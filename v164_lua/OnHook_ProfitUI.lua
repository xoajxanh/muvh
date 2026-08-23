OnHook_ProfitUI = class(BaseUI)
OnHook_ProfitUI.layer = UILayer.Panel
OnHook_ProfitUI.orderInLayer = 7
OnHook_ProfitUI.hideType = UIHideType.Hide
OnHook_ProfitUI.hideFunc = UIHideFunc.MoveOutOfScreen
OnHook_ProfitUI.escClose = UIEscClose.DontClose

function OnHook_ProfitUI:InitControls()
  self.btn_close = self:GetControl("bg/btn_close")
  self.tog_upgrade = self:GetControl("go_list/tog_upgrade")
  self.tog_badge = self:GetControl("go_list/tog_badge")
  self.onLinePointUI = self:GetControl("onLinePointUI")
  self.sv_mapList = self:GetControl("onLinePointUI/sv_mapList")
  self.mapItem = self:GetControl("onLinePointUI/sv_mapList/Viewport/Content/mapItem")
  self.sv_onLinePointGroup = self:GetControl("onLinePointUI/sv_onLinePointGroup")
  self.Content = self:GetControl("onLinePointUI/sv_onLinePointGroup/Viewport/Content")
  self.go_onLinePoint = self:GetControl("onLinePointUI/sv_onLinePointGroup/Viewport/Content/go_onLinePoint")
  self.hangUpSettings = self:GetControl("onLinePointUI/hangUpSettings")
  self.txt_killMonsterTime = self:GetControl("onLinePointUI/txt_killMonsterTime")
  self.txt_crossKillMonsterTime = self:GetControl("onLinePointUI/txt_crossKillMonsterTime")
  self.sv_pointList = self:GetControl("sv_pointList")
  self.btnBgClose = self:GetControl("sv_pointList/btnBgClose")
  self.btn_point = self:GetControl("sv_pointList/Viewport/Content/btn_point")
  self.img_profitBg = self:GetControl("img_profitBg")
  self.sw_profitExp = self:GetControl("img_profitBg/sw_profitExp")
  self.img_onlineProfit = self:GetControl("img_profitBg/sw_profitExp/Viewport/Content/img_onlineProfit")
  self.img_offlineProfit = self:GetControl("img_profitBg/sw_profitExp/Viewport/Content/img_offlineProfit")
  self.img_onlyOnlineProfit = self:GetControl("img_profitBg/img_onlyOnlineProfit")
  self.img_onlyOfflineProfit = self:GetControl("img_profitBg/img_onlyOfflineProfit")
  self.img_profitItemBg = self:GetControl("img_profitBg/img_profitItemBg")
  self.lab_profitItem = self:GetControl("img_profitBg/lab_profitItem")
  self.btn_3DItem = self:GetControl("img_profitBg/lab_profitItem/btn_3DItem")
  self.sw_profitItem = self:GetControl("img_profitBg/lab_profitItem/sw_profitItem")
  self.lab_kill = self:GetControl("img_profitBg/lab_kill")
  self.lab_isMonthCard = self:GetControl("img_profitBg/lab_isMonthCard")
  self.lab_noMonthCard = self:GetControl("img_profitBg/lab_noMonthCard")
  self.descBtn = self:GetControl("img_profitBg/descBtn")
  self.expTime = self:GetControl("img_profitBg/expNumber/txtTip1/expTime")
  self.onHookMonsterTime = self:GetControl("img_profitBg/expNumber/suitContainer/onHookMonsterTime")
  self.onHookMonsterExp = self:GetControl("img_profitBg/expNumber/suitContainer/onHookMonsterExp")
  self.onHookMonsterHolyRingPower = self:GetControl("img_profitBg/expNumber/suitContainer/onHookMonsterHolyRingPower")
  self.pointTime = self:GetControl("img_profitBg/expNumber/suitContainer/pointTime")
  self.pointExp = self:GetControl("img_profitBg/expNumber/suitContainer/pointExp")
  self.pointHolyRingPower = self:GetControl("img_profitBg/expNumber/suitContainer/pointHolyRingPower")
  self.expGet = self:GetControl("img_profitBg/sw_expGet/Viewport/expGet")
  self.getExp = self:GetControl("img_profitBg/sw_expGet/Viewport/expGet/getExp")
  self.lab_getCoinExp = self:GetControl("img_profitBg/sw_expGet/Viewport/expGet/getExp/getTip/lab_getCoinExp")
  self.lab_lackCoinExp = self:GetControl("img_profitBg/sw_expGet/Viewport/expGet/getExp/lab_lackCoinExp")
  self.btn_getCoinExp = self:GetControl("img_profitBg/sw_expGet/Viewport/expGet/getExp/btn_getCoinExp")
  self.btn_getCoin = self:GetControl("img_profitBg/sw_expGet/Viewport/expGet/getExp/btn_getCoin")
  self.lab_tempEvent = self:GetControl("img_profitBg/expLog/lab_tempEvent")
  self.lab_Event = self:GetControl("img_profitBg/expLog/expLogs/scroll_logs/Viewport/Content/lab_Event")
  self.btn_receive = self:GetControl("img_profitBg/btn_receive")
