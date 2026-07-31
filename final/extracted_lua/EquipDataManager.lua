local EquipDataManager = {}

function EquipDataManager:GetJewelryData()
  if self.JewelryData == nil then
    self.JewelryData = LuaClass.PlayerData_JewelryData:New()
  end
  return self.JewelryData
end

function EquipDataManager:GetCrossServerData()
  if self.CrossServerData == nil then
    self.CrossServerData = LuaClass.CrossServerData:New()
  end
  return self.CrossServerData
end

function EquipDataManager:GetSuitManager()
  if self.mSuitManager == nil then
    self.mSuitManager = LuaClass.SuitManager:New()
  end
  return self.mSuitManager
end

function EquipDataManager:GetEquipIndexExtraDataManager()
  if self.mEquipIndexExtraDataManager == nil then
    self.mEquipIndexExtraDataManager = LuaClass.EquipIndexExtraItemManager:New()
  end
  return self.mEquipIndexExtraDataManager
end

function EquipDataManager:Init()
  self.EquipDataDic = {}
end

function EquipDataManager:GetEquipDataDic()
  return self.EquipDataDic
end

function EquipDataManager:SetEquipDataDic(id, v, data)
  if self.EquipDataDic == nil then
    self.EquipDataDic = {}
  end
  if v == nil then
    self.EquipDataDic[id] = nil
    self:RefreShDataCallback(id, nil, data)
    return
  end
  if self.EquipDataDic[id] == nil then
    self.EquipDataDic[id] = LuaClass.PlayerData_EquipDataItem:New()
  end
  self.EquipDataDic[id]:RefreshData(v)
  self:RefreShDataCallback(id, self.EquipDataDic[id], data)
end

function EquipDataManager:GetEquipData()
  return self.equipsData
end

function EquipDataManager:RefreshAllData(data)
  if self.equipsData then
    self.equipsData:RefreshData(data)
  else
    self.equipsData = RoleEquipData(data)
  end
  self.s_equips = data
  if self.EquipDataDic == nil then
    self.EquipDataDic = {}
  end
  if data == nil then
    self.EquipDataDic = {}
    return
  end
  local keyList = self:GetEquipDataDicKeyList()
  for i, v in pairs(data) do
    if v ~= nil then
      keyList[v.id] = nil
      self:SetEquipDataDic(v.id, v)
    end
  end
  for i, v in pairs(keyList) do
    self:SetEquipDataDic(i, nil)
  end
  self:GetSuitManager():RefreshAllData(data)
end

function EquipDataManager:RefreshData(data)
  if data == nil or self.EquipDataDic == nil then
    return
  end
  self:GetSuitManager():RefreshSingleData(data)
  if data.remove ~= nil then
    self:SetEquipDataDic(data.remove.id, nil, data)
  end
  if data.items ~= nil then
    self:SetEquipDataDic(data.items.id, data.items, data)
  end
end

function EquipDataManager:GetEquipDataDicKeyList()
  if self.EquipDataDic == nil then
    return {}
  end
  local keyList = {}
  for i, v in pairs(self.EquipDataDic) do
    keyList[i] = true
  end
  return keyList
end

function EquipDataManager:RefreShDataCallback(id, EquipDataItem, data)
  self:GetJewelryData():RefreshData(id, EquipDataItem)
  if EquipDataItem == nil then
    EventManager.Dispatch(Event.TakeOffEquip, data)
  else
    gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():SetXiLianEquipByEquipData(EquipDataItem.equipData, XiLianEquipDataSource.EquipChange)
  end
  EventManager.Dispatch(Event.EquipInfoChange, {id = id, EquipDataItem = EquipDataItem})
end

function EquipDataManager:GetAllServerEquips()
  if type(self.s_equips) ~= "table" then
    return
  end
  local equipTbl = {}
  for k, v in pairs(self.s_equips) do
    equipTbl[v.bagGridIndex] = v
  end
  return equipTbl
end

function EquipDataManager:GetSuitBySuitId(suitId)
  local suitInfoTbl = {}
  if self.EquipDataDic == nil then
    return suitInfoTbl
  end
  for k, v in pairs(self.EquipDataDic) do
    local tblEquip = v:GetItemEquipTable()
    if tblEquip then
      local suitSpilt = string.split(tblEquip.suitId, "#")
      if 1 < #suitSpilt and v:GetEquipData() ~= nil and v:GetEquipData().isSuit and tonumber(suitSpilt[1]) == suitId then
        table.insert(suitInfoTbl, v:GetEquipData())
      end
    end
  end
  return suitInfoTbl
end

function EquipDataManager:CurOpenEquipType(_indexer, _value)
  if _indexer == IndexerEnum.set then
    self.mCurOpenEquipType = _value
  else
    return self.mCurOpenEquipType
  end
end

