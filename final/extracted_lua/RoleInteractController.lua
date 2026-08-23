RoleInteractController = {}
local this = RoleInteractController
require("GameModel/RoleInteractData")

function RoleInteractController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function RoleInteractController.RegistMessages()
  this.messageContainer:Regist(RoleMessage.ResTeamEquipsInfo, this.ResTeamInfo)
end

function RoleInteractController.ResTeamInfo(eventId, data)
  RoleInteractData.Init(data)
end
