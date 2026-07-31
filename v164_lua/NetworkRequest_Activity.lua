function networkRequest.ReqGetLuoLanXiaGuGongChengActivityWinUnion()
  local reqTable = {}
  
  NetManager.Send(ActivityMessage.ReqGetLuoLanXiaGuGongChengActivityWinUnion, reqTable)
end

function networkRequest.ReqSignChiSeYaoSaiActivity()
  NetManager.Send(ActivityMessage.ReqSignChiSeYaoSaiActivity)
end

function networkRequest.ReqLangHunYaoSaiProtectStatusActivityChooseBuff(buffId)
  local reqTable = {}
  if buffId ~= nil then
    reqTable.buffId = buffId
  end
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiProtectStatusActivityChooseBuff, reqTable)
end

function networkRequest.ReqUnionBossKillBossActivityData()
  local reqTable = {}
  NetManager.Send(ActivityMessage.ReqUnionBossKillBossActivityData, reqTable)
end

function networkRequest.ReqLangHunYaoSaiQueryUnionCoin()
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiQueryUnionCoin)
end

function networkRequest.ReqLangHunYaoSaiChooseTalent(position, index)
  local reqTable = {}
  if position ~= nil then
    reqTable.position = position
  end
  if index ~= nil then
    reqTable.index = index
  end
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiChooseTalent, reqTable)
end

function networkRequest.ReqLangHunYaoSaiTalent()
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiTalent)
end

function networkRequest.ReqLangHunYaoSaiFlushTalent()
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiFlushTalent)
end

function networkRequest.ReqHuoLongLaiXiCount()
  NetManager.Send(ActivityMessage.ReqHuoLongLaiXiCount)
end

function networkRequest.ReqReceiveEvaluateGift(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(ActivityMessage.ReqReceiveEvaluateGift, reqTable)
end

function networkRequest.ReqActivityResult(functionId)
  local reqTable = {}
  if functionId ~= nil then
    reqTable.functionId = functionId
  end
  NetManager.Send(ActivityMessage.ReqActivityResult, reqTable)
end
