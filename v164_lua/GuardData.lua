local GuardData = {}

function GuardData:Init()
  self.nowSelectType = nil
  self.GuardAttributesConfigDic = {}
  self.GlobalAttributInfoGlobleID = nil
  networkRequest.ReqGuardInfo()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
end

function GuardData:RegistEvent(type, func, data, priority)
  self.isInit = true
  if not type then
    print("event not exist")
    return
  end
  if not self.eventContainer then
    self.eventContainer = EventContainer(EventManager)
  end
  self.eventContainer:Regist(type, func, data, priority)
end

function GuardData:OnResBagChange(m)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.guard
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.guard_culture
  })
end

function GuardData:GuardDataCreatTextData()
  local GuardInfo = {}
  GuardInfo.guardList = {}
  GuardInfo.guardList[1] = {}
  GuardInfo.guardList[1].guardId = 10005
  GuardInfo.guardList[1].guardStrengthen = 0
  GuardInfo.guardList[2] = {}
  GuardInfo.guardList[2].guardId = 20000
  GuardInfo.guardList[2].guardStrengthen = 0
  GuardData:SetGuardInfo(GuardInfo)
end

function GuardData:GetDefaultGuardData()
  local data = ClientTable.cfg_Global_globalManager:GetDefaultGuardData()
  if data == nil then
    return {}
  end
  self.DefaultGuardData = {}
  for i, v in pairs(data) do
    if ConditionManager.Check4D(v.condition) == true then
      local GuardInfo = {
        guardId = v.id,
        guardType = v.type,
        guardStrengthen = 0,
        intGuardAppearance = 0,
        activeState = 0
      }
      table.insert(self.DefaultGuardData, GuardInfo)
    end
  end
  return self.DefaultGuardData
end

function GuardData:GetShowGuardData(data)
  local defGuardData = self:GetDefaultGuardData()
  if data == nil or data.guardList == nil then
    return defGuardData
  end
  local serverData = {}
  for i, v in pairs(data.guardList) do
    serverData[v.guardType] = v
  end
  for i, v in pairs(defGuardData) do
    if serverData[v.guardType] ~= nil then
      defGuardData[i] = serverData[v.guardType]
    end
  end
  return defGuardData
end

function GuardData:SetGuardInfo(data)
  if data == nil then
    return
  end
  local guardList = GuardData:GetShowGuardData(data)
  self.GuardInfoList = {}
  self.GuardCultureInfoList = {}
  self.GuardInfoDic_Type = {}
  if guardList ~= nil then
    for i, v in pairs(guardList) do
      local GuardInfoItem = {}
      GuardInfoItem.id = v.guardId
      GuardInfoItem.guardStrengthen = v.guardStrengthen == 1
      GuardInfoItem.isWear = v.intGuardAppearance == 1
      GuardInfoItem.nowtable = ClientTable.cfg_Equip_guard_levelManager:TryGetValue(v.guardId)
      if GuardInfoItem.nowtable ~= nil then
        GuardInfoItem.nextTable = ClientTable.cfg_Equip_guard_levelManager:TryGetValue(GuardInfoItem.nowtable.nextId)
        GuardInfoItem.IsNeedJiHuo = v.activeState ~= 1
        GuardInfoItem.strengthenEquipInfo = ClientTable.cfg_Item_equipManager:TryGetValue(GuardInfoItem.nowtable.strengthenModel)
        table.insert(self.GuardInfoList, GuardInfoItem)
        GuardInfoItem.isCultureJiHuo = v.cultureState == 1
        if GuardInfoItem.isCultureJiHuo then
          GuardInfoItem.cultureExp = v.cultureExp
          GuardInfoItem.cultureLevel = v.cultureLevel
          local cultureId = GuardInfoItem.nowtable.petType * 10000 + GuardInfoItem.cultureLevel
          GuardInfoItem.nowTableCulture = ClientTable.cfg_Guard_cultureManager:TryGetValue(cultureId)
          if GuardInfoItem.nowTableCulture then
            GuardInfoItem.nextTableCulture = ClientTable.cfg_Guard_cultureManager:TryGetValue(GuardInfoItem.nowTableCulture.nextid)
          end
          table.insert(self.GuardCultureInfoList, GuardInfoItem)
        end
        self.GuardInfoDic_Type[GuardInfoItem.nowtable.petType] = GuardInfoItem
      end
    end
  end
  EventManager.Dispatch(Event.Guard_InfoChange)
