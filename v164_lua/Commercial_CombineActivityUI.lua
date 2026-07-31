Commercial_CombineActivityUI = class(BaseUI)
Commercial_CombineActivityUI.layer = UILayer.Panel
Commercial_CombineActivityUI.orderInLayer = 5
Commercial_CombineActivityUI.hideType = UIHideType.WaitDestroy
Commercial_CombineActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_CombineActivityUI.escClose = UIEscClose.DontClose

function Commercial_CombineActivityUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Btn_Holiday = self:GetControl("sw_combineActivityList/Viewport/Content/Btn_Holiday")
  self.btn_close = self:GetControl("btn_close")
  self.go_combineFireworks = self:GetControl("go_combineFireworks")
  self.go_combineGift = self:GetControl("go_combineGift")
  self.go_combineRechangeGet = self:GetControl("go_combineRechangeGet")
  self.go_combineFirstGift = self:GetControl("go_combineFirstGift")
  self.go_combineWarOrderPass = self:GetControl("go_combineWarOrderPass")
  self.go_combineConsumeRank = self:GetControl("go_combineConsumeRank")
  self.go_combineDailyGoodReward = self:GetControl("go_combineDailyGoodReward")
  self.go_combinetask = self:GetControl("go_combinetask")
end

Commercial_CombineActivityUI.ToggleWithPanelTemplate = nil
Commercial_CombineActivityUI.ForceJumpActivityPageId = nil

function Commercial_CombineActivityUI:Init()
end

function Commercial_CombineActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegisterPanel()
  self:RegistUIEvents()
end

function Commercial_CombineActivityUI:InitUI()
  self.pageTempaltes = UIUtility.BindUIContainerTemp(self.Btn_Holiday, LuaComponentTemplates.Activity_CommercialCombine_Page, self)
end

function Commercial_CombineActivityUI:RegisterPanel()
  self.ToggleWithPanelTemplate = {}
  self.ToggleWithPanelTemplate[CommerceActivityIdType.LianChongFanLi] = luaTemplateManager.GetNewTemplate(self.go_combineRechangeGet, LuaComponentTemplates.LianChongFanLiViewTemplate, {baseUI = self})
  self.ToggleWithPanelTemplate[CommerceActivityIdType.CombineFirstGiftData] = luaTemplateManager.GetNewTemplate(self.go_combineFirstGift, LuaComponentTemplates.Activity_CombineFirstGift_MainTemplates, self)
  self.ToggleWithPanelTemplate[CommerceActivityIdType.MiracleBattlePass] = luaTemplateManager.GetNewTemplate(self.go_combineWarOrderPass, LuaComponentTemplates.WarOrderPassTemplate, {
    rootUI = self,
    activityBaseType = ActivityBaseType.CommerceActivity,
    activityIdType = CommerceActivityIdType.MiracleBattlePass
  })
  self.ToggleWithPanelTemplate[CommerceActivityIdType.GoodFiftsEveryDay] = luaTemplateManager.GetNewTemplate(self.go_combineDailyGoodReward, LuaComponentTemplates.Activity_GoodFiftsEveryDay_MainTemplates, self)
  self.ToggleWithPanelTemplate[CommerceActivityIdType.ConsumeRanking] = luaTemplateManager.GetNewTemplate(self.go_combineConsumeRank, LuaComponentTemplates.Activity_CommercialRankingTemplate, self)
  self.ToggleWithPanelTemplate[CommerceActivityIdType.CombineTask] = luaTemplateManager.GetNewTemplate(self.go_combinetask, LuaComponentTemplates.Activity_CommercialCombineTaskTemplate, self)
end

function Commercial_CombineActivityUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Commercial_CombineActivityUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Commercial_CombineActivityUI)
end

function Commercial_CombineActivityUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_CombineActivityUI)
end

