local MonsterData = {}
setmetatable(MonsterData, LuaClass.AvatarData)

function MonsterData:Init()
end

function MonsterData:GetMapBuffs()
  local buffList = self:GetBuffs()
  local mapShowConfigList = {}
  if type(buffList) ~= "table" or next(buffList) == nil then
    return mapShowConfigList
  end
  for k, v in pairs(buffList) do
    if v.mapShowConfig then
      table.insert(mapShowConfigList, v)
    end
  end
  table.sort(mapShowConfigList, self.MapBuffsSort)
  return mapShowConfigList
end

function MonsterData:GetShowMiniMapBuffs()
  local buffs = self:GetMapBuffs()
  local miniMapBuffs = {}
  if buffs == nil then
    return miniMapBuffs
  end
  for k, v in pairs(buffs) do
    if v.mapShowConfig ~= nil then
      table.insert(miniMapBuffs, v.mapShowConfig)
    end
  end
  return miniMapBuffs
end

function MonsterData.MapBuffsSort(mapShowConfig1, mapShowConfig2)
  return mapShowConfig1.miniLayer < mapShowConfig2.miniLayer
end

return MonsterData
