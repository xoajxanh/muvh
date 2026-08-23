Role_ChangeNameUI = class(BaseUI)
Role_ChangeNameUI.layer = UILayer.Tip
Role_ChangeNameUI.orderInLayer = 5
Role_ChangeNameUI.hideType = UIHideType.WaitDestroy
Role_ChangeNameUI.hideFunc = UIHideFunc.MoveOutOfScreen
Role_ChangeNameUI.escClose = UIEscClose.DontClose

function Role_ChangeNameUI:InitControls()
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.Button_1 = self:GetControl("Panel_Tip/Image_TipBg/Button_1")
  self.Text_1 = self:GetControl("Panel_Tip/Image_TipBg/Button_1/Text_1")
  self.Button_2 = self:GetControl("Panel_Tip/Image_TipBg/Button_2")
  self.Text_2 = self:GetControl("Panel_Tip/Image_TipBg/Button_2/Text_2")
  self.Text_TipContent = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent")
  self.InputField = self:GetControl("Panel_Tip/Image_TipBg/Text_TipContent/InputField")
  self.Text_TipTitle = self:GetControl("Panel_Tip/Image_TipBg/Text_TipTitle")
end

function Role_ChangeNameUI:OnPreLoad()
end

function Role_ChangeNameUI:Init()
  self.Rolename = RoleManager.me.data.name
end

function Role_ChangeNameUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Role_ChangeNameUI:InitUI()
  self.quxiao = LocalizationUtility.GetContentByKey("quxiao")
  self.queding = LocalizationUtility.GetContentByKey("queding")
  self.Text_1:SetText(self.quxiao)
  self.Text_2:SetText(self.queding)
end

function Role_ChangeNameUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Role_ChangeNameUI:OnHide()
  self.InputField:SetInputText("")
end

function Role_ChangeNameUI:OnDestroy()
end

function Role_ChangeNameUI:RegistUIEvents()
  self.Button_1:SetOnClick(self, self.Button_1OnClick)
  self.Button_2:SetOnClick(self, self.Button_2OnClick)
  self.InputField:SetOnValueChanged(self, self.InputFieldValueChanged)
  self.InputField:SetOnEndEdit(self, self.InputFieldEndEdit)
end

function Role_ChangeNameUI:InputFieldValueChanged(control)
  self.limit = self.InputField.transform:GetComponent("InputField")
  if self.limit.characterLimit ~= 9 then
    self.limit.characterLimit = 9
  end
end

function Role_ChangeNameUI:InputFieldEndEdit(control)
  local inputText = self.InputField:GetInputText()
  local length = string.GetKoreanStrCount(inputText)
  if 7 < length then
    self.limit.text = string.KoreanStrSub(inputText, 1, 6)
  end
  self.limit = 7
end

function Role_ChangeNameUI:Button_1OnClick(control)
  UIManager.Hide(UIID.RoleChangeNameUI)
end

function Role_ChangeNameUI:Button_2OnClick(control)
  local rolename = self.InputField:GetInputText()
  if not string.isNullOrEmpty(rolename) then
    if rolename ~= RoleManager.me.data.name then
      NetManager.Send(RoleMessage.ReqChangeRoleName, {
        roleId = RoleManager.me.id,
        itemId = self.args.itemId,
        changeName = rolename
      })
    else
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = "T\195\170n nh\195\162n v\225\186\173t \196\145\195\163 d\195\185ng"
      })
    end
  else
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "C\225\186\167n nh\225\186\173p \195\173t nh\225\186\165t 2 k\195\189 t\225\187\177"
    })
  end
end

function Role_ChangeNameUI:RegistEvents()
  self:RegistEvent(Event.Role_RefreshName, self.OnRefreshName, self)
end

function Role_ChangeNameUI:OnRefreshName(id, msg)
  UIManager.Hide(UIID.RoleChangeNameUI)
end

function Role_ChangeNameUI:Refresh()
end
