local cfg_Chat_chatManager = {}

function cfg_Chat_chatManager:GetName()
  return "cfg_Chat_chatManager"
end

function cfg_Chat_chatManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Chat_chat")
  end
  return self.dic
end

setmetatable(cfg_Chat_chatManager, TableManagerBase)

function cfg_Chat_chatManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Chat_chatManager:GetChatInfoType(id)
  if type(id) ~= "number" then
    return ChatInfoEnum.NONE
  end
  local chatTbl = self:TryGetValue(id)
  if chatTbl ~= nil and string.isNullOrEmpty(chatTbl.conductType) == false then
    return tonumber(chatTbl.conductType)
  end
  return ChatInfoEnum.NONE
end

return cfg_Chat_chatManager
