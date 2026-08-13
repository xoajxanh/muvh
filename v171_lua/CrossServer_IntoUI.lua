CrossServer_IntoUI = class(BaseUI)
CrossServer_IntoUI.layer = UILayer.Panel
CrossServer_IntoUI.orderInLayer = 0
CrossServer_IntoUI.hideType = UIHideType.WaitDestroy
CrossServer_IntoUI.hideFunc = UIHideFunc.MoveOutOfScreen
CrossServer_IntoUI.escClose = UIEscClose.DontClose

function CrossServer_IntoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_Bg/bg/btn_close")
  self.btn_close1 = self:GetControl("img_Bg/go_desc/btn_close")
  self.go_desc = self:GetControl("img_Bg/go_desc")
  self.go_main = self:GetControl("img_Bg/go_main")
  self.img_redPoint = self:GetControl("img_Bg/go_main/btn_goCs/img_redPoint")
  self.sw_paneltab = self:GetControl("img_Bg/go_main/sw_paneltab")
  self.btn_avtivy1 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy1")
  self.btn_avtivy4 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy4")
  self.btn_avtivy5 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy5")
  self.btn_avtivy2 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy2")
  self.btn_avtivy6 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy6")
  self.btn_avtivy8 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy8")
  self.btn_avtivy9 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy9")
  self.panel_GodCross = self:GetControl("img_Bg/go_main/panel_GodCross")
  self.btn_goCs = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodOn/btn_goCs")
  self.go_GodOn = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodOn")
  self.tips = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodOn/btn_goCs/tips")
  self.go_GodCome = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome")
  self.descBtnGodCome = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/descBtnGodCome")
  self.Crosstext_tim = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/ShowMain/Activity_time/Crosstext_tim")
  self.Crosstext_date = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/ShowMain/Activity_date/Crosstext_date")
  self.btn_3DItem = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/ShowMain/content/btn_3DItem")
  self.descBtn = self:GetControl("descBtn")
  self.grid_type = self:GetControl("img_Bg/go_desc/grid_type")
  self.ForecastBtn = self:GetControl("img_Bg/go_desc/grid_type/Viewport/Content/ForecastBtn")
  self.PlayPreviewpanel = self:GetControl("img_Bg/go_desc/PlayPreviewpanel")
  self.DesContent = self:GetControl("img_Bg/go_desc/PlayPreviewpanel/Des/Viewport/DesContent")
  self.Lab_Title = self:GetControl("img_Bg/go_desc/PlayPreviewpanel/Des/Viewport/DesContent/Lab_Title")
  self.lab_Content = self:GetControl("img_Bg/go_desc/PlayPreviewpanel/Des/Viewport/DesContent/Lab_Title/lab_Content")
  self.suitContainer = self:GetControl("img_Bg/go_desc/PlayPreviewpanel/Des/Viewport/DesContent/suitContainer")
  self.btn_goTT = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_one/btn_goTT")
  self.btn_goDY = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_two/btn_goDY")
  self.btn_goRJ = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_three/btn_goRJ")
  self.btn_goHD = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_four/btn_goHD")
  self.img_headTT = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_one/img_headTT")
  self.img_headDY = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_two/img_headDY")
  self.img_headRJ = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_three/img_headRJ")
  self.img_headHD = self:GetControl("img_Bg/go_main/panel_GodCross/go_GodCome/go_bossList/img_four/img_headHD")
  self.panel_NewCross = self:GetControl("img_Bg/go_main/panel_NewCross")
  self.panel_KaLunTeCross = self:GetControl("img_Bg/go_main/panel_KaLunTeCross")
  self.panel_KunShouCross = self:GetControl("img_Bg/go_main/panel_KunShouCross")
  self.panel_fightCross = self:GetControl("img_Bg/go_main/panel_fightCross")
  self.panel_DuoQiCross = self:GetControl("img_Bg/go_main/panel_DuoQiCross")
  self.descBtnNewJH = self:GetControl("img_Bg/go_main/panel_NewCross/go_JingHe/descBtnNewJH")
  self.descBtnNewFM = self:GetControl("img_Bg/go_main/panel_NewCross/go_Enchant/descBtnNewFM")
  self.btn_Activity7 = self:GetControl("img_Bg/go_main/sw_paneltab/Viewport/panel_tab/btn_avtivy7")
  self.panel_ShiKongCross = self:GetControl("img_Bg/go_main/panel_ShiKongCross")
  self.panel_ZhengBaCross = self:GetControl("img_Bg/go_main/panel_ZhengBaCross")
  self.panel_SiFangCross = self:GetControl("img_Bg/go_main/panel_SiFangCross")
