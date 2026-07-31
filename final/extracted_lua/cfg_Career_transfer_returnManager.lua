local cfg_Career_transfer_returnManager = {}

function cfg_Career_transfer_returnManager:GetName()
  return "cfg_Career_transfer_returnManager"
end

function cfg_Career_transfer_returnManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Career_transfer_return")
  end
  return self.dic
end

setmetatable(cfg_Career_transfer_returnManager, TableManagerBase)

function cfg_Career_transfer_returnManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Career_transfer_returnManager
