local PlayerAttributeData = {}
setmetatable(PlayerAttributeData, LuaClass.AttributeBaseData)
local this = PlayerAttributeData
local cdTable = {}
this.name = ""
this.career = 0
this.sex = 0
this.level = 0
this.maxHp = 0
this.maxMp = 0
this.unionId = 0
this.unionName = ""
this.unionPosition = 0
this.unionCamp = 0
this.PKmode = 0
this.evilLevel = 0
this.moveSpeed = 0
this.notoriety = 0
this.hangUpProtectionTime = 0
this.crossServerHangUpTime = 0
this.roleId = 0
this.serverId = 0
this.hostId = 0
this.teamId = 0
this.equipsData = nil
this.mountData = 0
this.titleData = 0
this.rideMount = 0
this.PetData = 0
this.WingData = 0
this.interactionStateChange = false
this.interactionState = false
this.roleType = 0
this.createTime = 0
this.exp = 0
this.validAttributePoint = 0
this.unionLevel = 0
this.AttributeTime = 0
this.freeReset = 0
this.rechargePoint = 0
this.dailyOnlineTime = 0
this.roleLogoutTime = 0
this.counts = 0
this.skills = {}
this.tasks = 0
this.chooseAttribute = {}
this.fruitAttribute = {}
this.roleLoginUnscaleTime = 0
this.roleLoginTime = 0
this.roleLoginFirstUnscaleTime = 0
this.careerConsumeRatio = 0
this.cdMap = {}

function PlayerAttributeData:Init()
end

function PlayerAttributeData:Refresh(data)
  self:RunBaseFunction("Refresh", data)
  self.name = data.info.name
  self.career = data.info.career
  self.sex = data.info.sex
  self.level = data.info.level
  self.maxHp = data.maxHp
  self.maxMp = data.maxMp
  self.unionId = data.info.unionId
  self.unionName = data.info.unionName
  self.unionPosition = data.info.unionPosition
  self.unionCamp = data.info.unionCamp
  self.PKMode = data.PKmode
  self.evilLevel = data.info.redLevel
  self.moveSpeed = data.moveSpeed
  self.notoriety = data.info.notoriety
  self.hangUpProtectionTime = data.hangUpProtectionTime
  self.crossServerHangUpTime = data.crossServerHangUpTime
  self.serverId = data.info.serverId
  self.hostId = data.info.hostId
  self.teamId = data.teamId
  self.mountData = MountData(self.id, data.equips)
  self:InitRideMount(self.mountData)
  self.titleData = RoleTitleData(data.equips)
  if self.interactionState ~= data.interactionState then
    self.interactionStateChange = true
  end
  self.interactionState = data.interactionState
  self.roleType = ERoleType.Player
end

function PlayerAttributeData:InitEquip(equips)
  if self.equipsData then
    self.equipsData:RefreshData(equips)
  else
    self.equipsData = RoleEquipData(equips)
  end
  self.equipsData:SetStoneLightData()
end

function PlayerAttributeData:InitRideMount(data)
  if data == nil then
    return
  end
  local mount
  for i = 1, #data.Mounts do
    if data.Mounts[i] ~= nil and data.Mounts[i].valid then
      mount = data.Mounts[i]
    end
  end
  self:SetRideMount(mount)
end

function PlayerAttributeData:UpdateRideMount(data)
  if data ~= nil and self.rideMount ~= nil and data.id == self.rideMount.id then
    return
  end
  self:SetRideMount(data)
  EventManager.Dispatch(Event.Mount_RideChange)
end

function PlayerAttributeData:SetRideMount(data)
  self.rideMount = data
end

function PlayerAttributeData:UpdateRideStatus(data)
  if data == nil then
    return
  end
  if self.rideMount and self.rideMount.id == data.id and not data.valid then
    self:UpdateRideMount(nil)
  end
  if data.valid then
    self:UpdateRideMount(data)
  end
end

function PlayerAttributeData:RefreshByTOOT(data)
  self:RunBaseFunction("RefreshByTOOT", data)
  self:RefreshBasicMapData(data)
end

function PlayerAttributeData:SetPkMode(PKMode)
  if PKMode ~= self.PKMode then
    self.PKMode = PKMode
    EventManager.Dispatch(Event.PKModeChanged)
  end
end

function PlayerAttributeData:InitConsumeRatio()
  local ratio = 0
  local consumeTbl = ClientTable.cfg_Global_globalManager:TryGetValue(2090001)
  consumeTbl = ParseUtility.ParseId(consumeTbl.effect)
  local basicCareer = RoleUtility.GetBasicCareer(self.career)
  if basicCareer == ERoleCareer.SwordMan then
    ratio = consumeTbl[1] * 1.0E-4
  elseif basicCareer == ERoleCareer.Magic then
    ratio = consumeTbl[2] * 1.0E-4
  elseif basicCareer == ERoleCareer.Archer then
    ratio = consumeTbl[3] * 1.0E-4
  end
  return ratio
end

function PlayerAttributeData:UpdateSkillDataStruct(allSkills)
  self.skills = {}
  local level = 1
  for i, v in pairs(allSkills) do
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if not self.skills[skillConfig.groupId] then
      self.skills[skillConfig.groupId] = v
    elseif self.skills[skillConfig.groupId].sid < v.sid then
      level = self.skills[skillConfig.groupId].level + 1
      v.level = level
      self.skills[skillConfig.groupId] = v
    end
  end
