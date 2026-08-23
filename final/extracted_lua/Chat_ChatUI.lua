Chat_ChatUI = class(BaseUI)
Chat_ChatUI.layer = UILayer.Panel
Chat_ChatUI.orderInLayer = 3
Chat_ChatUI.hideType = UIHideType.Hide
Chat_ChatUI.hideFunc = UIHideFunc.MoveOutOfScreen
Chat_ChatUI.escClose = UIEscClose.DontClose
require("GameUI/ChatPanel")

function Chat_ChatUI:InitControls()
  self.btn_close = self:GetControl("btn_close")
  self.go_allChat = self:GetControl("img_title/go_allChat")
  self.tog_all = self:GetControl("img_title/go_allChat/tog_all")
  self.tog_crossRealm = self:GetControl("img_title/go_allChat/tog_crossRealm")
  self.tog_union = self:GetControl("img_title/go_allChat/tog_union")
  self.tog_world = self:GetControl("img_title/go_allChat/tog_world")
  self.tog_nearby = self:GetControl("img_title/go_allChat/tog_nearby")
  self.tog_guild = self:GetControl("img_title/go_allChat/tog_guild")
  self.tog_team = self:GetControl("img_title/go_allChat/tog_team")
  self.tog_private = self:GetControl("img_title/go_allChat/tog_private")
  self.tog_system = self:GetControl("img_title/go_allChat/tog_system")
  self.tog_recruit = self:GetControl("img_title/go_allChat/tog_recruit")
  self.Panel_Chat = self:GetControl("Panel_Chat")
  self.ScrollView = self:GetControl("Panel_Chat/ScrollView")
  self.Text_Message = self:GetControl("Panel_Chat/Text_Message")
  self.go_selfPlayerChar = self:GetControl("Panel_Chat/go_selfPlayerChar")
  self.go_otherPlayerChar = self:GetControl("Panel_Chat/go_otherPlayerChar")
  self.go_systemChar = self:GetControl("Panel_Chat/go_systemChar")
  self.go_tempChar = self:GetControl("Panel_Chat/go_tempChar")
  self.img_charBubble = self:GetControl("Panel_Chat/go_tempChar/img_charBubble")
  self.lab_tempChar = self:GetControl("Panel_Chat/go_tempChar/img_charBubble/lab_tempChar")
  self.img_SystemCharBubble = self:GetControl("Panel_Chat/go_tempChar/img_SystemCharBubble")
  self.lab_SystemChar = self:GetControl("Panel_Chat/go_tempChar/img_SystemCharBubble/lab_SystemChar")
  self.btn_chat_shrink = self:GetControl("Panel_Chat/btn_chat_shrink")
  self.img_inputBaseChat = self:GetControl("img_inputBaseChat")
  self.img_inputPrivateChat = self:GetControl("img_inputPrivateChat")
  self.img_inputChat = self:GetControl("img_inputChat")
  self.Dropdown_Channel = self:GetControl("img_inputChat/Dropdown_Channel")
  self.Arrow = self:GetControl("img_inputChat/Dropdown_Channel/Arrow")
  self.btn_Choice = self:GetControl("img_inputChat/btn_Choice")
  self.InputField_Name = self:GetControl("img_inputChat/InputField_Name")
  self.Placeholder_PrivateName = self:GetControl("img_inputChat/InputField_Name/Placeholder_PrivateName")
  self.btn_voice = self:GetControl("img_inputChat/InputField_ChatInput/btn_voice")
  self.InputField_ChatInput = self:GetControl("img_inputChat/InputField_ChatInput")
  self.Placeholder = self:GetControl("img_inputChat/InputField_ChatInput/Placeholder")
  self.btn_other = self:GetControl("img_inputChat/btn_other")
  self.Button_OK = self:GetControl("img_inputChat/Button_OK")
  self.img_privateChoice = self:GetControl("img_inputChat/img_privateChoice")
  self.tog_go_history = self:GetControl("img_inputChat/img_privateChoice/go_objectType/tog_go_history")
  self.tog_go_friend = self:GetControl("img_inputChat/img_privateChoice/go_objectType/tog_go_friend")
  self.tog_go_guild = self:GetControl("img_inputChat/img_privateChoice/go_objectType/tog_go_guild")
  self.img_historyPanel = self:GetControl("img_inputChat/img_historyPanel")
  self.bg_emojiList = self:GetControl("img_inputChat/bg_emojiList")
  self.Button_emoji = self:GetControl("img_inputChat/bg_emojiList/bg_emojiList/Viewport/Content/Button_emoji")
  self.go_itemInput = self:GetControl("img_inputChat/go_itemInput")
  self.tog_bag = self:GetControl("img_inputChat/go_itemInput/tog_bag")
  self.tog_wear = self:GetControl("img_inputChat/go_itemInput/tog_wear")
  self.sw_privateChoiceList = self:GetControl("img_inputChat/img_historyPanel/sw_privateChoiceList")
  self.Bg_privateChoiceList = self:GetControl("img_inputChat/img_historyPanel/sw_privateChoiceList/Bg_privateChoiceList")
  self.img_other = self:GetControl("img_inputChat/img_other")
  self.btn_emoji = self:GetControl("img_inputChat/btn_emoji")
  self.btn_item = self:GetControl("img_inputChat/btn_item")
  self.btn_position = self:GetControl("img_inputChat/btn_position")
  self.go_noGuild = self:GetControl("go_noGuild")
  self.btn_establishGuild = self:GetControl("go_noGuild/panel_container/btn_establishGuild")
  self.btn_joinGuild = self:GetControl("go_noGuild/panel_container/btn_joinGuild")
  self.go_noTeam = self:GetControl("go_noTeam")
  self.btn_establishTeam = self:GetControl("go_noTeam/btn_establishTeam")
  self.btn_joinTeam = self:GetControl("go_noTeam/btn_joinTeam")
  self.go_noSystem = self:GetControl("go_noSystem")
  self.go_noRecruit = self:GetControl("go_noRecruit")
  self.Scroll_BagInfos = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos")
  self.go_BagContent = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/Viewport/go_BagContent")
  self.tile_bg = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/Viewport/go_BagContent/tile_bg")
  self.go_DragCheck = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/go_DragCheck")
  self.go_ScrollTop = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/go_DragCheck/go_ScrollTop")
  self.go_ScrollBottom = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/go_DragCheck/go_ScrollBottom")
  self.go_DragEdge = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/go_DragCheck/go_DragEdge")
  self.btn_3DItem = self:GetControl("img_inputChat/go_itemInput/Scroll_BagInfos/btn_3DItem")
  self.go_voice = self:GetControl("go_voice")
