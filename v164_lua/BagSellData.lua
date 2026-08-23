BagSellData = {}
local this = BagSellData
BagSellData.RecycleConfigDic = {}
BagSellData.currRecycleTogConfig = {}

function BagSellData:TryInitRecycleConfigDic()
  if not table.isNullOrEmpty(self.RecycleConfigDic) then
    return
  end
  local dic = ClientTable.cfg_Item_sellConfigManager:GetDic()
  for k, v in pairs(dic) do
    if v.feiqi ~= 1 then
      if self.RecycleConfigDic[v.sellId] == nil then
        self.RecycleConfigDic[v.sellId] = {}
      end
      table.insert(self.RecycleConfigDic[v.sellId], v)
    end
  end
  if type(self.currRecycleTogConfig) ~= "table" or table.isNullOrEmpty(self.currRecycleTogConfig) then
    self.currRecycleTogConfig = {}
    for k, v in pairs(dic) do
      if v.feiqi ~= 1 then
        if self.currRecycleTogConfig[tostring(v.sellId)] == nil then
          self.currRecycleTogConfig[tostring(v.sellId)] = {
            right = false,
            configs = {},
            notFirst = false
          }
        end
        local config = {
          right = false,
          param1 = v.defaultparam,
          notFirst = false,
          upFight = false
        }
        self.currRecycleTogConfig[tostring(v.sellId)].configs[tostring(v.id)] = config
      end
    end
    BagSellController.ChangeBagSellConfigByCareer()
  end
end

function BagSellData:RefrashRecycleConfigDic()
  if table.isNullOrEmpty(self.currRecycleTogConfig) then
    return
  end
  for k, v in pairs(self.currRecycleTogConfig) do
    local flag = false
    if not table.isNullOrEmpty(v.configs) then
      for ik, iv in pairs(v.configs) do
        if iv.notFirst == false then
          local config = ClientTable.cfg_Item_sellConfigManager:TryGetValue(tonumber(ik))
          local canOpen = ConditionManager.Check4D(config.selectedcondition)
          iv.right = canOpen or iv.right
          iv.notFirst = canOpen
          flag = flag or canOpen
        end
      end
      if v.notFirst == false then
        v.notFirst = flag
        v.right = flag or v.right
      end
    end
  end
end

function BagSellData:RecycleConfigShow(id)
  if type(id) ~= "number" then
    return false
  end
  local sellConfigTbl = ClientTable.cfg_Item_sellConfigManager:TryGetValue(id)
  if sellConfigTbl == nil then
    return false
  end
  return ConditionManager.Check4D(sellConfigTbl.condition)
end

function BagSellData:GetShowSellConfigDataList()
  if type(self.RecycleConfigDic) ~= "table" or table.isNullOrEmpty(self.RecycleConfigDic) then
    return {}
  end
  local sellConfigList = {}
  for k, v in pairs(self.RecycleConfigDic) do
    for ik, iv in pairs(v) do
      if self:RecycleConfigShow(iv.id) then
        if sellConfigList[iv.sellId] == nil then
          sellConfigList[iv.sellId] = {}
        end
        table.insert(sellConfigList[iv.sellId], iv)
      end
    end
  end
  return sellConfigList
end

function BagSellData:GetCurrRecycleTogConfig()
  if type(self.currRecycleTogConfig) ~= "table" then
    self:SetCurrRecycleTogConfig(nil)
  end
  return self.currRecycleTogConfig == nil and {} or self.currRecycleTogConfig
end

function BagSellData:CheckBagSellInfoUITogIsChoose(SellId)
  if SellId == nil then
    return false
  end
  SellId = tostring(SellId)
  if self.currRecycleTogConfig[SellId] and self.currRecycleTogConfig[SellId].right == true then
    return true
  end
  return false
end

function BagSellData:GetBagSellInfoUITogConfigBySellId(SellId)
  if SellId == nil then
    return nil
  end
  SellId = tostring(SellId)
  if self.currRecycleTogConfig[SellId] then
    return self.currRecycleTogConfig[SellId]
  end
  return nil
end

function BagSellData:CheckSellConfigUITogConfigByIdIsChoose(SellId, id)
  if SellId == nil or id == nil then
    return false
  end
  SellId = tostring(SellId)
  id = tostring(id)
  if self.currRecycleTogConfig[SellId] and self.currRecycleTogConfig[SellId].configs[id] and self.currRecycleTogConfig[SellId].configs[id].right == true then
    return true
  end
  return false
end

function BagSellData:GetCurrRecycleTogConfigById(sellId, id)
  if sellId == nil or id == nil then
    return nil
  end
  sellId = tostring(sellId)
  id = tostring(id)
  if self.currRecycleTogConfig[sellId] and self.currRecycleTogConfig[sellId].configs[id] and self.currRecycleTogConfig[sellId].configs[id] then
    return self.currRecycleTogConfig[sellId].configs[id]
  end
  return nil
end

function BagSellData:SetCurrRecycleTogConfig(configs)
  self.currRecycleTogConfig = configs
end

function BagSellData:SaveCurrRecycleTogConfig()
  CS.UnityEngine.PlayerPrefs.SetString(PlayerControlForceData.GetRecycleConfigKey(), json.encode(self.currRecycleTogConfig))
end

function BagSellData:GetParamtypeTypeOptions(paramType)
  if paramType == nil then
    return
  end
  if paramType == RecycleParamType.Switch then
    return
  elseif paramType == RecycleParamType.EquipOrder then
    return self:GetItemClassSetting()
  end
end

BagSellData.itemClassSetting = {}

function BagSellData:GetItemClassSetting()
  if table.isNullOrEmpty(self.itemClassSetting) then
    self.itemClassSetting = {}
    for i, v in ipairs(ClientTable.cfg_Item_class_settingManager:GetDic()) do
      if v then
        table.insert(self.itemClassSetting, CS.UnityEngine.UI.Dropdown.OptionData(v.className))
      end
    end
  end
  return self.itemClassSetting
end
