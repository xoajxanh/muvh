FriendData = {}
local this = FriendData
local OVERTIME = 2592000000
FriendData.ChatDB = nil
FriendData.curFriendType = FriendTypeEnum.FRIEND
FriendData.FriendList = {
  [FriendTypeEnum.FRIEND] = {},
  [FriendTypeEnum.ENEMY] = {},
  [FriendTypeEnum.BLACKLIST] = {},
  [FriendTypeEnum.APPLY_LIST] = {},
  [FriendTypeEnum.BE_APPLY_LIST] = {},
  [FriendTypeEnum.RECOMMEND] = {},
  [FriendTypeEnum.HISTORY] = {},
  [FriendTypeEnum.FRIEND_SEARCH] = {}
}
FriendData.FriendDict = {}
FriendData.FriendChatData = {}
FriendData.FriendChatMap = {}
FriendData.FriendChatInfoData = {}
FriendData.searchRelation = {}
FriendData.BLACKLIST_MAX = 20
FriendData.FRIEND_MAX = 100
FriendData.RECOMMEND_COUNTDOWN = 1800

function FriendData.Init()
  this.ResetData()
end

function FriendData.ResetData()
  this.FriendList = {
    [FriendTypeEnum.FRIEND] = {},
    [FriendTypeEnum.ENEMY] = {},
    [FriendTypeEnum.BLACKLIST] = {},
    [FriendTypeEnum.APPLY_LIST] = {},
    [FriendTypeEnum.BE_APPLY_LIST] = {},
    [FriendTypeEnum.RECOMMEND] = {},
    [FriendTypeEnum.HISTORY] = {},
    [FriendTypeEnum.FRIEND_SEARCH] = {}
  }
  this.FriendChatData = {}
  this.FriendChatInfoData = {}
  this.FriendDict = {}
  this.FriendChatMap = {}
  this.searchRelation = {}
  this.friendChatData = {}
end

function FriendData.SortListByType(type)
  if type == FriendTypeEnum.BE_APPLY_LIST then
    table.sort(this.FriendList[FriendTypeEnum.BE_APPLY_LIST], this.SortApply)
  elseif type == FriendTypeEnum.BLACKLIST then
    table.sort(this.FriendList[FriendTypeEnum.BLACKLIST], this.SortFriendInfo)
  elseif type == FriendTypeEnum.ENEMY then
    table.sort(this.FriendList[FriendTypeEnum.ENEMY], this.SortFriendInfo)
  end
end

function FriendData.UpdateFriendDict(channel)
  if channel == FriendTypeEnum.FRIEND then
    this.FriendDict = {}
    local friendTab = this.FriendList[FriendTypeEnum.FRIEND]
    for k, v in pairs(friendTab) do
      this.FriendDict[v.info.roleId] = v
    end
  elseif channel == FriendTypeEnum.APPLY_LIST then
    local beFriendTab = this.FriendList[FriendTypeEnum.FRIEND_SEARCH]
    local applyFriendTab = this.FriendList[FriendTypeEnum.APPLY_LIST]
    local applyIdMap = {}
    for i = 1, #beFriendTab do
      applyIdMap[beFriendTab[i].info.roleId] = true
    end
    for i = 1, #applyFriendTab do
      if applyIdMap[applyFriendTab[i].info.roleId] and this.searchRelation[applyFriendTab[i].info.roleId] then
        this.searchRelation[applyFriendTab[i].info.roleId][FriendTypeEnum.APPLY_LIST] = true
      end
    end
    EventManager.Dispatch(Event.Friend_UpdateSearch)
  elseif channel == FriendTypeEnum.BLACKLIST then
    local beFriendTab = this.FriendList[FriendTypeEnum.FRIEND_SEARCH]
    local applyFriendTab = this.FriendList[FriendTypeEnum.BLACKLIST]
    local applyIdMap = {}
    for i = 1, #beFriendTab do
      applyIdMap[beFriendTab[i].info.roleId] = true
    end
    for i = 1, #applyFriendTab do
      if applyIdMap[applyFriendTab[i].info.roleId] and this.searchRelation[applyFriendTab[i].info.roleId] then
        this.searchRelation[applyFriendTab[i].info.roleId][FriendTypeEnum.BLACKLIST] = true
      end
    end
    EventManager.Dispatch(Event.Friend_UpdateSearch)
  end
end

function FriendData.UpdateFriendData(data)
  this.SortListByType(data.type)
  this.FriendList[data.type] = data.list
  this.UpdateFriendDict(data.type)
  EventManager.Dispatch(Event.Friend_ResFriendList, data.type)
