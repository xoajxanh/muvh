Main_ChatUI = class(BaseUI)
Main_ChatUI.layer = UILayer.Background
Main_ChatUI.orderInLayer = 7
Main_ChatUI.hideType = UIHideType.WaitDestroy
Main_ChatUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_ChatUI.escClose = UIEscClose.DontClose
require("GameConst/AdditionalCanvasShaderChannelsEnum")

function Main_ChatUI:InitControls()
  self.messageContainer = self:GetControl("bg_mainChat/messageContainer")
  self.nonSystemContainer = self:GetControl("bg_mainChat/messageContainer/nonSystemContainer")
  self.systemContainer = self:GetControl("bg_mainChat/messageContainer/systemContainer")
  self.msgTemp = self:GetControl("bg_mainChat/msgTemp")
  self.Img_chatBg = self:GetControl("bg_mainChat/Img_chatBg")
  self.nonSystemTemp = self:GetControl("bg_mainChat/Img_chatBg/nonSystemTemp")
  self.btn_chat = self:GetControl("bg_mainChat/btn_chat")
  self.Img_bg = self:GetControl("bg_mainChat/Img_bg")
end

function Main_ChatUI:OnPreLoad()
end

function Main_ChatUI:Init()
  self.nonSystemList = {}
  self.systemList = {}
end

function Main_ChatUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  EventManager.Dispatch(Event.MainChatPanelIsCreate)
end

function Main_ChatUI:InitUI()
  self.fixWidth, _ = self.nonSystemTemp:GetSizeDelta()
  self.imgBgWidth, self.imgBgHeight = self.Img_bg:GetSizeDelta()
  self.labTable = {}
  self.msgTemp:SetText("")
  self.singleLineHeight = self.msgTemp.text.preferredHeight
  self:InitLabelBg()
end

local everyLineFix = 3
local sumLineFix = 6
local noSystemLineFix = 6
local systemLineFix = 2

function Main_ChatUI:InitChat()
  local nonSystemCount = ChatData.GetChannelCountByType(ChatChannelEnum.ALL)
  local startIndex = 1
  if nonSystemCount > sumLineFix then
    startIndex = nonSystemCount - sumLineFix + 1
  end
  for i = startIndex, nonSystemCount do
    self:UpdateMsgList(ChatChannelEnum.ALL, i)
  end
end

function Main_ChatUI:InitLabelBg()
end

function Main_ChatUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_ChatUI:OnHide()
  self.nonSystemList = {}
  self.systemList = {}
  for i, v in pairs(self.labTable) do
    v:Destroy()
  end
  self.labTable = {}
  self.msgTemp:SetText("")
end

function Main_ChatUI:OnDestroy()
end

function Main_ChatUI:RegistUIEvents()
  self.btn_chat:SetOnClick(self, self.btn_chatOnClick)
end

function Main_ChatUI:btn_chatOnClick(control)
  UIManager.Show(UIID.ChatUI)
end

function Main_ChatUI:RegistEvents()
  self:RegistEvent(Event.Chat_ResChat, self.OnResChat, self)
  self:RegistEvent(Event.Chat_RefreshChat, self.RefreshChat, self)
end

function Main_ChatUI:RefreshChat()
  self.nonSystemList = {}
  local chatIndex = ChatData.GetChannelCountByType(ChatChannelEnum.ALL)
  local limitCount = 0 < chatIndex - sumLineFix and chatIndex - sumLineFix or 1
  for cIndex = limitCount, chatIndex do
    local nonSystemMsg = ChatData.GetMsgByType(ChatChannelEnum.ALL):GetValueByIndex(cIndex)
    local nonSystemText = ChatUtility.UpdateChatMsg(nonSystemMsg)
    self.msgTemp:SetText(nonSystemText)
    local height = self.msgTemp.text.preferredHeight
    local lines = math.floor(height / self.singleLineHeight) <= everyLineFix and math.floor(height / self.singleLineHeight) or everyLineFix
    lines = 0 < lines and lines or 1
    local textData = {
      height = height,
      text = nonSystemText,
      lines = lines
    }
    table.insert(self.nonSystemList, textData)
    local sumLine = 0
    local index = 0
    for i = #self.nonSystemList, 1, -1 do
      sumLine = sumLine + self.nonSystemList[i].lines
      if sumLine > sumLineFix then
        index = i
        break
      end
    end
    for i = 1, index do
      table.remove(self.nonSystemList, 1)
    end
  end
  local fixedLines = sumLineFix
  local sumLines = 0
  for i, v in pairs(self.nonSystemList) do
    sumLines = sumLines + v.lines
  end
  for i, v in pairs(self.systemList) do
    sumLines = sumLines + v.lines
  end
  local minusLine = sumLines - fixedLines
  local index = 1
  while 0 < minusLine do
    local noSysLines = self.nonSystemList[index] and self.nonSystemList[index].lines or 0
    local sysLines = self.systemList[index] and self.systemList[index].lines or 0
    local sumLiens = noSysLines + sysLines
    if minusLine >= sumLiens then
      if self.nonSystemList[index] and noSysLines - 1 >= sumLiens - noSystemLineFix then
        table.remove(self.nonSystemList, index)
      end
      if self.systemList[index] and sysLines - 1 >= sumLiens - systemLineFix then
        table.remove(self.systemList, index)
      end
      minusLine = minusLine - sumLiens
    elseif sumLiens > minusLine then
      local nonSystemCount = #self.nonSystemList
      local systemCount = #self.systemList
      if systemCount > systemLineFix then
        if self.systemList[index] then
          table.remove(self.systemList, index)
          minusLine = minusLine - sysLines
        end
      elseif nonSystemCount > noSystemLineFix and self.nonSystemList[index] then
        table.remove(self.nonSystemList, index)
        minusLine = minusLine - noSysLines
      end
    end
  end
  self:UpdateMsgText()
