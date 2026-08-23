GraveData = class()

function GraveData:Init(data)
  self.id = data.id
  self.configId = data.configId
  self.reliveTime = data.reliveTime
  self.x = data.x
  self.y = data.y
end
