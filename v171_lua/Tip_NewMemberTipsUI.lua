Tip_NewMemberTipsUI = class(BaseUI)
Tip_NewMemberTipsUI.layer = UILayer.Tip
Tip_NewMemberTipsUI.orderInLayer = 0
Tip_NewMemberTipsUI.hideType = UIHideType.WaitDestroy
Tip_NewMemberTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_NewMemberTipsUI.escClose = UIEscClose.DontClose

function Tip_NewMemberTipsUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.RedIntensify = self:GetControl("RedIntensify")
  self.title = self:GetControl("RedIntensify/RedIntensifyScroll_Master/txt_title/title")
  self.tip = self:GetControl("RedIntensify/RedIntensifyScroll_Master/txt_title/tip")
  self.btn_closeBg:SetActive(true)
  self.RedIntensifyScroll_Master = self:GetControl("RedIntensify/RedIntensifyScroll_Master")
  self.btn_IntensifyMasterClose = self:GetControl("RedIntensify/RedIntensifyScroll_Master/btn_IntensifyMasterClose")
end

function Tip_NewMemberTipsUI:Init()
end

function Tip_NewMemberTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Tip_NewMemberTipsUI:InitUI()
end

function Tip_NewMemberTipsUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_IntensifyMasterClose:SetOnClick(self, self.btn_IntensifyMasterCloseOnClick)
end

function Tip_NewMemberTipsUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Tip_NewMemberTipsUI)
end

function Tip_NewMemberTipsUI:btn_IntensifyMasterCloseOnClick(control)
end

function Tip_NewMemberTipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Tip_NewMemberTipsUI:RegistEvents()
end

function Tip_NewMemberTipsUI:Refresh()
  if self.args.memberNowTable ~= nil then
    self.title:SetText(self.args.memberNowTable.name)
  end
  self.tip:SetText(self:GetMemberDataMgr():GetCurGroupDetailedTipsDes(self.args.starnum))
end

function Tip_NewMemberTipsUI:OnHide()
end

function Tip_NewMemberTipsUI:OnDestroy()
end

function Tip_NewMemberTipsUI:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end
