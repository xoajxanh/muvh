EquipData = class(ItemData)

function EquipData:Init()
  ItemData.Init(self)
  self.durability = 0
  self.intensify = 0
  self.additional = 0
  self.exp = 0
  self.level = 0
  self.breach = 0
  self.additionalAttribute = {}
  self.excellence = {}
  self.luckIds = {}
  self.skill = false
  self.attributeMap = {}
  self.invalidAttributtes = {}
  self.wingAttr = {}
  self.equipTime = 0
  self.luckLevel = 0
end

function EquipData:RefreshData(equip)
  ItemData.RefreshData(self, equip)
  self:SetEquipItemData()
  self.durability = equip.durability
  self:SetIntensify(equip.intensify)
  self:SetAddtion(equip.additional, equip.additionalAttribute)
  self:SetGrowUp(equip.level)
  if equip.excellence ~= nil and #equip.excellence > 0 then
    self:SetExcellence(equip.excellence)
  end
  if equip.excellentInfo ~= nil and next(equip.excellentInfo) ~= nil then
    self:SetNewExcellenceInfo(equip.excellentInfo)
    self.attributeMap[EAttributeType.entryRating] = EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMap_NewExcellence(equip.excellentInfo)
  end
  if equip.honourAttr ~= nil and next(equip.honourAttr) ~= nil then
    if self.attributeMap[EAttributeType.entryRating] == nil then
      self.attributeMap[EAttributeType.entryRating] = EquipAttributeCalculator.GetHonourAttrMap_NewExcellence(equip.honourAttr)
    else
      local excellenceEntryRating = self.attributeMap[EAttributeType.entryRating].entryRating or 0
      local honourAttrMap_NewExcellence = EquipAttributeCalculator.GetHonourAttrMap_NewExcellence(equip.honourAttr)
      if honourAttrMap_NewExcellence then
        self.attributeMap[EAttributeType.entryRating].entryRating = (honourAttrMap_NewExcellence.entryRating or 0) + excellenceEntryRating
      end
    end
  end
  if equip.excellentInfoTbl ~= nil and next(equip.excellentInfoTbl) ~= nil then
    self:SetNewExcellenceInfo(equip.excellentInfoTbl)
  end
  if equip.specialEffectIds ~= nil and next(equip.specialEffectIds) ~= nil then
    self:SetSpecialInfo(equip.specialEffectIds)
  end
  if equip.specialInfo ~= nil and next(equip.specialInfo) ~= nil then
    self:SetSpecialInfo(equip.specialInfo)
  end
  self:SetXiLianExcellenceList(equip.equipExcellentClear)
  self:SetLuckIds(equip.lucky and equip.lucky or {})
  self:SetLuckLevel(equip.luck and equip.luck or 0)
  self:SetBreachLevel(equip.exp, equip.level, equip.breach)
  self.skill = equip.skill
  self:SetWing(equip.wingAttr)
  self:WingGenerateAttr(equip.generateAttr)
  self.equipTime = equip.equipTime
  self:ResetExcellenceData()
  self:SetRegenerateAttributeList(equip.regenerateAttrs)
  self:SetRegenerateClearAttributeList(equip.regenerateClearAttrs)
  self:RefreshHonourAttribute(equip.honourAttr)
end

function EquipData:GetEquipExcellenceDesList()
  if self.excellenceDesList == nil or self.excellentInfoDesIsDirty == true then
    self.excellenceDesList = {}
    self.excellentInfoDesIsDirty = false
    if self.tblItem.subType == EItemSubtype.Wing then
      for k, v in pairs(self.wingAttr) do
        table.insert(self.excellenceDesList, RoleEquipUtility.GetExcellenceShowById(v))
      end
    else
      self.excellenceDesList = RoleEquipUtility.GetEquipExcellenceDesByServerInfo(self.excellentInfoTbl)
    end
  end
  return self.excellenceDesList
end

