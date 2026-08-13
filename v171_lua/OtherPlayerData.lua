local OtherPlayerData = {}
setmetatable(OtherPlayerData, LuaClass.PlayerData)

function OtherPlayerData:Init()
end

function OtherPlayerData:RefrashData(data)
  if data == nil then
    self.dataInfo = {}
  else
    self.dataInfo = data
  end
end

function OtherPlayerData:GetData()
  if self.dataInfo == nil then
    self.dataInfo = {}
  end
  return self.dataInfo
end

return OtherPlayerData
