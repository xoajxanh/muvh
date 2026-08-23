require("GamePlay/Role/RoleMoveState/MeMoveContext")
require("GamePlay/Role/MeAutoFight")
Me = class(Player)
Me.isMe = true
Me.effectDisPlayTime = 0
local timerCol
setgetters(Me, {
  skills = function(self)
    return self.data.skills
  end,
  cd = function(self)
    return self.data.cdMap
  end,
  hasShield = function(self)
    return self.data.hasShield
  end,
  hp = function(self)
    return QuickFind.LuaMainPlayerViewAttrData().hp
  end,
  maxHp = function(self)
    return QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.maximumHealth)
  end,
  maxMp = function(self)
    return self.data:GetAttribute(EAttributeType.maximumMana)
  end,
  maxShield = function(self)
    return self.data:GetAttribute(EAttributeType.maximumShield)
  end,
  PKMode = function(self)
    return self.data.PKMode
  end
})

function Me:ctor(data)
  self:InitMeAutoFight()
  Player.ctor(self, data)
  self:InitSkillData(data)
  self:InitTaskData(data)
  self:InitRefreshData(data)
  self:InitAudio()
  self:InitWeather(self.transform)
  self:InitRecoverHpAndMp()
end

function Me:InitHeadUI()
  if self.gameObject and self.Head then
    self.Head:RefreshData(self)
    return
  end
  self.Head = MeHead3DMesh(self)
end

function Me:UpdateData(data)
  self.data = data
end

function Me:InitMeAutoFight()
  self.meAutoFight = MeAutoFight()
end

function Me:MainUICloseAutoFightStart()
  self.meAutoFight:MainUICloseAutoFightStart()
end

function Me:MainUIOpenAutoFightStart()
  EventManager.Dispatch(Event.Role_CheckSitState, self.cellPos)
  self.meAutoFight:MainUIOpenAutoFightStart()
end

function Me:MoveCloseAutoFight()
  self.meAutoFight:MoveCloseAutoFight()
end

function Me:StartPressSkillAutoFight()
  EventManager.Dispatch(Event.Role_CheckSitState, self.cellPos)
  self.meAutoFight:StartPressAutoFightStart()
end

function Me:SetAutoFight(autoStrKey)
  EventManager.Dispatch(Event.Role_CheckSitState, self.cellPos)
  self.meAutoFight:SetAutoFightStart(autoStrKey)
end

function Me:SetAutoTaskFight(autoStrKey)
  self.meAutoFight:SetAutoTaskFightStart(autoStrKey)
end

function Me:SetAutoHookFight(isOpen)
  self.meAutoFight:SetAutoFightHookStart(isOpen)
end

function Me:SetHookCardAutoFightHookStart(isOpen)
  self.meAutoFight:SetHookCardAutoFightHookStart(isOpen)
end

function Me:ReconnectCloseAutoFight()
  self.meAutoFight:ReconnectCloseAutoFight()
end

function Me:GetAutoFightState()
  return self.meAutoFight:GetAutoFightState()
end

function Me:ReStartAutoFight()
  return self.meAutoFight:ReStartAutoFight()
end

function Me:InitRecoverHpAndMp()
  local function IsMeHpLessSettingData()
    return self.hp ~= self.maxHp and self.hp / self.maxHp < QiJiHelperData.SettingData.recoverHp
  end
  
  local function IsMeMpLessSettingData()
    return self.mp ~= self.maxMp and self.mp / self.maxMp < QiJiHelperData.SettingData.recoverMp
  end
  
  local root = SelectorNode({
    IfNode(function()
      return IsMeHpLessSettingData()
    end, UseHpMedNode()),
    IfNode(function()
      return IsMeMpLessSettingData()
    end, UseMpMedNode())
  })
  self.autoUseHpOrMpMedBt = BehaviorTree(root, self)
  self.autoUseHpOrMpMedBt:Start()
end

function Me:StopAutoOperate()
  self:StopRecoverHpAndMp()
  self:StopAutoFight()
end

function Me:StopRecoverHpAndMp()
  self.autoUseHpOrMpMedBt:Cancel()
end

function Me:StopAutoFight()
  if self.meAutoFight then
    self.meAutoFight:SetAutoFightStart(AutoFightStrKey.None)
  end
end

function Me:InitRoleMoveContext()
  self.roleMoveContext = MeMoveContext(self)
end

function Me:InitAttribute(data)
  Player.InitAttribute(self, data)
  self.needWalkStep = GameInitData.needWalkStep
  self:ResetMountWalkStep()
end

function Me:InitCell()
  Player.InitCell(self)
  Scene.UpdateTileType(self.cellType)
  EventManager.Dispatch(Event.Role_OnArrive, self.cellPos)
