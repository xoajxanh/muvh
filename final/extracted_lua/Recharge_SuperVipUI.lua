Recharge_SuperVipUI = class(BaseUI)
Recharge_SuperVipUI.layer = UILayer.Panel
Recharge_SuperVipUI.orderInLayer = 0
Recharge_SuperVipUI.hideType = UIHideType.WaitDestroy
Recharge_SuperVipUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_SuperVipUI.escClose = UIEscClose.DontClose

function Recharge_SuperVipUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_Vip/btn_close")
  self.go_Vip = self:GetControl("bg_Vip/go_Vip")
  self.btn_weixin = self:GetControl("bg_Vip/go_Vip/VipImage/Image")
end

function Recharge_SuperVipUI:Init()
end

function Recharge_SuperVipUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Recharge_SuperVipUI:InitUI()
end

function Recharge_SuperVipUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_weixin:SetOnClick(self, self.btn_weixinOnClick)
end

function Recharge_SuperVipUI:btn_closeBgOnClick(control)
end

function Recharge_SuperVipUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Recharge_SuperVipUI)
end

function Recharge_SuperVipUI:btn_weixinOnClick(control)
  local url = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(5000113)
  if url then
    Application.OpenURL(url)
  end
end

function Recharge_SuperVipUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Recharge_SuperVipUI:RegistEvents()
end

function Recharge_SuperVipUI:Refresh()
end

function Recharge_SuperVipUI:OnHide()
end

function Recharge_SuperVipUI:OnDestroy()
end
