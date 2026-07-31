function networkRequest.ReqPutOn(uniqueId, count, highPrice, lowPrice, type)
  local reqTable = {}
  
  if uniqueId ~= nil then
    reqTable.uniqueId = uniqueId
  end
  if count ~= nil then
    reqTable.count = count
  end
  if highPrice ~= nil then
    reqTable.highPrice = highPrice
  end
  if lowPrice ~= nil then
    reqTable.lowPrice = lowPrice
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(TradeMessage.ReqPutOn, reqTable)
end

function networkRequest.ReqPutOff(tid, type)
  local reqTable = {}
  if tid ~= nil then
    reqTable.tid = tid
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(TradeMessage.ReqPutOff, reqTable)
end

function networkRequest.ReqLsTrade(index, type, condition)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  if type ~= nil then
    reqTable.type = type
  end
  if condition ~= nil then
    reqTable.condition = condition
  end
  NetManager.Send(TradeMessage.ReqLsTrade, reqTable)
end

function networkRequest.ReqOpenTradePanel(state)
  local reqTable = {}
  if state ~= nil then
    reqTable.state = state
  end
  NetManager.Send(TradeMessage.ReqOpenTradePanel, reqTable)
end

function networkRequest.ReqStartBuy(centerHostId, hostId, tid, buyPrice, count, type)
  local reqTable = {}
  if centerHostId ~= nil then
    reqTable.centerHostId = centerHostId
  end
  if hostId ~= nil then
    reqTable.hostId = hostId
  end
  if tid ~= nil then
    reqTable.tid = tid
  end
  if buyPrice ~= nil then
    reqTable.buyPrice = buyPrice
  end
  if count ~= nil then
    reqTable.count = count
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(TradeMessage.ReqStartBuy, reqTable)
end

function networkRequest.ReqLookItemAveragePrice(itemId)
  local reqTable = {}
  if itemId ~= nil then
    reqTable.itemId = itemId
  end
  NetManager.Send(TradeMessage.ReqLookItemAveragePrice, reqTable)
end

function networkRequest.ReqAuctionStallPosition(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(TradeMessage.ReqAuctionStallPosition, reqTable)
end

function networkRequest.ReqAuctionInfo(position)
  local reqTable = {}
  if position ~= nil then
    reqTable.position = position
  end
  NetManager.Send(TradeMessage.ReqAuctionInfo, reqTable)
end

function networkRequest.ReqBuyAuctionPosition(title, position, stallCost)
  local reqTable = {}
  if title ~= nil then
    reqTable.title = title
  end
  if position ~= nil then
    reqTable.position = position
  end
  if stallCost ~= nil then
    reqTable.stallCost = stallCost
  end
  NetManager.Send(TradeMessage.ReqBuyAuctionPosition, reqTable)
end

function networkRequest.ReqCloseAuction()
  NetManager.Send(TradeMessage.ReqCloseAuction)
end
