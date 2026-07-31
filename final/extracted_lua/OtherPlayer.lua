local OtherPlayer = {}
setmetatable(OtherPlayer, LuaClass.Player)

function OtherPlayer:GetInfo()
  if self.otherPlayerInfo == nil then
    self.otherPlayerInfo = LuaClass.OtherPlayerData:New()
  end
  return self.otherPlayerInfo
end

function OtherPlayer:Init()
end

return OtherPlayer
