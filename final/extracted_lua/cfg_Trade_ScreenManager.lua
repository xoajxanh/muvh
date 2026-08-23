local cfg_Trade_ScreenManager = {}

function cfg_Trade_ScreenManager:GetName()
  return "cfg_Trade_ScreenManager"
end

function cfg_Trade_ScreenManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Trade_Screen")
  end
  return self.dic
end

setmetatable(cfg_Trade_ScreenManager, TableManagerBase)

function cfg_Trade_ScreenManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Trade_ScreenManager