end

function FriendData.UpdateFriendList(data)
  if data.status == OperateFriendListEnum.ADD then
    this.RemoveFriendChatData(data.changeInfo, data.type)
    this.AddFriendIntoList(data)
  elseif data.status == OperateFriendListEnum.REMOVE then
    this.RemoveFriendChatData(data.changeInfo, data.type)
    this.FriendList[data.type] = this.RemoveFriendFromList(data)
  else
    this.RefreshFriendList(data)
  end
  this.UpdateFriendDict(data.type)
  EventManager.Dispatch(Event.Friend_ResFriendList, data.type)
end

function FriendData.AddFriendIntoList(data)
  for i = 1, #data.changeInfo do
    table.insert(this.FriendList[data.type], data.changeInfo[i])
  end
end

function FriendData.RemoveFriendFromList(data)
  local friendDict = {}
  local friendList = data.changeInfo
  for i = 1, #friendList do
    friendDict[friendList[i].info.roleId] = true
  end
  local refreshData = {}
  local baseData = this.FriendList[data.type]
  for i = 1, #baseData do
    if not friendDict[baseData[i].info.roleId] then
      table.insert(refreshData, baseData[i])
    end
  end
  return refreshData
end

function FriendData.RefreshFriendList(data)
  this.FriendList[data.type] = data.changeInfo
end

function FriendData.UpdateSingleFriendData(data)
  local friendList = this.FriendList[FriendTypeEnum.FRIEND]
  for i, v in ipairs(friendList) do
    if v.info.roleId == data.info.roleId then
      friendList[i] = data
    end
  end
end

function FriendData.UpdateSearchFriendData(data)
  if data == nil then
    data = {
      info = {}
    }
  end
  local refreshData = {}
  for i = 1, #data.info do
    local relation = string.split(data.info[i].relation, "#")
    local roleId = data.info[i].info.roleId
    this.searchRelation[roleId] = {}
    for k = 1, #relation do
      this.searchRelation[roleId][tonumber(relation[k])] = true
    end
    table.insert(refreshData, data.info[i])
  end
  this.FriendList[FriendTypeEnum.FRIEND_SEARCH] = refreshData
  EventManager.Dispatch(Event.Friend_ResFriendList, FriendTypeEnum.FRIEND_SEARCH)
end

function FriendData.IsHasRelation(roleId, relation)
  if this.searchRelation[roleId] then
    return this.searchRelation[roleId][relation] and true or false
  end
end

function FriendData.UpdateFriendInfo(data)
  EventManager.Dispatch(Event.Friend_ResFriendSelfPanelInfo, data)
end

function FriendData.GetFriendCountByType(type)
  return #this.FriendList[type]
end

function FriendData.GetFriendIndex(type, roleId)
  if not roleId then
    return -1
  end
  for i, v in pairs(this.FriendList[type]) do
    if v.info.roleId == roleId then
      return i
    end
  end
  return -1
end

function FriendData.IsFriendCountLessLimit(type)
  if type == FriendTypeEnum.FRIEND then
    return #this.FriendList[type] < this.FRIEND_MAX
  elseif type == FriendTypeEnum.BLACKLIST then
    return #this.FriendList[type] < this.BLACKLIST_MAX
  end
end

function FriendData.IsEmpty(type)
  return this.GetFriendCountByType(type) == 0
end

