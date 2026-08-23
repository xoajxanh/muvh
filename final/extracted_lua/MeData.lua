require("GameModel/Role/PlayerData")
require("GameModel/Role/Cd/Cd")
MeData = class(PlayerData)

function MeData:Init(data)
  self:InitMapData(data)
  self:InitBasicInfo(data)
  self:InitRefresh(data.counts)
  self:InitEquip(data.equips, data.stoneLight)
  self:InitAttribute(data)
  self.roleType = ERoleType.Player
  self.realPlayer = true
end

function MeData:Refresh(data)
  self:InitBasicInfo(data)
  self:InitRefresh(data.counts)
  self:InitEquip(data.equips, data.stoneLight)
  self:InitAttribute(data)
end

function MeData:InitMapData(data)
  self.hp = data.map.hp
  self.mp = data.map.mp
  self.shield = data.map.shield or 0
end

function MeData:InitBasicInfo(data)
  self.roleBasicAttributePointMap = {}
  self.attributeMap = {}
  self.SerattributeMap = {}
  self.attributeAddPoint = {}
  self.cdMap = {}
  self.id = data.basic.info.roleId
  self.serverCoord = self.serverCoord or Vector2Int()
  self.serverDir8 = self.serverDir8 or Direction8.Down
  self.createTime = data.basic.createTime
  self.name = data.basic.info.name
  self.career = data.basic.info.career
  self:SetLevel(data.basic.info.level)
  self.reincarnationLevel = data.basic.reincarnationLevel
  self.sex = data.basic.info.sex
  self.exp = data.basic.exp
  self.serverId = data.basic.info.serverId
  self.validAttributePoint = data.basic.attributePoint
  self.stoneLight = data.basic.stoneLight
  self.hasShield = data.basic.info.hasShield
  self.unionLogo = data.basic.info.unionLogo
  self.unionId = data.basic.info.unionId
  self.unionName = data.basic.info.unionName
  self.unionLevel = data.basic.info.unionLevel
  self.unionCamp = data.basic.info.unionCamp
  self.badgeLevel = self.unionId > 0 and data.basic.info.badgeLevel or 0
  self.badgeLevel = self.unionLevel < self.badgeLevel and self.unionLevel or self.badgeLevel
  self.unionPosition = data.basic.info.unionPosition
  self.enemyUnionList = data.basic.info.enemyUnionList
  self.AttributeTime = data.fruitInfo.resetCount
  self.freeReset = data.fruitInfo.freeReset
  self.rechargePoint = data.recharge.point
  self.dailyOnlineTime = data.basic.dailyOnlineTime
  self:SetPkMode(data.basic.PKMode)
  self.roleLoginUnscaleTime = Time.unscaledTime
  self.roleLoginTime = Time.GetServerSecondTime()
  self.roleLogoutTime = data.basic.logoutTime
  self.counts = data.counts.counts
  self.evilLevel = data.basic.info.redLevel
  self.notoriety = data.basic.info.notoriety
  self.careerConsumeRatio = self:InitConsumeRatio()
  self.roleBuffData = RoleBuffData()
  self.allSkills = data.skills
  self:UpdateSkillDataStruct()
  self:InitCd(data.basic.cdMap)
  self:UpdateTasks(data.tasks.tasks.tasks)
  self.model = "1003"
end

function MeData:GetReinLv()
  if type(self.level) ~= "number" then
    return 0
  end
  local levelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(self.level)
  return levelTbl.reincarnationLevel
end

function MeData:SetPkMode(PKMode)
  if PKMode ~= self.PKMode then
    self.PKMode = PKMode
    EventManager.Dispatch(Event.PKModeChanged)
  end
end

function MeData:SetCampId(campId)
  self.campId = campId
end

function MeData:InitConsumeRatio()
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

function MeData:UpdateTasks(tasks)
  self.tasks = tasks
end

function MeData:CreateCd(cd)
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

function MeData:InitCd(cdMap)
  for i, v in ipairs(cdMap) do
    local cdData = {
      key = v.key,
      endTime = v.endTime,
      type = v.type
    }
    self:CreateCd(cdData)
  end
end

function MeData:UpdateCd(cdMsg)
  self:UpdateOthersCd(cdMsg)
end

