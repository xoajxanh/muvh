Activity_IndexUI = class(BaseUI)
Activity_IndexUI.layer = UILayer.Panel
Activity_IndexUI.orderInLayer = 2
Activity_IndexUI.hideType = UIHideType.Hide
Activity_IndexUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_IndexUI.escClose = UIEscClose.DontClose

function Activity_IndexUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_Activity/btn_close")
  self.btn_activeTask = self:GetControl("panel_tab/btn_activeTask")
  self.btn_active = self:GetControl("panel_tab/btn_active")
  self.btn_activeFindBack = self:GetControl("panel_tab/btn_activeFindBack")
  self.panel_degree = self:GetControl("panel_main/panel_degree")
  self.bg_dailyTask = self:GetControl("panel_main/panel_degree/bg_dailyTask")
  self.bg_degree = self:GetControl("panel_main/panel_degree/bg_dailyTask/Viewport/Content/bg_degree")
  self.slider_dailyTask = self:GetControl("panel_main/panel_degree/slider_dailyTask")
  self.btn_reward = self:GetControl("panel_main/panel_degree/slider_dailyTask/btn_reward")
  self.txt_activeCount = self:GetControl("panel_main/panel_degree/slider_dailyTask/txt_activeCount")
  self.reward_detail = self:GetControl("panel_main/panel_degree/reward_detail")
  self.bg_ornamentsBreach = self:GetControl("panel_main/panel_degree/reward_detail/bg_ornamentsBreach")
  self.btn_closeReward = self:GetControl("panel_main/panel_degree/reward_detail/bg_ornamentsBreach/btn_closeReward")
  self.item_choose = self:GetControl("panel_main/panel_degree/reward_detail/Scroll View/Viewport/Content/item_choose")
  self.btn_use = self:GetControl("panel_main/panel_degree/reward_detail/btn_use")
  self.panel_mainScroll = self:GetControl("panel_main/panel_mainScroll")
  self.Content = self:GetControl("panel_main/panel_mainScroll/Viewport/Content")
  self.bg_Main = self:GetControl("panel_main/panel_mainScroll/Viewport/Content/bg_Main")
  self.bg_DetailUI = self:GetControl("panel_main/panel_mainScroll/Viewport/Content/bg_DetailUI")
  self.panel_findBack = self:GetControl("panel_main/panel_findBack")
  self.tab_findBackCoin = self:GetControl("panel_main/panel_findBack/tab_findBackCoin")
  self.tab_findBackDiamond = self:GetControl("panel_main/panel_findBack/tab_findBackDiamond")
  self.bg_findBack = self:GetControl("panel_main/panel_findBack/bg_findBack")
  self.plane_bottom = self:GetControl("panel_main/panel_findBack/bg_findBack/plane_bottom")
  self.bg_detail = self:GetControl("panel_main/panel_findBack/bg_detail")
  self.btn_findReward1 = self:GetControl("panel_main/panel_findBack/bg_detail/panel_reward/btn_findReward1")
  self.btn_findReward2 = self:GetControl("panel_main/panel_findBack/bg_detail/panel_reward/btn_findReward2")
  self.btn_findReward3 = self:GetControl("panel_main/panel_findBack/bg_detail/panel_reward/btn_findReward3")
  self.btn_findReward4 = self:GetControl("panel_main/panel_findBack/bg_detail/panel_reward/btn_findReward4")
  self.btn_findCost = self:GetControl("panel_main/panel_findBack/bg_detail/decide/btn_findCost")
  self.find_thing = self:GetControl("panel_main/panel_findBack/find_thing")
  self.btn_close_find = self:GetControl("panel_main/panel_findBack/find_thing/btn_close_find")
  self.btn_find1 = self:GetControl("panel_main/panel_findBack/find_thing/panel_reward/btn_find1")
  self.btn_find2 = self:GetControl("panel_main/panel_findBack/find_thing/panel_reward/btn_find2")
  self.btn_find3 = self:GetControl("panel_main/panel_findBack/find_thing/panel_reward/btn_find3")
  self.btn_find4 = self:GetControl("panel_main/panel_findBack/find_thing/panel_reward/btn_find4")
  self.find_count_jian = self:GetControl("panel_main/panel_findBack/find_thing/find_count/find_count_jian")
  self.find_count_jia = self:GetControl("panel_main/panel_findBack/find_thing/find_count/find_count_jia")
  self.find_count_number = self:GetControl("panel_main/panel_findBack/find_thing/find_count/find_count_number")
  self.btn_findDiamond = self:GetControl("panel_main/panel_findBack/find_thing/find_need/need_diamond/btn_findDiamond")
  self.count_diamond = self:GetControl("panel_main/panel_findBack/find_thing/find_need/need_diamond/count_diamond")
  self.btn_findGold = self:GetControl("panel_main/panel_findBack/find_thing/find_need/need_gold/btn_findGold")
  self.count_gold = self:GetControl("panel_main/panel_findBack/find_thing/find_need/need_gold/count_gold")
  self.btn_diamond = self:GetControl("panel_main/panel_findBack/find_thing/find_btn/btn_diamond")
  self.btn_gold = self:GetControl("panel_main/panel_findBack/find_thing/find_btn/btn_gold")
