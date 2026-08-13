Activity_Sport3V3Dead = class(BaseUI)
Activity_Sport3V3Dead.layer = UILayer.Tip
Activity_Sport3V3Dead.orderInLayer = 0
Activity_Sport3V3Dead.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Dead.hideFunc = UIHideFunc.Deactive
Activity_Sport3V3Dead.escClose = UIEscClose.DontClose

function Activity_Sport3V3Dead:InitControls()
  self.bg = self:GetControl("bg_bg/bg")
  self.tip = self:GetControl("bg_bg/tip")
  self.des = self:GetControl("bg_bg/bg/tip")
end

Activity_Sport3V3Dead.data = nil

function Activity_Sport3V3Dead:Init()
end

function Activity_Sport3V3Dead:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_Sport3V3Dead:InitUI()
end

function Activity_Sport3V3Dead:RegistUIEvents()
end

function Activity_Sport3V3Dead:OnShow()
  if self:AnalysisParams() == false then
    self:Hide()
    return
  end
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Dead:AnalysisParams()
  if self.args == nil then
    return false
  end
  self.data = self.args
  local remainTime = TimeUtility.GetRemainSecTime(self.data.endTime)
  if remainTime < 0 then
    return false
  end
  return true
end

function Activity_Sport3V3Dead:RegistEvents()
end

function Activity_Sport3V3Dead:Refresh()
  self:RefreshBg()
  self:RefreshDes()
  self:RefreshCountDown()
end

function Activity_Sport3V3Dead:RefreshBg()
  self:SetSprite("Atlas_Common", self.data.bgName, self.bg)
end

function Activity_Sport3V3Dead:RefreshDes()
  self.des:SetText(self.data.des)
end

function Activity_Sport3V3Dead:RefreshCountDown()
  self:StopTimer()
  self:StartTimer()
  self.countDownTimer = Timer.StartLoopForever(0.2, self.StartTimer, self)
end

function Activity_Sport3V3Dead:StopTimer()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function Activity_Sport3V3Dead:StartTimer()
  local remainTime = TimeUtility.GetRemainSecTime(self.data.endTime)
  if remainTime < 0 then
    remainTime = 0
    self:Hide()
    if self.data.endCallBack ~= nil then
      self.data.endCallBack()
    end
    if self.data.roleReliveType ~= nil then
      networkRequest.ReqRelive(self.data.roleReliveType)
    end
    return
  end
  self.tip:SetText(remainTime)
end

function Activity_Sport3V3Dead:OnHide()
  self:StopTimer()
end

function Activity_Sport3V3Dead:OnDestroy()
  self:StopTimer()
end
