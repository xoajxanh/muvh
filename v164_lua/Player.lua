Player = class(Role)
setgetters(Player, {
  career = function(self)
    return self.data.career
  end,
  level = function(self)
    return self.data.level
  end,
  mp = function(self)
    return self.data.mp
  end,
  shield = function(self)
    return self.data.shield
  end,
  maxShield = function(self)
    return self.data.maxShield
  end,
  hasShield = function(self)
    return self.data.hasShield
  end,
  unionId = function(self)
    return self.data.unionId
  end,
  op_unionId = function(self)
    return self.data.op_unionId
  end,
  enemyUnionList = function(self)
    return self.data.enemyUnionList
  end,
  equipsData = function(self)
    return self.data.equipsData
  end,
  mountData = function(self)
    return self.data.mountData
  end,
  titleData = function(self)
    return self.data.titleData
  end,
  PKMode = function(self)
    return self.data.PKMode
  end,
  unionPosition = function(self)
    return self.data.unionPosition
  end,
  evilLevel = function(self)
    return self.data.evilLevel
  end,
  notoriety = function(self)
    return self.data.notoriety
  end,
  hangUpProtectionTime = function(self)
    return self.data.hangUpProtectionTime
  end,
  crossServerHangUpTime = function(self)
    return self.data.crossServerHangUpTime
  end,
  serverId = function(self)
    return self.data.serverId
  end,
  unionCamp = function(self)
    return self.data.unionCamp
  end,
  hostId = function(self)
    return self.data.hostId
  end
})

function Player:InitQuality()
  self.graphicType = GameGraphicModelType.Player
  self.graphicQuality = GameGraphicData.GetQualityLevel(isMe, self.graphicType)
  GameGraphicData.AddCount(self.graphicType, self.graphicQuality)
end

function Player:InitAttribute(data)
  self.playerEquipType = ERoleModelNameType[data.model]
  Role.InitAttribute(self, data)
  self:InitRoleEquip(self.data)
  self:InitHolyRingInfo(data.holyRingInfo)
  self.dynamicBlock = true
end

function Player:Update()
  self:PlayerStandStateNotify()
  Role.Update(self)
  if self.RolePet then
    self.RolePet:Update()
  end
  if self.data.equipsData then
    local equipData = self.data.equipsData:GetEquipByIndex(ERoleEquipPosition.pet)
    if equipData then
      equipData:CalcEquipTime(Time.unscaledDeltaTime)
    end
  end
end

function Player:PlayerStandStateNotify()
  if not self.moveNotify then
    self.moveNotify = self:IsMoveState()
  end
  if self.moveNotify ~= self:IsMoveState() and self:IsMoveState() == false then
    EventManager.Dispatch(Event.RoleStandNoticeEff, {
      lid = self:GetRoleInfo().id,
      action = ERoleMoveType.Stand
    })
    self.moveNotify = self:IsMoveState()
  end
end

function Player:InitPet()
  if self.data.PetData then
    self.RolePet = Pet(self.data.PetData, self)
  end
end

function Player:SetPetDisplay(display)
  if self.RolePet then
    self.RolePet:SetModelDisplay(display)
  end
end

function Player:SetModelDisplay(isShowModel)
  if self.isShowModel == isShowModel then
    return
  end
  self.isShowModel = isShowModel
  if not self.model then
    return
  end
  self.model:SetModelActive(isShowModel)
  self:SetModelActiveHandle(isShowModel)
  if self.selectState and self.model and not IsNil(self.model.modelObject) then
    for i = 0, self.model.modelObject.transform.childCount - 1 do
      local tansItem = self.model.modelObject.transform:GetChild(i)
      if tansItem.name ~= "Shadow01" then
        CS.Framework.MaterialChange.AttachOutLine(tansItem.gameObject, Color(1, 0.3203125, 0.2851562, 1.0), 0.03, 3000, "FGQJ/Role/OutLine2")
      end
    end
  end
  if not isShowModel then
    self:RecycleBuffEffect()
  else
    self:RecycleBuffEffect()
    local roleBuffs = BuffData.GetBuffs(self.id)
    for k, v in pairs(roleBuffs) do
      BuffMgr.LoadBuffEffect(v)
    end
  end
end

