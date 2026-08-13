Task_TaskReward_New = class(BaseUI)
Task_TaskReward_New.layer = UILayer.Panel
Task_TaskReward_New.orderInLayer = 0
Task_TaskReward_New.hideType = UIHideType.WaitDestroy
Task_TaskReward_New.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TaskReward_New.escClose = UIEscClose.DontClose
local Task_Reward_Got_Pic_Pos = {
  [3] = 285,
  [4] = 285
}

function Task_TaskReward_New:InitControls()
  self.LevelContent = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent")
  self.btn_close = self:GetControl("bg/btn_close")
  self.go_ScrollRect = self:GetControl("scroll_shop")
  self.Content = self:GetControl("scroll_shop/Viewport/Content")
  self.go_item = self:GetControl("scroll_shop/Viewport/Content/go_item")
  self.btn_MonsterRewarItem = self:GetControl("scroll_shop/Viewport/Content/go_item/TaskContent/btn_MonsterRewarItem")
  self.nameText = self:GetControl("lab_name/levelText/nameText")
  self.levelText = self:GetControl("lab_name/levelText")
  self.imgName = self:GetControl("lab_name/imgName")
  self.PeriodicalReward = self:GetControl("PeriodicalReward")
  self.PeriodicalReward_Item = self:GetControl("PeriodicalReward/PeriodicalReward_Item")
  self.img_redPoint4 = self:GetControl("PeriodicalReward/PeriodicalReward_Item/img_redPoint4")
  self.taskdes = self:GetControl("taskdes")
  self.lingquperiodical = self:GetControl("lingquperiodical")
  self.redpoint_lingquperiodical = self:GetControl("lingquperiodical/img_redPoint")
  self.Image_Received = self:GetControl("Image_Received")
  self.btn_left = self:GetControl("btn_left")
  self.btn_right = self:GetControl("btn_right")
  self.image_title = self:GetControl("image_title")
  self.template_toggle = self:GetControl("bg/ScrollviewLevel/Viewport/LevelContent/tog_type")
  self.lab_lastTimeBoss = self:GetControl("lab_lastTimeBoss")
  self.lab_lastTimeBossPre = self:GetControl("lab_lastTimeBossPre")
  self.xianshiReward = self:GetControl("xianshiReward")
  self.xianshiReward_Item = self:GetControl("xianshiReward/xianshiReward_Item")
  self.Rewardshow = self:GetControl("Rewardshow")
  self.Rewardshow_count = self:GetControl("Rewardshow/count")
  self.Rewardshow_item = self:GetControl("Rewardshow/item")
  self.Rewardshow_lab_titil = self:GetControl("xianshiReward_btn_buy/lab_titil")
  self.img_taskdes = self:GetControl("img_taskdes")
  self.toggleScorllRect = self:GetControl("bg/ScrollviewLevel")
  self.xianshiReward_btn_buy = self:GetControl("xianshiReward_btn_buy")
  self.xianshiReward_getItem = self:GetControl("xianshiReward_getItem")
  self.xianshiReward_buy_item = self:GetControl("xianshiReward_buy_item")
  self.xianshiReward_buy_item_ZK = self:GetControl("xianshiReward_buy_item/lab_num_first")
  self.xianshiReward_buy_item_Model = self:GetControl("xianshiReward_buy_item/Model")
  self.xianshiReward_buy_item_lab_num = self:GetControl("xianshiReward_buy_item/lab_num")
  self.descBtnA = self:GetControl("descBtnA")
  self.descBtnB = self:GetControl("descBtnB")
end

function Task_TaskReward_New:OnPreLoad()
end

function Task_TaskReward_New:Init()
  math.randomseed(os.time())
  self.sportsBossInfo = CommercializeData:GetSportBOSSInfo()
  self.monsterList = {}
  self.taskEffeList = {}
  self.currSelectIndex = 1
  self.buy_itemData = ItemCellData()
end

function Task_TaskReward_New:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function InitRewardItemControls(item)
  local itemCellData = ItemCellData()
  item.itemCellData = itemCellData
end

local function ItemRewardRefresh(item, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(rewards.itemID))
  itemInfo.count = rewards.itemNum
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

local function InitLevelBossItemControls(ctr)
  ctr.taskMonsterName = UIControl(ctr.transform, "lab_name")
  ctr.taskProgress = UIControl(ctr.transform, "kill_num")
  ctr.taskMonsterIcon = UIControl(ctr.transform, "img_icon")
  ctr.taskMonsterLevel = UIControl(ctr.transform, "img_icon/level")
  ctr.btn_leave = UIControl(ctr.transform, "btn_leave")
  ctr.btn_complete = UIControl(ctr.transform, "btn_complete")
  ctr.redpoint_btn_complete = UIControl(ctr.transform, "btn_complete/img_redPoint")
  ctr.btn_cpmpleted = UIControl(ctr.transform, "btn_cpmpleted")
  ctr.img_bgback = UIControl(ctr.transform, "img_bgback")
  ctr.taskRewardContent = UIControl(ctr.transform, "TaskContent/btn_MonsterRewarItem")
