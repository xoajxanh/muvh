local cfg_Activity_taskSifangManager = {}

function cfg_Activity_taskSifangManager:GetName()
  return "cfg_Activity_taskSifangManager"
end

function cfg_Activity_taskSifangManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_taskSifang")
  end
  return self.dic
end

setmetatable(cfg_Activity_taskSifangManager, TableManagerBase)

function cfg_Activity_taskSifangManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Activity_taskSifangManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Activity_taskSifangManager
