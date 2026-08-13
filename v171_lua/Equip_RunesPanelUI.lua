Equip_RunesPanelUI = class(BaseUI)
Equip_RunesPanelUI.layer = UILayer.Panel
Equip_RunesPanelUI.orderInLayer = 0
Equip_RunesPanelUI.hideType = UIHideType.WaitDestroy
Equip_RunesPanelUI.hideFunc = UIHideFunc.MoveOutOfScreen
Equip_RunesPanelUI.escClose = UIEscClose.DontClose

function Equip_RunesPanelUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_closeAllAttrPanel = self:GetControl("btn_closeAllAttrPanel")
  self.lab_attr_hole = self:GetControl("Bg/RunesIntensify/ViewPort/Content/View_Attr/ViewPort/Content/lab_attr")
  self.lab_attr_rune = self:GetControl("Bg/RunesIntensify/ViewPort/Content/View_Runes/ViewPort/Content/lab_attr")
  self.lab_attr_combination = self:GetControl("Bg/RunesIntensify/ViewPort/Content/View_RunesMaster/ViewPort/Content/lab_attr")
end

function Equip_RunesPanelUI:Init()
end

function Equip_RunesPanelUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function AttrCreate(ctr)
  ctr.lab_attrValue = UIControl(ctr.transform, "lab_attrValue")
end

local function AttrRefresh(ctr, k, data, ui)
  ctr:SetText(data.attributeName)
  ctr.lab_attrValue:SetText(data.valueDes)
end

function Equip_RunesPanelUI:InitUI()
  self.holeAttrContainer = UIContainer(self.lab_attr_hole, self, AttrCreate, AttrRefresh)
  self.runeAttrContainer = UIContainer(self.lab_attr_rune, self, AttrCreate, AttrRefresh)
  self.combinationAttrContainer = UIContainer(self.lab_attr_combination, self, AttrCreate, AttrRefresh)
end

function Equip_RunesPanelUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_closeAllAttrPanel:SetOnClick(self, self.btn_closeAllAttrPanelOnClick)
end

function Equip_RunesPanelUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Equip_RunesPanelUI)
end

function Equip_RunesPanelUI:btn_closeAllAttrPanelOnClick(control)
  UIManager.Hide(UIID.Equip_RunesPanelUI)
end

function Equip_RunesPanelUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Equip_RunesPanelUI:RegistEvents()
end

function Equip_RunesPanelUI:Refresh()
  self.holeAttrContainer:SetData(QuickFind.GetNewRuneDataManager():GetHoleAllAttributeList())
  self.runeAttrContainer:SetData(QuickFind.GetNewRuneDataManager():GetRuneAllAttributeList())
  self.combinationAttrContainer:SetData(QuickFind.GetNewRuneDataManager():GetCombinationAllAttributeList())
end

function Equip_RunesPanelUI:OnHide()
end