function Player:RefreshRoleInfo(data)
  Role.RefreshRoleInfo(self, data)
  if SceneData.mapId == 1019001 then
    if self.data.model ~= ERoleModelName.default then
      self:ChangeModel(ERoleModelName.default, PlayerModelDefaultScale)
      return
    end
  else
    local model, modelScale = RoleEquipUtility.GetCurPlayerModelName(ForgeData.appearData[self.data.id], self.data.equipsData.Data, self:GetModelScale())
    if self.data.model ~= model then
      self:ChangeModel(model, modelScale)
      return
    end
  end
  self:SetSkinnedMesh()
  self:RefreshMount()
  if data and self.data.interactionStateChange then
    if data.interactionState == 0 then
      local cellPos = Scene.GetPosByCell(data)
      self:SetPosition(cellPos.x, cellPos.y, cellPos.z)
    else
      self:SetSceneInteractiveState(data)
    end
    self.data.interactionStateChange = false
  end
  self:InitEffect()
end

function Player:InitModel()
  Role.InitModel(self)
  self:RefreshMount()
end

function Player:GetName()
  return TranScriptData.GetInDuplicateNameStr() or self.data.name
end

function Player:GetUnionName()
  if TranScriptData:IsHideUnionName() then
    return ""
  end
  return self.data.unionName
end

function Player:OnLoadRoleModelComplete(go, name)
  if name then
    return
  end
  self.model.animator:SetMountPrefix()
  self:InitRoleBondMountpoints()
  self:SetSkinnedMesh()
  self:SetArmbandMesh()
  self:UpdateAnimator(go)
  self:UpdateBoxCollider(go)
  self:AddFalseBuffEffect()
  self:AddLevelReinEffect()
end

function Player:UpdateAnimator(go)
  local runtimeController
  self.loadAnimatorCoroutine = Coroutine.Start(function()
    local animatorRequest, animResName
    if self.playerEquipType == ERoleInitEquipType.snowMan then
      animResName = string.format("Animator/AniCtr_%s.controller", ERoleAnimatorResName[self.data.model])
    else
      animResName = string.format("Animator/AniCtr_%s.controller", table.getKey(ERoleCareer, RoleUtility.GetBasicCareer(self.career)))
    end
    animatorRequest = CS.Framework.ResourceManager.LoadAssetAsync(animResName, typeof(CS.UnityEngine.RuntimeAnimatorController))
    Coroutine.Yield(animatorRequest)
    if animatorRequest.isError then
      logError(animatorRequest.error)
      Coroutine.Break()
    end
    runtimeController = animatorRequest.res
    self.animatorControl = go:GetComponent(typeof(CS.UnityEngine.Animator))
    if self.animatorControl then
      self.animatorControl.runtimeAnimatorController = runtimeController
    end
    if self.model ~= nil then
      if self.model.animator then
        self.model:SetForceUpdate()
      else
        logWarning("animator is nil")
      end
    end
    self:RefreshAnimation()
    self:SetSceneInteractiveState(self.data)
    self:SetPlayerDeadAnimator()
  end)
  if runtimeController then
  end
end

function Player:SetSceneInteractiveState(data)
  if not data.interactionState or data.interactionState == 0 then
    return
  end
  if data.interactionState == 1 then
    Scene.SetRoleLeanOnState({
      x = data.x,
      y = data.y
    }, self)
  elseif data.interactionState == 2 then
    Scene.SetRoleSitState({
      x = data.x,
      y = data.y
    }, self)
  elseif data.interactionState == 3 then
    Scene.SetRoleFlyUpState({
      x = data.x,
      y = data.y
    }, self)
  end
end

function Player:UpdateBoxCollider(go)
  self.boxCollider = go:GetComponent(typeof(CS.UnityEngine.BoxCollider))
  if self.data.boxColliderSize then
    self.boxCollider.size = self.data.boxColliderSize
  else
    self.boxCollider.size = Vector3(1, 3, 1)
  end
end

function Player:UpdateInfo()
end

function Player:GetParent()
  local this = Player
  if not this.playerAnchor then
    this.playerAnchor = CS.UnityEngine.GameObject("PlayerRoot").transform
    this.playerAnchor:SetParent(RoleManager.root, false)
  end
  return this.playerAnchor
end

function Player:GetModelScale()
  return self.data.modelScale and self.data.modelScale or 0.35
end

function Player:InitRoleEquip(data)
  if not self.AvatarEquip then
    self.AvatarEquip = RoleEquip(self)
  end