end

function Activity_IndexUI:OnPreLoad()
end

function Activity_IndexUI:Init()
end

function Activity_IndexUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_IndexUI:InitUI()
  self:InitActivityBtn()
  self:InitRewardBtn()
  self:InitCtr()
  self:InitCoinModel()
end

function Activity_IndexUI:InitActivityBtn()
  self.btn_activeTask.type = "task"
  self.btn_active.type = "active"
  self.btn_activeFindBack.type = "findBack"
  self.btnTypeToPanel = {
    task = self.panel_degree,
    active = self.panel_mainScroll,
    findBack = self.panel_findBack
  }
end

function Activity_IndexUI:InitRewardBtn()
  local rewardList = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2530001)
  rewardList = string.split(rewardList, "&")
  self.rewardBtnList = {}
  local maxRewardCount = Activity_IndexData.maxActivityCount
  local _, sliderHeight = self.slider_dailyTask:GetSizeDelta()
  local originBtnPosX, _ = self.btn_reward:GetAnchoredPosition()
  for i = 1, #rewardList do
    local reward = string.split(rewardList[i], "#")
    local percent = tonumber(reward[1]) / maxRewardCount
    local rewardHeight = percent * sliderHeight
    local rewardBtn = self.btn_reward:Instantiate()
    rewardBtn = UIControl(rewardBtn.transform)
    rewardBtn:SetAnchoredPosition(originBtnPosX, rewardHeight)
    rewardBtn:SetActive(true)
    self:SetSprite("Atlas_Common", string.format("img_active_gift%d", i), rewardBtn)
    rewardBtn.activityNum = tonumber(reward[1])
    rewardBtn.boxId = tonumber(reward[2])
    rewardBtn.rewardIndex = i
    rewardBtn:SetOnClick(self, self.ShowReward)
    rewardBtn:GetChild("txt_rewardNum"):SetText(reward[1])
    self.rewardBtnList[i] = rewardBtn
  end
end

function Activity_IndexUI:GetBoxData(boxId)
  local boxItems = ConfigManager.FindConfigs("cfg_Box_box", "boxId", boxId)
  local itemData = {}
  for i, v in pairs(boxItems) do
    itemData[i] = {
      itemId = v.itemId,
      count = v.count
    }
  end
  return itemData
end

function Activity_IndexUI:ShowReward(control)
  self.reward_detail:SetActive(true)
  self.RewardItemTemp:SetData(self:GetBoxData(control.boxId))
  self.btn_use.activityNum = control.activityNum
  self.btn_use.rewardIndex = control.rewardIndex
end

function Activity_IndexUI:GetRewardBtnOnClick(control)
  if not (Activity_IndexData.activityNum >= control.activityNum) then
    return
  end
  NetManager.Send(RoleMessage.ReqAward, {
    phase = control.activityNum
  })
  control:GetChild("img_received"):SetActive(true)
  Activity_IndexData.SetPhases(control.activityNum)
end

