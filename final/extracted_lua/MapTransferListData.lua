local MapTransferListData = {}
require("GameConst/MapEnum")
MapTransferListData.MapTransferDataList = nil
MapTransferListData.InputParams = nil

function MapTransferListData:AnalysisParams(commonData)
  if commonData == nil or type(commonData.sourceType) ~= "number" or type(commonData.id) ~= "number" then
    return false
  end
  if self.MapTransferDataList == nil then
    self.MapTransferDataList = {}
  end
  self.InputParams = commonData
  return true
end

function MapTransferListData:AddMapData(commonData)
  local sourceTypeList = self.MapTransferDataList[commonData.sourceType]
  if sourceTypeList == nil then
    self.MapTransferDataList[commonData.sourceType] = {}
    sourceTypeList = self.MapTransferDataList[commonData.sourceType]
  end
  local mapTransferDataList = sourceTypeList[commonData.id]
  if mapTransferDataList == nil then
    sourceTypeList[commonData.id] = {}
    mapTransferDataList = sourceTypeList[commonData.id]
  end
  local mapTransferTblList = self:GetMapTblList(commonData)
  if type(mapTransferTblList) ~= "table" then
    return
  end
  for k, v in pairs(mapTransferTblList) do
    local mapTransferTbl = v
    local mapTransferData = LuaClass.MapTransferData:New()
    mapTransferData:RefreshDataByTbl(mapTransferTbl)
    table.insert(mapTransferDataList, mapTransferData)
  end
  return mapTransferDataList
end

function MapTransferListData:GetMapTblList(commonData)
  if commonData == nil then
    return
  end
  if commonData.sourceType == MapTransferSourceType.Npc then
    return ClientTable.cfg_Npc_instance_transferManager:GetNpc_Instance_TransferList(commonData.id)
  end
end

function MapTransferListData:GetMapTransferData(commonData)
  if self:AnalysisParams(commonData) == false then
    return
  end
  if self.MapTransferDataList[commonData.sourceType] == nil or self.MapTransferDataList[commonData.sourceType][commonData.id] == nil then
    self:AddMapData(commonData)
  end
  return self.MapTransferDataList[commonData.sourceType][commonData.id]
end

return MapTransferListData
