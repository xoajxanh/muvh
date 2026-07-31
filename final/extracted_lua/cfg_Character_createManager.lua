local cfg_Character_createManager = {}

function cfg_Character_createManager:GetName()
  return "cfg_Character_createManager"
end

function cfg_Character_createManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Character_create")
  end
  return self.dic
end

setmetatable(cfg_Character_createManager, TableManagerBase)

function cfg_Character_createManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Character_createManager
