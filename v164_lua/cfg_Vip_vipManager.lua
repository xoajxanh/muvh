local cfg_Vip_vipManager = {}

function cfg_Vip_vipManager:GetName()
  return "cfg_Vip_vipManager"
end

function cfg_Vip_vipManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Vip_vip")
  end
  return self.dic
end

setmetatable(cfg_Vip_vipManager, TableManagerBase)

function cfg_Vip_vipManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Vip_vipManager