end

function CrossServer_IntoUI:OnPreLoad()
end

function CrossServer_IntoUI:Init()
end

function CrossServer_IntoUI:OnCreate()
  self.root:SetSortingOrder(200)
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function CrossServer_IntoUI:InitUI()
  self:InitData()
  self.panel_KaLunTeCrossgomain = luaTemplateManager.GetNewTemplate(self.panel_KaLunTeCross, LuaComponentTemplates.panel_KaLunTeCrossgomainTemplate, self)
  self.panel_KunShouCrossgomain = luaTemplateManager.GetNewTemplate(self.panel_KunShouCross, LuaComponentTemplates.panel_KunShouCrossTemplate, self)
  self.panel_PreviewTemplate = luaTemplateManager.GetNewTemplate(self.panel_NewCross, LuaComponentTemplates.CrossServer_PreviewTemplate, self)
  self.panel_ThreeVsThreeCrossgomain = luaTemplateManager.GetNewTemplate(self.panel_fightCross, LuaComponentTemplates.panel_ThreeVsThreeCrossTemplate, self)
  self.panel_DuoQiCrossgomain = luaTemplateManager.GetNewTemplate(self.panel_DuoQiCross, LuaComponentTemplates.panel_DuoQiCrossTemplate, self)
  self.SpaceCrackActivityTemplate = luaTemplateManager.GetNewTemplate(self.panel_ShiKongCross, LuaComponentTemplates.SpaceCrackActivityTemplate, self)
  self.panel_ZhengBaTemplate = luaTemplateManager.GetNewTemplate(self.panel_ZhengBaCross, LuaComponentTemplates.panel_ZhengBaTemplate, self)
  self.panel_SiFangCrossgomain = luaTemplateManager.GetNewTemplate(self.panel_SiFangCross, LuaComponentTemplates.panel_SiFangCrossTemplate, self)
  self.panelTemplates = {}
  self.panelTemplates[CrossServerTabType.Preview] = self.panel_PreviewTemplate
  self.panelTemplates[CrossServerTabType.Kalunte] = self.panel_KaLunTeCrossgomain
  self.panelTemplates[CrossServerTabType.Kunshou] = self.panel_KunShouCrossgomain
end

function CrossServer_IntoUI.Onlab_TitleCreat(ctr)
  ctr.lab_Content = UIControl(ctr.transform, "lab_Content")
end