end

function Main_ChatUI:OnResChat(id, channel, msg)
  self:UpdateMsgList(ChatChannelEnum.ALL)
end

function Main_ChatUI:UpdateMsgList(channel, msgIndex)
  local chatIndex = msgIndex and msgIndex or ChatData.GetChannelCountByType(channel)
  if channel ~= ChatChannelEnum.SYSTEM and chatIndex ~= 0 then
    local nonSystemMsg = ChatData.GetMsgByType(ChatChannelEnum.ALL):GetValueByIndex(chatIndex)
    local nonSystemText = ChatUtility.UpdateChatMsg(nonSystemMsg)
    self.msgTemp:SetText(nonSystemText)
    local height = self.msgTemp.text.preferredHeight
    local lines = math.floor(height / self.singleLineHeight) <= everyLineFix and math.floor(height / self.singleLineHeight) or everyLineFix
    lines = 0 < lines and lines or 1
    local textData = {
      height = height,
      text = nonSystemText,
      lines = lines
    }
    table.insert(self.nonSystemList, textData)
    local sumLine = 0
    local index = 0
    for i = #self.nonSystemList, 1, -1 do
      sumLine = sumLine + self.nonSystemList[i].lines
      if sumLine > sumLineFix then
        index = i
        break
      end
    end
    for i = 1, index do
      table.remove(self.nonSystemList, 1)
    end
  end
  local fixedLines = sumLineFix
  local sumLines = 0
  for i, v in pairs(self.nonSystemList) do
    sumLines = sumLines + v.lines
  end
  for i, v in pairs(self.systemList) do
    sumLines = sumLines + v.lines
  end
  local minusLine = sumLines - fixedLines
  local index = 1
  while 0 < minusLine do
    local noSysLines = self.nonSystemList[index] and self.nonSystemList[index].lines or 0
    local sysLines = self.systemList[index] and self.systemList[index].lines or 0
    local sumLiens = noSysLines + sysLines
    if minusLine >= sumLiens then
      if self.nonSystemList[index] and noSysLines - 1 >= sumLiens - noSystemLineFix then
        table.remove(self.nonSystemList, index)
      end
      if self.systemList[index] and sysLines - 1 >= sumLiens - systemLineFix then
        table.remove(self.systemList, index)
      end
      minusLine = minusLine - sumLiens
    elseif sumLiens > minusLine then
      local nonSystemCount = #self.nonSystemList
      local systemCount = #self.systemList
      if systemCount > systemLineFix then
        if self.systemList[index] then
          table.remove(self.systemList, index)
          minusLine = minusLine - sysLines
        end
      elseif nonSystemCount > noSystemLineFix and self.nonSystemList[index] then
        table.remove(self.nonSystemList, index)
        minusLine = minusLine - noSysLines
      end
    end
  end
  sumLines = 0
  for i, v in pairs(self.nonSystemList) do
    sumLines = sumLines + v.lines
  end
  for i, v in pairs(self.systemList) do
    sumLines = sumLines + v.lines
  end
  self:UpdateMsgText()
end

function Main_ChatUI:UpdateMsgText()
  for i, v in ipairs(self.labTable) do
    v:Destroy()
  end
  local singleLineHeight = 26
  self.labTable = {}
  local containerHeight = 0
  for i, v in pairs(self.nonSystemList) do
    local img_chatBg = self.Img_chatBg:Instantiate(self.Img_chatBg.parent)
    img_chatBg = UIControl(img_chatBg.transform)
    local uiLab = img_chatBg:GetChild("nonSystemTemp")
    img_chatBg:SetParent(self.nonSystemContainer)
    uiLab:SetSizeDelta(self.fixWidth, v.lines * singleLineHeight)
    uiLab:SetText(v.text)
    local emojiTextHyper = uiLab.gameObject:GetComponent(typeof(CS.Framework.EmojiTextHyper))
    emojiTextHyper.lines = v.lines
    emojiTextHyper:FindRichText()
    uiLab:SetSizeDelta(self.fixWidth + 2, v.lines * singleLineHeight)
    img_chatBg:SetSizeDelta(343, v.lines * singleLineHeight)
    containerHeight = containerHeight + v.lines * singleLineHeight
    self.labTable[#self.labTable + 1] = img_chatBg
  end
  self.nonSystemContainer:SetSizeDelta(self.fixWidth + 2, containerHeight + 2)
  if containerHeight > self.imgBgHeight then
    self.Img_bg:SetSizeDelta(self.imgBgWidth, containerHeight + 10)
    self.btn_chat:SetSizeDelta(337, containerHeight + 10)
  else
    self.Img_bg:SetSizeDelta(self.imgBgWidth, self.imgBgHeight)
    self.btn_chat:SetSizeDelta(337, self.imgBgHeight)
  end
end

function Main_ChatUI:Refresh()
  self:InitChat()
  ChatData.WelcomeEnterMap()
end
