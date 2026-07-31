local cfg_cpuManager = {}

function cfg_cpuManager:GetName()
  return "cfg_cpuManager"
end

function cfg_cpuManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_cpu")
  end
  return self.dic
end

setmetatable(cfg_cpuManager, TableManagerBase)

function cfg_cpuManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_cpuManager