end

function OnHook_ProfitUI:OnPreLoad()
end

function OnHook_ProfitUI:Init()
  self.groupIdTab = {}
  self.groupName = {}
  self.pointPosX = 469
  self.maxPointPosY = -189
  self.minPointPosY = -622
  self.AddtionStr = {
    [1] = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("OnHookProfit_2"),
    [2] = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("OnHookProfit_3")
  }
  self.addBuffInfoTbl = OnHookData.ExpAddBufferInfoTbl()
  self.holyExpStr = "EXP Th\195\161nh L\225\187\177c"
end

function OnHook_ProfitUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnPointCreate(control)
end

local function OnPointRefresh(ctr, i, data, ui)
  local name = ctr:GetChild("goLineName")
  local str = string.replace(data.position, "#", ",")
  name:SetText(string.format("(%s)", str))
  ctr.data = data
  ctr:GetChild("index"):SetText(i)
  ctr:SetOnClick(ui, ui.Btn_PointOnClick)
end

function OnHook_ProfitUI:InitUI()
  self:InitContainer()
  self.lab_tempEventRect = self.lab_tempEvent.transform:GetComponent("RectTransform")
  self.pointPosContainer = UIContainer(self.btn_point, self, OnPointCreate, OnPointRefresh)
end

local function OnRefreshLogs(ctr, _, logData, ui)
  ui.lab_tempEvent:SetText(string.format("%s %s", TimeUtility.SwitchMonthStamp(logData.time), logData.log))
  UnityEngineUI.LayoutRebuilder.ForceRebuildLayoutImmediate(ui.lab_tempEventRect)
  ctr:SetText(string.format("%s %s", TimeUtility.SwitchMonthStamp(logData.time), logData.log))
  local textWidth, textHeight = ui.lab_tempEvent:GetSizeDelta()
  ctr:SetSizeDelta(textWidth, textHeight)
end

function OnHook_ProfitUI:InitContainer()
  self.logsTemp = UIContainer(self.lab_Event, self, nil, OnRefreshLogs)
  self.getExpContainer = UIUtility.BindUIContainerTemp(self.getExp, LuaComponentTemplates.OnHookGetExpTemplate)
end

function OnHook_ProfitUI:OnShow()
  self.tog_upgrade:SetIsOn(false)
  self:RegistEvents()
  self:Refresh()
end

function OnHook_ProfitUI:OnHide()
  self.tog_upgrade:SetIsOn(false)
  self.tog_badge:SetActive(true)
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {2390001})
  EventManager.Dispatch(Event.PopAutoPopUI)
end

function OnHook_ProfitUI:OnDestroy()
end

