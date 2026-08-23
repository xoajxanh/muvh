Task_TaskReward = class(BaseUI)
Task_TaskReward.layer = UILayer.Panel
Task_TaskReward.orderInLayer = 0
Task_TaskReward.hideType = UIHideType.WaitDestroy
Task_TaskReward.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TaskReward.escClose = UIEscClose.DontClose

function Task_TaskReward:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.LevelContent = self:GetControl("bg_shop/ScrollviewLevel/Viewport/LevelContent")
  self.tog_type = self:GetControl("bg_shop/ScrollviewLevel/Viewport/LevelContent/tog_type")
  self.img_redPoint = self:GetControl("bg_shop/ScrollviewLevel/Viewport/LevelContent/tog_type/img_redPoint")
  self.btn_close = self:GetControl("bg_shop/btn_close")
  self.Content = self:GetControl("scroll_shop/Viewport/Content")
  self.go_item = self:GetControl("scroll_shop/Viewport/Content/go_item")
  self.btn_MonsterRewarItem = self:GetControl("scroll_shop/Viewport/Content/go_item/TaskContent/btn_MonsterRewarItem")
  self.PeriodicalReward = self:GetControl("PeriodicalReward")
  self.PeriodicalReward_Item = self:GetControl("PeriodicalReward/PeriodicalReward_Item")
  self.taskdes = self:GetControl("PeriodicalReward/taskdes")
  self.Image_Received = self:GetControl("PeriodicalReward/Image_Received")
  self.mapJump = self:GetControl("mapJump")
  self.lab_mapTitle = self:GetControl("mapJump/lab_mapTitle")
  self.DiaoLuoContent = self:GetControl("Scrollviewboss/DiaoLuoContent")
  self.btn_3DItem = self:GetControl("Scrollviewboss/DiaoLuoContent/btn_3DItem")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
  self.image_title = self:GetControl("image_title")
end

function Task_TaskReward:OnPreLoad()
end

function Task_TaskReward:Init()
  self.curSelectLabelPage = nil
  self.curJumpMapId = nil
  self.roleLevel = ViewData.meData.level
  self.selectLevel = Mathf.Floor(ViewData.meData.level / 10) * 10 <= 0 and 1 or Mathf.Floor(ViewData.meData.level / 10) * 10
  self.refushPageLevel = {}
  self.limitNum = 0
  self.toggleGroup = {}
  self.monsterList = {}
end

local function InitLevelItemControls(ctr)
  ctr.levelTitle = UIControl(ctr.transform, "Label")
  ctr.notClickImg = UIControl(ctr.transform, "Background/NetCheckmark")
  ctr.ClickImg = UIControl(ctr.transform, "Background/Checkmark")
end

local function ItemLevelRefresh(ctr, _, rewards, ui)
  local titleStr = ClientTable.cfg_Task_rewardManager:TryGetValue(rewards, "levelReward").title
  ctr.levelTitle:SetText(titleStr)
  ctr.level = rewards
  ctr.toggle.isOn = false
  ctr.notClickImg:SetActive(false)
  ctr.ClickImg:SetActive(true)
  ctr:SetOnToggleChanged(ui, ui.OnClickMonsterLevel)
  ui.toggleGroup[rewards] = ctr
  if ui:IsShowRedPoint(ctr.level) then
    ctr:GetChild("img_redPoint"):SetActive(true)
  else
    ctr:GetChild("img_redPoint"):SetActive(false)
  end
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
  local monsterLevelTable = ClientTable.cfg_Task_rewardManager:TryGetValue(ui.selectLevel, "levelReward")
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
  ctr.taskMonsterName:SetText(str)
  ctr.taskProgress:SetText(monsterTasks:GetTaskMonsterProgress())
  ctr.taskMonsterLevel:SetText(monsterTasks:GetTaskMonsterLevel())
  ctr.btn_leave:SetActive(monsterTasks:GetState() == TaskStateType.Acceptable or monsterTasks:GetState() == TaskStateType.Accept)
  ctr.btn_complete:SetActive(monsterTasks:GetState() == TaskStateType.Completed)
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

local function InitDropRewardItemControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemDropRewardRefresh(ctr, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(rewards))
  itemInfo.count = 1
  ctr.itemCellData:Reset()
  ctr.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function Task_TaskReward:InitContent()
  self.levelItemTemp = UIContainer(self.tog_type, self, InitLevelItemControls, ItemLevelRefresh)
  self.levleBossItemTemp = UIContainer(self.go_item, self, InitLevelBossItemControls, ItemLevelBossRefresh)
  self.dropRewardItemTemp = UIContainer(self.btn_3DItem, self, InitDropRewardItemControls, ItemDropRewardRefresh)
end

function Task_TaskReward:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Task_TaskReward:InitUI()
  self.DiaoLuoContent.layoutGroup.enabled = true
  self.Content.layoutGroup.enabled = true
  self.selectLevel = nil
  self.monsterLevelIndex = {}
  self:InitContent()
  self:SubSortIndex()
  self.taskEffeList = {}
  self.perTaskEffeList = {}
end

