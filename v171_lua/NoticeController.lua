require("GameConst/NoticeEnum")
require("GameModel/NoticeData")
NoticeController = {}
KillNoticeMgr = require("GameModel/Mu2_Chat/LuaKillNoticeDataMgr")
local this = NoticeController

function NoticeController.Init()
  KillNoticeMgr:Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
end

function NoticeController.RegistMessages()
  this.messageContainer:Regist(ChatMessage.ResAnnounce, this.ResAnnounce)
end

function NoticeController.GetCharCount(targetStr, char)
  local count = 0
  for s in string.gmatch(targetStr, "%" .. char) do
    count = count + 1
  end
  return count
end

function NoticeController.ResAnnounce(eventId, data)
  local chatConfig = ClientTable.cfg_Chat_chatManager:TryGetValue(data.id, "id")
  if not chatConfig then
    logError("ID th\195\180ng b\195\161o tr\225\187\145ng", data.id)
    return
  end
  if data.id > 4000 and data.id < 5000 then
    local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(SceneData.mapId)
    if mapTbl.line < 0 then
      return
    end
  end
  local openConditional = chatConfig.acceptCondition and chatConfig.acceptCondition or {}
  local isOpen = ConditionManager.Check(openConditional)
  if isOpen then
    local txt = ""
    local inputData = {}
    local parameterCount = 0
    for i = 1, #data.parameter do
      parameterCount = parameterCount + 1
      data.parameter[i] = string.replace(data.parameter[i], " ", "<color=#ffffff00>a</color>")
    end
    local systemChatParameterCount = this.GetCharCount(chatConfig.systemChat, "%s")
    if systemChatParameterCount ~= parameterCount then
      local param = ""
      for i = 1, #data.parameter do
        param = string.format("%s,%s", param, data.parameter[i])
      end
      logError("Tham s\225\187\145 th\195\180ng b\195\161o kh\195\180ng kh\225\187\155p, ID th\195\180ng b\195\161o l\195\160" .. data.id .. "Tham s\225\187\145 th\195\180ng b\195\161o l\195\160" .. param)
      return
    end
    local noticeStr = string.format(chatConfig.systemChat, table.unpack(data.parameter))
    local chatInfoType = ClientTable.cfg_Chat_chatManager:GetChatInfoType(data.id)
    if data.secondParameter and 0 < #data.secondParameter then
      local newChatStr = ""
      for i = 1, #data.secondParameter do
        local strTag = string.format("[system:%d]", i)
        local parameterStr = data.secondParameter[i]
        local decodeData = json.decode(parameterStr)
        if decodeData == nil then
          logError("Ph\195\162n t\195\173ch th\195\180ng b\195\161o th\225\186\165t b\225\186\161i", parameterStr)
        elseif not string.isNullOrEmpty(decodeData.announcemType) then
          inputData[strTag] = decodeData
          if decodeData.itemData ~= nil then
            newChatStr = ChatUtility.GetNoticeChatStr(decodeData.announcemType, noticeStr, decodeData.itemData)
          else
            newChatStr = ChatUtility.GetNoticeChatStr(decodeData.announcemType, noticeStr, decodeData.data)
          end
        else
          local inputDataTemp = ChatUtility.GetChatInfoData(chatInfoType, decodeData)
          inputData[strTag] = inputDataTemp
          newChatStr = ChatUtility.GetNoticeChatStr(chatInfoType, noticeStr, decodeData)
        end
        if not string.isNullOrEmpty(newChatStr) then
          noticeStr = newChatStr
        end
      end
      txt = noticeStr
    else
      inputData = {
        ["[system:1]"] = {
          type = chatInfoType,
          args = data.secondParameter
        }
      }
      txt = string.format("<a href=[system:1]>%s</a>", noticeStr)
    end
    if not txt then
      logError("ID th\195\180ng b\195\161o tr\225\187\145ng", data.id)
    end
    local chatMsg = {inputData = inputData, message = txt}
    local msg = {
      chatType = ChatChannelEnum.SYSTEM,
      chatMsg = chatMsg
    }
    local noticeTypes = string.split(chatConfig.type, "&")
    for i, v in ipairs(noticeTypes) do
      if tonumber(v) == 9 then
        msg.chatType = ChatChannelEnum.GUILD
        msg.isSystemChatFormat = true
        ChatData.AddMessage(msg.chatType, msg)
      elseif tonumber(v) == 10 then
        EventManager.Dispatch(Event.UnionKillAnnounce, data)
      elseif tonumber(v) == FourPartyRivalryConstant.AnnounceType then
        FourPartyRivalryManager:ResAnnounce(data)
      elseif tonumber(v) ~= NoticeEnum.SYSTEM then
        NoticeData.AddNotice(msg, tonumber(v), data.id)
      else
        ChatData.AddMessage(msg.chatType, msg)
      end
    end
  end
end

NoticeController.Init()
