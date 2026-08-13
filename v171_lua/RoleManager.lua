require("GamePlay/Role/Role")
require("GamePlay/Role/Monster")
require("GamePlay/Role/NPC")
require("GamePlay/Role/Player")
require("GamePlay/Role/Me")
require("GamePlay/Role/Pet")
require("GamePlay/Role/Head/RoleHead3DMesh")
require("GamePlay/Role/Head/PlayerHead")
require("GamePlay/Role/Head/PlayerHead3DMesh")
require("GamePlay/Role/Head/MeHead3DMesh")
require("GamePlay/Role/Head/MonsterHead3DMesh")
require("GamePlay/Role/Head/NpcHead3DMesh")
require("GamePlay/Role/RoleTouch/RoleTouch")
require("GamePlay/Role/RoleEquipOutEffect")
require("GamePlay/Role/RoleEquip")
require("GamePlay/Role/NpcTaskTag")
require("GamePlay/Role/RevealPlayer")
require("GamePlay/Role/ViewRole")
require("GamePlay/Role/ShopRole")
RoleManager = {
  me
}
local this = RoleManager
local roles = {}

function RoleManager.Init()
  this.InitRolesRootGo()
  this.TouchInit()
end

function RoleManager.InitRolesRootGo()
  this.root = CS.UnityEngine.GameObject("RoleManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
  this.damageRoot = CS.UnityEngine.GameObject("DamageRoot").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.damageRoot)
end

function RoleManager.OnEnterGame()
  this.RegistEvents()
end

function RoleManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyRoles()
end

function RoleManager.Update()
  if roles then
    for _, v in pairs(roles) do
      if v then
        v:Update()
      end
    end
  end
end

function RoleManager.InitMe(me)
  if roles[me.id] then
    return
  end
  this.me = me
  this.me:UpdateInfo()
  roles[me.id] = me
  CS.Framework.SceneArea.AddObject(this.me.transform)
  this.me.gameObject:AddComponent(typeof(CS.GpuGrass.GpuGrassPlayer))
  SkillData.CreateCareerSkillInfos()
  EventManager.Dispatch(Event.Role_OnMeCreated, me)
end

function RoleManager.CreateMonster(monsterData)
  if roles[monsterData.id] then
    return
  end
  local role = Monster(monsterData)
  if role.master and role.master ~= 0 and role.master == RoleManager.me.id then
    RoleManager.me.summonMonster = role
  end
  roles[monsterData.id] = role
  AudioManager.PlayMusicClipById(AudioUtility.GetMonsterAudioSound("bornSound", monsterData.model))
  EventManager.Dispatch(Event.Role_OnRoleCreated, role)
  return roles[monsterData.id]
end

function RoleManager.CreatePlayer(playerData)
  if roles[playerData.id] then
    return
  end
  if RedFortData.InRedFortActivity then
    playerData.model, playerData.modelScale = ERoleModelName.default, PlayerModelDefaultScale
  else
    playerData.model, playerData.modelScale = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[playerData.id], playerData.equipsData.Data)
  end
  local role = Player(playerData)
  roles[role.id] = role
  role:UpdateInfo()
  EventManager.Dispatch(Event.Role_OnRoleCreated, role)
  if UIManager.IsVisible("Instance_GoalUI") then
    EventManager.Dispatch(Event.CallBack_UpdateMemberInfo)
  end
  GameSettingsController.SetPlayerEnterViewHide(role)
  return roles[role.id]
end

function RoleManager.CreateNpc(npcData)
  if roles[npcData.id] then
    return
  end
  local npc = NPC(npcData)
  roles[npc.id] = npc
  EventManager.Dispatch(Event.Role_OnRoleCreated, npc)
  return npc
end

function RoleManager.CancelClickNpc()
  local npc = RoleManager.GetRoleListByType(ERoleType.NPC)
  for k, v in pairs(npc.list) do
    if not RoleManager.me then
      return
    end
    local MeTargetAvatar = RoleManager.me.TargetAvatar
    if MeTargetAvatar and MeTargetAvatar.RoleType == ERoleType.NPC and MeTargetAvatar.data.id == v.data.id then
      if v.model and v.model.modelObject then
        CS.Framework.MaterialChange.DisAttachOutLine(v.model.modelObject)
      end
      RoleManager.me:SetTargetAvatar(nil)
      EventManager.Dispatch(Event.CloseNpcPanel, v.data.config_Npc)
    end
  end