function Commercial_CombineActivityUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Commercial_CombineActivityUI:RegistEvents()
  self:RegistEvent(Event.CommerceCombineActivityPageOpen, self.OnCommerceCombineActivityPageOpen, self)
  self:RegistEvent(Event.CommerceCombineActivityPageClose, self.OnCommerceCombineActivityPageClose, self)
  self:RegistEvent(Event.CommerceCombineActivitySetJumpId, self.OnCommerceCombineActivitySetJumpId, self)
  self:RegistEvent(Event.CommerceCombineActivityClearJumpId, self.OnCommerceCombineActivityClearJumpId, self)
  self:RegistEvent(Event.CoServeLCFLRefreshView, self.OnCoServeLCFLRefreshView, self)
  self:RegistEvent(Event.CoServeLCFLRefreshRedPointView, self.OnCoServeLCFLRefreshRedPointView, self)
  self:RegistEvent(Event.CombineFirstGiftDataRefesh, self.OnRefreshCountCombineFirstGift, self)
  self:RegistEvent(Event.CombineFirstGiftCountSortOver, self.OnRefreshCountCombineFirstGift, self)
  self:RegistEvent(Event.GoodFiftsEveryDay, self.OnGoodFiftsEveryDayRefrash, self)
  self:RegistEvent(Event.CommercialRanking, self.CommercialRankingActivity, self)
  self:RegistEvent(Event.CombineWarOrderPassRefesh, self.OnCombineWarOrderPassRefesh, self)
  self:RegistEvent(Event.CombineWarOrderPassRefeshRare, self.OnCombineWarOrderPassRefeshRare, self)
  self:RegistEvent(Event.GoodFiftsEveryDayRefesh, self.OnGoodFiftsEveryDayRefesh, self)
  self:RegistEvent(Event.CombineTask, self.OnCombineTaskRefrash, self)
end

function Commercial_CombineActivityUI:OnCommerceCombineActivityPageOpen(id, data)
  local template = self:GetActivityTemplate(data:GetActivityId())
  if template ~= nil then
    template:UIControl():SetActive(true)
    if template.Refresh ~= nil then
      template:Refresh()
    end
  end
end

function Commercial_CombineActivityUI:OnCommerceCombineActivityPageClose(id, data)
  local template = self:GetActivityTemplate(data:GetActivityId())
  if template ~= nil then
    template:UIControl():SetActive(false)
    if template.Exit ~= nil then
      template:Exit()
    end
  end
end

function Commercial_CombineActivityUI:OnCommerceCombineActivitySetJumpId(id, activityId)
  if type(activityId) ~= "number" then
    return
  end
  self.ForceJumpActivityPageId = activityId
end

function Commercial_CombineActivityUI:OnCommerceCombineActivityClearJumpId(id, activityId)
  if type(activityId) ~= "number" then
    return
  end
  if self.ForceJumpActivityPageId == activityId then
    self.ForceJumpActivityPageId = nil
  end
end

function Commercial_CombineActivityUI:Refresh()
  if not self:AnalysisParams() then
    UIManager.Hide(UIID.Commercial_CombineActivityUI)
    return
  end
  networkRequest.ReqGetCommercialActivityInfo(CommercializeActivityTab.Combining_service, CommerceActivityIdType.CombineFirstGiftData)
  gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity):GetActivityData(CommerceActivityIdType.CombineTask):ReqServerInfo()
  self:RefreshPage()
  self:SetToggle()
end

function Commercial_CombineActivityUI:AnalysisParams()
  self.choosePage = CommerceActivityIdType.MiracleBattlePass
  if self.ForceJumpActivityPageId ~= nil then
    self.choosePage = self.ForceJumpActivityPageId
  elseif self.args ~= nil and self.args.activityId ~= nil then
    self.choosePage = self.args.activityId
  end
  return true
end

function Commercial_CombineActivityUI:RefreshPage()
  local commerceActivityManager = gameMgr:GetGlobalActivityDataManager():GetActivityManger(ActivityBaseType.CommerceActivity)
  self.pageTempaltes:SetData(commerceActivityManager:GetSortAndShowActivity())
end

function Commercial_CombineActivityUI:OnCombineTaskRefrash()
  local template = self:GetActivityTemplate(CommerceActivityIdType.CombineTask)
  if template then
    template:Refresh()
  end
end

