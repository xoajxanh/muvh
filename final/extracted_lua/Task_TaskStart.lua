Task_TaskStart = class(BaseUI)
Task_TaskStart.layer = UILayer.Dialog
Task_TaskStart.orderInLayer = 0
Task_TaskStart.hideType = UIHideType.WaitDestroy
Task_TaskStart.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TaskStart.escClose = UIEscClose.DontClose

function Task_TaskStart:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_shop/btn_close")
  self.StartContent = self:GetControl("StartContent")
  self.go_item = self:GetControl("StartContent/go_item")
  self.btn_3DItem = self:GetControl("StartContent/go_item/TaskContent/btn_3DItem")
  self.refushCount = self:GetControl("refushCount")
  self.ImageCost = self:GetControl("refushDiamond/ImageCost")
  self.refushDiamondNum = self:GetControl("refushDiamondNum")
  self.lab_number = self:GetControl("refushDiamondNum/lab_number")
  self.btn_obtain = self:GetControl("btn_obtain")
  self.plane_left = self:GetControl("plane_left")
  self.plane_right = self:GetControl("plane_right")
  self.btn_refresh = self:GetControl("btn_refresh")
  self.img_redPointre = self:GetControl("btn_refresh/img_redPointre")
  self.btn_refreshtask = self:GetControl("btn_refreshtask")
end

function Task_TaskStart:OnPreLoad()
end

function Task_TaskStart:Init()
  self.starFinishCount = nil
  self.starUpdatePropId = nil
  self.starUpdateCount = nil
  self.monsterList = {}
  self.taskEffeList = {}
  self.taskRefushEffeList = {}
end

function Task_TaskStart:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Task_TaskStart:InitUI()
  local starFinishCount = 2480001
  local starUpdatePropId = 2480002
  local starUpdateCount = 2480003
  self.starFinishCount = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(starFinishCount)
  self.starUpdatePropId = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(starUpdatePropId)
  self.starUpdateCount = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(starUpdateCount)
  self:InitContent()
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

local function InitTaskItemControls(ctr)
  ctr.bg = UIControl(ctr.transform)
  ctr.oneBg = UIControl(ctr.transform, "bg/onebg")
  ctr.twoBg = UIControl(ctr.transform, "bg/twobg")
  ctr.threeBg = UIControl(ctr.transform, "bg/threebg")
  ctr.Img_Icon = UIControl(ctr.transform, "Icon")
  ctr.oneStar = UIControl(ctr.transform, "starNum/one")
  ctr.twoStar = UIControl(ctr.transform, "starNum/two")
  ctr.threeStar = UIControl(ctr.transform, "starNum/three")
  ctr.name = UIControl(ctr.transform, "lab_name")
  ctr.img_leixing = UIControl(ctr.transform, "lab_name/img_leixing")
  ctr.map = UIControl(ctr.transform, "titlemap/lab_map")
  ctr.taskNum = UIControl(ctr.transform, "task_num")
  ctr.defNum = UIControl(ctr.transform, "lab_def")
  ctr.leaveTask = UIControl(ctr.transform, "btn_Leave")
  ctr.out = UIControl(ctr.transform, "btn_out")
  ctr.completeTask = UIControl(ctr.transform, "btn_Complete")
  ctr.lingQuTask = UIControl(ctr.transform, "btn_lingqu")
  ctr.btn_lingqugrey = UIControl(ctr.transform, "btn_lingqugrey")
  ctr.taskRewardContent = UIControl(ctr.transform, "TaskContent/btn_3DItem")
end

