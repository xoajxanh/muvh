WarAlliance_menuUI = class(BaseUI)
WarAlliance_menuUI.layer = UILayer.Panel
WarAlliance_menuUI.orderInLayer = 0
WarAlliance_menuUI.hideType = UIHideType.Destroy
WarAlliance_menuUI.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_menuUI.escClose = UIEscClose.DontClose

function WarAlliance_menuUI:InitControls()
  self.menu = self:GetControl("menu")
  self.NoWarAllianceTab = self:GetControl("menu/swt_bg/NoWarAllianceTab")
  self.apply_tab = self:GetControl("menu/swt_bg/NoWarAllianceTab/apply_tab")
  self.creat_tab = self:GetControl("menu/swt_bg/NoWarAllianceTab/creat_tab")
  self.WarAllianceTab = self:GetControl("menu/swt_bg/WarAllianceTab")
  self.info_tab = self:GetControl("menu/swt_bg/WarAllianceTab/info_tab")
  self.garden_tab = self:GetControl("menu/swt_bg/WarAllianceTab/garden_tab")
  self.exitgarden_tab = self:GetControl("menu/swt_bg/WarAllianceTab/exitgarden_tab")
  self.armbands_tab = self:GetControl("menu/swt_bg/WarAllianceTab/armbands_tab")
  self.Task_tab = self:GetControl("menu/swt_bg/WarAllianceTab/Task_tab")
  self.activity_tab = self:GetControl("menu/swt_bg/WarAllianceTab/activity_tab")
  self.fund_tab = self:GetControl("menu/swt_bg/WarAllianceTab/fund_tab")
  self.List_tab = self:GetControl("menu/swt_bg/WarAllianceTab/List_tab ")
  self.member_tab = self:GetControl("menu/swt_bg/WarAllianceTab/member_tab")
  self.manager_tab = self:GetControl("menu/swt_bg/WarAllianceTab/manager_tab")
  self.Rank_tab = self:GetControl("menu/swt_bg/WarAllianceTab/Rank_tab")
  self.Campaign_tab = self:GetControl("menu/swt_bg/WarAllianceTab/Campaign_tab")
  self.Impeach_tab = self:GetControl("menu/swt_bg/WarAllianceTab/Impeach_tab")
  self.Replace_tab = self:GetControl("menu/swt_bg/WarAllianceTab/Replace_tab")
  self.WarAlliance_SecTab = self:GetControl("menu/swt_bg/WarAlliance_SecTab")
  self.Hp_tab = self:GetControl("menu/swt_bg/WarAlliance_SecTab/Hp_tab")
  self.hpimg_clickeffect = self:GetControl("menu/swt_bg/WarAlliance_SecTab/Hp_tab/hpimg_clickeffect")
  self.Atk_tab = self:GetControl("menu/swt_bg/WarAlliance_SecTab/Atk_tab")
  self.atkimg_clickeffect = self:GetControl("menu/swt_bg/WarAlliance_SecTab/Atk_tab/atkimg_clickeffect")
  self.Def_tab = self:GetControl("menu/swt_bg/WarAlliance_SecTab/Def_tab")
  self.defimg_clickeffect = self:GetControl("menu/swt_bg/WarAlliance_SecTab/Def_tab/defimg_clickeffect")
end

WarAlliance_menuUI.Tag = {
  APPLY = enum(0),
  CREATE = enum(),
  INFO = enum(),
  ACTIVITY = enum(),
  ARMBANDS = enum(),
  LIST = enum(),
  RANK = enum(),
  TASK = enum(),
  IMPEACH = enum(),
  CAMPAIGN = enum(),
  REPLACE = enum()
}

function WarAlliance_menuUI:OnPreLoad()
end

function WarAlliance_menuUI:Init()
  self.MapID = 1035001
  self.UnionActiveMapID = 103500101
end

function WarAlliance_menuUI:OnCreate()
  self:InitControls()
  self:InitUIData()
  self:RegistUIEvents()
end

