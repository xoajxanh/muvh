local cfg_Activity_newManager = {}

function cfg_Activity_newManager:GetName()
  return "cfg_Activity_newManager"
end

function cfg_Activity_newManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_new")
  end
  return self.dic
end

setmetatable(cfg_Activity_newManager, TableManagerBase)

function cfg_Activity_newManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Activity_newManager
