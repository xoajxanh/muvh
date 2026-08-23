local MapTransferData = {}
MapTransferData.npcInstanceTransferTable = nil
MapTransferData.analysisState = false
MapTransferData.titleName = nil
MapTransferData.MapData = nil
MapTransferData.conditionDes = nil

function MapTransferData:RefreshDataById(npcInstanceTransferId)
  self:RefreshDataByTbl(npcInstanceTransferId)
end

function MapTransferData:RefreshDataByTbl(npcInstanceTransferTbl)
  if self:AnalysisParams(npcInstanceTransferTbl) == false then
    return
  end
  self:RefreshMapData()
end

function MapTransferData:AnalysisParams(npcInstanceTransfer)
  self.npcInstanceTransferTable = npcInstanceTransfer
  self.analysisState = false
  if type(self.npcInstanceTransferTable) == "number" then
    self.npcInstanceTransferTable = ClientTable.cfg_Npc_instance_transferManager:TryGetValue(npcInstanceTransfer)
  end
  if type(self.npcInstanceTransferTable) ~= "table" then
    return false
  end
  self.titleName = self.npcInstanceTransferTable.name
  self.conditionDes = self.npcInstanceTransferTable.des
  self.analysisState = true
  return self.analysisState
end

function MapTransferData:RefreshMapData()
  if self.MapData ~= nil then
    return
  end
  self.MapData = {}
  if string.isNullOrEmpty(self.npcInstanceTransferTable.mapId) then
    return
  end
  local mapId = tonumber(self.npcInstanceTransferTable.mapId)
  if mapId == nil then
    return
  end
  local mapData = LuaClass.MapData:New()
  mapData:RefreshData(mapId)
  if mapData.analysisState then
    self.MapData = mapData
  else
    self.analysisState = false
  end
end

function MapTransferData:GetConditionDes()
  if self.MapData == nil or self.MapData.analysisState == false or self.MapData.CanEnterMap == nil then
    return
  end
  local color = self.MapData:CanEnterMap() and EItemColorEnum.green or EItemColorEnum.bRed
  return self.conditionDes:GetColorText(ItemQuality2ColorDic[color])
end

return MapTransferData