end

function GuardData:GetGuardInfoList()
  if self.GuardInfoList == nil then
    self.GuardInfoList = {}
  end
  local guardInfoList = {}
  for i, v in ipairs(self.GuardInfoList) do
    if i <= 3 then
      table.insert(guardInfoList, v)
    end
  end
  return guardInfoList
end

function GuardData:GetAllGuardInfoList()
  if self.GuardInfoList == nil then
    self.GuardInfoList = {}
  end
  return self.GuardInfoList
end

function GuardData:GetAllActiveGuardInfoList()
  if self.GuardInfoList == nil then
    self.GuardInfoList = {}
    return self.GuardInfoList
  end
  local activeGuardList = {}
  for i, v in ipairs(self.GuardInfoList) do
    if not v.IsNeedJiHuo then
      table.insert(activeGuardList, v)
    end
  end
  return activeGuardList
end

function GuardData:GetGuardInfoDic()
  if self.GuardInfoDic_Type == nil then
    self.GuardInfoDic_Type = {}
  end
  return self.GuardInfoDic_Type
end

function GuardData:GetGuardCultureInfoList()
  if self.GuardCultureInfoList == nil then
    self.GuardCultureInfoList = {}
  end
  return self.GuardCultureInfoList
end

function GuardData:GetAttributesShowInfo(GuardInfoItem, AttributesConfig)
  local des = ""
  local nowDes = ""
  local nextDes = ""
  local StrengthenDes = ""
  local itemName = ""
  local guardTipsUI = ""
  if GuardInfoItem == nil then
    return des, nowDes, nextDes, StrengthenDes, itemName
  end
  local attributeTable = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(AttributesConfig.mainName)
  if attributeTable ~= nil then
    des = attributeTable.equipIntensifyUI
    guardTipsUI = attributeTable.GuardTipsUI
  end
  if GuardInfoItem.nowtable then
    nowDes = self:GetShowAttributesDes(GuardInfoItem.nowtable, AttributesConfig)
    itemName = GuardInfoItem.nowtable.itemName
  end
  if GuardInfoItem.nextTable then
    nextDes = self:GetShowAttributesDes(GuardInfoItem.nextTable, AttributesConfig)
  else
    nextDes = "Max"
  end
  if GuardInfoItem.guardStrengthen and GuardInfoItem.strengthenEquipInfo ~= nil then
    local nowAttributesConfig = {
      mainName = AttributesConfig.mainName,
      modulus = AttributesConfig.modulus
    }
    if nowAttributesConfig.mainName == "damageAbsorption" then
      nowAttributesConfig.mainName = "display_damageAbsorption"
    end
    local strengthennumber = self:GetShowAttributesDes(GuardInfoItem.strengthenEquipInfo, nowAttributesConfig)
    StrengthenDes = strengthennumber
  end
  if GuardInfoItem.nowtable then
    if GuardInfoItem.guardStrengthen and GuardInfoItem.strengthenEquipInfo ~= nil then
      itemName = GuardInfoItem.nowtable.changeName
    else
      itemName = GuardInfoItem.nowtable.name
    end
  end
  return des, nowDes, nextDes, StrengthenDes, itemName
end

function GuardData:GetCultureAttributesShowInfo(GuardInfoItem, AttributesConfig)
  local des = ""
  local nowDes = ""
  local nextDes = ""
  if GuardInfoItem == nil then
    return des, nowDes, nextDes
  end
  local attributeTable = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(AttributesConfig.mainName)
  if attributeTable ~= nil then
    des = attributeTable.equipIntensifyUI
  end
  if GuardInfoItem.nowTableCulture then
    nowDes = self:GetShowAttributesDes(GuardInfoItem.nowTableCulture, AttributesConfig)
  end
  if GuardInfoItem.nextTableCulture then
    nextDes = self:GetShowAttributesDes(GuardInfoItem.nextTableCulture, AttributesConfig)
  else
    nextDes = "Max"
  end
  return des, nowDes, nextDes
