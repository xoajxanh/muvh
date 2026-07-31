local cfg_Platform_channelManager = {}

function cfg_Platform_channelManager:GetName()
  return "cfg_Platform_channelManager"
end

function cfg_Platform_channelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Platform_channel")
  end
  return self.dic
end

setmetatable(cfg_Platform_channelManager, TableManagerBase)

function cfg_Platform_channelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Platform_channelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Platform_channelManager
