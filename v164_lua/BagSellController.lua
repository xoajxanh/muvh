require("GameModel/BagSell/BagSellData")
BagSellController = {}
local this = BagSellController

function BagSellController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function BagSellController.RegistMessages()
end

function BagSellController.RefrashRecycleConfigDic()
  BagSellData:RefrashRecycleConfigDic()
end

function BagSellController.GetShowSellConfigDataList()
  return BagSellData:GetShowSellConfigDataList()
end

function BagSellController:RecycleConfigAutoChoose(id)
  if type(id) ~= "number" then
    return false
  end
  local sellConfigTbl = ClientTable.cfg_Item_sellConfigManager:TryGetValue(id)
  if sellConfigTbl == nil then
    return false
  end
  return ConditionManager.Check4D(sellConfigTbl.selectedcondition)
end

function BagSellController:RecycleConfigShow(id)
  if type(id) ~= "number" then
    return false
  end
  local sellConfigTbl = ClientTable.cfg_Item_sellConfigManager:TryGetValue(id)
  if sellConfigTbl == nil then
    return false
  end
  return ConditionManager.Check4D(sellConfigTbl.condition)
end

function BagSellController:CheckItemIsRecycle(itemData)
  if not self:ChooseDefaultRecycle(itemData) then
    return false
  end
  local sellTypeArr = string.split(itemData.tblItem.sellType, "#")
  for i, v in ipairs(sellTypeArr) do
    if self:ChooseRecycleConfigListCheck(itemData, v) == false then
      return false
    end
  end
  return true
end

function BagSellController:ChooseDefaultRecycle(itemData)
  if itemData == nil or itemData.tblItem == nil then
    return false
  end
  if itemData.tblItem.autoSell == 1 then
    return false
  end
  if itemData.tblItem.type == EItemType.Equipe then
    local upState = RoleEquipUtility.CanUpFight(itemData)
    if RoleManager.me == nil then
      return false
    end
    if self:IntensifyCheck(itemData, 1) then
      return false
    end
    if self:AdditionalCheck(itemData, 1) then
      return false
    end
  end
  return true
end

function BagSellController:ChooseRecycleConfigListCheck(itemData, sellType)
  if itemData == nil then
    return false
  end
  local newSellTypes = string.split(itemData.tblItem.newSellType, "&")
  local configs = ClientTable.cfg_Item_sellConfigManager:GetDic()
  local chooseConfigs = {}
  for i, v in ipairs(configs) do
    if v.sellType == sellType and self.CheckBagSellInfoUITogIsChoose(v.sellId) and self.CheckSellConfigUITogConfigByIdIsChoose(v.sellId, v.id) then
      if chooseConfigs[v.sellId] == nil then
        chooseConfigs[v.sellId] = {}
      end
      table.insert(chooseConfigs[v.sellId], v)
    end
  end
  for i, v in pairs(chooseConfigs) do
    if self:ChooseRecycleConfigSellIdGroup(itemData, sellType, v, newSellTypes) then
      return true
    end
  end
  return false
end

function BagSellController:ChooseRecycleConfigSellIdGroup(itemData, sellType, configs, newSellTypes)
  local passCount = 0
  for i, v in pairs(configs) do
    local togConfig = BagSellData:GetCurrRecycleTogConfigById(v.sellId, v.id)
    if self.ChooseNewSellTypes(newSellTypes, v.newSellType) and self:ChooseRecycleConfigCheck(itemData, v, togConfig.param1) then
      passCount = passCount + 1
    end
  end
  if passCount >= table.count(newSellTypes) and 1 <= passCount then
    return true
  end
  return false
end

function BagSellController.ChooseNewSellTypes(newSellTypes, newSellType)
  if table.contains(newSellTypes, newSellType) then
    return true
  end
  if table.count(newSellTypes) == 0 then
    return true
  end
  if string.isNullOrEmpty(newSellType) then
    return true
  end
  return false
end

