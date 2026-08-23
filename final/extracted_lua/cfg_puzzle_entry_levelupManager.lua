local cfg_puzzle_entry_levelupManager = {}

function cfg_puzzle_entry_levelupManager:GetName()
  return "cfg_puzzle_entry_levelupManager"
end

function cfg_puzzle_entry_levelupManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_entry_levelup")
  end
  return self.dic
end

setmetatable(cfg_puzzle_entry_levelupManager, TableManagerBase)

function cfg_puzzle_entry_levelupManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_entry_levelupManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_puzzle_entry_levelupManager:GetGrowUpLevel(id, level)
  for i, v in pairs(self:GetDic()) do
    if v.contentExcel_ID == tostring(id) and v.level == level then
      return v
    end
  end
  return
end

return cfg_puzzle_entry_levelupManager
