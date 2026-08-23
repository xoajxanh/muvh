Login_UserPrivacyUI = class(BaseUI)
Login_UserPrivacyUI.layer = UILayer.Panel
Login_UserPrivacyUI.orderInLayer = 10
Login_UserPrivacyUI.hideType = UIHideType.Destroy
Login_UserPrivacyUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_UserPrivacyUI.escClose = UIEscClose.DontClose

function Login_UserPrivacyUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.go_UserPrivacy = self:GetControl("go_UserPrivacy")
  self.sv_PolicyContent = self:GetControl("go_UserPrivacy/sv_PolicyContent")
  self.btn_closePolicy = self:GetControl("go_UserPrivacy/btn_closePolicy")
  self.lab_PolicyContent00 = self:GetControl("go_UserPrivacy/sv_PolicyContent/Viewport/Content/lab_PolicyContent00")
  self.lab_PolicyContent11 = self:GetControl("go_UserPrivacy/sv_PolicyContent/Viewport/Content/lab_PolicyContent11")
  self.btn_PolicyContent = self:GetControl("go_UserPrivacy/sv_PolicyContent/Viewport/Content/lab_PolicyContent2/btn_PolicyContent")
  self.text_PolicyContent = self:GetControl("go_UserPrivacy/sv_PolicyContent/Viewport/Content/lab_PolicyContent/btn_PolicyContent/text_PolicyContent")
  self.lab_PolicyContent1 = self:GetControl("go_UserPrivacy/sv_PolicyContent/Viewport/Content/lab_PolicyContent1")
end

function Login_UserPrivacyUI:Init()
end

function Login_UserPrivacyUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_UserPrivacyUI:InitUI()
end

function Login_UserPrivacyUI:RegistUIEvents()
  self.btn_closePolicy:SetOnClick(self, self.btn_closePolicyOnClick)
  self.btn_PolicyContent:SetOnClick(self, self.btn_PolicyContentOnClieck)
  self.lab_PolicyContent1:SetOnTextPointerClick(self, self.ExecuteTextOrder)
  self.lab_PolicyContent11:SetOnTextPointerClick(self, self.ExecuteTextOrder)
end

function Login_UserPrivacyUI:btn_closePolicyOnClick(control)
  UIManager.Hide(UIID.Login_UserPrivacyUI)
end

function Login_UserPrivacyUI:btn_PolicyContentOnClieck(control)
  local uiWord = ClientTable.cfg_Ui_promptwordManager:TryGetValue(12)
  UIManager.Show(UIID.PromptTipUI, {
    title = uiWord.title,
    textContent = uiWord.content,
    ok = function(okArgs)
      NetManager.Send(UserMessage.ReqLogout, {
        reason = ELogoutType.LogOut
      })
      gameMgr:GetAvatarManager():RemoveAllAvatar()
    end
  })
end

function Login_UserPrivacyUI:ExecuteTextOrder(control, eventData, key)
  if key == "[link:1]" then
    UIManager.Show(UIID.Login_UserInformationUI)
    return
  end
  if key == "[link:2]" then
    UIManager.Show(UIID.Login_UserPrivacyUI)
    return
  end
  if key == "[link:3]" then
    UIManager.Show(UIID.Login_ChildProtectionUI)
    return
  end
  if key == "[link:4]" then
    UIManager.Show(UIID.Login_ThirdInformationUI)
    return
  end
end

function Login_UserPrivacyUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Login_UserPrivacyUI:RegistEvents()
end

function Login_UserPrivacyUI:Refresh()
  if not self.args or not self.args.canCancelProtocol then
    self.btn_PolicyContent:SetActive(false)
  else
    self.btn_PolicyContent:SetActive(true)
  end
  if self.sv_PolicyContent.scrollRect ~= nil then
    self.sv_PolicyContent.scrollRect.content.anchoredPosition = Vector3.New(0, 0, 0)
  end
end

function Login_UserPrivacyUI:OnHide()
  self.args = nil
end

function Login_UserPrivacyUI:OnDestroy()
end
