local cfg_Auction_stallNameManager = {}

function cfg_Auction_stallNameManager:GetName()
  return "cfg_Auction_stallNameManager"
end

function cfg_Auction_stallNameManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Auction_stallName")
  end
  return self.dic
end

setmetatable(cfg_Auction_stallNameManager, TableManagerBase)

function cfg_Auction_stallNameManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Auction_stallNameManager
