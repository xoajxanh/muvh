Recharge_InvestmentUI = class(BaseUI)
Recharge_InvestmentUI.layer = UILayer.Panel
Recharge_InvestmentUI.orderInLayer = 3
Recharge_InvestmentUI.hideType = UIHideType.WaitDestroy
Recharge_InvestmentUI.hideFunc = UIHideFunc.MoveOutOfScreen
Recharge_InvestmentUI.escClose = UIEscClose.DontClose

function Recharge_InvestmentUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_shop/btn_close")
  self.go_InvestGroup = self:GetControl("bg_shop/go_InvestGroup")
  self.Panel_invest_left = self:GetControl("bg_shop/go_InvestGroup/Panel_invest_left")
  self.Panel_invest_right = self:GetControl("bg_shop/go_InvestGroup/Panel_invest_right")
  self.lab_time = self:GetControl("bg_shop/go_InvestGroup/lab_time")
  self.Invest_left = self:GetControl("bg_shop/go_InvestGroup/left/Invest_left")
  self.img_Invest_left = self:GetControl("bg_shop/go_InvestGroup/left/Invest_left/img_Invest_left")
  self.btn_go = self:GetControl("bg_shop/go_InvestGroup/left/Invest_left/btn_go")
  self.lab_unTime = self:GetControl("bg_shop/go_InvestGroup/left/Invest_left/lab_unTime")
  self.grid_Invest = self:GetControl("bg_shop/go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest")
  self.go_Invest = self:GetControl("bg_shop/go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest")
  self.lab_Invest = self:GetControl("bg_shop/go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest/lab_Invest")
  self.lab_unfinish = self:GetControl("bg_shop/go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest/lab_unfinish")
  self.lab_finish = self:GetControl("bg_shop/go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest/lab_finish")
  self.right = self:GetControl("bg_shop/go_InvestGroup/right")
  self.Invest_right = self:GetControl("bg_shop/go_InvestGroup/right/Invest_right")
  self.descBtn = self:GetControl("bg_shop/descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_down = self:GetControl("plane_down")
end

function Recharge_InvestmentUI:Init()
end

function Recharge_InvestmentUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:InitContainer()
end

function Recharge_InvestmentUI:InitUI()
end

function Recharge_InvestmentUI:InitContainer()
  self.panelInvestContainer = {}
  self.panelInvestContainer[KFTZGradeType.Ordinary] = luaTemplateManager.GetNewTemplate(self.Panel_invest_left, LuaComponentTemplates.OpenServerInvestGradeTemplate, self)
  self.panelInvestContainer[KFTZGradeType.Advanced] = luaTemplateManager.GetNewTemplate(self.Panel_invest_right, LuaComponentTemplates.OpenServerInvestGradeTemplate, self)
end

function Recharge_InvestmentUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Recharge_InvestmentUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Recharge_InvestmentUI)
end

function Recharge_InvestmentUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Recharge_InvestmentUI")
  if type(lvCfg) ~= "table" or table.count(lvCfg) < 1 then
    return
  end
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Recharge_InvestmentUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Recharge_InvestmentUI:RegistEvents()
  self:RegistEvent(Event.OpenServerInvestmentRefresh, self.RefreshInvestment, self)
end

function Recharge_InvestmentUI:Refresh()
  self:RefreshTime()
  self:RefreshInvestment()
end

function Recharge_InvestmentUI:RefreshInvestment()
  for i, template in pairs(self.panelInvestContainer) do
    if template.Refresh ~= nil then
      template:Refresh(QuickFind:GetOpenServerInvestmentData():GetInvestmentInfoDicByRechargeId(i))
    end
  end
end

function Recharge_InvestmentUI:RefreshTime()
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  self.lab_time:SetText(QuickFind:GetOpenServerInvestmentData():GetRemainTimeDes())
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.lab_time:SetText(QuickFind:GetOpenServerInvestmentData():GetRemainTimeDes())
    QuickFind:GetOpenServerInvestmentData():TryUpdateCurDay()
  end)
end

function Recharge_InvestmentUI:OnHide()
  for i, template in pairs(self.panelInvestContainer) do
    if template.Exit ~= nil then
      template:Exit()
    end
  end
  self:DestroyTime()
end

function Recharge_InvestmentUI:DestroyTime()
  Timer.Stop(self.RemainTimeLoop)
  self.RemainTimeLoop = nil
end

function Recharge_InvestmentUI:OnDestroy()
end
