require("GameModel/BubbleData")
BubbleController = {}
local this = BubbleController

function BubbleController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function BubbleController.RegistEvent()
end

this.Init()