end

function Chat_ChatUI:Init()
end

function Chat_ChatUI:OnCreate()
  self:InitControls()
  self:InitArgs()
  self:InitUI()
  self:RegistUIEvents()
end

function Chat_ChatUI:InitArgs()
  self.chatPanel = ChatPanel(self)
  self.priType = "history"
end

function Chat_ChatUI:ResetChatInfo()
  self.stallShoutData = {}
end

function Chat_ChatUI:AddChatInfo(_chatType, _chatInfo)
  local key = ""
  if _chatType == ChatInfoEnum.ITEM then
    key = self.chatPanel.chatStrHandle:GetInputStr(ChatInfoEnum.ITEM, _chatInfo.itemData.itemId)
    self.stallShoutData[key] = {
      type = ChatInfoEnum.ITEM,
      itemData = _chatInfo.itemData
    }
  elseif _chatType == ChatInfoEnum.POS then
    key = self.chatPanel.chatStrHandle:GetInputStrStallPos(_chatInfo)
    self.stallShoutData[key] = {
      type = ChatInfoEnum.POS,
      x = _chatInfo.x,
      y = _chatInfo.y,
      mapId = _chatInfo.mapId
    }
  elseif _chatType == ChatInfoEnum.NONE then
    key = _chatInfo
  end
  return key
end

function Chat_ChatUI:SendMessageChatInfo(_inputStr, _chatChannelEnum)
  local message = self.chatPanel.chatStrHandle:GetChatText(_inputStr)
  local textData = self.chatPanel:UpdateTextData(self.stallShoutData, self.chatPanel.chatStrHandle:GetTextKeyTab())
  local data = {inputData = textData, message = message}
  local msg = {
    chatType = _chatChannelEnum,
    textData = data,
    toRoleId = ViewData.meData.id
  }
  EventManager.Dispatch(Event.Chat_ReqChat, msg)
end

function Chat_ChatUI:InitUI()
  _, self.normalChatHeight = self.go_tempChar:GetSizeDelta()
  _, self.systemChatHeight = self.go_systemChar:GetSizeDelta()
  self.chatLimitWidth = 273
  self.systemLimitWidth = 364
  self.systemCharBubbleRect = self.img_SystemCharBubble.transform:GetComponent("RectTransform")
  self.charBubbleRect = self.img_charBubble.transform:GetComponent("RectTransform")
  UnityEngineUI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.systemCharBubbleRect)
  UnityEngineUI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.charBubbleRect)
  self.systemWidth, self.systemHeight = 385, 29
  self.normalWidth, self.normalHeight = 300, 40
  self:InitToggle()
  self:InitBaseInputChat()
  self:InitDisplay()
  self:CreateMessageTableView()
  self:CreatePlayerTableView()
  self.channelTag = ChatChannelEnum.WORLD
  self.selectChannel = ChatChannelEnum.WORLD
  self:UpdateInputType(ChatData.curChannel)
  self.btn_voice:SetActive(VoiceUtility.isAllowYvVoice())
end

function Chat_ChatUI:InitToggle()
  self.toggleTab = {}
  self.tog_all.channel = ChatChannelEnum.ALL
  self.tog_crossRealm.channel = ChatChannelEnum.CROSS_REALM
  self.tog_world.channel = ChatChannelEnum.WORLD
  self.tog_nearby.channel = ChatChannelEnum.LOCAL
  self.tog_guild.channel = ChatChannelEnum.GUILD
  self.tog_team.channel = ChatChannelEnum.TEAM
  self.tog_private.channel = ChatChannelEnum.PRIVATE
  self.tog_system.channel = ChatChannelEnum.SYSTEM
  self.tog_recruit.channel = ChatChannelEnum.RECRUIT
  self.tog_union.channel = ChatChannelEnum.UNION
  self.tog_crossRealm.tag = CS.UnityEngine.UI.Dropdown.OptionData(ChatUtility.GetChannelName(ChatChannelEnum.CROSS_REALM))
  self.tog_world.tag = CS.UnityEngine.UI.Dropdown.OptionData(ChatUtility.GetChannelName(ChatChannelEnum.WORLD))
  self.tog_nearby.tag = CS.UnityEngine.UI.Dropdown.OptionData(ChatUtility.GetChannelName(ChatChannelEnum.LOCAL))
  self.tog_guild.tag = CS.UnityEngine.UI.Dropdown.OptionData(ChatUtility.GetChannelName(ChatChannelEnum.GUILD))
  self.tog_team.tag = CS.UnityEngine.UI.Dropdown.OptionData(ChatUtility.GetChannelName(ChatChannelEnum.TEAM))
  self.tog_union.tag = CS.UnityEngine.UI.Dropdown.OptionData(ChatUtility.GetChannelName(ChatChannelEnum.UNION))
  table.insert(self.toggleTab, self.tog_all)
  table.insert(self.toggleTab, self.tog_crossRealm)
  table.insert(self.toggleTab, self.tog_world)
  table.insert(self.toggleTab, self.tog_nearby)
  table.insert(self.toggleTab, self.tog_guild)
  table.insert(self.toggleTab, self.tog_team)
  table.insert(self.toggleTab, self.tog_private)
  table.insert(self.toggleTab, self.tog_system)
  table.insert(self.toggleTab, self.tog_recruit)
  table.insert(self.toggleTab, self.tog_union)
end

function Chat_ChatUI:CreateMessageTableView()
  self.msgTableView = UITableView()
  self.msgTableView:SetLowerMargin(10)
  self.msgTableView:SetScrollView(self.ScrollView)
  self.msgTableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.msgTableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.msgTableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.msgTableView:SetResetCellCallback(self, self.ResetCell)
  self.msgTableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
