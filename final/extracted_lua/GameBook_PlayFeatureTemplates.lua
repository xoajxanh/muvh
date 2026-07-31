local GameBook_PlayFeatureTemplates = {}

function GameBook_PlayFeatureTemplates:Init()
  self:InitControls()
end

function GameBook_PlayFeatureTemplates:InitControls()
  self.lab_descTitle = self:GetControl("activityForecast/titleBg/descTitle")
  self.img_descTitle = self:GetControl("activityForecast/titleBg/descImg")
  self.lab_descContent = self:GetControl("activityForecast/contentBg/descContent")
  self.lab_tip_noStart = self:GetControl("activityForecast/tip_noStart")
  self.btn_go = self:GetControl("activityForecast/btn_go")
end

function GameBook_PlayFeatureTemplates:Refresh(_templateData)
  self.templateData = _templateData
  local cfg_gameguide = self.templateData.cfg_gameguide
  self.lab_descTitle:SetText(cfg_gameguide.title)
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(cfg_gameguide.des)
  self.lab_descContent:SetText(content)
  local testIsCanGo = 0
  self.lab_tip_noStart:SetActive(testIsCanGo == 0)
  self.btn_go:SetOnClickParam(self, self.btn_goKillOnClick, cfg_gameguide.jump)
  _templateData.ui:SetSprite("Atlas_Common", cfg_gameguide.pic, self.img_descTitle, false)
end

function GameBook_PlayFeatureTemplates:btn_goKillOnClick(control)
  local jumpId = control.param
  local cfg_navigation = ClientTable.cfg_Navigation_barManager:TryGetValue(jumpId)
  if cfg_navigation == nil then
    return
  end
  if not self:CheckOpenCondition(cfg_navigation) then
    return
  end
  NavigationUtility.ClickNavigation(cfg_navigation)
  UIManager.Hide(UIID.System_GameBookUI)
end

function GameBook_PlayFeatureTemplates:CheckOpenCondition(table)
  if table.route and table.route == "WarAlliance_menuUI" and WarAllianceData.MyWarAllianceData.id == nil then
    FloatingTipUtility.QuickMsg("Kh\195\180ng thu\225\187\153c Guild, kh\195\180ng th\225\187\131 s\225\187\173 d\225\187\165ng")
    return false
  end
  return true
end

return GameBook_PlayFeatureTemplates
