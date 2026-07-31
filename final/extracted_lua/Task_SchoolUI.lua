Task_SchoolUI = class(BaseUI)
Task_SchoolUI.layer = UILayer.Panel
Task_SchoolUI.orderInLayer = 3
Task_SchoolUI.hideType = UIHideType.WaitDestroy
Task_SchoolUI.hideFunc = UIHideFunc.MoveOutOfScreen
Task_SchoolUI.escClose = UIEscClose.DontClose

function Task_SchoolUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("bg_school/btn_close")
  self.togContent = self:GetControl("sw_chapterList_new/Viewport/Content")
  self.tog_firstChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_firstChapter")
  self.tog_secondChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_secondChapter")
  self.tog_thirdChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_thirdChapter")
  self.tog_fourthChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_fourthChapter")
  self.tog_fifthChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_fifthChapter")
  self.tog_sixthChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_sixthChapter")
  self.tog_seventhChapter = self:GetControl("sw_chapterList_new/Viewport/Content/tog_seventhChapter")
  self.reward = self:GetControl("Rerward")
  self.rewardbtn_Item = self:GetControl("Rerward/rewardbtn_Item")
  self.rewardbtn_get = self:GetControl("Rerward/rewardbtn_get")
  self.lab_received = self:GetControl("Rerward/lab_received")
  self.bg_task = self:GetControl("go_taskEight_new/Viewport/Content/bg_task")
  self.img_item = self:GetControl("go_taskEight_new/Viewport/Content/bg_task/img_item")
  self.btn_bigAngel = self:GetControl("bg_school/btn_bigAngel")
end

function Task_SchoolUI:OnPreLoad()
end

function Task_SchoolUI:Init()
  self.taskidGrop, self.Subtypetask, self.SubTypeidGrop, self.RewardItem = CommercializeData.GetTaskSchoolInfo()
  self.Schoolinfo = {}
  self.Rewardinfo = {}
end

function Task_SchoolUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRerTogRefresh(ctr, _, data, ui)
  ctr.togger = UIControl(ctr.transform)
  ctr.img_clickeffect = UIControl(ctr.transform, "img_clickeffect")
  ctr.img_suo = UIControl(ctr.transform, "img_suo")
  ctr.img_get = UIControl(ctr.transform, "img_get")
  ctr.go_model = UIControl(ctr.transform, "go_model")
  ui.Toggrop[_] = ctr
  ctr.togger.img_clickeffect = ctr.img_clickeffect
  ctr.togger.img_suo = ctr.img_suo
  ctr.togger.index = _
  ctr.img_clickeffect:SetActive(false)
  ctr.togger:SetOnToggleChanged(ui, ui.tog_firstChapterOnChanged)
  local itemdata
  if ui.RewardItem then
    local meetRewards = CommercializeData.GetMeetConditionBoxTbl(ui.RewardItem[_])
    if meetRewards and table.count(meetRewards) then
      itemdata = meetRewards[1]
    end
  end
  local itemData
  if itemdata ~= nil then
    local itemData = ItemUtility.GenerateItemData(itemdata.itemId)
    ctr.togger.itemData = itemData
  else
    print("\233\148\153\232\175\175\239\188\129\239\188\129\239\188\129 itemdata==nil")
  end
end

local function OnRerwardRefresh(ctr, data, ui)
  if not ctr.itemCtr then
    ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
    ctr.modelData = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(data.id)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function OnTaskCreat(taskUI)
  taskUI.img_item = UIControl(taskUI.transform, "img_item")
  taskUI.itemCtr = ItemUtility.InitItemCell(UIControl(taskUI.img_item.transform))
  taskUI.modelData = ItemCellData()
  taskUI.lab_TaskDes = UIControl(taskUI.transform, "lab_TaskDes")
  taskUI.lab_TaskProgress = UIControl(taskUI.transform, "lab_TaskProgress")
  taskUI.btn_go = UIControl(taskUI.transform, "btn_go")
  taskUI.btn_reward = UIControl(taskUI.transform, "btn_reward")
  taskUI.lab_TaskState = UIControl(taskUI.transform, "lab_TaskState")
end

