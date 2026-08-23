local cfg_PVP_3v3_killManager = {}

function cfg_PVP_3v3_killManager:GetName()
  return "cfg_PVP_3v3_killManager"
end

function cfg_PVP_3v3_killManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_PVP_3v3_kill")
  end
  return self.dic
end

setmetatable(cfg_PVP_3v3_killManager, TableManagerBase)

function cfg_PVP_3v3_killManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_PVP_3v3_killManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_PVP_3v3_killManager
