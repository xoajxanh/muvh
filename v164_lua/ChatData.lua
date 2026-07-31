ChatData = {}
local this = ChatData
ChatData.ChatDB = nil
ChatData.NOT_READ_MSG = "notReadMsg"
ChatData.searchName = ""
ChatData.maxNumEveryChannel = 0
ChatData.crossRealmMaxCount = 0
ChatData.channelCount = 6
ChatData.sumMsg = 0
ChatData.CurMsg = {}
ChatData.curChannel = ChatChannelEnum.ALL
ChatData.Messages = {
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New(),
  Queue:New()
}
local channelToIndex = {
  [ChatChannelEnum.ALL] = 1,
  [ChatChannelEnum.CROSS_REALM] = 2,
  [ChatChannelEnum.WORLD] = 3,
  [ChatChannelEnum.GUILD] = 4,
  [ChatChannelEnum.TEAM] = 5,
  [ChatChannelEnum.LOCAL] = 6,
  [ChatChannelEnum.PRIVATE] = 7,
  [ChatChannelEnum.SYSTEM] = 8,
  [ChatChannelEnum.RECRUIT] = 9,
  [ChatChannelEnum.UNION] = 10
}
ChatData.ChannelMessage = {
  [ChatChannelEnum.ALL] = this.Messages[1],
  [ChatChannelEnum.CROSS_REALM] = this.Messages[2],
  [ChatChannelEnum.WORLD] = this.Messages[3],
  [ChatChannelEnum.GUILD] = this.Messages[4],
  [ChatChannelEnum.TEAM] = this.Messages[5],
  [ChatChannelEnum.LOCAL] = this.Messages[6],
  [ChatChannelEnum.PRIVATE] = this.Messages[7],
  [ChatChannelEnum.SYSTEM] = this.Messages[8],
  [ChatChannelEnum.RECRUIT] = this.Messages[9],
  [ChatChannelEnum.UNION] = this.Messages[10]
}
ChatData.ChannelFilter = {
  [1] = function(channel)
    return true
  end,
  [2] = function(channel)
    return channel == ChatChannelEnum.CROSS_REALM
  end,
  [3] = function(channel)
    return channel == ChatChannelEnum.WORLD
  end,
  [4] = function(channel)
    return channel == ChatChannelEnum.GUILD
  end,
  [5] = function(channel)
    return channel == ChatChannelEnum.TEAM
  end,
  [6] = function(channel)
    return channel == ChatChannelEnum.LOCAL
  end,
  [7] = function(channel)
    return channel == ChatChannelEnum.PRIVATE
  end,
  [8] = function(channel)
    return channel == ChatChannelEnum.SYSTEM
  end,
  [9] = function(channel)
    return channel == ChatChannelEnum.RECRUIT
  end,
  [10] = function(channel)
    return channel == ChatChannelEnum.UNION
  end
}

function ChatData.InitEveryChannelMaxCount()
  this.maxNumEveryChannel = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2290104))
  this.crossRealmMaxCount = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2290105))
  this.sumMsg = this.maxNumEveryChannel * this.channelCount
end

function ChatData.AddMessage(channel, message)
  for i = 1, #this.Messages do
    if this.ChannelFilter[i](channel) then
      this.Messages[i]:PushLast(message)
      if i ~= 1 and i ~= 2 and this.Messages[i]:Count() > this.maxNumEveryChannel then
        this.Messages[i]:PopFirst()
      end
    end
  end
  if this.ChannelMessage[ChatChannelEnum.ALL]:Count() > this.sumMsg then
    this.ChannelMessage[ChatChannelEnum.ALL]:PopFirst()
  end
  if this.ChannelMessage[ChatChannelEnum.CROSS_REALM]:Count() > this.crossRealmMaxCount then
    this.ChannelMessage[ChatChannelEnum.CROSS_REALM]:PopFirst()
  end
  if channel == ChatChannelEnum.PRIVATE then
    this.RecordPlayerMsg(message)
    FriendData.AddFriendChat(message)
  end
  EventManager.Dispatch(Event.Chat_ResChat, channel, message)
