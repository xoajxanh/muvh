local cfg_puzzle_zhuanyiManager = {}

function cfg_puzzle_zhuanyiManager:GetName()
  return "cfg_puzzle_zhuanyiManager"
end

function cfg_puzzle_zhuanyiManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_zhuanyi")
  end
  return self.dic
end

setmetatable(cfg_puzzle_zhuanyiManager, TableManagerBase)

function cfg_puzzle_zhuanyiManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_zhuanyiManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_puzzle_zhuanyiManager
