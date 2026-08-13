local cfg_Ui_descriptionManager = {}

function cfg_Ui_descriptionManager:GetName()
  return "cfg_Ui_descriptionManager"
end

function cfg_Ui_descriptionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_description")
  end
  return self.dic
end

setmetatable(cfg_Ui_descriptionManager, TableManagerBase)

function cfg_Ui_descriptionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Ui_descriptionManager