local function OnTaskRefresh(taskUI, _, data, ui)
  local name = data.name
  if string.contains(data.name, "&") then
    local nameGrop = string.split(data.name, "&")
    for i, v in pairs(nameGrop) do
      local namecond = string.split(v, "*")
      if ConditionManager.Check(namecond[1]) then
        name = namecond[2]
      end
    end
  end
  taskUI.lab_TaskDes:SetText(name)
  local goal1 = data.goals[1]
  local finishCount
  local Goalsfinish = false
  for i, Goal in pairs(data.goals) do
    if Goal.finishCount >= Goal.goalTbl.goalCount then
      Goalsfinish = true
      break
    end
  end
  if Goalsfinish then
    taskUI.btn_go:SetActive(false)
    taskUI.btn_reward:SetActive(data.state == TaskStateType.Completed)
    taskUI.lab_TaskState:SetActive(data.state == TaskStateType.Submitted)
    finishCount = "#3CD937"
    taskUI.btn_reward.taskid = data.taskId
    taskUI.btn_reward:SetOnClick(ui, ui.rewardbtn_getOnClick)
  else
    taskUI.btn_reward:SetActive(false)
    taskUI.btn_go:SetActive(true)
    taskUI.lab_TaskState:SetActive(false)
    finishCount = "#ED2E2E"
    if data.isNavigationFlag then
      taskUI.btn_go.OpenUI = data.navigationList[1]
    else
      taskUI.btn_go.OpenUI = nil
    end
    if table.count(data.transferId) == 2 then
      taskUI.btn_go.goalTbl = data.goalTbl
    else
      taskUI.btn_go.goalTbl = nil
    end
    taskUI.btn_go.id = data.taskId
    taskUI.btn_go:SetOnClick(ui, ui.TaskItemOnclick)
  end
  local text
  if 1 < #data.goals then
    local pass = Goalsfinish and 1 or 0
    text = string.format("%s/%s", string.GetColorText(pass, finishCount), 1)
  else
    text = string.format("%s/%s", string.GetColorText(goal1.finishCount, finishCount), goal1.goalTbl.goalCount)
  end
  taskUI.lab_TaskProgress:SetText(text)
  local rewardid = data.taskTbl.rewards
  local rewarddata = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(rewardid))[1]
  local itemData = ItemUtility.GenerateItemData(rewarddata.itemId)
  itemData.count = rewarddata.count
  taskUI.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(taskUI.itemCtr, taskUI.modelData, ui, true)
end

function Task_SchoolUI:InitUI()
  self.Toggrop = {}
  self.TaskContainer = UIContainer(self.bg_task, self, OnTaskCreat, OnTaskRefresh)
  self.TogIndex = #self.taskidGrop
end

function Task_SchoolUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Task_SchoolUI:OnHide()
end

function Task_SchoolUI:OnDestroy()
end

function Task_SchoolUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.rewardbtn_get:SetOnClick(self, self.rewardbtn_getOnClick)
  self.btn_bigAngel:SetOnClick(self, self.Btn_bigAngelOnClick)
end

function Task_SchoolUI:Btn_bigAngelOnClick(control)
  local cfg = ClientTable.cfg_Global_globalManager:GetSchoolModelList()
  if cfg then
    local data = {}
    data.type = "Task_SchoolUI"
    data.context = cfg
    UIManager.Show(UIID.Tip_TaskUI, data)
  end
end

function Task_SchoolUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Task_SchoolUI)
end

function Task_SchoolUI:rewardbtn_getOnClick(control)
  EventManager.Dispatch(Event.Task_BtnSubmitClick, control.taskid)
end

function Task_SchoolUI:tog_firstChapterOnChanged(control, eventData)
  control.img_clickeffect:SetActive(eventData)
  if eventData then
    local rewards = self.Rewardinfo[control.index]
    if rewards.reward and table.count(rewards.reward) > 0 then
      local itemData = ItemUtility.GenerateItemData(rewards.reward[1].id)
      if itemData and itemData.tblItem then
        if self.rewardbtn_Item.cellData == nil then
          self.rewardbtn_Item.cellData = ItemCellData()
        end
        self.rewardbtn_Item.cellData:RefreshData(itemData)
        ItemUtility.ShowItemCell(self.rewardbtn_Item, self.rewardbtn_Item.cellData, self, true)
        self.rewardbtn_Item.itemData = itemData
      end
    end
    self.lab_received:SetActive(false)
    if rewards.state == TaskStateType.Accept then
      self.rewardbtn_get:SetActive(false)
    elseif rewards.state == TaskStateType.Completed then
      self.rewardbtn_get.taskid = rewards.taskId
      self.rewardbtn_get:SetActive(true)
    elseif rewards.state == TaskStateType.Submitted then
      self.rewardbtn_get:SetActive(false)
      self.lab_received:SetActive(true)
    end
    self.btn_bigAngel:SetActive(rewards.state == TaskStateType.Accept)
    self.TaskContainer:SetData(self.Schoolinfo[control.index])
  end
