local cfg_Character_modelManager = {}

function cfg_Character_modelManager:GetName()
  return "cfg_Character_modelManager"
end

function cfg_Character_modelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Character_model")
  end
  return self.dic
end

setmetatable(cfg_Character_modelManager, TableManagerBase)

function cfg_Character_modelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Character_modelManager