end

function GuardData:GetShowAttributesDes(cfg_Equip_guard_level, AttributesConfig)
  if cfg_Equip_guard_level == nil or AttributesConfig == nil then
    return ""
  end
  local now = self:GetChangeEquip_guard_levelNumber(cfg_Equip_guard_level[AttributesConfig.mainName])
  if AttributesConfig.subName ~= nil then
  end
  local nowsub = cfg_Equip_guard_level[AttributesConfig.subName]
  local Symbol = tonumber(AttributesConfig.modulus) == 1 and "" or "%"
  local nowMainNumber = self:GetAttributesNumber(now, AttributesConfig.modulus)
  local nowSubNumber = self:GetAttributesNumber(nowsub, AttributesConfig.modulus)
  if nowsub == nil then
    return nowMainNumber .. Symbol
  else
    return nowMainNumber .. " - " .. nowSubNumber .. Symbol
  end
end

function GuardData:GetChangeEquip_guard_levelNumber(now)
  if type(now) == "table" then
    for k, condition in pairs(now) do
      if #condition == 2 and RoleUtility.CareerJudge(ViewData.meData.career, condition[1]) then
        return tonumber(condition[2])
      end
    end
  else
    return now
  end
end

function GuardData:GetAttributesNumber(Attribute, modulus)
  if Attribute ~= nil and tonumber(Attribute) ~= nil and modulus ~= nil then
    local number = math.fmod(tonumber(Attribute), tonumber(modulus))
    if number == 0 then
      return math.modf(tonumber(Attribute) / tonumber(modulus))
    else
      return tonumber(Attribute) / tonumber(modulus)
    end
  end
  return ""
end

function GuardData:GetGuardAttributesConfigList(isTipsInfo)
  local panelShowID = self:GetGlobalAttributInfoGlobleID()
  local gloableID = isTipsInfo and 2190102 or panelShowID
  if self.GuardAttributesConfigDic[gloableID] ~= nil then
    return self.GuardAttributesConfigDic[gloableID]
  end
  local globle = ClientTable.cfg_Global_globalManager:TryGetValue(gloableID)
  if globle == nil then
    return {}
  end
  self.GuardAttributesConfigDic[gloableID] = {}
  local AttributesNameList = string.split(globle.effect, "&")
  for i, v in pairs(AttributesNameList) do
    local temp = string.split(v, "#")
    if #temp == 2 then
      local nametemp = string.split(temp[1], "^")
      local mainName = nametemp[1]
      local GuardAttributesConfig = {
        mainName = nametemp[1],
        subName = nametemp[2],
        modulus = temp[2]
      }
      table.insert(self.GuardAttributesConfigDic[gloableID], GuardAttributesConfig)
    end
  end
  return self.GuardAttributesConfigDic[gloableID]
end

function GuardData:GetGlobalAttributInfoGlobleID()
  if self.GlobalAttributInfoGlobleID ~= nil then
    return self.GlobalAttributInfoGlobleID
  end
  local globle = ClientTable.cfg_Global_globalManager:TryGetValue(2190103)
  if globle == nil then
    return {}
  end
  local AttributesNameList = string.split(globle.effect, "&")
  for i, v in pairs(AttributesNameList) do
    local temp1 = string.split(v, "#")
    if #temp1 == 2 then
      local isNeed = false
      local temp1 = string.split(v, "#")
      local conditionS = string.split(temp1[1], "_")
      for k, condition in pairs(conditionS) do
        if RoleUtility.CareerJudge(ViewData.meData.career, condition) then
          isNeed = true
        end
      end
      if isNeed then
        self.GlobalAttributInfoGlobleID = tonumber(temp1[2])
        return self.GlobalAttributInfoGlobleID
      end
    end
  end
  return 0
end