function OnHook_ProfitUI:RegistUIEvents()
  self.btn_receive:SetOnClick(self, self.btn_receiveOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.tog_badge:SetOnToggleChanged(self, self.OnToggleChanged)
  self.tog_upgrade:SetOnToggleChanged(self, self.OnToggleChanged)
  self.btn_close:SetOnClick(self, self.btn_CloseOnClick)
  self.hangUpSettings:SetOnClick(self, self.ShowOutLineUI)
  self.btnBgClose:SetOnClick(self, self.BtnBgClose)
end

function OnHook_ProfitUI:BtnBgClose(control)
  if self.sv_pointList:GetActive() then
    self.sv_pointList:SetActive(false)
    if self.btnGoLinePoint then
      self.btnGoLinePoint:GetChild("img_jianTou"):SetActive(false)
    end
  end
end

function OnHook_ProfitUI:descBtnOnClick(control)
  UIManager.Show(UIID.System_DescUI, {id = 1047})
end

function OnHook_ProfitUI:ShowOutLineUI(control)
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.PreferenceUI, {
    togName = "tog_KillMonster"
  })
end

function OnHook_ProfitUI:btn_CloseOnClick(control)
  UIManager.Hide(UIID.OnHook)
end

function OnHook_ProfitUI:btn_getMedicineExpOnClick(control)
  local medTime = ExpAddData.MultipleTime and ExpAddData.MultipleTime or 0
  local timer = math.floor(medTime / 60)
  if timer < OnHookData.buffExp.time then
    ItemUtility.ClickObtainItemBtn(_, control)
    FloatingTipUtility.QuickMsg("Thu\225\187\145c EXP kh\195\180ng \196\145\225\187\167")
    return
  end
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, {id = 3})
end

function OnHook_ProfitUI:btn_getCoinExpOnClick(control)
  local hookExpTbl = ClientTable.cfg_OnHook_OnLineManager:GetHookExpTblByLevel(OnHookExpType.OutLine, ViewData.meData.level)
  if hookExpTbl == nil then
    return
  end
  local ConfigCostItemId = hookExpTbl ~= nil and ClientTable.cfg_OnHook_OnLineManager:GetCostItemId(hookExpTbl.id)
  if not ConfigCostItemId then
    return
  end
  local ownGold = BagInfoData.GetItemTotalCountByItemId(ConfigCostItemId)
  if ownGold < OnHookData.money then
    ItemUtility.ClickObtainItemBtn(_, control)
    FloatingTipUtility.QuickMsg("Ti\225\187\129n kh\195\180ng \196\145\225\187\167")
    return
  end
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, {id = 2})
end

function OnHook_ProfitUI:btn_getExpOnClick(control)
  NetManager.Send(OnHookMessage.ReqGetOnHookReward, {id = 1})
end

function OnHook_ProfitUI:btn_receiveOnClick(control)
  NetManager.Send(OnHookMessage.ReqGetOnHookReward)
  UIManager.Hide(UIID.OnHook)
end

function OnHook_ProfitUI:OnToggleChanged()
  if self.tog_upgrade.toggle.isOn then
    self:ShowLinePointUI()
    self.onLinePointUI:SetActive(true)
    self.img_profitBg:SetActive(false)
  end
  if self.tog_badge.toggle.isOn then
    self.onLinePointUI:SetActive(false)
    self.img_profitBg:SetActive(true)
  end
end

function OnHook_ProfitUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.OnHook)
end

function OnHook_ProfitUI:RegistEvents()
  self:RegistEvent(Event.RefreshOnHookInfo, self.RefreshOnHookInfo, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.RefreshBag_CoinChanged, self)
end

function OnHook_ProfitUI:RefreshOnHookInfo()
  self.getExpContainer:SetData(OnHookData.getExpInfoList)
end

function OnHook_ProfitUI:RefreshBag_CoinChanged()
  local template
  if type(self.getExpContainer) == "table" and type(self.getExpContainer.items) == "table" then
    for k, v in pairs(self.getExpContainer.items) do
      template = v.itemTemp
      if template.RefreshBtnEffect ~= nil then
        template:RefreshBtnEffect()
      end
    end
  end
end