function WarAlliance_menuUI:InitUIData()
  self.menuItemInfo = {
    [WarAlliance_menuUI.Tag.APPLY] = {
      group = 0,
      btnNode = self.apply_tab,
      onClick = self.apply_tabOnClick
    },
    [WarAlliance_menuUI.Tag.CREATE] = {
      group = 0,
      btnNode = self.creat_tab,
      onClick = self.creat_tabOnClick
    },
    [WarAlliance_menuUI.Tag.INFO] = {
      group = 1,
      btnNode = self.info_tab,
      onClick = self.info_tabOnClick
    },
    [WarAlliance_menuUI.Tag.ACTIVITY] = {
      group = 1,
      btnNode = self.activity_tab,
      onClick = self.activity_tabOnClick
    },
    [WarAlliance_menuUI.Tag.ARMBANDS] = {
      group = 1,
      btnNode = self.armbands_tab,
      onClick = self.armbands_tabOnClick
    },
    [WarAlliance_menuUI.Tag.LIST] = {
      group = 1,
      btnNode = self.List_tab,
      onClick = self.List_tabOnClick
    },
    [WarAlliance_menuUI.Tag.RANK] = {
      group = 1,
      btnNode = self.Rank_tab,
      onClick = self.Rank_tabOnClick
    },
    [WarAlliance_menuUI.Tag.TASK] = {
      group = 1,
      btnNode = self.Task_tab,
      onClick = self.Task_tabOnClick
    },
    [WarAlliance_menuUI.Tag.IMPEACH] = {
      group = 1,
      btnNode = self.Impeach_tab,
      onClick = self.Impeach_tabOnClick
    },
    [WarAlliance_menuUI.Tag.CAMPAIGN] = {
      group = 1,
      btnNode = self.Campaign_tab,
      onClick = self.Campaign_tabOnClick
    },
    [WarAlliance_menuUI.Tag.REPLACE] = {
      group = 1,
      btnNode = self.Replace_tab,
      onClick = self.Replace_tabOnClick
    }
  }
  self:InitArmbandTagInfo()
end

function WarAlliance_menuUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {10020001, 10030001})
end

function WarAlliance_menuUI:OnHide()
end

function WarAlliance_menuUI:OnDestroy()
end

function WarAlliance_menuUI:RegistUIEvents()
  for key, info in pairs(self.menuItemInfo) do
    info.btnNode:SetOnClick(self, info.onClick)
  end
  self:RegisteArmbandTagEvent()
end

function WarAlliance_menuUI:apply_tabOnClick()
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.APPLY)
  self:WarAllianceUIManager(UIID.WarAlliance_List)
end

function WarAlliance_menuUI:creat_tabOnClick()
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.CREATE)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Creat)
end

function WarAlliance_menuUI:info_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.INFO)
  self:WarAllianceUIManager(UIID.WarAlliance_Member)
end

function WarAlliance_menuUI:activity_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.ACTIVITY)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Activity)
end

function WarAlliance_menuUI:armbands_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.ARMBANDS)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Armband)
  local args, page = self.args, WarAllianceBadgeTag.HP
  if args ~= nil and args.openSecondTab == WarAlliance_menuUI.Tag.ARMBANDS and args.subPosition ~= nil and type(args.subPosition) == "number" then
    page = args.subPosition
  end
  local node = self.armbandMenu[page]
  if node then
    node.onClick(self)
  end
end

function WarAlliance_menuUI:fund_tabOnClick(control)
end

function WarAlliance_menuUI:member_tabOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Member)
end

function WarAlliance_menuUI:manager_tabOnClick(control)
end

function WarAlliance_menuUI:List_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.LIST)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_List)
end

function WarAlliance_menuUI:Rank_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.RANK)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Rank)
end

function WarAlliance_menuUI:Task_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.TASK)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_TaskUI)
end

function WarAlliance_menuUI:Impeach_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.IMPEACH)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Impeach)
end

function WarAlliance_menuUI:Campaign_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.CAMPAIGN)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Campaign)
end