end

local function ItemLevelBossRefresh(ctr, _, monsterTasks, ui)
  if not ctr.rewardItemTemp then
    ctr.rewardItemTemp = UIContainer(ctr.taskRewardContent, ui, InitRewardItemControls, ItemRewardRefresh)
  end
  local rewards = monsterTasks:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    table.insert(allRewards, {itemID = k, itemNum = v})
  end
  ctr.rewardItemTemp:SetData(allRewards)
  local monsterLevelTable = ConfigManager.GetConfig("cfg_Task_reward", ui.selectLevel, "levelReward")
  ctr.cor = Coroutine.Start(function()
    local name = string.format("Texture/%s", monsterLevelTable.mapImage)
    local request = ui:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
    Coroutine.Yield(request)
    if request.isError then
      Coroutine.Break()
    end
    ctr.img_bgback:SetTexture(request.res)
    ctr.cor = nil
  end)
  local position = string.split(GlobalConfig.GetGlobalConfig(2490002), "#")
  local scale = GlobalConfig.GetGlobalConfig(2490004)
  local rotation = string.split(GlobalConfig.GetGlobalConfig(2490003), "#")
  if ui.monsterList[monsterTasks:GetId()] then
    local monster = ui.monsterList[monsterTasks:GetId()]
    monster:SetActive(true)
    monster:SetParent(ctr.taskMonsterIcon.transform)
    monster:SetLocalPosition(Vector3(position[1], position[2], position[3]))
    monster:SetLocalScale(Vector3(scale, scale, scale))
    monster:SetLocalRotate(Vector3(rotation[1], rotation[2], rotation[3]))
  else
    local monster = UIMonsterUtility(monsterTasks:GetMonsterId(), ctr.taskMonsterIcon.transform, Vector3(scale, scale, scale), Vector3(position[1], position[2], position[3]), Vector3(rotation[1], rotation[2], rotation[3]))
    monster:SetActive(true)
    ui.monsterList[monsterTasks:GetId()] = monster
  end
  local str = monsterTasks:GetTaskMonsterName()
  if monsterTasks:GetMonsterType() == MonsterType.wildBoss then
    str = string.format("<color=#FF0000>%s</color>", str)
  end
  if monsterTasks:GetMonsterType() == MonsterType.goldBoss then
    str = string.format("<color=#E6E600>%s</color>", str)
  end
  ctr.taskMonsterName:SetText(str .. monsterTasks:GetTaskMonsterProgress())
  ctr.taskProgress:SetActive(false)
  ctr.taskProgress:SetText(monsterTasks:GetTaskMonsterProgress())
  ctr.taskMonsterLevel:SetText(monsterTasks:GetTaskMonsterLevel())
  ctr.btn_leave:SetActive(monsterTasks:GetState() == TaskStateType.Acceptable or monsterTasks:GetState() == TaskStateType.Accept)
  ctr.btn_complete:SetActive(monsterTasks:GetState() == TaskStateType.Completed)
  ctr.redpoint_btn_complete:SetActive(monsterTasks:GetState() == TaskStateType.Completed)
  ctr.btn_cpmpleted:SetActive(monsterTasks:GetState() == TaskStateType.Submitted)
  ctr.btn_leave:SetOnClick(ui, function()
    ui:StartToDoTask(monsterTasks)
  end)
  ctr.btn_complete:SetOnClick(ui, function()
    ui:StartToDoCompleteTask(monsterTasks)
  end)
  GuideUtility.AddCreatObj("Task_TaskReward", ctr.btn_leave)
  ui:AddCompleteEffect(monsterTasks, ctr.btn_complete, 2490005)
end

local function InitPerRewardItemControls(item)
  local itemCellData = ItemCellData()
  item.itemCellData = itemCellData
end