function Activity_IndexUI:RefreshRewardBtn()
  for i = 1, #self.rewardBtnList do
    if not Activity_IndexData.IsHasPhases(self.rewardBtnList[i].activityNum) and Activity_IndexData.activityNum >= self.rewardBtnList[i].activityNum then
      self.rewardBtnList[i]:GetChild("Eff_UI_xuanshangjiangli"):SetActive(true)
    else
      self.rewardBtnList[i]:GetChild("Eff_UI_xuanshangjiangli"):SetActive(false)
    end
    if Activity_IndexData.IsHasPhases(self.rewardBtnList[i].activityNum) then
      self.rewardBtnList[i]:GetChild("img_received"):SetActive(true)
    else
      self.rewardBtnList[i]:GetChild("img_received"):SetActive(false)
    end
    if Activity_IndexData.activityNum < self.rewardBtnList[i].activityNum then
      self.rewardBtnList[i]:SetColor("0x8E8E8EFF")
    else
      self.rewardBtnList[i]:SetColor("0xFFFFFFFF")
    end
  end
  local maxRewardCount = Activity_IndexData.maxActivityCount
  local activityNum = Activity_IndexData.activityNum
  self.slider_dailyTask:SetValue(activityNum / maxRewardCount)
  self.txt_activeCount:SetText(string.format("S\195\180i N\225\187\149i h\195\180m nay: %s", activityNum))
end

local function ActivityItemCreate(ctr)
  ctr.Activity_title = UIControl(ctr.transform, "ShowMain/Activity_title")
  ctr.Activity_surplus = UIControl(ctr.transform, "ShowMain/Activity_surplus")
  ctr.Activity_point = UIControl(ctr.transform, "ShowMain/Activity_point")
  ctr.place_Point = UIControl(ctr.transform, "ShowMain/Activity_point/place_Point")
  ctr.text_tim = UIControl(ctr.transform, "ShowMain/Activity_time/text_tim")
  ctr.text_date = UIControl(ctr.transform, "ShowMain/Activity_date/text_date")
  ctr.btn_detail = UIControl(ctr.transform, "ShowMain/btn_detail")
  ctr.ShowMainBG = UIControl(ctr.transform, "ShowMain/ShowMainBG")
  ctr.btn_3DItem = UIControl(ctr.transform, "ShowMain/content/btn_3DItem")
  ctr.btn_go = UIControl(ctr.transform, "ShowMain/btn_go")
end

local function DetailUICtr(ctr)
  ctr.Activity_description = UIControl(ctr.transform, "descScroll/Viewport/Content/Activity_description")
  ctr.btn_3DItem = UIControl(ctr.transform, "3DItemScroll/Viewport/Content/btn_3DItem")
end

local function Calculatingtime(activityOverview)
  local timeCondition = activityOverview.condition
  local showCondition
  for i, v in pairs(timeCondition) do
    if ConditionManager.Check(v) then
      for k = 1, #v do
        if v[k][1] == 908 then
          showCondition = v[k]
        end
      end
    end
  end
  if showCondition then
    return showCondition[2]
  else
    local curTime = Time.GetServerSecondTime()
    local ShowTlb
    for i, v in pairs(timeCondition) do
      local timecond
      for k = 1, #v do
        if v[k][1] == 908 then
          timecond = v[k]
          ShowTlb = ShowTlb or timecond
        end
      end
      if timecond then
        local times = string.split(timecond[2], "-")
        local startStr = times[1]
        local stratTime = TimeUtility.GetTimeStampByStr(startStr)
        if curTime < stratTime then
          return timecond[2]
        end
      else
        logError("C\195\160i \196\145\225\186\183t th\225\187\157i gian kh\195\180ng ph\195\185 h\225\187\163p v\225\187\155i logic")
      end
    end
    return ShowTlb[2]
  end
end

local function ActivitypointCreate(ctr)
  ctr.name = UIControl(ctr.transform, "name")
  ctr.liveNumber = UIControl(ctr.transform, "liveNumber")
  ctr.Line = UIControl(ctr.transform, "Line")
end

local function ActivitypointRefresh(ctr, _, data, ui)
  local count = data.count
  local Map = ClientTable.cfg_Map_mapManager:TryGetValue(data.mapId, "groupId")
  local MapName = Map and Map.name or ""
  local color = 0 < count and "#37EE0F" or "#cccccc"
  ctr.name:SetText(string.GetColorText(MapName, color))
  ctr.liveNumber:SetText(string.GetColorText(string.format("C\195\178n %s con", count), color))
  local mTextGenerator = ctr.Line.text.cachedTextGeneratorForLayout
  local mTgSettings = ctr.Line.text:GetGenerationSettings(Vector2(0, 0))
  local txtwith = mTextGenerator:GetPreferredWidth(MapName, mTgSettings) / ctr.Line.text.pixelsPerUnit + 1
  local nilwith = mTextGenerator:GetPreferredWidth("_", mTgSettings) / ctr.Line.text.pixelsPerUnit
  local txtcount = math.ceil(txtwith / nilwith) + 1
  local txt = string.rep("_", txtcount)
  ctr.Line:SetText(string.GetColorText(txt, color))
  ctr.data = data
  ctr:SetOnClick(ui, ui.HuoLongOnclick)