function OnHook_ProfitUI:Refresh()
  self:MapGroupIdRefresh()
  self.tog_badge.toggle.isOn = true
  self.onLinePointUI:SetActive(false)
  self.img_profitBg:SetActive(true)
  self.logsTemp:SetData(OnHookData.logs)
  self:RefreshSumExp()
  self.getExpContainer:SetData(OnHookData.getExpInfoList)
  local killMonsterSecond = KillMonsterCardData.totalTime
  killMonsterSecond = Mathf.Floor(killMonsterSecond / 1000)
  self.txt_killMonsterTime:SetText(string.format("Th\225\187\157i gian Th\225\187\167 H\225\187\153 treo m\195\161y: %s", TimeUtility.ShowTimeHour(killMonsterSecond)))
  killMonsterSecond = KillMonsterCardData.crossTotalTime
  killMonsterSecond = Mathf.Floor(killMonsterSecond / 1000)
  self.txt_crossKillMonsterTime:SetActive(CrossRealmData.IsCrossRealm())
  self.txt_crossKillMonsterTime:SetText(string.format("Th\225\187\157i gian Th\225\187\167 H\225\187\153 treo m\195\161y li\195\170n sv: %s", TimeUtility.ShowTimeHour(killMonsterSecond)))
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.hookProfit,
    state = true
  })
end

function OnHook_ProfitUI:RefreshSumExp()
  local sumOnHookTime = OnHookData.OnLineData.onHookTime + OnHookData.OffLineData.onHookTime
  self.expTime:SetText(TimeUtility.ShowMinuteTime(sumOnHookTime))
  self.onHookMonsterTime:SetText(TimeUtility.ShowMinuteTime(OnHookData.OnLineData.onHookTime))
  self.pointTime:SetText(TimeUtility.ShowMinuteTime(OnHookData.OffLineData.onHookTime))
  local reinLv = ViewData.meData:GetReinLv()
  local reinExpStr = ""
  if 0 < reinLv then
    local levelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(ViewData.meData.level)
    reinExpStr = " " .. levelTbl.tips
  end
  local expText = OnHookData.OnLineData.expInfoTbl[OnHookExpTypeEnum.Rein].onHookEXP
  self.onHookMonsterExp:SetText(expText)
  local expText = OnHookData.OnLineData.expInfoTbl[OnHookExpTypeEnum.Holy].onHookEXP
  self.onHookMonsterHolyRingPower:SetText(expText)
  local expText = self:GetExpText(OnHookData.OffLineData.expInfoTbl[OnHookExpTypeEnum.Rein], self.addBuffInfoTbl[OnHookExpTypeEnum.Rein], reinExpStr)
  self.pointExp:SetText(expText)
  local expText = self:GetExpText(OnHookData.OffLineData.expInfoTbl[OnHookExpTypeEnum.Holy], self.addBuffInfoTbl[OnHookExpTypeEnum.Holy], self.holyExpStr)
  self.pointHolyRingPower:SetText(expText)
end

function OnHook_ProfitUI:GetExpText(expInfo, addBuffInfo, expTypeStr)
  local expStr = ""
  expStr = string.format("%d%s", expInfo.onHookEXP, expInfo.onHookEXP > 0 and expTypeStr or "")
  local expAdditionStr = ""
  if 0 < expInfo.commerceExp or ExpAddData.HolidayExp ~= 0 then
    expAdditionStr = string.format(self.AddtionStr[1], addBuffInfo.name, addBuffInfo.value, expInfo.additionExp, 0 < expInfo.additionExp and expTypeStr or "", expInfo.commerceExp, 0 < expInfo.commerceExp and expTypeStr or "")
  else
    expAdditionStr = string.format(self.AddtionStr[2], addBuffInfo.name, addBuffInfo.value, expInfo.additionExp, 0 < expInfo.additionExp and expTypeStr or "")
  end
  local expText = string.format("%s%s", expStr, expAdditionStr)
  return expText
end

function OnHook_ProfitUI:IsShouldShowLinePoint()
  if self.args then
    return true
  end
  local strTab = string.split(GlobalConfig.GetGlobalConfig(2460104), "#")
  local task = TaskData.GetTaskById(tonumber(strTab[1]))
  if task then
    return true
  end
  return false
end

