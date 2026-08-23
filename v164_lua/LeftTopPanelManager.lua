PanelType = {
  TaskPanelType = enum(0),
  TeamPanelType = enum(),
  TransPanelType = enum(),
  SiegePanelType = enum(),
  GodComePaneType = enum(),
  KSBattlePaneType = enum()
}
LeftTopPanelManager = {}
local this = LeftTopPanelManager

function LeftTopPanelManager.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.SetBtnInit()
end

function LeftTopPanelManager.GetCurrentPanelType()
  return this.curPanelType
end

function LeftTopPanelManager.SetCurrentPanelType(type)
  this.curPanelType = type
end

function LeftTopPanelManager.RegistEvent()
  this.eventContainer:Regist(Event.TaskBtn_indentation, this.SetHideFlag)
  this.eventContainer:Regist(Event.Task_SetTaskPanelHide, this.SetHidePanek)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.SetBtnInit)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.SetBtnInit)
end

function LeftTopPanelManager.RegistMessages()
end

function LeftTopPanelManager.SetTaskBtnFlag(hide)
  this.taskbtn = hide
end

function LeftTopPanelManager.GetTaskBtnFlag(hide)
  return this.taskbtn
end

function LeftTopPanelManager.SetBtnInit()
  this.curPanelType = PanelType.TaskPanelType
  this.hideFlag = false
  this.TaskSchool = false
  this.Preview = false
  this.hidePanel = false
  this.taskbtn = false
end

function LeftTopPanelManager.SetHideFlag(id, flag)
  if flag.TaskSchool ~= nil then
    this.TaskSchool = flag.TaskSchool
  end
  if flag.Preview ~= nil then
    this.Preview = flag.Preview
  end
  this.hideFlag = false
  if this.TaskSchool or this.Preview then
    this.hideFlag = true
  end
  EventManager.Dispatch(Event.TaskSlideBtnUpdate)
end

function LeftTopPanelManager.GetBtnFlag()
  return this.hideFlag
end

function LeftTopPanelManager.SetHidePanek(id, flag)
  this.hidePanel = flag
end

function LeftTopPanelManager.GetPanelHide()
  return this.hidePanel
end

LeftTopPanelManager.Init()