end

function RoleManager.RoleOnArrive()
  local npc = RoleManager.GetRoleListByType(ERoleType.NPC)
  local openNpcList = {}
  local closeNpcList = {}
  for k, v in pairs(npc.list) do
    local distance = Vector2.DistancePow(v.cellPos, RoleManager.me.cellPos)
    if distance <= 4 then
      if v.data ~= nil and v.data.config_Npc ~= nil and (v.data.config_Npc.specialNPC == 2 or v.data.config_Npc.specialNPC == 3 or v.data.config_Npc.specialNPC == SpaceCrackMapData.SpecialNPC or v.data.config_Npc.specialNPC == SpaceCrackMapData.TransferNPC) then
        goto lbl_95
      end
      table.insert(openNpcList, v)
    end
    if 9 <= distance and (v.data == nil or v.data.config_Npc == nil or v.data.config_Npc.specialNPC ~= 2 and v.data.config_Npc.specialNPC ~= 3 and v.data.config_Npc.specialNPC ~= SpaceCrackMapData.SpecialNPC and v.data.config_Npc.specialNPC ~= SpaceCrackMapData.TransferNPC) then
      table.insert(closeNpcList, v)
    end
    ::lbl_95::
  end
  EventManager.Dispatch(Event.ProcessCollectionAndRob, npc.list)
  EventManager.Dispatch(Event.OpenNpcInteractionPanel, openNpcList)
  EventManager.Dispatch(Event.CloseNpcInteractionPanel, closeNpcList)
end

function RoleManager.GetNpcByConfigId(configId)
  for k, v in pairs(roles) do
    if v and v.RoleType == ERoleType.NPC and not v.isMe and v.data.config_Npc and v.data.config_Npc.npcId == tonumber(configId) then
      return v
    end
  end
  return nil
end

function RoleManager.LateUpdate()
  if roles then
    for _, v in pairs(roles) do
      if v then
        v:LateUpdate()
      end
    end
  end
end

function RoleManager.DestroyRole(id)
  local role = roles[id]
  if role then
    if this.me.TargetAvatar ~= nil and this.me.TargetAvatar.id == role.id then
      this.me:SetTarget(nil)
    end
    if role.master and role.master ~= 0 and role.master == RoleManager.me.id then
      RoleManager.me.summonMonster = nil
    end
    if role.RoleType == ERoleType.Monster then
      local monsterConfig = ClientTable.cfg_Monster_monsterManager:TryGetValue(role.configId, "id")
      if monsterConfig.reliveType ~= MonsterReliveType.Immediately then
        role:Destroy()
      elseif 0 <= role.hp then
        role:Destroy()
      end
    else
      role:Destroy()
    end
  end
  roles[id] = nil
end

function RoleManager.DestroyRolesInReconnectState()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  for k, v in pairs(roles) do
    if v and not v.isMe then
      this.DestroyRole(v.id)
    end
  end
end

function RoleManager.DestroyOtherRoles()
  for k, v in pairs(roles) do
    if v and not v.isMe then
      this.DestroyRole(v.id)
    end
  end
end

function RoleManager.DestroyRoles()
  for k, v in pairs(roles) do
    v:OnCancelTouch()
    v:Destroy()
  end
  roles = {}
  this.me = nil
end

function RoleManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnRoleEnterView, this.OnRoleEnterView)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnRoleLeaveView)
  this.eventContainer:Regist(Event.Role_OnRefreshRoleData, this.OnRefreshRoleData)
  this.eventContainer:Regist(Event.Role_OnRoleServerPosChanged, this.OnRoleServerPosChanged)
  this.eventContainer:Regist(Event.Map_ChangeMap, this.OnChangeScene)
  this.eventContainer:Regist(Event.Role_RefreshHp, this.OnRoleHpChanged)
  this.eventContainer:Regist(Event.Role_RefreshMp, this.OnRoleMpChanged)
  this.eventContainer:Regist(Event.Role_RefreshShield, this.OnRoleShieldChanged)
  this.eventContainer:Regist(Event.Role_RefreshUniversalShield, this.OnRoleAngelShieldChanged)
  this.eventContainer:Regist(Event.Role_RefreshName, this.OnRoleNameChanged)
  this.eventContainer:Regist(Event.Task_StateChange, this.TaskStateChange)
  this.eventContainer:Regist(Event.Task_Update, this.TaskStateChange)
  this.eventContainer:Regist(Event.Role_MyLvChanged, this.MyLevelChanged)
  this.eventContainer:Regist(Event.Role_OnArrive, this.RoleOnArrive)
  this.eventContainer:Regist(Event.CancelClickNpc, this.CancelClickNpc)
  this.eventContainer:Regist(Event.Role_OnAuctionEnterView, this.OnAuctionEnterView)
  this.eventContainer:Regist(Event.TaLunTeBoxBuffChanged, this.OnTaLunTeBoxChangeCallBack)
  this.eventContainer:Regist(Event.RankBuffChanged, this.OnRankBuffChangeCallBack)
  this.eventContainer:Regist(Event.RefreshFourPartyRivalryCampFlagIcon, this.RefreshFourPartyRivalryCampFlagIcon)
end

function RoleManager.MyLevelChanged()
  if RoleManager.me then
    RoleManager.me:DisplayLevelUpEffect()
  end
end

function RoleManager.TaskStateChange()
  local npcList = {}
  npcList = RoleManager.GetRoleListByType(ERoleType.NPC)
  for k, v in pairs(npcList.list) do
    v:RefushTaskTag()
  end
end

function RoleManager.RefreshHeadColor()
  if roles then
    for _, role in pairs(roles) do
      if role then
        role:InitHeadUI()
      end
    end
  end
end

function RoleManager.RefreshHeadColorById(roleId)
  local role = this.GetRoleById(roleId)
  if role then
    role:InitHeadUI()
  end
end

function RoleManager.OnRoleEnterView(_, roleData)
  if not roleData then
    return
  end
  if roleData.roleType == ERoleType.Player then
    this.CreatePlayer(roleData)
  elseif roleData.roleType == ERoleType.NPC then
    this.CreateNpc(roleData)
  elseif roleData.roleType == ERoleType.Monster then
    this.CreateMonster(roleData)
  end
  BuffMgr.RoleEnterView(roleData.data.buff, roleData.id)
end

function RoleManager.OnAuctionEnterView(_, auctionData)
  if roles[auctionData.id] then
    return
  end
  local role = ShopRole(auctionData)
  roles[auctionData.id] = role
end

function RoleManager.OnRoleLeaveView(_, roleData)
  if not roleData then
    return
  end
  this.DestroyRole(roleData.id)
end

function RoleManager.OnRefreshRoleData(_, roleData)
  local role = this.GetRoleById(roleData.id)
  if role then
    role:RefreshRoleInfo(roleData)
  end
end

function RoleManager.OnRoleServerPosChanged(_, eventArgs)
  local role = roles[eventArgs.roleId]
  if not role then
    return
  end
  role:ChangePos(eventArgs.moveType, eventArgs.changePosReason, eventArgs.reasonParam, eventArgs.moveSpeed)
  EventManager.Dispatch(Event.Role_PlayerChangePos, eventArgs.roleId, eventArgs.changePosReason, eventArgs.reasonParam, eventArgs.moveSpeed)
end

function RoleManager.OnChangeScene(_, data)
  this.me:StopMove()
end

function RoleManager.OnRoleHpChanged(_, hpData)
  local role = this.GetRoleById(hpData.roleId)
  if role then
    if hpData.newValue then
      role.hp = hpData.newValue
    end
    role:RefreshHp()
  end
end

function RoleManager.OnRoleMpChanged(_, mpdata)
  local role = this.GetRoleById(mpdata.roleId)
  if role then
    role:RefreshMp()
  end
end

function RoleManager.OnRoleShieldChanged(_, ShieldData)
  local role = this.GetRoleById(ShieldData.roleId)
  if role then
    role:RefreshShield()
  end