function GuardData:GetAttributesShowInfoList(GuardInfoItem, isTipsInfo)
  local dataList = {}
  local AttributesNameList = self:GetGuardAttributesConfigList(isTipsInfo)
  for i, v in pairs(AttributesNameList) do
    local GuardInfoItemAttributes = {}
    GuardInfoItemAttributes.GuardInfoItem = GuardInfoItem
    GuardInfoItemAttributes.AttributesName = v
    local isNeedAddAttributes = self:IsAttributesNotNil(GuardInfoItem.nowtable, GuardInfoItem.nextTable, v.mainName)
    if isNeedAddAttributes then
      table.insert(dataList, GuardInfoItemAttributes)
    end
  end
  return dataList
end

function GuardData:GetCultureAttributesShowInfoList(GuardInfoItem)
  local dataList = {}
  local AttributesNameList = self:GetGuardAttributesConfigList()
  for i, v in pairs(AttributesNameList) do
    local GuardInfoItemAttributes = {}
    GuardInfoItemAttributes.GuardInfoItem = GuardInfoItem
    GuardInfoItemAttributes.AttributesName = v
    local isNeedAddAttributes = self:IsAttributesNotNil(GuardInfoItem.nowTableCulture, GuardInfoItem.nextTableCulture, v.mainName)
    if isNeedAddAttributes then
      table.insert(dataList, GuardInfoItemAttributes)
    end
  end
  return dataList
end

function GuardData:IsAttributesNotNil(nowtable, nextTable, AttributesName)
  if nowtable ~= nil then
    local nowDesIsNotNil = nowtable[AttributesName] ~= "" and nowtable[AttributesName] ~= nil and nowtable[AttributesName] ~= 0
    if nextTable ~= nil then
      local nextDesIsNotNil = nextTable[AttributesName] ~= "" and nextTable[AttributesName] ~= nil and nextTable[AttributesName] ~= 0
      return nowDesIsNotNil or nextDesIsNotNil
    else
      return nowDesIsNotNil
    end
  end
  return false
end

function GuardData:GetConsumeMaterialList(GuardInfoItem)
  if GuardInfoItem == nil then
    return
  end
  if GuardInfoItem.nowtable == nil then
    return
  end
  local cost = {}
  if GuardInfoItem.IsNeedJiHuo then
    cost = GuardInfoItem.nowtable.cost
  elseif GuardInfoItem.nextTable ~= nil then
    cost = GuardInfoItem.nextTable.cost
  else
    return {}
  end
  local dataList = {}
  local str = string.split(cost, "&")
  if str == nil then
    return
  end
  for i, v in pairs(str) do
    local str2 = string.split(v, "#")
    local data = {}
    data.ItemID = tonumber(str2[1])
    data.Count = tonumber(str2[2])
    table.insert(dataList, data)
  end
  return dataList
end

function GuardData:GetCultureConsumeMaterialList()
  local cost = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(21100001)
  if string.isNullOrEmpty(cost) then
    return
  end
  local dataList = {}
  local str = string.split(cost, "&")
  for i, v in ipairs(str) do
    local str2 = string.split(v, "#")
    local data = {}
    data.ItemID = tonumber(str2[1])
    data.Exp = tonumber(str2[2])
    table.insert(dataList, data)
  end
  return dataList
end

function GuardData:TryGetDissatisfyConsumeMaterial()
  local tableList = self:GetConsumeMaterialList(self:GetNowSelectGuarItem())
  if tableList == nil then
    return false
  end
  local dissatisfyConsumeMaterialId
  for i, v in pairs(tableList) do
    local itemData = ItemUtility.GenerateItemData(v.ItemID)
    local bagCount = BagInfoData.GetItemTotalCountByItemId(v.ItemID)
    if bagCount < v.Count then
      return true, v.ItemID
    end
  end
  return false
end

function GuardData:GetNowSelectGuarItem()
  if self.nowSelectType == nil then
    return self:SelectGuarItem()
  end
  return self.GuardInfoDic_Type[self.nowSelectType]
end

function GuardData:SelectGuarItem(type)
  if self.GuardInfoDic_Type == nil then
    return
  end
  if type == nil then
    for i, v in pairs(self.GuardInfoDic_Type) do
      self.nowSelectType = i
      return v
    end
  end
  self.nowSelectType = type
  return self.GuardInfoDic_Type[self.nowSelectType]