end

function ChatData.BanRoleChat(banRoleId)
  for k, v in pairs(this.ChannelMessage) do
    if k ~= ChatChannelEnum.SYSTEM then
      local message = v
      local isReplace = false
      for i = 1, message:Count() do
        local from = message:GetValueByIndex(i).from
        if from and from.roleId == banRoleId then
          isReplace = true
          break
        end
      end
      if isReplace then
        local replaceQ = Queue:New()
        for i = 1, message:Count() do
          local from = message:GetValueByIndex(i).from
          if from and from.roleId ~= banRoleId or not from then
            replaceQ:PushLast(message:GetValueByIndex(i))
          end
        end
        this.Messages[channelToIndex[k]] = replaceQ
        this.ChannelMessage[k] = this.Messages[channelToIndex[k]]
      end
    end
  end
  EventManager.Dispatch(Event.Chat_RefreshChat)
end

function ChatData.ClearRecruit()
  local allMessage = this.ChannelMessage[ChatChannelEnum.ALL]
  local isReplace = false
  for i = 1, allMessage:Count() do
    local chatType = allMessage:GetValueByIndex(i).chatType
    if chatType == ChatChannelEnum.RECRUIT then
      isReplace = true
      break
    end
  end
  if isReplace then
    local replaceQ = Queue:New()
    for i = 1, allMessage:Count() do
      local chatInfo = allMessage:GetValueByIndex(i)
      local chatType = chatInfo.chatType
      if chatType ~= ChatChannelEnum.RECRUIT then
        replaceQ:PushLast(chatInfo)
      end
    end
    this.Messages[channelToIndex[ChatChannelEnum.ALL]] = replaceQ
    this.ChannelMessage[ChatChannelEnum.ALL] = this.Messages[channelToIndex[ChatChannelEnum.ALL]]
  end
  this.ClearChatDataByType(ChatChannelEnum.RECRUIT)
  EventManager.Dispatch(Event.Chat_RefreshChat)
end

function ChatData.WelcomeEnterMap()
  local mapConfig = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
  NoticeController.ResAnnounce(nil, {
    id = 1006,
    parameter = {
      mapConfig.name
    }
  })
end

function ChatData.WelcomeEnterGame()
  NoticeController.ResAnnounce(nil, {
    id = 10010,
    parameter = {}
  })
end

function ChatData.CurChannelData()
  return this.ChannelMessage[this.curChannel]
end

function ChatData.CurChannelDataCount()
  return this.ChannelMessage[this.curChannel]:Count()
end

function ChatData.GetMsgByType(type)
  return this.ChannelMessage[type]
end

function ChatData.GetChannelCountByType(type)
  return this.ChannelMessage[type]:Count()
end

function ChatData.ClearChatDataByType(chatChannel)
  ChatData.ChannelMessage[chatChannel]:Clear()
end

function ChatData.Init()
  this.ResetData()
end

function ChatData.RecordPlayerMsg(msg)
  this.SaveLocalPrivateMsg(msg)
end

function ChatData.ResetData()
  ChatData.curChannel = ChatChannelEnum.ALL
  ChatData.Messages = {
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New(),
    Queue:New()
  }
  ChatData.ChannelMessage = {
    [ChatChannelEnum.ALL] = this.Messages[1],
    [ChatChannelEnum.CROSS_REALM] = this.Messages[2],
    [ChatChannelEnum.WORLD] = this.Messages[3],
    [ChatChannelEnum.GUILD] = this.Messages[4],
    [ChatChannelEnum.TEAM] = this.Messages[5],
    [ChatChannelEnum.LOCAL] = this.Messages[6],
    [ChatChannelEnum.PRIVATE] = this.Messages[7],
    [ChatChannelEnum.SYSTEM] = this.Messages[8],
    [ChatChannelEnum.RECRUIT] = this.Messages[9],
    [ChatChannelEnum.UNION] = this.Messages[10]
  }
  ChatData.searchName = ""
  this.InitEveryChannelMaxCount()
end

function ChatData.CreatePlayerMsgByJson(msg)
  local playerMsg = json.encode(msg)
  playerMsg = string.format("%s", playerMsg)
  return playerMsg