local function ItemPerRewardRefresh(item, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(rewards.itemId)
  itemInfo.count = rewards.count
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

local function ItemTimePerRewardRefresh(item, _, rewards, ui)
  item.img_Limitedtime = UIControl(item.transform, "img_Limitedtime")
  item.img_overtime = UIControl(item.transform, "img_overtime")
  item.img_Collect = UIControl(item.transform, "img_Collect")
  item.img_Limitedtime:SetActive(ui.perTimeTask.v.state == 1 or ui.perTimeTask.v.state == 2)
  item.img_overtime:SetActive(ui.perTimeTask.v.state == 3)
  if ui.perTimeTask.v.bossRewardInfo.state == 6 then
    item.img_overtime:SetActive(false)
  end
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(ui.selectLevel)
  item.img_Collect:SetActive(ui.perTimeTask.v.state == 4 and periodicalTask and periodicalTask.state ~= TaskStateType.Completed)
  local itemInfo = ItemUtility.GenerateItemData(rewards.itemId)
  itemInfo.count = rewards.count
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

local function ItemzShowPerRewardRefresh(item, _, rewards, ui)
  item.img_Limitedtime = UIControl(item.transform, "img_Limitedtime")
  local itemInfo = ItemUtility.GenerateItemData(rewards.itemId)
  itemInfo.count = rewards.count
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

local function toggleOnCreate(ctr)
  ctr.txt_level = UIControl(ctr.transform, "Label")
  ctr.img_redpoint = UIControl(ctr.transform, "img_redPoint")
  ctr.img_complete = UIControl(ctr.transform, "img_complete")
end

local function toggleOnRefresh(ctr, index, data, ui)
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(data.level)
  local isSubmitted = false
  if periodicalTask ~= nil then
    isSubmitted = periodicalTask.state == TaskStateType.Submitted
  end
  ctr.img_complete:SetActive(isSubmitted)
  local titleStr = ConfigManager.GetConfig("cfg_Task_reward", data.level, "levelReward").title
  ctr.txt_level:SetText(titleStr)
  ctr.level = data.level
  ctr.index = index
  ctr.img_redpoint:SetActive(TaskData.GetMonsterLevelCompletedTasks(data.level) or TaskData.Get_Receive_Chapter_Reward_RedPoint(data.level))
  ctr:SetOnToggleChanged(ui, ui.OnClickMonsterLevel)
end

function Task_TaskReward_New:OnClickMonsterLevel(ctr, isOn)
  if isOn then
    self.currSelectIndex = ctr.index
    self:RefreshSelectPageView(ctr.level)
  end
end

function Task_TaskReward_New:InitUI()
  self.levleBossItemTemp = UIContainer(self.go_item, self, InitLevelBossItemControls, ItemLevelBossRefresh)
  self.taskEffeList = {}
  self.perItemTemp = UIContainer(self.PeriodicalReward_Item, self, InitPerRewardItemControls, ItemPerRewardRefresh)
  self.toggleContainer = UIContainer(self.template_toggle, self, toggleOnCreate, toggleOnRefresh)
  self.perItemTimeTemp = UIContainer(self.xianshiReward_Item, self, InitPerRewardItemControls, ItemTimePerRewardRefresh)
  self.rewardshowTemp = UIContainer(self.Rewardshow_item, self, InitPerRewardItemControls, ItemzShowPerRewardRefresh)
end

function Task_TaskReward_New:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_TaskReward_New:OnHide()
  self:SetDestroyTime()
  self:CleanAllTaskEffect()
  if self.countdownTimeReward then
    Timer.Stop(self.countdownTimeReward)
    self.countdownTimeReward = nil
  end
  if self.countdownPreviewTimeReward then
    Timer.Stop(self.countdownPreviewTimeReward)
    self.countdownPreviewTimeReward = nil
  end
end

function Task_TaskReward_New:OnDestroy()
  self:SetDestroyTime()
  self:CleanAllTaskEffect()
end

function Task_TaskReward_New:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_MonsterRewarItem:SetOnClick(self, self.btn_MonsterRewarItemOnClick)
  self.PeriodicalReward_Item:SetOnClick(self, self.PeriodicalReward_ItemOnClick)
  self.lingquperiodical:SetOnClick(self, self.lingquperiodicalOnClick)
  self.btn_left:SetOnClick(self, self.btn_leftOnClick)
  self.btn_right:SetOnClick(self, self.btn_rightOnClick)
  self.xianshiReward_btn_buy:SetOnClick(self, self.xianshiReward_btn_buyOnClick)
  self.descBtnA:SetOnClick(self, self.descBtnAOnClick)
  self.descBtnB:SetOnClick(self, self.descBtnBOnClick)
end

function Task_TaskReward_New:descBtnAOnClick(control)
  local lvCfg = ClientTable.cfg_Ui_descriptionManager:TryGetValue(1119)
  if lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg.id
    })
  end
end

function Task_TaskReward_New:descBtnBOnClick(control)
  local lvCfg = ClientTable.cfg_Ui_descriptionManager:TryGetValue(1120)
  if lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg.id
    })
  end
end

function Task_TaskReward_New:btn_closeOnClick(control)
  UIManager.Hide(UIID.Task_TaskReward_New)
end

function Task_TaskReward_New:btn_MonsterRewarItemOnClick(control)
end

function Task_TaskReward_New:PeriodicalReward_ItemOnClick(control)
end

function Task_TaskReward_New:lingquperiodicalOnClick(control)
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  if periodicalTask ~= nil then
    local isNotFinish = TaskData.GetCurMonsterLevelFinish(self.selectLevel)
    if not isNotFinish then
      if periodicalTask.state == TaskStateType.Completed then
        TaskController.TaskUISubmit(_, periodicalTask:GetId())
      end
      if periodicalTask.state == TaskStateType.Submitted then
        print("\229\183\178\233\162\134\229\143\150\229\165\150\229\138\177")
      end
    else
      local uiWord = periodicalTask:GetDes()
      FloatingTipUtility.QuickMsg(uiWord)
    end
  end
end

function Task_TaskReward_New:btn_leftOnClick(control)
end