local function ItemTaskRefresh(ctr, _, starTask, ui)
  if not ctr.rewardItemTemp then
    ctr.rewardItemTemp = UIContainer(ctr.taskRewardContent, ui, InitRewardItemControls, ItemRewardRefresh)
  end
  local rewards = starTask:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    table.insert(allRewards, {itemID = k, itemNum = v})
  end
  ctr.rewardItemTemp:SetData(allRewards)
  local starLevel = starTask:GetStar()
  ctr.oneStar:SetActive(starLevel == StarTaskLevel.OneStar or starLevel == StarTaskLevel.TwoStar or starLevel == StarTaskLevel.ThreeStar)
  ctr.twoStar:SetActive(starLevel == StarTaskLevel.TwoStar or starLevel == StarTaskLevel.ThreeStar)
  ctr.threeStar:SetActive(starLevel == StarTaskLevel.ThreeStar)
  ctr.oneBg:SetActive(starLevel == StarTaskLevel.OneStar)
  ctr.twoBg:SetActive(starLevel == StarTaskLevel.TwoStar)
  ctr.threeBg:SetActive(starLevel == StarTaskLevel.ThreeStar)
  local show = string.format("%s<size=14> Lv.%s</size>", starTask:GetMonster()[1].monsterTbl.name, starTask:GetMonster()[1].monsterTbl.showLevel)
  ctr.name:SetText(show)
  ctr.img_leixing:SetActive(starTask:GetMonster()[1].monsterTbl.danger == 1)
  ctr.map:SetText(starTask:GetTaskMonsterMapName())
  ctr.taskNum:SetText(starTask:GetTaskMonsterProgress())
  ctr.defNum:SetText(starTask:GetStarDef())
  local taskState = starTask:GetState()
  ctr.leaveTask:SetActive(taskState == TaskStateType.Accept)
  ctr.out:SetActive(taskState == TaskStateType.Accept)
  ctr.completeTask:SetActive(taskState == TaskStateType.Completed)
  ctr.lingQuTask:SetActive(taskState == TaskStateType.Acceptable)
  local isProgress = TaskData.IsStarTaskProgress() and taskState == TaskStateType.Acceptable
  if isProgress or ui.curRefushTaskCount >= tonumber(ui.starFinishCount) then
    ctr.btn_lingqugrey:SetActive(true)
    ctr.lingQuTask:SetActive(false)
  else
    ctr.btn_lingqugrey:SetActive(false)
  end
  ctr.lingQuTask:SetOnClick(ui, function()
    ui:LingQuTask(starTask)
  end)
  ctr.btn_lingqugrey:SetOnClick(ui, function()
    if isProgress then
      local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskStar_01")
      FloatingTipUtility.QuickMsg(titleStr)
    end
    if ui.curRefushTaskCount >= tonumber(ui.starFinishCount) then
      ui:LingQuTask(starTask)
    end
  end)
  ctr.leaveTask:SetOnClick(ui, function()
    ui:ToDoTask(starTask)
  end)
  ctr.out:SetOnClick(ui, function()
    ui:GivdUpTask(starTask)
  end)
  ctr.completeTask:SetOnClick(ui, function()
    ui:CompleteTask(starTask)
  end)
  local position = string.split(GlobalConfig.GetGlobalConfig(2480005), "#")
  local scale = GlobalConfig.GetGlobalConfig(2480007)
  local config = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(starTask:GetMonsterId()), "id")
  if not string.isNullOrEmpty(config) and tonumber(config.TaskStarScale) > 0 then
    scale = config.TaskStarScale
  end
  local rotation = string.split(GlobalConfig.GetGlobalConfig(2480006), "#")
  if ui.monsterList[starTask:GetId()] then
    local monster = ui.monsterList[starTask:GetId()]
    monster:SetActive(true)
    monster:SetParent(ctr.Img_Icon.transform)
    monster:SetLocalPosition(Vector3(position[1], position[2], position[3]))
    monster:SetLocalScale(Vector3(scale, scale, scale))
    monster:SetLocalRotate(Vector3(rotation[1], rotation[2], rotation[3]))
  else
    local monster = UIMonsterUtility(starTask:GetMonsterId(), ctr.Img_Icon.transform, Vector3(scale, scale, scale), Vector3(position[1], position[2], position[3]), Vector3(rotation[1], rotation[2], rotation[3]))
    monster:SetActive(true)
    ui.monsterList[starTask:GetId()] = monster
  end
  ui:AddCompleteEffect(starTask, ctr.completeTask)
  ui:AddRefushEffect(starTask, ctr)
end

function Task_TaskStart:InitContent()
  self.taskItemTemp = UIContainer(self.go_item, self, InitTaskItemControls, ItemTaskRefresh)
end

