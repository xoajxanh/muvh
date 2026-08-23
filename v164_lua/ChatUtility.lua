local dropDownToChatChannelTab = {
  [0] = ChatChannelEnum.WORLD,
  [1] = ChatChannelEnum.LOCAL,
  [2] = ChatChannelEnum.GUILD,
  [3] = ChatChannelEnum.TEAM,
  [4] = ChatChannelEnum.UNION
}
local dropDownCroToChatChannelTab = {
  [0] = ChatChannelEnum.CROSS_REALM,
  [1] = ChatChannelEnum.WORLD,
  [2] = ChatChannelEnum.LOCAL,
  [3] = ChatChannelEnum.GUILD,
  [4] = ChatChannelEnum.TEAM,
  [5] = ChatChannelEnum.UNION
}
local chatChannelToDoroDownTab = {
  [ChatChannelEnum.ALL] = 0,
  [ChatChannelEnum.WORLD] = 0,
  [ChatChannelEnum.LOCAL] = 1,
  [ChatChannelEnum.GUILD] = 2,
  [ChatChannelEnum.TEAM] = 3,
  [ChatChannelEnum.UNION] = 4
}
local chatCroChannelToDoroDownTab = {
  [ChatChannelEnum.CROSS_REALM] = 0,
  [ChatChannelEnum.ALL] = 1,
  [ChatChannelEnum.WORLD] = 1,
  [ChatChannelEnum.LOCAL] = 2,
  [ChatChannelEnum.GUILD] = 3,
  [ChatChannelEnum.TEAM] = 4,
  [ChatChannelEnum.UNION] = 5
}
local chatChannelToName = {
  [ChatChannelEnum.ALL] = "T\225\187\149ng h\225\187\163p",
  [ChatChannelEnum.CROSS_REALM] = "Li\195\170n Server",
  [ChatChannelEnum.WORLD] = "Th\225\186\191 Gi\225\187\155i",
  [ChatChannelEnum.GUILD] = "Guild",
  [ChatChannelEnum.TEAM] = "\196\144\225\187\153i",
  [ChatChannelEnum.LOCAL] = "G\225\186\167n",
  [ChatChannelEnum.PRIVATE] = "Chat ri\195\170ng",
  [ChatChannelEnum.SYSTEM] = "H\225\187\135 th\225\187\145ng",
  [ChatChannelEnum.RECRUIT] = "Chi\195\170u m\225\187\153",
  [ChatChannelEnum.UNION] = "Li\195\170n Minh"
}
local chatChannelToColor = {
  [ChatChannelEnum.ALL] = "#FFFFFF",
  [ChatChannelEnum.CROSS_REALM] = "#3E50F8",
  [ChatChannelEnum.WORLD] = "#C8DCFF",
  [ChatChannelEnum.GUILD] = "#FFC000",
  [ChatChannelEnum.TEAM] = "#D916D9",
  [ChatChannelEnum.LOCAL] = "#00FF00",
  [ChatChannelEnum.PRIVATE] = "#28E529",
  [ChatChannelEnum.SYSTEM] = "#4CC5FE",
  [ChatChannelEnum.RECRUIT] = "#00FFC1",
  [ChatChannelEnum.UNION] = "#4BFF00"
}

local function SetHonourAttribute(Data, ServerData)
  local count = table.count(ServerData.HonourAttribute)
  if count <= 0 then
    return Data
  end
  local info = table.DeepCopy(Data)
  local HonourAttribute = {}
  for i = 1, count do
    table.insert(HonourAttribute, ServerData.HonourAttribute[i])
  end
  if not info.HonourAttribute then
    info.HonourAttribute = HonourAttribute
  else
    info.HonourAttribute = HonourAttribute
  end
  return info
end

