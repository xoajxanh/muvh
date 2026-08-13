TaskController = {}
require("GameModel/TaskData")
local this = TaskController
local curTaskList = {}

function TaskController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  TaskData.InitUnionConfigData()
end

function TaskController.RegistMessages()
  this.messageContainer:Regist(TaskMessage.ResTasks, TaskController.OnResTasks)
  this.messageContainer:Regist(TaskMessage.ResTask, TaskController.OnResTask)
  this.messageContainer:Regist(TaskMessage.ResGoal, TaskController.OnResGoal)
  this.messageContainer:Regist(TaskMessage.ResUnionTask, TaskController.OnResUnionTasks)
  this.messageContainer:Regist(TaskMessage.ResUTask, TaskController.OnResUTask)
  this.messageContainer:Regist(TaskMessage.ResAssistTask, TaskController.OnHelpRes)
  this.messageContainer:Regist(TaskMessage.ResTaskCount, this.FinishCountForTasks)
  this.messageContainer:Regist(UserMessage.ResLogout, this.OnGamePlayLeave)
  this.messageContainer:Regist(TaskMessage.ResUnionCommonTask, this.OnResUnionCommonTask)
  this.messageContainer:Regist(TransferMessage.ResRemoveTask, this.OnResRemoveTask)
  this.messageContainer:Regist(TaskMessage.ResBossRewardInfo, this.OnResBossRewardInfo)
end

function TaskController.OnResRemoveTask(id, msg)
  if msg then
    TaskData.OnResRemoveTask(msg.taskId)
  end
end

function TaskController.OnResBossRewardInfo(id, msg)
  EventManager.Dispatch(Event.BossRewardInfo, msg)
end

function TaskController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function TaskController.OnResTasks(id, msg)
  TaskData.SetStarTaskCount(msg.starTaskCount)
  TaskData.InitTasks(msg.tasks)
  EventManager.Dispatch(Event.TaskData_Update, msg)
end

function TaskController.OnResTask(id, msg)
  this.RefreshTask(msg)
end

function TaskController.OnResGoal(id, msg)
  TaskData.UpdateTaskGoal(msg)
end

function TaskController.RegistEvent()
  this.eventContainer:Regist(Event.Task_BtnAcceptClick, this.TaskUIAccept)
  this.eventContainer:Regist(Event.Task_BtnRewardClick, this.TaskUIReward)
  this.eventContainer:Regist(Event.Task_StateChange, this.TaskStateChange)
  this.eventContainer:Regist(Event.Task_BtnSubmitClick, this.TaskUISubmit)
  this.eventContainer:Regist(Event.Task_OpenNpcTaskPanel, this.OpenClickTaskPanel)
  this.eventContainer:Regist(Event.Task_BtnGiveUpClick, this.GoGiveUpTask)
  this.eventContainer:Regist(Event.HelpUnionTask, this.OnHelpUnionTask)
  this.eventContainer:Regist(Event.ClickAskHelp, this.OnClickAskHelp)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnGamePlayLeave)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnGamePlayLeave)
end

function TaskController.OnGamePlayLeave()
  TaskData.SwitchRole()
end

function TaskController.AskGetFinishCountForTaskID(id, taskId)
  local taskTbl = ClientTable.cfg_union_taskManager:TryGetValue(taskId)
  local generalTaskTbl = ClientTable.cfg_Task_taskManager:TryGetValue(taskId, "id")
  if taskTbl ~= nil and taskTbl then
    local msg = {
      rid = ViewData.meData.id,
      taskId = taskId,
      type = 2
    }
    NetManager.Send(TaskMessage.ReqTaskCount, msg)
  elseif generalTaskTbl ~= nil and generalTaskTbl then
    local msg = {
      rid = ViewData.meData.id,
      taskId = taskId,
      type = 1
    }
    NetManager.Send(TaskMessage.ReqTaskCount, msg)
  end
end

function TaskController.FinishCountForTasks(id, msg)
  if ViewData.meData then
    TaskData.SaveCompletedTasksCount(msg.tasks)
  else
    logError("Ch\198\176a t\225\186\161o nh\195\162n v\225\186\173t, kh\195\180ng th\225\187\131 c\225\186\173p nh\225\186\173t th\195\180ng tin nhi\225\187\135m v\225\187\165")
  end
end

function TaskController.GoCompleteTask(task)
  local msg = {
    id = task.taskId
  }
  NetManager.Send(TaskMessage.ReqCompleteTask, msg)
end

function TaskController.GoGiveUpTask(id, taskId)
  local msg = {taskId = taskId}
  NetManager.Send(TaskMessage.ReqGiveUpTask, msg)
end

function TaskController.TaskUIAccept(id, taskId)
  if not taskId then
    return
  end
  local msg = {taskId = taskId}
  NetManager.Send(TaskMessage.ReqAcceptTask, msg)
end

function TaskController.TaskUISubmit(id, taskId)
  if not taskId then
    return
  end
  local msg = {taskId = taskId}
  NetManager.Send(TaskMessage.ReqSubmitTask, msg)
end

