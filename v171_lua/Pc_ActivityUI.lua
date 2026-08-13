Pc_ActivityUI = class(BaseUI)
Pc_ActivityUI.layer = UILayer.Panel
Pc_ActivityUI.orderInLayer = 0
Pc_ActivityUI.hideType = UIHideType.WaitDestroy
Pc_ActivityUI.hideFunc = UIHideFunc.MoveOutOfScreen
Pc_ActivityUI.escClose = UIEscClose.DontClose

function Pc_ActivityUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.tog_FirstLogin = self:GetControl("tog_LeftView/Scrollview/Viewport/Content/tog_FirstLogin")
  self.tog_DailyRegistration = self:GetControl("tog_LeftView/Scrollview/Viewport/Content/tog_DailyRegistration")
  self.tog_CumulativeRecharge = self:GetControl("tog_LeftView/Scrollview/Viewport/Content/tog_CumulativeRecharge")
  self.panel_FirstLogin = self:GetControl("view_RightForm/panel_FirstLogin")
  self.panel_DailyRegistration = self:GetControl("view_RightForm/panel_DailyRegistration")
  self.panel_CumulativeRecharge = self:GetControl("view_RightForm/panel_CumulativeRecharge")
end

function Pc_ActivityUI:Init()
end

function Pc_ActivityUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Pc_ActivityUI:InitUI()
  self:InitTemplate()
  self:InitTogViewAssociationDic()
end

function Pc_ActivityUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.tog_FirstLogin:SetOnToggleChanged(self, self.tog_FirstLoginOnToggleChanged)
  self.tog_DailyRegistration:SetOnToggleChanged(self, self.tog_DailyRegistrationOnToggleChanged)
  self.tog_CumulativeRecharge:SetOnToggleChanged(self, self.tog_CumulativeRechargeOnToggleChanged)
end

function Pc_ActivityUI:btn_CloseOnClick(control)
  UIManager.Hide(UIID.Pc_ActivityUI)
end

function Pc_ActivityUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Pc_ActivityUI:InitTemplate()
  self.firstLoginTemplate = luaTemplateManager.GetNewTemplate(self.panel_FirstLogin, LuaComponentTemplates.FirstLoginTemplate, {
    rootUI = self,
    activityType = PCActivityTypeEnum.FirstLogin
  })
  self.dailyRegistrationTemplate = luaTemplateManager.GetNewTemplate(self.panel_DailyRegistration, LuaComponentTemplates.DailyRegistrationTemplate, {
    rootUI = self,
    activityType = PCActivityTypeEnum.DailyRegistration
  })
  self.cumulativeRechargeTemplate = luaTemplateManager.GetNewTemplate(self.panel_CumulativeRecharge, LuaComponentTemplates.CumulativeRechargeTemplate, {
    rootUI = self,
    activityType = PCActivityTypeEnum.CumulativeRecharge
  })
end

function Pc_ActivityUI:InitTogViewAssociationDic()
  self.m_AllTogViewAssociationDic = {
    {
      activityType = PCActivityTypeEnum.FirstLogin,
      togControl = self.tog_FirstLogin,
      onChanged = self.tog_FirstLoginOnToggleChanged,
      view = self.panel_FirstLogin,
      redPoint = ERedPointId.pc_FirstLogin,
      template = self.firstLoginTemplate
    },
    {
      activityType = PCActivityTypeEnum.DailyRegistration,
      togControl = self.tog_DailyRegistration,
      onChanged = self.tog_DailyRegistrationOnToggleChanged,
      view = self.panel_DailyRegistration,
      redPoint = ERedPointId.pc_DailyRegistration,
      template = self.dailyRegistrationTemplate
    },
    {
      activityType = PCActivityTypeEnum.CumulativeRecharge,
      togControl = self.tog_CumulativeRecharge,
      onChanged = self.tog_CumulativeRechargeOnToggleChanged,
      view = self.panel_CumulativeRecharge,
      redPoint = ERedPointId.pc_CumulativeRecharge,
      template = self.cumulativeRechargeTemplate
    }
  }
end