function OnHook_ProfitUI:ShowLinePointUI()
  self.sv_pointList:SetActive(false)
  local temp
  self.recommendGroupId, temp = self:GetRecommendIndexInAllData()
  self.curMapGroupId = self.recommendGroupId
  self.mapIndex = 1
  self.paramGroupIdIndex = nil
  self.paramMonIndex = nil
  if self.args and self.args.openFirstTab and self.args.openFirstTab ~= 0 then
    self.paramGroupIdIndex = self.args.openFirstTab
    if self.args.openFirstTab == 1 then
      self.paramMonIndex = 5
    end
  end
  if not self.paramGroupIdIndex then
    self:GuideChooseSnowKing()
  end
  if self.paramGroupIdIndex then
    self.mapIndex = self.paramGroupIdIndex
    self.recommendGroupId = self.groupIdTab[self.paramGroupIdIndex]
    self.curMapGroupId = self.groupIdTab[self.paramGroupIdIndex]
  else
    for i = 1, table.count(self.groupIdTab) do
      if self.groupIdTab[i] == self.recommendGroupId then
        self.mapIndex = i
      end
    end
  end
  local startIndex = 1
  if self.mapIndex > 3 then
    startIndex = self.mapIndex - 2
  end
  if not self.mapListTableView then
    self:MapCreateTableView()
    self.mapListTableView:ReloadData(startIndex)
  else
    self.mapListTableView:ReloadData(startIndex)
  end
  self:RefreshPos()
end

function OnHook_ProfitUI:dp_mapOnClick(control)
  local mapTab = self:GetMapTableData(self.groupIdTab[control.index])
  local isEnough = self:IsEnoughLevel(mapTab.enterCondition)
  if not isEnough then
    FloatingWordUtility.QuickMsg("C\225\186\165p kh\195\180ng \196\145\225\187\167")
    return
  end
  if control.index ~= self.mapIndex then
    if self.lastControl then
      self.lastControl.select:SetActive(false)
    end
    self.lastControl = control
    self.btnIndex = nil
    self.mapIndex = control.index
    self.curMapGroupId = self.groupIdTab[control.index]
    control.select:SetActive(true)
    self:RefreshPos()
    self.sv_pointList:SetActive(false)
  end
end

function OnHook_ProfitUI:MonPointOnClick(control)
  if control.index == self.btnIndex then
    return
  end
  if self.btnControl then
    self.btnControl.select:SetActive(false)
  end
  if self.btnGoLinePoint then
    self.btnGoLinePoint:GetChild("img_jianTou"):SetActive(false)
  end
  self.btnIndex = control.index
  self.btnControl = control
  self.sv_pointList:SetActive(false)
end

function OnHook_ProfitUI:GoLineOnClick(control)
  if self.btnGoLinePoint then
    self.btnGoLinePoint:GetChild("img_jianTou"):SetActive(false)
  end
  if self.btnControl then
    self.btnControl.select:SetActive(false)
  end
  self.btnIndex = control.index
  self.btnGoLinePoint = control
  if self.paramGroupIdIndex then
    local index = Mathf.Random(1, table.count(self.currentMonData[control.index]))
    local tab = {}
    tab.data = self.currentMonData[control.index][index]
    self:Btn_PointOnClick(tab)
    return
  end
  if table.count(self.currentMonData[control.index]) == 1 then
    local posArray = string.split(control.position, "#")
    local pos = Vector2(tonumber(posArray[1]), tonumber(posArray[2]))
    local transId
    if self:IsCanUseFlyShoe(control.posTransId) then
      transId = control.posTransId
    end
    PathFinderManager.JumpMapToMoveToPos(control.groupId, pos, transId, nil, nil, Purpose.None, function()
      RoleManager.me:SetAutoHookFight(true)
    end, nil, true)
    UIManager.UICloseType(UIPanelType.SortAndHide, true)
    UIManager.Hide(UIID.OnHook)
  else
    control:GetChild("img_jianTou"):SetActive(true)
    local w, h, hMax = 200, table.count(self.currentMonData[control.index]) * 46 + 16, 433
    if h < hMax then
      self.sv_pointList:SetSizeDelta(w, h)
      local posY = self:GetSv_PointListPos(self.root.transform:InverseTransformPoint(control.transform.position).y, h)
      self.sv_pointList:SetAnchoredPosition(self.pointPosX, posY)
    else
      self.sv_pointList:SetSizeDelta(w, hMax)
      self.sv_pointList:SetAnchoredPosition(self.pointPosX, self.maxPointPosY)
    end
    self.sv_pointList:SetActive(true)
    self.pointPosContainer:SetData(self.currentMonData[control.index])
  end
