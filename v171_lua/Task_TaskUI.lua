Task_TaskUI = class(BaseUI)
Task_TaskUI.layer = UILayer.Background
Task_TaskUI.orderInLayer = 2
Task_TaskUI.hideType = UIHideType.Hide
Task_TaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TaskUI.escClose = UIEscClose.DontClose

function Task_TaskUI:InitControls()
  self.RootPanel = self:GetControl("RootPanel")
  self.subPanel = self:GetControl("RootPanel/subPanel")
  self.TaskPanel = self:GetControl("RootPanel/subPanel/TaskPanel")
  self.Content = self:GetControl("RootPanel/subPanel/TaskPanel/Viewport/Content")
  self.btn_TaskItem = self:GetControl("RootPanel/subPanel/TaskPanel/Viewport/Content/btn_TaskItem")
  self.img_taskSubmit = self:GetControl("RootPanel/subPanel/TaskPanel/Viewport/Content/btn_TaskItem/taskSubmit/img_taskSubmit")
  self.effectMask = self:GetControl("RootPanel/subPanel/TaskPanel/effectMask")
  self.naviRoot = self:GetControl("RootPanel/naviRoot")
  self.navigation = self:GetControl("RootPanel/naviRoot/navigation")
  self.btnNavi = self:GetControl("RootPanel/naviRoot/navigation/btnNavi")
  self.arrow = self:GetControl("RootPanel/naviRoot/arrow")
end

function Task_TaskUI:Init()
  self:TaskPanelInit()
end

function Task_TaskUI:TaskPanelInit()
  self.contentPosList = {}
  self.taskEffeList = {}
  self.hideMainUI = false
  self.mainShowTaskEffect = {}
  self:InitConfigWord()
  self.reminder = {}
end

local titleStr

function Task_TaskUI:InitConfigWord()
  self.acceptableState = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskAccept")
  self.acceptState = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskConduct")
  self.completeState = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskComplete")
  titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_3")
end

function Task_TaskUI:RootPanelState(state)
  self.RootPanel:SetActive(state)
end

function Task_TaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
end

local curSelectEffect, Effect, EffTimer, EffSpeedTimer

local function DestroyEffect()
  Effect:Destroy()
  Effect = nil
  if EffTimer ~= nil then
    Timer.Stop(EffTimer)
    EffTimer = nil
  end
end

local function DestroyEffectSpeed()
  if EffSpeedTimer then
    Timer.Stop(EffSpeedTimer)
    EffSpeedTimer = nil
  end
end

local function SetEffect(parent)
  if Effect ~= nil then
    DestroyEffect()
    DestroyEffectSpeed()
  end
  Effect = CS.Framework.GameModel("TaskEff", SkillMgr.ROOT, function(go, name)
  end)
  Effect:LoadAsync("Effect/UI/Eff_UI_renwu_dianji.prefab")
  Effect.transform:SetParent(parent.transform)
  Effect.transform.localPosition = Vector3(0, 0, 0)
  Effect.transform.localScale = Vector3(2, 2.1, 0)
  
  local function EffectActive()
    DestroyEffect()
  end
  
  EffTimer = Timer.StartLoopForever(3, EffectActive)
end

local function InitTaskItemControls(item)
  item.taskTypeSp = UIControl(item.transform, "bg_TaskType")
  item.taskState = UIControl(item.transform, "bg_TaskState")
  item.labTaskState = UIControl(item.transform, "lab_TaskState")
  item.taskDes = UIControl(item.transform, "lab_TaskDes")
  item.taskProgress = UIControl(item.transform, "lab_TaskProgress")
  item.taskHelpSp = UIControl(item.transform, "bg_help")
  item.img_taskSubmit = UIControl(item.transform, "taskSubmit/img_taskSubmit")
  item.lab_taskSubmit = UIControl(item.transform, "lab_taskSubmit")
end