function Pc_ActivityUI:RefreshTogConditionInfo()
  self.m_SatisfyTogViewAssociationDic = {}
  for _, togViewAssociation in ipairs(self.m_AllTogViewAssociationDic) do
    local commerceConfig = ClientTable.cfg_Commerce_overviewManager:TryGetValue(togViewAssociation.activityType, "group")
    if commerceConfig ~= nil then
      local showCondition = ConditionManager.Check4D(commerceConfig.level)
      if showCondition then
        togViewAssociation.commerceConfig = commerceConfig
        table.insert(self.m_SatisfyTogViewAssociationDic, togViewAssociation)
      end
      togViewAssociation.togControl:SetActive(showCondition)
    end
  end
end

function Pc_ActivityUI:RefreshTogSiblingIndexInfo()
  if self.m_SatisfyTogViewAssociationDic == nil then
    return
  end
  table.sort(self.m_SatisfyTogViewAssociationDic, function(a, b)
    if a.commerceConfig and b.commerceConfig then
      return a.commerceConfig.order < b.commerceConfig.order
    end
  end)
  for index, togViewAssociation in ipairs(self.m_SatisfyTogViewAssociationDic) do
    if togViewAssociation and togViewAssociation.commerceConfig then
      togViewAssociation.togControl:SetSiblingIndex(index)
    end
  end
end

function Pc_ActivityUI:RefreshTogViewAssociationInfo()
  if self.m_SatisfyTogViewAssociationDic == nil then
    return
  end
  local pageIndex = self:GetFirstSelectTogIndexInfo()
  for index, togViewAssociation in ipairs(self.m_SatisfyTogViewAssociationDic) do
    local isOn = index == pageIndex
    togViewAssociation.togControl:SetIsOn(isOn)
    togViewAssociation.onChanged(self, togViewAssociation.togControl, isOn)
    UIControl(togViewAssociation.togControl.transform, "Label"):SetText(togViewAssociation.commerceConfig.commerceName)
  end
end

function Pc_ActivityUI:GetFirstSelectTogIndexInfo()
  local page = 1
  for index, togViewAssociation in ipairs(self.m_SatisfyTogViewAssociationDic) do
    if togViewAssociation and togViewAssociation.redPoint then
      local isShow = RedPointChecker:CheckIsNeedShow(togViewAssociation.redPoint)
      if isShow then
        page = index
        break
      end
    end
  end
  if self.args and self.args.openFirstTab then
    page = self.args.openFirstTab
  end
  return page
end

function Pc_ActivityUI:tog_FirstLoginOnToggleChanged(control, eventData)
  if eventData then
    self:RefreshView()
  end
end

function Pc_ActivityUI:tog_DailyRegistrationOnToggleChanged(control, eventData)
  if eventData then
    self:RefreshView()
  end
end

function Pc_ActivityUI:tog_CumulativeRechargeOnToggleChanged(control, eventData)
  if eventData then
    self:RefreshView()
  end
end

function Pc_ActivityUI:RefreshView()
  if self.m_SatisfyTogViewAssociationDic == nil then
    return
  end
  for index, togViewAssociation in ipairs(self.m_SatisfyTogViewAssociationDic) do
    if togViewAssociation and togViewAssociation.togControl and togViewAssociation.view and togViewAssociation.template then
      local isOn = togViewAssociation.togControl:GetIsOn()
      togViewAssociation.view:SetActive(isOn)
      if isOn then
        togViewAssociation.template:Refresh()
      end
      local labelControl = togViewAssociation.togControl:GetChild("Label")
      if not IsNil(labelControl.transform) then
        local colorStr = isOn and UIColorDic[UIColorEnum.VerticalFirstTogSelected] or UIColorDic[UIColorEnum.VerticalFirstTogNormal]
        labelControl:SetColor(ColorUtility.StrToHexColorStr(colorStr))
      end
    end
  end
end

function Pc_ActivityUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshView, self)
  self:RegistEvent(Event.CountsRefresh, self.RefreshView, self)
end

function Pc_ActivityUI:Refresh()
  self:RefreshTogConditionInfo()
  self:RefreshTogSiblingIndexInfo()
  self:RefreshTogViewAssociationInfo()
end

function Pc_ActivityUI:OnHide()
end

function Pc_ActivityUI:OnDestroy()
end
