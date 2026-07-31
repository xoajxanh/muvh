local MessageItemTemplate = {}

function MessageItemTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function MessageItemTemplate:InitControls()
  self.indexText = self:GetControl("index")
  self.timeText = self:GetControl("time")
  self.netMessage = self:GetControl("netMessage")
  self.typeText = self:GetControl("type")
  self.img_ClickEffect = self:GetControl("img_ClickEffect")
  self.img_ClickEffect:SetActive(false)
end

function MessageItemTemplate:BindUIEvent()
  self:UIControl():SetOnClick(self, self.ClickGoCallBack)
end

function MessageItemTemplate:ClickGoCallBack()
  local data = self.data
  gameMgr:GetGMDataMgr():SetSelectMessageData(data)
  EventManager.Dispatch(Event.RefreshSelectGMMessage, data)
end

function MessageItemTemplate:Refresh(data)
  if data then
    self.data = data
    self:RefreshUIShow()
  else
    self:UIControl():SetActive(false)
  end
end

function MessageItemTemplate:RefreshUIShow()
  self.indexText:SetText(self.data.index)
  self.timeText:SetText(self.data.time)
  self.typeText:SetText(self.data.typeName)
  if string.len(self.data.messageIdToName) >= 55 then
    self.netMessage:SetText(string.format("%s  %s", self.data.id, string.sub(self.data.messageIdToName, 1, 45) .. "..." .. string.sub(self.data.messageIdToName, -10)))
  else
    self.netMessage:SetText(string.format("%s  %s", self.data.id, self.data.messageIdToName))
  end
end

return MessageItemTemplate