end

local function ActivityItemRefresh(ctr, _, data, ui)
  ctr.Activity_point:SetActive(false)
  if data.noshow then
    if data.activityId == 1008 then
      if not ctr.ActivitypointTemp then
        ctr.ActivitypointTemp = UIContainer(ctr.place_Point, ui, ActivitypointCreate, ActivitypointRefresh)
      end
      ctr.ActivitypointTemp:SetData(Activity_IndexData.HuoLongLaiXiCount.info)
      ctr.Activity_point:SetActive(true)
    end
    ctr.ShowMainBG:SetInteractable(true)
  else
    ctr.ShowMainBG:SetInteractable(false)
  end
  ctr.btn_go:SetActive(data.showArriveBtn)
  ctr.Activity_title:SetText(data.activityName)
  ctr.text_tim:SetText(data.showTime)
  ctr.Activity_title:SetText(data.activityName)
  if not ctr.bg_DetailUI then
    local item
    local go = ui.bg_DetailUI:Instantiate(ui.Content.transform, ui.Content)
    go.name = ui.bg_DetailUI.gameObject.name
    item = UIControl()
    item.transform = go.transform
    ctr.bg_DetailUI = item
    if not ctr.bg_DetailUI.Ctr then
      DetailUICtr(ctr.bg_DetailUI)
    end
  end
  local activityOverview = ClientTable.cfg_Activity_overviewManager:TryGetValue(data.activityId, "activityId")
  if data.showType == 1 then
    ctr.text_date:SetText(data.showLevel)
  else
    local showCondition = Calculatingtime(activityOverview)
    ctr.text_date:SetText(showCondition)
  end
  ui.cor = Coroutine.Start(function()
    local name = string.format("Texture/%s.png", data.showPic)
    local request = ui:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
    Coroutine.Yield(request)
    if request.isError then
      logError(request.error)
      Coroutine.Break()
    end
    ctr.ShowMainBG:SetTexture(request.res)
    ui.cor = nil
  end)
  ctr.btn_detail.UI = ctr.bg_DetailUI
  ctr.btn_detail.showDetail = activityOverview.showDetail
  local showReward = tonumber(data.showReward)
  ctr.btn_detail.showItemdata = {
    {itemId = showReward}
  }
  ctr.btn_detail:SetOnClick(ui, ui.detailOnclick)
  ctr.ShowMainBG.activityId = data.activityId
  ctr.ShowMainBG:SetOnClick(ui, ui.EnterOnclick)
  if not ui.activityReward[ctr] then
    ui:CreateActivityReward(ctr, ctr.btn_3DItem)
  end
  local rewardData = {}
  local rewardStr = data.showReward
  rewardStr = string.split(rewardStr, "#")
  for i = 1, #rewardStr do
    rewardData[i] = {
      itemId = tonumber(rewardStr[i])
    }
  end
  ui.activityReward[ctr]:SetData(rewardData)
end

local function OnItemCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function Activity_IndexUI:detailOnclick(control)
  if control.UI then
    if control.UI.gameObject.activeSelf then
      control.UI:SetActive(false)
    else
      control.UI:SetActive(true)
      if not control.UI.ItemContainer then
        control.UI.ItemContainer = UIContainer(control.UI.btn_3DItem, self, OnItemCreat, OnItemRefresh)
      end
      control.UI.ItemContainer:SetData(control.showItemdata)
      control.UI.Activity_description:SetText(control.showDetail)
    end
  else
    logError("Giao di\225\187\135n UI chi ti\225\186\191t ch\198\176a kh\225\187\159i t\225\186\161o")
  end
end

function Activity_IndexUI:HuoLongOnclick(control)
  local data = control.data
  ActivityUtility.ShowActivity(1008, data.mapId)
  UIManager.Hide(UIID.Activity_IndexUI)
end

