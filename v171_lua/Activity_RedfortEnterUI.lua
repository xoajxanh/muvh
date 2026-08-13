Activity_RedfortEnterUI = class(BaseUI)
Activity_RedfortEnterUI.layer = UILayer.Tip
Activity_RedfortEnterUI.orderInLayer = 0
Activity_RedfortEnterUI.hideType = UIHideType.WaitDestroy
Activity_RedfortEnterUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_RedfortEnterUI.escClose = UIEscClose.DontClose

function Activity_RedfortEnterUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.numberPeople = self:GetControl("Middel/numberPeople")
  self.count_time = self:GetControl("Middel/lab_leftcount/count_time")
  self.btn_enter = self:GetControl("Middel/btn_enter")
  self.btn_no = self:GetControl("Middel/btn_no")
end

function Activity_RedfortEnterUI:OnPreLoad()
end

function Activity_RedfortEnterUI:Init()
end

function Activity_RedfortEnterUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_RedfortEnterUI:InitUI()
end

function Activity_RedfortEnterUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_RedfortEnterUI:OnHide()
  if self.countDownPrepareTimer then
    Timer.Stop(self.countDownPrepareTimer)
    self.countDownPrepareTimer = nil
  end
end

function Activity_RedfortEnterUI:OnDestroy()
end

function Activity_RedfortEnterUI:RegistUIEvents()
  self.btn_no:SetOnClick(self, self.btn_closeOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
end

function Activity_RedfortEnterUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_RedfortEnterUI)
end

function Activity_RedfortEnterUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_RedfortEnterUI)
end

function Activity_RedfortEnterUI:btn_enterOnClick(control)
  EventManager.Dispatch(Event.RedFortApply)
  UIManager.Hide(UIID.Activity_RedfortEnterUI)
end

function Activity_RedfortEnterUI:RegistEvents()
end

function Activity_RedfortEnterUI:Refresh()
  self:ShowPrepareCountDown()
end

function Activity_RedfortEnterUI:ShowPrepareCountDown()
  local timeCounter = RedFortData.prepareCountDown - Time.GetServerSecondTime()
  if timeCounter <= 0 then
    return
  end
  
  local function StartTimer()
    local minutes = Mathf.Floor(timeCounter / 60)
    local seconds = Mathf.Floor(timeCounter % 60)
    self.count_time:SetText(string.format("%02d : %02d", minutes, seconds))
    if timeCounter <= 0 then
      if self.countDownPrepareTimer then
        Timer.Stop(self.countDownPrepareTimer)
        self.countDownPrepareTimer = nil
      end
      UIManager.Hide(UIID.Activity_RedfortEnterUI)
    end
    timeCounter = timeCounter - 1
  end
  
  StartTimer()
  self.countDownPrepareTimer = Timer.StartLoopForever(1, StartTimer)
end
