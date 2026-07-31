ChatController = {}
require("GameModel/ChatData")
local this = ChatController

function ChatController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function ChatController.RegistMessages()
  this.messageContainer:Regist(ChatMessage.ResChat, this.OnResChat)
  this.messageContainer:Regist(ChatMessage.ResReceiveFeedback, ChatData.DefQuestionChatGMSingleData)
  this.messageContainer:Regist(ChatMessage.ResFeedbacks, ChatData.DefAllQuestionChatData)
  this.messageContainer:Regist(ChatMessage.ResSendFeedback, ChatData.DefQuestionChatMeSingleData)
  this.messageContainer:Regist(ChatMessage.ResRoleChatBan, this.BanRoleChat)
  this.messageContainer:Regist(ChatMessage.ResSearchRoleId, this.ResSearchRoleId)
  this.messageContainer:Regist(ChatMessage.ResUnionKuaFuCamp, this.ResUnionKuaFuCamp)
end

function ChatController.ResUnionKuaFuCamp(eventId, data)
  ChatData.InitCampChannel(data)
end

function ChatController.OnResChat(eventId, data)
  data.chatMsg = json.decode(data.chatMsg)
  ChatData.AddMessage(data.chatType, data)
end

function ChatController.BanRoleChat(_, msg)
  ChatData.BanRoleChat(msg.banRoleId)
end

function ChatController.ResSearchRoleId(_, msg)
  EventManager.Dispatch(Event.Chat_PrivateChat, msg.toRoleId)
end

function ChatController.RegistEvent()
  this.eventContainer:Regist(Event.Chat_ReqChat, this.ReqChat)
  this.eventContainer:Regist(Event.Scene_SceneDataChange, this.ClearRecruitChat)
end

function ChatController.ClearRecruitChat()
  local mapConfig = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  local preMapConfig = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.lastMapId)
  if preMapConfig then
    if preMapConfig.serverType == EServerType.Internal and mapConfig.serverType == EServerType.External then
      ChatData.ClearRecruit()
    elseif preMapConfig.serverType == EServerType.External and mapConfig.serverType == EServerType.Internal then
      ChatData.ClearRecruit()
    end
  end
end

function ChatController.ReqChat(eventId, msg)
  if GLogSwitch.UnityEditor then
    local startIndex, endIndex = string.find(msg.textData.message, "@")
    if startIndex == endIndex and endIndex == 1 then
      NetManager.Send(ChatMessage.ReqGM, {
        info = msg.textData.message
      })
      return
    end
  end
  local chatMsg = json.encode(msg.textData)
  NetManager.Send(ChatMessage.ReqChat, {
    chatType = msg.chatType,
    chatMsg = chatMsg,
    toRoleId = msg.toRoleId
  })
end

function ChatController.ReqAnnounce(eventId, msg)
  NetManager.Send(ChatMessage.ReqAnnounce, {
    id = msg.id or 0,
    arg1 = msg.arg1 or {},
    arg2 = msg.arg2 or {}
  })
end

ChatController.Init()