end

function PlayerAttributeData:InitCd(cdMap)
  for i, v in ipairs(cdMap) do
    cdTable = {}
    cdTable.key = v.key
    cdTable.endTime = v.endTime
    cdTable.type = v.type
    self:CreateCd(cdTable)
  end
end

function PlayerAttributeData:CreateCd(cd)
  if cd.type == CdEnum.SkillCommon then
    self.cdMap[cd.key] = CommonSkillCd(self, cd)
  elseif cd.type == CdEnum.Skill then
    local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(cd.key)
    cd.key = skillConfig.groupId
    if skillConfig.chargingTimes > 0 then
      self.cdMap[skillConfig.groupId] = ChargeSkillCd(self, cd)
    elseif skillConfig.cdTimeType and skillConfig.cdTimeType == ESkillCDType.Fix then
      self.cdMap[skillConfig.groupId] = FixSkillCd(self, cd)
    else
      self.cdMap[skillConfig.groupId] = NormalSkillCd(self, cd)
    end
  elseif cd.type == CdEnum.SKILL_GROUP then
  else
    self.cdMap[cd.key] = OthersCd(self, cd)
  end
end

function PlayerAttributeData:RefreshBy2003(data)
  if data.logAction == AddExpType.performTask or data.logAction == AddExpType.killMonster or data.logAction == AddExpType.paoDian or data.logAction == AddExpType.killminiMonster then
    self.exp = data.exp
  end
  EventManager.Dispatch(Event.Role_MyExpChanged, data)
  if data.logAction == AddExpType.killMonster or data.logAction == AddExpType.killminiMonster then
    local bossID = MonsterData.GetBossidInfo()
    if not bossID[data.monsterId] then
      ExpAddData.AddExp(data.addExp)
    end
  end
end

function PlayerAttributeData:RefreshBy2004(data)
  self.level = data.level
  self.validAttributePoint = data.attributePoint
  EventManager.Dispatch(Event.Role_MyLvChanged, data)
  EventManager.Dispatch(Event.Fuc_Refresh)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.showExp,
    state = true
  })
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.pBoss,
    state = true
  })
  EventManager.Dispatch(Event.PreferenceUI_ExchangeRefresh)
end

function PlayerAttributeData:RefreshBy2006(data)
  self.validAttributePoint = data.attributePoint
  self.chooseAttribute = data.chooseAttribute
  EventManager.Dispatch(Event.Role_MyAttributePointChanged, data)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function PlayerAttributeData:RefreshBy2012(data)
  self.career = data.career
end

function PlayerAttributeData:RefreshBy2040(data)
  self:RunBaseFunction("RefreshBasicData", data)
  self:RefreshBasicMapData(data)
end

function PlayerAttributeData:RefreshBasicMapData(data)
  self.createTime = data.basic.createTime
  self.name = data.basic.info.name
  self.career = data.basic.info.career
  self.level = data.basic.info.level
  self.sex = data.basic.info.sex
  self.exp = data.basic.exp
  self.serverId = data.basic.info.serverId
  self.validAttributePoint = data.basic.attributePoint
  self.unionId = data.basic.info.unionId
  self.unionName = data.basic.info.unionName
  self.unionLevel = data.basic.info.unionLevel
  self.unionCamp = data.basic.info.unionCamp
  self.unionPosition = data.basic.info.unionPosition
  self.AttributeTime = data.fruitInfo.resetCount
  self.freeReset = data.fruitInfo.freeReset
  self.rechargePoint = data.recharge.point
  self.dailyOnlineTime = data.basic.dailyOnlineTime
  self:SetPkMode(data.basic.PKMode)
  self:RefreshRoleLoginFirstUnscaleTime(data.basic.info.roleId)
  self.roleLoginUnscaleTime = Time.unscaledTime
  self.roleLoginTime = Time.GetServerSecondTime()
  self.roleLogoutTime = data.basic.logoutTime
  self.counts = data.counts.counts
  self.evilLevel = data.basic.info.redLevel
  self.notoriety = data.basic.info.notoriety
  self.careerConsumeRatio = self:InitConsumeRatio()
  self:UpdateSkillDataStruct(data.skills)
  self:InitCd(data.basic.cdMap)
  self.tasks = data.tasks.tasks.tasks
  self.chooseAttribute = data.basic.chooseAttribute
  self.fruitAttribute = data.fruitInfo.fruitAttribute
end

function PlayerAttributeData:RefreshRoleLoginFirstUnscaleTime(roleId)
  if self.roleId ~= roleId then
    self.roleId = roleId
    self.roleLoginFirstUnscaleTime = Time.unscaledTime
  end
end

function PlayerAttributeData:GetHasChooseAttr(type)
  if self.chooseAttribute == nil or self.chooseAttribute[type] == nil then
    return 0
  end
  return self.chooseAttribute[type]
end

function PlayerAttributeData:GetBaseCareer()
  return self.career % 10 + 10
end

function PlayerAttributeData:GetBaseCareerByValue(value)
  if not value then
    return nil
  end
  return value % 10 + 10
end

function PlayerAttributeData:GetRoleSingleOnLineTime()
  return math.floor((Time.unscaledTime - self.roleLoginFirstUnscaleTime) * 1000)
end

return PlayerAttributeData