function WarAlliance_menuUI:Replace_tabOnClick(control)
  self:SetButtonPitchOn(WarAlliance_menuUI.Tag.REPLACE)
  UIManager.Hide(UIID.WarAlliance_Data)
  UIManager.Hide(UIID.WarAlliance_InfoUI)
  self:WarAllianceUIManager(UIID.WarAlliance_Replace)
end

function WarAlliance_menuUI:RegistEvents()
  self:RegistEvent(Event.WarAlliance_SelectMenu, self.SelectMenu, self)
  self:RegistEvent(Event.WarAlliance_MyWarAllianceData, self.RefreshPanel, self)
  self:RegistEvent(Event.WarAlliance_Leave, self.WarAlliance_Leave, self)
  self:RegistEvent(Event.WarAlliance_MasterMemberInfo, self.RefreshImpeachInfo, self)
  self:RegistEvent(Event.WarAlliance_ImpeachInfo, self.RefreshImpeachInfo, self)
  self:RegistEvent(Event.WarAlliance_MasterMemberInfo, self.RefreshReplaceInfo, self)
  self:RegistEvent(Event.WarAlliance_ReplaceInfo, self.RefreshReplaceInfo, self)
  self:RegistEvent(Event.WarAlliance_MasterMemberInfo, self.RefreshCampaignInfo, self)
  self:RegistEvent(Event.WarAlliance_CampaignInfo, self.RefreshCampaignInfo, self)
  self:RegistEvent(Event.WarAlliance_InitWarAllianceList, self.RefreshApplyOrCreate, self)
end

function WarAlliance_menuUI:Refresh()
  EventManager.Dispatch(Event.WarAlliance_OpenPanel)
  self:RefreshImpeachInfo()
  self:RefreshPanel()
end

function WarAlliance_menuUI:RefreshImpeachInfo()
  if not WarAllianceData.IsHaveUnion then
    return
  end
  local info = WarAllianceData.ImpeachInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Impeach
    })
    return
  end
  self.Impeach_tab:SetActive(WarAllianceData.IsImpeaching() and WarAllianceData.IsShowImpeach())
end

function WarAlliance_menuUI:RefreshReplaceInfo()
  if not WarAllianceData.IsHaveUnion then
    return
  end
  local info = WarAllianceData.ReplaceInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Replace
    })
    return
  end
  self.Replace_tab:SetActive(WarAllianceData.IsReplaceing() and WarAllianceData.IsShowReplace())
end

function WarAlliance_menuUI:RefreshCampaignInfo()
  if not WarAllianceData.IsHaveUnion then
    return
  end
  local info = WarAllianceData.CampaignInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Campaign
    })
    return
  end
  self.Campaign_tab:SetActive(WarAllianceData.IsCampaigning() and WarAllianceData.IsShowCampaign())
end

function WarAlliance_menuUI:RefreshPanel()
  local defaultPanel
  if WarAllianceData.IsHaveUnion then
    defaultPanel = WarAlliance_menuUI.Tag.INFO
    self.WarAllianceTab:SetActive(true)
  else
    local data = WarAllianceData.WarAllianceDataList
    if data and 0 < #data then
      defaultPanel = WarAlliance_menuUI.Tag.APPLY
      self.apply_tab:SetActive(true)
    else
      defaultPanel = WarAlliance_menuUI.Tag.CREATE
      self.apply_tab:SetActive(false)
    end
    self.WarAllianceTab:SetActive(false)
    NetManager.Send(UnionMessage.ReqUnionList)
  end
  local args = self.args
  if args ~= nil then
    defaultPanel = args.openSecondTab
  end
  EventManager.Dispatch(Event.WarAlliance_SelectMenu, defaultPanel)
end

function WarAlliance_menuUI:RefreshApplyOrCreate()
  if WarAllianceData.IsHaveUnion then
  else
    local data = WarAllianceData.WarAllianceDataList
    if data and 0 < #data then
      self.apply_tab:SetActive(true)
    else
      self.apply_tab:SetActive(false)
    end
    self.WarAllianceTab:SetActive(false)
  end