function BagSellController:ChooseRecycleConfigCheck(itemData, config, param)
  if itemData == nil or config == nil then
    return false
  end
  local result = false
  if config.sellId == 1 then
    result = self:ExcellenceCountCheck(itemData, 0)
  elseif config.sellId == 2 then
    result = self:ExcellenceCountCheck(itemData, 1)
  elseif config.sellId == 3 then
    result = self:ExcellenceCountCheck(itemData, 2)
  elseif config.sellId == 4 then
    result = self:ExcellenceCountCheck(itemData, 3)
  elseif config.sellId == 5 then
    result = self:ExcellenceCountCheck(itemData, 4)
  elseif config.sellId == 6 then
    result = self:DrugCheck(itemData, 1)
  elseif config.sellId == 7 then
    result = self:ItemSubTypeCheck(itemData, EItemSubtype.skillBook)
  elseif config.sellId == 8 then
  elseif config.sellId == 9 then
  elseif config.sellId == 10 then
  end
  if not result then
    return false
  end
  if config.paramtype == RecycleParamType.Switch then
    result = true
  elseif config.paramtype == RecycleParamType.EquipOrder then
    result = self:EquipClassCheck(itemData, RecycleEquipClassType.LessEqual, tonumber(param))
  end
  if ItemUtility.IsEquipType(itemData.tblItem.type) then
    if not result then
      return false
    end
    if not self:WearUpFightTog(itemData, config, false) then
      result = false
    end
  end
  if not result then
    return false
  end
  return true
end

function BagSellController:WearUpFightTog(itemData, config, param)
  if self.CheckUpFightById(config.sellId, config.id) == param then
    local upState = RoleEquipUtility.CanUpFight(itemData)
    if (upState == EquipUpState.CanWearUpFight or upState == EquipUpState.CantWearUpFight) and RoleManager.me.level < tonumber(GlobalConfig.GetGlobalConfig(2140025)) then
      return false
    end
    return true
  end
  return true
end

function BagSellController:SwitchCheck(itemData, recycleParams)
  return tonumber(recycleParams) == 1
end

function BagSellController:ExcellenceCountCheck(itemData, recycleParams)
  if itemData == nil then
    return false
  end
  return itemData:GetExcellenceCount() == tonumber(recycleParams)
end

function BagSellController:IntensifyCheck(itemData, recycleParams)
  if itemData == nil or type(itemData.intensify) ~= "number" then
    return false
  end
  local params = tonumber(recycleParams)
  if params == 1 then
    return itemData.intensify > 0
  elseif params == 0 then
    return itemData.intensify == 0
  end
  return false
end

function BagSellController:AdditionalCheck(itemData, recycleParams)
  if itemData == nil or type(itemData.additional) ~= "number" then
    return false
  end
  local params = tonumber(recycleParams)
  if params == 1 then
    return itemData.additional > 0
  elseif params == 0 then
    return itemData.additional == 0
  end
  return false
end

function BagSellController:SuitTypeCheck(itemData, recycleParams)
  if itemData == nil then
    return false
  end
  local suitType = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSuitTypeByItemId(itemData.tblItem.id)
  return suitType == tonumber(recycleParams)
end

function BagSellController:CareerDifferentCheck(itemData, recycleParams)
  if itemData == nil then
    return false
  end
  local careerCanUseItem = RoleEquipUtility.CheckCareerEquip(itemData.tblItem.id, ViewData.meData.career)
  careerCanUseItem = careerCanUseItem == true and 1 or 0
  return careerCanUseItem == tonumber(recycleParams)
end

function BagSellController:EquipClassCheck(itemData, equipClassType, recycleParams)
  if itemData == nil or itemData.tblEquip == nil or string.isNullOrEmpty(itemData.tblEquip.equipPosition) then
    return false
  end
  if equipClassType == RecycleEquipClassType.Less and recycleParams > itemData.tblEquip.equipClass or equipClassType == RecycleEquipClassType.Equal and itemData.tblEquip.equipClass == recycleParams or equipClassType == RecycleEquipClassType.Greater and recycleParams < itemData.tblEquip.equipClass or equipClassType == RecycleEquipClassType.LessEqual and recycleParams >= itemData.tblEquip.equipClass or equipClassType == RecycleEquipClassType.GreaterEqual and recycleParams <= itemData.tblEquip.equipClass then
    return true
  end
  return false
end

function BagSellController:IntensifyAndAdditionalCheck(itemData, recycleParams)
  if itemData == nil then
    return false
  end
  local IsAnd, paramList, splitFont = string.contains(recycleParams, "&")
  if IsAnd then
    splitFont = "&"
  else
    splitFont = "\\"
  end
  paramList = string.split(recycleParams, splitFont)
  if #paramList < 2 then
    return false
  end
  local intensifyCheck = self:IntensifyCheck(itemData, paramList[1])
  local additional = self:AdditionalCheck(itemData, paramList[2])
  if IsAnd then
    return intensifyCheck and additional
  else
    return intensifyCheck or additional
  end
  return false