local function OnRewardItemCreat(ctr)
  local rewardItem = UIControl(ctr.transform, "btn_3DItem")
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(rewardItem.transform))
  ctr.modelData = ItemCellData()
end

local function OnRewardItemRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function Activity_IndexUI:InitCtr()
  self.ActivityItemTemp = UIContainer(self.bg_Main, self, ActivityItemCreate, ActivityItemRefresh)
  self.RewardItemTemp = UIContainer(self.item_choose, self, OnRewardItemCreat, OnRewardItemRefresh)
  self.activityReward = {}
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

function Activity_IndexUI:CreateActivityReward(ctr, btn3dItem)
  self.activityReward[ctr] = UIContainer(btn3dItem, self, OnItemRewardCreate, OnItemRewardRefresh)
end

function Activity_IndexUI:CreateActivityTaskTableView()
  self.tableViewTask = UITableView()
  self.tableViewTask:SetLowerMargin(0)
  self.tableViewTask:SetScrollView(self.bg_dailyTask)
  self.tableViewTask:SetNumberOfCellsAtRowOrColumn(2)
  _, self.bg_degreeSizeY = self.bg_degree:GetSizeDelta()
  self.tableViewTask:SetScalarForCellInTableView(self, self.GetSizeCell)
  self.tableViewTask:SetUpperMargin(0)
  self.tableViewTask:SetTotalCellCount(self, self.GetCountCount)
  self.tableViewTask:SetCellAtIndexInTableView(self, self.GetCell)
  self.tableViewTask:SetCellAtIndexInTableViewWillAppear(self, self.UpdateCell)
  self.tableViewTask:ReloadData(1)
end

function Activity_IndexUI:GetSizeCell()
  return self.bg_degreeSizeY
end

function Activity_IndexUI:GetCountCount()
  return #Activity_IndexData.actives
end

function Activity_IndexUI:GetCell()
  return self.tableViewTask:ReuseOrCreateCell(self.bg_degree)
end

function Activity_IndexUI:UpdateCell(index)
  local taskData = Activity_IndexData.actives
  if taskData[index] then
    local taskCell = self.tableViewTask:GetLoadedCell(index)
    local gridGameObject = taskCell.gameObject
    if self.activityGrid == nil then
      self.activityGrid = {}
    end
    if self.activityGrid[gridGameObject] == nil then
      self.activityGrid[gridGameObject] = luaTemplateManager.GetNewTemplate(gridGameObject, LuaComponentTemplates.Actibity_EveryDayGrid)
    end
    local gridTemplate = self.activityGrid[gridGameObject]
    gridTemplate:Refresh()
    local activityLively = ClientTable.cfg_Activity_livelyManager:TryGetValue(taskData[index].activeId)
    self:SetSprite("Atlas_Common", activityLively.showIcon, taskCell:GetChild("ico_degree"))
    taskCell:GetChild("name"):SetText(activityLively.showName)
    local timescount = activityLively.times - taskData[index].completeTimes
    taskCell:GetChild("reward"):SetText(string.format("\196\144\225\187\153 S\195\180i N\225\187\149i <color=#1ADD1F>%s</color>/%s", taskData[index].completeTimes * activityLively.getLively, activityLively.times * activityLively.getLively))
    local btnGoto = taskCell:GetChild("btn_goto")
    local label_taskOver = taskCell:GetChild("label_taskOver")
    if taskData[index].open == 0 then
      taskCell:GetChild("label_notBtnDesc"):SetText(activityLively.showRequire)
      taskCell:GetChild("label_notBtnDesc"):SetActive(true)
      btnGoto:SetActive(false)
    else
      taskCell:GetChild("label_notBtnDesc"):SetActive(false)
      btnGoto:SetActive(true)
    end
    taskCell:GetChild("desc"):SetText(activityLively.showDesc)
    btnGoto.toFunction = activityLively.toFunction
    btnGoto.goalId = activityLively.goalId
    btnGoto:GetChild("Text"):SetText("<color=#DCE1E5>\196\144\225\186\191n</color>")
    label_taskOver:SetActive(not (0 < timescount))
    btnGoto.timescount = timescount
    btnGoto:SetOnClick(self, self.TransferUI)
  end
end

