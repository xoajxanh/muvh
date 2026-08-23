require("GameModel/OnHookData")
OnHookController = {}
local this = OnHookController
this.mainCallHookInfo = false
this.mailCallHookInfo = false

function OnHookController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistMessages()
  this.RegistEvent()
end

function OnHookController.RegistMessages()
  this.messageContainer:Regist(OnHookMessage.ResGetOnHookInfo, this.ResGetOnHookInfo)
end

function OnHookController.ResGetOnHookInfo(eventId, msg)
  OnHookData.InitOnHookData(msg)
end

function OnHookController.RegistEvent(eventId, msg)
  this.eventContainer:Regist(Event.GetOnHookInfo, this.GetOnHookInfo)
  this.eventContainer:Regist(Event.GetOnHookReward, this.GetOnHookReward)
end

function OnHookController.GetOnHookInfo()
  NetManager.Send(OnHookMessage.ReqGetOnHookInfo)
end

function OnHookController.GetOnHookReward()
  NetManager.Send(OnHookMessage.ReqGetOnHookReward)
end
