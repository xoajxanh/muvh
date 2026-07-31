function networkRequest.ReqAchievementInfo()
  NetManager.Send(AchievementMessage.ReqAchievementInfo)
end

function networkRequest.ReqGetAchievementReward(id)
  local reqTable = {}
  if id ~= nil then
    reqTable.id = id
  end
  NetManager.Send(AchievementMessage.ReqGetAchievementReward, reqTable)
end
