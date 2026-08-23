require("GameConst/GemEnum")
local EquipIndexExtraItemManager = {}
EquipIndexExtraItemManager.EquipIndexDataList = nil

function EquipIndexExtraItemManager:EquipIndexGemListRefresh(tblData)
  if tblData == nil or type(tblData.lightStone) ~= "table" then
    return
  end
  for k, v in pairs(tblData.lightStone) do
    self:EquipIndexGemRefresh(v)
  end
end

function EquipIndexExtraItemManager:EquipIndexGemRefresh(tblData, isServerRefresh)
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(tblData.index)
  if cellTbl ~= nil and cellTbl.relationPosition > 0 and 0 < cellTbl.stonetype then
    local equipIndexData = self:GetEquipIndexData(cellTbl.relationPosition)
    equipIndexData:GetGemListData():RefreshGemData(tblData)
  end
  if isServerRefresh and tblData.success then
    local upgrade = {
      gemIndex = tblData.index,
      stonetype = cellTbl.stonetype,
      success = tblData.success
    }
    self:GemServerUpgradeData(IndexerEnum.set, upgrade)
    EventManager.Dispatch(Event.GemIndexDataChangeEffect, upgrade)
  end
end

function EquipIndexExtraItemManager:GetEquipIndexData(equipIndex)
  if type(equipIndex) ~= "number" then
    return
  end
  if self.EquipIndexDataList == nil then
    self.EquipIndexDataList = {}
  end
  if self.EquipIndexDataList[equipIndex] == nil then
    local equipData = LuaClass.EquipIndexData:New()
    self.EquipIndexDataList[equipIndex] = equipData
    equipData:InitRefresh(equipIndex)
  end
  return self.EquipIndexDataList[equipIndex]
end

EquipIndexExtraItemManager.GemTypeAndTotalLevel = nil
EquipIndexExtraItemManager.GemTypeAndStoneCombinationList = nil
EquipIndexExtraItemManager.EquipIndexCanUpGemDic = nil
EquipIndexExtraItemManager.RecommendGemData = nil
EquipIndexExtraItemManager.NeedRefreshResult = true
EquipIndexExtraItemManager.gemUpgradeData = {}

function EquipIndexExtraItemManager:GemCalculate(equipIndexList, pos)
  if not self.NeedRefreshResult then
    return
  end
  if type(equipIndexList) ~= "table" or type(pos) ~= "number" or pos > #equipIndexList then
    self.NeedRefreshResult = false
    self:RefreshGemTypeAndStoneCombinationList()
    EventManager.Dispatch(Event.GemCalculateResultChange)
    return
  end
  if pos == 1 then
    self.GemTypeAndTotalLevel = {}
    self.EquipIndexCanUpGemDic = {}
    self.RecommendGemData = nil
  end
  local equipIndex = equipIndexList[pos]
  local equipIndexData = self:GetEquipIndexData(equipIndex)
  local equipIndexEquipInfo = equipIndexData:GetEquipItemData()
  self.EquipIndexCanUpGemDic[equipIndex] = {}
  if equipIndexData:GetGemListData().AnalysisState == false then
    self:GemCalculate(equipIndexList, pos + 1)
  end
  local gemDataList = equipIndexData:GetGemListData():GetGemList()
  for k, v in pairs(gemDataList) do
    self.GemTypeAndTotalLevel[v.stoneTbl.stonetype] = self.GemTypeAndTotalLevel[v.stoneTbl.stonetype] == nil and v.stoneLevel or self.GemTypeAndTotalLevel[v.stoneTbl.stonetype] + v.stoneLevel
    if equipIndexEquipInfo ~= nil and v:IsCanUpLevel() then
      self.RecommendGemData = self.RecommendGemData == nil and v or self:GemDataCompare(self.RecommendGemData, v)
      self.EquipIndexCanUpGemDic[equipIndex][v.stoneTbl.stonetype] = v
    end
  end
  self:GemCalculate(equipIndexList, pos + 1)
end

