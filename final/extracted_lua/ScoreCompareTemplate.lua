local ScoreCompareTemplate = {}
ScoreCompareTemplate._endTime = nil

function ScoreCompareTemplate:Init()
  self:InitComponent()
end

function ScoreCompareTemplate:InitComponent()
  self.timeCount = self:GetControl("timeTip/timeCount")
  self.ourRank = self:GetControl("ourRank")
  self.enemyRank = self:GetControl("enemyRank")
end

function ScoreCompareTemplate:Refresh(param)
  if self:AnalysisParams(param) == false then
    return
  end
  self:RefreshOurScore(param.ourScore or 0)
  self:RefreshEnemyScore(param.enemyScore or 0)
  self:RefreshCountDown()
end

function ScoreCompareTemplate:AnalysisParams(param)
  if param == nil or param.endTime == nil then
    return false
  end
  local remainTime = TimeUtility.GetRemainSecTime(param.endTime)
  if remainTime <= 0 then
    return false
  end
  self._endTime = param.endTime
  return true
end

function ScoreCompareTemplate:RefreshScore(score, comp)
  if score ~= nil and comp ~= nil then
    if comp == EThreeVSThreePlayerCamp.Red then
      self.enemyRank:SetText(score)
    elseif comp == EThreeVSThreePlayerCamp.Blue then
      self.ourRank:SetText(score)
    end
  end
end

function ScoreCompareTemplate:RefreshOurScore(score)
  local mainPlayerInfo = QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfo(RoleManager.me.id)
  if mainPlayerInfo ~= nil then
    local camp = mainPlayerInfo:GetGroupId()
    self:RefreshScore(score, camp)
  end
end

function ScoreCompareTemplate:RefreshEnemyScore(score)
  local mainPlayerInfo = QuickFind:GetThreeVsThreeDataMgr():GetMainPlayerCampInfo():GetPlayerInfo(RoleManager.me.id)
  if mainPlayerInfo ~= nil then
    local camp = mainPlayerInfo:GetGroupId() == EThreeVSThreePlayerCamp.Red and EThreeVSThreePlayerCamp.Blue or EThreeVSThreePlayerCamp.Red
    self:RefreshScore(score, camp)
  end
end

function ScoreCompareTemplate:RefreshCountDown()
  self:StopTimer()
  self.countDownTimer = Timer.StartLoopForever(1, self.StartTimer, self)
end

function ScoreCompareTemplate:StopTimer()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function ScoreCompareTemplate:StartTimer()
  local time = TimeUtility.ShowTimeHour(TimeUtility.GetRemainSecTime(self._endTime))
  if string.isNullOrEmpty(time) then
    time = "00:00"
  end
  self.timeCount:SetText(time)
end

function ScoreCompareTemplate:Destroy()
  self:StopTimer()
end

return ScoreCompareTemplate