function EquipData:GetEquipExcellenceTemplateDesList()
  if self.excellenceTemplateDesList == nil or self.excellenceInfoTemplateIsDirty == true then
    self.excellenceTemplateDesList = {}
    self.excellenceInfoTemplateIsDirty = false
    if #self:GetEquipExcellenceDesList() > 0 then
      for k, v in pairs(self:GetEquipExcellenceDesList()) do
        table.insert(self.excellenceTemplateDesList, {name = v, nextIsNil = true})
      end
    end
  end
  return self.excellenceTemplateDesList
end

function EquipData:GetEquipExcellenceList()
  if self.excellenceAttrList == nil or self.excellentInfoIsDirty == true then
    self.excellenceAttrList = {}
    self.excellentInfoIsDirty = false
    if self.tblItem.subType == EItemSubtype.Wing then
      for k, v in pairs(self.wingAttr) do
        table.insert(self.excellenceAttrList, {
          des = RoleEquipUtility.GetExcellenceShowById(v),
          id = v
        })
      end
    else
      self.excellenceAttrList = RoleEquipUtility.GetEquipExcellenceByServerInfo(self.excellentInfoTbl)
    end
  end
  return self.excellenceAttrList
end

function EquipData:GetXiLianExcellenceDesList()
  if self.xiLianExcellenceDesList == nil or self.xiLianExcellenceListIsDirty then
    self.xiLianExcellenceDesList = RoleEquipUtility.GetEquipExcellenceDesByServerInfo(self.xiLianExcellenceList)
  end
  return self.xiLianExcellenceDesList
end

function EquipData:GetXiLianExcellenceTemplateDesList()
  if self.xiLianExcellenceTemplateDesList == nil or self.xiLianExcellenceListIsDirty then
    self.xiLianExcellenceTemplateDesList = {}
    self.xiLianExcellenceListIsDirty = false
    if #self:GetXiLianExcellenceDesList() > 0 then
      for k, v in pairs(self:GetXiLianExcellenceDesList()) do
        table.insert(self.xiLianExcellenceTemplateDesList, {name = v, nextIsNil = true})
      end
    end
  end
  return self.xiLianExcellenceTemplateDesList
end

function EquipData:GetExcellenceCount()
  local excellenceDesList = self:GetEquipExcellenceDesList()
  return table.count(excellenceDesList)
end

function EquipData:ResetExcellenceData()
  self.excellenceDesList = nil
  self.excellentCount = nil
  self.excellenceAttrList = nil
  self.totalExcellScore = nil
end

function EquipData:SetIntensify(intensi)
  if self.intensify ~= intensi then
    self.intensify = intensi
    self:CalcIntensifyAttr()
    return true
  end
end

function EquipData:SetAddtion(addtion, additionalAttr)
  if self.additional ~= addtion or self.additionalAttribute ~= additionalAttr then
    self.additional = addtion
    self.additionalAttribute = additionalAttr or {}
    self:CalcAddionalAttr()
    return true
  end
end

function EquipData:SetGrowUp(level)
  self.level = -1
  if self.level ~= level then
    self.level = level
    self:CalcGrowUpAttr()
    return true
  end
end

function EquipData:SetLuckIds(lucks)
  if self.luckIds ~= lucks then
    self.luckIds = lucks
    self:CalcLuckAttr()
    return true
  end
end

function EquipData:SetLuckLevel(luckLv)
  if self.luckLevel ~= luckLv then
    self.luckLevel = luckLv
    self:CalcLuckLevelAttr()
    return true
  end
end

function EquipData:SetWing(wingAttr)
  if self.wingAttr ~= wingAttr then
    self.wingAttr = wingAttr
    self:CalcWingAttr()
    return true
  end
end

function EquipData:SetBreachLevel(exp, level, breach)
  self.exp = exp
  self.level = level
  self.breach = breach
end