function CrossServer_IntoUI.OnForeCreat(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.img_clickeffect = UIControl(ctr.transform, "img_clickeffect")
  ctr.img_redPoint = UIControl(ctr.transform, "img_redPoint")
end

function CrossServer_IntoUI.OnPlayMethodRefresh(ctr, _, data, ui)
  ctr.index = _
  if data ~= nil and data.Name ~= nil then
    ctr.lab_name:SetText(data.Name)
  end
  local bool = false
  if CrossServer_IntoUI.FirstOpen ~= 0 then
    bool = true
  end
  ctr.img_redPoint:SetActive(bool)
  ctr.img_clickeffect:SetActive(false)
  ctr:SetOnClick(CrossServer_IntoUI, CrossServer_IntoUI.OnClickFore)
end

function CrossServer_IntoUI:OnClickFore(ctr)
  self.lastForeBtn = self.curForeBtn
  self.curForeBtn = ctr.index
  self:UpdatePlayMethodInfo()
end

function CrossServer_IntoUI:OnShow()
  QuickFind:GetSpaceCrackDataManager():OnEnterGame()
  self.root.canvas.overrideSorting = false
  self:RegistEvents()
  self:Refresh()
  if self.agrs and self.agrs.index then
    self.curActivity = self.agrs.index
  end
  if self.agrs and self.agrs.subindex then
    self.curForeBtn = self.agrs.subindex
  end
  if self.args and self.args.isRefreshSportTeam3V3Template then
    self.isRefreshSportTeam3V3Template = self.args.isRefreshSportTeam3V3Template
    self.args.isRefreshSportTeam3V3Template = nil
  end
  local tabType
  if self.args and self.args.openFirstTab and self.mainTogs[self.args.openFirstTab] ~= nil then
    tabType = self.args.openFirstTab
    self.args.openFirstTab = nil
  else
    tabType = CrossServerTabType.Preview
  end
  if QuickFind:GetThreeVsThreeDataMgr() and QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    tabType = CrossServerTabType.ThreeVsThree
    if QuickFind:GetThreeVsThreeDataMgr():GetMatchPeopleType() == 1 then
      self.isRefreshSportTeam3V3Template = false
    elseif QuickFind:GetThreeVsThreeDataMgr():GetMatchPeopleType() == 2 then
      self.isRefreshSportTeam3V3Template = true
    end
  end
  if self.mainTogs[tabType]:GetIsOn() then
    self.curType = tabType
    self:RefreshPanel()
  else
    self.mainTogs[tabType]:SetIsOn(true)
  end
  self.descBtn:SetActive(false)
  self:InitMainTogs()
end

function CrossServer_IntoUI:InitArgs()
  self.FirstOpen = 1
  if PlayerPrefs.HasKey("CrossServer_IntoUIFirstOpen") then
    self.FirstOpen = PlayerPrefs.GetInt("CrossServer_IntoUIFirstOpen")
  end
  self.ActivityEnum = {
    Activity1 = enum(1),
    Activity2 = enum(),
    Activity3 = enum(),
    Activity4 = enum(4),
    Activity5 = enum(),
    Activity6 = enum(),
    Activity8 = enum()
  }
  self.ActivityDatas = {}
  local TogTble = SystemForecastData.AllGetInfo()
  local ActivityData1 = {}
  for i, v in pairs(TogTble) do
    if v.uType == "1" then
      table.insert(ActivityData1, v)
    end
  end
  table.insert(self.ActivityDatas, ActivityData1)
  self.Activitys = {
    [self.ActivityEnum.Activity1] = self.btn_avtivy1,
    [self.ActivityEnum.Activity4] = self.btn_avtivy4,
    [self.ActivityEnum.Activity5] = self.btn_avtivy5,
    [self.ActivityEnum.Activity6] = self.btn_avtivy6
  }
  self.subActivitys = {
    [self.ActivityEnum.Activity1] = self.btn_activeList,
    [self.ActivityEnum.Activity2] = self.btn_activeList1
  }
  self.curActivity = self.ActivityEnum.Activity1
  self.curSubActivity = self.ActivityEnum.Activity1
  self.curForeBtn = 1
  self.lastForeBtn = 0
end

function CrossServer_IntoUI:InitFriendChatDisplay()
  self.btn_avtivy1.type = self.ActivityEnum.Activity1
  local displayTab = {
    [self.ActivityEnum.Activity1] = self.btn_goCs
  }
  self.ActivityDisplay = setmetatable(displayTab, {
    __call = function(t, displayType)
      self:DisplayUIByName(t, displayType)
    end
  })
  self.btn_activeList.type = self.ActivityEnum.Activity1
  self.btn_activeList1.type = self.ActivityEnum.Activity2
  local displayTab1 = {
    [self.ActivityEnum.Activity1] = self.go_GodOn,
    [self.ActivityEnum.Activity2] = self.go_GodCome
  }
  self.subActivityDisplay = setmetatable(displayTab1, {
    __call = function(t, displayType)
      self:DisplayUIByName(t, displayType)
    end
  })
  local displayTab2 = {
    [self.ActivityEnum.Activity1] = self.btn_activeList,
    [self.ActivityEnum.Activity2] = self.btn_activeList1
  }
  self.subActivityDisplayCheckmark = setmetatable(displayTab2, {
    __call = function(t, displayType)
      self:DisplayUIByName1(t, displayType)
    end
  })
end

function CrossServer_IntoUI:DisplayUIByName1(displayTab, displayType)
  if displayTab ~= nil then
    for k, v in pairs(displayTab) do
      local bool = k == displayType
      local s = UIControl(v.transform, "Background/Checkmark")
      s.gameObject:SetActive(bool)
    end
  end
end

function CrossServer_IntoUI:DisplayUIByName(displayTab, displayType)
  if displayTab ~= nil then
    for k, v in pairs(displayTab) do
      v:SetActive(k == displayType)
    end
  end
end

function CrossServer_IntoUI:Update()
  if self.SpaceCrackActivityTemplate == nil or self.curType ~= CrossServerTabType.SpaceCrack then
    return
  end
  self.SpaceCrackActivityTemplate:Update()
end

function CrossServer_IntoUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_goCs:SetOnClick(self, self.btn_goCsOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close1:SetOnClick(self, self.HideActivity)
  self.btn_goTT.global = 110002
  self.btn_goTT:SetOnClick(self, self.btn_goOnClick)
  self.btn_goDY.global = 110003
  self.btn_goDY:SetOnClick(self, self.btn_goOnClick)
  self.btn_goRJ.global = 110004
  self.btn_goRJ:SetOnClick(self, self.btn_goOnClick)
  self.btn_goHD.global = 110005
  self.btn_goHD:SetOnClick(self, self.btn_goOnClick)
  self.descBtnGodCome:SetOnClick(self, self.descBtnGodComeOnClick)
  self.descBtnNewJH:SetOnClick(self, self.descBtnNewJHOnClick)
  self.descBtnNewFM:SetOnClick(self, self.descBtnNewFMOnClick)
  for i, tog in pairs(self.mainTogs) do
    tog:SetOnToggleChanged(self, self.ToggleCallBack)
  end
end

function CrossServer_IntoUI:ShowActivity(ctrl)
  self.curSubActivity = ctrl.type
  self.subActivityDisplay(ctrl.type)
  self:Refresh()
end

function CrossServer_IntoUI:HideActivity()
  self.go_main:SetActive(true)
  self.go_desc:SetActive(false)
  self.descBtn:SetActive(true)
end

function CrossServer_IntoUI:btn_closeOnClick(control)
  if QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "Khi b\225\186\175t \196\145\225\186\167u gh\195\169p \196\145\225\187\153i, s\225\186\189 duy tr\195\172 ch\225\186\191 \196\145\225\187\153 3V3. Nh\198\176ng trong kho\225\186\163ng th\225\187\157i gian n\195\160y, b\225\186\161n s\225\186\189 kh\195\180ng th\225\187\131 tham gia b\225\187\153 ph\225\186\173n s\225\187\177 ki\225\187\135n kh\195\161c. N\225\186\191u b\225\186\161n mu\225\187\145n tho\195\161t kh\225\187\143i gh\195\169p \196\145\225\187\153i, vui l\195\178ng ch\225\187\141n \"Tho\195\161t\".",
      cancelText = "Thu nh\225\187\143",
      okText = "Tho\195\161t",
      cancel = function()
        UIManager.Hide(UIID.PromptTipUI)
        UIManager.Hide(UIID.CrossServer_IntoUI)
        local matchState = QuickFind:GetThreeVsThreeDataMgr():GetMatchState()
        EventManager.Dispatch(Event.ThreeVSThreeMatchingMinimize, {
          state = matchState == 1
        })
      end,
      ok = function()
        UIManager.Hide(UIID.PromptTipUI)
        networkRequest.ReqCancelMatchThreeVThree(1)
        QuickFind:GetThreeVsThreeDataMgr():SetMatchPeopleType(0)
        QuickFind:GetThreeVsThreeDataMgr():SetIsNeedAfterCancelMatchReqExitTeam(true)
        EventManager.Dispatch(Event.ThreeVSThreeMatchingMinimize, {state = false})
        UIManager.Hide(UIID.CrossServer_IntoUI)
      end
    })
  else
    if QuickFind:GetThreeVsThreeDataMgr():GetIsHaveTeam() then
      networkRequest.ReqExitThreeVThreeTeam(1)
    end
    UIManager.Hide(UIID.CrossServer_IntoUI)
  end