end

function Player:FindRoleRightHand(isRightHand)
  return self.model:FindRoleRightHand(isRightHand)
end

function Player:Destroy()
  Role.DestroySkill(self)
  self:DestroyEffect()
  self:RecycleBuffEffect()
  self:DestroyEquip()
  self:DestroyPet()
  Role.Destroy(self)
  self:DestroyData()
end

function Player:DestroyData()
  if self.data then
    self.data:Destroy()
  end
end

function Player:RecycleBuffEffect()
  local buffEffectNode = self:GetModelNode("BuffspineParent")
  if IsNil(buffEffectNode) then
    return
  end
  for i = buffEffectNode.childCount - 1, 0, -1 do
    local child = buffEffectNode:GetChild(i)
    child:SetParent(SkillMgr.ROOT)
    child.gameObject:SetActive(false)
  end
end

function Player:RefreshMount()
  local isSet = true
  if self:IsCurSafeZone(self.cellPos) then
    if self.data.rideMount then
      if self.data.rideMount.cityride == 1 then
        if self.playerEquipType == ERoleInitEquipType.snowMan then
          self:SetMount(nil)
          isSet = false
          return
        else
          self:SetMount(self.data.rideMount.model)
        end
      else
        isSet = false
        self:SetMount(nil)
      end
    else
      isSet = false
      self:SetMount(nil)
    end
  elseif self.data.rideMount then
    if self.hp <= 0 then
      isSet = false
      self:SetMount(nil)
    elseif self.data.interactionState and 0 < self.data.interactionState then
      isSet = false
      self:SetMount(nil)
    elseif self.playerEquipType == ERoleInitEquipType.snowMan then
      self:SetMount(nil)
      isSet = false
      return
    else
      self:SetMount(self.data.rideMount.model)
    end
  else
    isSet = false
    self:SetMount(nil)
  end
  if isSet and not GameSettingsController.ShouldShowModel(self) then
    self:SetMount(nil)
  end
  if self:IsNowMapNotHorse() == false then
    self:SetMount(nil)
  end
  if not IsNil(self.gameObject) and self.Head then
    self.Head:RefreshData(self)
    return
  end
end

function Player:IsNowMapNotHorse()
  local mapTable = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  if mapTable ~= nil then
    if mapTable.mountType == 1 then
      return false
    elseif mapTable.mountType == 2 and self.data.rideMount ~= nil then
      return ClientTable.cfg_Map_mapManager:IsNowMapChangeHorseState(mapTable, self.data.rideMount.itemId)
    end
  end
  return true
end

function Player:DestroyEquip()
  if self.AvatarEquip then
    self.AvatarEquip:Destroy()
    self.AvatarEquip = nil
  end
end

function Player:DestroyPet()
  if self.RolePet then
    self.RolePet:Destroy()
    self.RolePet = nil
  end
end

function Player:DestroyModel()
  if self.loadAnimatorCoroutine then
    Coroutine.Stop(self.loadAnimatorCoroutine)
  end
  Role.DestroyModel(self)
  if self.HitFlickerTimer then
    Timer.Stop(self.HitFlickerTimer)
  end
end

function Player:SetModelActiveHandle(isShow)
  if not isShow then
    self:RefreshMount()
    self.AvatarEquip:Destroy()
  else
    self:RefreshRoleInfo()
  end
end

function Player:SetCell(x, y)
  local oldCellType = self.cellType
  Role.SetCell(self, x, y)
  if oldCellType ~= self.cellType then
    if self.AvatarEquip then
      self.AvatarEquip:ChangeWeaponByCell()
    end
    self:RefreshMount()
    if self.RolePet then
      self.RolePet:SetPosition()
      self.RolePet:Reset()
    end
  end
end

function Player:SetMoving(moveType)
  moveType = Scene.IsSwimZone(self.cellPos) and (moveType == ERoleMoveType.Run and ERoleMoveType.FastSwim or moveType == ERoleMoveType.Walk and ERoleMoveType.Swim or moveType == ERoleMoveType.Stand and ERoleMoveType.SwimIdle) or moveType
  Role.SetMoving(self, moveType)
end

function Player:MoveStateChanged()
  if not self:IsCurSafeZone(self.cellPos) then
    self.AvatarEquip:SetWeaponParent(self:IsSwimState())
  end
  Role.MoveStateChanged(self)
