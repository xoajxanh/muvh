Activity_SiegeforRuleUI = class(BaseUI)
Activity_SiegeforRuleUI.layer = UILayer.MessageBox
Activity_SiegeforRuleUI.orderInLayer = 11
Activity_SiegeforRuleUI.hideType = UIHideType.WaitDestroy
Activity_SiegeforRuleUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeforRuleUI.escClose = UIEscClose.DontClose

function Activity_SiegeforRuleUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.title = self:GetControl("img_Bg/title")
end

function Activity_SiegeforRuleUI:OnPreLoad()
end

function Activity_SiegeforRuleUI:Init()
end

function Activity_SiegeforRuleUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeforRuleUI:InitUI()
end

function Activity_SiegeforRuleUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeforRuleUI:OnHide()
end

function Activity_SiegeforRuleUI:OnDestroy()
end

function Activity_SiegeforRuleUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
end

function Activity_SiegeforRuleUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_SiegeforRuleUI)
end

function Activity_SiegeforRuleUI:RegistEvents()
end

function Activity_SiegeforRuleUI:Refresh()
end
