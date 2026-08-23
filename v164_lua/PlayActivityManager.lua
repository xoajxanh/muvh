local PlayActivityManager = {}
setmetatable(PlayActivityManager, LuaClass.ActivityManagerBase)

function PlayActivityManager:GetActivityTbl()
  return ClientTable.cfg_Activity_overviewManager:GetDic()
end

function PlayActivityManager:GetActivityClass(activityId)
  if activityId == PlayActivityIdType.CoalitionSiege then
    return LuaClass.CoalitionSiege:New()
  elseif activityId == PlayActivityIdType.KunShouBattle then
    return LuaClass.LuaKunShouBattleDataMgr:New()
  elseif activityId == PlayActivityIdType.ThreeVsThree then
    return LuaClass.ThreeVsThreeDataMgr:New()
  elseif activityId == PlayActivityIdType.DuoQiCross then
    return LuaClass.DuoQiCrossDataManager:New()
  elseif activityId == PlayActivityIdType.DuoQiZhengBa then
    return LuaClass.DuoQiZhengBaDataManager:New()
  elseif activityId == PlayActivityIdType.SpaceCrack then
    return LuaClass.SpaceCrackActivityData:New()
  elseif activityId == PlayActivityIdType.SiFangZhengBa then
    return LuaClass.SiFangZhengBaData:New()
  end
  return LuaClass.PlayActivity:New()
end

function PlayActivityManager:GetActivityChangeEventId()
  return Event.PlayActivityStateChange
end

return PlayActivityManager