function MeData:UpdateCommonCd(endTime)
  if not self.cdMap[1] then
    local cdData = {
      key = 1,
      type = CdEnum.SkillCommon
    }
    self:CreateCd(cdData)
  end
  self.cdMap[1]:UpdateCd(endTime)
end

function MeData:UpdateOthersCd(cdMsg)
  if cdMsg.type == CdEnum.Skill or cdMsg.type == CdEnum.SkillCommon then
    return
  end
  if cdMsg.type == CdEnum.REDUCE_CD then
    if not self.cdMap[cdMsg.key] then
      return
    end
    self.cdMap[cdMsg.key]:ReduceCd(cdMsg.endTime)
    EventManager.Dispatch(Event.UpdateSkillCd)
  else
    if not self.cdMap[cdMsg.key] then
      local cdData = {
        key = cdMsg.key,
        type = cdMsg.type
      }
      self:CreateCd(cdData)
    end
    self.cdMap[cdMsg.key]:UpdateCd(cdMsg.endTime)
  end
end

function MeData:UpdateClientSkillCd(skillId)
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if not self.cdMap[skillConfig.groupId] then
    local cdData = {
      key = skillId,
      type = CdEnum.Skill
    }
    self:CreateCd(cdData)
  end
  self.cdMap[skillConfig.groupId]:UpdateCd()
end

function MeData:SpecialChangeClientSkillCd(skillId, endTime)
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if not self.cdMap[skillConfig.groupId] then
    local cdData = {
      key = skillId,
      type = CdEnum.Skill
    }
    self:CreateCd(cdData)
  end
  self.cdMap[skillConfig.groupId]:SetEndTime(endTime)
end

function MeData:UpdateClientItemCd(itemId)
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
  local clientCd = itemConfig.clientCD
  if clientCd == 0 then
    return
  end
  local cd = itemConfig.useCd
  local curTime = Time.GetServerTime()
  if not self.cdMap[itemConfig.useCdGroup] then
    local cdData = {
      key = itemConfig.useCdGroup,
      type = CdEnum.ItemUse
    }
    self:CreateCd(cdData)
  end
  self.cdMap[itemConfig.useCdGroup]:UpdateCd(cd + curTime)
end

function MeData:UpdateSkillDataStruct()
  self.skills = {}
  local level = 1
  for i, v in pairs(self.allSkills) do
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

function MeData:HasSkill(skillId)
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  return self.skills[skillConfig.groupId] ~= nil
end

function MeData:AddSkillData(skillData)
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillData.sid)
  local learnSkill = self.skills[skillConfig.groupId]
  table.insert(self.allSkills, skillData)
  if learnSkill and learnSkill.sid > skillData.sid then
    return
  end
  self.skills[skillConfig.groupId] = skillData
  EventManager.Dispatch(Event.Skill_ResLearnSkill, skillData.sid)
end

function MeData:RemoveSkillData(skillId)
  local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  for i = 1, #self.allSkills do
    if self.allSkills[i].sid == skillId then
      table.remove(self.allSkills, i)
      break
    end
  end
  local learnSkill = self.skills[skillConfig.groupId]
  if learnSkill and skillId < learnSkill.sid then
    return
  end
  self.skills[skillConfig.groupId] = nil
  local sameGroupSkill
  for i = 1, #self.allSkills do
    local learnSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(self.allSkills[i].sid)
    if learnSkillConfig.groupId == skillConfig.groupId then
      if not sameGroupSkill then
        sameGroupSkill = self.allSkills[i]
      elseif sameGroupSkill.sid < self.allSkills[i].sid then
        sameGroupSkill = self.allSkills[i]
      end
    end
  end
  self.skills[skillConfig.groupId] = sameGroupSkill
end

