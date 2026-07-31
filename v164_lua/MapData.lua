local MapData = {}
MapData.mapTable = nil
MapData.analysisState = nil
MapData.mapName = nil
MapData.mapTransferTable = nil

function MapData:RefreshData(mapId)
  if self:AnalysisParams(mapId) == false then
    return
  end
  self.mapName = self.mapTable.name
end

function MapData:AnalysisParams(mapId)
  self.analysisState = false
  if type(mapId) ~= "number" then
    return false
  end
  self.mapTable = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
  if self.mapTable == nil then
    return false
  end
  self.analysisState = true
  return true
end

function MapData:CanEnterMap()
  if self.analysisState == false or self.mapTable == nil then
    return false
  end
  if self.mapTable.enterCondition == nil then
    return true
  end
  return ConditionManager.Check4D(self.mapTable.enterCondition)
end

function MapData:TransferMap()
  if self.analysisState == false or self.mapTable == nil or self.mapTable.transferPosition == nil then
    return false
  end
  if self:CanEnterMap() == false then
    FloatingTipUtility.QuickMsg("\196\144i\225\187\129u ki\225\187\135n kh\195\180ng th\225\187\143a")
    return false
  end
  if self.mapTransferTable == nil then
    self.mapTransferTable = ClientTable.cfg_Map_transferManager:TryGetValue(tonumber(self.mapTable.transferPosition))
  end
  if self.mapTransferTable == nil then
    return false
  end
  local changeMapData = {
    mapId = self.mapTransferTable.id
  }
  EventManager.Dispatch(Event.Map_ChangeMap, changeMapData)
end

return MapData
