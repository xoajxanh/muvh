local cfg_puzzle_decomposeManager = {}

function cfg_puzzle_decomposeManager:GetName()
  return "cfg_puzzle_decomposeManager"
end

function cfg_puzzle_decomposeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_decompose")
  end
  return self.dic
end

setmetatable(cfg_puzzle_decomposeManager, TableManagerBase)

function cfg_puzzle_decomposeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_decomposeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_puzzle_decomposeManager