function Task_TaskReward_New:btn_rightOnClick(control)
end

function Task_TaskReward_New:xianshiReward_btn_buyOnClick()
  if self.IsNotNeedCountItem == true then
    FloatingTipUtility.QuickMsg("KC kh\195\180ng \196\145\225\187\167")
  end
  networkRequest.ReqBuy(self.select_buypreview, 1)
  networkRequest.ReqBossRewardBuy(self.select_buypreview, 1, 0, self.select_taskID)
end

function Task_TaskReward_New:RegistEvents()
  self:RegistEvent(Event.UnionTask_Update, self.RefushUnionTask, self)
  self:RegistEvent(Event.BossBountyReward, self.RefushBossBountyReward, self)
  self:RegistEvent(Event.BossRewardInfo, self.BossRewardInfo, self)
end

function Task_TaskReward_New:RefushUnionTask()
  self:RefreshSelectPageView(self.selectLevel)
  self.toggleContainer:RefreshItem(self.currSelectIndex)
  self.tableViewTask:ReloadData(1)
end

function Task_TaskReward_New:RefushBossBountyReward(_, msg)
  self:RefushTimeReward()
end

function Task_TaskReward_New:Refresh()
  TaskData.timeTasks = {}
  networkRequest.ReqBossBountyReward()
  self.roleLevel = ViewData.meData.level
  self.refushPageLevel = {}
  self:InitToggle()
  if self.tableViewTask then
    self.tableViewTask:ReloadData(1)
  else
    self:CreateBOSSTableView()
  end
end

function Task_TaskReward_New:InitToggle()
  self.allTaskInfo = TaskData.GetAllMonsterLevelTasks()
  local tempTbl = {}
  for k, v in pairs(self.allTaskInfo) do
    v.level = k
    table.insert(tempTbl, v)
  end
  table.sort(tempTbl, function(a, b)
    return a.level < b.level
  end)
  self.toggleContainer:SetData(tempTbl)
  self.tempTbl = tempTbl
  self.currSelectIndex = self:Get_Default_Select_Index(tempTbl)
  if self.currSelectIndex > 8 then
    self.LevelContent.transform.localPosition = Vector2(0, self.currSelectIndex * 50)
  else
    self.LevelContent.transform.localPosition = Vector2(0, 0)
  end
  local nowItemIndex = #self.toggleContainer.items
  if nowItemIndex == 0 or nowItemIndex < self.currSelectIndex then
    return
  end
  self.toggleContainer.items[self.currSelectIndex]:SetIsOn(false)
  self.toggleContainer.items[self.currSelectIndex]:SetIsOn(true)
end

function Task_TaskReward_New:Get_Default_Select_Index(tempTbl)
  if self.args and self.args.currSelectIndex then
    for i = 1, #tempTbl do
      if tempTbl[i].level == self.args.currSelectIndex then
        return i
      end
    end
  end
  for i = 1, #tempTbl do
    local canReceive = TaskData.GetMonsterLevelCompletedTasks(tempTbl[i].level) or TaskData.Get_Receive_Chapter_Reward_RedPoint(tempTbl[i].level)
    if canReceive then
      return i
    end
  end
  for i = 1, #tempTbl do
    local tempTbl2 = self.allTaskInfo[tempTbl[i].level]
    for j = 1, #tempTbl2 do
      if tempTbl2[j]:GetState() ~= TaskStateType.Submitted then
        return i
      end
    end
  end
  return #tempTbl
end

function Task_TaskReward_New:GetPageList()
  local curNotFinishLevel
  if self.roleLevel < TaskData.allMonsterLevel[1] then
  else
    for k, v in pairs(TaskData.allMonsterLevel) do
      if v <= self.roleLevel then
        local ifNotFinish = TaskData.GetCurMonsterLevelFinish(v)
        local generalTask = TaskData.GetPeriodicalTaskByLevel(v)
        if ifNotFinish or not ifNotFinish and generalTask and generalTask:GetState() ~= TaskStateType.Submitted then
          curNotFinishLevel = v
          table.insert(self.refushPageLevel, v)
        end
      end
    end
    if self.refushPageLevel ~= nil and 1 > #self.refushPageLevel then
      for k, v in pairs(TaskData.allMonsterLevel) do
        if v >= self.roleLevel - 10 and v < self.roleLevel then
          table.insert(self.refushPageLevel, v)
        end
      end
    end
  end
  for k, v in pairs(TaskData.allMonsterLevel) do
    if v > self.roleLevel then
      table.insert(self.refushPageLevel, v)
    elseif curNotFinishLevel ~= nil and v > curNotFinishLevel then
      table.insert(self.refushPageLevel, v)
    end
  end
  if self.refushPageLevel ~= nil and table.count(self.refushPageLevel) > 0 then
    self.selectLevel = self.refushPageLevel[1]
  end
end

local unionTitle = {
  [50] = "first_task50",
  [60] = "first_task60",
  [100] = "first_task100",
  [150] = "first_task150",
  [200] = "first_task200"
}

