function networkRequest.ReqGetCommercialActivityTab(icon)
  local reqTable = {}
  
  if icon ~= nil then
    reqTable.icon = icon
  end
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityTab, reqTable)
end

function networkRequest.ReqGetCommercialActivityInfo(icon, groupId, changePage)
  local reqTable = {}
  if icon ~= nil then
    reqTable.icon = icon
  end
  if groupId ~= nil then
    reqTable.groupId = groupId
  end
  if changePage ~= nil then
    reqTable.changePage = changePage
  end
  NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, reqTable)
end

function networkRequest.ReqSevenDaySign(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(CommerceMessage.ReqSevenDaySign, reqTable)
end

function networkRequest.ReqSevenDayReissue(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(CommerceMessage.ReqSevenDayReissue, reqTable)
end

function networkRequest.ReqExchange(commerceId)
  local reqTable = {}
  if commerceId ~= nil then
    reqTable.commerceId = commerceId
  end
  NetManager.Send(CommerceMessage.ReqExchange, reqTable)
end

function networkRequest.ReqActiveGuardInvest(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CommerceMessage.ReqActiveGuardInvest, reqTable)
end

function networkRequest.ReqTreasureHunt(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CommerceMessage.ReqTreasureHunt, reqTable)
end

function networkRequest.ReqTreasureHuntAccumulatedAward(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(CommerceMessage.ReqTreasureHuntAccumulatedAward, reqTable)
end

function networkRequest.ReqLuckTurntable(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CommerceMessage.ReqLuckTurntable, reqTable)
end

function networkRequest.ReqZhanLingReward(rewardId)
  local reqTable = {}
  if rewardId ~= nil then
    reqTable.rewardId = rewardId
  else
    reqTable.rewardId = {}
  end
  NetManager.Send(CommerceMessage.ReqZhanLingReward, reqTable)
end

function networkRequest.ReqBuyZhanLing(type)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CommerceMessage.ReqBuyZhanLing, reqTable)
end

function networkRequest.ReqWorldCupGuessing(id, choice)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if choice ~= nil then
    reqTable.choice = choice
  end
  NetManager.Send(CommerceMessage.ReqWorldCupGuessing, reqTable)
end

function networkRequest.ReqWorldCupGuessingReceiveReward(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(CommerceMessage.ReqWorldCupGuessingReceiveReward, reqTable)
end

function networkRequest.ReqAccumulateRechargeActivityInfo()
  local reqTable = {}
  NetManager.Send(CommerceMessage.ReqAccumulateRechargeActivityInfo, reqTable)
end

function networkRequest.ReqAccumulateRechargeActivityGetAward(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(CommerceMessage.ReqAccumulateRechargeActivityGetAward, reqTable)
end

function networkRequest.ReqQianDaoInfo()
  NetManager.Send(CommerceMessage.ReqQianDaoInfo)
end

function networkRequest.ReqFirecrackerTreasureHuntInfo(index)
  local reqTable = {}
  if index ~= nil then
    reqTable.index = index
  end
  NetManager.Send(CommerceMessage.ReqFirecrackerTreasureHuntInfo, reqTable)
end

function networkRequest.ReqGetFireAlreadyReceived(configId)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(CommerceMessage.ReqGetFireAlreadyReceived, reqTable)
end

function networkRequest.ReqSevenDaysGiftsInfo()
  NetManager.Send(CommerceMessage.ReqSevenDaysGiftsInfo)
end

function networkRequest.ReqGetYuTuAward()
  local reqTable = {}
  NetManager.Send(CommerceMessage.ReqGetYuTuAward, reqTable)
end

function networkRequest.ReqSevenDaysGiftsReward(configId)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(CommerceMessage.ReqSevenDaysGiftsReward, reqTable)
end

function networkRequest.ReqQianDaoReward(configId)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(CommerceMessage.ReqQianDaoReward, reqTable)
end

function networkRequest.ReqOpenServiceInfo(rewardId)
  local reqTable = {}
  if rewardId ~= nil then
    reqTable.rewardId = rewardId
  end
  NetManager.Send(CommerceMessage.ReqOpenServiceInfo, reqTable)
end

function networkRequest.ReqCooperativeServiceInfo()
  NetManager.Send(CommerceMessage.ReqCooperativeServiceInfo)
end

function networkRequest.ReqCooperativeServiceReward(configId)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(CommerceMessage.ReqCooperativeServiceReward, reqTable)
end

function networkRequest.ReqLuckyRebateReward(configId)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(CommerceMessage.ReqLuckyRebateReward, reqTable)
end

function networkRequest.ReqLuckDiamondGashapon(count)
  local reqTable = {}
  if count ~= nil then
    reqTable.count = count
  end
  NetManager.Send(CommerceMessage.ReqLuckDiamondGashapon, reqTable)
end

function networkRequest.ReqDiamondGashaponReward(configId)
  local reqTable = {}
  if configId ~= nil then
    reqTable.configId = configId
  end
  NetManager.Send(CommerceMessage.ReqDiamondGashaponReward, reqTable)
end

function networkRequest.ReqDiamondGashaponInfo()
  NetManager.Send(CommerceMessage.ReqDiamondGashaponInfo)
end

function networkRequest.ReqInvestRewardInfo(id, finishCount, hasReward)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  if finishCount ~= nil then
    reqTable.finishCount = finishCount
  end
  if hasReward ~= nil then
    reqTable.hasReward = hasReward
  end
  NetManager.Send(CommerceMessage.ReqInvestRewardInfo, reqTable)
end

function networkRequest.ReqActiveInvest(position)
  local reqTable = {}
  if position ~= nil then
    reqTable.position = position
  end
  NetManager.Send(CommerceMessage.ReqActiveInvest, reqTable)
end

function networkRequest.ReqSettingRegionName(regionName)
  local reqTable = {}
  if regionName ~= nil then
    reqTable.regionName = regionName
  end
  NetManager.Send(CommerceMessage.ReqSettingRegionName, reqTable)
end

function networkRequest.ReqCheckText(text)
  local reqTable = {}
  if text ~= nil then
    reqTable.text = text
  end
  NetManager.Send(CommerceMessage.ReqCheckText, reqTable)
end

function networkRequest.ReqActivityRechargeInfo()
  local reqTable = {}
  NetManager.Send(CommerceMessage.ReqActivityRechargeInfo, reqTable)
end

function networkRequest.ReqAddToCar(shoppingId)
  local reqTable = {}
  if shoppingId ~= nil then
    reqTable.shoppingId = shoppingId
  end
  NetManager.Send(CommerceMessage.ReqAddToCar, reqTable)
end

function networkRequest.ReqRemoveOutCar(shoppingId)
  local reqTable = {}
  if shoppingId ~= nil then
    reqTable.shoppingId = shoppingId
  end
  NetManager.Send(CommerceMessage.ReqRemoveOutCar, reqTable)
end

function networkRequest.ReqSettlementCrazyCar()
  NetManager.Send(CommerceMessage.ReqSettlementCrazyCar)
end

function networkRequest.ReqPandoraLottery(commerceId, isFree)
  local reqTable = {}
  if commerceId ~= nil then
    reqTable.commerceId = commerceId
  end
  if isFree ~= nil then
    reqTable.isFree = isFree
  end
  NetManager.Send(CommerceMessage.ReqPandoraLottery, reqTable)
end

function networkRequest.ReqPandoraInfo(commerceId)
  local reqTable = {}
  if commerceId ~= nil then
    reqTable.commerceId = commerceId
  end
  NetManager.Send(CommerceMessage.ReqPandoraInfo, reqTable)
end

function networkRequest.ReqPandoraInfinite(type, commerceId)
  local reqTable = {}
  if type ~= nil then
    reqTable.type = type
  end
  if commerceId ~= nil then
    reqTable.commerceId = commerceId
  end
  NetManager.Send(CommerceMessage.ReqPandoraInfinite, reqTable)
end

function networkRequest.ReqPandoraRareChoose(choose, commerceId)
  local reqTable = {}
  if choose ~= nil then
    reqTable.choose = choose
  end
  if commerceId ~= nil then
    reqTable.commerceId = commerceId
  end
  NetManager.Send(CommerceMessage.ReqPandoraRareChoose, reqTable)
end

function networkRequest.ReqAwardXunLi(rewards)
  local reqTable = {}
  if rewards ~= nil then
    reqTable.rewards = rewards
  else
    reqTable.rewards = {}
  end
  NetManager.Send(CommerceMessage.ReqAwardXunLi, reqTable)
end

function networkRequest.ReqGoalAward(rewards, type)
  local reqTable = {}
  if rewards ~= nil then
    reqTable.rewards = rewards
  else
    reqTable.rewards = {}
  end
  if type ~= nil then
    reqTable.type = type
  end
  NetManager.Send(CommerceMessage.ReqGoalAward, reqTable)
end

function networkRequest.ReqAnniversaryReward(rewardId, commerceId)
  local reqTable = {}
  if rewardId ~= nil then
    reqTable.rewardId = rewardId
  else
    reqTable.rewardId = {}
  end
  if commerceId ~= nil then
    reqTable.commerceId = commerceId
  end
  NetManager.Send(CommerceMessage.ReqAnniversaryReward, reqTable)
end