end

function RoleManager.OnRoleAngelShieldChanged(_, data)
  local role = this.GetRoleById(data.rid)
  if role then
    role:RefreshAngelShield()
  end
end

function RoleManager.OnRoleNameChanged(_, role)
  local role = this.GetRoleById(role.roleId)
  if role then
    role:RefreshName(role.name, nil)
  end
end

function RoleManager.IsOverLimitPos(limitPosTab, pos)
  if pos.x > limitPosTab.minPosX and pos.x < limitPosTab.maxPosX and pos.y > limitPosTab.minPosY and pos.x < limitPosTab.maxPosY then
    return true
  end
  return false
end

function RoleManager.TouchInit()
  RoleTouch.Init()
end

function RoleManager.GetRoleMeOnLineTime()
  local currentLoginTime = Time.unscaledTime - this.me.data.roleLoginUnscaleTime
  return this.me.data.dailyOnlineTime + currentLoginTime * 1000
end

function RoleManager:OnTaLunTeBoxChangeCallBack(data)
  local role = this.GetRoleById(data.rid)
  if role then
    role:RefreshBox(data)
  end
end

function RoleManager:OnRankBuffChangeCallBack(data)
  local role = this.GetRoleById(data.rid)
  if role then
    role:RefreshRank(data)
  end
end

function RoleManager:RefreshFourPartyRivalryCampFlagIcon(data)
  local role = this.GetRoleById(data.rid)
  if role then
    role:RefreshFourPartyRivalryCampFlagIcon(data)
  end
end

function RoleManager.GetRoleById(roleId)
  return roles[roleId]
end

function RoleManager.HideHpBar(bShow)
  for i, v in pairs(roles) do
    if v and v.isMe and v.Head then
      v.Head:ShowHpHead(bShow)
    end
  end
end

function RoleManager.GetMonsterByMonsterType(typeList, range)
  local monsterList = {}
  for k, v in pairs(roles) do
    if v and v.RoleType == ERoleType.Monster and not v.isMe and v.hp > 0 then
      for l, t in pairs(typeList) do
        if v.monsterType == tonumber(t) then
          if range ~= nil and 0 < range then
            if PathFinderManager.pathFinding.IsReachPoint(v.cellPos, range) then
              table.insert(monsterList, v)
            end
          else
            table.insert(monsterList, v)
          end
        end
      end
    end
  end
  return monsterList
end

function RoleManager.GetMonsterByMonsterType2(monsterList, typeList, range)
  for k, v in pairs(roles) do
    if v and v.RoleType == ERoleType.Monster and not v.isMe and v.hp > 0 then
      for l, t in pairs(typeList) do
        if v.monsterType == tonumber(t) then
          if range ~= nil and 0 < range then
            if PathFinderManager.pathFinding.IsReachPoint(v.cellPos, range) then
              table.insert(monsterList, v)
            end
          else
            table.insert(monsterList, v)
          end
        end
      end
    end
  end
end

function RoleManager.GetMonsterRoleByConfigId(configIdList, range)
  local monsterList = {}
  for k, v in pairs(roles) do
    if v and v.RoleType == ERoleType.Monster and not v.isMe and v.hp > 0 then
      for l, t in pairs(configIdList) do
        if v:GetConfigId() == tonumber(t) then
          if range ~= nil and 0 < range then
            if PathFinderManager.pathFinding.IsReachPoint(v.cellPos, range) then
              table.insert(monsterList, v)
            end
          else
            table.insert(monsterList, v)
          end
        end
      end
    end
  end
  return monsterList
end

function RoleManager.GetRolesByUnionId(unionId, roleType)
  if unionId == nil or unionId == 0 then
    return {}
  end
  local result = {}
  for _, v in pairs(roles) do
    if not v.isMe and v.unionId == unionId and v.data.roleType == roleType then
      result[v.id] = v
    end
  end
  return result
end

function RoleManager.GetRoleByModel(modelObj)
  local objName = modelObj.name
  for k, v in pairs(roles) do
    if tostring(v.data.id) == objName then
      return v
    end
  end
end