end

function CrossServer_IntoUI:btn_goDescOnClick(control)
end

function CrossServer_IntoUI:descBtnGodComeOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "CrossServer_IntoUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function CrossServer_IntoUI:descBtnNewJHOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "iconName", "descBtnNewJH")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function CrossServer_IntoUI:descBtnNewFMOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "iconName", "descBtnNewFM")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function CrossServer_IntoUI:btn_goOnClick(control)
  if control == nil then
    return
  end
  local ActivityTTData = ClientTable.cfg_Activity_globalManager:TryGetValue(control.global, "id")
  local rewardTTStr = ActivityTTData.effect
  rewardTTStr = string.split(rewardTTStr, "#")
  local transferTTId = tonumber(rewardTTStr[2])
  local cfgTblTT = ConfigManager.FindConfigs("cfg_Map_transfer", "id", transferTTId)[1]
  if ConditionManager.Check4D(cfgTblTT.condition) then
    local mapData = {mapId = transferTTId}
    EventManager.Dispatch(Event.Map_ChangeMap, mapData)
    UIManager.Hide(UIID.CrossServer_IntoUI)
    self.go_desc:SetActive(false)
  else
    FloatingTipUtility.QuickMsg("Kh\195\180ng \196\145\225\186\161t \196\145i\225\187\129u ki\225\187\135n v\195\160o")
  end
end

