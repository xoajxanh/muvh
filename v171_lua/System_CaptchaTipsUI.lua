System_CaptchaTipsUI = class(BaseUI)
System_CaptchaTipsUI.layer = UILayer.Panel
System_CaptchaTipsUI.orderInLayer = 0
System_CaptchaTipsUI.hideType = UIHideType.WaitDestroy
System_CaptchaTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
System_CaptchaTipsUI.escClose = UIEscClose.DontClose

function System_CaptchaTipsUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.lab_TipContent = self:GetControl("Panel_Tip/Image_TipBg/lab_TipContent")
  self.Button_OK = self:GetControl("Panel_Tip/Button_OK")
  self.btn_needGold = self:GetControl("Panel_Tip/Button_OK/btn_needGold")
  self.lab_num = self:GetControl("Panel_Tip/Button_OK/btn_needGold/lab_num")
  self.Text_OK = self:GetControl("Panel_Tip/Button_OK/Text_OK")
  self.Btn_Description = self:GetControl("Panel_Tip/Button_OK/Btn_Description")
  self.Button_Cancel = self:GetControl("Panel_Tip/Button_Cancel")
  self.Text_Cancel = self:GetControl("Panel_Tip/Button_Cancel/Text_Cancel")
  self.input_CaptchaCodeFrame = self:GetControl("Panel_Tip/input_CaptchaCodeFrame")
  self.lab_CaptchaNum = self:GetControl("Panel_Tip/input_CaptchaCodeFrame/lab_CaptchaNum")
  self.Button_Captcha = self:GetControl("Panel_Tip/Button_Captcha")
  self.Text_Captcha = self:GetControl("Panel_Tip/Button_Captcha/Text_Captcha")
end

function System_CaptchaTipsUI:Init()
end

function System_CaptchaTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function System_CaptchaTipsUI:InitUI()
end

function System_CaptchaTipsUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.btn_needGold:SetOnClick(self, self.btn_needGoldOnClick)
  self.Button_Cancel:SetOnClick(self, self.Button_CancelOnClick)
  self.Button_Captcha:SetOnClick(self, self.Button_CaptchaOnClick)
end

function System_CaptchaTipsUI:Bg_CloseOnClick(control)
end

function System_CaptchaTipsUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.System_CaptchaTipsUI)
end

function System_CaptchaTipsUI:Button_OKOnClick(control)
  if self.number == self.lab_CaptchaNum:GetText() then
    local uiWord = ClientTable.cfg_Ui_promptwordManager:TryGetValue(13)
    UIManager.Show(UIID.PromptTipUI, {
      title = uiWord.title,
      textContent = uiWord.content,
      ok = function(okArgs)
        LoginController.AccountCancellation()
        LoginData.LogoutAccount()
        NetManager.Send(UserMessage.ReqLogout, {
          reason = ELogoutType.LogOut
        })
        gameMgr:GetAvatarManager():RemoveAllAvatar()
      end
    })
  else
    FloatingTipUtility.QuickMsg("H\195\163y nh\225\186\173p m\195\163 x\195\161c nh\225\186\173n ch\195\173nh x\195\161c")
  end
  self.input_CaptchaCodeFrame:SetInputText("")
end

function System_CaptchaTipsUI:btn_needGoldOnClick(control)
end

function System_CaptchaTipsUI:Button_CancelOnClick(control)
  UIManager.Hide(UIID.System_CaptchaTipsUI)
end

function System_CaptchaTipsUI:Button_CaptchaOnClick(control)
  self:RefreshText_Captcha()
end

function System_CaptchaTipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function System_CaptchaTipsUI:RegistEvents()
end

function System_CaptchaTipsUI:Refresh()
  self:RefreshText_Captcha()
end

local codeLength = 4
local codeChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

function System_CaptchaTipsUI:RefreshText_Captcha()
  local code = ""
  for i = 1, codeLength do
    local index = math.random(1, #codeChars)
    local char = string.sub(codeChars, index, index)
    code = code .. char
  end
  self.number = code
  self.Text_Captcha:SetText(self.number)
end

function System_CaptchaTipsUI:OnHide()
end

function System_CaptchaTipsUI:OnDestroy()
end
