System_DescUI = class(BaseUI)
System_DescUI.layer = UILayer.Tip
System_DescUI.orderInLayer = 2
System_DescUI.hideType = UIHideType.WaitDestroy
System_DescUI.hideFunc = UIHideFunc.MoveOutOfScreen
System_DescUI.escClose = UIEscClose.DontClose

function System_DescUI:InitControls()
  self.Panel_Desc = self:GetControl("Panel_Desc")
  self.CloseBtn = self:GetControl("Img_DescBg/CloseBtn")
  self.lab_DescTitle = self:GetControl("Img_DescBg/lab_DescTitle")
  self.lab_DescContent = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/lab_DescContent")
end

function System_DescUI:Init()
end

function System_DescUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function System_DescUI:InitUI()
  local transform = self.root.transform
  local x, y = transform:GetAnchoredPosition()
  transform.anchoredPosition3D = Vector3.New(x, y, -1000)
end

function System_DescUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function System_DescUI:OnHide()
end

function System_DescUI:OnDestroy()
end

function System_DescUI:RegistUIEvents()
  self.Panel_Desc:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
end

function System_DescUI:CloseBtnOnClick()
  UIManager.Hide(UIID.System_DescUI)
end

function System_DescUI:RegistEvents()
end

function System_DescUI:Refresh()
  self.DescId = self.args.id
  self:SetDescText()
end

function System_DescUI:SetDescText()
  local DescData = ClientTable.cfg_Ui_descriptionManager:TryGetValue(self.DescId, "id")
  DescData.desc = string.replace(DescData.desc, "\\n", "\n")
  self.lab_DescTitle:SetText(DescData.title)
  self.lab_DescContent:SetText(DescData.desc)
end