local function ItemTaskRefresh(ctr, k, task, ui)
  ui.contentPosList[task.taskId] = ctr
  GuideUtility.AddCreatObjInTask("Task_TaskUI", ctr, task.taskId, k)
  
  local function ClickTask()
    if task:GetNavi() and task:GetState() == TaskStateType.Accept then
      ui:IsShowNavigation(task.taskId, ctr, ui)
    else
      ui:TaskItemClick(task.taskId)
    end
    if curSelectEffect ~= nil then
      curSelectEffect:Destroy()
      curSelectEffect = nil
    end
    SetEffect(ctr.gameObject.transform)
  end
  
  ctr:SetOnClick(ui, ClickTask)
  if not ctr.spriteAtlas then
    ctr.spriteIconAtlas = ui:LoadAsset("Texture/Atlas_Language.spriteatlas", typeof(CS.UnityEngine.U2D.SpriteAtlas))
    ctr.spriteAtlas = ui:LoadAsset("Texture/Atlas_Main.spriteatlas", typeof(CS.UnityEngine.U2D.SpriteAtlas))
  end
  local typeSprite, bgSprite
  if ctr.spriteIconAtlas ~= nil and ctr.spriteAtlas ~= nil and task:GetTaskType() ~= nil then
    typeSprite = ctr.spriteIconAtlas:GetSprite(tostring(string.format("img_task%s", task:GetTaskTypeName())))
    bgSprite = ctr.spriteAtlas:GetSprite(tostring(string.format("bg_task%s", task:GetTaskType())))
  end
  ctr:SetSprite(bgSprite)
  ctr.taskTypeSp:SetSprite(typeSprite)
  ctr.taskState:SetActive(false)
  ctr.labTaskState:SetActive(true)
  local state = task:GetState()
  if task:GetTaskTypeID() == RoleTaskType.UnionTask then
    ctr.labTaskState:SetText(state == TaskStateType.Accept and "" or state == TaskStateType.Acceptable and "" or state == TaskStateType.Completed and ui.completeState)
    if state == TaskStateType.Accept then
      if task:GetLevelBossFlag() then
        ctr.taskDes:SetText(task:GetDes())
        ctr.taskProgress:SetText("0/1")
      else
        ctr.taskDes:SetText(titleStr)
        ctr.taskProgress:SetText("")
      end
    end
    if state == TaskStateType.Acceptable then
      ctr.taskDes:SetText(titleStr)
      ctr.taskProgress:SetText("")
    end
    if state == TaskStateType.Submitted then
      ctr.taskDes:SetText(titleStr)
      ctr.taskProgress:SetText("")
    end
    if state == TaskStateType.Completed then
      ctr.taskDes:SetText(titleStr)
      ctr.taskProgress:SetText("")
    end
  else
    ctr.labTaskState:SetText(state == TaskStateType.Accept and ui.acceptState or state == TaskStateType.Acceptable and ui.acceptableState or state == TaskStateType.Completed and ui.completeState)
    if task.taskTbl and task.taskTbl.type == RoleTaskType.RewardsTask then
      local parameterInfo = task:GetProgressMultiple()
      if parameterInfo then
        ctr.taskDes:SetText(parameterInfo.des)
        ctr.taskProgress:SetText(parameterInfo.progressStr)
        local mTaskGoalDic = {
          taskId = task.taskId,
          goalTbl = parameterInfo.goalTbl
        }
        TaskData:RewardsTaskGoal(IndexerEnum.set, mTaskGoalDic)
        if parameterInfo.refresh then
          ctr.taskId = task.taskId
          ui:TextColorFlicker(ctr, parameterInfo.progressStr, "", 1, "#FFFFFF", "#FF0000", 2)
        elseif ctr.taskId ~= task.taskId and ctr.refushTextTimer then
          Timer.Stop(ctr.refushTextTimer)
          ctr.refushTextTimer = nil
        end
      end
    else
      ctr.taskDes:SetText(task:GetDes())
      local progress01, progress02, refushOne, refushTwo = task:GetProgress()
      local str = progress02 == "" and progress01 or progress01 .. "\n" .. progress02
      ctr.taskProgress:SetText(str)
      if refushOne then
        ctr.taskId = task.taskId
        ui:TextColorFlicker(ctr, progress01, progress02, 1, "#FFFFFF", "#FF0000", 2)
      end
      if refushTwo then
        ctr.taskId = task.taskId
        ui:TextColorFlicker(ctr, progress01, progress02, 2, "#FFFFFF", "#FF0000", 2)
      end
      if not refushOne and not refushTwo and ctr.taskId ~= task.taskId and ctr.refushTextTimer then
        Timer.Stop(ctr.refushTextTimer)
        ctr.refushTextTimer = nil
      end
    end
    ctr.taskProgress:SetActive(state == TaskStateType.Accept)
    if state == TaskStateType.Accept and task:GetTaskGola() then
      local goalType = task:GetTaskGola().goalTbl.type
      if goalType == 201 or goalType == 401 then
        ctr.taskProgress:SetActive(false)
        ctr.labTaskState:SetActive(true)
      else
        ctr.labTaskState:SetActive(false)
      end
    end
  end
  ctr.taskHelpSp:SetActive(task:GetTaskTypeID() == RoleTaskType.MarsTask and task:GetHelp() and state == TaskStateType.Accept)
  ctr.taskHelpSp:SetOnClick(self, function()
    EventManager.Dispatch(Event.ClickAskHelp, task)
  end)
  if not ui.hideMainUI then
    ui.mainShowTaskEffect[task:GetId()] = {taskE = task, ctrP = ctr}
  else
    ui:TaskAcceptEffect(task, ctr)
    ui:TaskAcceptableEffect(task, ctr)
    ui:TaskCompleteEffect(task, ctr)
    ui:TaskBottomFrameEffects(task, ctr)
  end
  ctr.img_taskSubmit:SetActive(false)
  ctr.img_taskSubmit.transform:DOKill()
  ctr.img_taskSubmit.transform.localPosition = Vector3.zero
  ui:TaskCompleteReminder(task, ctr)
  ui:CleanTaskReminder()
end

local function ItemRefreshEnd()
  EventManager.Dispatch(Event.AddCreatObj, {taskId = 0})
end

function Task_TaskUI:CleanTaskReminder()
  for k, v in pairs(self.reminder) do
    if v ~= nil and k ~= nil and TaskData.AllTasks[k] == nil then
      if v.time then
        Timer.Stop(v.time)
        v.time = nil
      end
      if v.effectTime then
        Timer.Stop(v.effectTime)
        v.effectTime = nil
      end
      v.active = nil
      self.reminder[k] = nil
    end
  end
end

function Task_TaskUI:TaskCompleteReminder(task, ctr)
  if task.state ~= TaskStateType.Completed or not AutoTaskManage.NewPeriod() then
    return
  end
  if TaskData.AllTasks[task:GetId()] == nil then
    if self.reminder[task:GetId()] ~= nil then
      if self.reminder[task:GetId()].time then
        Timer.Stop(self.reminder[task:GetId()].time)
        self.reminder[task:GetId()].time = nil
      end
      if self.reminder[task:GetId()].effectTime then
        Timer.Stop(self.reminder[task:GetId()].effectTime)
        self.reminder[task:GetId()].effectTime = nil
      end
      self.reminder[task:GetId()].active = nil
      self.reminder[task:GetId()] = nil
    end
    return
  end
  
  local function ShowTaskComplate()
    Timer.Stop(self.reminder[task:GetId()].time)
    self.reminder[task:GetId()].time = nil
    self.reminder[task:GetId()].active = true
    ctr.img_taskSubmit:SetActive(true)
  end
  
  if self.reminder[task:GetId()] == nil then
    local countTime = ClientTable.cfg_Global_globalManager:TryGetValue(2460105, "id").effect
    self.reminder[task:GetId()] = {}
    self.reminder[task:GetId()].time = Timer.StartLoop(countTime / 1000, countTime, ShowTaskComplate)
  elseif self.reminder[task:GetId()].active ~= nil and self.reminder[task:GetId()].active then
    ctr.img_taskSubmit:SetActive(true)
  end
  if self.reminder[task:GetId()] ~= nil and self.reminder[task:GetId()].effectTime then
    Timer.Stop(self.reminder[task:GetId()].effectTime)
    self.reminder[task:GetId()].effectTime = nil
  end
  ctr.img_taskSubmit.transform:DOKill()
  ctr.left = false
  ctr.img_taskSubmit.transform.localPosition = Vector3.zero
  
  local function MoveLeft()
    ctr.img_taskSubmit.transform:DOLocalMoveX(ctr.left and ctr.img_taskSubmit.transform.localPosition.x - 10 or ctr.img_taskSubmit.transform.localPosition.x + 10, 1):OnComplete(function()
      ctr.left = not ctr.left
      ctr.img_taskSubmit.transform:DOLocalMoveX(ctr.left and ctr.img_taskSubmit.transform.localPosition.x - 10 or ctr.img_taskSubmit.transform.localPosition.x + 10, 1):OnComplete(function()
        ctr.left = not ctr.left
        MoveLeft()
      end)
    end)
  end
  
  MoveLeft()