end

function Task_SchoolUI:TaskItemOnclick(control)
  if control.OpenUI then
    self:btn_closeOnClick()
    if control.OpenUI.btnCondition == TaskAddBarType.WarAllianceTaskConditions then
      if WarAllianceData.IsHaveUnion and GradData.GoToNavi(control.OpenUI) then
        NavigationUtility.OpenPanel(control.OpenUI)
      end
    else
      if GradData.GoToNavi(control.OpenUI) then
        NavigationUtility.ClickNavigation(control.OpenUI)
      end
      return
    end
  end
  TaskManager.TaskGo(control.id, TaskTriggeringConditionType.OnClick)
  self:btn_closeOnClick()
end

function Task_SchoolUI:RegistEvents()
  self:RegistEvent(Event.TaskData_Update, self.RefreshTask, self)
  self:RegistEvent(Event.MiracleTask_Update, self.Refreshtask, self)
end

local lastkey = {}
local ordKey = {}

function Task_SchoolUI:RefreshTask(id, task)
  local magtask = task.tasks
  for i, v in pairs(ordKey) do
    local ord = true
    for j = 1, #magtask do
      if magtask[j].taskId == i then
        local taskid = magtask[j].taskId
        local state = ordKey[taskid]
        if state and state == TaskStateType.Completed and state ~= magtask[j].state then
          self:Refresh()
          ord = false
        end
      end
    end
    if ord then
      self:Refresh()
    end
  end
  local key = {}
  local refresh = true
  for k = 1, #magtask do
    for i, v in pairs(self.taskidGrop) do
      if magtask[k].taskId == v then
        refresh = false
        table.insert(key, v)
        if #key == 1 then
          self:Refresh()
        end
      end
    end
  end
  if #key ~= #lastkey then
    self:Refresh()
    lastkey = key
    return
  else
    local mun = #key
    if mun ~= 0 then
      table.sort(key)
      table.sort(lastkey)
      for i = 1, mun do
        if key[i] ~= lastkey[i] then
          self:Refresh()
          lastkey = key
          return
        end
      end
    end
  end
  lastkey = key
end

function Task_SchoolUI:Refreshtask(id, task)
  if not task then
    return
  end
  for i, v in pairs(self.SubTypeidGrop) do
    if task == v then
      self:Refresh()
      break
    end
  end
  for i, v in pairs(self.taskidGrop) do
    if task == v then
      self:Refresh()
      break
    end
  end
end

local function tasksort(tabledata)
  local count = #tabledata
  local acc = 0
  for i = 1, count do
    i = i + acc
    if tabledata[i].state == TaskStateType.Submitted then
      table.insert(tabledata, tabledata[i])
      table.remove(tabledata, i)
      acc = acc - 1
    elseif tabledata[i].state == TaskStateType.Completed then
      table.insert(tabledata, 1, tabledata[i])
      table.remove(tabledata, i + 1)
    end
  end
end

