require("GameModel/ReturnActivityData")
ReturnActivityController = {}
local this = ReturnActivityController

function ReturnActivityController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function ReturnActivityController.RegistEvent()
end
