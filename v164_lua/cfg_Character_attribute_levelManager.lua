local cfg_Character_attribute_levelManager = {}

function cfg_Character_attribute_levelManager:GetName()
  return "cfg_Character_attribute_levelManager"
end

function cfg_Character_attribute_levelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Character_attribute_level")
  end
  return self.dic
end

setmetatable(cfg_Character_attribute_levelManager, TableManagerBase)

function cfg_Character_attribute_levelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Character_attribute_levelManager
