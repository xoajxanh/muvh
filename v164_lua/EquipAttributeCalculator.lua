EquipAttributeCalculator = {}
local this = EquipAttributeCalculator
local AttackSpeedRatio = 0
local AssistantWeapondamping = 0

function EquipAttributeCalculator.CalcSingleEquipAttr(equipeData)
  local intensifyTbl = MeEquipController.GetEquipIntensifyCfgByEquipData(equipeData)
  local result = table.metatableCopy({}, equipeData.tblEquip)
  if intensifyTbl then
    for k, _ in pairs(intensifyTbl) do
      if result[k] then
        if string.contains(k, CAttributeFixFlag.MUL) then
          result[k] = result[k] ~= 0 and intensifyTbl[k] ~= 0 and math.floor(result[k] * (1 + intensifyTbl[k] / 10000)) or result[k]
        elseif tonumber(result[k]) ~= nil and tonumber(intensifyTbl[k]) ~= nil then
          result[k] = result[k] ~= 0 and intensifyTbl[k] ~= 0 and result[k] + intensifyTbl[k] or result[k]
        end
      end
    end
  end
  return result
end

function EquipAttributeCalculator.CalcAllEquipIntensifyAttr(roleEquipData, career)
  local resultIntensify = {}
  for k, v in pairs(roleEquipData) do
    local equipeData = v
    if equipeData.bagGridIndex == ERoleEquipPosition.pet or equipeData.bagGridIndex ~= ERoleEquipPosition.wing then
    end
    resultIntensify = AttributeConfig.MergeAttributeMap(resultIntensify, v:GetAttributes(EEquipeAttributeProviderSystem.Intensified))
  end
  this.resultIntensify = resultIntensify
end

function EquipAttributeCalculator.CalcAllEquipadditionalAttr(roleEquipData)
  local resultIntensify = {}
  for k, v in pairs(roleEquipData) do
    if equipeData.bagGridIndex == ERoleEquipPosition.pet or equipeData.bagGridIndex ~= ERoleEquipPosition.wing then
    end
    resultIntensify = AttributeConfig.MergeAttributeMap(resultIntensify, v:GetAttributes(EEquipeAttributeProviderSystem.Addition))
  end
  this.resultadditional = resultIntensify
end

function EquipAttributeCalculator.CalcAllEquipGrowUpAttr(roleEquipData, career)
  local resultGrowUp = {}
  for k, v in pairs(roleEquipData) do
    local equipeData = v
    if equipeData.bagGridIndex == ERoleEquipPosition.pet or equipeData.bagGridIndex ~= ERoleEquipPosition.wing then
    end
    resultGrowUp = AttributeConfig.MergeAttributeMap(resultGrowUp, v:GetAttributes(EEquipeAttributeProviderSystem.GrowUp))
  end
  this.resultGrowUp = resultGrowUp
end

function EquipAttributeCalculator.GetEquipAtttributeValue(key, value)
  for k, v in pairs(RoleEquipUtility.integerAttribute) do
    if key == v then
      return value, 1
    end
  end
  for k, v in pairs(RoleEquipUtility.percentageAttribute) do
    if key == v then
      return value / 10000, 2
    end
  end
  for k, v in pairs(RoleEquipUtility.thousandDivide) do
    if key == v then
      return 10000 / value, 3
    end
  end
end

local Item_equip_excellenceAttributes

local function GetSingleExcellenceOrLuckAttrMap(excOrLuckId)
  if excOrLuckId == 0 then
    return
  end
  local cfg = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(excOrLuckId)
  return cfg
end

function EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMap(excOrLuckIds)
  excOrLuckIds = excOrLuckIds or {}
  local result = {}
  for _, id in pairs(excOrLuckIds) do
    local attrMap = GetSingleExcellenceOrLuckAttrMap(id)
    if attrMap then
      result = AttributeConfig.MergeAttributeMap(result, attrMap)
    end
  end
  return result
end

function EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMap_NewExcellence(excOrLuckIds)
  excOrLuckIds = excOrLuckIds or {}
  local result = {}
  for _, info in pairs(excOrLuckIds) do
    local attrMap = GetSingleExcellenceOrLuckAttrMap(info.configId)
    if attrMap then
      local attrMap_metaTbl = getmetatable(attrMap)
      if attrMap_metaTbl ~= nil then
        for k, v in pairs(attrMap_metaTbl.__index) do
          if v ~= 0 and v ~= "" and attrMap[k] == v then
            attrMap[k] = v
          end
        end
      end
      result = AttributeConfig.MergeAttributeMap(result, attrMap)
    end
  end
  return result
end

function EquipAttributeCalculator.GetHonourAttrMap_NewExcellence(honourAttr)
  honourAttr = honourAttr or {}
  local result = {}
  for _, configId in pairs(honourAttr) do
    local attrMap = ClientTable.cfg_Item_equip_excell_honourManager:TryGetValue(configId)
    if attrMap then
      local attrMap_metaTbl = getmetatable(attrMap)
      if attrMap_metaTbl ~= nil then
        for k, v in pairs(attrMap_metaTbl.__index) do
          if v ~= 0 and v ~= "" and attrMap[k] == v then
            attrMap[k] = v
          end
        end
      end
      result = AttributeConfig.MergeAttributeMap(result, attrMap)
    end
  end
  return result
end

function EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMapTable(excOrLuckIds, tblEquip)
  excOrLuckIds = excOrLuckIds or {}
  local result = {}
  for _, id in pairs(excOrLuckIds) do
    local attrMap = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(id)
    if attrMap and (attrMap.conditionShow == nil or attrMap.conditionShow == "" or ConditionManager.Check4D(attrMap.conditionShow, tblEquip)) then
      table.insert(result, attrMap)
    end
  end
  return result
end

function EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMapTableByServerInfo(excOrLuckInfos)
  local result = {}
  if excOrLuckInfos then
    for k, v in pairs(excOrLuckInfos) do
      local attrMap = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(k)
      if attrMap then
        table.insert(result, attrMap)
      end
    end
  end
  return result
end

function EquipAttributeCalculator.GetMultiLuckLevelAttrMap(equipId, LuckLevel, resultTable)
  local cfg = ConfigManager.FindConfigs("cfg_Item_equip_lucky", "type", equipId)
  for _, v in pairs(cfg) do
    if v.level == LuckLevel then
      return AttributeConfig.GetTableAttributes(v, resultTable)
    end
  end
end

function EquipAttributeCalculator.CalcAllStoneBasicsAttr(StoneDatas)
  local resultIntensify = {}
  for k, v in pairs(StoneDatas) do
    local stoneData = v
    if stoneData.valid then
      local singleStoneAttri = this.GetSingleStoneBasicsAttr(stoneData)
      for k, value in pairs(singleStoneAttri) do
        resultIntensify[k] = resultIntensify[k] and resultIntensify[k] + value or value
      end
    end
  end
  this.StoneBasicsAttri = resultIntensify
end

function EquipAttributeCalculator.GetSingleStoneBasicsAttr(stoneData)
  local normalIntensifyInfo = {}
  local equipeTbl = stoneData.tblEquip
  local fullConfig
  local metatable = getmetatable(equipeTbl)
  if metatable then
    fullConfig = table.copy(fullConfig, metatable.__index)
  end
  fullConfig = table.copy(fullConfig, equipeTbl)
  for k, v in pairs(fullConfig) do
    if AttributeConfig.IsAttribute(k) then
      normalIntensifyInfo[k] = v
    end
  end
  return normalIntensifyInfo
end

function EquipAttributeCalculator.CalcStoneLightAttr(stoneLight, resultTable)
  local stone_lightTbl = ClientTable.cfg_Item_stone_lightManager:TryGetValue(stoneLight)
  return AttributeConfig.GetTableAttributes(stone_lightTbl, resultTable)
