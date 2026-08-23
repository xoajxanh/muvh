local cfg_Commerce_CooperativeserviceTaskManager = {}

function cfg_Commerce_CooperativeserviceTaskManager:GetName()
  return "cfg_Commerce_CooperativeserviceTaskManager"
end

function cfg_Commerce_CooperativeserviceTaskManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_CooperativeserviceTask")
  end
  return self.dic
end

setmetatable(cfg_Commerce_CooperativeserviceTaskManager, TableManagerBase)

function cfg_Commerce_CooperativeserviceTaskManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_CooperativeserviceTaskManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_CooperativeserviceTaskManager
