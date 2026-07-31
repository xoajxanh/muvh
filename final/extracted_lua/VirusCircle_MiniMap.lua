local VirusCircle_MiniMap = {}
VirusCircle_MiniMap.VirusCircleBaseParams = nil
VirusCircle_MiniMap.VirusCircleMiniMapNoticeInfo = nil

function VirusCircle_MiniMap:GetVirusCircleManager()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetActivityDataMgr():GetKLTRuinsManager():GetVirusCircleManager()
end

function VirusCircle_MiniMap:ChangeMiniMapVirusCircle(baseParams)
  if self:AnalysisParams(baseParams) == false then
    return
  end
  self:NoticeVirusCircleChange()
end

function VirusCircle_MiniMap:AnalysisParams(baseParams)
  self.VirusCircleBaseParams = baseParams
  return true
end

function VirusCircle_MiniMap:NoticeVirusCircleChange()
  local noticeParams = {}
  noticeParams.endTime = self.VirusCircleBaseParams.changeEndTime
  if self.VirusCircleBaseParams.changeEndTime ~= nil and self.VirusCircleBaseParams.changeStartTime ~= nil then
    noticeParams.totalTime = self.VirusCircleBaseParams.changeEndTime - self.VirusCircleBaseParams.changeStartTime
  end
  noticeParams.startPoint = self:GetStartPoint()
  noticeParams.endPoint = self.VirusCircleBaseParams.centerPoint
  noticeParams.pointOffset = self.VirusCircleBaseParams.pointOffset
  noticeParams.startWidth = self:GetStartWidth()
  noticeParams.endWidth = self.VirusCircleBaseParams.width
  noticeParams.widthOffset = self.VirusCircleBaseParams.widthOffset
  self.VirusCircleMiniMapNoticeInfo = noticeParams
  EventManager.Dispatch(Event.KalunteRuinsVirusCircleChange, noticeParams)
end

function VirusCircle_MiniMap:GetStartPoint()
  local isLerp = self:GetVirusCircleManager().IsLerpCirle(self.VirusCircleBaseParams)
  if isLerp == false then
    return self.VirusCircleBaseParams.centerPoint
  end
  return self:GetVirusCircleManager().GetLerpStartPoint(self.VirusCircleBaseParams)
end

function VirusCircle_MiniMap:GetStartWidth()
  local isLerp = self:GetVirusCircleManager().IsLerpCirle(self.VirusCircleBaseParams)
  local width = self.VirusCircleBaseParams.width
  if isLerp then
    width = self:GetVirusCircleManager().GetLerpStartWidth(self.VirusCircleBaseParams)
  end
  return width
end

function VirusCircle_MiniMap:GetMaskItemDefaultPosDic()
  if self.MaskItemDefaultPosDic == nil then
    self.MaskItemDefaultPosDic = {}
    self.MaskItemDefaultPosDic[1] = Vector3(10, 10, 0)
    self.MaskItemDefaultPosDic[2] = Vector3(10, -1990, 0)
    self.MaskItemDefaultPosDic[3] = Vector3(2010, -1990, 0)
    self.MaskItemDefaultPosDic[4] = Vector3(2010, 10, 0)
  end
  return self.MaskItemDefaultPosDic
end

function VirusCircle_MiniMap:GetMaskItemChangePosDic(width)
  local dic = self:GetMaskItemDefaultPosDic()
  if self.MaskItemChangePosDic == nil then
    self.MaskItemChangePosDic = {}
    for i = 1, 4 do
      self.MaskItemChangePosDic[i] = Vector3(0, 0, 0)
    end
  end
  self.MaskItemChangePosDic[1]:Set(dic[1].x - width, dic[1].y - width, 0)
  self.MaskItemChangePosDic[2]:Set(dic[2].x + width, dic[2].y - width, 0)
  self.MaskItemChangePosDic[3]:Set(dic[3].x + width, dic[3].y + width, 0)
  self.MaskItemChangePosDic[4]:Set(dic[4].x - width, dic[4].y + width, 0)
  return self.MaskItemChangePosDic
end

function VirusCircle_MiniMap:Exit()
  self.VirusCircleBaseParams = nil
  self.VirusCircleMiniMapNoticeInfo = nil
end

return VirusCircle_MiniMap