function EquipData:SetExcellence(exc)
  if exc and self.excellence ~= exc then
    self.excellence = exc
    self:CalcExcellenceAttr()
    return true
  end
end

function EquipData:SetNewExcellenceInfo(data)
  if data == nil then
    return
  end
  self.excellentInfoTbl = data
  self.excellentInfoDesIsDirty = true
  self.excellentInfoIsDirty = true
  self.excellenceInfoTemplateIsDirty = true
end

function EquipData:SetSpecialInfo(data)
  if data == nil then
    return
  end
  self.specialInfo = data
end

function EquipData:CalcIntensifyAttr()
  local intensifyTbl = MeEquipController.GetEquipIntensifyCfgByEquipData(self)
  intensifyTbl = AttributeConfig.GetTableAttributes(intensifyTbl)
  self.attributeMap[EEquipeAttributeProviderSystem.Intensified] = intensifyTbl
end

function EquipData:CalcAddionalAttr()
  local addtionalTbl = MeEquipController.GetEquipAddtion(self.tblItem.id, self.additional)
  addtionalTbl = addtionalTbl or MeEquipController.GetEquipAddtion(self.tblItem.subType, self.additional)
  if addtionalTbl then
    local additionAttr = AttributeConfig.GetTableAttributes(addtionalTbl)
    local result = {}
    local attrTypeStr
    for _, v in pairs(self.additionalAttribute) do
      attrTypeStr = table.getKey(EAttributeType, v)
      result[attrTypeStr] = additionAttr[attrTypeStr]
    end
    self.AdditionAttributeMap = result
    self.attributeMap[EEquipeAttributeProviderSystem.Addition] = result
  end
end

function EquipData:CalcGrowUpAttr()
  local cellIndex = tonumber(string.split(self.tblEquip.equipPosition, "#")[1])
  if RoleEquipUtility.EquipTypeUtility(cellIndex, ERoleEquipCondition.Normal) and (self.tblItem.subType == EItemSubtype.Ring or self.tblItem.subType == EItemSubtype.Earrings or self.tblItem.subType == EItemSubtype.Necklace) then
    if not self.level or not MeController.career then
      return
    end
    local growUpTbl = ConfigManager.FindConfigs("cfg_Item_equip_growUp", "level", self.level)
    local growTbl
    for i = 1, #growUpTbl do
      local currentTbl = growUpTbl[i]
      if string.contains(currentTbl.career, MeController.career) and currentTbl.type == tostring(self.tblItem.subType) then
        growTbl = currentTbl
        break
      end
    end
    if not growTbl then
      return
    end
    self.attributeMap[EEquipeAttributeProviderSystem.GrowUp] = AttributeConfig.GetTableAttributes(growTbl)
  end
end

function EquipData:CalcLuckAttr()
  self.attributeMap[EEquipeAttributeProviderSystem.Luck] = EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMap(self.luckIds)
end

function EquipData:CalcLuckLevelAttr()
  self.attributeMap[EEquipeAttributeProviderSystem.luckLevel] = EquipAttributeCalculator.GetMultiLuckLevelAttrMap(self.itemId, self.luckLevel)
end

function EquipData:CalcExcellenceAttr()
  self.attributeMap[EEquipeAttributeProviderSystem.Excellence] = EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMap(self.excellence)
  local attrTbl = self.attributeMap[EEquipeAttributeProviderSystem.Excellence]
  if self.excellence then
    attrTbl.zhuoyueAttribute = #self.excellence
  end
end

function EquipData:CalcWingAttr()
  self.attributeMap[EEquipeAttributeProviderSystem.Wing] = EquipAttributeCalculator.GetMultiExcellenceOrLuckAttrMap(self.wingAttr)
end

function EquipData:RefreshValidAttrs()
  for _, map in pairs(self.attributeMap) do
    for type, _ in pairs(map) do
      if not self:IsAtributeValid(EAttributeType[type]) then
        map[type] = 0
      end
    end
  end