end

function Chat_ChatUI:ResetCell(cell)
  local img_sound = cell:GetChild("img_sound")
  if img_sound and img_sound.voiceAnim then
    img_sound:GetChild("sound2"):SetAlpha(1)
    img_sound:GetChild("sound3"):SetAlpha(1)
    img_sound.voiceAnim:Kill()
    img_sound.voiceAnim = nil
  end
end

function Chat_ChatUI:ScalarForCellInTableView(index)
  local curChannelData = ChatData.CurChannelData()
  local chatData = curChannelData:GetValueByIndex(index)
  if not chatData then
    return
  end
  local msg = ChatUtility.UpdateOnlyChatUIMsg(chatData)
  local lab, height, resHeight
  local isNormal = chatData.chatType ~= ChatChannelEnum.SYSTEM and (chatData.isSystemChatFormat == nil or chatData.isSystemChatFormat == false)
  local isVoice = chatData.chatMsg.inputData.type == ChatInfoEnum.Voice
  if isNormal then
    self.lab_tempChar:SetText(msg)
    lab = self.lab_tempChar
    height = self.normalHeight
    _, resHeight = self:UpdateNormalTextLength(self.lab_tempChar, self.img_charBubble)
  else
    local systemName = ChatUtility.UpdateName(chatData)
    self.lab_SystemChar:SetText(string.format("%s%s", systemName, msg))
    lab = self.lab_SystemChar
    height = self.systemHeight
    _, resHeight = self:UpdateSystemTextLength(self.lab_SystemChar, self.img_SystemCharBubble)
  end
  local labHeight = resHeight - height
  labHeight = 0 < labHeight and labHeight or 0
  local res = labHeight + (isNormal and self.normalChatHeight or self.systemChatHeight) + (isVoice and 40 or 0)
  return res
end

function Chat_ChatUI:NumberOfCellsInTableView()
  return ChatData.CurChannelDataCount()
end

function Chat_ChatUI:CellAtIndexInTableView(index)
  local curChannelData = ChatData.CurChannelData()
  local chatData = curChannelData:GetValueByIndex(index)
  if not chatData then
    return
  end
  if chatData.chatType == ChatChannelEnum.SYSTEM or chatData.isSystemChatFormat then
    return self.msgTableView:ReuseOrCreateCell(self.go_systemChar)
  end
  local roleId = chatData.roleChatInfo and chatData.roleChatInfo.roleId
  if roleId == nil then
    roleId = chatData.from and chatData.from.roleId or 0
  end
  if roleId == RoleManager.me.id then
    return self.msgTableView:ReuseOrCreateCell(self.go_selfPlayerChar)
  else
    return self.msgTableView:ReuseOrCreateCell(self.go_otherPlayerChar)
  end
end

function Chat_ChatUI:UpdateNormalTextLength(lab, content)
  local width = lab.text.preferredWidth
  if width > self.chatLimitWidth then
    content:SetHorizontalFit(FitModeEnum.Unconstrained)
    content:SetSizeDelta(self.normalWidth, 0)
  else
    content:SetHorizontalFit(FitModeEnum.PreferredSize)
  end
  UnityEngineUI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.charBubbleRect)
  return self.charBubbleRect:GetSizeDelta()
end

function Chat_ChatUI:UpdateSystemTextLength(lab, content)
  local width = lab.text.preferredWidth
  if width > self.systemLimitWidth then
    content:SetHorizontalFit(FitModeEnum.Unconstrained)
    content:SetSizeDelta(self.systemWidth, 0)
  else
    content:SetHorizontalFit(FitModeEnum.PreferredSize)
  end
  UnityEngineUI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.systemCharBubbleRect)
  return self.systemCharBubbleRect:GetSizeDelta()
end

function Chat_ChatUI:PlayAudioAnim(control)
  local allLoadCell = self.msgTableView:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    local cell = v.loadedCell
    local img_sound = cell:GetChild("img_sound")
    if img_sound and img_sound.voiceAnim then
      img_sound.voiceAnim:Kill()
      img_sound.voiceAnim = nil
    end
  end
  control:GetChild("sound2"):SetAlpha(0)
  control:GetChild("sound3"):SetAlpha(0)
  local quence = DOTween.Sequence()
  quence:AppendInterval(0.5)
  quence:AppendCallback(function()
    control:GetChild("sound2"):SetAlpha(1)
  end)
  quence:AppendInterval(0.5)
  quence:AppendCallback(function()
    control:GetChild("sound3"):SetAlpha(1)
  end)
  quence:AppendInterval(0.5)
  quence:AppendCallback(function()
    control:GetChild("sound2"):SetAlpha(0)
  end)
  quence:AppendCallback(function()
    control:GetChild("sound3"):SetAlpha(0)
  end)
  quence:SetLoops(-1, CS.DG.Tweening.LoopType.Restart):OnComplete(function()
    control:GetChild("sound2"):SetAlpha(1)
    control:GetChild("sound3"):SetAlpha(1)
    control.voiceAnim = nil
  end)
  control.voiceAnim = quence
end