function MeData:UpdateSkillExpData(skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local playerSkill = self.skills[cfg_skill.groupId]
  if cfg_skill.exp and cfg_skill.exp > 0 and cfg_skill.exp > playerSkill.exp then
    playerSkill.exp = playerSkill.exp + 1
  end
end

function MeData:UpdateSkillUseTime(skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local playerSkill = self.skills[cfg_skill.groupId]
  if playerSkill then
    playerSkill.lastUseTime = Time.GetServerSecondTime()
  end
end

function MeData:UpdateTransferCareer(data)
  if data.roleId == self.id then
    self.oldCareer = data.beforeCareer
    self.career = data.career
  end
end

function MeData:InitAttribute(data)
  self:InitRoleBasicAttribute(data.basic.chooseAttribute)
  self:InitFruitAddAttribute(data.fruitInfo)
  self:InitBasicAttribute()
  self:InitFinalAttribute()
end

function MeData:RefreshAttributes(refreshType)
  self:InitBasicAttribute()
  self:InitFinalAttribute()
end

function MeData:SetLevel(lv)
  if self.level ~= lv and RoleManager.me ~= nil then
    self.level = lv
    RoleManager.me:AddLevelReinEffect()
  end
  self.level = lv
  self.roleBasicAttributePointMap.level = lv
end

function MeData:RefreshLevel(lv)
  self:SetLevel(lv)
  self:RefreshAttributes()
end

function MeData:RefreshShieldNum(roleData)
  self.shield = roleData.shield
  self.hasShield = roleData.info.hasShield
  RoleData.SetShieldState(roleData)
end

function MeData:UpdateUnionInfoData(unionId, unionName, unionLogo)
  if unionId ~= nil then
    self.unionId = unionId
  end
  if unionName ~= nil then
    self.unionName = unionName
  end
  if unionLogo ~= nil then
    self.unionLogo = unionLogo
  end
  if self.unionId ~= 0 then
    WarAllianceData.CreatArmband()
  end
  WarAllianceData.UpdateData()
  RoleManager.RefreshHeadColor()
end

function MeData:InitRoleBasicAttribute(attrMapMsg)
  self.roleBasicAttributePointMap.strength = attrMapMsg[EAttributeType.strength] or 0
  self.roleBasicAttributePointMap.agility = attrMapMsg[EAttributeType.agility] or 0
  self.roleBasicAttributePointMap.vitality = attrMapMsg[EAttributeType.vitality] or 0
  self.roleBasicAttributePointMap.energy = attrMapMsg[EAttributeType.energy] or 0
  self.roleBasicAttributePointMap.leadership = attrMapMsg[EAttributeType.leadership] or 0
end

function MeData:RefreshRoleBasicAttribute(attrMapMsg)
  self:InitRoleBasicAttribute(attrMapMsg)
  self:RefreshAttributes()
end

function MeData:RefreshRedNameData(msg)
  self.evilLevel = msg.redLevel
  self.notoriety = msg.notoriety
end

local function CalculateTitleAttribute(self)
  local temp
  local resultAttr = {}
  local keyTemp
  for k, v in pairs(self.titleData.TitleInfo) do
    for key, val in pairs(v.tblEquip) do
      keyTemp = string.replace(key, CAttributePrefixFlag.Mount_Active, "")
      if AttributeConfig.IsAttribute(keyTemp) then
        temp = resultAttr[keyTemp] or 0
        resultAttr[keyTemp] = temp + val
      end
    end
  end
  return resultAttr
end

function MeData:InitBasicAttribute()
  self.AttributeSystemMap = {}
  self.AttributeSystemMap[EAttributeProviderSystem.RoleBasic] = RoleBasicAttributeCalculator.CalcAttribute(self.career, self.roleBasicAttributePointMap)
  local finalsBaseAttribute = {}
  finalsBaseAttribute = AttributeConfig.MergeAttributeMap(finalsBaseAttribute, self.AttributeSystemMap[EAttributeProviderSystem.RoleBasic])
  finalsBaseAttribute = AttributeConfig.MergeAttributeMap(finalsBaseAttribute, self.attributeAddPoint)
  self.AttributeSystemMap[EAttributeProviderSystem.RoleEquip] = EquipAttributeCalculator.CalcRoleEquipeAttr(self.equipsData, self.career, finalsBaseAttribute)
  self.AttributeSystemMap[EAttributeProviderSystem.Union] = UnionAttributeCalculator.CalcUnionAttributes(self.id, self.career)
  self.AttributeSystemMap[EAttributeProviderSystem.Mount] = MountAttributeCalculator.CalcMountAttributes(self.mountData)
  self.AttributeSystemMap[EAttributeProviderSystem.Fruit] = self.attributeAddPoint
  self.AttributeSystemMap[EAttributeProviderSystem.Other] = self.masterAttr and self.masterAttr or {}
  self.AttributeSystemMap[EAttributeProviderSystem.Title] = CalculateTitleAttribute(self)
end

local function FightCalculator(self, attributeMap)
  local usedAttribute = {
    excellentDamageChance = EAttributeType.excellentDamageChance,
    criticalDamageChance = EAttributeType.criticalDamageChance,
    doubleDamageChance = EAttributeType.doubleDamageChance,
    attackSpeedIncrease = EAttributeType.attackSpeedIncrease,
    twoHandedWeaponDamageIncrease = EAttributeType.twoHandedWeaponDamageIncrease,
    damageBonus = EAttributeType.damageBonus,
    extraDamage = EAttributeType.extraDamage,
    maximumHealth = EAttributeType.maximumHealth,
    maximumShield = EAttributeType.maximumShield,
    damageReflection = EAttributeType.damageReflection,
    defenseBase = EAttributeType.defenseBase,
    defenseIgnoreChance = EAttributeType.defenseIgnoreChance,
    defenseRatePvm = EAttributeType.defenseRatePvm,
    damageReceiveDecrement = EAttributeType.damageReceiveDecrement,
    damageAbsorption = EAttributeType.damageAbsorption
  }
  for k, v in pairs(usedAttribute) do
    usedAttribute[k] = math.floor(tonumber(tostring(self:GetTrueCalculateAttribute(v, attributeMap))))
  end
  local careerRatio = GlobalConfig.GetGlobalConfig(1110101)
  careerRatio = string.split(careerRatio, "#")
  if RoleUtility.GetBasicCareer(self.career) == ERoleCareer.SwordMan then
    careerRatio = tonumber(careerRatio[1])
  elseif RoleUtility.GetBasicCareer(self.career) == ERoleCareer.Archer then
    careerRatio = tonumber(careerRatio[2])
  else
    careerRatio = tonumber(careerRatio[3])
  end
  local comUseRatio = 1.0E-4
  local attack = RoleUtility.GetBasicCareer(self.career) == ERoleCareer.Magic and attributeMap[EAttributeType.maximumWizBaseDmg] or attributeMap[EAttributeType.maximumPhysBaseDmg]
  local dmgAddtion = 1 + usedAttribute.excellentDamageChance * comUseRatio * 0.3 + usedAttribute.criticalDamageChance * comUseRatio * 0.25 + usedAttribute.doubleDamageChance * comUseRatio
  local extraDmg = usedAttribute.attackSpeedIncrease * comUseRatio * (1 + usedAttribute.twoHandedWeaponDamageIncrease * comUseRatio + usedAttribute.damageBonus * comUseRatio) * (1 + usedAttribute.extraDamage * comUseRatio)
  local fight = (attack * extraDmg * dmgAddtion + usedAttribute.maximumHealth * usedAttribute.damageReflection * comUseRatio + usedAttribute.defenseBase / 2 * usedAttribute.defenseIgnoreChance * comUseRatio * extraDmg * dmgAddtion) * (usedAttribute.maximumHealth + usedAttribute.defenseBase / 2 * 8) / (1 - usedAttribute.defenseRatePvm / 2500) / (1 - usedAttribute.damageReceiveDecrement * comUseRatio) / (1 - usedAttribute.damageAbsorption * comUseRatio) * 0.001 / careerRatio
  attributeMap[EAttributeType.fight] = math.floor(fight)
end

function MeData:InitFinalAttribute()
  local attrSumMap
  for _, v in pairs(self.AttributeSystemMap) do
    attrSumMap = AttributeConfig.MergeAttributeMap(attrSumMap, v)
  end
  local fightAttra = AttributeFormulaCalculator.CalcFinalAttribute(self.career, attrSumMap)
  FightCalculator(self, fightAttra)
  self.attributeMap = AttributeFormulaCalculator.CalcFinalAttribute(self.career, attrSumMap)
  self.attributeMap[EAttributeType.fight] = fightAttra[EAttributeType.fight]
  for i, v in pairs(BuffAttributeCalculator.CollectBuffAttribute(self.id)) do
    local value = self.attributeMap[i] or 0
    self.attributeMap[i] = value + v
  end
end

function MeData:RefreshSpeedAttribute(data)
  self.attributeMap[EAttributeType.moveSpeed] = data
end

function MeData:InitFruitAddAttribute(AddAttributeMsg)
  self:InitFruitChangeAttribute(AddAttributeMsg)
end

function MeData:UpdateFruitAddAttribute(AddAttributeMsg)
  self.AttributeTime = AddAttributeMsg.resetCount
  self:InitFruitChangeAttribute(AddAttributeMsg)
  self:RefreshAttributes()
end

function MeData:InitFruitChangeAttribute(AddAttributeMsg)
  if AddAttributeMsg ~= nil then
    self.attributeAddPoint.strength = AddAttributeMsg.fruitAttribute.strength or 0
    self.attributeAddPoint.agility = AddAttributeMsg.fruitAttribute.agility or 0
    self.attributeAddPoint.vitality = AddAttributeMsg.fruitAttribute.vitality or 0
    self.attributeAddPoint.energy = AddAttributeMsg.fruitAttribute.energy or 0
    local atrributeValue = AddAttributeMsg.fruitAttribute.comboRecovery or 0
    self.attributeAddPoint.comboRecovery_mul = atrributeValue * 20
    atrributeValue = AddAttributeMsg.fruitAttribute.shieldRecoveryMultiplier_mul or 0
    self.attributeAddPoint.shieldRecoveryMultiplier_mul = atrributeValue * 20
  end
end

function MeData:GetAttribute(attrType)
  return self.attributeMap[attrType] or 0
end

function MeData:GetServerAttribute(attriType)
  return math.floor(tonumber(tostring(self:GetTrueCalculateAttribute(attriType, self.attributeMap))))
end

function MeData:GetTrueCalculateAttribute(attriType, attrMap)
  for k, v in pairs(ClientServersDifferenceAttributeToServerKey) do
    if EAttributeType[k] == attriType then
      local serverValue = attrMap[v] or 0
      return serverValue
    end
  end
  return attrMap[attriType] or 0
end

function MeData:SetAttribute(attrType, value)
  self.SerattributeMap[attrType] = value
  self:RefreshAttributes()
end

function MeData:InitRefresh(count)
  if count then
    self.counts = count
  end
end

local Equip_masterAttr = {}

function MeData:SetMasterAttr(masterID)
  if not masterID or table.count(masterID) == 0 then
    self.attributeMap[EAttributeType.extraIntensifyAttributeIncrease] = 0
    self.attributeMap[EAttributeType.extraAdditionalAttributeIncrease] = 0
    self.masterAttr = {}
    self:RefreshAttributes()
    return
  end
  if table.count(masterID) > 0 then
    local masterAttr = {}
    for i = 1, #masterID do
      local masterTbl = ClientTable.cfg_Equip_masterManager:TryGetValue(masterID[i])
      AttributeConfig.GetTableAttributes(masterTbl, Equip_masterAttr)
      masterAttr = AttributeConfig.MergeAttributeMap(masterAttr, Equip_masterAttr)
    end
    for k, v in pairs(masterAttr) do
      self.attributeMap[EAttributeType[k]] = tonumber(v)
    end
    if self.masterAttr == nil then
    end
    self.masterAttr = masterAttr
    self:RefreshAttributes()
  end
end

local function TwoHandWeapon(subtype)
  if subtype == EItemSubtype.TwoHandedSword or subtype == EItemSubtype.Spear or subtype == EItemSubtype.TwoHandedAxe or subtype == EItemSubtype.TwoHandedStick then
    return true
  else
    return false
  end
end

local function OneHandWeapon(subType)
  if subType == EItemSubtype.OneHandedSword or subType == EItemSubtype.OneHandedAxe or subType == EItemSubtype.OneHandedStick or subType == EItemSubtype.Shield or subType == EItemSubtype.RedOneHandedStick or subType == EItemSubtype.Suit_OneHandedStick then
    return true
  else
    return false
  end
end

local function calculateFight(self, EquipData)
  local AttributeSystemMap = {}
  AttributeSystemMap[EAttributeProviderSystem.RoleBasic] = RoleBasicAttributeCalculator.CalcAttribute(self.career, self.roleBasicAttributePointMap)
  AttributeSystemMap[EAttributeProviderSystem.RoleEquip] = EquipAttributeCalculator.CalcRoleEquipeAttr(EquipData, self.career)
  AttributeSystemMap[EAttributeProviderSystem.Union] = UnionAttributeCalculator.CalcUnionAttributes(self.id, self.career)
  AttributeSystemMap[EAttributeProviderSystem.Mount] = MountAttributeCalculator.CalcMountAttributes(self.mountData)
  AttributeSystemMap[EAttributeProviderSystem.Fruit] = self.attributeAddPoint
  AttributeSystemMap[EAttributeProviderSystem.Other] = self.masterAttr and self.masterAttr or {}
  local attrSumMap = {}
  for _, v in pairs(AttributeSystemMap) do
    attrSumMap = AttributeConfig.MergeAttributeMap(attrSumMap, v)
  end
  local tempAttribute = AttributeFormulaCalculator.CalcFinalAttribute(self.career, attrSumMap)
  return tempAttribute
end

local function EquipItemFight(self, pos, curreEquipData)
  local equipData, equipDataSelf
  equipData = table.DeepCopy(self.equipsData)
  equipDataSelf = table.DeepCopy(self.equipsData)
  curreEquipData = ItemUtility.GenerateItemData(curreEquipData.itemId)
  if TwoHandWeapon(curreEquipData.tblEquip.subType) then
    equipData.Data[4] = nil
    equipData.Data[5] = nil
  end
  if OneHandWeapon(curreEquipData.tblEquip.subType) and equipData.Data[4] and TwoHandWeapon(equipData.Data[4].tblEquip.subType) then
    equipData.Data[4] = nil
  end
  equipData.Data[pos] = curreEquipData
  local tempAttribute = calculateFight(self, equipData)
  local tempAttributeSelf
  if equipDataSelf.Data[pos] then
    equipDataSelf.Data[pos] = ItemUtility.GenerateItemData(equipDataSelf.Data[pos].itemId)
    tempAttributeSelf = calculateFight(self, equipDataSelf)
    FightCalculator(self, tempAttributeSelf)
  else
    tempAttributeSelf = self.attributeMap
  end
  FightCalculator(self, tempAttribute)
  return tempAttribute[EAttributeType.fight] > tempAttributeSelf[EAttributeType.fight], tempAttribute[EAttributeType.fight], tempAttribute
end

function MeData:EquipItemFightCalculator(equipData)
  local posStr = equipData.tblEquip.equipPosition
  posStr = string.split(posStr, "#")
  for i = 1, #posStr do
    local isUp = EquipItemFight(self, tonumber(posStr[i]), equipData)
    if isUp then
      return isUp
    end
  end
  return false
end

function MeData:EquipWearFightCaululator(equipData)
  local posStr = equipData.tblEquip.equipPosition
  posStr = string.split(posStr, "#")
  local maxfight = 0
  for i = 1, #posStr do
    local isUp, fightVal = EquipItemFight(self, tonumber(posStr[i]), equipData)
    if maxfight < fightVal then
      maxfight = fightVal
    end
  end
  return maxfight
end

local function TowHandOneHandWeaponReplace(equipsData, subtype)
  if TwoHandWeapon(subtype) then
    equipsData[4] = nil
  end
  if OneHandWeapon(subtype) and equipsData[4] and TwoHandWeapon(equipsData[4].tblEquip.subType) then
    equipsData[4] = nil
  end
end

local function OneHandOrTwoHandWeapon(equipItem)
  local subType = equipItem.tblEquip.subType
  if subType == 1 or subType == 4 or subType == 6 or 8 <= subType and subType <= 12 then
    return 1
  elseif subType == 3 or subType == 2 or subType == 5 or subType == 7 or subType == 3 then
    return 2
  end
end

function MeData:EquipEntryRatingCompare(equipData)
  if equipData.tblEquip == nil then
    return false
  end
  local selfData = self.equipsData.Data
  local posStr = equipData.tblEquip.equipPosition
  posStr = string.split(posStr, "#")
  if tonumber(posStr[1]) == 4 or tonumber(posStr[1]) == 5 then
    local mainWeapon = selfData[4] and selfData[4]:GetAllAttributes().equipRating or 0
    local mainWeaponExcellence = selfData[4] and selfData[4]:GetEquipExcellenceNum() or 0
    local assistantWeapon = selfData[5] and selfData[5]:GetAllAttributes().equipRating or 0
    local assistantWeaponExcellence = selfData[5] and selfData[5]:GetEquipExcellenceNum() or 0
    local attackValue = selfData[5] and (selfData[5]:GetAllAttributes().maximumPhysBaseDmg and selfData[5]:GetAllAttributes().maximumPhysBaseDmg or 0) or 0
    if 1 < #posStr then
      if selfData[4] then
        if OneHandOrTwoHandWeapon(selfData[4]) == 2 then
          if equipData.tblEquip.equipClass <= selfData[4].tblEquip.equipClass then
            return false
          else
            return mainWeapon < equipData:GetAllAttributes().equipRating
          end
        elseif selfData[5] then
          if selfData[5].tblEquip.subType == EItemSubtype.Shield and attackValue == 0 then
            return mainWeapon < equipData:GetAllAttributes().equipRating
          end
          if mainWeapon > assistantWeapon then
            return assistantWeapon < equipData:GetAllAttributes().equipRating
          else
            return mainWeapon < equipData:GetAllAttributes().equipRating
          end
        else
          return true
        end
      else
        return true
      end
      return false
    elseif selfData[4] and OneHandOrTwoHandWeapon(selfData[4]) == 2 then
      if OneHandOrTwoHandWeapon(equipData) == 1 then
        if equipData.tblEquip.equipClass > selfData[4].tblEquip.equipClass then
          return mainWeapon < equipData:GetAllAttributes().equipRating
        else
          return false
        end
      else
        return mainWeapon < equipData:GetAllAttributes().equipRating
      end
    elseif selfData[4] then
      if OneHandOrTwoHandWeapon(equipData) == 2 then
        if selfData[5] then
          local mainClass = selfData[4].tblEquip.equipClass
          local assistantClass = selfData[5].tblEquip.equipClass
          local comparePos = assistantWeapon <= mainClass and 4 or 5
          mainClass = mainClass > assistantClass and mainClass or assistantClass
          if mainClass < equipData.tblEquip.equipClass then
            return selfData[comparePos]:GetAllAttributes().equipRating < equipData:GetAllAttributes().equipRating
          else
            return false
          end
        elseif equipData.tblEquip.equipClass > selfData[4].tblEquip.equipClass then
          return mainWeapon < equipData:GetAllAttributes().equipRating
        else
          return false
        end
      elseif tonumber(posStr[1]) == 5 then
        if selfData[5] then
          if (selfData[5].tblEquip.subType == EItemSubtype.Shield or selfData[5].tblEquip.subType == EItemSubtype.mShield) and (equipData.tblEquip.subType == EItemSubtype.Shield or equipData.tblEquip.subType == EItemSubtype.mShield) then
            return assistantWeapon < equipData:GetAllAttributes().equipRating
          end
          if selfData[5].tblEquip.subType == EItemSubtype.Shield or equipData.tblEquip.subType == EItemSubtype.Shield then
            if attackValue == 0 and equipData:GetAllAttributes().maximumPhysBaseDmg == 0 then
              return assistantWeapon < equipData:GetAllAttributes().equipRating
            end
            if 0 < attackValue and 0 < equipData:GetAllAttributes().maximumPhysBaseDmg then
              return assistantWeapon < equipData:GetAllAttributes().equipRating
            end
            return false
          end
        else
          return true
        end
      else
        return mainWeapon < equipData:GetAllAttributes().equipRating
      end
    elseif tonumber(posStr[1]) == 5 then
      if selfData[5] then
        if selfData[5].tblEquip.subType == EItemSubtype.Shield or equipData.tblEquip.subType == EItemSubtype.Shield then
          if attackValue == 0 and equipData:GetAllAttributes().maximumPhysBaseDmg == 0 then
            return assistantWeapon < equipData:GetAllAttributes().equipRating
          end
          if 0 < attackValue and 0 < equipData:GetAllAttributes().maximumPhysBaseDmg then
            return assistantWeapon < equipData:GetAllAttributes().equipRating
          end
          return false
        end
      else
        return true
      end
    elseif selfData[5] then
      if OneHandOrTwoHandWeapon(equipData) == 2 then
        if equipData.tblEquip.equipClass > selfData[5].tblEquip.equipClass then
          return assistantWeapon < equipData:GetAllAttributes().equipRating
        else
          return false
        end
      else
        return mainWeapon < equipData:GetAllAttributes().equipRating
      end
    else
      return mainWeapon < equipData:GetAllAttributes().equipRating
    end
  elseif tonumber(posStr[1]) > 2200 and tonumber(posStr[1]) < 2300 then
    local curRide = RoleManager.me.data.mountData:GetMountDataByType(tonumber(posStr[1]))
    if curRide ~= nil then
      return equipData:GetAllAttributes().equipRating > curRide.tblEquip.equipRating
    end
    return true
  end
  local endRating = selfData[tonumber(posStr[1])] and selfData[tonumber(posStr[1])]:GetAllAttributes().equipRating or 0
  local endRating2 = (posStr[2] and selfData[tonumber(posStr[2])] or nil) and selfData[tonumber(posStr[2])]:GetAllAttributes().equipRating or 0
  local canUp = endRating < equipData:GetAllAttributes().equipRating
  local canUp2 = endRating2 < equipData:GetAllAttributes().equipRating
  if posStr[2] then
    return canUp or canUp2
  else
    return canUp
  end
end

local buffAttrPercentByBuffId = {
  [30001008] = 1000,
  [30001009] = 2000,
  [30001010] = 3000,
  [30001011] = 1000,
  [30001012] = 2000,
  [30001013] = 3000,
  [30002007] = 1000,
  [30002008] = 2000,
  [30002009] = 3000,
  [30002010] = 1000,
  [30002011] = 2000,
  [30002012] = 3000
}

function MeData:SetHp(hp)
  self:SetAttributeByHpBuff(hp)
  RoleData.SetHp(self, hp)
end

function MeData:SetShield(Shield)
  RoleData.SetShield(self, Shield)
end

function MeData:SetAttributeByHpBuff(hp)
  local percent = hp / self.attributeMap[EAttributeType.maximumHealth]
  percent = math.ceil(percent * 10)
  if percent <= 9 then
    local roleBuffs = BuffData.GetBuffs(self.id)
    local attributeAddtionMap = {}
    attributeAddtionMap.attackSpeedIncrease_fAdd = 0
    attributeAddtionMap.damageBonus = 0
    local change = false
    for _, buff_struct in pairs(roleBuffs) do
      if buffAttrPercentByBuffId[buff_struct.buffConfig.id] then
        if buff_struct.buffConfig.id > 30001010 and buff_struct.buffConfig.id < 30002007 or buff_struct.buffConfig.id > 30002009 then
          change = true
          attributeAddtionMap.attackSpeedIncrease_fAdd = attributeAddtionMap.attackSpeedIncrease_fAdd + buffAttrPercentByBuffId[buff_struct.buffConfig.id]
        end
        if buff_struct.buffConfig.id < 30001011 or buff_struct.buffConfig.id < 30002010 and buff_struct.buffConfig.id > 30001013 then
          attributeAddtionMap.damageBonus = attributeAddtionMap.damageBonus + buffAttrPercentByBuffId[buff_struct.buffConfig.id]
          change = true
        end
      end
    end
    attributeAddtionMap.damageBonus = attributeAddtionMap.damageBonus * (10 - percent)
    attributeAddtionMap.attackSpeedIncrease_fAdd = attributeAddtionMap.attackSpeedIncrease_fAdd * (10 - percent) * AttributeConfig.MULTIRATIO_RATIO
    if change then
      local oldAttrs = self.attributeMap
      self:InitBasicAttribute()
      local attrSumMap
      for _, v in pairs(self.AttributeSystemMap) do
        attrSumMap = AttributeConfig.MergeAttributeMap(attrSumMap, v)
      end
      attrSumMap = AttributeConfig.MergeAttributeMap(attrSumMap, attributeAddtionMap)
      local attributeMapWithBuff = AttributeFormulaCalculator.CalcFinalAttribute(self.career, attrSumMap)
      self.attributeMap = table.merge(self.attributeMap, attributeMapWithBuff)
      for i, v in pairs(BuffAttributeCalculator.CollectBuffAttribute(self.id)) do
        local value = self.attributeMap[i] or 0
        self.attributeMap[i] = value + v
      end
      self.attributeMap[EAttributeType.fight] = oldAttrs[EAttributeType.fight]
    end
  end
end

function MeData:ResetData()
  self.campId = nil
end
