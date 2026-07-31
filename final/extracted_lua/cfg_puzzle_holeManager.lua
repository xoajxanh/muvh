local cfg_puzzle_holeManager = {}

function cfg_puzzle_holeManager:GetName()
  return "cfg_puzzle_holeManager"
end

function cfg_puzzle_holeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_hole")
  end
  return self.dic
end

setmetatable(cfg_puzzle_holeManager, TableManagerBase)

function cfg_puzzle_holeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_holeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_puzzle_holeManager
