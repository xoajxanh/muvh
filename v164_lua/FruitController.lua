require("GameModel/FruitData")
FruitController = {}
local this = FruitController

function FruitController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function FruitController.RegistMessages()
  this.messageContainer:Regist(FruitMessage.ResFruitInfo, this.ResFruitInfo)
end

function FruitController.RegistEvent()
  this.eventContainer:Regist(Event.GamePlay_Leave, this.OnLeaveGame)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnLeaveGame)
end

function FruitController.RegistEvent()
end

function FruitController.ResFruitInfo(id, msg)
  FruitData.RefreshFreeReset(msg)
  EventManager.Dispatch(Event.Role_FruitAttribute)
end

function FruitController.OnLeaveGame()
  FruitData.Clear()
end
