Activity_LeagueSiegeUI = class(BaseUI)
Activity_LeagueSiegeUI.layer = UILayer.Panel
Activity_LeagueSiegeUI.orderInLayer = 9
Activity_LeagueSiegeUI.hideType = UIHideType.WaitDestroy
Activity_LeagueSiegeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_LeagueSiegeUI.escClose = UIEscClose.DontClose

function Activity_LeagueSiegeUI:InitControls()
  self.btn_close = self:GetControl("bg/btn_close")
  self.tog_LeagueSiege = self:GetControl("sw_welfareList/Viewport/Content/tog_LeagueSiege")
  self.tog_SiegeUI = self:GetControl("sw_welfareList/Viewport/Content/tog_SiegeUI")
  self.sw_LeagueSiege = self:GetControl("sw_LeagueSiege")
  self.sw_SiegeUI = self:GetControl("sw_SiegeUI")
end

Activity_LeagueSiegeUI.pageList = nil
Activity_LeagueSiegeUI.ToggleWithPanelTemplate = nil

function Activity_LeagueSiegeUI:Init()
end

function Activity_LeagueSiegeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegisterPage()
  self:RegisterPanel()
  self:RegistUIEvents()
end

function Activity_LeagueSiegeUI:InitUI()
end

function Activity_LeagueSiegeUI:RegisterPage()
  self.pageList = {}
  self.pageList[CoalitionPageType.CoalitionPage] = self.tog_LeagueSiege
  self.pageList[CoalitionPageType.Siege] = self.tog_SiegeUI
end

function Activity_LeagueSiegeUI:RegisterPanel()
  self.ToggleWithPanelTemplate = {}
  self.ToggleWithPanelTemplate[self.tog_LeagueSiege] = luaTemplateManager.GetNewTemplate(self.sw_LeagueSiege, LuaComponentTemplates.CoalitionTemplate)
  self.ToggleWithPanelTemplate[self.tog_SiegeUI] = luaTemplateManager.GetNewTemplate(self.sw_SiegeUI, LuaComponentTemplates.Coalition_SiegeTemplate)
end

function Activity_LeagueSiegeUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  for toggle, template in pairs(self.ToggleWithPanelTemplate) do
    toggle:SetOnToggleChanged(self, self.ToggleCallBack)
  end
end

function Activity_LeagueSiegeUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_LeagueSiegeUI)
end

function Activity_LeagueSiegeUI:ToggleCallBack(control)
  if self.ToggleWithPanelTemplate == nil or self.ToggleWithPanelTemplate[control] == nil then
    return
  end
  local toggleTemplate = self.ToggleWithPanelTemplate[control]
  if toggleTemplate == nil then
    return
  end
  local controlState = control:GetIsOn()
  if controlState == false then
    if toggleTemplate.Exit ~= nil then
      toggleTemplate:Exit()
    end
  elseif toggleTemplate.Refresh ~= nil then
    toggleTemplate:Refresh(self)
  end
  toggleTemplate:UIControl():SetActive(controlState)
end

function Activity_LeagueSiegeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:RefreshOpenTime()
end

function Activity_LeagueSiegeUI:RegistEvents()
  self:RegistEvent(Event.CoalitionDataChange, self.OnCoalitionDataChange, self)
  self:RegistEvent(Event.CoalitionOnLienPeopleNumChange, self.OnCoalitionOnLienPeopleNumChange, self)
  self:RegistEvent(Event.MainPlayerCoalitionChange, self.OnMainPlayerCoalitionChange, self)
  self:RegistEvent(Event.PlayActivityStateChange, self.OnPlayActivityStateChange, self)
end

function Activity_LeagueSiegeUI:Refresh()
  self:RefreshPanel()
end

function Activity_LeagueSiegeUI:CoalitionSiegeStcchange()
  self.ToggleWithPanelTemplate[self.tog_SiegeUI]:RefreshDataUI()
end

function Activity_LeagueSiegeUI:RefreshPanel()
  local pageType = CoalitionPageType.CoalitionPage
  if self.args ~= nil and self.args.pageType ~= nil then
    pageType = self.args.pageType
  end
  local toggle = self.pageList[pageType]
  if toggle == nil then
    return
  end
  if toggle:GetIsOn() == true then
    self.ToggleWithPanelTemplate[toggle]:Refresh(self)
  else
    toggle:SetIsOn(true)
  end
end

function Activity_LeagueSiegeUI:RefreshOpenTime()
end

function Activity_LeagueSiegeUI:OnCoalitionDataChange(id, coalitionId)
  local coalitionTemplate = self.ToggleWithPanelTemplate[self.tog_LeagueSiege]
  if coalitionId == nil then
    coalitionTemplate:RefreshAllCoalition()
  else
    coalitionTemplate:RefreshSingleCoalition(coalitionId)
  end
end

function Activity_LeagueSiegeUI:OnCoalitionOnLienPeopleNumChange(id, coalitionId)
  if coalitionId == nil then
    return
  end
  local coalitionTemplate = self.ToggleWithPanelTemplate[self.tog_LeagueSiege]
  coalitionTemplate:RefreshOnLinePeopleNum(coalitionId)
end

function Activity_LeagueSiegeUI:OnMainPlayerCoalitionChange(id)
  local coalitionTemplate = self.ToggleWithPanelTemplate[self.tog_LeagueSiege]
  coalitionTemplate:RefreshAllTemplateBtn()
end

function Activity_LeagueSiegeUI:OnPlayActivityStateChange(id, activityId)
  local coalitionTemplate = self.ToggleWithPanelTemplate[self.tog_LeagueSiege]
  coalitionTemplate:RefreshAllTemplateBtn()
  coalitionTemplate:RefreshNotice()
end

function Activity_LeagueSiegeUI:OnHide()
  for k, v in pairs(self.ToggleWithPanelTemplate) do
    if v.Exit ~= nil then
      v:Exit()
    end
  end
end

function Activity_LeagueSiegeUI:OnDestroy()
end
