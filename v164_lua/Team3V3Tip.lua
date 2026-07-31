Team3V3Tip = class(BaseUI)
Team3V3Tip.layer = UILayer.Prompt
Team3V3Tip.orderInLayer = 5
Team3V3Tip.hideType = UIHideType.Hide
Team3V3Tip.hideFunc = UIHideFunc.MoveOutOfScreen
Team3V3Tip.escClose = UIEscClose.DontClose

function Team3V3Tip:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.Text_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK")
  self.Btn_Description = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/Btn_Description")
  self.Text_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/Text_OK")
  self.Button_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel")
  self.Text_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel/Text_Cancel")
  self.Text_CountDown = self:GetControl("Panel_Tip/Image_TipBg/Text_CountDown")
end

function Team3V3Tip:Init()
end

function Team3V3Tip:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Team3V3Tip:InitUI()
end

function Team3V3Tip:RegistUIEvents()
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.Button_Cancel:SetOnClick(self, self.Button_CancelOnClick)
end

function Team3V3Tip:Button_OKOnClick(control)
  if self.args and self.args.confirmCallback then
    self.args.confirmCallback()
  end
  UIManager.Hide(UIID.Team3V3Tip)
  if self.args and self.args.delay then
    UIManager.Show(UIID.Team3V3UI)
  end
end

function Team3V3Tip:Button_CancelOnClick(control)
  if self.args and self.args.cancelCallback then
    self.args.cancelCallback()
  end
  UIManager.Hide(UIID.Team3V3Tip)
  if self.args and self.args.delay then
    UIManager.Show(UIID.Team3V3UI)
  end
end

function Team3V3Tip:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Team3V3Tip:RegistEvents()
end

function Team3V3Tip:Refresh()
  if not self.args or not self.args.uiWordId then
    return
  end
  self.Text_CountDown:SetActive(false)
  self.Text_TipTitle:SetText(self.args.title or "")
  self.Text_TipContent:SetText(self.args.content or "")
  self.Text_OK:SetText(self.args.btn1Text or "\231\161\174\232\174\164")
  local btnCount = self.args.btnCount or 1
  if 2 <= btnCount then
    self.Button_Cancel:SetActive(true)
    self.Text_Cancel:SetText(self.args.btn2Text or "\229\143\150\230\182\136")
  else
    self.Button_Cancel:SetActive(false)
  end
  if self.args.type == 3 then
    self.Text_CountDown:SetActive(true)
    local countdown = 5
    local content = "(%ss sau t\225\187\177 \196\145\225\187\153ng v\195\160o)"
    self.Text_CountDown:SetText(string.format(content, countdown))
    self.timer = Timer.StartLoop(1, countdown, function()
      countdown = countdown - 1
      if 0 < countdown then
        self.Text_CountDown:SetText(string.format(content, countdown))
      else
        self.Text_CountDown:SetActive(false)
        self:Button_OKOnClick()
      end
    end)
  end
end

function Team3V3Tip:OnHide()
  if self.timer then
    Timer.Stop(self.timer)
    self.timer = nil
  end
end

function Team3V3Tip:OnDestroy()
end