function CrossServer_IntoUI:btn_goCsOnClick(control)
  local cfgTbl = ConfigManager.FindConfigs("cfg_Global_global", "id", 11110001)[1]
  if cfgTbl ~= nil and ConditionManager.Check4D(cfgTbl.effect) then
    if not SceneData.IsCrossRealm() then
      local mapData = {mapId = 109101}
      ServerDataRecordData.SendSaveData({
        dataInt = {
          [SerRecordIntType.joined] = 1
        }
      })
      EventManager.Dispatch(Event.Map_ChangeMap, mapData)
      EventManager.Dispatch(Event.RP_RedPointRefresh, {
        index = ERedPointType.btnFunc,
        state = true
      })
      UIManager.Hide(UIID.CrossServer_IntoUI)
    else
      local tip = ConfigManager.FindConfigs("cfg_Ui_word", "id", "kuafu_02")
      if tip ~= nil then
        FloatingTipUtility.QuickMsg(tip[1].content ~= nil and tip[1].content or "")
      end
    end
  else
    local tip = ConfigManager.FindConfigs("cfg_Ui_word", "id", "kuafu_01")
    if tip ~= nil then
      FloatingTipUtility.QuickMsg(tip[1].content ~= nil and tip[1].content or "")
    end
  end
end

function CrossServer_IntoUI:descBtnOnClick(control)
  self.go_desc:SetActive(true)
  self.go_main:SetActive(false)
  self.descBtn:SetActive(false)
  self.PlayMethodBtn:SetData(self.ActivityDatas[self.curActivity])
  self:UpdatePlayMethodInfo()
end

function CrossServer_IntoUI:UpdatePlayMethodInfo()
  local item = self.PlayMethodBtn:GetOrCreateItem(self.curForeBtn)
  if self.lastForeBtn ~= 0 then
    local item1 = self.PlayMethodBtn:GetOrCreateItem(self.lastForeBtn)
    item1.img_clickeffect:SetActive(false)
  end
  item.img_clickeffect:SetActive(true)
  CrossServer_IntoUI:ShowDescribe(self.ActivityDatas[self.curActivity][self.curForeBtn].content)
end

function CrossServer_IntoUI:RegistEvents()
  self:RegistEvent(Event.Rank_CrossServerKalunte, self.CrossServerKalunteRefshTime, self)
  self:RegistEvent(Event.CrossServerPreviewTabStateChange, self.CrossServerPreviewTabStateChange, self)
  self:RegistEvent(Event.CrossServer_IntoUIClose, self.CrossServer_IntoUIClose, self)
  self:RegistEvent(Event.RankKunShouPlayModel, self.RankKunShouPlayModel, self)
  self:RegistEvent(Event.RefreshThreeVThreePlaneInfo, self.RefreshThreeVsThreeCrossPanel, self)
  self:RegistEvent(Event.ThreeVThreeMatchSuccessTransferToMap, self.ThreeVsThreeMatchSuccessCallBack, self)
  self:RegistEvent(Event.RefreshUnionStrColor, self.RefreshDuoQiCrossGomainPanel, self)
  self:RegistEvent(Event.UnionMyLvChangeRefreshUI, self.RefreshDuoQiCrossGomainPanel, self)
  self:RegistEvent(Event.ResSpaceCrackActivity, self.ResSpaceCrackActivity, self)
  self:RegistEvent(Event.RefreshSpaceCrackActivityRank, self.RefreshSpaceCrackActivityRank, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChange, self)
  self:RegistEvent(Event.RefreshDuoQiZhangBaUI, self.RefreshDuoQiZhangBa, self)
  self:RegistEvent(Event.RefreshSiFangZhengBaUI, self.RefreshSiFangZhengBa, self)
end

function CrossServer_IntoUI:ThreeVsThreeMatchSuccessCallBack(_, data)
  UIManager.Hide(UIID.CrossServer_IntoUI)
  UIManager.Hide(UIID.PromptTipUI)
  self.isFromMinimizeWindowsOpen3V3 = nil
  UIManager.Show(UIID.Tip_3V3Begin, {Data = data})
end

function CrossServer_IntoUI:RankKunShouPlayModel(ctr)
  self.panel_KunShouCrossgomain:RefreshLeader()
end

function CrossServer_IntoUI:CrossServerKalunteRefshTime(ctr)
  self.panel_KaLunTeCrossgomain:RefreshLeader()
end

function CrossServer_IntoUI:CrossServerPreviewTabStateChange(id, msg)
  self.panel_PreviewTemplate:RefreshPlane(msg.funcId, msg.state)
end

function CrossServer_IntoUI:CrossServer_IntoUIClose(id)
  self:btn_closeOnClick()
end

function CrossServer_IntoUI:ShowActivityUI(ctr)
  self.ActivityDisplay(ctr.type)
  self:ShowPlayMethod(ctr.type)
end

function CrossServer_IntoUI:Refresh()
end

