local cfg_Career_transferManager = {}

function cfg_Career_transferManager:GetName()
  return "cfg_Career_transferManager"
end

function cfg_Career_transferManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Career_transfer")
  end
  return self.dic
end

setmetatable(cfg_Career_transferManager, TableManagerBase)

function cfg_Career_transferManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Career_transferManager
