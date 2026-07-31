local cfg_Ui_promptwordManager = {}

function cfg_Ui_promptwordManager:GetName()
  return "cfg_Ui_promptwordManager"
end

function cfg_Ui_promptwordManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ui_promptword")
  end
  return self.dic
end

setmetatable(cfg_Ui_promptwordManager, TableManagerBase)

function cfg_Ui_promptwordManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Ui_promptwordManager:GetUi_promptwordCount(id)
  local content = ""
  local cfg_Ui_word = self:TryGetValue(id)
  if cfg_Ui_word ~= nil then
    content = cfg_Ui_word.content
  end
  return content
end

function cfg_Ui_promptwordManager:GetKoreaTipData(id)
  local cfg_Ui_word = self:TryGetValue(id)
  if cfg_Ui_word ~= nil then
    return cfg_Ui_word
  end
  return ""
end

return cfg_Ui_promptwordManager