function FriendData.GetSearchFriendNotWithinFriendList(data)
  local friendDict = {}
  local friendList = this.FriendList[FriendTypeEnum.FRIEND_SEARCH]
  for i = 1, #friendList do
    friendDict[friendList[i].info.roleId] = true
  end
  local refreshData = {}
  for i = 1, #data.info do
    table.insert(refreshData, data.info[i])
    if not friendDict[data.info[i].roleId] then
      refreshData[#refreshData].status = SearchStatusEnum.NONE
    else
      refreshData[#refreshData].status = SearchStatusEnum.ADDED
    end
  end
  return refreshData
end

function FriendData.IsFriend(roleId)
  for i, v in ipairs(this.FriendList[FriendTypeEnum.FRIEND]) do
    if v.info.roleId == roleId then
      return true
    end
  end
  return false
end

function FriendData.SetFriendChatData()
  this.FriendChatData = {}
  for i, v in ipairs(this.FriendList[FriendTypeEnum.FRIEND]) do
    local data = {}
    if not this.FriendChatMap[v.info.roleId] then
      local chatData = this.LoadFriendHistoryChat(v.info.roleId)
      if chatData:Count() > 0 then
        data = {
          info = v.info,
          time = chatData:GetValueByIndex(chatData:Count()).time
        }
      else
        data = {
          info = v.info,
          time = v.time
        }
      end
      table.insert(this.FriendChatData, data)
      this.FriendChatInfoData[v.info.roleId] = chatData
      this.FriendChatMap[v.info.roleId] = data
    else
      this.FriendChatMap[v.info.roleId].info = v.info
      table.insert(this.FriendChatData, this.FriendChatMap[v.info.roleId])
    end
  end
  table.sort(this.FriendChatData, function(a, b)
    if a.info.online ~= b.info.online then
      local onlineA = a.info.online and 100 or 0
      local onlineB = b.info.online and 100 or 0
      return onlineA > onlineB
    else
      local countA = this.GetFriendChatInfoDataById(a.info.roleId):Count()
      local countB = this.GetFriendChatInfoDataById(b.info.roleId):Count()
      if countA ~= countB then
        return countA > countB
      else
        return a.time > b.time
      end
    end
  end)
end

function FriendData.GetFriendChatInfoDataById(id)
  local data = this.FriendChatInfoData[id]
  if data.dataTb and #data.dataTb > 1 then
    table.sort(data.dataTb, function(a, b)
      return a.time < b.time
    end)
  end
  return data
end

function FriendData.GetFriendIndexById(id)
  for i, v in ipairs(this.FriendChatData) do
    if v.info.roleId == id then
      return i
    end
  end
  return -1
end

function FriendData.GetFriendIndexByIdOnType(id, friendType)
  for i, v in ipairs(this.FriendList[friendType]) do
    if v.info.roleId == id then
      return i
    end
  end
  return false
end

function FriendData.AddFriendChat(chatMsg)
  local friendDict = this.FriendDict
  local roleId = chatMsg.from.roleId ~= RoleManager.me.id and chatMsg.from.roleId or chatMsg.toId
  if not friendDict[roleId] then
    return
  end
  ChatData.searchName = friendDict[roleId].info.name
  local index = this.GetFriendIndexById(roleId)
  friendDict[roleId].info = chatMsg.from.roleId ~= RoleManager.me.id and chatMsg.from or friendDict[roleId].info
  local data = {
    info = friendDict[roleId].info,
    time = chatMsg.time
  }
  if index == -1 then
    table.insert(this.FriendChatData, 1, data)
  else
    table.remove(this.FriendChatData, index)
    table.insert(this.FriendChatData, 1, data)
  end
  if not this.FriendChatInfoData[roleId] then
    this.FriendChatInfoData[roleId] = Queue:New()
  end
  if this.FriendChatInfoData[roleId]:Count() > ChatData.OVER_COUNT then
    this.FriendChatInfoData[roleId]:PopFirst()
  end
  EventManager.Dispatch(Event.Friend_RefreshChat, roleId)
end

function FriendData.AddFriendChatData(roleInfo)
  local data = {
    info = roleInfo,
    time = Time.GetServerTime()
  }
  table.insert(this.FriendChatData, 1, data)
end

function FriendData.ReadChatData(index)
  if not this.FriendChatData[index] then
    return
  end
  local roleId = this.FriendChatData[index].info.roleId
  ChatData.ResetNotReadInfo(roleId)
end

function FriendData.RefreshDataByType(type)
  this.FriendList[type] = {}
end

function FriendData.SortApply(a, b)
  return a.time < b.time
end

function FriendData.SortFriendInfo(a, b)
  return a.intimacy > b.intimacy
end

function FriendData.GetFriendChatData(friendId)
  friendId = friendId or 1
  if not this.friendChatData[friendId] then
    this.friendChatData[friendId] = Queue:New()
  end
  return this.friendChatData[friendId]
end

function FriendData.LoadFriendHistoryChat(friendId)
  return FriendData.GetFriendChatData(friendId)
end

function FriendData.RemoveFriendChatData(changeInfo, type)
  for i, v in pairs(changeInfo) do
    local roleId = v.info.roleId
    this.FriendChatMap[roleId] = nil
    this.FriendChatInfoData[roleId] = nil
    ChatData.ResetNotReadInfo(roleId)
  end
end

function FriendData.GetRoleIndexById(id, type)
  for i, v in ipairs(this.FriendList[type]) do
    if v.info.roleId == id then
      return i
    end
  end
  return -1
end

function FriendData.IsMeFriend(id)
  return this.FriendDict[id]
end

function FriendData.ClearData(friendType)
  FriendData.FriendList[friendType] = {}
end