end

local function MasterAdd(result, systemTab, moreAttribute)
  if ViewData.meData then
    local extra = ViewData.meData:GetAttribute(moreAttribute)
    extra = extra * 1.0E-4
    for k, v in pairs(systemTab) do
      if EAttributeType[k] and k ~= "staticMoveSpeed" then
        result[k] = result[k] or 0
        local value = v
        if type(v) == "table" then
          value = RoleManager.me ~= nil and TableParse:GetCareerAttribute(v, RoleUtility.GetBasicCareer(RoleManager.me.career)) or 0
        end
        result[k] = result[k] + value * extra
      end
    end
  end
end

function EquipData:GetAllAttributes(career)
  local attr = {}
  for _, v in pairs(self.attributeMap) do
    if _ == EEquipeAttributeProviderSystem.Intensified then
      MasterAdd(attr, v, EAttributeType.extraIntensifyAttributeIncrease)
    end
    if _ == EEquipeAttributeProviderSystem.Addition then
      MasterAdd(attr, v, EAttributeType.extraAdditionalAttributeIncrease)
    end
    if _ == EEquipeAttributeProviderSystem.Excellence then
      MasterAdd(attr, v, EAttributeType.entryRating)
    end
    attr = AttributeConfig.MergeAttributeMap(attr, v, career)
  end
  for k, v in pairs(self.tblEquip) do
    if string.contains(k, CAttributePrefixFlag.Mount_Active) then
      local keyTemp = string.replace(k, CAttributePrefixFlag.Mount_Active, "")
      attr[keyTemp] = attr[keyTemp] or 0
      attr[keyTemp] = attr[keyTemp] + v
    end
  end
  return attr
end

function EquipData:isEquiped()
  local flag = false
  if self.bagGridIndex >= 0 then
    local equip = ViewData.meData.equipsData:GetEquipByIndex(self.bagGridIndex)
    if equip then
      flag = equip.id == self.id
    end
  end
  return flag
end

function EquipData:GetAttributes(equipAttrSystem)
  return self.attributeMap[equipAttrSystem] or {}
end

function EquipData:GetMultiAttributes(equipAttrSystems)
  local result
  for _, v in pairs(equipAttrSystems) do
    result = AttributeConfig.MergeAttributeMap(result, self.attributeMap[v])
  end
  return result or {}
end

function EquipData:GetAttribute(equipAttrSystem, attrType)
  local attrMap = self:GetAttributes(equipAttrSystem)
  if type(attrType) == "number" then
    attrType = table.getKey(EAttributeType, attrType)
  end
  return attrMap[attrType]
end

function EquipData:GetGenerateAttr(attr)
  local attrType = table.getKey(EAttributeType, attr)
  if self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr] then
    return self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr][attrType]
  end
end

function EquipData:GetGenerateAttrRandom(equipData)
  local random = false
  if equipData == nil then
    return random
  end
  for i, v in pairs(EquipData.AttributeClientRandom) do
    for k, y in pairs(equipData) do
      if y.attributeName == v and y.attributeValue > 0 then
        random = true
      end
    end
  end
  return random
end

EquipData.AttributeClientRandom = {
  "maximumHealth",
  "minimumPhysBaseDmg",
  "maximumPhysBaseDmg",
  "minimumWizBaseDmg",
  "maximumWizBaseDmg",
  "maximumCurseBaseDmg",
  "minimumCurseBaseDmg",
  "defenseBase"
}
local ming = 0
local maxg = 0
local minWiz = 0
local maxWiz = 0
local minCur = 0
local maxCur = 0