end

local CombinationAttr = {
  "fight",
  "doubleDamageChance",
  "defenseI"
}
local item_stone_combinationAttr = {}

function EquipAttributeCalculator.CalcStoneCombinationAttr(StoneDatas)
  local result = {}
  local cfg = ClientTable.cfg_item_stone_combinationManager:GetDic()
  for _, v in pairs(cfg) do
    local combinationTbl = {tbl = v}
    local isOpen = RoleEquipUtility.GetStoneCombinIsActivate(combinationTbl, StoneDatas)
    if isOpen then
      result = AttributeConfig.MergeAttributeMap(result, AttributeConfig.GetTableAttributes(v, item_stone_combinationAttr))
    end
  end
  return result
end

local function GetSuitCountByLevel(suidTbl)
  local levelContainer = {}
  for k, v in pairs(suidTbl) do
    local levelNum = v
    if not table.containsKey(levelContainer, levelNum) then
      levelContainer[levelNum] = {}
    end
    table.insert(levelContainer[levelNum], "sign")
  end
  return levelContainer
end

local function HightLevelChangeCount(levelContainer)
  local levelAndCount = {}
  for k, v in pairs(levelContainer) do
    local count = #v
    for key, val in pairs(levelContainer) do
      if tostring(key) > tostring(k) then
        count = count + #val
      end
    end
    levelAndCount[k] = count
  end
  return levelAndCount
end

local Item_equip_suit_list = {}

function EquipAttributeCalculator.CalcAllEquipSuitAttr(roleEquipData)
  local resultIntensify = {}
  local suitTbl = this.GetAllSuitNum(roleEquipData)
  for k, suidTbl in pairs(suitTbl) do
    local suitId = k
    local levelAndCount = HightLevelChangeCount(GetSuitCountByLevel(suidTbl))
    local suitAttrCfgs = ConfigManager.cfg_Item_equip_suit_list[suitId]
    local CountToLevelTab = {}
    for k, v in pairs(levelAndCount) do
      for i = 1, #suitAttrCfgs do
        if v >= suitAttrCfgs[i].actNum and suitAttrCfgs[i].level == tonumber(k) then
          if not table.containsKey(CountToLevelTab, suitAttrCfgs[i].actNum) then
            CountToLevelTab[suitAttrCfgs[i].actNum] = {}
          end
          CountToLevelTab[suitAttrCfgs[i].actNum][suitAttrCfgs[i].level] = suitAttrCfgs[i]
        end
      end
    end
    for k, v in pairs(CountToLevelTab) do
      local maxlevel = 0
      for key, val in pairs(v) do
        if key > maxlevel then
          maxlevel = key
        end
      end
      resultIntensify = AttributeConfig.MergeAttributeMap(resultIntensify, AttributeConfig.GetTableAttributes(v[maxlevel], Item_equip_suit_list))
    end
  end
  return resultIntensify
end

local baseAttributeMap

function EquipAttributeCalculator.GetAllSuitNum(roleEquipData)
  local normalTable = {}
  for k, v in pairs(roleEquipData) do
    if v.isSuit then
      local suitId = v.tblEquip.suitId
      local suitSpilt = string.split(suitId, "#")
      if table.count(suitSpilt) > 0 then
        local suitId = tonumber(suitSpilt[1])
        if not normalTable[suitId] then
          normalTable[suitId] = {}
        end
        local canWear = true
        if baseAttributeMap then
          local needStrength = v.tblItem.needStrength
          local needAgility = v.tblItem.needAgility
          local needEnergy = v.tblItem.needEnergy
          if needStrength > baseAttributeMap.strength or needAgility > baseAttributeMap.agility or needEnergy > baseAttributeMap.energy then
            canWear = false
          end
        end
        if canWear then
          table.insert(normalTable[suitId], tonumber(suitSpilt[2]))
        end
      end
    end
  end
  return normalTable