end

function Task_TaskUI:TextColorFlicker(ctr, progress01, progress02, refushIndex, defaultColor, sparkleColor, sparkleCount)
  if ctr.taskProgress == nil then
    return
  end
  ctr.taskProgress.str = refushIndex == 1 and progress01 or progress02
  if ctr.refushTextTimer then
    Timer.Stop(ctr.refushTextTimer)
    ctr.refushTextTimer = nil
  end
  ctr.taskProgress.count = 0
  
  local function TextDown()
    if ctr.taskProgress ~= nil then
      ctr.taskProgress.count = ctr.taskProgress.count + 1
      if ctr.taskProgress.count % 2 == 0 then
        ctr.taskProgress.defaultStr = string.format("<color=%s>%s</color>", defaultColor, ctr.taskProgress.str)
        ctr.taskProgress.linkStr = ""
        if refushIndex == 1 then
          ctr.taskProgress.linkStr = progress02 == "" and ctr.taskProgress.defaultStr or ctr.taskProgress.defaultStr .. "\n" .. progress02
        else
          ctr.taskProgress.linkStr = progress01 .. "\n" .. ctr.taskProgress.defaultStr
        end
        ctr.taskProgress:SetText(ctr.taskProgress.linkStr)
      else
        ctr.taskProgress.sparkleStr = string.format("<color=%s>%s</color>", sparkleColor, ctr.taskProgress.str)
        ctr.taskProgress.linkStr1 = ""
        if refushIndex == 1 then
          ctr.taskProgress.linkStr1 = progress02 == "" and ctr.taskProgress.sparkleStr or ctr.taskProgress.sparkleStr .. "\n" .. progress02
        else
          ctr.taskProgress.linkStr1 = progress01 .. "\n" .. ctr.taskProgress.sparkleStr
        end
        ctr.taskProgress:SetText(ctr.taskProgress.linkStr1)
      end
      if ctr.taskProgress.count >= sparkleCount * 2 and ctr.refushTextTimer then
        Timer.Stop(ctr.refushTextTimer)
        ctr.refushTextTimer = nil
      end
    elseif ctr.refushTextTimer then
      Timer.Stop(ctr.refushTextTimer)
      ctr.refushTextTimer = nil
    end
  end
  
  ctr.refushTextTimer = Timer.StartLoop(0.2, sparkleCount * 2, TextDown)
end

function Task_TaskUI:InitUI()
  self.taskItemTemp = UIContainer(self.btn_TaskItem, self, InitTaskItemControls, ItemTaskRefresh, ItemRefreshEnd)
  self.Recommend_PromptEffect = UIEffectUtility.SetUIEffect("Eff_UI_annuikuang03", self.subPanel, true, Vector3(0.67, 1, 1), Vector3(0, 0, 0))
  self.Recommend_PromptEffect:SetActive(false)
end

local allTask = {}
local curAllTask = {}
local temporaryStorageTask = {}
local isEffect = false
local tempRewardsTask = {}

function Task_TaskUI:RefreshTaskUI()
  allTask = {}
  for i, v in pairs(TaskData.mainTasks) do
    table.insert(allTask, v)
  end
  for i, v in pairs(TaskData.transferTask) do
    table.insert(allTask, v)
  end
  temporaryStorageTask = {}
  temporaryStorageTask = TaskData.GetCounterpartTask()
  if temporaryStorageTask ~= nil and 0 < #temporaryStorageTask then
    for k, v in pairs(temporaryStorageTask) do
      table.insert(allTask, v)
    end
  end
  temporaryStorageTask = {}
  temporaryStorageTask = TaskData.GetSkillBooksTasks()
  if temporaryStorageTask ~= nil then
    table.insert(allTask, temporaryStorageTask)
  end
  self:GetStarTaskList()
  for k, v in pairs(temporaryStorageTask) do
    table.insert(allTask, v)
  end
  for i, v in pairs(TaskData.activeUnionTasks) do
    table.insert(allTask, v)
  end
  for i, v in pairs(TaskData.branchTasks) do
    table.insert(allTask, v)
  end
  tempRewardsTask = {}
  for k, v in pairs(TaskData.rewardsTasks) do
    if tempRewardsTask[v:GetSubType()] == nil then
      tempRewardsTask[v:GetSubType()] = v
    elseif tempRewardsTask[v:GetSubType()]:GetState() < v:GetState() or tempRewardsTask[v:GetSubType()]:GetState() == v:GetState() and tempRewardsTask[v:GetSubType()]:GetId() > v:GetId() then
      tempRewardsTask[v:GetSubType()] = v
    end
  end
  for i, v in pairs(tempRewardsTask) do
    table.insert(allTask, v)
  end
  self.mainShowTaskEffect = {}
  table.sort(allTask, self.TaskSort)
  self.taskItemTemp:SetData(allTask)
  self.naviRoot:SetActive(false)
  curAllTask = allTask
  for k, v in pairs(self.taskEffeList) do
    isEffect = false
    for l, t in pairs(curAllTask) do
      if k == t.taskId then
        isEffect = true
      end
    end
    if not isEffect then
      self:CleanTaskSingleEffect(v)
    end
  end
end