function EquipData:GetGenerateAttrRandomStr(equipData)
  local random = {}
  local Dmgindex = 0
  for i, v in pairs(EquipData.AttributeClientRandom) do
    for k, y in pairs(equipData) do
      if y.attributeName == v and 0 < y.attributeValue then
        if v == "minimumPhysBaseDmg" then
          ming = y.attributeValue
        elseif v == "maximumPhysBaseDmg" then
          maxg = y.attributeValue
        elseif v == "minimumWizBaseDmg" then
          minWiz = y.attributeValue
        elseif v == "maximumWizBaseDmg" then
          maxWiz = y.attributeValue
        elseif v == "maximumCurseBaseDmg" then
          maxCur = y.attributeValue
        elseif v == "minimumCurseBaseDmg" then
          minCur = y.attributeValue
        else
          Dmgindex = Dmgindex + 1
          local des = self:GetAtterRandom(v, y.attributeValue)
          table.insert(random, Dmgindex, des)
        end
      end
    end
  end
  if 0 < maxg or 0 < ming then
    table.insert(random, 2, self:GetAtterRandom("physBaseDmgRange", ming, maxg))
    ming = 0
    maxg = 0
  end
  if 0 < maxWiz or 0 < minWiz then
    table.insert(random, 2, self:GetAtterRandom("WizBaseDmgRange", minWiz, maxWiz))
    minWiz = 0
    maxWiz = 0
  end
  if 0 < maxCur or 0 < minCur then
    table.insert(random, 2, self:GetAtterRandom("CurseBaseDmgRange", minCur, maxCur))
    minCur = 0
    maxCur = 0
  end
  return random
end

function EquipData:GetAtterRandom(attName, min, max)
  local des = AttributeWordUtil.GetUIWord(attName, "holySpiritChangeUI")
  if min ~= nil and max ~= nil and 0 <= max and 0 <= min then
    return string.format(des, min, max)
  end
  return string.format(des, min)
end

function EquipData:GetAtterRandomStr(attName, equip)
  local nowName = "random_" .. attName
  local equipInfo = equip[nowName]
  if equipInfo == nil or equipInfo == "" then
    return
  end
  if string.contains(equipInfo, "&") then
    local des = AttributeWordUtil.GetUIWord(attName, "holySpiritChangeUI")
    local min = self:RandomEquipDateMin(equipInfo)
    local max = self:RandomEquipDateMax(equipInfo)
    if 0 < min or 0 < max then
      return string.format(des, min, max)
    end
  else
    local des = AttributeWordUtil.GetUIWord(attName, "holySpiritChangeUI2")
    local min = self:RandomEquipDateMin(equipInfo)
    if 0 < min then
      return string.format(des, min)
    end
  end
  return
end

function EquipData:GetGenerateAttrNilRandomStr(equipData, itemData)
  local random = {}
  local itemdate = RoleUtility.GetBasicCareer(itemData.career)
  local equip = ClientTable.cfg_Item_equip_randomManager:GetSelectCondition(equipData.itemId, itemdate)
  if equip == nil then
    return
  end
  local Count = 0
  for i, v in pairs(EquipData.AttributeClientRandom) do
    local nowName = "random_" .. v
    local equipInfo = equip[nowName]
    if equipInfo ~= nil and equipInfo ~= "" then
      Count = Count + 1
    end
  end
  local equipSuitid = ClientTable.cfg_Item_equipManager:TryGetValue(equip.id)
  local Suitid = string.split(equipSuitid.suitId, "#")[1]
  if tonumber(Suitid) == 42010 then
    local text = string.format("#N/A", Count)
    text = string.GetColorText(text, ItemQuality2ColorDic[EItemColorEnum.blue])
    table.insert(random, text)
  end
  for i, v in pairs(EquipData.AttributeClientRandom) do
    local des = self:GetAtterRandomStr(v, equip)
    if des ~= nil then
      table.insert(random, des)
    end
  end
  return random
end

function EquipData:RandomEquipDateMin(EquipData)
  local equipData = EquipData
  if equipData == nil or equipData == "" then
    return
  end
  local RandomEquip = TableParse:SplitStringToIntListList(equipData, "&", "#")
  local Numbers = RandomEquip[1][1]
  for i, v in pairs(RandomEquip) do
    if Numbers > v[1] then
      Numbers = v[1]
    end
  end
  return Numbers