function Task_TaskReward_New:RefreshSelectPageView(level)
  for k, v in pairs(self.monsterList) do
    v:SetHide()
  end
  self.selectLevel = level
  if self.tableViewTask then
    self.tableViewTask:ReloadData(1)
  end
  self:RefushPeriodicalReward()
  self:RefushTimeReward()
  local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(QuickFind.LuaMainPlayerViewAttrData().level)
  if tbl == nil or string.isNullOrEmpty(tbl.name) then
    self.levelText:SetText("")
  else
    self.levelText:SetText(tbl.name)
  end
end

function Task_TaskReward_New:StartToDoTask(monsterTasks)
  self:OnHidePer()
  TaskData.SetClickLevelBossTask(monsterTasks:GetId())
  local taskGoalTblData = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(monsterTasks.taskTbl.goals))
  if taskGoalTblData then
    local mapId = tonumber(string.split(taskGoalTblData.target, "#")[2])
    local tempPosTbl = string.split(taskGoalTblData.position, "&")
    local random = Mathf.Random(1, #tempPosTbl)
    local targetPos = string.split(tempPosTbl[random], "#")
    local goPos = Vector2(tonumber(targetPos[1]), tonumber(targetPos[2]))
    local transferID
    if not string.isNullOrEmpty(taskGoalTblData.transferId) then
      local transferIdTbl = string.split(taskGoalTblData.transferId, "#")
      local randomIndex = Mathf.Random(1, #transferIdTbl)
      transferID = tonumber(transferIdTbl[randomIndex])
    end
    UIManager.Show(UIID.Instance_BossUI, {
      Monsterid = tonumber(taskGoalTblData.goalParam)
    })
  end
  UIManager.Hide(UIID.Task_TaskReward_New)
end

function Task_TaskReward_New:StartToDoCompleteTask(monsterTasks, level)
  TaskController.TaskUISubmit(_, monsterTasks:GetId())
end

function Task_TaskReward_New:OnHidePer()
  for k, v in pairs(self.monsterList) do
    v:DestroyGameObject()
  end
  self.monsterList = {}
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.CommercializationActivityUI)
end

function Task_TaskReward_New:SetRewardShow()
  local levelRewardTbl = ConfigManager.GetConfig("cfg_Task_reward", self.selectLevel, "levelReward")
  if levelRewardTbl then
    networkRequest.ReqBossRewardInfo(levelRewardTbl.taskId)
  end
  self.xianshiReward:SetActive(not string.isNullOrEmpty(levelRewardTbl.rewards))
  if not string.isNullOrEmpty(levelRewardTbl.rewards) then
    local rewardIds = tonumber(levelRewardTbl.rewards)
    if rewardIds then
      self.rewardsTbl = ConfigManager.FindConfigs("cfg_Box_box", "boxId", rewardIds)
      self.rewardsTbl = TaskData.HandleGiftTblData(self.rewardsTbl)
      table.sort(self.rewardsTbl, function(a, b)
        return a.layer < b.layer
      end)
    end
    self.perItemTimeTemp:SetData(self.rewardsTbl)
  end
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  local isSubmitted = false
  if periodicalTask ~= nil then
    isSubmitted = periodicalTask.state == TaskStateType.Submitted
  end
  self.Rewardshow:SetActive(not string.isNullOrEmpty(levelRewardTbl.warriorPreview) and isSubmitted == false)
  if not string.isNullOrEmpty(levelRewardTbl.warriorPreview) then
    local award = TaskData.SetCarrerReward(levelRewardTbl.warriorPreview)
    self.rewardshowTemp:SetData(award)
  end
  self.Rewardshow_lab_titil:SetText(levelRewardTbl.txtPreview)
  local pos = not string.isNullOrEmpty(levelRewardTbl.rewards) and Vector2(-50, -190) or Vector2(-130, -190)
  local posReward = not string.isNullOrEmpty(levelRewardTbl.rewards) and Vector2(20, -190) or Vector2(-60, -190)
  self.img_taskdes.transform.localPosition = pos
  self.PeriodicalReward.transform.localPosition = posReward
end

function Task_TaskReward_New:RefushTimeReward()
  if TaskData.GetTimeTasks() == nil or table.count(TaskData.GetTimeTasks()) == 0 then
    return
  end
  if not TaskData.GetTimeClose() then
    self:GetRetData()
    return
  else
    self.levelText:SetActive(false)
    self.imgName:SetActive(true)
  end
  local perTimeTask = TaskData.GetTimeTaskByLevel(self.selectLevel)
  self.rewardsTbl = {}
  if perTimeTask then
    self.perTimeTask = perTimeTask
    local height, low = MathUtility.getDigitUnit(perTimeTask.v.previewReward, 32)
    self.Rewardshow_count:SetText(height .. "/" .. low)
    local totalTime = math.floor(perTimeTask.v.overTime - Time.GetServerSecondTime())
    if self.countdownTimeReward then
      Timer.Stop(self.countdownTimeReward)
      self.countdownTimeReward = nil
    end
    if 0 < totalTime then
      self.descBtnA:SetActive(true)
      self.descBtnB:SetActive(false)
      self.lab_lastTimeBoss:SetActive(true)
      self.lab_lastTimeBoss:SetText(TimeUtility.ShowDayHourMin(totalTime))
      
      local function CountdownTimeReward()
        local totalTime = math.floor(perTimeTask.v.overTime - Time.GetServerSecondTime())
        self.lab_lastTimeBoss:SetText(TimeUtility.ShowDayHourMin(totalTime))
        if totalTime <= 0 and self.countdownTimeReward then
          Timer.Stop(self.countdownTimeReward)
          self.countdownTimeReward = nil
          TaskData.GetTimeTaskByLevel(self.selectLevel, 3)
          self.perTimeTask.v.state = 3
          self.perItemTimeTemp:SetData(self.rewardsTbl)
          self.lab_lastTimeBoss:SetActive(false)
          self.descBtnA:SetActive(false)
          self.descBtnB:SetActive(true)
        end
      end
      
      self.countdownTimeReward = Timer.StartLoopForever(1, CountdownTimeReward)
    else
      self.perTimeTask.v.state = 3
      self.lab_lastTimeBoss:SetActive(false)
      self.descBtnA:SetActive(false)
      self.descBtnB:SetActive(true)
    end
    local totalTime = math.floor(perTimeTask.v.previewTime - Time.GetServerSecondTime())
    if self.countdownPreviewTimeReward then
      Timer.Stop(self.countdownPreviewTimeReward)
      self.countdownPreviewTimeReward = nil
    end
    self.lab_lastTimeBossPre:SetActive(false)
    self:SetRewardShow()
  else
    self:GetRetData()
  end
end

function Task_TaskReward_New:RefreshByShopInfo(byItemID, itemCount, zkCount)
  local itemData = ItemUtility.GenerateItemData(byItemID)
  self.buy_itemData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.xianshiReward_buy_item_Model, self.buy_itemData, self, true)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(byItemID)
  local showText = itemCount
  self.IsNotNeedCountItem = itemCount > bagCount
  if self.IsNotNeedCountItem then
    showText = string.GetColorText(itemCount, ItemQuality2ColorDic[7])
  end
  self.xianshiReward_buy_item_ZK:SetText(zkCount)
  self.xianshiReward_buy_item_lab_num:SetText(showText)