end

function Player:IsStillState()
  return self.RoleMoveType == ERoleMoveType.Stand or self.RoleMoveType == ERoleMoveType.SwimIdle
end

function Player:IsSwimState()
  return self.RoleMoveType == ERoleMoveType.Swim or self.RoleMoveType == ERoleMoveType.FastSwim
end

function Player:IsMoveState()
  return self.RoleMoveType == ERoleMoveType.Walk or self.RoleMoveType == ERoleMoveType.Run or self.RoleMoveType == ERoleMoveType.Swim or self.RoleMoveType == ERoleMoveType.FastSwim
end

function Player:GetMoveSpeed()
  local moveSpeed = self.data:GetAttribute(EAttributeType.moveSpeed) * 0.01
  if not self.data.moveSpeedByBuff and (self.RoleMoveType ~= ERoleMoveType.Run and self.RoleMoveType ~= ERoleMoveType.FastSwim or not moveSpeed) then
    moveSpeed = GameInitData.personWalkSpeed
  end
  return moveSpeed
end

function Player:SetInitDynamicBlock()
  self.dynamicBlock = false
  if self.dynamicBlock and not Scene.IsSafeZone(self.cellPos.x, self.cellPos.y) then
    Scene.AddTileType(self.cellPos, SceneTileType.Block)
  end
end

function Player:SetCellDynamicBlock(x, y)
  if self.dynamicBlock then
    if self.cellPos then
      Scene.RemoveTileType(self.cellPos, SceneTileType.Block)
    end
    if not Scene.IsSafeZone(x, y) then
      Scene.AddTileType({x = x, y = y}, SceneTileType.Block)
    end
  end
end

function Player:ChangeTileTypeOnMove()
  if self.dynamicBlock then
    if self.cellPos then
      Scene.RemoveTileType(self.cellPos, SceneTileType.Block)
    end
    if not Scene.IsSafeZone(self.nextCell.x, self.nextCell.y) then
      Scene.AddTileType(self.nextCell, SceneTileType.Block)
    end
  end
end

function Player:SetSkinnedMesh(isNeedRefreshSuitEffect)
  if not self.model.modelObject then
    return
  end
  self:UpdateEquipData(isNeedRefreshSuitEffect)
  self:InitMeshMaterial()
end

function Player:UpdateEquipData(isNeedRefreshSuitEffect)
  if not self.AvatarEquip or not self.isShowModel then
    return
  end
  if SceneData.mapId == 1019001 then
    self.AvatarEquip:InitEquipInRedFort()
  else
    self.AvatarEquip:InitData()
    self.AvatarEquip:InitEquip(isNeedRefreshSuitEffect)
  end
  self.AvatarEquip:ChangeWeaponByCell()
end

function Player:UnloadEquip(position, removeData)
  if not self.AvatarEquip or not self.isShowModel then
    return
  end
  if SceneData.mapId == 1019001 then
  else
    self.AvatarEquip:UnloadEquip(position, removeData)
    self.AvatarEquip:DestroyZhaoHuanWuQITouEff(position)
    self.AvatarEquip:CheckAndLoadCapeDisplay()
  end
end

function Player:PutOnEquip(bagGridIndex, modelPath)
  if not self.AvatarEquip or not self.isShowModel then
    return
  end
  if SceneData.mapId == 1019001 then
  else
    self.AvatarEquip:PutOnEquip(bagGridIndex, modelPath)
    self.AvatarEquip:CheckAndLoadCapeDisplay()
  end
end

function Player:SetArmbandMesh()
  if LoginData.InGame then
    local meData = ViewData.meData
    WarAllianceData.UpdateData()
    if self.data.id ~= meData.id then
      return
    end
    if WarAllianceData.IsHaveUnion then
      WarAllianceData:CreatArmband(self.AvatarEquip)
    else
      WarAllianceData:RemoveArmband(self.AvatarEquip)
    end
  end
end

