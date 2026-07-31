require("GameModel/PandoraActivityData")
PandoraActivityController = {}
local this = PandoraActivityController

function PandoraActivityController.Init()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
  this.RegistEvent()
  this.nowLayer = nil
end

function PandoraActivityController.RegistMessages()
  this.messageContainer:Regist(CommerceMessage.ResPandoraInfo, this.OnResPandoraInfoMessage)
  this.messageContainer:Regist(CommerceMessage.ResPandoraInfiniteStop, this.OnResPandoraInfiniteStopMessage)
  this.messageContainer:Regist(CommerceMessage.ResPandoraRare, this.OnResPandoraRareMessage)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnLeaveGame)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnLeaveGame)
end

function PandoraActivityController.RegistEvent()
end

function PandoraActivityController.OnResPandoraRareMessage(_, msg)
  EventManager.Dispatch(Event.PandoraActivityRareChoose, msg)
end

function PandoraActivityController.OnResPandoraInfoMessage(_, msg)
  EventManager.Dispatch(Event.PandoraActivityRefresh, msg)
end

function PandoraActivityController.OnResPandoraInfiniteStopMessage(_, msg)
  EventManager.Dispatch(Event.PandoraActivityInfiniteStop, msg)
end

function PandoraActivityController.OnLeaveGame()
  PandoraActivityData.ResetLastOpenTogIndex()
end