end

function Me:SetCell(x, y)
  local oldCell = self.cellPos
  local oldCellType = self.cellType
  Player.SetCell(self, x, y)
  if self:IsMoveState() then
    self:RefreshNeedWalkStep()
  end
  if Scene.IsSafeZone(self.cellPos.x, self.cellPos.y) then
    self:SetAutoFight(AutoFightStrKey.None)
  end
  if oldCellType ~= self.cellType then
    Scene.UpdateTileType(self.cellType)
  end
  EventManager.Dispatch(Event.Role_OnMove, oldCell, self.cellPos)
  EventManager.Dispatch(Event.Role_OnArrive, self.cellPos)
end

function Me:RefreshMount()
  self.base.RefreshMount(self)
  if not self:IsStillState() and not self.model:IsMounting() then
    self:ResetMountWalkStep()
    self:SetMoving(self:GetMoveType())
  end
end

local posTemp = Vector3()

function Me:JoyStickMove(dir)
  dir = dir * self.tempMoveSpeed * self:SpeedSlowByDistance() * Time.deltaTime
  posTemp:Set(dir.x, 0, dir.y)
  self.pos = self.pos + posTemp
  self.transform:SetLocalPosition(self.pos.x, self.pos.y, self.pos.z)
end

function Me:ContinueAutoFight()
  if QiJiHelperData.openStartTime and Time.GetServerSecondTime() - QiJiHelperData.openStartTime > 10 and self.meAutoFight then
    self.meAutoFight:ReStartAutoFight()
  end
end

function Me:Update()
  Player.Update(self)
  self:UpdateTarget()
  if self.effectDisPlayTime > 0 then
    self.effectDisPlayTime = self.effectDisPlayTime - Time.deltaTime
    if self.effectDisPlayTime <= 0 then
      MainCamera.uac.renderPostProcessing = false
    end
  end
  self:ContinueAutoFight()
end

function Me:Destroy()
  EventManager.Dispatch(Event.Role_OnMeDestroy)
  AudioManager.AttachAudioListener(nil)
  self:DestroySceneEffect()
  self:DestroyLevelUpEffect()
  self:StopAutoOperate()
  self.WeatherAnchor = nil
  self.meAutoFight = nil
  Player.Destroy(self)
  if timerCol ~= nil then
    Timer.Stop(timerCol)
    timerCol = nil
  end
end

function Me:GetParent()
  return RoleManager.root
end

function Me:MoveTo(cell, stopRange, onEndMove)
  EventManager.Dispatch(Event.Role_CheckSitState, cell)
  local moveType = self:GetMoveType()
  self.guidePathIndex = 1
  self.targetStopRange = stopRange
  self.moveEndCell = cell
  local res = self.base.MoveTo(self, cell, stopRange, onEndMove, moveType)
  if self:IsStillState() then
    self.roleMoveContext:RefreshAutoFight()
  end
  return res
end

function Me:LineMoveTo(cell, joyStickLastCell)
  if cell.x == joyStickLastCell.x and cell.y == joyStickLastCell.y then
    return
  end
  if self:CanMove() and not Scene.IsBlock(cell) then
    if not Scene.TileCanMoveToByRole(cell) and SceneData.orThrough ~= 1 then
    else
      if joyStickLastCell.x == 0 and joyStickLastCell.y == 0 then
        joyStickLastCell:Set(self.cellPos.x, self.cellPos.y)
      end
      self.endDirection = cell - joyStickLastCell
      joyStickLastCell:Set(cell.x, cell.y)
      EventManager.Dispatch(Event.Role_CheckSitState, cell)
      self.movePath = {}
      self.pathIndex = 1
      self.base.LineMoveTo(self, cell, self:GetMoveType())
      local reqX = cell.x
      local reqY = cell.y
      self.data:SetServerPos(reqX, reqY)
      NetManager.Send(MapMessage.ReqMove, {
        x = reqX,
        y = reqY,
        action = self.RoleMoveType == ERoleMoveType.Run and 2 or 1,
        time = Time.GetServerTime()
      })
      if not IsNil(self.footPrintEffect) and not self.footPrintEffect.activeSelf then
        self.footPrintEffect:SetActive(true)
        self.footPrintEffect.transform:GetChild(1).gameObject:SetActive(false)
        local otherTime = 0.5 / self.moveSpeed
        Timer.Start(otherTime, self.OpenOtherFootPrint, self)
      end
    end
  elseif self:IsStillState() then
    self.roleMoveContext:RefreshAutoFight()
  end
end

function Me:CanMove()
  return (self.usingSkillId == nil or SkillUtility.IsComboSkill(self.usingSkillId)) and not self.isDead and not self.isStoppingMove and not self.buffCantMove