end

function EquipAttributeCalculator.CalcAllMoveSpeedAttr(roleEquipData)
  local resultIntensify = {}
  for k, v in pairs(roleEquipData) do
    local equipeData = v
    local equipeTbl = equipeData.tblEquip
    if equipeTbl.staticMoveSpeed and equipeTbl.staticMoveSpeed ~= 0 then
      local value = equipeTbl.staticMoveSpeed
      if equipeData.bagGridIndex == ERoleEquipPosition.glove then
        resultIntensify.staticMoveSpeedglove = value > resultIntensify.staticMoveSpeedglove and value or resultIntensify.staticMoveSpeedglove or value
      elseif equipeData.bagGridIndex == ERoleEquipPosition.boot then
        resultIntensify.staticMoveSpeedboot = value > resultIntensify.staticMoveSpeedboot and value or resultIntensify.staticMoveSpeedboot or value
      else
        resultIntensify.staticMoveSpeedglove = value > resultIntensify.staticMoveSpeedglove and value or resultIntensify.staticMoveSpeedglove or value
        resultIntensify.staticMoveSpeedboot = value > resultIntensify.staticMoveSpeedboot and value or resultIntensify.staticMoveSpeedboot or value
      end
    end
    if equipeData.bagGridIndex ~= ERoleEquipPosition.pet and equipeData.bagGridIndex ~= ERoleEquipPosition.wing then
      local equipeTbl = equipeData.tblEquip
      local intensifyTbl = MeEquipController.GetEquipIntensifyCfgByEquipData(equipeData)
      if intensifyTbl and intensifyTbl.staticMoveSpeed ~= 0 then
        local value = intensifyTbl.staticMoveSpeed
        if equipeData.bagGridIndex == ERoleEquipPosition.glove then
          resultIntensify.staticMoveSpeedglove = value > resultIntensify.staticMoveSpeedglove and value or resultIntensify.staticMoveSpeedglove or value
        elseif equipeData.bagGridIndex == ERoleEquipPosition.boot then
          resultIntensify.staticMoveSpeedboot = value > resultIntensify.staticMoveSpeedboot and value or resultIntensify.staticMoveSpeedboot or value
        else
          resultIntensify.staticMoveSpeedglove = value > resultIntensify.staticMoveSpeedglove and value or resultIntensify.staticMoveSpeedglove or value
          resultIntensify.staticMoveSpeedboot = value > resultIntensify.staticMoveSpeedboot and value or resultIntensify.staticMoveSpeedboot or value
        end
      end
    end
  end
  this.equipMoveSpeedAttr = resultIntensify
  return resultIntensify
end

function EquipAttributeCalculator.GetEquipAttributes(equipsData, equipAttrSys)
  local result
  for _, equipe in pairs(equipsData) do
    for _, sys in pairs(equipAttrSys) do
      result = AttributeConfig.MergeAttributeMap(result, equipe:GetAttributes(sys))
    end
  end
  return result
end

local WeaponType = {
  EItemSubtype.Arch,
  EItemSubtype.CrossBow,
  EItemSubtype.Suit_CrossBow,
  EItemSubtype.BowBag,
  EItemSubtype.CrossBowBag,
  EItemSubtype.Suit_CrossBowBag,
  EItemSubtype.OneHandedSword,
  EItemSubtype.OneHandedAxe,
  EItemSubtype.OneHandedStick,
  EItemSubtype.RedOneHandedStick,
  EItemSubtype.Suit_OneHandedStick,
  EItemSubtype.Shield
}

local function ArcherWeaponSubTypeCheck(subtype)
  for i = 1, #WeaponType do
    if subtype == WeaponType[i] then
      return true
    end
  end
  return false
end

local function EquipBaseAttributeIsFull(equipData)
  if not equipData then
    return false
  end
  if baseAttributeMap then
    local needStrength = equipData.tblItem.needStrength
    local needAgility = equipData.tblItem.needAgility
    local needEnergy = equipData.tblItem.needEnergy
    if needStrength > baseAttributeMap.strength or needAgility > baseAttributeMap.agility or needEnergy > baseAttributeMap.energy then
      return false
    end
  end
  return true
