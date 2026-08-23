Tip_RunesMaster = class(BaseUI)
Tip_RunesMaster.layer = UILayer.Panel
Tip_RunesMaster.orderInLayer = 5
Tip_RunesMaster.hideType = UIHideType.WaitDestroy
Tip_RunesMaster.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_RunesMaster.escClose = UIEscClose.DontClose

function Tip_RunesMaster:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.Tip_ModelShow = self:GetControl("Img_TipBg/sv_center/Viewport/Content/Tip_ModelShow")
end

function Tip_RunesMaster:Init()
end

function Tip_RunesMaster:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_RunesMaster:InitUI()
  self.newRuneCombinationAttributeTemplate = UIUtility.BindUIContainerTemp(self.Tip_ModelShow, LuaComponentTemplates.NewRuneCombinationAttributeTemplate, self, {root = self})
end

function Tip_RunesMaster:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
end

function Tip_RunesMaster:btn_CloseOnClick(control)
  UIManager.Hide(UIID.Tip_RunesMaster)
end

function Tip_RunesMaster:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_RunesMaster:RegistEvents()
end

function Tip_RunesMaster:Refresh()
  local tipRunesMasterData = QuickFind.GetNewRuneDataManager():GetTipRunesMasterData()
  self.newRuneCombinationAttributeTemplate:SetData(tipRunesMasterData)
end

function Tip_RunesMaster:OnHide()
end