end

function Me:CanUseSkill()
  return (self.usingSkillId == nil or SkillUtility.IsComboSkill(self.usingSkillId)) and not self.data.roleBuffData:CheckState(RoleBuffState.SILENT)
end

local function ResearchTilePath(self)
  self.nextCell = nil
  local canArrive, path, bestGuidePath = Scene.SearchTilePath(self.cellPos, self.moveEndCell, self.targetStopRange, true)
  if canArrive and path and 1 < #path then
    self.movePath = path
    self.bestGuidePath = bestGuidePath
    self.pathIndex = 1
    self:MoveNext()
    return true
  end
  return false
end

local function RoleBlockCanCross(self)
  local dir = self.nextCell - self.cellPos
  dir = self.nextCell + dir
  local canArrive, path, bestGuidePath = Scene.SearchTilePath(self.cellPos, dir, 0, true)
  if not canArrive and not Scene.IsBlock(dir) then
    self.nextCell = dir
    self.targetPos = Scene.GetPosByCell(self.nextCell)
    if self.tempMoveType ~= ERoleMoveType.Stand and self.targetPos then
      self:LookAt(self.targetPos, true)
    end
    if self.nextCell ~= nil and self.cellPos ~= self.nextCell and self.serverCoord ~= self.nextCell then
      local reqX = self.nextCell.x
      local reqY = self.nextCell.y
      self.data:SetServerPos(reqX, reqY)
      NetManager.Send(MapMessage.ReqMove, {
        x = reqX,
        y = reqY,
        action = self.RoleMoveType == ERoleMoveType.Run and 2 or 1,
        time = Time.GetServerTime()
      })
      self:PathAmend()
    end
    return true
  end
  return false
end

local function CleanMoveData(self)
  self.movePath = {}
  self.targetPos = nil
  self.nextCell = nil
  self.isStoppingMove = false
end

local function PosIsRoles(cell, roleType)
  local npcTable = RoleManager.GetRolesByType(roleType)
  for k, v in pairs(npcTable) do
    if tonumber(cell.x) == tonumber(v.cellPos.x) and tonumber(cell.y) == tonumber(v.cellPos.y) then
      if roleType == ERoleType.Monster and v:StaticBlockMonster(v.data.configId) then
        return false
      end
      return true
    end
  end
  return false
end

local roundCells = {}
local calculatorCell = Vector2Int(0, 0)

local function GetPosByCellRolesAroundNpc(npcPos)
  if #roundCells < 1 then
    roundCells[1] = Vector2.right
    roundCells[2] = -Vector2.right
    roundCells[3] = Vector2.up
    roundCells[4] = -Vector2.up
    roundCells[5] = Vector2.one
    roundCells[6] = -Vector2.one
    roundCells[7] = Vector2.right - Vector2.up
    roundCells[8] = -Vector2.right + Vector2.up
  end
  local posVec = Vector2(npcPos.x, npcPos.y)
  local count = 100
  local index = 0
  for i = 1, #roundCells do
    local posItem = posVec + roundCells[i]
    calculatorCell:Set(math.floor(posItem.x), math.floor(posItem.y))
    if not Scene.IsBlock(calculatorCell) then
      local roles = Scene.GetTilesRoleInfor(calculatorCell)
      if count > roles then
        count = roles
        index = i
      end
    end
  end
  if 0 < index then
    posVec = posVec + roundCells[index]
    calculatorCell:Set(math.floor(posVec.x), math.floor(posVec.y))
    return calculatorCell
  else
    return index
  end
end