function Task_TaskUI.TaskSort(task1, task2)
  return task1:GetTaskShowOrderSynthesis() < task2:GetTaskShowOrderSynthesis()
end

function Task_TaskUI:GetStarTaskList()
  temporaryStorageTask = {}
  local refresh
  for i, v in pairs(TaskData.GetStarTask()) do
    refresh = RefreshData.TaskStarCount
    if refresh == nil then
      refresh = {}
      refresh.count = 0
    end
    if refresh.count >= tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2480001)) then
      break
    end
    if TaskData.IsStarTaskProgress() then
      if v:GetState() == TaskStateType.Accept or v:GetState() == TaskStateType.Completed then
        table.insert(temporaryStorageTask, v)
        break
      end
    else
      table.insert(temporaryStorageTask, v)
      break
    end
  end
end

function Task_TaskUI:GetUnionTaskList()
  temporaryStorageTask = {}
  local task = TaskData.GetClickLevelBossTask()
  if TaskData.AllTasks[10023] == nil then
    if task then
      table.insert(temporaryStorageTask, task)
    else
      local refushLastLevel, completedTask = TaskData.GetLastLevelBossTasks()
      if refushLastLevel ~= nil and completedTask ~= nil then
        table.insert(temporaryStorageTask, completedTask)
      else
        local isHaveLevel
        for k, v in pairs(TaskData.allMonsterLevel) do
          if v <= ViewData.meData.level then
            local ifNotFinish = TaskData.GetCurMonsterLevelFinish(v)
            local generalTask = TaskData.GetPeriodicalTaskByLevel(v)
            if ifNotFinish then
              isHaveLevel = v
            end
            if generalTask ~= nil and generalTask:GetState() ~= TaskStateType.Submitted then
              isHaveLevel = v
            end
          end
        end
        if isHaveLevel then
          local levelTaskList = TaskData.GetMonsterLevelTasks(isHaveLevel)
          if levelTaskList ~= nil and levelTaskList[1] ~= nil and levelTaskList[1] then
            levelTaskList[1]:SetLevelBossFlag(false)
            table.insert(temporaryStorageTask, levelTaskList[1])
          end
        end
      end
    end
  end
end

function Task_TaskUI:IsShowNavigation(taskId, objControl, ui)
  if TaskData.AllTasks[taskId] then
    local naviList = TaskData.AllTasks[taskId]:GetNavigationList()
    if 1 < #naviList then
      self:ExhibitionNavigation(taskId, objControl, ui)
    elseif TaskData.AllTasks[taskId]:OrNaviDisplay() then
      self:ExhibitionNavigation(taskId, objControl, ui)
    else
      NavigationUtility.ClickNavigation(naviList[1])
    end
  end
end