end

function OnHook_ProfitUI:Btn_PointOnClick(control)
  local posArray = string.split(control.data.position, "#")
  local pos = Vector2(tonumber(posArray[1]), tonumber(posArray[2]))
  local transId
  if self:IsCanUseFlyShoe(control.data.posTransId) then
    transId = control.data.posTransId
  end
  PathFinderManager.JumpMapToMoveToPos(control.data.mapId, pos, transId, nil, nil, Purpose.None, function()
    ForgeData.isOnHookProfitStart = true
    RoleManager.me:SetAutoHookFight(true)
  end, nil, true)
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  UIManager.Hide(UIID.OnHook)
end

function OnHook_ProfitUI:GetPosData(groupId)
  local tempTab = {}
  local dataTable = self.cfgLinePoint
  for i, v in ipairs(dataTable) do
    if v.mapId == groupId then
      if not tempTab[v.monsterId] then
        tempTab[v.monsterId] = {}
      end
      table.insert(tempTab[v.monsterId], v)
    end
  end
  local tab = {}
  for i, v in pairs(tempTab) do
    table.insert(tab, v)
  end
  table.sort(tab, function(a, b)
    return a[1].recommendDef < b[1].recommendDef
  end)
  return tab
end

function OnHook_ProfitUI:GetMapTableData(groupId)
  local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(groupId, "id")
  if mapTab then
    return mapTab
  end
  return {}
end

function OnHook_ProfitUI:MapGroupIdRefresh()
  local isOpen = ConditionManager.Check(GlobalConfig.GetGlobalConfig(11110001))
  local dataTable = ClientTable.cfg_OnHook_OnLinePointManager:GetDic()
  self.cfgLinePoint = {}
  for i, v in pairs(dataTable) do
    if v.show == 1 then
      local tab = self:GetMapTableData(v.mapId)
      if tab.serverType == 2 then
        if isOpen then
          table.insert(self.cfgLinePoint, v)
          if not table.contains(self.groupIdTab, v.mapId) then
            table.insert(self.groupIdTab, v.mapId)
            table.insert(self.groupName, tab.name)
          end
        end
      else
        table.insert(self.cfgLinePoint, v)
        if not table.contains(self.groupIdTab, v.mapId) then
          table.insert(self.groupIdTab, v.mapId)
          table.insert(self.groupName, tab.name)
        end
      end
    end
  end
end

function OnHook_ProfitUI:IsEnoughLevel(condition)
  local strTab = condition[1]
  if ConditionManager.GenerateSingleCondition(strTab[1]):Check() then
    return true
  else
    return false
  end
end

function OnHook_ProfitUI:GuideChooseSnowKing()
  local strTab = string.split(GlobalConfig.GetGlobalConfig(2460104), "#")
  local task = TaskData.GetTaskById(tonumber(strTab[1]))
  if task then
    self.paramGroupIdIndex = 1
    self.paramMonIndex = 5
  end
end

function OnHook_ProfitUI:GetRecommendIndex(data)
  local index = 1
  for i = 1, table.count(data) do
    if i == table.count(data) then
      if ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i][1].recommendDef then
        index = i
      end
    elseif ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i][1].recommendDef and ViewData.meData:GetAttribute(EAttributeType.defenseBase) < data[i + 1][1].recommendDef then
      index = i
    end
  end
  return index
end

function OnHook_ProfitUI:GetAllRecommendValue()
  local data = self.cfgLinePoint
  local value = data[1].recommendDef
  for i = 1, table.count(data) do
    if i == table.count(data) then
      if ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef then
        value = data[i].recommendDef
      end
    elseif ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i].recommendDef and ViewData.meData:GetAttribute(EAttributeType.defenseBase) < data[i + 1].recommendDef then
      value = data[i].recommendDef
    end
  end
  return value
end

