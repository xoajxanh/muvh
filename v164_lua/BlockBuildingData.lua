BlockBuildingData = class()

function BlockBuildingData:Init(data)
  self.id = data.id
  self.configId = data.configId
  self.serverCoord = Vector2Int(data.x, data.y)
  self.x = data.x
  self.y = data.y
  self.blockData = data.blockData
  self.blockType = ClientTable.cfg_Map_blockBuildingManager:TryGetValue(self.configId, "id").type
  self.name = ClientTable.cfg_Map_blockBuildingManager:TryGetValue(self.configId, "id").name
end

function BlockBuildingData:Refresh(data)
  self:Init(data)
  EventManager.Dispatch(Event.Block_OnRefreshBlockBuildingData, self)
end
