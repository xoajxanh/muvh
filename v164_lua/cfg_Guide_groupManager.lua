local cfg_Guide_groupManager = {}

function cfg_Guide_groupManager:GetName()
  return "cfg_Guide_groupManager"
end

function cfg_Guide_groupManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Guide_group")
  end
  return self.dic
end

setmetatable(cfg_Guide_groupManager, TableManagerBase)

function cfg_Guide_groupManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Guide_groupManager
