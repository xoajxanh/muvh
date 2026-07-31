Activity_OtherWelfare = class(BaseUI)
Activity_OtherWelfare.layer = UILayer.Panel
Activity_OtherWelfare.orderInLayer = 0
Activity_OtherWelfare.hideType = UIHideType.WaitDestroy
Activity_OtherWelfare.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_OtherWelfare.escClose = UIEscClose.DontClose

function Activity_OtherWelfare:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.tog_goodComment = self:GetControl("sw_welfareList/Viewport/Content/tog_goodComment")
  self.sw_goodComment = self:GetControl("sw_goodComment")
  self.tog_bindPhone = self:GetControl("sw_welfareList/Viewport/Content/tog_bindPhone")
  self.sw_bindPhone = self:GetControl("sw_bindPhone")
  self.tog_followFB = self:GetControl("sw_welfareList/Viewport/Content/tog_followFB")
  self.sw_followFB = self:GetControl("sw_followFB")
  self.tog_joinTeam = self:GetControl("sw_welfareList/Viewport/Content/tog_joinTeam")
  self.go_joinTeam = self:GetControl("go_joinTeam")
  self.tog_gameGuide = self:GetControl("sw_welfareList/Viewport/Content/tog_gameGuide")
  self.sw_gameGuide = self:GetControl("sw_gameGuide")
end

local TogGerGroup = {}
local admin_ui = {}
local lastActiveToggleName = ""
local lastActivePanel

function Activity_OtherWelfare:Init()
end

function Activity_OtherWelfare:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_OtherWelfare:InitUI()
  TogGerGroup[Page.tog_goodComment] = self.tog_goodComment
  TogGerGroup[Page.tog_bindPhone] = self.tog_bindPhone
  TogGerGroup[Page.tog_followFB] = self.tog_followFB
  TogGerGroup[Page.tog_joinTeam] = self.tog_joinTeam
  TogGerGroup[Page.tog_gameGuide] = self.tog_gameGuide
  admin_ui[Page.tog_goodComment] = self.sw_goodComment
  admin_ui[Page.tog_bindPhone] = self.sw_bindPhone
  admin_ui[Page.tog_followFB] = self.sw_followFB
  admin_ui[Page.tog_joinTeam] = self.go_joinTeam
  admin_ui[Page.tog_gameGuide] = self.sw_gameGuide
  self.togglePanelMap = {
    tog_goodComment = admin_ui[Page.tog_goodComment],
    tog_bindPhone = admin_ui[Page.tog_bindPhone],
    tog_followFB = admin_ui[Page.tog_followFB],
    tog_joinTeam = admin_ui[Page.tog_joinTeam],
    tog_gameGuide = admin_ui[Page.tog_gameGuide]
  }
  self.panelRefreshMap = {
    tog_goodComment = function()
      self:RefreshGoodCommentPanel()
    end,
    tog_bindPhone = function()
      self:RefreshBindPhonePanel()
    end,
    tog_followFB = function()
      self:RefreshFollowFBPanel()
    end,
    tog_joinTeam = function()
      self:RefreshJoinTeamPanel()
    end,
    tog_gameGuide = function()
      self:RefreshGameGuidePanel()
    end
  }
  self.sw_goodCommentTemplate = luaTemplateManager.GetNewTemplate(self.togglePanelMap.tog_goodComment, LuaComponentTemplates.GoodReviewRewardTemplate, self)
  self.sw_bindPhoneTemplate = luaTemplateManager.GetNewTemplate(self.togglePanelMap.tog_bindPhone, LuaComponentTemplates.GoodReviewRewardTemplate, self)
  self.sw_followFBTemplate = luaTemplateManager.GetNewTemplate(self.togglePanelMap.tog_followFB, LuaComponentTemplates.GoodReviewRewardTemplate, self)
  self.sw_joinTeamTemplate = luaTemplateManager.GetNewTemplate(self.togglePanelMap.tog_joinTeam, LuaComponentTemplates.GoodReviewRewardTemplate, self)
  self.sw_gameGuideTemplate = luaTemplateManager.GetNewTemplate(self.togglePanelMap.tog_gameGuide, LuaComponentTemplates.GoodReviewRewardTemplate, self)