function OnHook_ProfitUI:GetRecommendIndexInAllData()
  local lineTab = self.cfgLinePoint
  local dataTable = {}
  for i = 1, table.count(lineTab) do
    if lineTab[i].mapLevle <= RoleManager.me.level then
      table.insert(dataTable, lineTab[i])
    end
  end
  table.sort(dataTable, function(a, b)
    return a.recommendDef < b.recommendDef
  end)
  local groupId = 1003
  local value = table.count(dataTable) > 0 and dataTable[1].recommendDef or 0
  for i = 1, table.count(dataTable) do
    if i == table.count(dataTable) then
      if ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= dataTable[i].recommendDef then
        groupId = dataTable[i].mapId
        value = dataTable[i].recommendDef
      end
    elseif ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= dataTable[i].recommendDef and ViewData.meData:GetAttribute(EAttributeType.defenseBase) < dataTable[i + 1].recommendDef then
      groupId = dataTable[i].mapId
      value = dataTable[i].recommendDef
    end
  end
  return groupId, value
end

function OnHook_ProfitUI:IsCanUseFlyShoe(transId)
  local transConfig = ConfigManager.FindConfigs("cfg_Map_transfer", "id", transId)
  if transConfig[1].condition ~= nil then
    local strTab = transConfig[1].condition
    for i = 1, table.count(strTab) do
      if ConditionManager.GenerateSingleCondition(strTab[i][1]):Check() then
        return true
      end
    end
  end
  return false
end

function OnHook_ProfitUI:MapCreateTableView()
  self.mapListTableView = UITableView()
  self.mapListTableView:SetLowerMargin(0)
  self.mapListTableView:SetScrollView(self.sv_mapList)
  self.mapListTableView:SetScalarForCellInTableView(self, self.MapScalarForCellInTableView)
  self.mapListTableView:SetUpperMargin(0)
  self.mapListTableView:SetResetCellCallback(self, self.MapResetBgList)
  self.mapListTableView:SetTotalCellCount(self, self.MapNumberOfCellsInTableView)
  self.mapListTableView:SetCellAtIndexInTableView(self, self.MapCellAtIndexInTableView)
  self.mapListTableView:SetCellAtIndexInTableViewWillAppear(self, self.MapCellAtIndexInTableViewWillAppear)
  self.mapListTableView:ScrollToCell(1, true)
end

function OnHook_ProfitUI:MapScalarForCellInTableView()
  local _, sizeY = self.mapItem:GetSizeDelta()
  return sizeY
end

function OnHook_ProfitUI:MapResetBgList(cell)
end

function OnHook_ProfitUI:MapNumberOfCellsInTableView()
  local count = self.groupIdTab and table.count(self.groupIdTab) or 0
  return count
end

function OnHook_ProfitUI:MapCellAtIndexInTableView(index)
  return self.mapListTableView:ReuseOrCreateCell(self.mapItem)
end

function OnHook_ProfitUI:MapCellAtIndexInTableViewWillAppear(i)
  local data = self.groupIdTab[i]
  local ctr = self.mapListTableView:GetLoadedCell(i)
  local mapTab = self:GetMapTableData(data)
  local str = mapTab.name
  local level = mapTab.enterCondition[1][1][2] .. "Lv"
  local isEnough = self:IsEnoughLevel(mapTab.enterCondition)
  if data == self.recommendGroupId then
    ctr:GetChild("img_recommend"):SetActive(true)
  else
    ctr:GetChild("img_recommend"):SetActive(false)
  end
  if isEnough then
    str = string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.white])
    level = string.GetColorText(level, ItemQuality2ColorDic[EItemColorEnum.white])
  else
    str = string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.gray])
    level = string.GetColorText(level, ItemQuality2ColorDic[EItemColorEnum.bRed])
  end
  ctr.mapLabel = ctr:GetChild("mapLabel")
  ctr.mapLevel = ctr:GetChild("mapLevel")
  ctr.select = ctr:GetChild("select")
  ctr.index = i
  ctr.mapLabel:SetText(str)
  ctr.mapLevel:SetText(level)
  ctr:SetOnClick(self, self.dp_mapOnClick)
  if i == self.mapIndex then
    self.lastControl = ctr
    ctr.select:SetActive(true)
  else
    ctr.select:SetActive(false)
  end
end

