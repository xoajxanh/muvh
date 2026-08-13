local GemData = {}
GemData.stoneLevel = nil
GemData.stoneCellInfo = nil
GemData.stoneTbl = nil
GemData.nextStoneTbl = nil
GemData.serverData = nil
GemData.attributeList = nil
GemData.costItemList = nil

function GemData:InitRefresh(stoneCellInfo)
  self.stoneCellInfo = stoneCellInfo
  self.stoneLevel = 0
  self:RefreshLevelData(self.stoneCellInfo.cellTbl.stonetype, self.stoneLevel)
end

function GemData:Refresh(serverData)
  if serverData == nil or serverData.type ~= self.stoneTbl.stonetype then
    return
  end
  self.serverData = serverData
  self.stoneLevel = self.serverData.level
  self.attributeListNeedChange = true
  self.costItemListNeedChange = true
  self:RefreshLevelData(self.stoneCellInfo.cellTbl.stonetype, self.stoneLevel)
end

function GemData:RefreshLevelData(stoneType, stoneLevel)
  self.stoneTbl = ClientTable.cfg_Item_stone_newlevelManager:GetGemTblByType(stoneType, stoneLevel)
  self.nextStoneTbl = ClientTable.cfg_Item_stone_newlevelManager:GetGemTblByType(stoneType, stoneLevel + 1)
end

function GemData:CheckIsMaxLevel()
  return self.nextStoneTbl == nil
end

function GemData:CheckCondition()
  if self.stoneTbl == nil then
    return false
  end
  if self.stoneTbl.condition == nil then
    return true
  end
  return ConditionManager.Check(self.stoneTbl.condition, self.stoneCellInfo.equipIndex)
end

function GemData:IsCanUpLevel()
  if self:CheckIsMaxLevel() then
    return false
  end
  if self:CheckCondition() == false then
    return false
  end
  local lackCostItem = self:GetUpLackCostItemId()
  if lackCostItem ~= nil then
    return false
  end
  return true
end

function GemData:GetAttributeList()
  if self.attributeListNeedChange ~= nil and not self.attributeListNeedChange then
    return self.attributeList
  end
  self.attributeListNeedChange = false
  self.attributeList = {}
  local attributeInfo
  for k, v in pairs(GemConfigAttribute) do
    local curValue = TableParse:GetAttributeValueDes(self.stoneTbl, v.attributeConfigName)
    if curValue ~= nil and string.isNullOrEmpty(curValue) == false then
      attributeInfo = {}
      attributeInfo.name = v.attributeName
      attributeInfo.curValue = curValue
      attributeInfo.nextIsNil = self.nextStoneTbl == nil
      if self.nextStoneTbl ~= nil then
        attributeInfo.nextValue = TableParse:GetAttributeValueDes(self.nextStoneTbl, v.attributeConfigName)
      end
      table.insert(self.attributeList, attributeInfo)
    end
  end
  return self.attributeList
end

function GemData:GetCostItemList()
  if self.costItemListNeedChange ~= nil and not self.costItemListNeedChange then
    return self.costItemList
  end
  self.costItemListNeedChange = false
  self.costItemList = TableParse:SpliteStringToItemCountList(self.stoneTbl.cost)
  return self.costItemList
end

function GemData:GetUpLackCostItemId()
  local costItemList = self:GetCostItemList()
  if next(costItemList) == nil then
    return
  end
  for k, v in pairs(costItemList) do
    local bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
    if bagCount < v.count then
      return v
    end
  end
end

return GemData