function Task_TaskStart:AddCompleteEffect(task, parentItem)
  if task.state ~= TaskStateType.Completed and self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    self:CleanAllTaskEffect(task:GetId())
    return
  end
  if task.state ~= TaskStateType.Completed then
    return
  end
  local effectInfo = GlobalConfig.GetGlobalConfig(2480008)
  if effectInfo == nil or effectInfo == "" then
    return
  end
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    return
  end
  local effectList = string.split(effectInfo, "&")
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local scaleList = string.split(effectList[2], "#")
  self.taskEffeList[task.taskId].submitEffect = UIEffectUtility.SetUIEffect(effectList[1], parentItem, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
end

function Task_TaskStart:AddRefushEffect(task, parentItem)
  if task.state ~= TaskStateType.Acceptable and self.taskRefushEffeList[task.taskId] ~= nil and self.taskRefushEffeList[task.taskId].refushEffect ~= nil then
    self:CleanRefushTaskEffect(task:GetId())
    return
  end
  if task.state ~= TaskStateType.Acceptable then
    return
  end
  local effectInfo = GlobalConfig.GetGlobalConfig(2480009)
  if effectInfo == nil or effectInfo == "" then
    return
  end
  if self.taskRefushEffeList[task.taskId] ~= nil and self.taskRefushEffeList[task.taskId].refushEffect ~= nil then
    return
  end
  local effectList = string.split(effectInfo, "&")
  if self.taskRefushEffeList[task.taskId] == nil then
    self.taskRefushEffeList[task.taskId] = {}
  end
  local scaleList = string.split(effectList[2], "#")
  self.taskRefushEffeList[task.taskId].refushEffect = UIEffectUtility.SetUIEffect(effectList[1], parentItem, true, Vector3(scaleList[1], scaleList[2], scaleList[3]))
end

function Task_TaskStart:CleanTaskEffect(taskId)
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

function Task_TaskStart:CleanAllTaskEffect()
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

function Task_TaskStart:CleanRefushTaskEffect(taskId)
  for k, v in pairs(self.taskRefushEffeList) do
    if k == taskId and v.refushEffect ~= nil then
      v.refushEffect:Destroy()
      v.refushEffect = nil
    end
    if TaskData.AllTasks[k] == nil and v.refushEffect ~= nil then
      v.refushEffect:Destroy()
      v.refushEffect = nil
    end
  end
end

function Task_TaskStart:CleanRefushAllTaskEffect()
  for k, v in pairs(self.taskRefushEffeList) do
    if v.refushEffect ~= nil then
      v.refushEffect:Destroy()
      v.refushEffect = nil
    end
  end
  self.taskRefushEffeList = {}
end

function Task_TaskStart:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_TaskStart:OnHide()
end

function Task_TaskStart:OnDestroy()
  self:CleanAllTaskEffect()
end

function Task_TaskStart:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.OnHidePanel)
  self.btn_close:SetOnClick(self, self.OnHidePanel)
  self.btn_3DItem:SetOnClick(self, self.btn_ItemOnClick)
  self.go_modelData = ItemCellData()
  self.btn_obtain:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Task_TaskStart:OnHidePanel()
  for k, v in pairs(self.monsterList) do
    v:DestroyGameObject()
  end
  self.monsterList = {}
  UIManager.Hide(UIID.Task_TaskStart)
end

function Task_TaskStart:btn_ItemOnClick(control)
end

function Task_TaskStart:RegistEvents()
  self:RegistEvent(Event.StarTask_Update, self.Refresh, self)
  self:RegistEvent(Event.StarTask_Count, self.Refresh, self)
  self:RegistEvent(Event.Bag_ResUseItem, self.RefushPropItem, self)
  self:RegistEvent(Event.Bag_ResBagInfo, self.RefushPropItem, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefushPropItem, self)
end

function Task_TaskStart:RefushTaskCount()
  local refresh = RefreshData.TaskStarCount
  if refresh == nil then
    refresh = {}
    refresh.count = 0
  end
  self.curRefushTaskCount = refresh.count
  self.refushCount:SetText(refresh.count .. "/" .. self.starFinishCount)
end

function Task_TaskStart:Refresh()
  self:CleanAllTaskEffect()
  self:RefushTaskCount()
  self:RefushPropItem()
  for k, v in pairs(self.monsterList) do
    v:SetHide()
  end
  local curStarTask = TaskData.GetStarTask()
  if curStarTask ~= nil then
    self.taskItemTemp:SetData(curStarTask)
  end
