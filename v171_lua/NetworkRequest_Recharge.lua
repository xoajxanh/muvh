function networkRequest.ReqGetGift(id)
  local reqTable = {}
  
  if id ~= nil then
    reqTable.id = id
  else
    reqTable.id = {}
  end
  NetManager.Send(RechargeMessage.ReqGetGift, reqTable)
end

function networkRequest.ReqEverydayRechargeInfo()
  NetManager.Send(RechargeMessage.ReqEverydayRechargeInfo)
end

function networkRequest.ReqDailyRechargeInfo()
  NetManager.Send(RechargeMessage.ReqDailyRechargeInfo)
end

function networkRequest.ReqSkyPavilionInfo()
  NetManager.Send(RechargeMessage.ReqSkyPavilionInfo)
end

function networkRequest.ReqGetAllSkyPavilionReward()
  NetManager.Send(RechargeMessage.ReqGetAllSkyPavilionReward)
end

function networkRequest.ReqDirectRepayInfo()
  NetManager.Send(RechargeMessage.ReqDirectRepayInfo)
end

function networkRequest.ReqCheckRecharge(id, rmb, diamond, reward, name, payType)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if rmb ~= nil then
    reqTable.rmb = rmb
  end
  if diamond ~= nil then
    reqTable.diamond = diamond
  end
  if reward ~= nil then
    reqTable.reward = reward
  end
  if name ~= nil then
    reqTable.name = name
  end
  if payType ~= nil then
    reqTable.payType = payType
  end
  NetManager.Send(RechargeMessage.ReqCheckRecharge, reqTable)
end

function networkRequest.ReqCheckSwitchRecharge(id, rmb, name, payType)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if rmb ~= nil then
    reqTable.rmb = rmb
  end
  if name ~= nil then
    reqTable.name = name
  end
  if payType ~= nil then
    reqTable.payType = payType
  end
  NetManager.Send(RechargeMessage.ReqCheckSwitchRecharge, reqTable)
end

function networkRequest.ReqLastStarInfo(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(RechargeMessage.ReqLastStarInfo, reqTable)
end

function networkRequest.ReqSurpriseGiftInfo()
  NetManager.Send(RechargeMessage.ReqSurpriseGiftInfo)
end

function networkRequest.ReqReissue(serviceCode, type)
  local reqTable = {}
  if serviceCode ~= nil then
    reqTable.serviceCode = serviceCode
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(RechargeMessage.ReqReissue, reqTable)
end

function networkRequest.ReqModelRecharge(rechargeId, type)
  local reqTable = {}
  if rechargeId ~= nil then
    reqTable.rechargeId = rechargeId
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(RechargeMessage.ReqModelRecharge, reqTable)
end

function networkRequest.ReqFinishPCRedPoint()
  NetManager.Send(RechargeMessage.ReqFinishPCRedPoint)
end
