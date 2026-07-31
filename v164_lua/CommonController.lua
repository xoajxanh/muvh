require("GameModel/CommonData")
CommonController = {}
local this = CommonController

function CommonController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function CommonController.RegistMessages()
  this.messageContainer:Regist(CommonMessage.ResOpenWeek, this.CurrentTakeWeek)
end

function CommonController.RegistEvent()
  this.eventContainer:Regist(Event.TakeWeek, this.ReqCurrentTakeWeek)
end

function CommonController.ReqCurrentTakeWeek()
  NetManager.Send(CommonMessage.ReqOpenWeek)
end

function CommonController.CurrentTakeWeek(id, curWeek)
  CommonData.CurrentTakeWeek(curWeek)
end
