local LuaKillNoticeDataMgr = {}

function LuaKillNoticeDataMgr:NoticeList()
  if self.mKillNoticeList == nil then
    self.mKillNoticeList = {}
  end
  return self.mKillNoticeList
end

function LuaKillNoticeDataMgr:ProtagonistNoticeList()
  if self.mProtagonistKillNoticeList == nil then
    self.mProtagonistKillNoticeList = {}
  end
  return self.mProtagonistKillNoticeList
end

function LuaKillNoticeDataMgr:ScoreNoticeList()
  if self.mScoreNoticeList == nil then
    self.mScoreNoticeList = {}
  end
  return self.mScoreNoticeList
end

function LuaKillNoticeDataMgr:GetWaitTime()
  if self.waitTime == nil then
    self.waitTime = ClientTable.cfg_Activity_globalManager:GetKSBattleNoticeShowTime()
  end
  return self.waitTime
end

function LuaKillNoticeDataMgr:Init()
  self:InitParam()
  self:BindEventMsg()
end

function LuaKillNoticeDataMgr:InitParam()
  self.doRefresh = false
  self.curNoticeData = nil
  self.eventContainer = EventContainer(EventManager)
end

function LuaKillNoticeDataMgr:BindEventMsg()
  self.eventContainer:Regist(Event.ClearkillNotice, self.ClearkillNoticeCallBack, self)
  self.eventContainer:Regist(Event.ShowkillNotice, self.ShowkillTipsCallBack, self)
  self.eventContainer:Regist(Event.RefreshNoticeMaxKillCount, self.RefreshKillCountCallBack, self)
end

function LuaKillNoticeDataMgr:ShowkillTipsCallBack(id, data)
  if data == nil or data.chatId == nil then
    return
  end
  if data.killer and data.killer.lid == RoleManager.me.id then
    table.insert(self:ProtagonistNoticeList(), data)
  else
    table.insert(self:NoticeList(), data)
  end
  self:TryStart()
end

function LuaKillNoticeDataMgr:RefreshKillCountCallBack(id, num)
  if self.mIndividualKillNum == num then
    return
  end
  self.mIndividualKillNum = num
  EventManager.Dispatch(Event.RefreshMaxKillNoticeView)
  if QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi() == true then
    EventManager.Dispatch(Event.UnionKillAniPlay)
  end
  if FourPartyRivalryManager:IsEnterFourPartyRivalryMap() then
    EventManager.Dispatch(Event.PlayFourPartyRivalryKillNotice)
  end
end

function LuaKillNoticeDataMgr:RefreshScoreCountCallBack(id, num)
  if self.mIndividualKillNum == num then
    return
  end
  self.mIndividualKillNum = num
  EventManager.Dispatch(Event.RefreshMaxKillNoticeView)
end

function LuaKillNoticeDataMgr:ClearkillNoticeCallBack()
  self:Clear()
end

function LuaKillNoticeDataMgr:TryStart()
  if self.doRefresh then
    return
  end
  self.doRefresh = true
  self:DoFor()
  self:StartNoticeLoop()
end

function LuaKillNoticeDataMgr:StartNoticeLoop()
  self:StopKillNoticeTimer()
  if self.isNeedRefreshTime or self.DoRefreshNoticeTimer == nil then
    self.waitTime = self:GetWaitTime()
    self.DoRefreshNoticeTimer = Timer.StartLoopForever(self.waitTime, self.DoFor, self)
  end
end

function LuaKillNoticeDataMgr:DoFor()
  if not self.doRefresh then
    return
  end
  self.curNoticeData = nil
  if next(self:ProtagonistNoticeList()) then
    self.curNoticeData = self:ProtagonistNoticeList()[1]
    table.remove(self:ProtagonistNoticeList(), 1)
  elseif next(self:NoticeList()) then
    self.curNoticeData = self:NoticeList()[1]
    table.remove(self:NoticeList(), 1)
  else
    self:StopKillNoticeTimer()
    return
  end
  EventManager.Dispatch(Event.RefreshKillNoticeView, self.curNoticeData)
end

function LuaKillNoticeDataMgr:StopKillNoticeTimer()
  self.doRefresh = false
  if self.DoRefreshNoticeTimer then
    Timer.Stop(self.DoRefreshNoticeTimer)
    self.DoRefreshNoticeTimer = nil
  end
end

function LuaKillNoticeDataMgr:RefreshScoreData(data)
  if data == nil then
    return
  end
  table.insert(self:ScoreNoticeList(), data.score)
  EventManager.Dispatch(Event.RefreshScoreNoticeView)
end

function LuaKillNoticeDataMgr:PopScoreData()
  local temp
  if self:CheckHaveScoreData() then
    temp = self:ScoreNoticeList()[1]
    table.remove(self:ScoreNoticeList(), 1)
  end
  return temp
end

function LuaKillNoticeDataMgr:CheckHaveScoreData()
  return next(self:ScoreNoticeList()) ~= nil
end

function LuaKillNoticeDataMgr:NewScoreInfoByData()
end

function LuaKillNoticeDataMgr:IndividualKillNum()
  return self.mIndividualKillNum or 0
end

function LuaKillNoticeDataMgr:Clear()
  self.mIndividualKillNum = nil
  self:StopKillNoticeTimer()
  self.mKillNoticeList = nil
  self.mProtagonistKillNoticeList = nil
  self.mScoreNoticeList = nil
end

function LuaKillNoticeDataMgr:OnDestruct()
  self:RunBaseFunction("OnDestruct")
  if self.mNoticeAnimatorCoroutine then
    Coroutine.Stop(self.mNoticeAnimatorCoroutine)
    self.mNoticeAnimatorCoroutine = nil
  end
end

return LuaKillNoticeDataMgr