function Task_TaskReward:SubSortIndex()
  local allLevel = {}
  for k, v in pairs(TaskData.allMonsterLevel) do
    table.insert(allLevel, v)
  end
  for i = 1, #allLevel do
    self.monsterLevelIndex[i] = allLevel[i]
  end
end

function Task_TaskReward:ResetUI()
  self.curJumpMapId = nil
  self.roleLevel = ViewData.meData.level
  self.refushPageLevel = {}
  self.toggleGroup = {}
  self.selectLevel = nil
end

function Task_TaskReward:AddPerCompleteEffect(task, parentItem, globalId)
  self:CleanAllPerTaskEffect()
  if task.state ~= TaskStateType.Completed then
    return
  end
  local effectInfo = GlobalConfig.GetGlobalConfig(globalId)
  if effectInfo == nil or effectInfo == "" then
    return
  end
  local effectList = string.split(effectInfo, "&")
  if self.perTaskEffeList[task.taskId] == nil then
    self.perTaskEffeList[task.taskId] = {}
  end
  local scaleList = string.split(effectList[2], "#")
  self.perTaskEffeList[task.taskId].submitEffect = UIEffectUtility.SetUIEffect(effectList[1], parentItem, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
end

function Task_TaskReward:AddCompleteEffect(task, parentItem, globalId)
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

function Task_TaskReward:CleanTaskEffect(taskId)
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

function Task_TaskReward:CleanAllPerTaskEffect()
  if self.perTaskEffeList then
    for k, v in pairs(self.perTaskEffeList) do
      if v.submitEffect ~= nil then
        v.submitEffect:Destroy()
        v.submitEffect = nil
      end
    end
    self.perTaskEffeList = {}
  end
end

function Task_TaskReward:CleanAllTaskEffect()
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

function Task_TaskReward:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_TaskReward:DefaultPageShow()
  if self.selectLevel == nil then
    self.selectLevel = TaskData.allMonsterLevel[1]
  end
  if self.selectLevel ~= nil and self.selectLevel >= self.monsterLevelIndex[1] then
    self:RefushPeriodicalReward()
    self:RefushCurLevelInfo(self.selectLevel)
    self.toggleGroup[self.selectLevel].toggle.isOn = true
  end
end

function Task_TaskReward:ClickTask()
  if self.args ~= nil and self.args.openFirstTab ~= nil and self.args.openFirstTab > 0 then
    self.selectLevel = self.monsterLevelIndex[self.args.openFirstTab]
    self.args = nil
  end
  if self.args ~= nil and self.args.openLevle ~= nil then
    self.selectLevel = self.args.openLevle
    self.args = nil
  end
end

function Task_TaskReward:RefushTableView()
  self.Content.transform.localPosition = Vector3(0, 0, 0)
end

function Task_TaskReward:RefushPeriodicalReward()
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  if periodicalTask ~= nil then
    local curReward = periodicalTask:GetRewards()
    for k, v in pairs(curReward) do
      local itemInfo = ItemUtility.GenerateItemData(k)
      itemInfo.count = v
      self.PeriodicalReward_Item.itemCellData = self.PeriodicalReward_Item.itemCellData or ItemCellData()
      self.PeriodicalReward_Item.itemCellData:Reset()
      self.PeriodicalReward_Item.itemCellData:RefreshData(itemInfo)
      ItemUtility.ShowItemCell(self.PeriodicalReward_Item, self.PeriodicalReward_Item.itemCellData, self)
    end
    if periodicalTask.state == TaskStateType.Submitted then
      self.Image_Received:SetActive(true)
    else
      self.Image_Received:SetActive(false)
      self.taskdes:SetText(periodicalTask:GetDes())
    end
    self:AddPerCompleteEffect(periodicalTask, self.PeriodicalReward, 2490006)
    self:ShowPeriodicalRewardRedPoint(periodicalTask)
  else
  end
end

function Task_TaskReward:ShowPeriodicalRewardRedPoint(periodicalTask)
  self.PeriodicalReward_Item:GetChild("img_redPoint"):SetActive(false)
  if periodicalTask:GetState() == TaskStateType.Completed then
    self.PeriodicalReward_Item:GetChild("img_redPoint"):SetActive(true)
  end
end

function Task_TaskReward:ShowPeriodicalReward()
  local periodicalTask = TaskData.GetPeriodicalTaskByLevel(self.selectLevel)
  if periodicalTask ~= nil then
    local isNotFinish = TaskData.GetCurMonsterLevelFinish(self.selectLevel)
    if not isNotFinish then
      if periodicalTask.state == TaskStateType.Completed then
        EventManager.Dispatch(Event.Task_BtnSubmitClick, periodicalTask:GetId())
      end
      if periodicalTask.state == TaskStateType.Submitted then
        print("\229\183\178\233\162\134\229\143\150\229\165\150\229\138\177")
      end
    else
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = periodicalTask:GetDes()
      })
    end
  end
end

function Task_TaskReward:OnHide()
end

function Task_TaskReward:OnDestroy()
  self:CleanAllTaskEffect()
  self:CleanAllPerTaskEffect()
end