function Task_TaskUI:ExhibitionNavigation(taskId, objControl, ui)
  if self.naviRoot.gameObject.activeSelf then
    self.naviRoot:SetActive(false)
  else
    local mulOpen = TaskData.AllTasks[taskId]:GetMulOpenNavi()
    if not string.isNullOrEmpty(mulOpen) then
      NavigationUtility.OpenPanel(mulOpen)
    end
    self.naviRoot:SetActive(true)
    self.naviRoot.transform.position = Vector3(self.naviRoot.transform.position.x, objControl.transform.position.y, objControl.transform.position.z)
    local naviList = TaskData.AllTasks[taskId]:GetNavigationList()
    local vipNaviList = TaskData.AllTasks[taskId]:GetVipNavigationList()
    local naviGroup = {}
    local showNavi = {}
    local isAdd = false
    for k, v in pairs(naviList) do
      isAdd = false
      if v.btnCondition ~= 0 then
        isAdd = NavigationUtility.IsShowBtn(v)
      elseif v.taskCondition ~= nil and v.taskCondition ~= "" then
        isAdd = ConditionManager.Check4D(v.taskCondition)
      elseif v.group ~= 0 then
        if not naviGroup[v.group] then
          naviGroup[v.group] = true
          isAdd = true
        end
      else
        isAdd = true
      end
      if isAdd then
        table.insert(showNavi, v)
      end
    end
    local vipNavi
    for i, v in pairs(vipNaviList) do
      if v.btnCondition ~= 0 then
        isAdd = NavigationUtility.IsShowBtn(v)
      elseif v.taskCondition ~= nil and v.taskCondition ~= "" then
        isAdd = ConditionManager.Check4D(v.taskCondition)
      else
        isAdd = true
      end
      if isAdd then
        table.insert(showNavi, ClientTable.cfg_Global_globalManager:GetMemberNaviPos() or 1, v)
        break
      end
    end
    local childCount = self.navigation.transform.childCount
    local obj
    if childCount > #showNavi then
      for index = #showNavi, childCount - 1 do
        obj = self.navigation.transform:GetChild(index).gameObject
        obj:SetActive(false)
      end
    end
    local naviLength = 0
    for index = 1, #showNavi do
      if childCount < index then
        obj = Instantiate(self.navigation.transform:GetChild(0).gameObject)
        obj.transform:SetParent(self.navigation.transform, false)
      else
        obj = self.navigation.transform:GetChild(index - 1).gameObject
      end
      obj:SetActive(true)
      if naviLength < showNavi[index].length then
        naviLength = showNavi[index].length
      end
      obj = UIControl(obj.transform)
      local Label = UIControl(obj.transform, "Label")
      Label:SetText(showNavi[index].name)
      local isRecommend = false
      local taskParameter = showNavi[index].taskParameter
      if not string.isNullOrEmpty(taskParameter) then
        local nums = string.splitToNumbers(taskParameter)
        local defense = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.defenseBase)
        isRecommend = defense >= nums[1] and defense <= nums[2]
      end
      local Recommend_Prompt = UIControl(obj.transform, "Recommend_Prompt")
      Recommend_Prompt:SetActive(isRecommend)
      if isRecommend and self.Recommend_PromptEffect ~= nil then
        self.Recommend_PromptEffect:SetParent(Recommend_Prompt.transform)
        self.Recommend_PromptEffect:SetPosition(0, 0, 0)
        self.Recommend_PromptEffect:SetScale(0.67, 1, 1)
        self.Recommend_PromptEffect:SetActive(true)
      end
      local Guide_Prompt = UIControl(obj.transform, "Guide_Prompt")
      Guide_Prompt:SetActive(false)
      
      local function ClickTaskNavi()
        self.naviRoot:SetActive(false)
        if showNavi[index].type == TaskNavigationType.DirectlyOpen then
          if TaskData.AllTasks[taskId] and TaskData.AllTasks[taskId]:GuideOrder() ~= nil and not string.isNullOrEmpty(TaskData.AllTasks[taskId]:GuideOrder()) and AutoTaskManage.NewPeriod() then
            local guideOrder = string.split(TaskData.AllTasks[taskId]:GuideOrder(), "#")
            if tonumber(guideOrder[1]) == TaskGuideType.Navi and not UIManager.IsVisible(UIID.GuideMaskUI) then
              UIManager.Show(UIID.GuideMaskUI, {
                id = tonumber(guideOrder[2])
              })
            end
          else
            NavigationUtility.OpenPanel(showNavi[index])
          end
        end
        if showNavi[index].type == TaskNavigationType.FindNpc then
          PathFinderManager.FlyTransferScene(tonumber(showNavi[index].transferId), nil, {
            npcId = tonumber(showNavi[index].target)
          }, Purpose.ClickNpc)
        end
        if showNavi[index].type == TaskNavigationType.OpenPromptBox then
          NavigationUtility.OpenPromptBoxPanel(showNavi[index])
        end
        if showNavi[index].type == TaskNavigationType.FindPos then
          PathFinderManager.JumpMapToMoveToPos(showNavi[index].target, showNavi[index].position1, showNavi[index].transferId)
        end
        if showNavi[index].type == TaskNavigationType.JumpPos then
          PathFinderManager.FlyTransferScene(tonumber(showNavi[index].transferId), nil, nil, nil, function()
            RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
          end)
        end
        if showNavi[index].type == TaskNavigationType.ClickEvent and showNavi[index].eventcheck ~= nil then
          EventManager.Dispatch(Event[showNavi[index].eventcheck])
          ui.time = Timer.StartLoop(0.4, 1, function()
            if TaskData.AllTasks[taskId] ~= nil and TaskData.AllTasks[taskId]:GuideOrder() ~= nil and not string.isNullOrEmpty(TaskData.AllTasks[taskId]:GuideOrder()) and AutoTaskManage.NewPeriod() then
              local guideOrder = string.split(TaskData.AllTasks[taskId]:GuideOrder(), "#")
              if tonumber(guideOrder[1]) == TaskGuideType.Navi and not UIManager.IsVisible(UIID.GuideMaskUI) then
                UIManager.Show(UIID.GuideMaskUI, {
                  id = tonumber(guideOrder[2])
                })
              end
            end
            ui:RemoveTime()
          end)
        end
        if showNavi[index].type == TaskNavigationType.ConditionOpen and showNavi[index].eventcheck ~= nil then
          if showNavi[index].eventcheckCondition == TaskNavigationEvtntFuntion.GoldEvent and SceneData.CanShowFXList() then
            Guide_Prompt:SetActive(true)
            ui.naviGuideTime = Timer.StartLoop(5, 1, function()
              ui:RemoveNaviGuideTime()
              Guide_Prompt:SetActive(false)
            end)
            EventManager.Dispatch(Event[showNavi[index].eventcheck])
            self.naviRoot:SetActive(false)
          else
            NavigationUtility.OpenPanel(showNavi[index])
            self.naviRoot:SetActive(false)
          end
        end
        if showNavi[index].type == TaskNavigationType.FindRandomPos then
          self:DoRandomPosTypeOperation(showNavi[index])
        end
      end
      
      obj:SetOnClick(self, ClickTaskNavi)
    end
    local childIsShow = false
    for k = 1, self.navigation.transform.childCount do
      if self.navigation.transform:GetChild(k - 1).gameObject.activeSelf then
        childIsShow = true
      end
    end
    if childIsShow == false then
      self.naviRoot:SetActive(false)
    end
    local GridLayoutGroup = self.navigation.transform:GetComponent("GridLayoutGroup")
    local cell = GridLayoutGroup.cellSize
    local space = GridLayoutGroup.spacing
    local curHeight = table.count(showNavi) * cell.y + (table.count(showNavi) - 1) * space.y
    GridLayoutGroup.cellSize = Vector2(naviLength, cell.y)
    self.navigation:SetSizeDelta(naviLength, curHeight)
  end
end

function Task_TaskUI:RemoveTime()
  if self.time then
    Timer.Stop(self.time)
    self.time = nil
  end
end

function Task_TaskUI:RemoveNaviGuideTime()
  if self.naviGuideTime then
    Timer.Stop(self.naviGuideTime)
    self.naviGuideTime = nil
  end
end

function Task_TaskUI:DragEvent()
  self.naviRoot:SetActive(false)
end

function Task_TaskUI:UpdateTask(id, taskId)
  self:RefreshTaskUI()
end

function Task_TaskUI:HidePointUIToOut()
  self.naviRoot:SetActive(false)
end

function Task_TaskUI:OnShow()
  self:RootPanelState(true)
  self:RegistEvents()
  if self.subPanel.gameObject.activeSelf then
    self.hideMainUI = true
  else
    self.hideMainUI = false
  end
  self:RefreshTaskUI()
end

function Task_TaskUI:TaskCompleteTaskGo(id, task)
  if task == nil and self.contentPosList[task.taskId] == nil then
    return
  end
  self:TaskSubmitEffect(task, self.contentPosList[task.taskId])
end

function Task_TaskUI:CleanTaskEffect()
  for k, v in pairs(self.taskEffeList) do
    self:CleanTaskSingleEffect(v)
  end
  self.taskEffeList = {}
  if curSelectEffect ~= nil then
    curSelectEffect:Destroy()
    curSelectEffect = nil
  end
end

