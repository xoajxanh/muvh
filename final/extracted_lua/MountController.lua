MountController = {}
require("GameModel/MountData")
local this = MountController

function MountController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  MountController.RegistEvent()
end

function MountController.RegistEvent()
  this.messageContainer:Regist(UnitMessage.ResDefaultHorse, this.OnResDefaultHorse)
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.OnRoleLoginMap, _, 3)
  EventManager.Regist(Event.GamePlay_Leave, this.OnLeaveGame)
  EventManager.Regist(Event.GamePlay_Back2Choose, this.OnLeaveGame)
end

function MountController.OnResDefaultHorse(_, msg)
  MountData.DefaultMount = msg.defaultHorse
end

function MountController.OnRoleLoginMap(_, x, y)
  RoleManager.me:RefreshMount()
end

function MountController.OnLeaveGame(_, x, y)
  MountData.DefaultMount = 0
end