function TaskController.TaskUIReward(id, taskId)
  if not taskId then
    return
  end
  local msg = {taskId = taskId}
  NetManager.Send(TaskMessage.ReqCompleteTask, msg)
end

function TaskController.RefreshTask(msg)
  TaskData.UpdateTaskInfo(msg)
end

function TaskController.OpenClickTaskPanel(id, npcTaskData)
  if not npcTaskData then
    return false
  end
  PathFinderManager.ResetData()
  if npcTaskData.state == TaskStateType.Acceptable or npcTaskData.state == TaskStateType.Completed then
    TaskManager.ShowTaskStatePanel(npcTaskData)
  end
end

function TaskController.GetTaskFromNpc(npcId)
  this.curTaskList = {}
  local isGetTask = false
  for i, v in pairs(TaskData.AllTasks) do
    if v.state == TaskStateType.Acceptable and v.taskTbl.fromNPC == npcId then
      table.insert(this.curTaskList, v)
    end
    if v.state == TaskStateType.Accept and v.taskTbl.toNPC == npcId then
      table.insert(this.curTaskList, v)
    end
    if v.state == TaskStateType.Completed and v.taskTbl.toNPC == npcId then
      table.insert(this.curTaskList, v)
    end
  end
  if table.count(this.curTaskList) > 0 then
    isGetTask = true
    this.curTask = this.curTaskList[1]
  end
  return isGetTask
end

function TaskController.TaskStateChange(id, taskId)
  local task = TaskData.AllTasks[taskId]
  if not task then
    return
  end
  local state = task:GetState()
  if state == TaskStateType.Acceptable and task:GetTaskGola().goalTbl.type == TaskGoalType.Dialogue then
    local msg = {taskId = taskId}
    NetManager.Send(TaskMessage.ReqAcceptTask, msg)
  end
  if state == TaskStateType.Completed and task:GetTaskGola().goalTbl.type == TaskGoalType.Dialogue then
    TaskManager.ShowTaskStatePanel(task)
  end
  if state == TaskStateType.Submitted and task:GetTaskGola().goalTbl.type == TaskGoalType.Dialogue then
    TaskManager.ShowTaskStatePanel(task)
  end
end

function TaskController.OnResUnionTasks(id, unionTasks)
  if unionTasks ~= nil then
    TaskData.InitUnionTasks(unionTasks)
  end
end

function TaskController.OnResUTask(id, unionTask)
  if unionTask ~= nil then
    TaskData.UpdateUnionTask(unionTask)
  end
end

function TaskController.OnClickAskHelp(id, task)
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_10")
  local askHelpTxt = string.format("<a href=[AskForHelp:1]>" .. content .. "</a>", ViewData.meData.name, task:GetUnionTaskTitle())
  local data = {
    inputData = {
      ["[AskForHelp:1]"] = {
        type = ChatInfoEnum.UnionTask_AskForHelp,
        needHelpTaskId = task.taskId,
        needHelpId = ViewData.meData.id,
        needHelpName = ViewData.meData.name
      }
    },
    message = askHelpTxt
  }
  local msg = {
    chatType = ChatChannelEnum.GUILD,
    textData = data
  }
  UIManager.Hide(UIID.WarAlliance_Task)
  EventManager.Dispatch(Event.Chat_ReqChat, msg)
end

local curHelpInfo = {}

function TaskController.OnHelpUnionTask(id, helpInfo)
  if helpInfo ~= nil then
    this.curHelpInfo = helpInfo
    if TaskData.canAssistCount ~= nil then
      if TaskData.canAssistCount > 0 then
        local msg = {
          rid = helpInfo.needHelpId,
          taskId = helpInfo.needHelpTaskId
        }
        NetManager.Send(TaskMessage.ReqAssistUTask, msg)
      else
        local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_11")
        local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_1")
        UIManager.Show(UIID.PromptTipUI, {
          title = title,
          textContent = tostring(titleStr)
        })
      end
    end
  end
end

function TaskController.OnHelpRes(id, msg)
  if msg ~= nil then
    local title = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TaskReward_1")
    if msg.result == 1 then
      local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_12")
      local titleStr = string.format(content, this.curHelpInfo.needHelpName)
      local prompTipArgs = {
        title = title,
        textContent = titleStr,
        ok = function()
          if this.curHelpInfo.needHelpTaskId ~= nil then
            local taskTbl = ClientTable.cfg_union_taskManager:TryGetValue(this.curHelpInfo.needHelpTaskId)
            local taskGold = ClientTable.cfg_Task_goalManager:TryGetValue(taskTbl.goalId, "goalId")
            local transferId = taskGold.transferId
            PathFinderManager.FlyTransferScene(transferId, nil, nil, Purpose.ForTask)
          end
        end
      }
      UIManager.Show(UIID.PromptTipUI, prompTipArgs)
    else
      local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_13")
      local titleStr = string.format(content, this.curHelpInfo.needHelpName)
      UIManager.Show(UIID.PromptTipUI, {
        title = title,
        textContent = tostring(titleStr)
      })
    end
  end
end

function TaskController.OnResUnionCommonTask(id, msg)
  TaskData.RefreshUnionCommonTask(msg)
end
