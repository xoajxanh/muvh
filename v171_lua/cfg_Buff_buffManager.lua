local cfg_Buff_buffManager = {}

function cfg_Buff_buffManager:GetName()
  return "cfg_Buff_buffManager"
end

function cfg_Buff_buffManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Buff_buff")
  end
  return self.dic
end

setmetatable(cfg_Buff_buffManager, TableManagerBase)

function cfg_Buff_buffManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Buff_buffManager