function Task_SchoolUI:RefreshData()
  local Schoolinfo = TaskData.instituteMiracleTasks
  ordKey = {}
  lastkey = {}
  for k = 1, #Schoolinfo do
    local taskId = Schoolinfo[k].taskId
    local ord = true
    for i, v in pairs(self.taskidGrop) do
      if taskId == v then
        ord = false
        table.insert(lastkey, v)
      end
    end
    if ord then
      ordKey[taskId] = Schoolinfo[k].state
    end
  end
  self.Msgindex = self.TogIndex
  if table.count(Schoolinfo) == 0 then
    for i = 1, #self.taskidGrop do
      self.Schoolinfo[i] = {}
      local Subtypetask = self.Subtypetask[self.taskidGrop[i]]
      for k, v in pairs(Subtypetask) do
        local taskdata = CommercializeData.GetCompletedTaskSchool(v)
        self.Schoolinfo[i][k] = taskdata
      end
      self.Rewardinfo[i] = CommercializeData.GetRewardSchoolinfo(self.taskidGrop[i], TaskStateType.Submitted)
    end
    return
  end
  local pageid
  for i, v in pairs(Schoolinfo) do
    local Reward = true
    for k = 1, #self.taskidGrop do
      if self.taskidGrop[k] == v.taskId then
        Reward = false
      end
    end
    if Reward and v.state == TaskStateType.Accept then
      pageid = v.subType
      break
    end
  end
  if pageid then
    for k = 1, #self.taskidGrop do
      if self.taskidGrop[k] == pageid then
        self.Msgindex = k
      end
    end
  else
    self.Msgindex = self.TogIndex
  end
  local alltask = TaskData.AllTasks
  for i = 1, self.Msgindex do
    self.Schoolinfo[i] = {}
    local pagetask = self.Subtypetask[self.taskidGrop[i]]
    local rewardstate = TaskStateType.Submitted
    for k = 1, #pagetask do
      if alltask[pagetask[k]] then
        if alltask[pagetask[k]].state ~= TaskStateType.Submitted then
          rewardstate = TaskStateType.Accept
        end
        self.Schoolinfo[i][k] = alltask[pagetask[k]]
      else
        self.Schoolinfo[i][k] = CommercializeData.GetCompletedTaskSchool(pagetask[k])
      end
      if k == #pagetask then
        tasksort(self.Schoolinfo[i])
      end
    end
    if alltask[self.taskidGrop[i]] then
      self.Rewardinfo[i] = alltask[self.taskidGrop[i]]
      self.Rewardinfo[i].reward = {}
      for k, v in pairs(self.Rewardinfo[i].rewards) do
        table.insert(self.Rewardinfo[i].reward, {id = k, count = v})
      end
    else
      self.Rewardinfo[i] = CommercializeData.GetRewardSchoolinfo(self.taskidGrop[i], rewardstate)
    end
  end
end

function Task_SchoolUI:RefreshShow()
  self:RefreshToggleView()
  local togshow = self.Msgindex
  for i = 1, togshow do
    self.Toggrop[i]:SetInteractable(true)
    self.Toggrop[i].img_suo:SetActive(false)
    self:RefrshToggleModel(self.Toggrop[i], true)
  end
  local reward = #self.Rewardinfo
  for i = togshow + 1, reward do
    self.Toggrop[i]:SetInteractable(false)
    self.Toggrop[i].img_suo:SetActive(true)
    self:RefrshToggleModel(self.Toggrop[i], false)
  end
  if lastkey[1] then
    for i, v in pairs(self.taskidGrop) do
      if lastkey[1] == v then
        togshow = i
      end
    end
  end
  self.Toggrop[togshow].toggle.isOn = true
  self.Toggrop[togshow].index = togshow
  self:tog_firstChapterOnChanged(self.Toggrop[togshow], true)
  if 6 < togshow then
    self.togContent:SetAnchoredPosition(0, (togshow - 6) * 75)
  else
    self.togContent:SetAnchoredPosition(0, 0)
  end
end

function Task_SchoolUI:RefrshToggleModel(ctr, isShow)
  if ctr.go_model ~= nil then
    ctr.go_model:SetActive(isShow)
  end
  if isShow and ctr.togger and ctr.togger.itemData and ctr.togger.itemData.tblItem then
    if ctr.cellData == nil then
      ctr.cellData = ItemCellData()
    end
    ctr.cellData:RefreshData(ctr.togger.itemData)
    ItemUtility.ShowItemCell(ctr, ctr.cellData, self, false)
  end
end

function Task_SchoolUI:Refresh()
  self:RefreshData()
  self:RefreshShow()
end

function Task_SchoolUI:RefreshToggleView()
  if RoleManager.me and self.career ~= RoleUtility.GetBasicCareer(RoleManager.me.career) then
    OnRerTogRefresh(self.tog_firstChapter, 1, self.taskidGrop[1], self)
    OnRerTogRefresh(self.tog_secondChapter, 2, self.taskidGrop[2], self)
    OnRerTogRefresh(self.tog_thirdChapter, 3, self.taskidGrop[3], self)
    OnRerTogRefresh(self.tog_fourthChapter, 4, self.taskidGrop[4], self)
    OnRerTogRefresh(self.tog_fifthChapter, 5, self.taskidGrop[5], self)
    OnRerTogRefresh(self.tog_sixthChapter, 6, self.taskidGrop[6], self)
    OnRerTogRefresh(self.tog_seventhChapter, 7, self.taskidGrop[7], self)
    self.career = RoleUtility.GetBasicCareer(RoleManager.me.career)
  end
end
