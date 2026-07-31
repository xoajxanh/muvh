local cfg_Auction_stallManager = {}

function cfg_Auction_stallManager:GetName()
  return "cfg_Auction_stallManager"
end

function cfg_Auction_stallManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Auction_stall")
  end
  return self.dic
end

setmetatable(cfg_Auction_stallManager, TableManagerBase)

function cfg_Auction_stallManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Auction_stallManager
