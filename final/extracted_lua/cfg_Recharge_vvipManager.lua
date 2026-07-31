local cfg_Recharge_vvipManager = {}

function cfg_Recharge_vvipManager:GetName()
  return "cfg_Recharge_vvipManager"
end

function cfg_Recharge_vvipManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Recharge_vvip")
  end
  return self.dic
end

setmetatable(cfg_Recharge_vvipManager, TableManagerBase)

function cfg_Recharge_vvipManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Recharge_vvipManager
