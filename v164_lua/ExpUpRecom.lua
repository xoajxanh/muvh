ExpUpRecom = class(BaseUI)
ExpUpRecom.layer = UILayer.Panel
ExpUpRecom.orderInLayer = 0
ExpUpRecom.hideType = UIHideType.WaitDestroy
ExpUpRecom.hideFunc = UIHideFunc.MoveOutOfScreen
ExpUpRecom.escClose = UIEscClose.DontClose

function ExpUpRecom:InitControls()
  self.t1 = self:GetControl("t1")
  self.RecomImage_bg = self:GetControl("t1/RecomImage_bg")
  self.RecomImage = self:GetControl("t1/RecomImage")
  self.Countdown = self:GetControl("t1/Countdown")
end

function ExpUpRecom:OnPreLoad()
end

function ExpUpRecom:Init()
end

function ExpUpRecom:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function ExpUpRecom:InitUI()
end

function ExpUpRecom:OnShow()
  self:RegistEvents()
  self:RefreshHideData()
end

function ExpUpRecom:OnHide()
  self:HelperDestroyTimer()
  self.timeStr = nil
end

function ExpUpRecom:OnDestroy()
end

function ExpUpRecom:RegistUIEvents()
  self.RecomImage_bg:SetOnClick(self, self.RecomImage_bgOnClick)
end

function ExpUpRecom:RecomImage_bgOnClick(control)
  UIManager.Show(UIID.Shop_ExpUpUI)
  UIManager.Hide(UIID.ExpUpRecom)
end

function ExpUpRecom:RegistEvents()
end

function ExpUpRecom:RefreshHideData()
  local time = tonumber(ClientTable.cfg_Global_globalManager:TryGetValue(2520002, "id").effect)
  local min = math.floor(time / 60000)
  local sec = math.floor(time % 60)
  self.Countdown:SetText(string.format("%02d:%02d", min, sec))
  self:HelperDestroyTimer()
  self:HelperCreatTimer(time)
end

function ExpUpRecom:HelperCreatTimer(time)
  self.timeStr = time
  
  local function UpdataTimerBtn()
    self.timeStr = self.timeStr - 1
    local min = math.floor(self.timeStr / 60000)
    local sec = math.floor(self.timeStr % 60)
    if 0 < sec then
      self.Countdown:SetText(string.format("%02d:%02d", min, sec))
    elseif sec == 0 then
      self.Countdown:SetText(string.format("%02d:%02d", min, sec))
      UIManager.Hide(UIID.ExpUpRecom)
    end
  end
  
  self.recTimer = Timer.StartLoop(1, self.timeStr, UpdataTimerBtn)
end

function ExpUpRecom:HelperDestroyTimer()
  if self.recTimer then
    Timer.Stop(self.recTimer)
  end
  self.recTimer = nil
end