end

function Task_TaskStart:RefushPropItem()
  local itemData = string.split(self.starUpdatePropId, "#")
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(itemData[1]))
  local cfg_Global = ClientTable.cfg_Global_globalManager:TryGetValue(2480002, "id")
  local moneyItemId
  if cfg_Global then
    local moneyArray = string.split(cfg_Global.effect, "#")
    if 2 <= #moneyArray then
      moneyItemId = tonumber(moneyArray[1])
      local cfg_Item = ClientTable.cfg_Item_itemManager:TryGetValue(moneyItemId, "id")
      if cfg_Item then
        self:SetSprite("Atlas_Common", cfg_Item.icon, self.ImageCost, false)
      end
    end
  end
  if bagCount >= tonumber(itemData[2]) then
    local count = string.format("<color=#1add1f>%s</color>", Mathf.NumberShowFormat(bagCount, 1))
    self.refushDiamondNum:SetText(count)
    local countSum = string.format("<color=white>/%s</color>", Mathf.NumberShowFormat(tonumber(itemData[2]), 1))
    self.lab_number:SetText(countSum)
  else
    local count = string.format("<color=red>%s</color>", Mathf.NumberShowFormat(bagCount, 1))
    self.refushDiamondNum:SetText(count)
    local countSum = string.format("<color=white>/%s</color>", Mathf.NumberShowFormat(tonumber(itemData[2]), 1))
    self.lab_number:SetText(countSum)
  end
  local obtainItemData = ItemUtility.GenerateItemData(tonumber(itemData[1]))
  self.btn_obtain.itemData = obtainItemData
  local isProgress = TaskData.IsStarTaskProgress()
  if self.curRefushTaskCount >= tonumber(self.starFinishCount) or isProgress or TaskData.AllTasks[10034] then
    self.btn_refresh:SetActive(false)
    self.btn_refreshtask:SetActive(true)
  else
    self.btn_refresh:SetActive(true)
    self.btn_refreshtask:SetActive(false)
  end
  self.btn_refresh:SetOnClick(self, function()
    if 0 < bagCount then
      self:CleanRefushAllTaskEffect()
    end
    if bagCount >= tonumber(itemData[2]) then
      NetManager.Send(TaskMessage.ReqFlushTask)
    else
      local itemData1 = ItemUtility.GenerateItemData(tonumber(itemData[1]))
      self.btn_refresh.itemData = itemData1
      self.btn_refresh:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
    end
  end)
  self.btn_refreshtask:SetOnClick(self, function()
    if TaskData.AllTasks[10034] then
      local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskStar_03")
      FloatingTipUtility.QuickMsg(titleStr)
      return
    end
    if isProgress then
      local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskStar_02")
      FloatingTipUtility.QuickMsg(titleStr)
    end
    if self.curRefushTaskCount >= tonumber(self.starFinishCount) then
      local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskStar_04")
      FloatingTipUtility.QuickMsg(titleStr)
    end
  end)
end

function Task_TaskStart:LingQuTask(starTask)
  EventManager.Dispatch(Event.Task_BtnAcceptClick, starTask:GetId())
end

local function AutoFight()
  RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
end

function Task_TaskStart:ToDoTask(starTask)
  if table.count(starTask.goals) >= 1 then
    local goal = ClientTable.cfg_Task_goalManager:TryGetValue(starTask.goals[1].goalTbl.goalId, "goalId")
    if goal ~= nil then
      PathFinderManager.JumpMapToMovePosByTransferId(tonumber(goal.transferId), nil, nil, nul, AutoFight)
    end
  end
end

function Task_TaskStart:GivdUpTask(starTask)
  EventManager.Dispatch(Event.Task_BtnGiveUpClick, starTask:GetId())
end

function Task_TaskStart:CompleteTask(starTask)
  self:OnHidePanel()
  self:CleanRefushAllTaskEffect()
  if TaskData.AllTasks[10034] then
    self:OnHidePanel()
  end
  EventManager.Dispatch(Event.Task_BtnSubmitClick, starTask:GetId())
end