end

function EquipAttributeCalculator.DoesArcherManHasTwoWeapon(roleEquipData, career)
  local swordEuipeData = {}
  local leftAttack = 0
  if roleEquipData[4] and EquipBaseAttributeIsFull(roleEquipData[4]) then
    leftAttack = roleEquipData[4]:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.maximumPhysBaseDmg)
    if not leftAttack or leftAttack == 0 then
      leftAttack = roleEquipData[4]:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.maximumWizBaseDmg)
    end
    table.insert(swordEuipeData, roleEquipData[4])
  end
  local rightAttack = 0
  if roleEquipData[5] and EquipBaseAttributeIsFull(roleEquipData[5]) then
    rightAttack = roleEquipData[5]:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.maximumPhysBaseDmg)
    if not rightAttack or rightAttack == 0 then
      rightAttack = roleEquipData[5]:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.maximumWizBaseDmg)
    end
    table.insert(swordEuipeData, roleEquipData[5])
  end
  leftAttack = leftAttack or 0
  rightAttack = rightAttack or 0
  swordEuipeData = leftAttack > rightAttack and roleEquipData[5] or roleEquipData[4]
  return 0 < leftAttack and 0 < rightAttack, swordEuipeData
end

function EquipAttributeCalculator:WeaponAttackSpeedSelect(roleEquipData)
  local rightSpeed = 0
  if roleEquipData[4] and EquipBaseAttributeIsFull(roleEquipData[4]) then
    local value = roleEquipData[4]:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.attackSpeed)
    if value then
      rightSpeed = value
    end
  end
  local leftSpeed = 0
  if roleEquipData[5] and EquipBaseAttributeIsFull(roleEquipData[4]) then
    local value = roleEquipData[5]:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.attackSpeed)
    if value then
      leftSpeed = value
    end
  end
  local maxSpeed = rightSpeed > leftSpeed and rightSpeed or leftSpeed
  local sumSpeed = rightSpeed + leftSpeed
  return 0 < leftSpeed and 0 < rightSpeed, sumSpeed, maxSpeed
end

local cardsTable

local function IsMonthCardCondition(tableId)
  if cardsTable == nil then
    cardsTable = ConfigManager.FindConfigs("cfg_Gift_gift", "type", 2)
    for k, v in pairs(cardsTable) do
      v.buyCondition2Num = tonumber(string.split(v.buyCondition, "#")[2])
    end
  end
  for k, v in pairs(cardsTable) do
    if v.buyCondition2Num == tableId then
      return true
    end
  end
end

local equipItemStoneContainer = {}

local function StoneDataDifferentiation(stoneData)
  for index, stone in pairs(stoneData) do
    local equipPos = math.floor(index * 0.01)
    if not equipItemStoneContainer[equipPos] then
      equipItemStoneContainer[equipPos] = {}
    end
    equipItemStoneContainer[equipPos][index] = stone
  end
end

local Item_stone_lightAttr = {}

