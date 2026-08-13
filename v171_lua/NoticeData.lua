NoticeData = {}
local this = NoticeData

local function CompareA(a, b)
  if a.priority ~= b.priority then
    return a.priority > b.priority
  else
    return a.receiveTime < b.receiveTime
  end
end

local function CompareB(a, b)
  if a.priority ~= b.priority then
    return a.priority > b.priority
  else
    return a.receiveTime > b.receiveTime
  end
end

NoticeData.AllNoticeData = {
  [NoticeEnum.TOP] = PriorityQueue:New(CompareA),
  [NoticeEnum.UPPER] = PriorityQueue:New(CompareA),
  [NoticeEnum.MIDDLE] = PriorityQueue:New(CompareA)
}
NoticeData.CurrentNoticeId = {
  [NoticeEnum.TOP] = 0,
  [NoticeEnum.UPPER] = 0,
  [NoticeEnum.MIDDLE] = 0
}

function NoticeData.AddNotice(noticeData, noticeType, noticeId)
  local chatConfig = ClientTable.cfg_Chat_chatManager:TryGetValue(noticeId, "id")
  local noticeTab = {
    priority = chatConfig.priority,
    receiveTime = Time.GetServerTime(),
    noticeData = noticeData,
    id = noticeId,
    noticeType = noticeType
  }
  if noticeType == NoticeEnum.LINE then
    EventManager.Dispatch(Event.NoticeUpdate, noticeTab)
  elseif noticeType == NoticeEnum.MIDDLE_TIP then
    FloatingTipUtility.QuickMsg(noticeTab.noticeData.chatMsg.message)
  else
    local topNotice = NoticeData.AllNoticeData[noticeType]:Top()
    if topNotice and topNotice.priority < noticeTab.priority then
      NoticeData.AllNoticeData[noticeType]:Pop()
    end
    NoticeData.AllNoticeData[noticeType]:Put(noticeTab)
    local curNoticeId = NoticeData.CurrentNoticeId[noticeType]
    local noticeMsg = NoticeData.AllNoticeData[noticeType]:Top()
    local curChatConfig = ClientTable.cfg_Chat_chatManager:TryGetValue(curNoticeId, "id")
    if curNoticeId == 0 then
      NoticeData.CurrentNoticeId[noticeType] = noticeId
      EventManager.Dispatch(Event.NoticeUpdate, noticeMsg)
    elseif chatConfig.priority > curChatConfig.priority then
      NoticeData.CurrentNoticeId[noticeType] = noticeId
      EventManager.Dispatch(Event.NoticeUpdate, noticeMsg)
    end
  end
end

function NoticeData.Init()
  this.ResetData()
end

function NoticeData.ResetData()
  NoticeData.AllNoticeData = {
    [NoticeEnum.TOP] = PriorityQueue:New(CompareA),
    [NoticeEnum.UPPER] = PriorityQueue:New(CompareA),
    [NoticeEnum.MIDDLE] = PriorityQueue:New(CompareA)
  }
  NoticeData.CurrentNoticeId = {
    [NoticeEnum.TOP] = 0,
    [NoticeEnum.UPPER] = 0,
    [NoticeEnum.MIDDLE] = 0
  }
end

function NoticeData.GetNoticeData(noticeType)
  NoticeData.AllNoticeData[noticeType]:Pop()
  local noticeMsg = NoticeData.AllNoticeData[noticeType]:Top()
  NoticeData.CurrentNoticeId[noticeType] = noticeMsg and noticeMsg.id or 0
  return noticeMsg
end