function Chat_ChatUI:UpdateNormalChat(index)
  local curChannelData = ChatData.CurChannelData()
  local chatData = curChannelData:GetValueByIndex(index)
  if not chatData then
    return
  end
  if chatData.chatType == ChatChannelEnum.SYSTEM or chatData.isSystemChatFormat then
    return
  end
  local chatCell = self.msgTableView:GetLoadedCell(index)
  local img_charBubble = chatCell:GetChild("img_charBubble")
  local lab_playChar = chatCell:GetChild("img_charBubble/lab_playChar")
  local lab_name = chatCell:GetChild("lab_name")
  local headPortrait = chatCell:GetChild("img_headFrame/headPortrait")
  local img_headFrame = chatCell:GetChild("img_headFrame")
  local img_sound = chatCell:GetChild("img_sound")
  local lab_soundTime = img_sound:GetChild("soundTime")
  local img_soundCharBubble = img_sound:GetChild("img_charBubble")
  local lab_soundPlayChar = img_soundCharBubble:GetChild("lab_playChar")
  local isVoice = chatData.chatMsg.inputData.type == ChatInfoEnum.Voice
  img_charBubble:SetActive(not isVoice)
  img_sound:SetActive(isVoice)
  lab_soundTime:SetText(isVoice and Mathf.Floor(chatData.chatMsg.inputData.voiceTime / 1000) .. "s" or 0)
  img_sound.fileId = isVoice and chatData.chatMsg.inputData.fileId or 0
  img_sound:SetOnClick(self, self.PlayVoice)
  if isVoice and VoiceManager.GetCurPlayAudioFileId() == string.format("https:%s", chatData.chatMsg.inputData.fileId) then
    self:PlayAudioAnim(img_sound)
  end
  local chatControl = {
    lab_playChar = isVoice and lab_soundPlayChar or lab_playChar,
    headPortrait = headPortrait,
    img_headFrame = img_headFrame,
    lab_name = lab_name,
    img_charBubble = isVoice and img_soundCharBubble or img_charBubble
  }
  self:UpdateNormalChatCell(chatControl, index, chatData)
  self:UpdateNormalTextLength(chatControl.lab_playChar, chatControl.img_charBubble)
end

function Chat_ChatUI:UpdateSystemChat(index)
  local curChannelData = ChatData.CurChannelData()
  local chatData = curChannelData:GetValueByIndex(index)
  if not chatData then
    return
  end
  local isNormal = chatData.chatType ~= ChatChannelEnum.SYSTEM and (chatData.isSystemChatFormat == nil or chatData.isSystemChatFormat == false)
  if isNormal then
    return
  end
  local chatCell = self.msgTableView:GetLoadedCell(index)
  local img_SystemCharBubble = chatCell:GetChild("img_SystemCharBubble")
  local lab_SystemChar = chatCell:GetChild("img_SystemCharBubble/lab_SystemChar")
  local lab_SystemName = chatCell:GetChild("lab_SystemName")
  local chatControl = {
    lab_playChar = lab_SystemChar,
    lab_name = lab_SystemName,
    img_charBubble = img_SystemCharBubble
  }
  self:UpdateSystemChatCell(chatControl, index, chatData)
  self:UpdateSystemTextLength(lab_SystemChar, img_SystemCharBubble)
end

function Chat_ChatUI:CellAtIndexInTableViewWillAppear(index)
  self:UpdateNormalChat(index)
  self:UpdateSystemChat(index)
end

function Chat_ChatUI:PlayVoice(control)
  VoiceManager.PlayAudio(control.fileId)
end

function Chat_ChatUI:UpdateNormalChatCell(chatControl, index, chatData)
  local spriteName = ChatUtility.GetChatHeadSpriteName(chatData)
  local haveSpriteName = string.isNullOrEmpty(spriteName) == false
  if haveSpriteName then
    self:SetSprite("Atlas_headPortrait", spriteName, chatControl.headPortrait)
  end
  chatControl.img_headFrame:SetActive(haveSpriteName)
  local msg = ChatUtility.UpdateOnlyChatUIMsg(chatData)
  chatControl.lab_playChar.index = index
  chatControl.lab_playChar.inputData = chatData.chatMsg.inputData
  local name = ChatUtility.UpdateName(chatData)
  chatControl.lab_name:SetText(name)
  chatControl.lab_playChar:SetText(msg)
  chatControl.lab_playChar:SetOnTextPointerClick(self, self.ExecuteTextOrder)
  if chatData.from and chatData.from.roleId ~= RoleManager.me.id then
    chatControl.headPortrait.id = chatData.from.roleId
    chatControl.headPortrait.roleName = chatData.from.name
    chatControl.headPortrait.unionId = chatData.from.unionId
    chatControl.headPortrait.career = chatData.from.career
    chatControl.headPortrait.unionName = chatData.from.unionName
    chatControl.headPortrait.unionPosition = chatData.from.unionPosition
    chatControl.headPortrait.fight = chatData.from.fight
    chatControl.headPortrait.level = chatData.from.level
    chatControl.headPortrait.serverId = chatData.from.serverId
    chatControl.headPortrait.hostId = chatData.hostId
    chatControl.headPortrait:SetOnClick(self, self.OpenRoleInterUI)
  elseif chatData.roleChatInfo and chatData.roleChatInfo.roleId ~= RoleManager.me.id then
    chatControl.headPortrait.id = chatData.roleChatInfo.roleId
    chatControl.headPortrait.roleName = chatData.roleChatInfo.name
    chatControl.headPortrait.unionId = chatData.roleChatInfo.unionId
    chatControl.headPortrait.career = chatData.roleChatInfo.career
    chatControl.headPortrait.unionName = chatData.roleChatInfo.unionName
    chatControl.headPortrait.unionPosition = chatData.roleChatInfo.unionPosition
    chatControl.headPortrait.fight = chatData.roleChatInfo.fight
    chatControl.headPortrait.level = chatData.roleChatInfo.level
    chatControl.headPortrait.serverId = chatData.roleChatInfo.serverId
    chatControl.headPortrait.hostId = chatData.hostId
    chatControl.headPortrait:SetOnClick(self, self.OpenRoleInterUI)
  else
    chatControl.headPortrait:SetOnClick(self, self.DontDoNothing)
  end
end

function Chat_ChatUI:UpdateSystemChatCell(chatControl, index, chatData)
  local msg = ChatUtility.UpdateOnlyChatUIMsg(chatData)
  chatControl.lab_playChar.index = index
  chatControl.lab_playChar.inputData = chatData.chatMsg.inputData
  local systemName = ChatUtility.UpdateName(chatData)
  chatControl.lab_playChar:SetText(string.format("%s%s", systemName, msg))
  chatControl.lab_playChar:SetOnTextPointerClick(self, self.ExecuteTextOrder)
end

