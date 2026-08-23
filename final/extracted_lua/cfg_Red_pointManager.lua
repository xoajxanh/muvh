local cfg_Red_pointManager = {}

function cfg_Red_pointManager:GetName()
  return "cfg_Red_pointManager"
end

function cfg_Red_pointManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Red_point")
  end
  return self.dic
end

setmetatable(cfg_Red_pointManager, TableManagerBase)

function cfg_Red_pointManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Red_pointManager