function Task_TaskReward:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.OnHidePer)
  self.btn_close:SetOnClick(self, self.OnHidePer)
  self.PeriodicalReward_Item:SetOnClick(self, self.ShowPeriodicalReward)
  self.mapJump:SetOnClick(self, self.Btn_mapJump)
end

function Task_TaskReward:Btn_mapJump()
  local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_4")
  local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_1")
  local prompTipArgs = {
    title = title,
    textContent = titleStr,
    ok = function()
      PathFinderManager.FlyTransferScene(self.curJumpMapId)
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Task_TaskReward:OnHidePer()
  for k, v in pairs(self.monsterList) do
    v:DestroyGameObject()
  end
  self.monsterList = {}
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Task_TaskReward)
end

function Task_TaskReward:RegistEvents()
  self:RegistEvent(Event.UnionTask_Update, self.Refresh, self)
end

function Task_TaskReward:Refresh()
  self:ResetUI()
  self:GetPageList()
  if self.refushPageLevel ~= nil and #self.refushPageLevel > 0 then
    self.levelItemTemp:SetData(self.refushPageLevel)
  else
    self:OnHidePer()
    return
  end
  self:ClickTask()
  self:DefaultPageShow()
  self:RefushTableView()
end

function Task_TaskReward:GetPageList()
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

function Task_TaskReward:OnClickMonsterLevel(itemLevel, isOn)
  if isOn then
    if self.selectLevel ~= itemLevel.level then
      local levelTasks = TaskData.GetMonsterLevelTasks(itemLevel.level)
      if levelTasks and self.roleLevel >= itemLevel.level then
        self.selectLevel = itemLevel.level
        self:RefushCurLevelInfo(itemLevel.level)
        self:RefushPeriodicalReward()
        self:RefushTableView()
      else
        local titleStrCon = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_2")
        local titleStr = string.format(titleStrCon, itemLevel.level)
        FloatingWordUtility.QuickMsg(titleStr)
        self.toggleGroup[self.selectLevel].toggle.isOn = true
      end
    elseif self.toggleGroup[self.selectLevel] then
      self.toggleGroup[self.selectLevel].toggle.isOn = true
    end
  end
end

function Task_TaskReward:RefushCurLevelInfo(level)
  for k, v in pairs(self.monsterList) do
    v:SetHide()
  end
  local monsterLevelTable = ClientTable.cfg_Task_rewardManager:TryGetValue(level, "levelReward")
  self.lab_mapTitle:SetText(monsterLevelTable.jumpTxt)
  self.curJumpMapId = monsterLevelTable.mapID
  local curLevelMonsterTasks = TaskData.GetMonsterLevelTasks(level)
  if curLevelMonsterTasks ~= nil then
    self.levleBossItemTemp:SetData(curLevelMonsterTasks)
  end
  local genDropOutList = {}
  if RoleUtility.GetBasicCareer(ViewData.meData.career) == ERoleCareer.SwordMan then
    local curLevelDropOut = monsterLevelTable.previewWarrior
    local curDropOutList = string.split(curLevelDropOut, "#")
    for k, v in pairs(curDropOutList) do
      table.insert(genDropOutList, v)
    end
  end
  if RoleUtility.GetBasicCareer(ViewData.meData.career) == ERoleCareer.Magic then
    local curLevelDropOut = monsterLevelTable.previewMaster
    local curDropOutList = string.split(curLevelDropOut, "#")
    for k, v in pairs(curDropOutList) do
      table.insert(genDropOutList, v)
    end
  end
  if RoleUtility.GetBasicCareer(ViewData.meData.career) == ERoleCareer.Archer then
    local curLevelDropOut = monsterLevelTable.previewArcher
    local curDropOutList = string.split(curLevelDropOut, "#")
    for k, v in pairs(curDropOutList) do
      table.insert(genDropOutList, v)
    end
  end
  local genDropOut = monsterLevelTable.preview
  local genDrop = string.split(genDropOut, "#")
  for k, v in pairs(genDrop) do
    table.insert(genDropOutList, v)
  end
  LayoutRebuilder:ForceRebuildLayoutImmediate(self.DiaoLuoContent.rectTransform)
  self.dropRewardItemTemp:SetData(genDropOutList)
end

function Task_TaskReward:StartToDoTask(monsterTasks)
  self:OnHidePer()
  TaskData.SetClickLevelBossTask(monsterTasks:GetId())
  UIManager.Show(UIID.Instance_BossUI, {
    Monsterid = tonumber(monsterTasks:GetMonsterId())
  })
end

function Task_TaskReward:StartToDoCompleteTask(monsterTasks, level)
  EventManager.Dispatch(Event.Task_BtnSubmitClick, monsterTasks:GetId())
end

function Task_TaskReward:IsShowRedPoint(level)
  local isShow = false
  local taskTab = TaskData.GetMonsterLevelCompletedTasks(level)
  if taskTab and table.count(taskTab) > 0 then
    isShow = true
  end
  local task = TaskData.GetPeriodicalTaskByLevel(level)
  if not isShow and task and task:GetState() == TaskStateType.Completed then
    isShow = true
  end
  return isShow
end