function Activity_IndexUI:TransferUI(control)
  UIManager.Hide(UIID.Activity_IndexUI)
  if control.toFunction == "-1" then
    local goalId = control.goalId
    local taskGoal = TaskGoal(goalId)
    if taskGoal:GetTarget() == TaskTargetType.NpcTarget then
      PathFinderManager.JumpMapMoveToNpc({
        npcId = taskGoal:GetNpc()
      }, nil, Purpose.ClickNpc)
    end
    if taskGoal:GetTarget() == TaskTargetType.SingleMap or taskGoal:GetTarget() == TaskTargetType.MultiMap then
      local mul, groundId, pos, transferId = taskGoal:GetPosition()
      PathFinderManager.JumpMapToMoveToPos(groundId, PathFinderManager.GetCalcPosData(pos), transferId, nil, nil, nil, function()
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
      end)
    end
  elseif tonumber(control.toFunction) == 4010003 then
    if WarAllianceData.IsHaveUnion then
      UIManager.JumpShow(UIPanelType.SortAndHide, "Activity_IndexUI", {openPanel = "btn_active"})
    else
      local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(10000000)
      if GradData.GoToNavi(navTbl) then
        NavigationUtility.OpenPanel(navTbl)
      end
    end
  else
    NavigationUtility.OpenPanelForId(tonumber(control.toFunction))
  end
end

function Activity_IndexUI:CreateFindTableView()
  self.tableViewFind = UITableView()
  self.tableViewFind:SetLowerMargin(0)
  self.tableViewFind:SetScrollView(self.bg_findBack)
  _, self.bg_detailSizeY = self.bg_detail:GetSizeDelta()
  self.tableViewFind:SetScalarForCellInTableView(self, self.GetFindSizeCell)
  self.tableViewFind:SetUpperMargin(0)
  self.tableViewFind:SetTotalCellCount(self, self.GetFindCountCount)
  self.tableViewFind:SetCellAtIndexInTableView(self, self.GetFindCell)
  self.tableViewFind:SetCellAtIndexInTableViewWillAppear(self, self.UpdateFindCell)
  self.tableViewFind:ReloadData(1)
end

function Activity_IndexUI:GetFindSizeCell()
  return self.bg_detailSizeY
end

function Activity_IndexUI:GetFindCountCount()
  return #Activity_IndexData.findBackData
end

function Activity_IndexUI:GetFindCell()
  return self.tableViewFind:ReuseOrCreateCell(self.bg_detail)
end

function Activity_IndexUI:UpdateFindCell(index)
  local findData = Activity_IndexData.findBackData
  if findData[index] then
    local findCell = self.tableViewFind:GetLoadedCell(index)
    local findConfig = ClientTable.cfg_Activity_findBackManager:TryGetValue(findData[index].id)
    local activityLively = ClientTable.cfg_Activity_livelyManager:TryGetValue(findConfig.livelyId)
    findCell:GetChild("name"):SetText(findConfig.showName)
    findCell:GetChild("times"):SetText(string.format("L\198\176\225\187\163t c\195\179 th\225\187\131 t\195\172m l\225\186\161i %s/%s", findData[index].findTimes, activityLively.times))
    local decide = findCell:GetChild("decide")
    if findData[index].findTimes == 0 then
      decide:SetInteractable(false)
    else
      decide:SetInteractable(true)
    end
    local findCost = string.split(findConfig.cost, "&")
    local coinData = {}
    for i = 1, #findCost do
      local findCoin = string.split(findCost[i], "#")
      coinData[#coinData + 1] = {
        itemId = tonumber(findCoin[1]),
        cost = tonumber(findCoin[2])
      }
    end
    decide.coinData = coinData
    decide.id = findData[index].id
    decide.findTimes = findData[index].findTimes
    decide:SetOnClick(self, self.SendFindBack)
    self:UpdateRewardModel(findConfig.reward[1], findCell)
  end
end

function Activity_IndexUI:UpdateRewardModel(reward, findCell)
  local boxTable = ConfigManager.FindConfigs("cfg_Box_box", "boxId", reward)
  for i = 1, 4 do
    local rewardPanel = findCell:GetChild(string.format("panel_reward/btn_findReward%d", i))
    if boxTable[i] then
      rewardPanel:SetActive(true)
      local itemData = ItemUtility.GenerateItemData(boxTable[i].itemId)
      if not rewardPanel.itemCellData then
        local itemCellData = ItemCellData()
        rewardPanel.itemCellData = itemCellData
        rewardPanel.itemCellData:RefreshData(itemData)
        ItemUtility.ShowItemCell(rewardPanel, rewardPanel.itemCellData, self, true)
      end
    else
      rewardPanel:SetActive(false)
    end
  end