function Player:InitRoleBondMountpoints()
  if not self.model.modelObject.activeInHierarchy then
    return
  end
  self.roleBondData = self.model.modelObject:GetComponent(typeof(CS.RoleBondData))
  self.RoleWeaponRightParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleWeaponRightParent)
  self.RoleWeaponLeftParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleWeaponLeftParent)
  self.RoleShieldLFingerParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleShieldLFingerParent)
  self.RoleWeaponLSpineParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleWeaponLSpineParent)
  self.RoleWeaponRSpineParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleWeaponRSpineParent)
  self.RoleWingSpineParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleWingSpineParent)
  self.RoleShieldspineParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleShieldspineParent)
  self.RolePetSpineParent = self:GetBoneTransform(RoleEquipConstantConfig.RolePetSpineParent)
  self.BuffSpineParent = self:GetBoneTransform(RoleEquipConstantConfig.BuffSpineParent)
  self.BodyspineParent = self:GetBoneTransform(RoleEquipConstantConfig.BodyspineParent)
  self.RoleArmbandParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleArmbandParent)
  self.RoleCloakParent = self:GetBoneTransform(RoleEquipConstantConfig.RoleCloakParent)
  self.RoleAvatarRoot = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarRoot)
  self.RoleAvatarHead = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarHead)
  self.RoleAvatarSpine1 = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarSpine1)
  self.RoleAvatarLeftUpperArm = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarLeftUpperArm)
  self.RoleAvatarRightUpperArm = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarRightUpperArm)
  self.RoleAvatarLeftCalf = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarLeftCalf)
  self.RoleAvatarRightCalf = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarRightCalf)
  self.RoleAvatarLeftForearm = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarLeftForearm)
  self.RoleAvatarRightForearm = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarRightForearm)
  self.RoleAvatarLeftFoot = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarLeftCalf)
  self.RoleAvatarRightFoot = self:GetBoneTransform(RoleEquipConstantConfig.RoleAvatarRightCalf)
  self.AvatarEquip:InitWeaponParent()
  self.AvatarEquip:InitOutEffectParent()
end

function Player:GetBoneTransform(boneName)
  local nameId = StringPool.ToID(boneName)
  return self.roleBondData:GetBondByName(nameId)
end

function Player:InitHeadUI()
  if self.gameObject and self.Head then
    self.Head:RefreshData(self)
    return
  end
  self.Head = PlayerHead3DMesh(self)
end

function Player:SetPlayerDeadAnimator()
  if self.hp <= 0 then
    self:PlayDeadAnimatorFinallyFrame()
  end
end

function Player:PlayDeadAnimatorFinallyFrame()
  self.model:PlayInstantAnimation("dead", 1, 2)
end

function Player:RoleDead()
  Role.RoleDead(self)
  self:RefreshMount()
  self:PlayDeadAnimator()
  self:RecycleBuffEffect()
end

function Player:PlayDeadAnimator()
  self.model:PlayAnimation("dead")
end

function Player:SpeedSlowByDistance()
  return self.movePath and #self.movePath > 4 and 1.1 or #self.movePath > 2 and 1 or 0.8
end

function Player:OnTouch()
  self.selectState = true
  if not self:IsCurSafeZone() and self.model and not IsNil(self.model.modelObject) then
    for i = 0, self.model.modelObject.transform.childCount - 1 do
      local tansItem = self.model.modelObject.transform:GetChild(i)
      if tansItem.name ~= "Shadow01" then
        CS.Framework.MaterialChange.AttachOutLine(tansItem.gameObject, Color(1, 0.3203125, 0.2851562, 1.0), 0.03, 3000, "FGQJ/Role/OutLine2")
      end
    end
  end
  RoleManager.me:SetTargetAvatar(self)
  RoleInteractData.PlayerLookShowUI(self, RoleOpenType.NearTouch)
  Role.OnTouch(self)
end

function Player:OnCancelTouch()
  RoleInteractData.PlayerLookHideUI(self)
  if RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.id == self.id then
    if self.model and not IsNil(self.model.modelObject) then
      for i = 0, self.model.modelObject.transform.childCount - 1 do
        local tansItem = self.model.modelObject.transform:GetChild(i)
        if tansItem.name ~= "Shadow01" then
          CS.Framework.MaterialChange.DisAttachOutLine(tansItem.gameObject)
        end
      end
    end
    self.selectState = false
    RoleManager.me:SetTargetAvatar(nil)
  end
  Role.OnCancelTouch(self)
end