end

function Activity_OtherWelfare:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.tog_goodComment:SetOnToggleChanged(self, self.SwitchUnifiedPanel)
  self.tog_bindPhone:SetOnToggleChanged(self, self.SwitchUnifiedPanel)
  self.tog_followFB:SetOnToggleChanged(self, self.SwitchUnifiedPanel)
  self.tog_joinTeam:SetOnToggleChanged(self, self.SwitchUnifiedPanel)
  self.tog_gameGuide:SetOnToggleChanged(self, self.SwitchUnifiedPanel)
end

function Activity_OtherWelfare:SwitchUnifiedPanel(control, isOn)
  if not isOn then
    if lastActivePanel then
      lastActivePanel:SetActive(false)
      lastActiveToggleName = ""
      lastActivePanel = nil
    end
    return
  end
  local toggleName = control:GetName()
  if toggleName == lastActiveToggleName then
    self:RefreshPanel(toggleName)
    return
  end
  if lastActivePanel then
    lastActivePanel:SetActive(false)
  end
  local targetPanel = self.togglePanelMap[toggleName]
  if targetPanel then
    targetPanel:SetActive(true)
    self:RefreshPanel(toggleName)
    lastActiveToggleName = toggleName
    lastActivePanel = targetPanel
  end
end

function Activity_OtherWelfare:RefreshPanel(toggleName)
  local refreshFunc = self.panelRefreshMap[toggleName]
  if refreshFunc then
    refreshFunc()
  end
end

function Activity_OtherWelfare:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_OtherWelfare)
end

function Activity_OtherWelfare:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_OtherWelfare:RegistEvents()
end

function Activity_OtherWelfare:Refresh()
  self:RefreshViewTab()
end

function Activity_OtherWelfare:RefreshViewTab()
  local getPage = {}
  for i, v in pairs(TogGerGroup) do
    v:SetActive(false)
    local func = ClientTable.cfg_Function_functionManager:TryGetValue(i, "id")
    if ConditionManager.Check4D(func.condition) then
      v:SetActive(true)
      table.insert(getPage, i)
      table.sort(getPage, function(a, b)
        return a < b
      end)
    end
  end
  TogGerGroup[tonumber(getPage[1])]:SetIsOn(true)
  admin_ui[tonumber(getPage[1])]:SetActive(true)
end

function Activity_OtherWelfare:RefreshGoodCommentPanel()
  local data = QuickFind:GetOtherWelfareDataMgr():GetData(tonumber(Page.tog_goodComment))
  self.sw_goodCommentTemplate:Refresh(data, self)
end

function Activity_OtherWelfare:RefreshBindPhonePanel()
  local data = QuickFind:GetOtherWelfareDataMgr():GetData(tonumber(Page.tog_bindPhone))
  self.sw_bindPhoneTemplate:Refresh(data, self)
end

function Activity_OtherWelfare:RefreshFollowFBPanel()
  local data = QuickFind:GetOtherWelfareDataMgr():GetData(tonumber(Page.tog_followFB))
  self.sw_followFBTemplate:Refresh(data, self)
end

function Activity_OtherWelfare:RefreshJoinTeamPanel()
  local data = QuickFind:GetOtherWelfareDataMgr():GetData(tonumber(Page.tog_joinTeam))
  self.sw_joinTeamTemplate:Refresh(data, self)
end

function Activity_OtherWelfare:RefreshGameGuidePanel()
  local data = QuickFind:GetOtherWelfareDataMgr():GetData(tonumber(Page.tog_gameGuide))
  self.sw_gameGuideTemplate:Refresh(data, self)
end

function Activity_OtherWelfare:OnHide()
end

function Activity_OtherWelfare:OnDestroy()
end