local chatInfoTab = {
  [ChatInfoEnum.ITEM] = function(data, control, eventData)
    local pos = eventData.pressEventCamera:ScreenToWorldPoint(Vector3(eventData.position.x, eventData.position.y, 0))
    local itemData = ItemUtility.GenerateItemDataByServerData_serverInfo(data.itemData, true)
    itemData = SetHonourAttribute(itemData, data.itemData)
    local ClientChatEnchantMen, ClientChatEnchantMenDetail
    if data and data.itemData and data.itemData.ClientSettingsEnchantMen then
      ClientChatEnchantMen = data.itemData.ClientSettingsEnchantMen
    end
    if data and data.itemData and data.itemData.ClientSettingsEnchantMenDetail then
      ClientChatEnchantMenDetail = data.itemData.ClientSettingsEnchantMenDetail
    end
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Show,
      inputMousePos = pos,
      ChatEnchantMen = ClientChatEnchantMen,
      ChatEnchantMenDetail = ClientChatEnchantMenDetail
    })
  end,
  [ChatInfoEnum.POS] = function(data)
    local targetCell = Vector2Int(data.x, data.y)
    PathFinderManager.JumpMapToMoveToPos(data.mapId, targetCell, nil, data.line)
  end,
  [ChatInfoEnum.BOSS] = function()
  end,
  [ChatInfoEnum.BOSS_MAP] = function()
  end,
  [ChatInfoEnum.ROLE] = function(data)
  end,
  [ChatInfoEnum.JOIN_TEAM] = function(data)
    EventManager.Dispatch(Event.Team_AskEnterTeam, data.teamId)
  end,
  [ChatInfoEnum.EQUIP_INTENSIFY] = function(data)
    if not UIManager.IsVisible(UIID.Equip_IntensifyUI) then
      UIManager.JumpShow(UIPanelType.HideOpen, UIID.Equip_ForgeNavUi, {
        uiID = UIID.Equip_IntensifyUI
      })
    end
    UIManager.Hide(UIID.ChatUI)
  end,
  [ChatInfoEnum.EQUIP_ZHUIJIA] = function(data)
    if not UIManager.IsVisible(UIID.Equip_ZhuijiaUI) then
      UIManager.JumpShow(UIPanelType.HideOpen, UIID.Equip_ForgeNavUi, {
        uiID = UIID.Equip_ZhuijiaUI
      })
    end
    UIManager.Hide(UIID.ChatUI)
  end,
  [ChatInfoEnum.WAR_ALLIANCE_BOSS] = function(data)
  end,
  [ChatInfoEnum.BLOOD_CASTLE] = function(data)
  end,
  [ChatInfoEnum.DEMON_PLAZA] = function(data)
  end,
  [ChatInfoEnum.NONE] = function(data)
  end,
  [ChatInfoEnum.MATCH_INVITE] = function(data)
    EventManager.Dispatch(Event.matchingInviteNotice, data.args)
  end,
  [ChatInfoEnum.UnionTask_AskForHelp] = function(data)
    if data.needHelpId ~= ViewData.meData.id then
      UIManager.Hide(UIID.ChatUI)
      EventManager.Dispatch(Event.HelpUnionTask, data)
    end
  end,
  [ChatInfoEnum.LEVEL_SPORTS] = function(data)
    UIManager.Hide(UIID.ChatUI)
    UIManager.Show(UIID.CommercializationActivityUI, {openFirstTab = 101})
  end,
  [ChatInfoEnum.OPENPANEL_NAVIGATION] = function(tbl)
    local navTbl = ClientTable.cfg_Navigation_barManager:TryGetValue(tbl.data)
    if navTbl and GradData.GoToNavi(navTbl) then
      NavigationUtility.OpenPanel(navTbl)
    end
  end,
  [ChatInfoEnum.Team3v3_Join] = function(data)
    local myLevel = RoleManager.me.level
    if data.GreaterLv and (myLevel >= data.GreaterLv or myLevel >= data.teamLimitLv) and data.teamId then
      local info = QuickFind:GetTeam3V3DataMgr():GetMatchTeamInfo()
      if data.teamId == info.teamId then
        FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\131 g\225\187\173i y\195\170u c\225\186\167u cho ch\195\173nh Chi\225\186\191n \196\144\225\187\153i c\225\187\167a m\195\172nh")
        return
      end
      networkRequest.ReqJoinTeam(data.teamId)
      UIManager.Hide(UIID.ChatUI)
      FloatingTipUtility.QuickMsg("Y\195\170u c\225\186\167u tham gia \196\145\225\187\153i \196\145\195\163 g\225\187\173i th\195\160nh c\195\180ng")
    else
      FloatingTipUtility.QuickMsg("Kh\195\180ng th\225\187\143a m\195\163n \196\145i\225\187\129u ki\225\187\135n gia nh\225\186\173p")
    end
  end
}
local funcWithChatOrFriend = {
  [ChatFuncEnum.POS] = function()
    local playerPos = string.format("[%s:%d,%d]", SceneData.name, RoleManager.me.cellPos.x, RoleManager.me.cellPos.y)
    local posStr = string.format("<color=#28E529><a href=[pos:1]>%s</a></color>", playerPos)
    local textData = {
      ["[pos:1]"] = {
        type = ChatInfoEnum.POS,
        x = RoleManager.me.cellPos.x,
        y = RoleManager.me.cellPos.y,
        mapId = SceneData.mapId
      }
    }
    local data = {inputData = textData, message = posStr}
    local msg = {
      chatType = ChatChannelEnum.TEAM,
      textData = data
    }
    EventManager.Dispatch(Event.Chat_ReqChat, msg)
  end,
  [ChatFuncEnum.ADD_FRIEND] = function(roleId)
    local msg = {
      id = roleId,
      type = FriendTypeEnum.FRIEND
    }
    EventManager.Dispatch(Event.Friend_ReqAddFriend, msg)
  end,
  [ChatFuncEnum.CHAT] = function(name)
    if UIManager.IsVisible(UIID.ChatUI) then
      UIManager.Hide(UIID.ChatUI)
    end
    ChatData.curChannel = ChatChannelEnum.PRIVATE
    UIManager.Show(UIID.ChatUI, {
      chatType = ChatChannelEnum.PRIVATE,
      roleName = name
    })
  end
}
local chatInfoData = {
  [ChatInfoEnum.NONE] = function()
  end,
  [ChatInfoEnum.ITEM] = function(item)
    local itemData = {
      type = ChatInfoEnum.ITEM,
      itemData = item
    }
    return itemData
  end
}
setmetatable(chatInfoData, {
  __index = function()
    return function()
    end
  end
})
local chatStrData = {
  [ChatInfoEnum.NONE] = function(data)
  end,
  [ChatInfoEnum.ITEM] = function(noticeStr, decodeData)
    local itemInfo = ClientTable.cfg_Item_itemManager:TryGetValue(decodeData.itemId)
    local qualityColor = ItemQuality2ColorDic[itemInfo.colorShow]
    local resStr = string.gsub(noticeStr, "$1", string.format("<color=%s>", qualityColor), 1)
    return resStr
  end
}
setmetatable(chatStrData, {
  __index = function()
    return function()
    end
  end
})

