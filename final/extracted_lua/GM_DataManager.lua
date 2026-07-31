require("GameModel/GM_Tool/GmMessageData")
require("GameModel/GM_Tool/GM_MessageTreeLogic")
local GM_DataManager = {}
local this = GM_DataManager
this.IsReceiveMessage = false
this.CurMessageType = 0
this.SelectMessageData = nil

function GM_DataManager:GetReceiveState()
  if self.IsReceiveMessage == nil then
    self.IsReceiveMessage = false
  end
  return self.IsReceiveMessage
end

function GM_DataManager:GetMessageType()
  if self.CurMessageType == nil then
    self.CurMessageType = 0
  end
  return self.CurMessageType
end

function GM_DataManager:Init()
  GmMessageData.Init()
end

function GM_DataManager:UpdateMessageData(data)
  GmMessageData.UpdateMessageData(data)
end

function GM_DataManager:SetReceiveState(state)
  this.IsReceiveMessage = state
end

function GM_DataManager:SetMessageType(type)
  this.CurMessageType = type
  EventManager.Dispatch(Event.RefreshGMListView, {
    type = this.CurMessageType
  })
end

function GM_DataManager:ClearMessageDataByType()
  GmMessageData.RemoveMessageDataManager(this.CurMessageType)
  EventManager.Dispatch(Event.RefreshGMListView, {
    type = this.CurMessageType
  })
end

function GM_DataManager:RefreshMessage()
  EventManager.Dispatch(Event.RefreshGMListView, {
    type = this.CurMessageType
  })
end

function GM_DataManager:SearchMessageData(id)
  EventManager.Dispatch(Event.RefreshGMListView, {
    type = GM_DataEnum.Find,
    id = id
  })
end

function GM_DataManager:SetSelectMessageData(data)
  if data then
    this.SelectMessageData = data
  end
end

function GM_DataManager:GetSelectMessageData()
  return this.SelectMessageData
end

return GM_DataManager