function Commercial_CombineActivityUI:OnGoodFiftsEveryDayRefrash()
  local template = self:GetActivityTemplate(CommerceActivityIdType.GoodFiftsEveryDay)
  if template then
    template:Refresh()
  end
end

function Commercial_CombineActivityUI:CommercialRankingActivity()
  local template = self:GetActivityTemplate(CommerceActivityIdType.ConsumeRanking)
  if template then
    template:RefreshModelUI()
  end
end

function Commercial_CombineActivityUI:SetToggle()
  local pageTemplate = self:GetPageTemplate(self.choosePage)
  if pageTemplate ~= nil then
    if pageTemplate:GetIsOn() then
      local panelTemplate = self:GetActivityTemplate(pageTemplate.activityData:GetActivityId())
      if panelTemplate ~= nil then
        panelTemplate:UIControl():SetActive(true)
        panelTemplate:Refresh()
      end
    else
      pageTemplate:SetIsOn()
    end
  end
end

function Commercial_CombineActivityUI:OnHide()
  self:Exit()
end

function Commercial_CombineActivityUI:OnDestroy()
  self:Exit()
end

function Commercial_CombineActivityUI:GetActivityTemplate(activityId)
  if type(activityId) ~= "number" or self.ToggleWithPanelTemplate == nil then
    return
  end
  return self.ToggleWithPanelTemplate[activityId]
end

function Commercial_CombineActivityUI:GetPageTemplate(activityId)
  local pageTemplateList, pageTemplate = self.pageTempaltes.items
  if next(pageTemplateList) == nil then
    return
  end
  for k, v in pairs(pageTemplateList) do
    pageTemplate = v.itemTemp
    if pageTemplate.activityData ~= nil and pageTemplate.activityData.activityTbl ~= nil and pageTemplate.activityData.activityTbl.activityId == activityId then
      return pageTemplate
    end
  end
  return pageTemplateList[next(pageTemplateList)].itemTemp
end

function Commercial_CombineActivityUI:OnCoServeLCFLRefreshView()
  local temp = self:GetActivityTemplate(CommerceActivityIdType.LianChongFanLi)
  if temp then
    temp:OnCoServeLCFLRefreshView()
  end
end

function Commercial_CombineActivityUI:OnCoServeLCFLRefreshRedPointView()
  local temp = self:GetActivityTemplate(CommerceActivityIdType.LianChongFanLi)
  if temp then
    temp:OnCoServeLCFLRefreshRedPointView()
  end
end

function Commercial_CombineActivityUI:OnRefreshCountCombineFirstGift()
  local temp = self:GetActivityTemplate(CommerceActivityIdType.CombineFirstGiftData)
  if temp then
    temp:Refresh()
  end
end

function Commercial_CombineActivityUI:OnCombineWarOrderPassRefesh()
  local temp = self:GetActivityTemplate(CommerceActivityIdType.MiracleBattlePass)
  if temp then
    temp:Refresh()
  end
end

function Commercial_CombineActivityUI:OnCombineWarOrderPassRefeshRare()
  local temp = self:GetActivityTemplate(CommerceActivityIdType.MiracleBattlePass)
  if temp then
    temp:RefreshRareReward()
  end
end

function Commercial_CombineActivityUI:OnGoodFiftsEveryDayRefesh()
  local temp = self:GetActivityTemplate(CommerceActivityIdType.GoodFiftsEveryDay)
  if temp then
    temp:Refresh()
  end
end

function Commercial_CombineActivityUI:Exit()
  if type(self.ToggleWithPanelTemplate) == "table" then
    for k, v in pairs(self.ToggleWithPanelTemplate) do
      v:UIControl():SetActive(false)
      if v.Exit ~= nil then
        v:Exit()
      end
    end
  end
  local pageTemplate
  if type(self.pageTempaltes) == "table" and type(self.pageTempaltes.items) == "table" then
    for k, v in pairs(self.pageTempaltes.items) do
      pageTemplate = v.itemTemp
      if pageTemplate.Exit ~= nil then
        pageTemplate:Exit()
      end
    end
  end
end