function EquipAttributeCalculator.CalcRoleEquipeAttr(equipsData, career, basicMap)
  local result = {}
  local tmpAttrMap, excellenceCount
  baseAttributeMap = basicMap
  StoneDataDifferentiation(equipsData.RealStoneData)
  for _, equipe in pairs(equipsData.Data) do
    excellenceCount = table.count(equipe.excellence)
    tmpAttrMap = equipe:GetAllAttributes(career)
    local stones = equipItemStoneContainer[_]
    if stones then
      for k, item in pairs(stones) do
        tmpAttrMap = AttributeConfig.MergeAttributeMap(tmpAttrMap, item:GetAllAttributes())
        stones[k] = nil
      end
    end
    if basicMap then
      local needStrength = equipe.tblItem.needStrength
      local needAgility = equipe.tblItem.needAgility
      local needEnergy = equipe.tblItem.needEnergy
      if needStrength > basicMap.strength or needAgility > basicMap.agility or needEnergy > basicMap.energy then
        tmpAttrMap = {}
      end
    end
    result = AttributeConfig.MergeAttributeMap(result, tmpAttrMap)
  end
  result = AttributeConfig.MergeAttributeMap(result, this.CalcAllEquipSuitAttr(equipsData.Data))
  for _, stone in pairs(equipsData.StoneData) do
    local isOpen = RoleEquipUtility.GetStoneCellIsOpen(_, excellenceCount or 0)
    if isOpen then
    else
    end
    if stone.tblEquip.subType == 29 then
      if not stone.valid then
        stone:SetValid(true)
      end
      tmpAttrMap = stone:GetAllAttributes()
      result = AttributeConfig.MergeAttributeMap(result, tmpAttrMap)
    end
    if IsMonthCardCondition(stone.tblItem.id) and stone.time > Time.GetServerTime() then
      stone:SetValid(true)
      tmpAttrMap = stone:GetAllAttributes()
      result = AttributeConfig.MergeAttributeMap(result, tmpAttrMap)
    end
  end
  result = AttributeConfig.MergeAttributeMap(result, this.CalcStoneCombinationAttr(equipsData.StoneData))
  local doesArcherManHasTwoWeapon, swordsData = this.DoesArcherManHasTwoWeapon(equipsData.Data, career)
  if doesArcherManHasTwoWeapon then
    local tmpAtkPow
    tmpAtkPow = swordsData:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.maximumPhysBaseDmg)
    tmpAtkPow = tmpAtkPow * (AssistantWeapondamping - 1)
    if result.maximumPhysBaseDmg then
      result.maximumPhysBaseDmg = result.maximumPhysBaseDmg + tmpAtkPow
    end
    tmpAtkPow = swordsData:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.minimumPhysBaseDmg)
    tmpAtkPow = tmpAtkPow * (AssistantWeapondamping - 1)
    if result.minimumPhysBaseDmg then
      result.minimumPhysBaseDmg = result.minimumPhysBaseDmg + tmpAtkPow
    end
    tmpAtkPow = swordsData:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.maximumWizBaseDmg)
    tmpAtkPow = tmpAtkPow * (AssistantWeapondamping - 1)
    if result.maximumWizBaseDmg then
      result.maximumWizBaseDmg = result.maximumWizBaseDmg + tmpAtkPow
    end
    tmpAtkPow = swordsData:GetAttribute(EEquipeAttributeProviderSystem.EquipeBasic, EAttributeType.minimumWizBaseDmg)
    tmpAtkPow = tmpAtkPow * (AssistantWeapondamping - 1)
    if result.minimumWizBaseDmg then
      result.minimumWizBaseDmg = result.minimumWizBaseDmg + tmpAtkPow
    end
  end
  local twoSpeedWeapon, sumSpeed, maxSpeed = this:WeaponAttackSpeedSelect(equipsData.Data)
  if twoSpeedWeapon and result.attackSpeed then
    result.attackSpeed = result.attackSpeed - sumSpeed + maxSpeed
  end
  if result.attackSpeed then
    result.attackSpeedIncrease = 1 + result.attackSpeed * AttackSpeedRatio
  else
    result.attackSpeedIncrease = 1
  end
  for k, v in pairs(result) do
    if EAttributeType[k] and EAttributeType[k] ~= EAttributeType.attackSpeedIncrease then
      result[k] = result[k] // 1
    end
  end
  return result
end

local function InitConstant()
  AttackSpeedRatio = ClientTable.cfg_Global_globalManager:TryGetValue(2430002, "id").effect * 1.0E-8
  AssistantWeapondamping = ClientTable.cfg_Global_globalManager:TryGetValue(1110102, "id").effect * 1
end

InitConstant()
