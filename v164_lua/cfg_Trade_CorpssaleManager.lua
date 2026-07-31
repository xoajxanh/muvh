local cfg_Trade_CorpssaleManager = {}

function cfg_Trade_CorpssaleManager:GetName()
  return "cfg_Trade_CorpssaleManager"
end

function cfg_Trade_CorpssaleManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Trade_Corpssale")
  end
  return self.dic
end

setmetatable(cfg_Trade_CorpssaleManager, TableManagerBase)

function cfg_Trade_CorpssaleManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Trade_CorpssaleManager
