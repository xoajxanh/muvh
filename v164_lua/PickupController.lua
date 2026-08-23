PickupController = {}
local this = PickupController

function PickupController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function PickupController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResPickUpMapItems, this.ResPickUpMapItemState)
end

function PickupController.ResPickUpMapItemState(id, msg)
  EventManager.Dispatch(Event.SendPickupMsgSuccessful, msg.objIds)
end