function EquipDataManager:GetEquipDataByEquipIndex(_equipIndex, _type)
  if self:GetSuitManager() == nil then
    return nil
  end
  _type = _type or EquipCellType.NORMAL
  local suitList = self:GetSuitManager():GetSingleSuit(_type)
  if suitList == nil then
    return
  end
  return suitList:GetEquipDataByGridIndex(_equipIndex)
end

function EquipDataManager:EquipPositionCanIntensify(equipType)
  local equipData = RoleManager.me.data.equipsData.Data
  if equipData[equipType] == nil then
    return false
  end
  local curEquipData = equipData[equipType]
  local mIntensifyTable = MeEquipController.GetEquipIntensifyCfgByEquipData(curEquipData)
  if mIntensifyTable == nil then
    return false
  end
  local cost = {}
  if mIntensifyTable ~= nil then
    local tempCost = string.split(mIntensifyTable.cost, "&")
    for i = 1, table.count(tempCost) do
      table.insert(cost, tempCost[i])
    end
  end
  local isMeetCostCondition
  for i = 1, #cost do
    local itemTbl = string.split(cost[i], "#")
    local id = tonumber(itemTbl[1])
    local costCount = tonumber(itemTbl[2])
    local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
    if isMeetCostCondition == nil then
      isMeetCostCondition = costCount <= bagCount
    else
      isMeetCostCondition = isMeetCostCondition and costCount <= bagCount
    end
  end
  local isCanIntensify = false
  if isMeetCostCondition then
    if mIntensifyTable.condition then
      local conditonValue = mIntensifyTable.condition[1]
      if conditonValue >= EConditionEnum.WingQualityGreater and conditonValue <= EConditionEnum.WingQualityLess then
        isCanIntensify = ConditionManager.GenerateSingleCondition(mIntensifyTable.condition):Check(curEquipData.tblItem)
      elseif conditonValue >= EConditionEnum.JewelryGreater and conditonValue <= EConditionEnum.JewelryLess then
        isCanIntensify = ConditionManager.GenerateSingleCondition(mIntensifyTable.condition):Check()
      elseif conditonValue == EConditionEnum.equipeClass then
        isCanIntensify = ConditionManager.GenerateSingleCondition(mIntensifyTable.condition):Check(equipType)
      end
    else
      isCanIntensify = isMeetCostCondition
    end
  end
  return isCanIntensify
end

function EquipDataManager:EquipPositionCanAdditional(equipType)
  local equipData = RoleManager.me.data.equipsData.Data
  if equipData[equipType] == nil then
    return
  end
  local curEquipData = equipData[equipType]
  local additionalTab = MeEquipController.GetEquipAddtion(curEquipData.itemId, curEquipData.additional or 0)
  additionalTab = additionalTab or MeEquipController.GetEquipAddtion(curEquipData.tblItem.subType, curEquipData.additional or 0)
  local LastAddTable = MeEquipController.GetEquipAddtion(curEquipData.itemId, curEquipData.additional + 1)
  LastAddTable = LastAddTable or MeEquipController.GetEquipAddtion(curEquipData.tblItem.subType, curEquipData.additional + 1 or 0)
  if LastAddTable and additionalTab then
    local cost = string.split(additionalTab.cost, "&")
    local isMeetCostCondition
    for i = 1, #cost do
      local itemTbl = string.split(cost[i], "#")
      local costCount = tonumber(itemTbl[2])
      local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemTbl[1]))
      if isMeetCostCondition == nil then
        isMeetCostCondition = costCount <= bagCount
      else
        isMeetCostCondition = isMeetCostCondition and costCount <= bagCount
      end
    end
    if isMeetCostCondition then
      if additionalTab.condition then
        local isCanAdditional = false
        local conditonValue = additionalTab.condition[1]
        if conditonValue >= EConditionEnum.WingQualityGreater and conditonValue <= EConditionEnum.WingQualityLess then
          isCanAdditional = ConditionManager.GenerateSingleCondition(additionalTab.condition):Check(curEquipData.tblItem)
        elseif conditonValue >= EConditionEnum.JewelryGreater and conditonValue <= EConditionEnum.JewelryLess then
          isCanAdditional = ConditionManager.GenerateSingleCondition(additionalTab.condition):Check()
        elseif conditonValue == EConditionEnum.equipeClass then
          isCanAdditional = ConditionManager.GenerateSingleCondition(additionalTab.condition):Check(equipType)
        end
        return isCanAdditional
      else
        return true
      end
    end
  end
  return false
end

function EquipDataManager:RegEquipPositionCanAdditional(equipType)
  local equipData = RoleManager.me.data.equipsData.Data
  if equipData[equipType] == nil then
    return
  end
  for i, v in pairs(ERoleEquipCanRegenerate) do
    if equipType == v and gameMgr:GetAvatarManager():GetMainPlayer():GetRegenerateDataMgr():GetRegenerateEquip(equipData[equipType]) then
      return true
    end
  end
  return false
end

return EquipDataManager
