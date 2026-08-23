local cfg_puzzle_entryManager = {}

function cfg_puzzle_entryManager:GetName()
  return "cfg_puzzle_entryManager"
end

function cfg_puzzle_entryManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_entry")
  end
  return self.dic
end

setmetatable(cfg_puzzle_entryManager, TableManagerBase)

function cfg_puzzle_entryManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_entryManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_puzzle_entryManager