function Task_TaskUI:TaskItemClick(taskId)
  if TaskData.AllTasks[taskId] then
    if TaskData.AllTasks[taskId]:GetTaskTypeID() == RoleTaskType.StarTask then
      UIManager.Show(UIID.Task_TaskStart)
    elseif TaskData.AllTasks[taskId]:GetTaskTypeID() == RoleTaskType.UnionTask then
      local refushLastLevel, completedTask = TaskData.GetLastLevelBossTasks()
      if refushLastLevel ~= nil and completedTask ~= nil then
        UIManager.Show(UIID.Task_TaskReward, {openLevle = refushLastLevel})
        return
      end
      UIManager.Show(UIID.Task_TaskReward)
    elseif TaskData.AllTasks[taskId]:GetTaskTypeID() == RoleTaskType.RewardsTask then
      TaskData:OpenRewardsTask(IndexerEnum.set, TaskData.AllTasks[taskId])
      UIManager.Show(UIID.Arrest_BossUI)
    else
      TaskManager.TaskGo(taskId, TaskTriggeringConditionType.OnClick)
    end
  else
    local unionTask = TaskData.GetUnionTaskOfIndex(taskId)
    if unionTask ~= nil and table.count(unionTask) > 0 then
      TaskManager.UnionTaskGo(unionTask)
    end
  end
end

function Task_TaskUI:CleanTaskSingleEffect(effectTime)
  if effectTime.acceptableEffect ~= nil then
    effectTime.acceptableEffect:Destroy()
    effectTime.acceptableEffect = nil
  end
  if effectTime.acceptableTime then
    Timer.Stop(effectTime.acceptableTime)
    effectTime.acceptableTime = nil
  end
  if effectTime.completeEffect ~= nil then
    effectTime.completeEffect:Destroy()
    effectTime.completeEffect = nil
  end
  if effectTime.acceptEffect ~= nil then
    effectTime.acceptEffect:Destroy()
    effectTime.acceptEffect = nil
  end
  if effectTime.acceptTime then
    Timer.Stop(effectTime.acceptTime)
    effectTime.acceptTime = nil
  end
  if effectTime.submitEffect ~= nil then
    effectTime.submitEffect:Destroy()
    effectTime.submitEffect = nil
  end
  if effectTime.submitTime then
    Timer.Stop(effectTime.submitTime)
    effectTime.submitTime = nil
  end
  if effectTime.bottomFrameEffects ~= nil then
    effectTime.bottomFrameEffects:Destroy()
    effectTime.bottomFrameEffects = nil
  end
end

function Task_TaskUI:TaskSubmitEffect(task, parentItem)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].submitEffect ~= nil then
    self.taskEffeList[task.taskId].submitEffect.transform:SetParent(parentItem.transform)
    self.taskEffeList[task.taskId].submitEffect:SetPosition(0, 0, 0)
    return
  end
  if task.state ~= TaskStateType.Completed then
    return
  end
  if string.isNullOrEmpty(task:GetSubmittedEffect()) then
    TaskManager.ShowTaskStatePanel(task)
    return
  end
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local effect = task:GetSubmittedEffect()
  local effectList = string.split(effect, "&")
  local scaleList = string.split(effectList[2], "#")
  local effectData = {
    modelType = EEffectModelType.UI,
    model = effectList[1]
  }
  self.taskEffeList[task.taskId].submitEffect = EffectModel(parentItem.transform, nil, effectData)
  self.taskEffeList[task.taskId].submitEffect:Init()
  self.taskEffeList[task.taskId].submitEffect:SetLayer(UI_LAYER)
  self.taskEffeList[task.taskId].submitEffect:SetPosition(0, 0, 0)
  self.taskEffeList[task.taskId].submitEffect:SetModel(1)
  self.taskEffeList[task.taskId].submitEffect.transform.localScale = Vector3(scaleList[1], scaleList[2], scaleList[3])
  if self.taskEffeList[task.taskId].submitTime then
    Timer.Stop(self.taskEffeList[task.taskId].submitTime)
    self.taskEffeList[task.taskId].submitTime = nil
  end
  
  local function taskSubmitEffect()
    TaskManager.ShowTaskStatePanel(task)
    if self.taskEffeList[task.taskId].submitTime then
      Timer.Stop(self.taskEffeList[task.taskId].submitTime)
      self.taskEffeList[task.taskId].submitTime = nil
    end
  end
  
  EventManager.Dispatch(Event.Task_DisPlayEffect)
  self.taskEffeList[task.taskId].submitTime = Timer.StartLoop(2, 1, taskSubmitEffect)
end

function Task_TaskUI:TaskBottomFrameEffects(task, parentItem)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].bottomFrameEffects ~= nil then
    self.taskEffeList[task.taskId].bottomFrameEffects.transform:SetParent(parentItem.transform)
    self.taskEffeList[task.taskId].bottomFrameEffects:SetPosition(0, 0, 0)
    return
  end
  if string.isNullOrEmpty(task:GetTaskBgEffect()) then
    return
  end
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local effect = task:GetTaskBgEffect()
  local effectList = string.split(effect, "&")
  local scaleList = string.split(effectList[2], "#")
  local effectData = {
    modelType = EEffectModelType.UI,
    model = effectList[1]
  }
  self.taskEffeList[task.taskId].bottomFrameEffects = EffectModel(parentItem.transform, nil, effectData)
  self.taskEffeList[task.taskId].bottomFrameEffects:Init()
  self.taskEffeList[task.taskId].bottomFrameEffects:SetLayer(UI_LAYER)
  self.taskEffeList[task.taskId].bottomFrameEffects:SetPosition(0, 0, 0)
  self.taskEffeList[task.taskId].bottomFrameEffects:SetModel(1)
  self.taskEffeList[task.taskId].bottomFrameEffects.transform.localScale = Vector3(scaleList[1], scaleList[2], scaleList[3])
  self.taskEffeList[task.taskId].bottomFrameEffects.gameObject:SetActive(false)
end