end

function EquipData:RandomEquipDateMax(EquipData)
  local equipData = EquipData
  if equipData == nil or equipData == "" then
    return
  end
  local Numbers = 0
  local RandomEquip = TableParse:SplitStringToIntListList(equipData, "&", "#")
  for i, v in pairs(RandomEquip) do
    if Numbers < v[1] then
      Numbers = v[1]
    end
  end
  return Numbers
end

function EquipData:GetEquipeShowAttribute()
  if self.additional == nil then
    self.additional = 0
  end
  if self.intensify == nil then
    self.intensify = 0
  end
  if self.intensifyKey and self.intensifyKey == string.format("%d_%d", self.intensify, self.additional) then
    return self.showTblEquip
  end
  if self.intensify == 0 and self.additional == 0 then
    return self.tblEquip
  end
  self.intensifyKey = string.format("%d_%d", self.intensify, self.additional)
  self.showTblEquip = EquipAttributeCalculator.CalcSingleEquipAttr(self)
  return self.showTblEquip
end

function EquipData:SetEquipItemData()
  self.tblEquip = ClientTable.cfg_Item_equipManager:TryGetValue(self.itemId)
  self.tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemId)
  if RoleEquipUtility.IsEquipAppearData(self.bagGridIndex) and self.bagGridIndex % 100 == ERoleEquipPosition.helm then
    self.isHaveHead = self.tblEquip.haveHead == 1 and true or false
    self.ExtraFaceModelPath = self.isHaveHead and "head/HeadClassNull" or nil
  end
  self.modelPath = RoleEquipUtility.GetEquipModelName(self)
  self.subType = self.tblItem.subType
  self.isSuit = self.tblEquip.suitId ~= ""
  self.attributeMap[EEquipeAttributeProviderSystem.EquipeBasic] = AttributeConfig.GetTableAttributes(self.tblEquip)
end

function EquipData:ValidateAttribute(attrType, valid)
  if self.invalidAttributtes[attrType] ~= valid then
    self.invalidAttributtes[attrType] = valid
    self:RefreshValidAttrs()
    return true
  end
  return false
end

function EquipData:IsAtributeValid(attrType)
  return self.invalidAttributtes[attrType]
end

function EquipData:DoWingGenerateAttr(tblJson)
  for k, v in pairs(tblJson) do
    if not self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr] then
      self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr] = {}
    end
    self.attributeMap[EEquipeAttributeProviderSystem.GenerateAttr][k] = v
  end
end

function EquipData:WingGenerateAttr(generateAttr)
  if not generateAttr then
    return
  end
  self.generateAttr = generateAttr
  local tblJson = json.decode(generateAttr)
  if generateAttr then
    self:DoWingGenerateAttr(tblJson)
  end
end

function EquipData:CalcEquipTime(deltaTime)
  local time = self.equipTime
  if time and time ~= -1 and deltaTime then
    self.equipTime = time - deltaTime * 1000
  end
end

function EquipData:CalcEquipDurability(reduce)
  if self.durability and self.durability ~= -1 and reduce then
    self.durability = self.durability - reduce
  end
end

function EquipData:SetValid(valid)
  self.valid = valid
end

function EquipData:GetBuffTbl()
  if self.buffTbl ~= nil then
    return self.buffTbl
  end
  if self.tblEquip == nil then
    return
  end
  if self.tblEquip.carryingBuff == 0 then
    return
  end
  self.buffTbl = ClientTable.cfg_Buff_buffManager:TryGetValue(self.tblEquip.carryingBuff)
  return self.buffTbl
end

function EquipData:FirstOpenPanelArgs(_indexEnum, _value)
  if _indexEnum == IndexerEnum.get then
    return self.firstOpenPanelArgs
  elseif _indexEnum == IndexerEnum.set then
    self.firstOpenPanelArgs = _value
  end