function EquipIndexExtraItemManager:GemDataCompare(gemData, gemData2)
  if gemData == nil or gemData2 == nil then
    return
  end
  local defaultRecommendGemData = gemData
  local gemDataTypeOrder, gemData2TypeOrder = ClientTable.cfg_Item_stone_configManager:GetGemChooseOrderList()[gemData.stoneTbl.stonetype], ClientTable.cfg_Item_stone_configManager:GetGemChooseOrderList()[gemData2.stoneTbl.stonetype]
  if gemDataTypeOrder == nil or gemData2TypeOrder == nil then
    return defaultRecommendGemData
  end
  if gemData2.stoneLevel < defaultRecommendGemData.stoneLevel then
    defaultRecommendGemData = gemData2
  elseif gemData2.stoneLevel == defaultRecommendGemData.stoneLevel and gemDataTypeOrder > gemData2TypeOrder then
    defaultRecommendGemData = gemData2
  end
  return defaultRecommendGemData
end

function EquipIndexExtraItemManager:RefreshGemTypeAndStoneCombinationList()
  if type(self.GemTypeAndTotalLevel) ~= "table" then
    return
  end
  self.GemTypeAndStoneCombinationList = {}
  for k, v in pairs(self.GemTypeAndTotalLevel) do
    local stoneCombineInfo = ClientTable.cfg_item_stone_combinationManager:GetStoneCombineInfoByLevel(k, v)
    if stoneCombineInfo then
      table.insert(self.GemTypeAndStoneCombinationList, stoneCombineInfo)
    end
  end
end

function EquipIndexExtraItemManager:ResetGemCalculate()
  self.NeedRefreshResult = true
end

function EquipIndexExtraItemManager:GetRecommendGemData()
  self:GemCalculate(ClientTable.cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList(), 1)
  return self.RecommendGemData
end

function EquipIndexExtraItemManager:GetGemTypeAndTotalLevel()
  self:GemCalculate(ClientTable.cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList(), 1)
  return self.GemTypeAndTotalLevel
end

function EquipIndexExtraItemManager:GetGemCombineTblList()
  self:GemCalculate(ClientTable.cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList(), 1)
  return self.GemTypeAndStoneCombinationList
end

function EquipIndexExtraItemManager:GetEquipIndexCanUpGemDic()
  self:GemCalculate(ClientTable.cfg_Item_stone_configManager:GetHaveGemEquipIndexOrderList(), 1)
  return self.EquipIndexCanUpGemDic
end

function EquipIndexExtraItemManager:GetCanUpGemListByEquipIndex(equipIndex)
  if type(equipIndex) ~= "number" then
    return
  end
  local equipIndexCanUpGemDic = self:GetEquipIndexCanUpGemDic()
  if type(equipIndexCanUpGemDic) ~= "table" then
    return
  end
  return equipIndexCanUpGemDic[equipIndex]
end

function EquipIndexExtraItemManager:GetTotalLevel(gemType)
  if type(gemType) ~= "number" then
    return 0
  end
  local gemTypeAndTotalLevelDic = self:GetGemTypeAndTotalLevel()
  if type(gemTypeAndTotalLevelDic) ~= "table" or next(gemTypeAndTotalLevelDic) == nil then
    return 0
  end
  if gemType == GemType.TotalGem then
    local totalLevel = 0
    for k, v in pairs(gemTypeAndTotalLevelDic) do
      totalLevel = totalLevel + v
    end
    return totalLevel
  end
  if gemTypeAndTotalLevelDic[gemType] == nil then
    return 0
  end
  return gemTypeAndTotalLevelDic[gemType]
end

function EquipIndexExtraItemManager:EquipIndexHaveCanUpGem(equipIndex)
  local canUpGemList = self:GetCanUpGemListByEquipIndex(equipIndex)
  if canUpGemList == nil then
    return false
  end
  return type(canUpGemList) == "table" and next(canUpGemList) ~= nil
end

function EquipIndexExtraItemManager:GemPositionCanUp(equipIndex, gemType)
  local canUpGemList = self:GetCanUpGemListByEquipIndex(equipIndex)
  if canUpGemList == nil then
    return false
  end
  return canUpGemList[gemType] ~= nil
end

function EquipIndexExtraItemManager:GemServerUpgradeData(_indexer, _value)
  if self.gemUpgradeData == nil then
    self.gemUpgradeData = {}
  end
  if _indexer == IndexerEnum.get then
    return self.gemUpgradeData
  elseif _indexer == IndexerEnum.set then
    self.gemUpgradeData = _value
  end
end

return EquipIndexExtraItemManager
