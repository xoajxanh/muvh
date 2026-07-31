TransData = class()

function TransData:Init(data)
  self.id = data.id
  self.configId = data.configId
  self.x = data.x
  self.y = data.y
end
