Seachest_DescUI = class(BaseUI)
Seachest_DescUI.layer = UILayer.Tip
Seachest_DescUI.orderInLayer = 0
Seachest_DescUI.hideType = UIHideType.WaitDestroy
Seachest_DescUI.hideFunc = UIHideFunc.MoveOutOfScreen
Seachest_DescUI.escClose = UIEscClose.DontClose

function Seachest_DescUI:InitControls()
  self.Panel_Desc = self:GetControl("Panel_Desc")
  self.CloseBtn = self:GetControl("Img_DescBg/CloseBtn")
  self.lab_DescTitle = self:GetControl("Img_DescBg/lab_DescTitle")
  self.lab_DescContent = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/lab_DescContent")
  self.title = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/pro_level/title")
  self.lab_text = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/pro_level/title/lab_text")
  self.detail = self:GetControl("Img_DescBg/ScrollView/Viewport/Content/pro_level/Content/detail")
end

function Seachest_DescUI:Init()
end

function Seachest_DescUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnDetailItemCreate(ctr)
  ctr.lab_nameOfFree = UIControl(ctr.transform, "Free/lab_name")
  ctr.lab_proOfFree = UIControl(ctr.transform, "Free/lab_pro")
  ctr.lab_nameOfDiamond = UIControl(ctr.transform, "Diamond/lab_name")
  ctr.lab_proOfDiamond = UIControl(ctr.transform, "Diamond/lab_pro")
end

local function OnDetailItemRefresh(ctr, _, data, ui)
  local itemData = data.data
  ctr.lab_nameOfFree:SetText(itemData.freeName)
  local weight = itemData.weight0 / 100
  ctr.lab_proOfFree:SetText(tostring(weight) .. "%")
  ctr.lab_nameOfDiamond:SetText(itemData.diamondName)
  weight = itemData.weight1 / 100
  ctr.lab_proOfDiamond:SetText(tostring(weight) .. "%")
end

function Seachest_DescUI:InitUI()
  self.detailContainer = UIContainer(self.detail, self, OnDetailItemCreate, OnDetailItemRefresh)
end

function Seachest_DescUI:RegistUIEvents()
  self.Panel_Desc:SetOnClick(self, self.Panel_DescOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
end

function Seachest_DescUI:Panel_DescOnClick(control)
end

function Seachest_DescUI:CloseBtnOnClick(control)
  UIManager.Hide(UIID.Seachest_DescUI)
end

function Seachest_DescUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Seachest_DescUI:RegistEvents()
end

function Seachest_DescUI:Refresh()
  if self.args then
    local lvCfg = ClientTable.cfg_Ui_descriptionManager:TryGetValue(self.args.id)
    self.lab_DescTitle:SetText(lvCfg.title)
    self.lab_DescContent:SetText(lvCfg.desc)
    self.detailContainer:SetData(self.args.data.rewardpond)
  end
end

function Seachest_DescUI:OnHide()
end

function Seachest_DescUI:OnDestroy()
end