function OnHook_ProfitUI:RefreshPos()
  self.currentMonData = self:GetPosData(self.curMapGroupId)
  self.recommendIndex = self:GetRecommendIndex(self.currentMonData)
  local temp
  temp, self.recommendValue = self:GetRecommendIndexInAllData()
  self.btnIndex = 1
  if self.paramGroupIdIndex and self.paramGroupIdIndex == 1 then
    self.btnIndex = self.paramMonIndex
  else
    self.btnIndex = self.recommendIndex
  end
  local startIndex = 1
  if self.btnIndex > 5 then
    startIndex = self.btnIndex - 4
  end
  if self.paramMonIndex then
    startIndex = 2
  end
  if not self.lineListTableView then
    self:CreateTableView()
    self.lineListTableView:ReloadData(startIndex)
  else
    self.lineListTableView:ReloadData(startIndex)
  end
end

function OnHook_ProfitUI:CreateTableView()
  self.lineListTableView = UITableView()
  self.lineListTableView:SetLowerMargin(0)
  self.lineListTableView:SetScrollView(self.sv_onLinePointGroup)
  self.lineListTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.lineListTableView:SetUpperMargin(0)
  self.lineListTableView:SetResetCellCallback(self, self.ResetBgList)
  self.lineListTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.lineListTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.lineListTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  self.lineListTableView:ScrollToCell(1, true)
end

function OnHook_ProfitUI:ScalarForCellInTableView()
  local _, sizeY = self.go_onLinePoint:GetSizeDelta()
  return sizeY
end

function OnHook_ProfitUI:ResetBgList(cell)
end

function OnHook_ProfitUI:NumberOfCellsInTableView()
  local count = self.currentMonData and table.count(self.currentMonData) or 0
  return count
end

function OnHook_ProfitUI:CellAtIndexInTableView(index)
  return self.lineListTableView:ReuseOrCreateCell(self.go_onLinePoint)
end

function OnHook_ProfitUI:CellAtIndexInTableViewWillAppear(i)
  local data = self.currentMonData
  local obj = self.lineListTableView:GetLoadedCell(i)
  local color = ViewData.meData:GetAttribute(EAttributeType.defenseBase) >= data[i][1].recommendDef and ItemQuality2ColorDic[EItemColorEnum.white] or ItemQuality2ColorDic[EItemColorEnum.bRed]
  local str = string.GetColorText("lv." .. data[i][1].mLevel, color)
  obj:GetChild("txt_level"):SetText(str)
  str = data[i][1].pointName
  obj:GetChild("txt_name"):SetText(str)
  str = string.format("EXP %d/con", data[i][1].mExp)
  obj:GetChild("txt_exp"):SetText(str)
  local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(data[i][1].monsterId, "id")
  if monster then
    local head = obj:GetChild("img_headFrame/img_head")
    self:SetSprite("Atlas_headPortrait", monster.head, head)
  end
  obj.index = i
  obj.select = obj:GetChild("img_select")
  obj.btn_golinePoint = obj:GetChild("btn_golinePoint")
  obj.btn_golinePoint.groupId = data[i][1].mapId
  obj.btn_golinePoint.position = data[i][1].position
  obj.btn_golinePoint.mapTransId = data[i][1].mapTransId
  obj.btn_golinePoint.posTransId = data[i][1].posTransId
  obj.btn_golinePoint.index = i
  obj.btn_golinePoint:GetChild("img_jianTou"):SetActive(false)
  obj.select:SetActive(false)
  if self.btnIndex == i then
    self.btnControl = obj
    if self.paramGroupIdIndex and self.paramMonIndex then
      obj.select:SetActive(true)
    end
  end
  obj.btn_golinePoint:SetOnClick(self, self.GoLineOnClick)
end

function OnHook_ProfitUI:GetSv_PointListPos(y, h)
  local pos = 0
  local max = -189
  local min = -622
  if y < 0 then
    pos = 375 - y - h * 0.5
  else
    local temp = 375 - y
    pos = temp - h * 0.5
  end
  if 0 < y then
    if pos < -max then
      pos = max
    else
      pos = -pos
    end
  elseif pos + h > -min then
    pos = (-min - h) * -1
  else
    pos = -pos
  end
  return pos
end