function Chat_ChatUI:CreatePlayerTableView()
  self.playerTableview = UITableView()
  self.playerTableview:SetLowerMargin(0)
  self.playerTableview:SetScrollView(self.sw_privateChoiceList)
  _, self.bg_privateChoiceListSizeY = self.Bg_privateChoiceList:GetSizeDelta()
  self.playerTableview:SetScalarForCellInTableView(self, self.GetSizePlayerCell)
  self.playerTableview:SetTotalCellCount(self, self.GetPlayerCountCount)
  self.playerTableview:SetCellAtIndexInTableView(self, self.GetPlayerCell)
  self.playerTableview:SetCellAtIndexInTableViewWillAppear(self, self.UpdatePlayerInfoCell)
  self.selectRoleIndex = 1
  self.playerTableview:ReloadData(1)
end

function Chat_ChatUI:GetPlayerDataByType(type)
  if type == "history" then
    return FriendData.FriendList[FriendTypeEnum.HISTORY]
  elseif type == "friend" then
    return FriendData.FriendList[FriendTypeEnum.FRIEND]
  else
    return FriendData.FriendList[FriendTypeEnum.UNION]
  end
end

function Chat_ChatUI:GetSizePlayerCell()
  return self.bg_privateChoiceListSizeY
end

function Chat_ChatUI:GetPlayerCell()
  return self.playerTableview:ReuseOrCreateCell(self.Bg_privateChoiceList)
end

function Chat_ChatUI:GetPlayerCountCount()
  return table.count(self:GetPlayerDataByType(self.priType))
end

function Chat_ChatUI:UpdatePlayerInfoCell(index)
  local playerInfoCell = self.playerTableview:GetLoadedCell(index)
  local playerData = self:GetPlayerDataByType(self.priType)
  local lab_name = playerInfoCell:GetChild("lab_name")
  playerInfoCell.id = playerData[index].info.roleId
  playerInfoCell.name = playerData[index].info.name
  playerInfoCell:SetOnClick(self, self.SetPrivateLinkman)
  lab_name:SetText(playerData[index].info.name)
  playerInfoCell:GetChild("img_bg"):SetActive(self.selectRoleIndex == index)
end

function Chat_ChatUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:UpdateInputFieldName()
end

function Chat_ChatUI:UpdateInputFieldName()
  if not self.args then
    return
  end
  if self.args.chatType == ChatChannelEnum.PRIVATE then
    self.InputField_Name:SetInputText(self.args.roleName)
  end
end

function Chat_ChatUI:OnHide()
  self.chatPanel:OnHide()
  self:StopMsgCoroutine()
  if self.msgTableView then
    self.msgTableView:UnloadAllCells()
  end
end

function Chat_ChatUI:OnDestroy()
  self:StopMsgCoroutine()
end

function Chat_ChatUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.Button_Close)
  self.btn_chat_shrink:SetOnClick(self, self.Button_Close)
  self.btn_Choice:SetOnClick(self, self.ShowPrivateChoice)
  self.btn_establishTeam:SetOnClick(self, self.EstablishTeam)
  self.btn_joinTeam:SetOnClick(self, self.JoinTeam)
  self.btn_establishGuild:SetOnClick(self, self.EstablishGuild)
  self.btn_joinGuild:SetOnClick(self, self.JoinGuild)
  self.Dropdown_Channel:SetOnDropDownValueChanged(self, self.UpdateDropDownChannel)
  self.ScrollView:SetOnPointerClick(self, self.HideAllOtherUI)
  self:SetChannelToggleClick()
  self:SetPrivateTogClickEvent()
  self.chatPanel:RegistChatPanelClickEvent()
  self.InputField_Name:SetOnValueChanged(self, self.InputField_NameValueChanged)
  self.InputField_Name:SetOnEndEdit(self, self.InputField_NameEndEdit)
end

function Chat_ChatUI:InputField_NameValueChanged(control)
  self.limit = self.InputField_Name.transform:GetComponent("InputField")
  if self.limit.characterLimit ~= 9 then
    self.limit.characterLimit = 9
  end
end

function Chat_ChatUI:InputField_NameEndEdit(control)
  local inputText = self.InputField_Name:GetInputText()
  local length = string.GetKoreanStrCount(inputText)
  if 7 < length then
    self.limit.text = string.KoreanStrSub(inputText, 1, 6)
  end
  self.limit = 7
end

function Chat_ChatUI:EstablishTeam()
  EventManager.Dispatch(Event.Team_CreateTeam, nil)
end

function Chat_ChatUI:JoinTeam()
  EventManager.Dispatch(Event.Team_OpenTeamsPanel, nil)
end

function Chat_ChatUI:EstablishGuild()
  UIManager.Hide(UIID.ChatUI)
  UIManager.Show(UIID.WarAlliance_menuUI, {openSecondTab = 1})
end

function Chat_ChatUI:JoinGuild()
  UIManager.Hide(UIID.ChatUI)
  UIManager.Show(UIID.WarAlliance_menuUI)
end

function Chat_ChatUI:SetInputFieldTextClickEvent()
  self.Text_Message:SetOnTextPointerClick(self, self.ExecuteTextOrder)
end

function Chat_ChatUI:ExecuteTextOrder(control, eventData, key)
  local inputData = control.inputData[key]
  if inputData.announcemType then
    ChatUtility.GetChatInfoTab(inputData.announcemType, inputData, control, eventData)
  else
    ChatUtility.GetChatInfoTab(inputData.type, inputData, control, eventData)
  end
end

function Chat_ChatUI:ShowBagEquipInfoUI(index, linkIndex)
  UIManager.Show(UIID.Bag_EquipInfoUI)
end

