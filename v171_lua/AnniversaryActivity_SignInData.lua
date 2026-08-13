AnniversaryActivity_SignInData = {}
AnniversaryActivity_SignInData.commerceId = 0
AnniversaryActivity_SignInData.signInData = {}

function AnniversaryActivity_SignInData.SetSignInInfo(data)
  if data then
    AnniversaryActivity_SignInData.signInData = data.qianDaoInfos
  end
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.AnniversaryActivity_qiandao
  })
end

function AnniversaryActivity_SignInData.SetSignInData(data)
  if data ~= nil then
    AnniversaryActivity_SignInData.commerceId = ClientTable.cfg_Commerce_overviewManager:TryGetValue(data.groupId, "group").commerceId or nil
  end
end

function AnniversaryActivity_SignInData.GetSignInInfo()
  if not AnniversaryActivity_SignInData.signInData then
    return
  end
  local itemData = AnniversaryActivity_SignInData.signInData
  table.sort(itemData, function(a, b)
    return a.goalId < b.goalId
  end)
  for i, v in pairs(itemData) do
    local cfg = ClientTable.cfg_Commerce_qiandaoManager:TryGetValue(v.configId)
    if cfg then
      v.cfgInfo = cfg
    end
  end
  return itemData
end

function AnniversaryActivity_SignInData.GetSignInReward(data)
  if not data.giftId then
    return
  end
  local reward = ClientTable.cfg_Gift_giftManager:TryGetValue(data.giftId)
  if not reward then
    return
  end
  local boxData = ClientTable.cfg_Box_boxManager:TryGetValue(reward.reward, "boxId")
  return reward, boxData
end

function AnniversaryActivity_SignInData.GetSignInTaskGoalData(taskId)
  return ClientTable.cfg_Task_goalManager:TryGetValue(taskId)
end

function AnniversaryActivity_SignInData.CheckRedPoint()
  if next(AnniversaryActivity_SignInData.signInData) == nil then
    return false
  end
  for _, v in pairs(AnniversaryActivity_SignInData.signInData) do
    if v.hasReward == false and v.count <= v.current then
      return true
    end
  end
  return false
end