function CrossServer_IntoUI:ShowPlayMethod(type)
  local cfgTbl = ConfigManager.FindConfigs("cfg_Global_global", "id", 11110001)[1]
  if cfgTbl ~= nil and ConditionManager.Check4D(cfgTbl.effect) then
    ServerDataRecordData.SendSaveData({
      dataInt = {
        [SerRecordIntType.joined] = 1
      }
    })
  end
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  if type == self.ActivityEnum.Activity1 then
    if self.curSubActivity == self.ActivityEnum.Activity1 then
      local strs = {}
      local str = ""
      local tips = self.ActivityDatas[self.curActivity][self.curForeBtn]
      local cfgTbl = ConfigManager.FindConfigs("cfg_Global_global", "id", 11110002)[1]
      local color = ItemQuality2ColorDic[EItemColorEnum.red]
      local color1 = ItemQuality2ColorDic[EItemColorEnum.red]
      if tips ~= nil and cfgTbl ~= nil then
        strs = string.split(tips.txtCod, "#")
        local cfgTbl1 = string.split(cfgTbl.effect, "-")
        if cfgTbl1[1] ~= nil and ConditionManager.Check4D(cfgTbl1[1]) then
          color1 = ItemQuality2ColorDic[EItemColorEnum.green]
        end
        if cfgTbl1[2] ~= nil and ConditionManager.Check4D(cfgTbl1[2]) then
          color = ItemQuality2ColorDic[EItemColorEnum.green]
        end
        if strs[1] and strs[2] then
          str = string.GetColorText(strs[1], color1)
          str = str .. string.GetColorText(strs[2], color)
        end
        self.tips:SetText(str)
      end
    elseif self.curSubActivity == self.ActivityEnum.Activity2 then
      self:IsAllGodsCondition()
      local TTData = ClientTable.cfg_Activity_globalManager:TryGetValue(110002, "id")
      local rewardTTStr = TTData.effect
      rewardTTStr = string.split(rewardTTStr, "#")
      local monsterTTID = tonumber(rewardTTStr[1])
      local monsterTTData = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterTTID, "id")
      self:SetSprite("Atlas_headPortrait", monsterTTData.head, self.img_headTT)
      local DYData = ClientTable.cfg_Activity_globalManager:TryGetValue(110003, "id")
      local rewardDYStr = DYData.effect
      rewardDYStr = string.split(rewardDYStr, "#")
      local monsterDYID = tonumber(rewardDYStr[1])
      local monsterDYData = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterDYID, "id")
      self:SetSprite("Atlas_headPortrait", monsterDYData.head, self.img_headDY)
      local RJData = ClientTable.cfg_Activity_globalManager:TryGetValue(110004, "id")
      local rewardRJStr = RJData.effect
      rewardRJStr = string.split(rewardRJStr, "#")
      local monsterRJID = tonumber(rewardRJStr[1])
      local monsterRJData = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterRJID, "id")
      self:SetSprite("Atlas_headPortrait", monsterRJData.head, self.img_headRJ)
      local HDData = ClientTable.cfg_Activity_globalManager:TryGetValue(110005, "id")
      local rewardHDStr = HDData.effect
      rewardHDStr = string.split(rewardHDStr, "#")
      local monsterHDID = tonumber(rewardHDStr[1])
      local monsterHDData = ClientTable.cfg_Monster_monsterManager:TryGetValue(monsterHDID, "id")
      self:SetSprite("Atlas_headPortrait", monsterHDData.head, self.img_headHD)
      local ActivityData = ClientTable.cfg_Activity_indexManager:TryGetValue(4001, "activityId")
      local rewardData = {}
      local rewardStr = ActivityData.showReward
      rewardStr = string.split(rewardStr, "#")
      for i = 1, #rewardStr do
        rewardData[i] = {
          itemId = tonumber(rewardStr[i])
        }
      end
      self.ActivityItemTemp:SetData(rewardData)
    end
  end
end

function CrossServer_IntoUI:OnHide()
  self.go_desc.gameObject:SetActive(false)
  self.go_main.gameObject:SetActive(true)
  self.descBtn.gameObject:SetActive(false)
  self.panel_PreviewTemplate:Exit()
  self.panel_KaLunTeCrossgomain:SrossServerRankDestory()
  self.panel_KunShouCrossgomain:RankDestory()
  self.isRefreshSportTeam3V3Template = nil
  self.sw_paneltab.scrollRect.normalizedPosition = Vector2(0, 0)
end

function CrossServer_IntoUI:OnDestroy()
end

