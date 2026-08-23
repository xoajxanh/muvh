local cfg_Ui_word_serverManager = {}

function cfg_Ui_word_serverManager:GetName()
  return "cfg_Ui_word_serverManager"
end

function cfg_Ui_word_serverManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_word_server")
  end
  return self.dic
end

setmetatable(cfg_Ui_word_serverManager, TableManagerBase)

function cfg_Ui_word_serverManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Ui_word_serverManager