function Task_TaskUI:TaskCompleteEffect(task, parentItem)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].completeEffect ~= nil and task.state == TaskStateType.Completed then
    self.taskEffeList[task.taskId].completeEffect.gameObject:SetActive(true)
    self.taskEffeList[task.taskId].completeEffect.transform:SetParent(parentItem.transform)
    self.taskEffeList[task.taskId].completeEffect:SetPosition(0, 0, 0)
    return
  end
  if task.state ~= TaskStateType.Completed or string.isNullOrEmpty(task:GetCompletedEffect()) then
    return
  end
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local effect = task:GetCompletedEffect()
  local effectList = string.split(effect, "&")
  local scaleList = string.split(effectList[2], "#")
  local effectData = {
    modelType = EEffectModelType.UI,
    model = effectList[1]
  }
  self.taskEffeList[task.taskId].completeEffect = EffectModel(parentItem.transform, nil, effectData)
  self.taskEffeList[task.taskId].completeEffect:Init()
  self.taskEffeList[task.taskId].completeEffect:SetLayer(UI_LAYER)
  self.taskEffeList[task.taskId].completeEffect:SetPosition(0, 0, 0)
  self.taskEffeList[task.taskId].completeEffect:SetModel(1)
  self.taskEffeList[task.taskId].completeEffect.transform.localScale = Vector3(scaleList[1], scaleList[2], scaleList[3])
  EventManager.Dispatch(Event.Task_DisPlayEffect)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].bottomFrameEffects then
    self.taskEffeList[task.taskId].bottomFrameEffects.gameObject:SetActive(false)
  end
end

function Task_TaskUI:TaskAcceptEffect(task, parentItem)
  if self.taskEffeList[task.taskId] ~= nil and task.state == TaskStateType.Accept then
    if self.taskEffeList[task.taskId].acceptEffect ~= nil then
      self.taskEffeList[task.taskId].acceptEffect.gameObject:SetActive(false)
      self.taskEffeList[task.taskId].acceptEffect.transform:SetParent(parentItem.transform)
      self.taskEffeList[task.taskId].acceptEffect:SetPosition(0, 0, 0)
    end
    if self.taskEffeList[task.taskId].completeEffect ~= nil then
      self.taskEffeList[task.taskId].completeEffect.gameObject:SetActive(false)
    end
    return
  end
  if task.state ~= TaskStateType.Accept or string.isNullOrEmpty(task:GetAcceptEffect()) then
    return
  end
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local effect = task:GetAcceptEffect()
  local effectList = string.split(effect, "&")
  local scaleList = string.split(effectList[2], "#")
  local effectData = {
    modelType = EEffectModelType.UI,
    model = effectList[1]
  }
  self.taskEffeList[task.taskId].acceptEffect = EffectModel(parentItem.transform, nil, effectData)
  self.taskEffeList[task.taskId].acceptEffect:Init()
  self.taskEffeList[task.taskId].acceptEffect:SetLayer(UI_LAYER)
  self.taskEffeList[task.taskId].acceptEffect:SetPosition(0, 0, 0)
  self.taskEffeList[task.taskId].acceptEffect:SetModel(1)
  self.taskEffeList[task.taskId].acceptEffect.transform.localScale = Vector3(scaleList[1], scaleList[2], scaleList[3])
  if self.taskEffeList[task.taskId].acceptTime then
    Timer.Stop(self.taskEffeList[task.taskId].acceptTime)
    self.taskEffeList[task.taskId].acceptTime = nil
  end
  
  local function taskAcceptEffect()
    if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].acceptEffect then
      self.taskEffeList[task.taskId].acceptEffect.gameObject:SetActive(false)
      if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].bottomFrameEffects then
        self.taskEffeList[task.taskId].bottomFrameEffects.gameObject:SetActive(true)
      end
    end
    if self.taskEffeList[task.taskId].acceptTime then
      Timer.Stop(self.taskEffeList[task.taskId].acceptTime)
      self.taskEffeList[task.taskId].acceptTime = nil
    end
  end
  
  EventManager.Dispatch(Event.Task_DisPlayEffect)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].bottomFrameEffects then
    self.taskEffeList[task.taskId].bottomFrameEffects.gameObject:SetActive(false)
  end
  self.taskEffeList[task.taskId].acceptTime = Timer.StartLoop(2, 1, taskAcceptEffect)
end

function Task_TaskUI:TaskAcceptableEffect(task, parentItem)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].acceptableEffect ~= nil then
    self.taskEffeList[task.taskId].acceptableEffect.transform:SetParent(parentItem.transform)
    self.taskEffeList[task.taskId].acceptableEffect:SetPosition(0, 0, 0)
    if self.taskEffeList[task.taskId].completeEffect ~= nil and task.state == TaskStateType.Acceptable then
      self.taskEffeList[task.taskId].completeEffect.gameObject:SetActive(false)
    end
    return
  end
  if task.state ~= TaskStateType.Acceptable or string.isNullOrEmpty(task:GetAcceptableEffect()) then
    return
  end
  if self.taskEffeList[task.taskId] == nil then
    self.taskEffeList[task.taskId] = {}
  end
  local effect = task:GetAcceptableEffect()
  local effectList = string.split(effect, "&")
  local scaleList = string.split(effectList[2], "#")
  local effectData = {
    modelType = EEffectModelType.UI,
    model = effectList[1]
  }
  self.taskEffeList[task.taskId].acceptableEffect = EffectModel(parentItem.transform, nil, effectData)
  self.taskEffeList[task.taskId].acceptableEffect:Init()
  self.taskEffeList[task.taskId].acceptableEffect:SetLayer(UI_LAYER)
  self.taskEffeList[task.taskId].acceptableEffect:SetPosition(0, 0, 0)
  self.taskEffeList[task.taskId].acceptableEffect:SetModel(1)
  self.taskEffeList[task.taskId].acceptableEffect.transform.localScale = Vector3(scaleList[1], scaleList[2], scaleList[3])
  if self.taskEffeList[task.taskId].acceptableTime then
    Timer.Stop(self.taskEffeList[task.taskId].acceptableTime)
    self.taskEffeList[task.taskId].acceptableTime = nil
  end
  
  local function taskAcceptableEffect()
    if self.taskEffeList[task.taskId] ~= nil then
      self.taskEffeList[task.taskId].acceptableEffect.gameObject:SetActive(false)
      if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].bottomFrameEffects then
        self.taskEffeList[task.taskId].bottomFrameEffects.gameObject:SetActive(true)
      end
    end
    if self.taskEffeList[task.taskId].acceptableTime then
      Timer.Stop(self.taskEffeList[task.taskId].acceptableTime)
      self.taskEffeList[task.taskId].acceptableTime = nil
    end
  end
  
  EventManager.Dispatch(Event.Task_DisPlayEffect)
  if self.taskEffeList[task.taskId] ~= nil and self.taskEffeList[task.taskId].bottomFrameEffects then
    self.taskEffeList[task.taskId].bottomFrameEffects.gameObject:SetActive(false)
  end
  self.taskEffeList[task.taskId].acceptableTime = Timer.StartLoop(2, 1, taskAcceptableEffect)
