local cfg_Commerce_luckystarManager = {}

function cfg_Commerce_luckystarManager:GetName()
  return "cfg_Commerce_luckystarManager"
end

function cfg_Commerce_luckystarManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_luckystar")
  end
  return self.dic
end

setmetatable(cfg_Commerce_luckystarManager, TableManagerBase)

function cfg_Commerce_luckystarManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_luckystarManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_luckystarManager
