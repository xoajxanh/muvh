local cfg_Auction_stallPositionManager = {}

function cfg_Auction_stallPositionManager:GetName()
  return "cfg_Auction_stallPositionManager"
end

function cfg_Auction_stallPositionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Auction_stallPosition")
  end
  return self.dic
end

setmetatable(cfg_Auction_stallPositionManager, TableManagerBase)

function cfg_Auction_stallPositionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Auction_stallPositionManager
