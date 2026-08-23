require("GameConst/FriendTypeEnum")
require("GameModel/FriendData")
FriendController = {}
local this = FriendController

function FriendController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function FriendController.RegistMessages()
  this.messageContainer:Regist(FriendMessage.ResFriendInfo, this.ResFriendInfo)
  this.messageContainer:Regist(FriendMessage.ResFriendRalationChange, this.ResFriendRalationChange)
  this.messageContainer:Regist(FriendMessage.ResPersonalInfo, this.ResPersonalInfo)
  this.messageContainer:Regist(FriendMessage.ResSearchByName, this.ResSearchByName)
  this.messageContainer:Regist(FriendMessage.ResFriendSelfPanelInfo, this.ResFriendSelfPanelInfo)
  this.messageContainer:Regist(FriendMessage.ResFriendIntimacyInfo, this.ResFriendIntimacyInfo)
end

function FriendController.ResFriendInfo(eventId, data)
  FriendData.UpdateFriendData(data)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function FriendController.ResFriendRalationChange(eventId, data)
  FriendData.UpdateFriendList(data)
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function FriendController.ResPersonalInfo(eventId, data)
  FriendData.UpdateSingleFriendData(data)
end

function FriendController.ResSearchByName(eventId, data)
  FriendData.UpdateSearchFriendData(data)
end

function FriendController.ResFriendSelfPanelInfo(eventId, data)
  FriendData.UpdateFriendInfo(data)
end

function FriendController.ResFriendIntimacyInfo(eventId, data)
  EventManager.Dispatch(Event.Friend_Intimacy, data.rid, data.intimacy)
end

function FriendController.RegistEvent()
  this.eventContainer:Regist(Event.Friend_ReqAddFriend, this.AddFriend)
  this.eventContainer:Regist(Event.Friend_ReqDeleteFriend, this.DeleteFriend)
end

function FriendController.AddFriend(eventId, msg)
  NetManager.Send(FriendMessage.ReqAddFriend, {
    id = msg.id,
    type = msg.type
  })
end

function FriendController.DeleteFriend(eventId, msg)
  NetManager.Send(FriendMessage.ReqDeleteFriend, {
    id = msg.id,
    type = msg.type
  })
end

FriendController.Init()