function Chat_ChatUI:ShowTeamUI()
  local openType = {
    openType = ShowTeamType.MyApplyType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function Chat_ChatUI:OpenRoleInterUI(control)
  RoleInteractData.roleId = control.id
  RoleInteractData.roleName = control.roleName
  RoleInteractData.unionId = control.unionId
  RoleInteractData.career = control.career
  RoleInteractData.unionName = control.unionName
  RoleInteractData.unionPosition = control.unionPosition
  RoleInteractData.fight = control.fight
  RoleInteractData.level = control.level
  RoleInteractData.serverId = control.serverId
  RoleInteractData.interactType = RoleOpenType.ChatOpen
  NetManager.Send(RoleMessage.ReqTeamEquipsInfo, {
    roleId = control.id,
    hostId = control.hostId
  })
end

function Chat_ChatUI:DontDoNothing(control)
end

function Chat_ChatUI:SetPrivateTogClickEvent()
  self.tog_go_history.priType = "history"
  self.tog_go_friend.priType = "friend"
  self.tog_go_guild.priType = "guild"
  self.tog_go_history:SetOnToggleChanged(self, self.RefreshPrivate)
  self.tog_go_friend:SetOnToggleChanged(self, self.RefreshPrivate)
  self.tog_go_guild:SetOnToggleChanged(self, self.RefreshPrivate)
end

function Chat_ChatUI:RefreshPrivate(control, isOn)
  control:GetChild("img_clickeffect"):SetActive(isOn)
  if isOn == false then
    return
  end
  if control.priType == "history" then
    self:ShowHistory()
  elseif control.priType == "friend" then
    self:ShowFriend()
  else
    self:ShowGuild()
  end
  self.priType = control.priType
end

function Chat_ChatUI:ShowHistory()
  NetManager.Send(FriendMessage.ReqOpenFriendPanel, {
    type = FriendTypeEnum.HISTORY
  })
end

function Chat_ChatUI:ShowFriend()
  NetManager.Send(FriendMessage.ReqOpenFriendPanel, {
    type = FriendTypeEnum.FRIEND
  })
end

function Chat_ChatUI:ShowGuild()
  NetManager.Send(FriendMessage.ReqOpenFriendPanel, {
    type = FriendTypeEnum.UNION
  })
end

function Chat_ChatUI:ShowPrivateChoice()
  self:ShowHistory()
  BlockerUtility.Show(self.img_historyPanel)
end

function Chat_ChatUI:SetPrivateLinkman(control)
  FriendData.SelectSearch = FriendTypeEnum.FRIEND
  self.InputField_Name:SetInputText(control.name)
  self.chatRoleId = control.id
  self:SetUItActive(self.img_privateChoice, false)
  BlockerUtility.Hide()
end

function Chat_ChatUI:UpdateDropDownChannel()
  local dropIndex = self.Dropdown_Channel:GetSelectValue()
  self.selectChannel = ChatUtility.GetChatChannelTab(dropIndex)
  if self.selectChannel == ChatChannelEnum.PRIVATE then
    self.Dropdown_Channel:GetChild("Label"):SetActive(false)
  else
    self.Dropdown_Channel:GetChild("Label"):SetActive(true)
  end
  self.baseInputChat[self.selectChannel]()
  if self.tagIsManulChanged == true then
    self.channelTag = self.selectChannel
  else
    self.tagIsManulChanged = true
  end
end

function Chat_ChatUI:UpdateSelectChatChannel(channelTag)
  if channelTag == ChatChannelEnum.ALL then
    self.Dropdown_Channel:SetInteractable(true)
    self.Arrow:SetActive(true)
    local dropIndex = self.Dropdown_Channel:GetSelectValue()
    self.selectChannel = ChatUtility.GetChatChannelTab(dropIndex)
  else
    self.Dropdown_Channel:SetInteractable(false)
    self.Arrow:SetActive(false)
    self.selectChannel = channelTag
  end
  self.tagIsManulChanged = false
end

function Chat_ChatUI:SetChannelToggleClick()
  for k, v in pairs(self.toggleTab) do
    v:SetOnToggleChanged(self, self.ReloadMessagePanel)
  end
end

function Chat_ChatUI:InitBaseInputChat()
  local commonUI = {
    "Dropdown_Channel",
    "InputField_ChatInput/btn_voice",
    "InputField_ChatInput",
    "btn_other",
    "Button_OK"
  }
  local privateUI = {
    "btn_Choice",
    "InputField_Name"
  }
  
  local function SetSizeAndPos(i, templateInputChat)
    local realUI = self.img_inputChat:GetChild(commonUI[i])
    local fakeUI = templateInputChat:GetChild(commonUI[i])
    realUI:SetAnchoredPosition(fakeUI:GetAnchoredPosition())
    realUI:SetSizeDelta(fakeUI:GetSizeDelta())
  end
  
  self.baseInputChat = {
    [ChatChannelEnum.PRIVATE] = function()
      for i = 1, #commonUI do
        SetSizeAndPos(i, self.img_inputPrivateChat)
      end
      for i = 1, #privateUI do
        local realUI = self.img_inputChat:GetChild(privateUI[i])
        self:SetUItActive(realUI, true)
      end
      self.img_inputChat:GetChild("Dropdown_Channel"):SetActive(false)
    end
  }
  setmetatable(self.baseInputChat, {
    __index = function()
      return function()
        self.img_inputChat:GetChild("Dropdown_Channel"):SetActive(self.tog_all:GetIsOn())
        local size = self.tog_all:GetIsOn() and Vector2(276, 38) or Vector2(386, 38)
        self.img_inputChat:GetChild("InputField_ChatInput"):SetSizeDelta(size.x, size.y)
        local pos = self.tog_all:GetIsOn() and Vector2(50, 33) or Vector2(-4, 33)
        self.img_inputChat:GetChild("InputField_ChatInput"):SetAnchoredPosition(pos.x, pos.y)
        for i = 1, #privateUI do
          local realUI = self.img_inputChat:GetChild(privateUI[i])
          self:SetUItActive(realUI, false)
        end
      end
    end
  })
end

function Chat_ChatUI:InitDisplay()
  local displayTab = {
    team = self.go_noTeam,
    guild = self.go_noGuild,
    system = self.go_noSystem,
    recruit = self.go_noRecruit,
    null = self.img_inputChat
  }
  
  local function DisplayUIByName(name)
    for k, v in pairs(displayTab) do
      if k == name then
        self:SetUItActive(v, true)
      else
        self:SetUItActive(v, false)
      end
    end
  end
  
  self.displayBaseChannel = {
    [ChatChannelEnum.GUILD] = function()
      if RoleManager.me.unionId == 0 then
        DisplayUIByName("guild")
      else
        DisplayUIByName("null")
      end
    end,
    [ChatChannelEnum.TEAM] = function()
      if TeamData.teamId == 0 then
        DisplayUIByName("team")
      else
        DisplayUIByName("null")
      end
    end,
    [ChatChannelEnum.SYSTEM] = function()
      DisplayUIByName("system")
    end,
    [ChatChannelEnum.RECRUIT] = function()
      DisplayUIByName("recruit")
    end
  }
  setmetatable(self.displayBaseChannel, {
    __index = function()
      return function()
        DisplayUIByName("null")
      end
    end
  })
end

function Chat_ChatUI:ReloadMessagePanel(control, isOn)
  if isOn == false then
    control:GetChild("img_clickeffect"):SetActive(isOn)
    return
  end
  self:UpdateInputType(control.channel)
  self:UpdateMessagePanel(control.channel)
  self:UpdateSelectChatChannel(control.channel)
  control:GetChild("img_clickeffect"):SetActive(isOn)
  self:StopMsgCoroutine()
end

function Chat_ChatUI:UpdateMessagePanel(channel)
  self.msgTableView:ReloadData(1)
  self.msgTableView:ScrollToCellAtIndex(ChatData.CurChannelDataCount())
end

function Chat_ChatUI:UpdateInputType(channel)
  ChatData.curChannel = channel
  if channel == ChatChannelEnum.ALL then
    self.baseInputChat[ChatChannelEnum.WORLD]()
  else
    self.baseInputChat[ChatData.curChannel]()
  end
  self.displayBaseChannel[ChatData.curChannel]()
end

function Chat_ChatUI:Button_Close(control)
  UIManager.Hide(UIID.ChatUI)
end

function Chat_ChatUI:RegistEvents()
  self:RegistEvent(Event.Chat_ResChat, self.OnResChat, self)
  self:RegistEvent(Event.Chat_SendMessage, self.SendChatMessage, self)
  self:RegistEvent(Event.Friend_ResFriendList, self.UpdatePlayerList, self)
  self:RegistEvent(Event.Team_RefreshTeamInfo, self.UpdateTeamUI, self)
  self:RegistEvent(Event.UpdateCrossRealmCondition, self.RefreshChannel, self)
  self:RegistEvent(Event.Chat_RefreshChat, self.RefreshChat, self)
  self:RegistEvent(Event.Chat_VoicePlay, self.Chat_VoicePlay, self)
  self:RegistEvent(Event.Chat_VoiceStop, self.Chat_VoiceStop, self)
  self:RegistEvent(Event.Chat_CampRefresh, self.RefreshChannel, self)
  self:RegistEvent(Event.Chat_PrivateChat, self.Chat_PrivateChat, self)
end

function Chat_ChatUI:Chat_PrivateChat(_, roleId)
  self:JudgePlayerInfo(roleId)
end

function Chat_ChatUI:Chat_VoicePlay(_, fileId)
  local allLoadCell = self.msgTableView:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    local cell = v.loadedCell
    local img_sound = cell:GetChild("img_sound")
    if img_sound and string.format("https:%s", img_sound.fileId) == fileId then
      self:PlayAudioAnim(img_sound)
    end
  end
end

function Chat_ChatUI:Chat_VoiceStop()
  local allLoadCell = self.msgTableView:GetAllLoadCell()
  for i, v in pairs(allLoadCell) do
    local cell = v.loadedCell
    local img_sound = cell:GetChild("img_sound")
    if img_sound and img_sound.voiceAnim then
      img_sound:GetChild("sound2"):SetAlpha(1)
      img_sound:GetChild("sound3"):SetAlpha(1)
      img_sound.voiceAnim:Kill()
      img_sound.voiceAnim = nil
    end
  end
end

function Chat_ChatUI:RefreshChat()
  if self.msgTableView then
    self.msgTableView:ReloadData()
  end
end

function Chat_ChatUI:UpdateTeamUI()
  if self.selectChannel == ChatChannelEnum.TEAM then
    if TeamData.teamId == 0 then
      self:SetUItActive(self.go_noTeam, true)
      self.img_inputChat:SetActive(false)
    else
      self:SetUItActive(self.go_noTeam, false)
      self.img_inputChat:SetActive(true)
    end
  end
end

function Chat_ChatUI:UpdatePlayerList(_, friendType)
  if friendType == FriendTypeEnum.FRIEND then
    self.playerTableview:ReloadData()
  elseif friendType == FriendTypeEnum.HISTORY then
    local index = FriendData.GetFriendIndex(FriendTypeEnum.HISTORY, self.chatRoleId)
    self.selectRoleIndex = index ~= -1 and index or 1
    self.playerTableview:ReloadData(self.selectRoleIndex)
  elseif friendType == FriendTypeEnum.UNION then
    self.playerTableview:ReloadData()
  end
end

function Chat_ChatUI:JudgePlayerInfo(roleId)
  if roleId == 0 then
    return
  end
  self.roleId = roleId
  self:SendMessage()
end

function Chat_ChatUI:SendChatMessage(_, textData)
  if self.selectChannel == ChatChannelEnum.ALL then
    FloatingWordUtility.QuickBtnMsg({
      parent = self.Button_OK,
      msgStr = LocalizationUtility.GetUIWord("Chat_AllNotChat")
    })
    return
  elseif self.selectChannel == ChatChannelEnum.SYSTEM then
    FloatingWordUtility.QuickBtnMsg({
      parent = self.Button_OK,
      msgStr = LocalizationUtility.GetUIWord("Chat_SystemNotChat")
    })
    return
  elseif self.selectChannel == ChatChannelEnum.GUILD then
    if RoleManager.me.unionId == 0 then
      FloatingWordUtility.QuickBtnMsg({
        parent = self.Button_OK,
        msgStr = LocalizationUtility.GetUIWord("Chat_GuildNotChat")
      })
      return
    end
  elseif self.selectChannel == ChatChannelEnum.TEAM and TeamData.teamId == 0 then
    FloatingWordUtility.QuickBtnMsg({
      parent = self.Button_OK,
      msgStr = LocalizationUtility.GetUIWord("Chat_TeamNotChat")
    })
    return
  end
  local curTime = Time.GetServerTime()
  local endTime = RoleManager.me.cd[self.selectChannel] and RoleManager.me.cd[self.selectChannel].endTime or 0
  local intervalTime = TimeUtility.SecondApartFromTwoTime(curTime, endTime)
  if 0 < intervalTime then
    FloatingWordUtility.QuickBtnMsg({
      parent = self.Button_OK,
      msgStr = LocalizationUtility.GetUIWord("Chat_ChatCd")
    })
    return
  end
  self.textData = textData
  self:SearchPlayerByName()
end

function Chat_ChatUI:SearchPlayerByName()
  local roleName = self.InputField_Name:GetInputText()
  roleName = string.gsub(roleName, "%s+", "")
  ChatData.searchName = roleName
  if roleName ~= "" and self.selectChannel == ChatChannelEnum.PRIVATE then
    FriendData.SelectSearch = FriendTypeEnum.FRIEND
    NetManager.Send(ChatMessage.ReqSearchRoleId, {name = roleName})
  elseif roleName == "" and self.selectChannel == ChatChannelEnum.PRIVATE then
    self:Tips(LocalizationUtility.GetUIWord("qingshurunicheng"))
  else
    self.roleId = nil
    self:SendMessage()
  end
end

function Chat_ChatUI:SendMessage()
  local msg = {
    chatType = self.selectChannel,
    textData = self.textData,
    toRoleId = self.roleId
  }
  EventManager.Dispatch(Event.Chat_ReqChat, msg)
  self.chatPanel:RefreshInputChat()
end

function Chat_ChatUI:ShowMsg(channel)
  self.loadMsgChannel = channel
  self.isNeedLoadMsg = true
  self:StartMsgCoroutine()
end

function Chat_ChatUI:StartMsgCoroutine()
  if self.msgCoroutine then
    return
  end
  
  local function LoadMsg()
    while true do
      if self.loadMsgChannel == self.selectChannel or self.tog_all:GetIsOn() then
        local _, normalizePosY = self.msgTableView:GetNormalizedPosition()
        if normalizePosY < 0.1 then
          self.msgTableView:ReloadData()
          self.msgTableView:ScrollToCellAtIndexWithTime(ChatData.CurChannelDataCount(), 0.1, true, nil)
        else
          self.msgTableView:ReloadData()
        end
        self.isNeedLoadMsg = false
      end
      Coroutine.WaitForEndOfFrame()
      if not self.isNeedLoadMsg then
        self.msgCoroutine = nil
        Coroutine.Break()
      end
    end
  end
  
  self.msgCoroutine = Coroutine.Start(LoadMsg)
end

function Chat_ChatUI:StopMsgCoroutine()
  if self.msgCoroutine then
    Coroutine.Stop(self.msgCoroutine)
    self.msgCoroutine = nil
  end
end

function Chat_ChatUI:OnResChat(id, channel)
  self:ShowMsg(channel)
end

function Chat_ChatUI:Refresh()
  self:RefreshChannel()
  self.speakCdTab = {}
  self.tagIsManulChanged = true
  self.chatPanel:Refresh()
  self.msgTableView:ScrollToCellAtIndexWithTime(ChatData.CurChannelDataCount(), 0, true, nil)
  for k, v in pairs(self.toggleTab) do
    if v.channel == ChatData.curChannel then
      v:SetIsOn(true)
    end
  end
  local condition
  condition = ClientTable.cfg_Function_functionManager:TryGetValue(10000001, "id").condition
  self.btn_establishGuild:SetActive(ConditionManager.Check4D(condition))
  condition = ClientTable.cfg_Function_functionManager:TryGetValue(10000002, "id").condition
  self.btn_joinGuild:SetActive(ConditionManager.Check4D(condition))
  if UIManager.IsVisible(UIID.Logo_18) then
    UIManager.Hide(UIID.Logo_18)
  end
end

function Chat_ChatUI:RefreshChannel()
  self:UpdateDropDownTag()
  self.selectChannel = self.args and self.args.chatType or self.selectChannel
  if not CrossRealmData.IsCrossRealm() and self.selectChannel == ChatChannelEnum.CROSS_REALM then
    self.selectChannel = ChatChannelEnum.WORLD
  end
  if not ChatData.isCampChannel and self.selectChannel == ChatChannelEnum.UNION then
    self.selectChannel = ChatChannelEnum.WORLD
  end
  local dropIndex = ChatUtility.GetDoroDownTab(self.selectChannel)
  self.Dropdown_Channel:SetSelectValue(dropIndex)
  local inputType = self.args and self.args.chatType or ChatData.curChannel or ChatChannelEnum.ALL
  if not CrossRealmData.IsCrossRealm() and self.selectChannel == ChatChannelEnum.CROSS_REALM then
    inputType = ChatChannelEnum.ALL
  end
  if not ChatData.isCampChannel and self.selectChannel == ChatChannelEnum.UNION then
    inputType = ChatChannelEnum.ALL
  end
  self:UpdateInputType(inputType)
  self:UpdateTogCrossRealm()
  self:UpdateTogUnion()
  self.msgTableView:ReloadData()
end

function Chat_ChatUI:UpdateTogCrossRealm()
  self.tog_crossRealm:SetActive(CrossRealmData.IsCrossRealm())
end

function Chat_ChatUI:UpdateTogUnion()
  self.tog_union:SetActive(ChatData.isCampChannel)
end

function Chat_ChatUI:UpdateDropDownTag()
  self.Dropdown_Channel:ClearOptions()
  local channelTag = {
    self.tog_world.tag,
    self.tog_nearby.tag,
    self.tog_guild.tag,
    self.tog_team.tag
  }
  if CrossRealmData.IsCrossRealm() then
    table.insert(channelTag, 1, self.tog_crossRealm.tag)
  end
  if ChatData.isCampChannel then
    table.insert(channelTag, self.tog_union.tag)
  end
  self.Dropdown_Channel:AddOptions(channelTag)
end

function Chat_ChatUI:SetUItActive(ui, isShow)
  ui:SetActive(isShow)
end

function Chat_ChatUI:Tips(tip)
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = tip,
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      UIManager.Hide(UIID.PromptTipUI)
    end
  })
end
