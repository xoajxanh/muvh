local Monster = {}
setmetatable(Monster, LuaClass.Avatar)

function Monster:GetInfo()
  if self.monsterInfo == nil then
    self.monsterInfo = LuaClass.MonsterData:New()
  end
  return self.monsterInfo
end

function Monster:Init()
end

function Monster:RefreshData(data)
  self:GetInfo():Refresh(data)
end

return Monster
