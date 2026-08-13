local cfg_Chat_emojiManager = {}

function cfg_Chat_emojiManager:GetName()
  return "cfg_Chat_emojiManager"
end

function cfg_Chat_emojiManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Chat_emoji")
  end
  return self.dic
end

setmetatable(cfg_Chat_emojiManager, TableManagerBase)

function cfg_Chat_emojiManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Chat_emojiManager