end

function Task_TaskReward_New:GetByInfo(Item_buyID)
  local byItemID = 0
  local itemCount = 0
  if Item_buyID ~= nil then
    local itemBy = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(Item_buyID))
    if itemBy then
      local temp = string.split(itemBy.cost, "#")
      if temp and #temp == 2 then
        byItemID = tonumber(temp[1])
        itemCount = tonumber(temp[2])
      end
    end
  end
  return byItemID, itemCount
end

function Task_TaskReward_New:BossRewardInfo(id, data)
  local byItemID = 0
  local itemCount = 0
  local zkCount = 0
  self.select_buypreview = data.rewardShopId
  self.select_taskID = data.id
  local byItemID, itemCount = self:GetByInfo(data.rewardShopId)
  local taskInfo = ClientTable.cfg_Task_rewardManager:TryGetValue(data.id)
  if taskInfo ~= nil then
    zkCount = taskInfo.originalPrice
  end
  self:RefreshByShopInfo(byItemID, itemCount, zkCount)
  self.xianshiReward_buy_item:SetActive(data.buyState == 1)
  self.xianshiReward_btn_buy:SetActive(data.buyState == 1)
  self.xianshiReward_getItem:SetActive(data.buyState == 2)
end

function Task_TaskReward_New:GetRetData()
  self.levelText:SetActive(true)
  self.imgName:SetActive(false)
  self.Rewardshow:SetActive(false)
  self.lab_lastTimeBossPre:SetActive(false)
  self.lab_lastTimeBoss:SetActive(false)
  self.xianshiReward:SetActive(false)
  self.img_taskdes.transform.localPosition = Vector2(-130, -190)
  self.PeriodicalReward.transform.localPosition = Vector2(-60, -190)
end