end

function Task_TaskUI:OnHide()
  self:CleanTaskPanelData()
  self:RemoveTime()
  self:RemoveNaviGuideTime()
  self:CleanTaskTime()
end

function Task_TaskUI:CleanTaskPanelData()
  self:CleanTaskEffect()
end

function Task_TaskUI:CleanTaskTime()
  for k, v in pairs(self.reminder) do
    if v ~= nil then
      if v.time then
        Timer.Stop(v.time)
        v.time = nil
      end
      if v.effectTime then
        Timer.Stop(v.effectTime)
        v.effectTime = nil
      end
      v.active = nil
    end
  end
  self.reminder = {}
end

function Task_TaskUI:OnDestroy()
  self:CleanTaskPanelData()
  self:RemoveTime()
  self:RemoveNaviGuideTime()
  self:CleanTaskTime()
end

function Task_TaskUI:RegistEvents()
  self:RegistEvent(Event.Task_Update, self.UpdateTask, self)
  self:RegistEvent(Event.GradTask_Update, self.UpdateTask, self)
  self:RegistEvent(Event.Logic_ActiveMainUI, self.HidePointUIToOut, self)
  self:RegistEvent(Event.Task_CompleteTaskGo, self.TaskCompleteTaskGo, self)
  self:RegistEvent(Event.Logic_ActiveMainUI, self.OnActiveMainUI, self)
  self:RegistEvent(Event.UI_Show, self.HideMask, self)
  self:RegistEvent(Event.UI_Hide, self.ShowMask, self)
  self:RegistEvent(Event.Guide_CrossServerIntoUI, self.GuideMaskCall, self)
end

function Task_TaskUI:ShowMask(_, msg)
  if msg ~= nil then
    if msg.name == UIID.ChatUI then
      self.effectMask:SetActive(true)
    end
    if msg.name == UIID.Zhuanzhi_TIpsUI then
      self.effectMask:SetActive(true)
    end
    if msg.name == UIID.Item_ChooseBoxUI then
      self.effectMask:SetActive(true)
    end
    if msg.name == UIID.Zhuansheng_TIpsUI then
      self.effectMask:SetActive(true)
    end
  end
end

function Task_TaskUI:HideMask(_, msg)
  if msg ~= nil then
    if msg.name == UIID.ChatUI then
      self.effectMask:SetActive(false)
    end
    if msg.name == UIID.Zhuanzhi_TIpsUI then
      self.effectMask:SetActive(false)
    end
    if msg.name == UIID.Item_ChooseBoxUI then
      self.effectMask:SetActive(false)
    end
    if msg.name == UIID.Zhuansheng_TIpsUI then
      self.effectMask:SetActive(false)
    end
    if msg.name == UIID.Task_TaskReward_New then
      self.effectMask:SetActive(false)
    end
  end
end

function Task_TaskUI:OnActiveMainUI(_, flag)
  self.hideMainUI = flag
  if flag then
    for k, v in pairs(self.mainShowTaskEffect) do
      if k ~= nil and v ~= nil then
        self:TaskAcceptEffect(v.taskE, v.ctrP)
        self:TaskAcceptableEffect(v.taskE, v.ctrP)
        self:TaskCompleteEffect(v.taskE, v.ctrP)
        self:TaskBottomFrameEffects(v.taskE, v.ctrP)
      end
      self.mainShowTaskEffect[k] = nil
    end
  end
end

function Task_TaskUI:GuideMaskCall()
  local taskIdList = ClientTable.cfg_Global_globalManager:GetTaskId()
  local index = 0
  for i, taskId in pairs(taskIdList) do
    index = index + 1
    if self.contentPosList[taskId] ~= nil then
      local task = allTask[index]
      local effect = task:GetCompletedEffect()
      local effectList = string.split(effect, "&")
      local scaleList = string.split(effectList[2], "#")
      local effectData = {
        modelType = EEffectModelType.UI,
        model = effectList[1]
      }
      if curSelectEffect == nil then
        curSelectEffect = EffectModel(self.contentPosList[taskId].transform, nil, effectData)
        curSelectEffect:Init()
        curSelectEffect:SetLayer(UI_LAYER)
        curSelectEffect:SetPosition(0, 0, 0)
        curSelectEffect:SetModel(1)
        curSelectEffect.transform.localScale = Vector3(scaleList[1], scaleList[2], scaleList[3])
      end
      break
    end
  end
end

function Task_TaskUI:DoRandomPosTypeOperation(navTbl)
  if navTbl == nil or navTbl.transferId == nil then
    return
  end
  local transferTbl = ClientTable.cfg_Map_transferManager:TryGetValue(tonumber(navTbl.transferId))
  if transferTbl == nil then
    return
  end
  local pointTbl = TableParse:SplitStringToStrList(transferTbl.position, "#")
  if table.count(pointTbl) == 0 then
    return
  end
  local randomIndex = Mathf.Random(1, table.count(pointTbl))
  local posTbl = TableParse:SplitStringToIntList(pointTbl[randomIndex], "_")
  if table.count(posTbl) < 2 then
    return
  end
  PathFinderManager.JumpMapToMoveToPos(transferTbl.groupId, Vector2(posTbl[1], posTbl[2]), nil, nil, nil, Purpose.ForTask, function()
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end)
end
