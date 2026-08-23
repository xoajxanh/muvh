DirectTask = {}
local this = DirectTask

function DirectTask.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.SwitchRole()
end

function DirectTask.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.SwitchRole)
end

function DirectTask.RegistEvent()
end

function DirectTask.SwitchRole()
end

function DirectTask.OpenNav(task)
  local naviList = TaskData.AllTasks[task.taskId]:GetNavigationList()
  if naviList ~= nil and 0 < #naviList then
    if 1 < #naviList then
      local mulOpen = TaskData.AllTasks[task.taskId]:GetMulOpenNavi()
      if not string.isNullOrEmpty(mulOpen) then
        NavigationUtility.ClickNavigation(mulOpen)
      else
        NavigationUtility.ClickNavigation(naviList[1])
      end
    else
      NavigationUtility.ClickNavigation(naviList[1])
    end
  end
end

function DirectTask.GoExecuteTask(task)
  if task:GuideOrder() ~= nil and not string.isNullOrEmpty(task:GuideOrder()) and AutoTaskManage.NewPeriod() then
    local guideOrder = string.split(task:GuideOrder(), "#")
    if tonumber(guideOrder[1]) == TaskGuideType.OpenTask and not UIManager.IsVisible(UIID.GuideMaskUI) then
      UIManager.Show(UIID.GuideMaskUI, {
        id = tonumber(guideOrder[2])
      })
    end
  else
    return
  end
end

DirectTask.Init()
