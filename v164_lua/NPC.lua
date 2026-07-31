local Npc = {}
setmetatable(Npc, LuaClass.Avatar)

function Npc:GetInfo()
  if self.npcInfo == nil then
    self.npcInfo = LuaClass.NpcData:New()
  end
  return self.npcInfo
end

function Npc:Init()
end

function Npc:RefreshData(data)
end

return Npc
