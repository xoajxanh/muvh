require("GameModel/BossData")
BossController = {}
local this = BossController

function BossController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function BossController.RegistEvent()
end
