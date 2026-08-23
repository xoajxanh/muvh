Activity_DragonAttackController = {}
require("GameModel/Activity_DragonAttackData")
local this = Activity_DragonAttackController

function Activity_DragonAttackController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistMessages()
end

function Activity_DragonAttackController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResHuoLongLaiXiActivity, this.ResHuoLongLaiXiActivity)
end

function Activity_DragonAttackController.ResHuoLongLaiXiActivity(id, msg)
  Activity_DragonAttackData.InitData(msg)
  EventManager.Dispatch(Event.ActivityDragonAttackStatusRefresh, msg.state)
end

this.Init()