local function EndNpcPosPlayerPathAdjust(self)
  if (PosIsRoles(self.moveEndCell, ERoleType.NPC) or PosIsRoles(self.moveEndCell, ERoleType.Monster)) and Scene.GetTilesRoleInfor(self.nextCell) > 0 then
    local targetCell = GetPosByCellRolesAroundNpc(self.moveEndCell)
    if targetCell ~= 0 then
      local arrive, path = Scene.SearchTilePath(self.cellPos, targetCell)
      if path then
        self.movePath = path
        self.pathIndex = 2
        self.nextCell = self.movePath[self.pathIndex]
        self.navTargetCell = self.movePath[#self.movePath]
      end
    end
  end
end

function Me:MoveNext()
  self.pathIndex = self.pathIndex + 1
  if not self.movePath then
    self.nextCell = nil
  else
    self.nextCell = self.movePath[self.pathIndex]
  end
  if self.nextCell == nil then
    self.targetPos = nil
    self:OnArrive()
  elseif Scene.IsBlock(self.nextCell) then
    if ResearchTilePath(self) then
      return
    end
    CleanMoveData(self)
    self:OnArrive(ENavigateStatus.BlockBreak)
    return
  elseif not Scene.TileCanMoveToByRole(self.nextCell) and SceneData.orThrough ~= 1 then
    if SceneData.resName ~= 1012 and RoleBlockCanCross(self) then
      return
    end
    if self.nextCell == self.navTargetCell then
      if ResearchTilePath(self) then
        return
      end
      self.tempMoveType = ERoleMoveType.Stand
      CleanMoveData(self)
      self:OnArrive(ENavigateStatus.EndBlockBreak)
      return
    end
    if ResearchTilePath(self) then
      return
    end
    self.tempMoveType = ERoleMoveType.Stand
    CleanMoveData(self)
    self:OnArrive(ENavigateStatus.BlockBreak)
    return
  else
    if PosIsRoles(self.navTargetCell, ERoleType.NPC) then
      self.navTargetCell = self.movePath[#self.movePath - 1]
    end
    if self.nextCell == self.navTargetCell then
      EndNpcPosPlayerPathAdjust(self)
    end
    if self.footPrintEffect and not IsNil(self.footPrintEffect) and not self.footPrintEffect.activeSelf then
      self.footPrintEffect:SetActive(true)
      self.footPrintEffect.transform:GetChild(1).gameObject:SetActive(false)
      local otherTime = 0.5 / self.moveSpeed
      Timer.Start(otherTime, self.OpenOtherFootPrint, self)
    end
    self.targetPos = Scene.GetPosByCell(self.nextCell)
    if self.tempMoveType ~= ERoleMoveType.Stand and self.targetPos then
      self:LookAt(self.targetPos, true)
    end
  end
  if self.nextCell ~= nil and self.cellPos ~= self.nextCell and self.serverCoord ~= self.nextCell then
    local reqX = self.nextCell.x
    local reqY = self.nextCell.y
    self.data:SetServerPos(reqX, reqY)
    NetManager.Send(MapMessage.ReqMove, {
      x = reqX,
      y = reqY,
      action = self.RoleMoveType == ERoleMoveType.Run and 2 or 1,
      time = Time.GetServerTime()
    })
    self:PathAmend()
  end
end

local function AmendPathJoint(partPath, partEnd, oldPath)
  local endPoint = Vector2Int(partEnd.x, partEnd.y)
  local partCount = #partPath
  local insert = false
  for i = 1, #oldPath do
    if oldPath[i] == endPoint then
      insert = true
    end
    if insert then
      partCount = partCount + 1
      partPath[partCount] = oldPath[i]
    end
  end
end

function Me:PathAmend()
  if self.nextCell ~= self.navTargetCell and self.bestGuidePath then
    local currentGui = Scene.tileData:GetGuidePointByTile(self.nextCell.x, self.nextCell.y)
    if self.currentGuiPoint ~= currentGui then
      self.currentGuiPoint = currentGui
      local guidePointIndex = 0
      for i = 1, #self.bestGuidePath do
        local pathPoint = Scene.tileData:GetGuidePoint(self.bestGuidePath[i].x, self.bestGuidePath[i].y)
        if pathPoint == currentGui and i > self.guidePathIndex then
          guidePointIndex = i
          self.guidePathIndex = i
        end
      end
      if 0 < guidePointIndex then
        if guidePointIndex + 3 < #self.bestGuidePath then
          local partEnd = self.bestGuidePath[guidePointIndex + 3]
          partEnd = Scene.tileData:GetGuidePoint(partEnd.x, partEnd.y)
          local reachable, path, bestGuidePath = Scene.SearchTilePath(self.nextCell, Vector2Int(partEnd.x, partEnd.y), 1)
          if not bestGuidePath and path then
            AmendPathJoint(path, partEnd, self.movePath)
            self.movePath = path
            EventManager.Dispatch(Event.Map_PathChange, path)
            self.pathIndex = 1
          else
          end
        else
          if not self.navTargetCell then
            return
          end
          local reachable, path, bestGuidePath = Scene.SearchTilePath(self.nextCell, self.navTargetCell)
          self.movePath = path
          EventManager.Dispatch(Event.Map_PathChange, path)
          self.pathIndex = 1
          if not bestGuidePath then
            self.bestGuidePath = nil
          end
        end
      end
    end
  end
end

function Me:RefreshNeedWalkStep()
  if not self:IsCurSafeZone() then
    if self.model:IsMounting() then
      if self.mountNeedWalkStep and self.mountNeedWalkStep > 0 then
        self.mountNeedWalkStep = self.mountNeedWalkStep - 1
      end
    elseif self.needWalkStep and 0 < self.needWalkStep then
      self.needWalkStep = self.needWalkStep - 1
    end
    self:UpdateMoveType()
  end
end

function Me:UpdateMoveType()
  self:SetMoving(self:GetMoveType())
end

function Me:SpeedSlowByDistance()
  return 1
end

function Me:SetPosition(x, y, z)
  self.base.SetPosition(self, x, y, z)
  EventManager.Dispatch(Event.Role_OnMePosChanged, self.pos)
end

function Me:StopMoveImmediate()
  self.base.StopMoveImmediate(self)
  self.needWalkStep = GameInitData.needWalkStep
  self.mountNeedWalkStep = self.mountStep
end

function Me:CancelMove()
  self:StopMoveImmediate()
  NetManager.Send(MapMessage.ReqMove, {
    x = self.cellPos.x,
    y = self.cellPos.y,
    action = self.RoleMoveType == ERoleMoveType.Run and 2 or 1,
    time = Time.GetServerTime()
  })
end

local function TileCantStand(self)
  local dir
  if self.movePath[self.pathIndex - 2] then
    dir = self.cellPos - self.movePath[self.pathIndex - 2]
  else
    dir = self.endDirection
  end
  dir = dir or Vector2(0, 1)
  dir = self.cellPos + dir
  self.isStoppingMove = false
  if not Scene.IsBlock(dir) then
    Main_JoyStickUI:ResetCurrentCell(dir)
    self:MoveTo(dir, self.targetStopRange, self.onEndMove)
    return true
  else
    return false
  end
end

function Me:OnArrive(arriveType)
  if not Main_JoyStickUI.movingWithJoyStick then
    if SceneData.orThrough == 1 and not Scene.TileCanMoveToByRole(self.cellPos) and TileCantStand(self) then
      return
    end
    self:SetMoving(ERoleMoveType.Stand)
    self.needWalkStep = GameInitData.needWalkStep
    self.mountNeedWalkStep = self.mountStep
  else
    self:SetMoving(ERoleMoveType.Stand)
  end
  if self.isStoppingMove then
    self.isStoppingMove = false
  end
  if self.onStop ~= nil then
    self.onStop()
    self.onStop = nil
  end
  if self.onEndMove then
    local navStatus = self.cellPos == self.navTargetCell and ENavigateStatus.Arrived or ENavigateStatus.Interrupted
    if arriveType then
      navStatus = arriveType
    end
    self.onEndMove(navStatus)
    self.onEndMove = nil
  end
  EventManager.Dispatch(Event.Role_OnArrive, self.cellPos)
end

function Me:IsMoving()
  return self.RoleMoveType and not self:IsStillState() or false
end

local DebugTool = CS.DebugTool.DebugTool

function Me:ProcessMoveInput(layerName, hitX, hitY, hitZ)
  if DebugTool.isOpen then
    return
  end
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
  if UIManager.IsVisible(UIID.MapDetailUI) then
    Main_MapDetailUI:ClearPath()
  end
  if layerName ~= "Ground" then
    return
  end
  if Main_JoyStickUI.movingWithJoyStick then
    return
  end
  AutoTaskManage.SetCurRoleOperate(AutoTaskOperateType.MouseClick)
  self:MoveTo(Scene.GetCellByPos(Vector3(hitX, hitY, hitZ)), nil, function()
  end)
  EventManager.Dispatch(Event.CloseKillMonsterCard)
end

function Me:GetMoveType()
  local moveType
  if self.model:IsMounting() then
    moveType = self.mountNeedWalkStep <= 0 and ERoleMoveType.Run or ERoleMoveType.Walk
  elseif self.data.equipsData:GetEquipByIndex(ERoleEquipPosition.wing) then
    moveType = ERoleMoveType.Run
  else
    moveType = self:CanRunOrFastSwim() and ERoleMoveType.Run or ERoleMoveType.Walk
  end
  return moveType
end

function Me:IsSpeedLimited()
  return self:IsCurSafeZone(self.cellPos) or self.model:IsMounting() and self.mountNeedWalkStep > 0 or not self.model:IsMounting() and 0 < self.needWalkStep and not self.data.equipsData:GetEquipByIndex(ERoleEquipPosition.wing)
end

local function MoveBuffRunLogic()
  local meBuffs = BuffData.GetBuffs(ViewData.meData.id)
  for _, buff_struct in pairs(meBuffs) do
    if buff_struct.buffConfig.subType == 117 then
      return false
    end
  end
  return true
end

local function MoveBuffSpeedLogic()
  local meBuffs = BuffData.GetBuffs(ViewData.meData.id)
  for _, buff_struct in pairs(meBuffs) do
    if buff_struct.buffConfig.subType == 117 or buff_struct.buffConfig.subType == 102 then
      return false
    end
  end
  return true
end

function Me:CanRun()
  return not Scene.IsSwimZone(self.cellPos) or false
end

function Me:CanFastSwim()
  return Scene.IsSwimZone(self.cellPos) and self.data.equipsData:GetEquipByIndex(ERoleEquipPosition.glove) or false
end

function Me:CanRunOrFastSwim()
  if not MoveBuffRunLogic() then
    return true
  end
  return self:CanRun() or self:CanFastSwim() or false
end

function Me:GetMoveSpeed()
  local moveSpeed = self.data:GetAttribute(EAttributeType.moveSpeed) * 0.01
  return moveSpeed
end

function Me:GetMoveSpeedByAttribute()
  return self.data:GetAttribute(EAttributeType.moveSpeed) * 0.01
end

function Me:GetModelScale()
  return self.data.modelScale and self.data.modelScale or 0.35
end

function Me:GetName()
  return self.data.name
end

function Me:SetTarget(avatar)
  if avatar and avatar.RoleType == ERoleType.LuoLanDefense then
    return
  end
  if avatar ~= nil and avatar.isMe then
    return
  end
  if avatar ~= nil and self.TargetAvatar ~= nil and avatar.id == self.TargetAvatar.id then
    if avatar.data.career and avatar.RoleType ~= ERoleType.Shop then
      RoleInteractData.PlayerLookShowUI(avatar, RoleOpenType.NearTouch)
    end
    return
  end
  if avatar ~= nil and avatar.data.campId ~= nil and avatar.data.campId ~= 0 and self.data.campId ~= nil and self.data.campId ~= 0 and avatar.data.campId == self.data.campId then
    return
  end
  if avatar ~= nil and avatar.data.configData and avatar.data.configData.type == 5004 then
    return
  end
  EventManager.Dispatch(Event.CancelClickNpc)
  self.oldTargetAvatar = self.TargetAvatar
  if self.oldTargetAvatar then
    self.oldTargetAvatar:OnCancelTouch()
  end
  if avatar then
    avatar:OnTouch()
  end
end

function Me:SetTargetAvatar(avatar)
  self.TargetAvatar = avatar
end

function Me:UpdateTarget()
  if self.TargetAvatar ~= nil and self.TargetAvatar.RoleType ~= ERoleType.NPC and self.TargetAvatar.RoleType ~= ERoleType.Shop and (Vector2Int.DistancePow(self.serverCoord, self.TargetAvatar.serverCoord) > 64 or self.TargetAvatar:IsCurSafeZone()) then
    self:CloseTarget()
  end
end

function Me:CloseTarget()
  local target = self.TargetAvatar
  if not target then
    return
  end
  target:OnCancelTouch()
  self:SetTargetAvatar(nil)
  ThreeVsThreeUtility.SetChooseEnemyLid(nil, true)
end

function Me:ChangePos(moveType, changeReason, reasonParam)
  if changeReason == ERoleChangePosReason.Scene_Interactive then
    return
  end
  Scene.RemoveTileType(self.cellPos, SceneTileType.Block)
  if self.nextCell then
    Scene.RemoveTileType(self.nextCell, SceneTileType.Block)
  end
  if changeReason == ERoleChangePosReason.Transport or changeReason == ERoleChangePosReason.Revive or changeReason == ERoleChangePosReason.RandomTransport or changeReason == ERoleChangePosReason.CoerceTransport then
    self:FlashTo(self.serverCoord.x, self.serverCoord.y)
    self:PlayTransportEffect()
    self:SetMoving(moveType)
    if self.RolePet then
      self.RolePet:SetPosition()
    end
    EventManager.Dispatch(Event.Scene_SmallBossShow, true)
    if not IsNil(self.footPrintEffect) then
      self.footPrintEffect:SetActive(false)
    end
  elseif changeReason == ERoleChangePosReason.MoveFailed then
    local logEndMove = self.onEndMove
    local next = self.nextCell
    self:FlashTo(self.serverCoord.x, self.serverCoord.y)
    if self:CanMove() and next then
      self:MoveTo(self.moveEndCell, self.targetStopRange, logEndMove)
    end
  else
    self.base.ChangePos(self, moveType, changeReason, reasonParam)
    if not IsNil(self.footPrintEffect) then
      self.footPrintEffect:SetActive(false)
    end
  end
end

function Me:InitSkillData(data)
  if data.skills ~= nil then
    SkillData.SaveSkillInfos(data.skills)
  end
end

function Me:InitAudio()
  AudioManager.AttachAudioListener(self.transform, Vector3(0, 1.6, 0))
end

function Me:InitWeather(parent)
  self.WeatherAnchor = CS.UnityEngine.GameObject("WeatherAnchor").transform
  self.WeatherAnchor:SetParent(parent, false)
end

function Me:ShowBubbleEffect(isShow)
  if isShow then
    self:InitShowSceneEffect()
  else
    self:DestroySceneEffect()
  end
end

function Me:ShowLookEnemyCircleEffect(color)
  self:InitShowCircleEffect(color)
end

function Me:DisplayLevelUpEffect()
  MainCamera.uac.renderPostProcessing = true
  if self.levelUpEffect then
    self.levelUpEffect:SetModelActive(false)
    self.levelUpEffect:SetModelActive(true)
  else
    local effectData = {
      modelType = EEffectModelType.Scene,
      model = "Eff_Scene_shengji"
    }
    self.levelUpEffect = EffectModel(self.model.BuffAnchor, "Hi\225\187\135u \225\187\169ng l\195\170n c\225\186\165p", effectData)
    self.levelUpEffect:Init()
    self.levelUpEffect:SetLayer(ROLE_LAYER)
    self.levelUpEffect:SetModel(1)
  end
  self.effectDisPlayTime = 3
end

function Me:InitShowSceneEffect(isShow)
  if not self.bubbleEffect then
    self.bubbleEffect = CS.Framework.GameModel("SceneEffect", self.model.BuffAnchor, function(go, name)
      self:OnLoadBubbleEffect(go, name)
    end)
    self.bubbleEffect:LoadAsync("Effect/Scene/renwu_qipao.prefab")
  end
end

function Me:InitShowCircleEffect(color)
  if not self.circleEffect then
    self.circleEffect = {}
  end
  if self.preCircleColor then
    self.circleEffect[self.preCircleColor]:SetActive(false)
  end
  if not self.circleEffect[color] then
    self.circleEffect[color] = LookEnemyCircleEffect(color)
  else
    self.circleEffect[color]:SetActive(true)
  end
  self.preCircleColor = color
end

function Me:OnLoadBubbleEffect(go, name)
  self.bubbleObject = go
  if self.bubbleObject then
    local bubbleTransform = self.bubbleObject.transform
    bubbleTransform:SetParent(self.bubbleEffect.transform, false)
    bubbleTransform:SetLocalPosition(0, 1, 0)
    bubbleTransform:SetLocalRotation(0, 0, 0, 1)
    self.bubbleObject:SetActive(true)
  end
end

function Me:DestroySceneEffect()
  if self.bubbleEffect then
    self.bubbleEffect:Destroy()
    self.bubbleEffect = nil
    self.bubbleObject = nil
  end
  if self.circleEffect then
    for i, v in pairs(self.circleEffect) do
      v:Destroy()
    end
    self.circleEffect = {}
    self.preCircleColor = nil
  end
end

function Me:DestroyLevelUpEffect()
  if self.levelUpEffect then
    self.levelUpEffect:Destroy()
    self.levelUpEffect = nil
  end
end

function Me:InitTaskData(data)
  if data.tasks ~= nil and table.count(data.tasks) > 0 then
    TaskData.UpdatePlayerTasks(data.tasks)
  end
end

function Me:InitRefreshData(data)
  if data.counts ~= nil then
    RefreshData.InitRefreshes(data.counts)
    RefreshController.GenerateSchedule()
  end
end

function Me:SetNeedWalkStep(step)
end

function Me:ResetWalkStep()
  if self.needWalkStep then
    self.needWalkStep = GameInitData.needWalkStep
  end
end

function Me:ResetMountWalkStep()
  self.mountNeedWalkStep = 0
  self.mountStep = 0
  if not self.data.rideMount then
    return
  end
  local riderData = ClientTable.cfg_Item_mountManager:TryGetValue(self.data.rideMount.itemId, "id")
  if riderData ~= nil then
    self.mountNeedWalkStep = tonumber(riderData.stepNumber)
    self.mountStep = self.mountNeedWalkStep
  end
end

function Me:LoginMap()
  self:FlashTo(self.serverCoord.x, self.serverCoord.y)
  if self.RolePet then
    self.RolePet.data.x = self.serverCoord.x
    self.RolePet.data.y = self.serverCoord.y
    self.RolePet:Reset()
  end
  self:SetMoving(ERoleMoveType.Stand)
  self:PlayTransportEffect()
  self.AvatarEquip:ChangeWeaponByCell(self.cellType)
end

function Me:PlayTransportEffect()
  Effect("Effect/Scene/chuansong.prefab", nil, RoleManager.me.pos, 1, self.OnLoadChangeMapEffect)
end

function Me.OnLoadChangeMapEffect(go)
  go:SetActive(true)
end

function Me:RoleDead()
  PlayerSoundManager.PlayDieSound(self.data.career)
  self:StopAutoFight()
  if BuffUtility.HasBuff(BuffEnum.Revive) then
    return
  end
  Player.RoleDead(self)
  if timerCol ~= nil then
    Timer.Stop(timerCol)
    timerCol = nil
  end
  if not UIManager.IsVisible(UIID.Role_ResurgenceUI) then
    timerCol = Timer.StartLoop(3, 1, function()
      if LoginData.InGame then
        UIManager.UICloseType(UIPanelType.SortAndHide, true)
        UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Role_ResurgenceUI)
      end
    end)
  end
  EventManager.Dispatch(Event.Me_Dead)
  EventManager.Dispatch(Event.CanNotCollectBox)
end

function Me:FlyShoeTransfer(pos)
  self:FlashTo(pos.x, pos.y)
  NetManager.Send(MapMessage.ReqMove, {
    x = pos.x,
    y = pos.y,
    action = ERoleMoveType.Stand,
    time = Time.GetServerTime()
  })
  PathFinderController.pathFinding.OnArriveTarget()
end

function Me:SetPlayerDeadAnimator()
end

local healthEffecObjPool = {}
local manaEffecObjPool = {}

local function LoadOtherSuitEffect(pool, name, initPos)
  local modelPath = string.format("Effect/Skill/%s.prefab", name)
  local loadReq = CS.Framework.ResourceManager.InstantiateAsync(modelPath, SkillMgr.ROOT, false)
  Coroutine.Yield(loadReq)
  if not loadReq or loadReq.isError then
    Coroutine.Break()
  end
  loadReq = loadReq.gameObject
  local lerpMove = loadReq:AddComponent(typeof(CS.Framework.MoveToPlayer))
  if lerpMove then
    lerpMove.targetTrans = RoleManager.me.model.transform
  end
  local renders = loadReq:GetComponentsInChildren(typeof(UnityEngineLua.Renderer))
  for i = 0, renders.Length - 1 do
    renders[i].gameObject.layer = 0
  end
  loadReq:SetActive(true)
  loadReq.transform.position = initPos
  table.insert(pool, loadReq)
end

local function InitKillEffactPlay(pool, effectName, initPos)
  local EffectObj
  for i = 1, #pool do
    if not pool[i].activeSelf then
      EffectObj = pool[i]
      break
    end
  end
  if not EffectObj then
    Coroutine.Start(LoadOtherSuitEffect, pool, effectName, initPos)
    return
  end
  EffectObj.transform.position = initPos
  EffectObj:SetActive(true)
end

function Me:KillMonsterRecoverEffect(recoverType, monsterPos)
  local EffecName, ObjPool
  if recoverType == 1 then
    EffecName = "Eff_jingyanqiu_02lan"
    ObjPool = manaEffecObjPool
  else
    EffecName = "Eff_jingyanqiu_hong"
    ObjPool = healthEffecObjPool
  end
  InitKillEffactPlay(ObjPool, EffecName, monsterPos)
end

function Me:InitEffect()
end

function Me:EnableKillMonsterEffect(enable)
  if self.killMonsterEffect then
    self.killMonsterEffect:SetModelActive(false)
    self.killMonsterEffect:SetModelActive(enable)
  else
    if not enable then
      return
    end
    local effectData = {
      modelType = EEffectModelType.Skill,
      model = "Eff_PK_mianyi"
    }
    self.killMonsterEffect = EffectModel(self.model.BuffAnchor, "Hi\225\187\135u \225\187\169ng treo m\195\161y qu\195\161i th\198\176\225\187\157ng", effectData)
    self.killMonsterEffect:Init()
    self.killMonsterEffect:SetLayer(ROLE_LAYER)
    self.killMonsterEffect:SetModel(1)
  end
end

function Me:SetUsingSkill(skillId)
  self.usingSkillId = skillId
  if not self.usingSkillId and self.meAutoFight and self.meAutoFight:IsAutoFightOpen() and QiJiHelperData.isAutoFight then
    QiJiHelperData.SetOpenStartTime(Time.GetServerSecondTime())
  end
end

function Me:SetMoving(moveType)
  Player.SetMoving(self, moveType)
  if self:IsStillState() then
    if self.meAutoFight and self.meAutoFight:IsAutoFightOpen() and QiJiHelperData.isAutoFight then
      QiJiHelperData.SetOpenStartTime(Time.GetServerSecondTime())
    end
  else
    QiJiHelperData.SetOpenStartTime()
  end
end

function Me:CheckReturnLoadReinEffect()
  return false
end

function Me:SetMainPlayerPosition(time, vector3)
  if type(time) ~= "number" then
    return
  end
  EventManager.Dispatch(Event.Logic_ActiveMainUI, false)
  Main_JoyStickUI.holdingJoyStick = true
  Timer.Start(time, self.BackGameArea, self)
end

function Me:BackGameArea()
  EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
  Main_JoyStickUI.holdingJoyStick = false
end
