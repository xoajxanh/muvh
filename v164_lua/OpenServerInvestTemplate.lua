local OpenServerInvestTemplate = {}

function OpenServerInvestTemplate:Init(rootUI)
  self:InitControls(rootUI)
  self:BindUIEvent()
  self:InitContainer()
end

function OpenServerInvestTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.go_InvestGroup = self:GetControl("go_InvestGroup")
  self.Panel_invest_left = self:GetControl("go_InvestGroup/Panel_invest_left")
  self.Panel_invest_right = self:GetControl("go_InvestGroup/Panel_invest_right")
  self.lab_time = self:GetControl("go_InvestGroup/lab_time")
  self.Invest_left = self:GetControl("go_InvestGroup/left/Invest_left")
  self.img_Invest_left = self:GetControl("go_InvestGroup/left/Invest_left/img_Invest_left")
  self.btn_go = self:GetControl("go_InvestGroup/left/Invest_left/btn_go")
  self.lab_unTime = self:GetControl("go_InvestGroup/left/Invest_left/lab_unTime")
  self.grid_Invest = self:GetControl("go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest")
  self.go_Invest = self:GetControl("go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest")
  self.lab_Invest = self:GetControl("go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest/lab_Invest")
  self.lab_unfinish = self:GetControl("go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest/lab_unfinish")
  self.lab_finish = self:GetControl("go_InvestGroup/left/sw_Invest_left/Viewport/grid_Invest/go_Invest/lab_finish")
  self.right = self:GetControl("go_InvestGroup/right")
  self.Invest_right = self:GetControl("go_InvestGroup/right/Invest_right")
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_down = self:GetControl("plane_down")
end

function OpenServerInvestTemplate:InitContainer()
  self.panelInvestContainer = {}
  self.panelInvestContainer[KFTZGradeType.Ordinary] = luaTemplateManager.GetNewTemplate(self.Panel_invest_left, LuaComponentTemplates.OpenServerInvestGradeTemplate, self.rootUI)
  self.panelInvestContainer[KFTZGradeType.Advanced] = luaTemplateManager.GetNewTemplate(self.Panel_invest_right, LuaComponentTemplates.OpenServerInvestGradeTemplate, self.rootUI)
end

function OpenServerInvestTemplate:InitData()
end

function OpenServerInvestTemplate:BindUIEvent()
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function OpenServerInvestTemplate:btn_closeOnClick(control)
  UIManager.Hide(UIID.Recharge_InvestmentUI)
end

function OpenServerInvestTemplate:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Recharge_InvestmentUI")
  if type(lvCfg) ~= "table" or table.count(lvCfg) < 1 then
    return
  end
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function OpenServerInvestTemplate:Refresh()
  self:RefreshTime()
  self:RefreshInvestment()
end

function OpenServerInvestTemplate:RefreshInvestment()
  for i, template in pairs(self.panelInvestContainer) do
    if template.Refresh ~= nil then
      template:Refresh(QuickFind:GetOpenServerInvestmentData():GetInvestmentInfoDicByRechargeId(i))
    end
  end
end

function OpenServerInvestTemplate:RefreshTime()
  self:DestroyTime()
  self.lab_time:SetText(QuickFind:GetOpenServerInvestmentData():GetRemainTimeDes())
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.lab_time:SetText(QuickFind:GetOpenServerInvestmentData():GetRemainTimeDes())
  end)
end

function OpenServerInvestTemplate:Exit()
  for i, template in pairs(self.panelInvestContainer) do
    if template.Exit ~= nil then
      template:Exit()
    end
  end
  self:DestroyTime()
end

function OpenServerInvestTemplate:DestroyTime()
  if self.RemainTimeLoop then
    Timer.Stop(self.RemainTimeLoop)
    self.RemainTimeLoop = nil
  end
end

return OpenServerInvestTemplate