end

function GuardData:GetTipShowData()
  local dataList = self:GetGuardInfoList()
  if dataList == nil then
    return
  end
  local tabkeData = {}
  local TableType = {}
  for i, v in pairs(dataList) do
    local InfoList = self:GetAttributesShowInfoList(v, true)
    if InfoList ~= nil then
      for i, v in pairs(InfoList) do
        local des, nowDes, nextDes, StrengthenDes, itemName = self:GetAttributesShowInfo(v.GuardInfoItem, v.AttributesName)
        local TipGuardData_Attributes = {}
        TipGuardData_Attributes.GuardInfoItem = v.GuardInfoItem
        local showInfo = self:GetuiWordAttributesTipDes(StrengthenDes)
        if v.GuardInfoItem.IsNeedJiHuo == true and v.GuardInfoItem.guardStrengthen then
          nowDes = "0% "
        end
        TipGuardData_Attributes.des = string.format(showInfo, itemName, des, nowDes, StrengthenDes)
        if v.GuardInfoItem ~= nil and v.GuardInfoItem.nowtable ~= nil and TableType[v.GuardInfoItem.nowtable.petType] == nil then
          TipGuardData_Attributes.IsStart = true
          TableType[v.GuardInfoItem.nowtable.petType] = true
        else
          TipGuardData_Attributes.IsStart = false
        end
        if v.GuardInfoItem ~= nil and v.GuardInfoItem.nowtable ~= nil and (v.GuardInfoItem.IsNeedJiHuo == false or v.GuardInfoItem.guardStrengthen) then
          table.insert(tabkeData, TipGuardData_Attributes)
        end
      end
    end
  end
  return tabkeData
end

function GuardData:GetuiWordAttributesTipDes(StrengthenDes)
  local key = "Guard01"
  if StrengthenDes == "" then
    key = "Guard02"
  end
  local data = ClientTable.cfg_Ui_wordManager:TryGetValue(key)
  if data ~= nil then
    self.uiWordAttributesTipDes = data.content
    return self.uiWordAttributesTipDes
  end
  return ""
end

function GuardData:IsNeedShowGuardRed()
  if self.GuardInfoList == nil or #self.GuardInfoList == 0 then
    return false
  end
  for i, v in pairs(self.GuardInfoList) do
    if v.nextTable ~= nil then
      local tableList = self:GetConsumeMaterialList(v)
      local ismeetUpgrade = true
      for i, v in pairs(tableList) do
        local bagCount = BagInfoData.GetItemTotalCountByItemId(v.ItemID)
        if bagCount < v.Count then
          ismeetUpgrade = false
        end
      end
      if ismeetUpgrade then
        return true
      end
    end
  end
  return false
end

function GuardData:IsNeedUpLevel(nowType)
  if self.GuardInfoDic_Type == nil then
    return false
  end
  local guard = self.GuardInfoDic_Type[nowType]
  if guard == nil or guard.nextTable == nil then
    return false
  end
  local tableList = self:GetConsumeMaterialList(guard)
  local ismeetUpgrade = true
  for i, v in pairs(tableList) do
    local bagCount = BagInfoData.GetItemTotalCountByItemId(v.ItemID)
    if bagCount < v.Count then
      ismeetUpgrade = false
    end
  end
  if ismeetUpgrade then
    return true
  end
end

function GuardData:IsNeedShowGuardEquipRed()
  return false
end

function GuardData:IsNeedShowGuardCultureRed()
  if self.GuardCultureInfoList == nil or #self.GuardCultureInfoList == 0 then
    return false
  end
  local isMeetUpgrade = false
  local tableList = self:GetCultureConsumeMaterialList()
  for i, v in ipairs(tableList) do
    if 0 < BagInfoData.GetItemTotalCountByItemId(v.ItemID) then
      isMeetUpgrade = true
      break
    end
  end
  return isMeetUpgrade
end

