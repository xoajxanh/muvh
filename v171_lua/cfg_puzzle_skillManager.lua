local cfg_puzzle_skillManager = {}

function cfg_puzzle_skillManager:GetName()
  return "cfg_puzzle_skillManager"
end

function cfg_puzzle_skillManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_skill")
  end
  return self.dic
end

setmetatable(cfg_puzzle_skillManager, TableManagerBase)

function cfg_puzzle_skillManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_skillManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_puzzle_skillManager
