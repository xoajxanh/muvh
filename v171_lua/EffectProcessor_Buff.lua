local EffectProcessor_Buff = {}
setmetatable(EffectProcessor_Buff, LuaClass.EffectProcessor)

function EffectProcessor_Buff:AddBuffs(buffIds, rootObj)
  if type(buffIds) ~= "table" then
    return
  end
  local curLids = {}
  for k, v in pairs(buffIds) do
    local lids = self:InstantiationEffect(v, rootObj)
    if lids ~= nil then
      table.merge(curLids, lids)
    end
  end
  return curLids
end

function EffectProcessor_Buff:InstantiationEffect(id, rootObj)
  if type(id) ~= "number" or IsNil(rootObj) then
    return
  end
  local buffTbl = ClientTable.cfg_Buff_buffManager:TryGetValue(id)
  if buffTbl == nil or buffTbl.show == 0 then
    return
  end
  local buffActionTbl = ConfigManager.GetConfig("cfg_buffAction", buffTbl.show, "id")
  if buffActionTbl == nil or buffActionTbl.prefabs == nil then
    return
  end
  local lids = {}
  for k, v in pairs(buffActionTbl.prefabs) do
    local lid = self:RunBaseFunction("InstantiationEffect", v, rootObj)
    table.insert(lids, lid)
  end
  return lids
end

function EffectProcessor_Buff:RemoveEffects(lids)
  if type(lids) ~= "table" then
    return
  end
  for k, v in pairs(lids) do
    self:RemoveEffect(v)
  end
end

return EffectProcessor_Buff