end

function Activity_IndexUI:InitCoinModel()
  local coin = 1000010
  local itemData = ItemUtility.GenerateItemData(coin)
  local itemCellData = ItemCellData()
  itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_findGold, itemCellData, self, true)
  local diamond = 1000050
  itemData = ItemUtility.GenerateItemData(diamond)
  itemCellData = ItemCellData()
  itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_findDiamond, itemCellData, self, true)
end

function Activity_IndexUI:SendFindBack(control)
  self.btn_diamond.id = control.id
  self.btn_gold.id = control.id
  self.findTimes = control.findTimes
  self.coinData = control.coinData
  self:ShowFindBackUI()
end

function Activity_IndexUI:ShowFindBackUI()
  self.find_count_number:SetText(1)
  self.findTime = 1
  self:UpdateCoinNum()
  BlockerUtility.Show(self.find_thing)
end

function Activity_IndexUI:ActivityUI()
end

function Activity_IndexUI:OnShow()
  NetManager.Send(ActivityMessage.ReqHuoLongLaiXiCount)
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    4010002,
    4010003,
    4010004
  })
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.dayGoal,
    state = true
  })
  self:RegistEvents()
  self:Refresh()
end

function Activity_IndexUI:OnHide()
end

function Activity_IndexUI:OnDestroy()
end

function Activity_IndexUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_activeTask:SetOnToggleChanged(self, self.ShowActivePanelByType)
  self.btn_active:SetOnToggleChanged(self, self.ShowActivePanelByType)
  self.btn_activeFindBack:SetOnToggleChanged(self, self.ShowActivePanelByType)
  self.tab_findBackCoin:SetOnClick(self, self.showFindCoinTableView)
  self.tab_findBackDiamond:SetOnClick(self, self.showFindDiamondTableView)
  self.btn_close_find:SetOnClick(self, self.HideFindBackUI)
  self.btn_diamond:SetOnClick(self, self.btn_diamondOnClick)
  self.btn_gold:SetOnClick(self, self.btn_goldOnClick)
  self.find_count_jian:SetOnClick(self, self.find_count_jianOnClick)
  self.find_count_jia:SetOnClick(self, self.find_count_jiaOnClick)
  self.btn_closeReward:SetOnClick(self, self.btn_closeRewardOnClick)
  self.btn_use:SetOnClick(self, self.btn_useRewardOnClick)
end

function Activity_IndexUI:btn_useRewardOnClick(control)
  if Activity_IndexData.IsHasPhases(control.activityNum) then
    FloatingTipUtility.QuickMsg("\196\144\195\163 nh\225\186\173n xong")
    return
  end
  if Activity_IndexData.activityNum < control.activityNum then
    FloatingTipUtility.QuickMsg("\196\144i\225\187\131m kh\195\180ng \196\145\225\187\167")
    return
  end
  NetManager.Send(RoleMessage.ReqAward, {
    phase = control.activityNum
  })
  Activity_IndexData.SetPhases(control.activityNum)
  self.reward_detail:SetActive(false)
  self.rewardBtnList[control.rewardIndex]:GetChild("Eff_UI_xuanshangjiangli"):SetActive(false)
  self.rewardBtnList[control.rewardIndex]:GetChild("img_received"):SetActive(true)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.dayGoal,
    state = true
  })
end

function Activity_IndexUI:btn_closeRewardOnClick()
  self.reward_detail:SetActive(false)
end

function Activity_IndexUI:UpdateCoinNum()
  self.count_gold:SetText(self.coinData[1].cost * self.findTime)
  self.count_diamond:SetText(self.coinData[2].cost * self.findTime)
end

function Activity_IndexUI:find_count_jianOnClick()
  local findTime = tonumber(self.find_count_number:GetText())
  findTime = findTime - 1 > 0 and findTime - 1 or 1
  self.findTime = findTime
  self.find_count_number:SetText(findTime)
  self:UpdateCoinNum()
end

