local cfg_Red_point_typeManager = {}

function cfg_Red_point_typeManager:GetName()
  return "cfg_Red_point_typeManager"
end

function cfg_Red_point_typeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Red_point_type")
  end
  return self.dic
end

setmetatable(cfg_Red_point_typeManager, TableManagerBase)

function cfg_Red_point_typeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Red_point_typeManager
