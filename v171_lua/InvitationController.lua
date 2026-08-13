InvitationController = {}
require("GameModel/InvitationData")
local this = InvitationController

function InvitationController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function InvitationController.RegistEvent()
  this.eventContainer:Regist(Event.GamePlay_Leave, this.CleanInvitationData, this)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.CleanInvitationData, this)
end

function InvitationController.RegistMessages()
  this.messageContainer:Regist(InviteMessage.ResInvitationInfo, this.OnResInvite)
  this.messageContainer:Regist(UserMessage.ResLogout, this.CleanInvitationData)
end

function InvitationController.OnResInvite(_, msg)
  InvitationData.SetData(msg)
end

function InvitationController.CleanInvitationData()
  InvitationData.CleanInvitationData()
end

function InvitationController.CrossCleanInvitationData()
  InvitationData.CrossCleanInvitationData()
end

InvitationController.Init()
