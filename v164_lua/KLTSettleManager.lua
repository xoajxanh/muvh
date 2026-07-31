local KLTSettleManager = {}
KLTSettleManager.settleInfo = nil

function KLTSettleManager:ChangeSettleInfoByServer(serverData)
  if self:AnalysisServerData(serverData) == false then
    return
  end
  EventManager.Dispatch(Event.KalunteRuinsColetSettle)
end

function KLTSettleManager:AnalysisServerData(serverData)
  if serverData == nil or serverData.reliveRank == nil or serverData.gainExpCount == nil or serverData.gainBoxCount == nil or serverData.killPlayerCount == nil then
    return false
  end
  self.serverData = serverData
  if self.settleInfo == nil then
    self.settleInfo = {}
  end
  self.settleInfo.reliveRank = serverData.reliveRank
  self.settleInfo.gainExpCount = serverData.gainExpCount
  self.settleInfo.gainBoxCount = serverData.gainBoxCount
  self.settleInfo.killPlayerCount = serverData.killPlayerCount
  return true
end

function KLTSettleManager:GetSettleInfo()
  return self.settleInfo
end

return KLTSettleManager
