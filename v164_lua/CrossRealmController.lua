CrossRealmController = {}
require("GameModel/CrossRealmData")
local this = CrossRealmController

function CrossRealmController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function CrossRealmController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResCanJoinRemoteMap, this.UpdateCrossRealm)
end

function CrossRealmController.UpdateCrossRealm(_, msg)
  CrossRealmData.Init(msg)
end