function RoleManager.GetRoleListByType(roleType)
  local targetGroup = List:New()
  for _, v in pairs(roles) do
    if v and v.RoleType == roleType and not v.isMe then
      targetGroup:Add(v)
    end
  end
  return targetGroup
end

function RoleManager.GetRolesByType(roleType)
  local targetGroup = {}
  for _, v in pairs(roles) do
    if v and v.RoleType == roleType and not v.isMe then
      targetGroup[v.id] = v
    end
  end
  return targetGroup
end

function RoleManager.GetRolesByTypeAndRange(roleType, range)
  local targetGroup = List:New()
  for _, v in pairs(roles) do
    if v and v.RoleType == roleType and not v.isMe then
      local distance = Vector3.Distance(v.pos, RoleManager.me.pos)
      if range >= distance then
        targetGroup:Add(v)
      end
    end
  end
  return targetGroup
end

function RoleManager.GetRoleInCell(cell)
  local targetGroup = {}
  for _, v in pairs(roles) do
    if v and not v.isMe and v.cellPos.x == cell.x and v.cellPos.y == cell.y then
      table.insert(targetGroup, v)
    end
  end
  return targetGroup
end

function RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, range, callback)
  local cellPos = RoleManager.me.serverCoord
  local rolesTypeMap = {}
  if type(roleTypes) == "table" then
    for i, v in pairs(roleTypes) do
      rolesTypeMap[v] = true
    end
  else
    rolesTypeMap[roleTypes] = true
  end
  local targetGroup = {}
  local distance
  local meCell = cellPos
  for _, v in pairs(roles) do
    if v and rolesTypeMap[v.RoleType] and v.hp > 0 and not v.isMe and v:CanSelect() and not v.CloakingState and v:IsSameCamp() == false then
      if callback then
        if callback(v) then
          distance = Mathf.Max(Mathf.Abs(v.cellPos.x - meCell.x), Mathf.Abs(v.cellPos.y - meCell.y))
          if range >= distance and v.data.monsterType ~= 5004 then
            v.tempPathFindingDistance = distance
            table.insert(targetGroup, v)
          end
        end
      else
        distance = Mathf.Max(Mathf.Abs(v.cellPos.x - meCell.x), Mathf.Abs(v.cellPos.y - meCell.y))
        if range >= distance and v.data.monsterType ~= 5004 then
          v.tempPathFindingDistance = distance
          table.insert(targetGroup, v)
        end
      end
    end
  end
  return targetGroup
end

function RoleManager.GetRolesByTypeAndRangeAliveHook(roleTypes, hookPos, range, callback)
  local cellPos = RoleManager.me.serverCoord
  local rolesTypeMap = {}
  if type(roleTypes) == "table" then
    for i, v in pairs(roleTypes) do
      rolesTypeMap[v] = true
    end
  else
    rolesTypeMap[roleTypes] = true
  end
  local targetGroup = {}
  local distance
  local meCell = cellPos
  for _, v in pairs(roles) do
    if v and rolesTypeMap[v.RoleType] and v.hp > 0 and not v.isMe and v:CanSelect() then
      if callback then
        if callback(v) then
          distance = Mathf.Max(Mathf.Abs(v.cellPos.x - meCell.x), Mathf.Abs(v.cellPos.y - meCell.y))
          if range >= distance and Vector2.DistancePow(hookPos, v.cellPos) <= OnHookData.hookRange * OnHookData.hookRange then
            v.tempPathFindingDistance = distance
            table.insert(targetGroup, v)
          end
        end
      else
        distance = Mathf.Max(Mathf.Abs(v.cellPos.x - meCell.x), Mathf.Abs(v.cellPos.y - meCell.y))
        if range >= distance and Vector2.DistancePow(hookPos, v.cellPos) <= OnHookData.hookRange * OnHookData.hookRange then
          v.tempPathFindingDistance = distance
          table.insert(targetGroup, v)
        end
      end
    end
  end
  return targetGroup
end

function RoleManager.RefreshAllCell()
  for i, v in pairs(roles) do
    v:SetCell(v.cellPos.x, v.cellPos.y)
  end
end

RoleManager.Init()