function CrossServer_IntoUI:IsAllGodsCondition()
  local allAodsActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(4001, "activityId")
  local isOpen = ConditionManager.Check4D(allAodsActivityCond.enterCondition)
  local isOpenBtn = ConditionManager.Check4D(allAodsActivityCond.condition)
  if isOpen and isOpenBtn then
    self.btn_goTT:SetActive(true)
    self.btn_goDY:SetActive(true)
    self.btn_goRJ:SetActive(true)
    self.btn_goHD:SetActive(true)
  else
    self.btn_goTT:SetActive(false)
    self.btn_goDY:SetActive(false)
    self.btn_goRJ:SetActive(false)
    self.btn_goHD:SetActive(false)
  end
end

local function DetailUICtr(ctr)
end

local function DetailUIRefresh(ctr, _, data, ui)
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(data)
  if content ~= nil then
    ctr:SetText(content)
  end
end

function CrossServer_IntoUI:ShowDescribe(des)
  local TitleGrop = string.split(des, "&")
  local ShowDes = {}
  for i, v in pairs(TitleGrop) do
    local Describe = string.split(v, "#")
    local Title = Describe[1]
    local DesGrop = string.split(Describe[2], "/")
    ShowDes[i] = {}
    ShowDes[i].Title = Title
    ShowDes[i].DesGrop = DesGrop
  end
  for i, v in pairs(self.lab_TitleContainer.items) do
    v:SetActive(false)
    if v.suitContainer then
      v.suitContainer:SetActive(false)
    end
  end
  for i, v in pairs(ShowDes) do
    local obj = self.lab_TitleContainer:GetOrCreateItem(i)
    local Title = ClientTable.cfg_Ui_wordManager:TryGetValue(v.Title).content
    obj.lab_Content:SetText(Title)
    local mTextGenerator = obj.lab_Content.text.cachedTextGeneratorForLayout
    local mTgSettings = obj.lab_Content.text:GetGenerationSettings(Vector2(0, 0))
    local txtwith = mTextGenerator:GetPreferredWidth(Title, mTgSettings) / obj.lab_Content.text.pixelsPerUnit
    obj:SetSizeDelta(txtwith * 1.5, 45)
    if not obj.suitContainer then
      local item
      local go = self.suitContainer:Instantiate(self.DesContent.transform, self.DesContent)
      go.name = self.suitContainer.gameObject.name
      item = UIControl()
      item.transform = go.transform
      item:SetActive(true)
      obj.suitContainer = item
      if not obj.DetailUIContainer then
        local lab_TipSuitAdditional = obj.suitContainer:GetChild("lab_TipSuitAdditional")
        obj.DetailUIContainer = UIContainer(lab_TipSuitAdditional, self, DetailUICtr, DetailUIRefresh)
      end
    else
      obj.suitContainer:SetActive(true)
    end
    obj.DetailUIContainer:SetData(v.DesGrop)
    obj:SetActive(true)
  end
end

local function OnItemRewardCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnItemRewardRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function CrossServer_IntoUI:InitCrossCtr()
  local ActData = ClientTable.cfg_Activity_indexManager:TryGetValue(4001, "activityId")
  self.Crosstext_tim:SetText(ActData.showTime)
  self.Crosstext_date:SetText(ActData.showLevel)
  self.ActivityItemTemp = UIContainer(self.btn_3DItem, self, OnItemRewardCreate, OnItemRewardRefresh)
  self.activityReward = {}
end

function CrossServer_IntoUI:InitData()
  self.mainTogs = {
    [CrossServerTabType.Preview] = self.btn_avtivy1,
    [CrossServerTabType.Kalunte] = self.btn_avtivy4,
    [CrossServerTabType.Kunshou] = self.btn_avtivy5,
    [CrossServerTabType.ThreeVsThree] = self.btn_avtivy2,
    [CrossServerTabType.DuoQiCross] = self.btn_avtivy6,
    [CrossServerTabType.SpaceCrack] = self.btn_Activity7,
    [CrossServerTabType.DuoQiZhengBa] = self.btn_avtivy8,
    [CrossServerTabType.SiFangZhengBa] = self.btn_avtivy9
  }
  for tabType, tog in pairs(self.mainTogs) do
    tog.tabType = tabType
  end
end

function CrossServer_IntoUI:InitMainTogs()
  for tabType, tog in pairs(self.mainTogs) do
    local tbl = ClientTable.cfg_Function_functionManager:TryGetValue(tabType)
    local isOpen = false
    if tbl and tbl.condition then
      isOpen = ConditionManager.Check4D(tbl.condition)
    end
    tog:SetActive(isOpen)
    tog:SetIsOn(false)
  end
end