local function HurtEffect(self)
  if not self.model then
    return
  end
  if not self.model.modelObject then
    return
  end
  local smrs = self.model.modelObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  local effectMats = {}
  for i = 0, smrs.Length - 1 do
    local mats = smrs[i].materials
    for j = 0, mats.Length - 1 do
      local matItem = mats[j]
      if matItem:HasProperty("_HitColorLerpRate") then
        table.insert(effectMats, matItem)
      end
    end
  end
  local lerpRate = 0
  local changeValue = 0.04000000000000001
  self.HitFlickerTimer = Timer.StartLoop(0.02, 10, function()
    if 0.2 <= lerpRate then
      changeValue = -changeValue
    end
    lerpRate = lerpRate + changeValue
    lerpRate = lerpRate < 0 and 0 or lerpRate
    for i = 1, #effectMats do
      effectMats[i]:SetFloat("_HitColorLerpRate", lerpRate)
    end
  end)
end

function Player:HurtMaterialEffect(attackerId)
  self.attackerId = attackerId
  if attackerId == ViewData.meData.id then
    HurtEffect(self)
  end
end

function Player:InitEffect()
  if false then
    self:EnableKillMonsterEffect(self.crossServerHangUpTime and self.crossServerHangUpTime > 0 or false)
  else
    self:EnableKillMonsterEffect(self.hangUpProtectionTime and 0 < self.hangUpProtectionTime or false)
  end
end

function Player:GetProtectTIme()
  if false then
    return self.crossServerHangUpTime
  else
    return self.hangUpProtectionTime
  end
end

function Player:EnableKillMonsterEffect(enable)
  if self.killMonsterEffect then
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

function Player:DestroyEffect()
  if self.killMonsterEffect then
    self.killMonsterEffect:Destroy()
  end
  Role.DestroyEffect(self)
end

local function ChangeModeLoadBuffEffect(self)
  local buffs = BuffData.GetBuffs(self.id)
  for k, v in pairs(buffs) do
    if v.buffAction and v.buffAction.prefabs and #v.buffAction.prefabs > 0 then
      for i = 1, #v.buffAction.prefabs do
        BuffEffectMgr.AddEffect(v, v.buffAction.prefabs[i])
      end
    end
  end
end

function Player:ChangeModel(model, scale)
  self:DestroyEquip()
  local desModel = table.DeepCopy(self.data.model)
  local desModelType = table.DeepCopy(self.data.modelType)
  self.data.model = model
  self.data.modelScale = scale
  self:InitAttribute(self.data)
  if self.model then
    self.model:ChangeRoleModel(desModel, self.data, desModelType)
  else
    self:InitModel()
  end
  self:RefreshMount()
  ChangeModeLoadBuffEffect(self)
end

function Player:ArchangelSkillChange(isStart)
  local model, modelScale
  if isStart then
    model, modelScale = ERoleModelName.datianshibianshen, PlayerModelDefaultScale
  elseif self:IsInRedFortActivity() then
    model, modelScale = ERoleModelName.default, PlayerModelDefaultScale
  else
    model, modelScale = RoleEquipUtility.GetCurPlayerModelName(self.data.appearData, self.data.equipsData.Data, self:GetModelScale())
  end
  if self.data.model ~= model then
    self:ChangeModel(model, modelScale)
  end
end

function Player:IsArchangeActive(buffid)
  local dic = ClientTable.cfg_Global_globalManager:GetGlobal_DaTianShiBianshenBuffIDDic()
  if dic then
    if buffid ~= nil then
      return dic[buffid]
    else
      for i, v in pairs(dic) do
        if BuffData.IsHasBuff(self.id, i) then
          return true
        end
      end
    end
  end
  return false
end

function Player:IsInRedFortActivity()
  return RedFortData.InRedFortActivity and self.data.realPlayer
end

function Player:RefreshBox(data)
  if self.Head then
    self.Head:RefreshBoxView(data)
  end
end

function Player:RefreshRank(data)
  if self.Head then
    self.Head:RefreshRankView(data)
  end
end

function Player:RefreshFourPartyRivalryCampFlagIcon(data)
  if self.Head then
    self.Head:RefreshFourPartyRivalryCampFlagIcon(data)
  end
end

function Player:InitHolyRingInfo(holyRingInfo)
  if holyRingInfo and table.count(holyRingInfo) > 0 then
    self.holyRingTbl = holyRingInfo
    table.sort(self.holyRingTbl, function(a, b)
      if a.point and b.point then
        return a.point < b.point
      end
    end)
  end
end
