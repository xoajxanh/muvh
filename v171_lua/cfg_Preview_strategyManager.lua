local cfg_Preview_strategyManager = {}

function cfg_Preview_strategyManager:GetName()
  return "cfg_Preview_strategyManager"
end

function cfg_Preview_strategyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Preview_strategy")
  end
  return self.dic
end

setmetatable(cfg_Preview_strategyManager, TableManagerBase)

function cfg_Preview_strategyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Preview_strategyManager