end

function BagSellController:DrugCheck(itemData, recycleParams)
  local openType = tonumber(recycleParams)
  if openType == 1 and (table.contains(BagInfoData.RedMedicineItemIds, itemData.itemId) or table.contains(BagInfoData.BlueMedicineItemIds, itemData.itemId)) then
    return BagInfoData.JudgeMedicineItemIdRecycle(itemData.itemId)
  end
  return false
end

function BagSellController:ItemSubTypeCheck(itemData, recycleParams)
  if itemData == nil then
    return false
  end
  return itemData.tblItem.subType == tonumber(recycleParams)
end

function BagSellController:GetRecycleConditionParam(id)
  if type(id) ~= "number" then
    return
  end
  local sellConfigTbl = ClientTable.cfg_Item_sellConfigManager:TryGetValue(id)
  if sellConfigTbl == nil then
    return
  end
  local conditionTbl = {}
  conditionTbl.type = sellConfigTbl.type
  conditionTbl.subType = sellConfigTbl.subType
  local paramTypeList, paramList
  if string.isNullOrEmpty(sellConfigTbl.paramtype) == false then
    paramTypeList = string.split(sellConfigTbl.paramtype, "#")
    for i = 1, #paramTypeList do
      paramTypeList[i] = tonumber(paramTypeList[i])
    end
  end
  if string.isNullOrEmpty(sellConfigTbl.param1) == false then
    paramList = string.split(sellConfigTbl.param1, "#")
  end
  if paramTypeList then
    for i = 1, #paramTypeList do
      local paramType = paramTypeList[i]
      local param = paramList ~= nil and paramList[i]
      if paramType == RecycleConditionParamType.ExcellenceCount and param then
        conditionTbl.excellenceCount = tonumber(param)
      elseif paramType == RecycleConditionParamType.Excellence and param then
        conditionTbl.excellence = tonumber(param)
      elseif paramType == RecycleConditionParamType.Intensify and param then
        conditionTbl.intensify = tonumber(param)
      elseif paramType == RecycleConditionParamType.Additional and param then
        conditionTbl.additional = tonumber(param)
      elseif paramType == RecycleConditionParamType.SuitType and param then
        conditionTbl.suitType = tonumber(param)
      elseif paramType == RecycleConditionParamType.CareerDifferent then
        conditionTbl.career = ViewData.meData.career
      elseif paramType == RecycleConditionParamType.EquipClass then
        conditionTbl.equipClassType = tonumber(param)
      end
    end
  end
  return conditionTbl
end

function BagSellController.SetSellInfoTogStatus(sellId, status)
  if sellId == nil or status == nil then
    return
  end
  local config = BagSellData:GetBagSellInfoUITogConfigBySellId(sellId)
  if config then
    if table.count(config.configs) == 1 then
      for i, v in pairs(config.configs) do
        v.right = status
      end
    end
    config.right = status
    EventManager.Dispatch(Event.Bag_RefreshShowSell)
    EventManager.Dispatch(Event.Bag_RefreshSellSelect)
  end
end

function BagSellController.SetSellInfoConfigTogStatus(sellId, id, status)
  if sellId == nil or id == nil or status == nil then
    return
  end
  local config = BagSellData:GetCurrRecycleTogConfigById(sellId, id)
  if config then
    config.right = status
    EventManager.Dispatch(Event.Bag_RefreshShowSell)
    EventManager.Dispatch(Event.Bag_RefreshSellSelect)
  end
end

function BagSellController.SetSellInfoConfigAllTogStatus(sellId, status)
  if sellId == nil or status == nil then
    return
  end
  local configs = BagSellData:GetBagSellInfoUITogConfigBySellId(sellId)
  if configs and configs.configs then
    for i, config in pairs(configs.configs) do
      config.right = status
    end
  end
  EventManager.Dispatch(Event.Bag_RefreshShowSell)
  EventManager.Dispatch(Event.Bag_RefreshSellSelect)
end

function BagSellController.SetSellInfoConfigOption(sellId, id, option)
  if sellId == nil or id == nil or option == nil then
    return
  end
  local config = BagSellData:GetCurrRecycleTogConfigById(sellId, id)
  if config then
    config.param1 = tonumber(option) + 1
    EventManager.Dispatch(Event.Bag_RefreshShowSell)
    EventManager.Dispatch(Event.Bag_RefreshSellSelect)
  end