local function GetNoticeChatStr(index, noticeStr, decodeData)
  return chatStrData[index](noticeStr, decodeData)
end

local function GetChatInfoData(index, item)
  return chatInfoData[index](item)
end

local function GetChatChannelTab(index)
  if CrossRealmData.IsCrossRealm() then
    return dropDownCroToChatChannelTab[index]
  else
    return dropDownToChatChannelTab[index]
  end
end

local function GetDoroDownTab(index)
  if CrossRealmData.IsCrossRealm() then
    return chatCroChannelToDoroDownTab[index]
  else
    return chatChannelToDoroDownTab[index]
  end
end

local function GetChannelName(index)
  return chatChannelToName[index]
end

local function GetChannelColor(index)
  return chatChannelToColor[index]
end

local function GetChatInfoTab(index, data, control, eventData)
  return chatInfoTab[index](data, control, eventData)
end

local function GetFuncWithChatOrFriend(chatFucType, roleId)
  return funcWithChatOrFriend[chatFucType](roleId)
end

local function UpdateChatMsg(msg)
  local roleName, text
  local serverRoleInfo = msg.from == nil and msg.roleChatInfo or msg.from
  local serverId = (msg.chatType == ChatChannelEnum.CROSS_REALM or msg.chatType == ChatChannelEnum.UNION or msg.chatType == ChatChannelEnum.PRIVATE and SceneData.IsCrossRealm()) and string.format("S%s.", serverRoleInfo.serverId) or ""
  if msg.chatType == ChatChannelEnum.PRIVATE then
    if serverRoleInfo.roleId == RoleManager.me.id then
      roleName = string.format("B\225\186\161n n\195\179i v\225\187\155i %s ", ChatData.searchName)
    else
      roleName = string.format("%s n\195\179i v\225\187\155i b\225\186\161n", serverId .. serverRoleInfo.name)
    end
  else
    roleName = serverRoleInfo and serverId .. serverRoleInfo.name or ""
  end
  if serverRoleInfo and serverRoleInfo.roleId ~= RoleManager.me.id then
    text = string.format("<color=%s>[%s]</color><a href=[name:1]>%s</a>:%s", ChatUtility.GetChannelColor(msg.chatType), ChatUtility.GetChannelName(msg.chatType), roleName, msg.chatMsg.message)
    local roleData = {
      ["[name:1]"] = {
        type = ChatInfoEnum.ROLE,
        id = serverRoleInfo.roleId,
        roleName = serverRoleInfo.name,
        unionId = serverRoleInfo.unionId
      }
    }
    table.merge(msg.chatMsg.inputData, roleData)
  else
    local s = ""
    if roleName ~= "" then
      s = ":"
    end
    text = string.format("<color=%s>[%s]</color>%s" .. s .. "%s", ChatUtility.GetChannelColor(msg.chatType), ChatUtility.GetChannelName(msg.chatType), roleName, msg.chatMsg.message)
  end
  return text