function GuardData:IsNeedUsePopPrompt(itemID)
  local GuardStrengthenItemTypeDic = self:GetGuardStrengthenItemTypeDic()
  if GuardStrengthenItemTypeDic ~= nil and GuardStrengthenItemTypeDic[itemID] ~= nil then
    local guideInfo = ClientTable.cfg_Equip_guard_levelManager:TryGetValue(itemID, "model")
    if guideInfo ~= nil and guideInfo.strengthenModel == 0 then
      return true, true, guideInfo.id
    end
    return true, true, nil
  end
  local GuardItemTypeDic = self:GetGuardItemTypeDic()
  if GuardItemTypeDic == nil then
    return false, false, nil
  end
  local nowItemtype = GuardItemTypeDic[itemID]
  if nowItemtype == nil then
    return false, false, nil
  end
  if self.GuardInfoDic_Type == nil then
    return false, false, nil
  end
  local GuardInfo = self.GuardInfoDic_Type[nowItemtype]
  if GuardInfo == nil then
    return false, false, nil
  end
  if GuardInfo.IsNeedJiHuo == true then
    return true, false, nil
  end
  return false, false, nil
end

function GuardData:GetGuardItemTypeDic()
  if self.GuardItemTypeDic ~= nil then
    return self.GuardItemTypeDic
  end
  self.GuardItemTypeDic = self:GetGuardItemTypeAnalyze(21100003)
  return self.GuardItemTypeDic
end

function GuardData:GetGuardStrengthenItemTypeDic()
  if self.GuardStrengthenItemTypeDic ~= nil then
    return self.GuardStrengthenItemTypeDic
  end
  self.GuardStrengthenItemTypeDic = self:GetGuardItemTypeAnalyze(21100004)
  return self.GuardStrengthenItemTypeDic
end

function GuardData:GetGuardItemTypeAnalyze(id)
  local GuardItemTypeDic = {}
  local cfg_data = ClientTable.cfg_Global_globalManager:TryGetValue(id)
  if cfg_data == nil then
    return {}
  end
  local data = string.split(cfg_data.effect, "&")
  for i, v in pairs(data) do
    local temp = string.split(v, "#")
    if #temp == 2 then
      GuardItemTypeDic[tonumber(temp[1])] = tonumber(temp[2])
    end
  end
  return GuardItemTypeDic
end

function GuardData:IsSatisfyStrengthenCondition(GuardType)
  local dic = self:GetStrengthenConditionDic()
  if dic == nil then
    return true
  end
  local condition = dic[GuardType]
  if condition == nil then
    return true
  end
  return ConditionManager.Check4D(condition)
end

function GuardData:GetStrengthenConditionDic()
  if self.StrengthenConditionDic ~= nil then
    return self.StrengthenConditionDic
  end
  local StrengthenConditionDic = {}
  local cfg_data = ClientTable.cfg_Global_globalManager:TryGetValue(21100005)
  if cfg_data == nil then
    return {}
  end
  local data = string.split(cfg_data.effect, "_")
  for i, v in pairs(data) do
    local temp = string.split(v, "^")
    if #temp == 2 then
      StrengthenConditionDic[tonumber(temp[1])] = temp[2]
    end
  end
  self.StrengthenConditionDic = StrengthenConditionDic
  return StrengthenConditionDic
end

function GuardData:CancelNowSelect()
  self.nowSelectType = nil
end

function GuardData:GetGuardInfoByType(_guardType)
  if self.GuardInfoDic_Type == nil or self.GuardInfoDic_Type[_guardType] == nil then
    return
  end
  local guardInfo = self.GuardInfoDic_Type[_guardType]
  if guardInfo == nil then
    return
  end
  local petLevel = guardInfo.nowtable.petLevel
  local param = {
    isEnable = guardInfo.IsNeedJiHuo == false,
    petLevel = petLevel
  }
  return param
end

function GuardData:IsNotJiHuoGuardByItemId(_itemId)
  if self.GuardInfoList == nil then
    return false
  end
  for i, guardInfo in pairs(self.GuardInfoList) do
    if guardInfo.nowtable.model == _itemId and guardInfo.IsNeedJiHuo == false then
      return true
    end
  end
  return false
end

return GuardData