function Task_TaskReward_New:RefushPeriodicalReward()
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  if periodicalTask ~= nil then
    local rewards = self:RewardsOfThisLevel(periodicalTask.taskId)
    self.perItemTemp:SetData(rewards)
    local xAxis = Task_Reward_Got_Pic_Pos[#rewards]
    if periodicalTask.state == TaskStateType.Submitted then
      self.Image_Received:SetActive(true)
      self.lingquperiodical:SetActive(false)
    else
      self.Image_Received:SetActive(false)
      if periodicalTask.taskAcceptState == 1 then
        self.lingquperiodical:SetActive(false)
      else
        self.lingquperiodical:SetActive(true)
      end
      self.redpoint_lingquperiodical:SetActive(not TaskData.GetCurMonsterLevelFinish(self.selectLevel) and periodicalTask.state == TaskStateType.Completed)
      self.taskdes:SetText(periodicalTask:GetDes())
    end
  end
end

function Task_TaskReward_New:RewardsOfThisLevel(taskId)
  local rewardsTbl = {}
  local taskTbl = ClientTable.cfg_Task_taskManager:TryGetValue(taskId, "taskId")
  local rewardIds = tonumber(taskTbl.rewards)
  if rewardIds then
    rewardsTbl = ConfigManager.FindConfigs("cfg_Box_box", "boxId", rewardIds)
    table.sort(rewardsTbl, function(a, b)
      return a.layer < b.layer
    end)
  end
  return rewardsTbl
end

local function DaojishiTime(condition)
  local down = TimeUtility.AddDay(LoginData.openServerTime, condition[2][2])
  local Difference = TimeUtility.RefreshSec(down)
  return Difference
end

local DaojiTime = 0

function Task_TaskReward_New:RefreshTime(lab_lastTime, txt_lastTime)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    lab_lastTime:SetText(DaoJiShi)
  else
    txt_lastTime:SetActive(false)
    lab_lastTime:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Task_TaskReward_New:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Task_TaskReward_New:RefreshSportBossTime(data, info)
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local Difference = DaojishiTime(info[1].condition)
  local DaoJiShi
  if Difference <= 0 then
    self.txt_lastTimBoss:SetActive(false)
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lab_lastTimeBoss:SetText(DaoJiShi)
  else
    self.txt_lastTimBoss:SetActive(true)
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lab_lastTimeBoss:SetText(DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lab_lastTimeBoss, self.txt_lastTimBoss)
  end
end

function Task_TaskReward_New:AddCompleteEffect(task, parentItem, globalId)
  if task.state ~= TaskStateType.Completed and self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    self:CleanTaskEffect(task:GetId())
    return
  end
  if task.state ~= TaskStateType.Completed then
    return
  end
  local effectInfo = GlobalConfig.GetGlobalConfig(globalId)
  if effectInfo == nil or effectInfo == "" then
    return
  end
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    self.taskEffeList[task.taskId].submitEffect.transform:SetParent(parentItem.transform)
    self.taskEffeList[task.taskId].submitEffect:SetPosition(0, 0, 0)
    return
  end
  local effectList = string.split(effectInfo, "&")
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local scaleList = string.split(effectList[2], "#")
  self.taskEffeList[task.taskId].submitEffect = UIEffectUtility.SetUIEffect(effectList[1], parentItem, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
end

function Task_TaskReward_New:CleanTaskEffect(taskId)
  for k, v in pairs(self.taskEffeList) do
    if k == taskId and v.submitEffect ~= nil then
      v.submitEffect:Destroy()
      v.submitEffect = nil
    end
    if TaskData.AllTasks[k] == nil and v.submitEffect ~= nil then
      v.submitEffect:Destroy()
      v.submitEffect = nil
    end
  end
end

function Task_TaskReward_New:CleanAllTaskEffect()
  if self.taskEffeList then
    for k, v in pairs(self.taskEffeList) do
      if v.submitEffect ~= nil then
        v.submitEffect:Destroy()
        v.submitEffect = nil
      end
    end
    self.taskEffeList = {}
  end
end

function Task_TaskReward_New:CreateBOSSTableView()
  self.tableViewTask = UITableView()
  self.tableViewTask:SetLowerMargin(0)
  self.tableViewTask:SetScrollView(self.go_ScrollRect)
  self.tableViewTask:SetNumberOfCellsAtRowOrColumn(1)
  self.bg_degreeSizeX, _ = self.go_item:GetSizeDelta()
  self.tableViewTask:SetScalarForCellInTableView(self, self.GetSizeCell)
  self.tableViewTask:SetUpperMargin(0)
  self.tableViewTask:SetTotalCellCount(self, self.GetCountCount)
  self.tableViewTask:SetCellAtIndexInTableView(self, self.GetCell)
  self.tableViewTask:SetCellAtIndexInTableViewWillAppear(self, self.UpdateCell)
  self.tableViewTask:ReloadData(1)
end

function Task_TaskReward_New:GetSizeCell()
  return self.bg_degreeSizeX + 10
end

function Task_TaskReward_New:GetCountCount()
  local tempCount = TaskData.GetMonsterLevelTasks(self.selectLevel)
  return #tempCount
end

function Task_TaskReward_New:GetCell()
  return self.tableViewTask:ReuseOrCreateCell(self.go_item)
end

function Task_TaskReward_New:UpdateCell(index)
  local ctr = self.tableViewTask:GetLoadedCell(index)
  if not ctr.rewardItemTemp then
    ctr.taskRewardContent = ctr:GetChild("TaskContent/btn_MonsterRewarItem")
    ctr.rewardItemTemp = UIContainer(ctr.taskRewardContent, self, InitRewardItemControls, ItemRewardRefresh)
  end
  ctr.img_bgback = ctr:GetChild("img_bgback")
  ctr.taskMonsterIcon = ctr:GetChild("img_icon")
  ctr.taskMonsterName = ctr:GetChild("lab_name")
  ctr.taskMonsterLevel = ctr:GetChild("lab_level")
  ctr.taskProgress = ctr:GetChild("kill_num")
  ctr.btn_leave = ctr:GetChild("btn_leave")
  ctr.lab_condition = ctr:GetChild("lab_condition")
  ctr.btn_complete = ctr:GetChild("btn_complete")
  ctr.redpoint_btn_complete = ctr:GetChild("btn_complete/img_redPoint")
  ctr.btn_cpmpleted = ctr:GetChild("btn_cpmpleted")
  ctr.Eff_UI_annuikuang03 = ctr:GetChild("btn_complete/Eff_UI_annuikuang03")
  local monsterTasks = TaskData.GetMonsterLevelTasks(self.selectLevel)[index]
  local rewards = monsterTasks:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    table.insert(allRewards, {itemID = k, itemNum = v})
  end
  ctr.rewardItemTemp:SetData(allRewards)
  local monsterLevelTable = ConfigManager.GetConfig("cfg_Task_reward", self.selectLevel, "levelReward")
  ctr.cor = Coroutine.Start(function()
    local name = string.format("Texture/%s", monsterLevelTable.mapImage)
    local request = self:LoadAssetAsync(name, typeof(CS.UnityEngine.Texture2D))
    Coroutine.Yield(request)
    if request.isError then
      Coroutine.Break()
    end
    ctr.img_bgback:SetTexture(request.res)
    ctr.cor = nil
  end)
  local position = string.split(GlobalConfig.GetGlobalConfig(2490002), "#")
  local scale = GlobalConfig.GetGlobalConfig(2490004)
  local rotation = string.split(GlobalConfig.GetGlobalConfig(2490003), "#")
  for i = 0, ctr.taskMonsterIcon.transform.childCount - 1 do
    ctr.taskMonsterIcon.transform:GetChild(i).gameObject:SetActive(false)
  end
  if self.monsterList[monsterTasks:GetId()] then
    local monster = self.monsterList[monsterTasks:GetId()]
    monster:SetActive(true)
    monster:SetParent(ctr.taskMonsterIcon.transform)
    monster:SetLocalPosition(Vector3(position[1], position[2], position[3]))
    monster:SetLocalScale(Vector3(scale, scale, scale))
    monster:SetLocalRotate(Vector3(rotation[1], rotation[2], rotation[3]))
  else
    local monster = UIMonsterUtility(monsterTasks:GetMonsterId(), ctr.taskMonsterIcon.transform, Vector3(scale, scale, scale), Vector3(position[1], position[2], position[3]), Vector3(rotation[1], rotation[2], rotation[3]))
    monster:SetActive(true)
    self.monsterList[monsterTasks:GetId()] = monster
  end
  local str = monsterTasks:GetTaskMonsterName()
  if monsterTasks:GetMonsterType() == MonsterType.wildBoss then
    str = string.format("<color=#FF0000>%s</color>", str)
  end
  if monsterTasks:GetMonsterType() == MonsterType.goldBoss then
    str = string.format("<color=#E6E600>%s</color>", str)
  end
  ctr.taskMonsterName:SetText(str .. monsterTasks:GetTaskMonsterProgress())
  ctr.taskProgress:SetActive(false)
  ctr.taskProgress:SetText(monsterTasks:GetTaskMonsterProgress())
  if monsterTasks:GetTaskAcceptState() == 1 then
    ctr.btn_leave:SetActive(false)
    local text = ClientTable.cfg_Character_levelManager:TryGetValue(tonumber(self.selectLevel))
    ctr.lab_condition:SetText("Lv" .. text.name .. "M\225\187\159")
    ctr.lab_condition:SetActive(true)
  else
    ctr.btn_leave:SetActive(monsterTasks:GetState() == TaskStateType.Acceptable or monsterTasks:GetState() == TaskStateType.Accept)
    ctr.lab_condition:SetActive(false)
  end
  ctr.btn_complete:SetActive(monsterTasks:GetState() == TaskStateType.Completed)
  ctr.redpoint_btn_complete:SetActive(monsterTasks:GetState() == TaskStateType.Completed)
  ctr.btn_cpmpleted:SetActive(monsterTasks:GetState() == TaskStateType.Submitted)
  ctr.btn_leave:SetOnClick(self, function()
    self:StartToDoTask(monsterTasks)
  end)
  ctr.btn_complete:SetOnClick(self, function()
    self:StartToDoCompleteTask(monsterTasks)
  end)
  GuideUtility.AddCreatObj("Task_TaskReward", ctr.btn_leave)
  self:SetEffectShow(monsterTasks, ctr)
end

function Task_TaskReward_New:SetEffectShow(task, parentItem, globalId)
  if task.state ~= TaskStateType.Completed then
    parentItem.Eff_UI_annuikuang03:SetActive(false)
    return
  end
  parentItem.Eff_UI_annuikuang03:SetActive(true)
end