function CrossServer_IntoUI:ToggleCallBack(control)
  if self.panel_fightCross:GetActive() == true and QuickFind:GetThreeVsThreeDataMgr():GetMatchState() == 1 then
    if self.mainTogs[CrossServerTabType.ThreeVsThree]:GetIsOn() == false then
      FloatingTipUtility.QuickMsg("\196\144ang gh\195\169p tr\225\186\173n kh\195\180ng th\225\187\131 th\225\187\177c hi\225\187\135n thao t\195\161c n\195\160y, h\195\163y h\225\187\167y Gh\195\169p Tr\225\186\173n tr\198\176\225\187\155c")
      self.mainTogs[CrossServerTabType.ThreeVsThree]:SetIsOn(true)
    end
    return
  end
  if control:GetIsOn() and self.curType ~= control.tabType then
    self.curType = control.tabType
    self:RefreshPanel()
  end
end

function CrossServer_IntoUI:RefreshPanel()
  self.panel_KaLunTeCrossgomain:SrossServerRankDestory()
  self.panel_KunShouCrossgomain:RankDestory()
  self.panel_PreviewTemplate:Exit()
  self.panel_ThreeVsThreeCrossgomain:Exit()
  self.panel_DuoQiCrossgomain:Exit()
  self.SpaceCrackActivityTemplate:Exit()
  self.panel_ZhengBaTemplate:Exit()
  self.panel_SiFangCrossgomain:Exit()
  if self.curType == CrossServerTabType.Preview then
    self.panel_PreviewTemplate:Refresh()
  elseif self.curType == CrossServerTabType.Kalunte then
    self.panel_KaLunTeCrossgomain:Refresh()
    self.panel_KaLunTeCrossgomain:CrossServerRank()
  elseif self.curType == CrossServerTabType.Kunshou then
    self.panel_KunShouCrossgomain:Refresh()
  elseif self.curType == CrossServerTabType.ThreeVsThree then
    networkRequest.ReqThreeVThreePlaneInfo(1)
  elseif self.curType == CrossServerTabType.DuoQiCross then
    self.panel_DuoQiCrossgomain:Refresh()
  elseif self.curType == CrossServerTabType.SpaceCrack then
    self.SpaceCrackActivityTemplate:RefreshPanel()
  elseif self.curType == CrossServerTabType.DuoQiZhengBa then
    self.panel_ZhengBaTemplate:SendUnionKuaFuSystemInstanceInfo()
  elseif self.curType == CrossServerTabType.SiFangZhengBa then
    self.panel_SiFangCrossgomain:RefreshPanel()
  end
end

function CrossServer_IntoUI:RefreshThreeVsThreeCrossPanel()
  if self.curType and self.curType == CrossServerTabType.ThreeVsThree then
    self.panel_ThreeVsThreeCrossgomain:Refresh()
    if self.isRefreshSportTeam3V3Template then
      self.panel_ThreeVsThreeCrossgomain:RefreshSportTeam3V3Template()
      self.isRefreshSportTeam3V3Template = nil
    else
      self.panel_ThreeVsThreeCrossgomain:RefreshSportMatch3V3Template()
    end
  end
end

function CrossServer_IntoUI:RefreshDuoQiCrossGomainPanel()
  if self.curType and self.curType == CrossServerTabType.DuoQiCross then
    self.panel_DuoQiCrossgomain:Refresh()
  end
end

function CrossServer_IntoUI:ResSpaceCrackActivity()
  if self.SpaceCrackActivityTemplate == nil then
    return
  end
  if self.curType == CrossServerTabType.SpaceCrack then
    self.SpaceCrackActivityTemplate:Refresh()
  end
end

function CrossServer_IntoUI:RefreshSpaceCrackActivityRank()
  if self.SpaceCrackActivityTemplate == nil then
    return
  end
  if self.curType == CrossServerTabType.SpaceCrack then
    self.SpaceCrackActivityTemplate:Refresh()
  end
end

function CrossServer_IntoUI:Bag_ResBagChange()
  if self.curType == CrossServerTabType.SpaceCrack then
    if self.SpaceCrackActivityTemplate == nil then
      return
    end
    self.SpaceCrackActivityTemplate:Refresh()
  end
end

function CrossServer_IntoUI:RefreshDuoQiZhangBa()
  if self.curType == CrossServerTabType.DuoQiZhengBa then
    if self.panel_ZhengBaTemplate == nil then
      return
    end
    self.panel_ZhengBaTemplate:Refresh()
  end
end

function CrossServer_IntoUI:RefreshSiFangZhengBa()
  if self.curType == CrossServerTabType.SiFangZhengBa then
    if self.panel_SiFangCrossgomain == nil then
      return
    end
    self.panel_SiFangCrossgomain:Refresh()
  end
end