end

function WarAlliance_menuUI:UIRefresh()
  if SceneData.mapId == self.MapID then
    self.exitgarden_tab:SetActive(true)
  else
    self.exitgarden_tab:SetActive(false)
  end
end

function WarAlliance_menuUI:WarAlliance_Leave(_, data)
  WarAllianceData.RemoveArmband()
  UIManager.Hide(UIID.WarAlliance_menuUI)
end

function WarAlliance_menuUI:WarAllianceUIManager(UiID)
  if self:IsClickArmbandTag(UiID) then
    return
  end
  UIManager.Show(UiID, {resetLogic = 1})
end

function WarAlliance_menuUI:SelectMenu(id, key)
  local info = self.menuItemInfo[key]
  info.onClick(self)
end

function WarAlliance_menuUI:SetButtonPitchOn(key)
  local target = self.menuItemInfo[key]
  for k, info in pairs(self.menuItemInfo) do
    if k == key then
      info.btnNode:GetChild("img_clickeffect"):SetActive(true)
    else
      info.btnNode:GetChild("img_clickeffect"):SetActive(false)
    end
  end
end

function WarAlliance_menuUI:InitArmbandTagInfo()
  self.armbandMenu = {
    [WarAllianceBadgeTag.HP] = {
      group = 0,
      btnNode = self.Hp_tab,
      clickNode = self.hpimg_clickeffect,
      onClick = self.Hp_tblOnClick
    },
    [WarAllianceBadgeTag.Attack] = {
      group = 1,
      btnNode = self.Atk_tab,
      clickNode = self.atkimg_clickeffect,
      onClick = self.Atk_tblOnClick
    },
    [WarAllianceBadgeTag.Defense] = {
      group = 2,
      btnNode = self.Def_tab,
      clickNode = self.defimg_clickeffect,
      onClick = self.Def_tblOnClick
    }
  }
end

function WarAlliance_menuUI:RegisteArmbandTagEvent()
  for key, info in pairs(self.armbandMenu) do
    info.btnNode:SetOnClick(self, info.onClick)
  end
end

function WarAlliance_menuUI:Hp_tblOnClick(control)
  if self ~= nil then
    self:DoForByType(WarAllianceBadgeTag.HP)
  end
end

function WarAlliance_menuUI:Atk_tblOnClick(control)
  if self ~= nil then
    self:DoForByType(WarAllianceBadgeTag.Attack)
  end
end

function WarAlliance_menuUI:Def_tblOnClick(control)
  if self ~= nil then
    self:DoForByType(WarAllianceBadgeTag.Defense)
  end
end

function WarAlliance_menuUI:DoForByType(type)
  if self.curArmbandPageIndex ~= type then
    if self.curArmbandPageIndex ~= nil then
      local lastMenuItem = self.armbandMenu[self.curArmbandPageIndex]
      if lastMenuItem then
        lastMenuItem.clickNode:SetActive(false)
      end
    end
    local curMenuItem = self.armbandMenu[type]
    if curMenuItem then
      curMenuItem.clickNode:SetActive(true)
    end
  end
  if not UIManager.IsVisible(UIID.WarAlliance_Armband) then
    UIManager.Show(UIID.WarAlliance_Armband, {resetLogic = 1, type = type})
  elseif self.curArmbandPageIndex ~= type then
    local ui = UIManager.GetUiByName(UIID.WarAlliance_Armband)
    if ui then
      ui:SelectType(type)
    end
  end
  self.curArmbandPageIndex = type
end

function WarAlliance_menuUI:IsClickArmbandTag(UiID)
  local isArmband = UiID == UIID.WarAlliance_Armband
  if self.WarAlliance_SecTab.gameObject.activeSelf ~= isArmband then
    self.WarAlliance_SecTab:SetActive(isArmband)
  end
  return isArmband
end
