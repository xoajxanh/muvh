local cfg_Trade_autoAuctionManager = {}

function cfg_Trade_autoAuctionManager:GetName()
  return "cfg_Trade_autoAuctionManager"
end

function cfg_Trade_autoAuctionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Trade_autoAuction")
  end
  return self.dic
end

setmetatable(cfg_Trade_autoAuctionManager, TableManagerBase)

function cfg_Trade_autoAuctionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Trade_autoAuctionManager
