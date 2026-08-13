local cfg_Character_attributeManager = {}

function cfg_Character_attributeManager:GetName()
  return "cfg_Character_attributeManager"
end

function cfg_Character_attributeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Character_attribute")
  end
  return self.dic
end

setmetatable(cfg_Character_attributeManager, TableManagerBase)

function cfg_Character_attributeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Character_attributeManager
