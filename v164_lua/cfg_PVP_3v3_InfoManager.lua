local cfg_PVP_3v3_InfoManager = {}

function cfg_PVP_3v3_InfoManager:GetName()
  return "cfg_PVP_3v3_InfoManager"
end

function cfg_PVP_3v3_InfoManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_PVP_3v3_Info")
  end
  return self.dic
end

setmetatable(cfg_PVP_3v3_InfoManager, TableManagerBase)

function cfg_PVP_3v3_InfoManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_PVP_3v3_InfoManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_PVP_3v3_InfoManager