function Activity_IndexUI:find_count_jiaOnClick()
  local findTime = tonumber(self.find_count_number:GetText())
  findTime = findTime + 1 <= self.findTimes and findTime + 1 or self.findTimes
  self.findTime = findTime
  self.find_count_number:SetText(findTime)
  self:UpdateCoinNum()
end

function Activity_IndexUI:btn_goldOnClick(control)
  NetManager.Send(RoleMessage.ReqFind, {
    fId = control.id,
    itemId = 1000010,
    count = self.findTime
  })
  BlockerUtility.Hide()
end

function Activity_IndexUI:btn_diamondOnClick(control)
  NetManager.Send(RoleMessage.ReqFind, {
    fId = control.id,
    itemId = 1000050,
    count = self.findTime
  })
  BlockerUtility.Hide()
end

function Activity_IndexUI:HideFindBackUI()
  BlockerUtility.Hide()
end

function Activity_IndexUI:btn_closeOnClick()
  UIManager.Hide(UIID.Activity_IndexUI)
end

function Activity_IndexUI:ShowActivePanelByType(control)
  if control.type == "active" then
    NetManager.Send(ActivityMessage.ReqHuoLongLaiXiCount)
  elseif control.type == "task" then
    self:RefreshTaskTableView()
  end
  local panel = self.btnTypeToPanel[control.type]
  panel:SetActive(control:GetIsOn())
end

function Activity_IndexUI:showFindCoinTableView()
  self.tableViewFind:ReloadData(1)
end

function Activity_IndexUI:showFindDiamondTableView()
  self.tableViewFind:ReloadData(1)
end

function Activity_IndexUI:RegistEvents()
  self:RegistEvent(Event.ActivityTaskUpdate, self.ActivityTaskUpdate, self)
  self:RegistEvent(Event.ActivityFindBackUpdate, self.ActivityFindBackUpdate, self)
  self:RegistEvent(Event.ShowActivityIndex, self.ShowActivityIndex, self)
  self:RegistEvent(Event.ActiveTbUpdate, self.RefreshData, self)
end

function Activity_IndexUI:ShowActivityIndex(_, activityType)
  self.btn_active:SetIsOn(true)
end

function Activity_IndexUI:ActivityTaskUpdate()
  if self.tableViewTask then
    self.tableViewTask:ReloadData()
  end
  self:RefreshRewardBtn()
end

function Activity_IndexUI:ActivityFindBackUpdate()
  if self.tableViewFind then
    self.tableViewFind:ReloadData()
  end
end

function Activity_IndexUI:Refresh()
  self:RefreshData()
  self:RefreshRewardBtn()
  self:RefreshTaskTableView()
  self:RefreshFindTableView()
  if self.args and self.args.openPanel and self[self.args.openPanel]:GetIsOn() == false then
    self[self.args.openPanel]:SetIsOn(true)
  elseif self.args and self.args.openFirstTab and self.args.openFirstTab == 2 then
    self.btn_active:SetIsOn(true)
  else
    self.btn_activeTask:SetIsOn(true)
  end
end

function Activity_IndexUI:RefreshTaskTableView()
  if self.tableViewTask then
    self.tableViewTask:ReloadData(1)
  else
    self:CreateActivityTaskTableView()
  end
end

function Activity_IndexUI:RefreshFindTableView()
  if self.tableViewFind then
    self.tableViewFind:ReloadData(1)
  else
    self:CreateFindTableView()
  end
end

function Activity_IndexUI:RefreshData()
  local ActivityData = {}
  local NoActivityData = {}
  for i, v in pairs(Activity_IndexData.ActivityTableData) do
    local activityOverview = ClientTable.cfg_Activity_overviewManager:TryGetValue(v.activityId, "activityId")
    if ConditionManager.Check4D(activityOverview.enterCondition) then
      if ConditionManager.Check4D(activityOverview.condition) then
        local data = v
        data.noshow = true
        data.showArriveBtn = activityOverview.showGoButton == 1
        table.insert(ActivityData, data)
      else
        local data = v
        data.noshow = false
        data.showArriveBtn = false
        table.insert(NoActivityData, data)
      end
    end
  end
  table.combine(ActivityData, NoActivityData)
  self.ActivityItemTemp:SetData(ActivityData)
end

function Activity_IndexUI:EnterOnclick(control)
  UIManager.Hide(UIID.Activity_IndexUI)
  ActivityUtility.ShowActivity(control.activityId)
end