end

ChatData.OVER_COUNT = 300
ChatData.OVERTIME = 2592000000

function ChatData.SaveLocalPrivateMsg(msg)
  local roleId = msg.from.roleId ~= RoleManager.me.id and msg.from.roleId or msg.toId
  FriendData.GetFriendChatData(roleId):PushLast(msg)
end

function ChatData.ResetNotReadInfo(roleId)
  local id = RoleManager.me.id
  local notReadStr = string.format("%s-%d-%d", this.NOT_READ_MSG, id, roleId)
  PlayerPrefs.SetInt(notReadStr, 0)
end

function ChatData.GetNotReadMsgCount(roleId)
  local id = RoleManager.me.id
  local notReadStr = string.format("%s-%d-%d", this.NOT_READ_MSG, id, roleId)
  local notRead = PlayerPrefs.GetInt(notReadStr, 0)
  return notRead
end

this.isCampChannel = false

function ChatData.InitCampChannel(data)
  this.isCampChannel = data.camp > 0
  EventManager.Dispatch(Event.Chat_CampRefresh)
end

ChatData.GetQuestionAward = false
ChatData.QuestionChatList = {}
ChatData.SingleInfo = nil

function ChatData.DefAllQuestionChatData(eventId, data)
  ChatData.GetQuestionAward = data.submit
  ChatData.DefQuestionChatData(data.feedbacks)
end

function ChatData.DefQuestionChatData(data)
  ChatData.QuestionChatList = {}
  if data == nil or #data <= 0 then
    EventManager.Dispatch(Event.Chat_GMRefresh)
    return
  end
  for i = 1, #data do
    local tab = {}
    tab.text = data[i].msg
    tab.time = os.date("Ng\195\160y %d th\195\161ng %m n\196\131m %y", math.floor(data[i].mills / 1000))
    tab.mode = data[i].mode
    tab.receive = data[i].receive
    table.insert(ChatData.QuestionChatList, tab)
  end
  EventManager.Dispatch(Event.Chat_GMRefresh)
end

function ChatData.DefQuestionChatMeSingleData(eventId, data)
  if data.success and ChatData.SingleInfo ~= nil then
    local tab = {}
    tab.text = ChatData.SingleInfo.msg
    tab.time = ChatData.SingleInfo.time
    tab.mode = ChatData.SingleInfo.mode
    tab.receive = ChatData.SingleInfo.receive
    table.insert(ChatData.QuestionChatList, tab)
    EventManager.Dispatch(Event.Chat_GMRefresh)
  end
  ChatData.SingleInfo = nil
end

function ChatData.DefQuestionChatGMSingleData(eventId, data)
  local tab = {}
  tab.text = data.feedback.msg
  tab.time = os.date("Ng\195\160y %d th\195\161ng %m n\196\131m %y", math.floor(data.feedback.mills / 1000))
  tab.mode = data.feedback.mode
  tab.receive = data.feedback.receive
  table.insert(ChatData.QuestionChatList, tab)
  EventManager.Dispatch(Event.Chat_GMRefresh)
end

function ChatData.SetMeChatData(msg)
  ChatData.SingleInfo = {}
  ChatData.SingleInfo.msg = msg
  ChatData.SingleInfo.time = os.date("Ng\195\160y %d th\195\161ng %m n\196\131m %y", os.time())
  ChatData.SingleInfo.mode = 1
  ChatData.SingleInfo.receive = 2
end

function ChatData.GetVersionThirdNum()
  if ChatData.mVersionNum == nil then
    ChatData.mVersionNum = 0
    local apkVersion = MuInterfaceLua.Instance:GetInstallResVersion()
    local versionTbl = string.split(apkVersion, ".")
    if table.count(versionTbl) > 2 then
      ChatData.mVersionNum = tonumber(versionTbl[3])
    end
  end
  return ChatData.mVersionNum
end

function ChatData.IsOpenSqlite3System()
  return CS.TCFramework.Platform.isEditor or ChatData.GetVersionThirdNum() > 18
end
