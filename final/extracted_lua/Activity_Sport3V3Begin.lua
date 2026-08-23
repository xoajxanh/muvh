Activity_Sport3V3Begin = class(BaseUI)
Activity_Sport3V3Begin.layer = UILayer.Tip
Activity_Sport3V3Begin.orderInLayer = 0
Activity_Sport3V3Begin.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Begin.hideFunc = UIHideFunc.Deactive
Activity_Sport3V3Begin.escClose = UIEscClose.DontClose

function Activity_Sport3V3Begin:InitControls()
  self.tip = self:GetControl("startBg/tip")
end

Activity_Sport3V3Begin.data = nil

function Activity_Sport3V3Begin:Init()
end

function Activity_Sport3V3Begin:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_Sport3V3Begin:InitUI()
end

function Activity_Sport3V3Begin:RegistUIEvents()
end

function Activity_Sport3V3Begin:OnShow()
  if self:AnalysisParams() == false then
    self:Hide()
    return
  end
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Begin:AnalysisParams()
  if self.args == nil or self.args.textFormat == nil or self.args.endTime == nil then
    return false
  end
  self.data = self.args
  local remainTime = TimeUtility.GetRemainSecTime(self.data.endTime)
  if remainTime < 0 then
    return false
  end
  return true
end

function Activity_Sport3V3Begin:RegistEvents()
end

function Activity_Sport3V3Begin:Refresh()
  self:RefreshCountDown()
end

function Activity_Sport3V3Begin:RefreshCountDown()
  self:StopTimer()
  self:StartTimer()
  self.countDownTimer = Timer.StartLoopForever(0.2, self.StartTimer, self)
end

function Activity_Sport3V3Begin:StopTimer()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function Activity_Sport3V3Begin:StartTimer()
  local remainTime = TimeUtility.GetRemainSecTime(self.data.endTime)
  if remainTime < 0 then
    remainTime = 0
    self:Hide()
    if self.data.endCallBack ~= nil then
      self.data.endCallBack()
    end
    return
  end
  local des = string.format(self.data.textFormat, remainTime)
  self.tip:SetText(des)
end

function Activity_Sport3V3Begin:OnHide()
  self:StopTimer()
end

function Activity_Sport3V3Begin:OnDestroy()
  self:StopTimer()
end
