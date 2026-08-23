local cfg_Ui_logicManager = {}

function cfg_Ui_logicManager:GetName()
  return "cfg_Ui_logicManager"
end

function cfg_Ui_logicManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_logic")
  end
  return self.dic
end

setmetatable(cfg_Ui_logicManager, TableManagerBase)

function cfg_Ui_logicManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Ui_logicManager