end

local function UpdateOnlyChatUIMsg(msg)
  local text = string.format("%s", msg.chatMsg.message)
  return text
end

local function UpdateName(msg)
  local text
  if msg == nil then
    return ""
  end
  local nameFormat, channelColor, channelName, serverId, name = "<color=%s>[%s]</color>", ChatUtility.GetChannelColor(msg.chatType), ChatUtility.GetChannelName(msg.chatType)
  if msg.roleChatInfo ~= nil then
    nameFormat = msg.roleChatInfo.roleId ~= RoleManager.me.id and "<color=%s>[%s]</color><a href=[name:1]>%s%s</a>" or "<color=%s>[%s]</color>%s%s"
    serverId = (msg.chatType == ChatChannelEnum.CROSS_REALM or msg.chatType == ChatChannelEnum.UNION or msg.chatType == ChatChannelEnum.PRIVATE and SceneData.IsCrossRealm()) and string.format("S%s.", msg.roleChatInfo.serverId) or ""
    name = msg.roleChatInfo.name
  elseif msg.from ~= nil then
    nameFormat = msg.from.roleId ~= RoleManager.me.id and "<color=%s>[%s]</color><a href=[name:1]>%s%s</a>" or "<color=%s>[%s]</color>%s%s"
    serverId = (msg.chatType == ChatChannelEnum.CROSS_REALM or msg.chatType == ChatChannelEnum.UNION or msg.chatType == ChatChannelEnum.PRIVATE and SceneData.IsCrossRealm()) and string.format("S%s.", msg.from.serverId) or ""
    name = msg.from.name
  end
  if string.isNullOrEmpty(name) then
    text = string.format(nameFormat, channelColor, channelName)
  else
    text = string.format(nameFormat, channelColor, channelName, serverId, name)
  end
  return text
end

local function GetChatHeadSpriteName(chatData)
  if chatData == nil then
    return
  end
  local career
  if chatData.roleChatInfo ~= nil then
    career = chatData.roleChatInfo.career
  elseif chatData.from ~= nil then
    career = chatData.from.career
  end
  if career == nil then
    return
  end
  return ClientTable.cfg_Character_attributeManager:TryGetValue(career, "id").headPortrait
end

ChatUtility = {
  GetChatChannelTab = GetChatChannelTab,
  GetDoroDownTab = GetDoroDownTab,
  GetChannelName = GetChannelName,
  GetChannelColor = GetChannelColor,
  GetChatInfoTab = GetChatInfoTab,
  GetFuncWithChatOrFriend = GetFuncWithChatOrFriend,
  UpdateChatMsg = UpdateChatMsg,
  UpdateOnlyChatUIMsg = UpdateOnlyChatUIMsg,
  UpdateName = UpdateName,
  GetChatInfoData = GetChatInfoData,
  GetNoticeChatStr = GetNoticeChatStr,
  GetChatHeadSpriteName = GetChatHeadSpriteName
}
