local cfg_Mail_mailManager = {}

function cfg_Mail_mailManager:GetName()
  return "cfg_Mail_mailManager"
end

function cfg_Mail_mailManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Mail_mail")
  end
  return self.dic
end

setmetatable(cfg_Mail_mailManager, TableManagerBase)

function cfg_Mail_mailManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Mail_mailManager
