function networkRequest.ReqBuy(goodId, buyCount, buyEntrance, autoBuyLiquid)
  local reqTable = {}
  
  if goodId ~= nil then
    reqTable.goodId = goodId
  end
  if buyCount ~= nil then
    reqTable.buyCount = buyCount
  end
  if buyEntrance ~= nil then
    reqTable.buyEntrance = buyEntrance
  end
  if autoBuyLiquid ~= nil then
    reqTable.autoBuyLiquid = autoBuyLiquid
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, reqTable)
end

function networkRequest.ReqBossRewardBuy(goodId, buyCount, buyEntrance, taskId)
  local reqTable = {}
  if goodId ~= nil then
    reqTable.goodId = goodId
  end
  if buyCount ~= nil then
    reqTable.buyCount = buyCount
  end
  if buyEntrance ~= nil then
    reqTable.buyEntrance = buyEntrance
  end
  if taskId ~= nil then
    reqTable.taskId = taskId
  end
  NetManager.Send(ItemBuyMessage.ReqBossRewardBuy, reqTable)
end
