TrapData = class()

function TrapData:Init(data)
  self.id = data.id
  self.configId = data.configId
  self.serverCoord = Vector2Int(data.x, data.y)
  self.x = data.x
  self.y = data.y
  self.createTime = data.createTime
  local cfgMapTrap = ClientTable.cfg_Map_trapManager:TryGetValue(self.configId, "id")
  self.trapType = cfgMapTrap.type
  self.name = cfgMapTrap.name
  self.model = cfgMapTrap.effect
  self.modelType = EEffectModelType.Scene
end

function TrapData:Refresh(data)
  self:Init(data)
end