end

function BagSellController.SetSellInfoConfigAllOption(sellId, option)
  if sellId == nil or option == nil or tonumber(option) < 0 then
    return
  end
  local configs = BagSellData:GetBagSellInfoUITogConfigBySellId(sellId)
  if configs and configs.configs then
    for i, config in pairs(configs.configs) do
      config.param1 = tonumber(option) + 1
    end
  end
  EventManager.Dispatch(Event.Bag_RefreshShowSell)
  EventManager.Dispatch(Event.Bag_RefreshSellSelect)
end

function BagSellController.CheckSellConfigUIAllTogConfig(sellId)
  if sellId == nil then
    return
  end
  local configs = BagSellData:GetBagSellInfoUITogConfigBySellId(sellId)
  if configs and configs.configs then
    for i, config in pairs(configs.configs) do
      if config.right ~= true then
        return false
      end
    end
    return true
  end
  return false
end

function BagSellController.GetCurrRecycleTogConfig()
  return BagSellData:GetCurrRecycleTogConfig()
end

function BagSellController.InitCurrRecycleTogConfig(configs)
  BagSellData.RecycleConfigDic = {}
  BagSellData.currRecycleTogConfig = configs
  BagSellData:TryInitRecycleConfigDic()
end

function BagSellController.GetParamtypeTypeOptions(paramType)
  return BagSellData:GetParamtypeTypeOptions(paramType)
end

function BagSellController.CheckBagSellInfoUITogIsChoose(SellId)
  return BagSellData:CheckBagSellInfoUITogIsChoose(SellId)
end

function BagSellController.GetBagSellInfoUITogConfigs(SellId)
  local config = BagSellData:GetBagSellInfoUITogConfigBySellId(SellId)
  if config and config.configs then
    return config.configs
  end
  return nil
end

function BagSellController.CheckSellConfigUITogConfigByIdIsChoose(SellId, id)
  return BagSellData:CheckSellConfigUITogConfigByIdIsChoose(SellId, id)
end

function BagSellController.GetCurrRecycleTogConfigById(sellId, id)
  return BagSellData:GetCurrRecycleTogConfigById(sellId, id)
end

function BagSellController.CheckUpFightById(sellId, id)
  local config = BagSellData:GetCurrRecycleTogConfigById(sellId, id)
  if config == nil or config.upFight == nil then
    return false
  end
  return config.upFight
end

function BagSellController.SetUpFightById(sellId, id, isOn)
  if sellId == nil or isOn == nil then
    return
  end
  local config = BagSellData:GetCurrRecycleTogConfigById(sellId, id)
  if config then
    config.upFight = isOn
  end
  EventManager.Dispatch(Event.Bag_RefreshShowSell)
  EventManager.Dispatch(Event.Bag_RefreshSellSelect)
end

function BagSellController.SaveCurrRecycleTogConfig()
  BagSellData:SaveCurrRecycleTogConfig()
end

function BagSellController.ClearRecycleTogConfigAndSave()
  BagSellData.RecycleConfigDic = {}
  BagSellData.currRecycleTogConfig = {}
  BagSellData:TryInitRecycleConfigDic()
  BagSellData:SaveCurrRecycleTogConfig()
end

function BagSellController.ChangeBagSellConfigByCareer()
  local careerCategory = RoleUtility.GetCurrentCareerCategory()
  if careerCategory == nil then
    return
  end
  local selectSellConfig, unSelectSellConfig = ClientTable.cfg_Global_globalManager:GetBagSellSelectRuleByCareerCategory(careerCategory)
  local sellConfigTbl
  if selectSellConfig then
    for i, v in pairs(selectSellConfig) do
      sellConfigTbl = ClientTable.cfg_Item_sellConfigManager:TryGetValue(v)
      if sellConfigTbl then
        BagSellController.SetUpFightById(sellConfigTbl.sellId, sellConfigTbl.id, true)
      end
    end
  end
  if unSelectSellConfig then
    for i, v in pairs(unSelectSellConfig) do
      sellConfigTbl = ClientTable.cfg_Item_sellConfigManager:TryGetValue(v)
      if sellConfigTbl then
        BagSellController.SetUpFightById(sellConfigTbl.sellId, sellConfigTbl.id, false)
      end
    end
  end
  BagSellController.SaveCurrRecycleTogConfig()
end
