local LuckyRebateScrollTemplate = {}

function LuckyRebateScrollTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:InitData()
end

function LuckyRebateScrollTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.Number_1 = self:GetControl("n_1")
  self.Number_2 = self:GetControl("n_2")
end

function LuckyRebateScrollTemplate:InitContainer()
end

function LuckyRebateScrollTemplate:InitData()
  self.startPosX, self.startShowPosY = self.Number_1:GetAnchoredPosition()
  _, self.high = self.Number_1:GetSizeDelta()
  self.startMovePosY = self.startShowPosY + self.high
  self.intervalTime = 0.02
  self.moveDistance = 0
  self.curTimes = 0
  self.curPlayTime = 0
  self.position = {
    Vector2(0, 0),
    Vector2(0, 1),
    Vector2(0, 1),
    Vector2(1, 1)
  }
  self.bezier = PointMgr.InitBezier(self.position)
end

function LuckyRebateScrollTemplate:BindUIEvent()
end

function LuckyRebateScrollTemplate:Refresh(data)
  if data == nil then
    return
  end
  self.Number_1:SetText(tostring(data))
  self.Number_1:SetAnchoredPosition(self.startPosX, self.startShowPosY)
  self.Number_2:SetAnchoredPosition(self.startPosX, self.startMovePosY)
end

function LuckyRebateScrollTemplate:RefreshScroll(scrollCount, playTime)
  if type(scrollCount) ~= "number" or type(playTime) ~= "number" then
    return
  end
  self.curTimes = 0
  self.moveDistance = 0
  self.curPlayTime = 0
  self.scrollCount = scrollCount
  self.totalDistance = self.scrollCount * self.high
  self.playTime = playTime
  self.LoopTimer = Timer.StartLoop(self.intervalTime, math.modf(self.playTime / self.intervalTime), self.BezierMoveScroll, self)
end

function LuckyRebateScrollTemplate:BezierMoveScroll()
  self.curPlayTime = self.curPlayTime + self.intervalTime
  if math.abs(self.playTime - self.curPlayTime) <= 1.0E-6 then
    EventManager.Dispatch(Event.LuckyRebatePlayAnimStateChange, LuckyRebateAnimState.OneFinish)
  end
  local pointPosition = PointMgr.GetBezierPoint(self.bezier, self.curPlayTime / self.playTime)
  local moveDistance = pointPosition.y * self.totalDistance
  local curTimes = math.modf(moveDistance / self.high)
  moveDistance = moveDistance - curTimes * self.high
  local showNum = curTimes % 10
  if curTimes % 2 == 0 then
    self:RefreshNumber(self.Number_2, self.Number_1, moveDistance, showNum)
  else
    self:RefreshNumber(self.Number_1, self.Number_2, moveDistance, showNum)
  end
end

function LuckyRebateScrollTemplate:RefreshNumber(moveControl, showControl, moveDistance, showNum)
  moveControl:SetAnchoredPosition(self.startPosX, self.startMovePosY - moveDistance)
  showControl:SetAnchoredPosition(self.startPosX, self.startShowPosY - moveDistance)
  moveControl:SetText(math.modf((showNum + 1) % 10))
  showControl:SetText(math.modf(showNum))
end

function LuckyRebateScrollTemplate:Exit()
  self:DestroyTime()
end

function LuckyRebateScrollTemplate:DestroyTime()
  if self.LoopTimer then
    Timer.Stop(self.LoopTimer)
    self.LoopTimer = nil
  end
end

return LuckyRebateScrollTemplate
