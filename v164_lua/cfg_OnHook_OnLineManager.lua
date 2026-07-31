local cfg_OnHook_OnLineManager = {}

function cfg_OnHook_OnLineManager:GetName()
  return "cfg_OnHook_OnLineManager"
end

function cfg_OnHook_OnLineManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_OnLine")
  end
  return self.dic
end

setmetatable(cfg_OnHook_OnLineManager, TableManagerBase)

function cfg_OnHook_OnLineManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_OnHook_OnLineManager:GetCostItemId(id)
  if type(id) ~= "number" then
    return
  end
  local hookExpTbl = self:TryGetValue(id)
  if hookExpTbl == nil or string.isNullOrEmpty(hookExpTbl.gold) then
    return
  end
  local goldList = string.split(hookExpTbl.gold, "#")
  return tonumber(goldList[1])
end

cfg_OnHook_OnLineManager.HookExpDic = nil

function cfg_OnHook_OnLineManager:GetHookExpTblByLevel(hookExpType, level)
  if type(level) ~= "number" then
    return
  end
  hookExpType = hookExpType ~= nil and hookExpType or OnHookExpType.OnLine
  self:TryInitHookExpDic()
  local typeHookExpLst = self.HookExpDic[hookExpType]
  if typeHookExpLst == nil then
    return
  end
  for k, v in pairs(typeHookExpLst) do
    if level >= k[1] and level <= k[2] then
      return v
    end
  end
end

function cfg_OnHook_OnLineManager:TryInitHookExpDic()
  if self.HookExpDic ~= nil then
    return
  end
  self.HookExpDic = {}
  local tblList = self:GetDic()
  for k, v in pairs(tblList) do
    self:TryAddSingleHookExpTbl(v)
  end
end

function cfg_OnHook_OnLineManager:TryAddSingleHookExpTbl(hookExpTbl)
  if hookExpTbl == nil or string.isNullOrEmpty(hookExpTbl.levelPart) then
    return
  end
  local levelInterval = string.split(hookExpTbl.levelPart, "#")
  if #levelInterval ~= 2 then
    return
  end
  for i = 1, #levelInterval do
    levelInterval[i] = tonumber(levelInterval[i])
  end
  if self.HookExpDic[hookExpTbl.type] == nil then
    self.HookExpDic[hookExpTbl.type] = {}
  end
  self.HookExpDic[hookExpTbl.type][levelInterval] = hookExpTbl
end

return cfg_OnHook_OnLineManager