end

function EquipData:GetEquipExcellenceNum()
  if type(self.excellence) ~= "table" then
    return 0
  end
  return #self.excellence
end

function EquipData:CheckCanXiLian()
  if self.isCanXiLian == nil then
    self.isCanXiLian = ClientTable.cfg_Item_equipManager:EquipCanXiLian(self.itemId) == true and ClientTable.cfg_Item_reExcellManager:GetXiLianCostList(self.itemId) ~= nil and #self:GetEquipExcellenceDesList() > 0
  end
  return self.isCanXiLian
end

function EquipData:GetXilianCost()
  if self.xiLianCostList == nil then
    self.xiLianCostList = ClientTable.cfg_Item_reExcellManager:GetXiLianCostList(self.itemId)
  end
  return self.xiLianCostList
end

function EquipData:GetXiLianLackCostItemId()
  local costItemList = self:GetXilianCost()
  if costItemList == nil or next(costItemList) == nil then
    return
  end
  for k, v in pairs(costItemList) do
    local bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
    if bagCount < v.count then
      return v
    end
  end
end

function EquipData:SetXiLianExcellenceList(excellenceList)
  self.xiLianExcellenceList = excellenceList
  self.xiLianExcellenceListIsDirty = true
end

function EquipData:SetRegenerateAttributeList(excellenceList)
  self.RegenerateAttributeList = excellenceList
end

function EquipData:GetRegenerateNewAttributeTemplateDesList()
  local attributeValue, orginalValue
  self.regenerateNewAttributeTemplateDesList = {}
  local regenerateExcellenceList = RoleEquipUtility.GetEquipRegenerateAttribute(self.RegenerateAttributeList)
  if type(regenerateExcellenceList) == "table" and 0 < #regenerateExcellenceList then
    for index, clientItem in ipairs(regenerateExcellenceList) do
      local severItem = self.RegenerateAttributeList[index].RegenerateAttribute[1]
      if severItem then
        attributeValue = severItem.attributeValue or 0
        orginalValue = severItem.orginalValue or 0
        table.insert(self.regenerateNewAttributeTemplateDesList, {
          attributeInfo = clientItem.attributeInfo,
          configId = clientItem.configId,
          attributeValue = attributeValue,
          orginalValue = orginalValue,
          nowIndex = index,
          excellentLevel = clientItem.excellentLevel
        })
      end
    end
    return self.regenerateNewAttributeTemplateDesList
  end
end

function EquipData:GetNewAttributeList()
  return table.count(self:GetRegenerateNewAttributeTemplateDesList())
end

function EquipData:SetRegenerateClearAttributeList(excellenceClearList)
  self.RegenerateClearAttributeList = excellenceClearList
end

function EquipData:GetRegenerateClearAttributeTemplateDesList()
  self.regenerateNewAttributeTemplateDesList = {}
  local regenerateExcellenceList = RoleEquipUtility.GetEquipRegenerateAttribute(self.RegenerateClearAttributeList)
  if type(regenerateExcellenceList) == "table" and 0 < #regenerateExcellenceList then
    for k, v in pairs(regenerateExcellenceList) do
      table.insert(self.regenerateNewAttributeTemplateDesList, {
        attributeInfo = v.attributeInfo,
        configId = v.configId,
        excellentLevel = v.excellentLevel
      })
    end
  end
  return self.regenerateNewAttributeTemplateDesList
end

function EquipData:GetClearAttributeList()
  return table.count(self:GetRegenerateClearAttributeTemplateDesList())
end

function EquipData:IsHolySpiritEquip()
  return self.tblEquip and self.tblEquip.subType and self.tblEquip.subType.subType == 18
end

function EquipData:RefreshHonourAttribute(honourAttr)
  self.HonourAttribute = honourAttr
end
