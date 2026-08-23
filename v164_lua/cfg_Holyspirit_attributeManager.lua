local cfg_Holyspirit_attributeManager = {}

function cfg_Holyspirit_attributeManager:GetName()
  return "cfg_Holyspirit_attributeManager"
end

function cfg_Holyspirit_attributeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Holyspirit_attribute")
  end
  return self.dic
end

setmetatable(cfg_Holyspirit_attributeManager, TableManagerBase)

function cfg_Holyspirit_attributeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Holyspirit_attributeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Holyspirit_attributeManager
