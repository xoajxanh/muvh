ChatPanel = class()

function ChatPanel:ctor(ui)
  self.ui = ui
  self:InitData()
  self:Init()
end

function ChatPanel:InitData()
  self.textData = {}
end

function ChatPanel:Init()
  self.inputChat = self.ui.InputField_ChatInput
  self.placeholder = self.ui.Placeholder
  self.btn_other = self.ui.btn_other
  self.btn_emoji = self.ui.btn_emoji
  self.btn_item = self.ui.btn_item
  self.btn_position = self.ui.btn_position
  self.Button_OK = self.ui.Button_OK
  self.btn_voice = self.ui.btn_voice
  self.img_other = self.ui.img_other
  self.bg_emojiList = self.ui.bg_emojiList
  self.go_itemInput = self.ui.go_itemInput
  self.Button_emoji = self.ui.Button_emoji
  self.tog_bag = self.ui.tog_bag
  self.tog_wear = self.ui.tog_wear
  self.go_voice = self.ui.go_voice
  self.chatStrHandle = ChatStrHandle()
  self:InitOtherBg()
  self:InitContent()
  self:InitEmojiData()
  self:InitItemUI()
end

local function EmojiOnCreate(ctr)
  ctr.icon = UIControl(ctr.transform, "img_icon")
end

local function EmojiRefresh(ctr, _, emojiData, ui)
  ui.ui:SetSprite("Atlas_Emoji", emojiData.name, ctr.icon)
  ctr.index = emojiData.index
  ctr:SetOnClick(ui, ui.SetEmojiMessage)
end

function ChatPanel:InitOtherBg()
  local othersBg = {
    emoji = self.bg_emojiList,
    item = self.go_itemInput
  }
  
  function self.changeOtherBg(name)
    for k, v in pairs(othersBg) do
      if name == k then
        self.img_other:SetActive(true)
        v:SetActive(true)
      else
        v:SetActive(false)
      end
    end
  end
end

function ChatPanel:InitContent()
  self.Button_emojiTemp = UIContainer(self.Button_emoji, self, EmojiOnCreate, EmojiRefresh)
end

function ChatPanel:RegistChatPanelClickEvent()
  self.btn_other:SetOnClick(self, self.ShowImgOther)
  self.btn_emoji:SetOnClick(self, self.ShowEmojiPanel)
  self.btn_item:SetOnClick(self, self.ShowItemPanel)
  self.btn_position:SetOnClick(self, self.SetPlayerPosMessage)
  self.Button_OK:SetOnClick(self, self.SendMessage)
  self.img_other:SetOnClick(self, self.HideUI)
  self.btn_voice:SetOnPress(self, self.btn_voiceOnPress, self.btn_voiceOnStopPress, 0.5)
  self:SetItemTypeTogClickEvent()
end

function ChatPanel:HideUI()
  self.changeOtherBg(1)
  self.tog_bag:SetIsOn(true)
  self.tog_wear:SetIsOn(false)
end

local onPress = false

function ChatPanel:btn_voiceOnPress(control)
  if not VoiceData.HasVoicePermission then
    FloatingWordUtility.QuickMsg("H\195\163y m\225\187\159 quy\225\187\129n h\225\186\161n voice")
    VoiceManager.RequestVoicePermission()
    return
  end
  if onPress then
    return
  end
  self.go_voice:SetActive(true)
  onPress = true
  local savePath = ""
  VoiceData.isCancelLuying = false
  VoiceManager.StartRecord(savePath, "1001#1#7555", 1, 0, nil, ChatPanel.UploadResponse, self.go_voice)
end

function ChatPanel.UploadResponse(_args)
  if _args.gameObject.activeSelf then
    _args.gameObject:SetActive(false)
  end
end

function ChatPanel:btn_voiceOnStopPress(control)
  onPress = false
  self.go_voice:SetActive(false)
  if not VoiceData.HasVoicePermission then
    return
  end
  VoiceData.isRecordAudio = false
  AudioManager.SetEnable(true)
  VoiceManager.StopRecord()
end

function ChatPanel:ShowImgOther(control)
  BlockerUtility.Show(self.img_other)
  self.changeOtherBg("emoji")
end

function ChatPanel:ShowItemPanel(control)
  if UIManager.IsVisible(UIID.ChatUI) then
    BlockerUtility.Show(self.go_itemInput)
  end
  self.changeOtherBg("item")
  self:ShowBagItem()
end

function ChatPanel:SetItemTypeTogClickEvent()
  self.tog_bag.itemType = "bag"
  self.tog_wear.itemType = "equip"
  self.tog_bag:SetOnToggleChanged(self, self.RefreshItem)
  self.tog_wear:SetOnToggleChanged(self, self.RefreshItem)
end

function ChatPanel:RefreshItem(control, isOn)
  if isOn == false then
    return
  end
  if control.itemType == "bag" then
    self:ShowBagItem()
  else
    self:ShowPlayerEquipItem()
  end
end

function ChatPanel:InitItemUI()
  local CellDataTbl = {
    curCellCount = BagInfoData.bagCellCount,
    totalCellCount = BagInfoData.bagCellCount,
    colCount = BagInfoData.colCount
  }
  self.dragTbl = UIDragCellContainer(self.ui, self.PutIn, nil, CellDataTbl, false, self.SetDataState)
end

function ChatPanel:InitBagData()
  self.dragTbl:SetParam(nil, self.Button_ShowUseOperation, true, true)
  local itemTab = table.clone(BagInfoData.TotalItems)
  self.dragTbl:SetData(itemTab, "ChatPanel:InitBagData")
end

function ChatPanel:InitWearData()
  self.dragTbl:SetParam(nil, self.Button_ShowUseOperation, true, true)
  local itemTab = self:RearrangeData(RoleManager.me.data.equipsData.Data)
  self.dragTbl:SetData(itemTab, "ChatPanel:InitBagData")
end

function ChatPanel:Button_ShowUseOperation(control)
  if control.data.itemData == nil then
    return
  end
  local itemCellData = control.data
  local itemData = itemCellData.itemData
  if itemData.bagGridIndex and itemData.bagGridIndex ~= 0 then
    local EnchantMen = gameMgr:GetAvatarManager():GetMainPlayer():GetEnchantEquipManager():GetEnchantEquipIndexDataByItem(itemData)
    if not table.isNullOrEmpty(EnchantMen) and not table.isNullOrEmpty(EnchantMen.m_ItemInfo) and not table.isNullOrEmpty(EnchantMen.m_ItemInfo.enchantAttr) then
      local EnchantMenInfo = {}
      for i, v in pairs(EnchantMen.m_ItemInfo.enchantAttr) do
        local equip_excell = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(v)
        local attr = EnchantEquipUtility:GetConfigAttributeDataTab(equip_excell)
        if not table.isNullOrEmpty(attr) then
          for a, b in pairs(attr) do
            local des = string.format(AttributeWordUtil.GetUIWord(b.attributeName, "enchantattributeUI"), MathUtility.FormatNum(b.attributeValue))
            table.insert(EnchantMenInfo, string.GetColorText(des, ItemQuality2ColorDic[2]))
          end
        end
      end
      itemData.ClientSettingsEnchantMen = EnchantMenInfo
    end
    if not table.isNullOrEmpty(EnchantMen) and 0 < EnchantMen.m_PointGrade then
      itemData.ClientSettingsEnchantMenDetail = {
        attr = EnchantEquipUtility:GetAppointEquipIndexAllAttributeDes({
          [1] = EnchantMen
        }),
        EnchantMen = EnchantMen
      }
    end
  end
  self.chatPanel:SetUItActive(self.chatPanel.img_other, false)
  local itemKey = self.chatPanel.chatStrHandle:GetInputStr(ChatInfoEnum.ITEM, itemData.itemId)
  self.chatPanel.textData[itemKey] = {
    type = ChatInfoEnum.ITEM,
    itemData = itemData
  }
  self.chatPanel.inputChat:MoveTextEnd()
  self.chatPanel:SetInputText(itemKey)
  BlockerUtility.Hide()
end

function ChatPanel:ShowBagItem()
  self:InitBagData()
end

function ChatPanel:ShowPlayerEquipItem()
  self:InitWearData()
end

function ChatPanel:ShowEmojiPanel()
  if UIManager.IsVisible(UIID.ChatUI) then
    BlockerUtility.Show(self.bg_emojiList)
  end
  self.changeOtherBg("emoji")
end

function ChatPanel:InitEmojiData()
  local emojiData = ClientTable.cfg_Chat_emojiManager:GetDic()
  emojiData = self:RearrangeData(emojiData)
  self:RefreshTempData(self.Button_emojiTemp, emojiData)
end

function ChatPanel:SetItemInfoMessage(control)
  self:SetUItActive(self.img_other, false)
  local itemKey = self.chatStrHandle:GetInputStr(ChatInfoEnum.ITEM, control.itemData.itemId)
  self.textData[itemKey] = {
    type = ChatInfoEnum.ITEM,
    itemData = control.itemData
  }
  self.inputChat:MoveTextEnd()
  self:SetInputText(itemKey)
  BlockerUtility.Hide()
end

function ChatPanel:SetPlayerPosMessage()
  if not TranScriptData.InTranscript then
    if not TranScriptData.InAllGodsscript then
      local posKey = self.chatStrHandle:GetInputStr(ChatInfoEnum.POS)
      self.textData[posKey] = {
        type = ChatInfoEnum.POS,
        x = RoleManager.me.cellPos.x,
        y = RoleManager.me.cellPos.y,
        mapId = SceneData.mapId,
        line = SceneData.line
      }
      self.inputChat:MoveTextEnd()
      self:SetInputText(posKey)
    else
      local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChatError_1")
      UIManager.Show(UIID.PromptTipUI, {
        title = "Nh\225\186\175c nh\225\187\159",
        textContent = uiWord,
        okText = "X\195\161c nh\225\186\173n",
        ok = function()
          UIManager.Hide(UIID.PromptTipUI)
        end
      })
    end
  else
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChatError_1")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = uiWord,
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
  end
  self:SetUItActive(self.img_other, false)
  BlockerUtility.Hide()
end

function ChatPanel:SetEmojiMessage(control)
  self:SetUItActive(self.img_other, false)
  local emojiKey = self.chatStrHandle:GetInputStr(ChatInfoEnum.IMG, control.index)
  self.inputChat:MoveTextEnd()
  self:SetInputText(emojiKey)
  BlockerUtility.Hide()
end

function ChatPanel:SetInputText(message)
  local msg = message
  msg = self.inputChat:GetInputText() .. msg
  self.inputChat:SetInputText(msg)
end

function ChatPanel:UpdateTextData(textData, textKeyTab)
  local textTab = {}
  for i, v in ipairs(textKeyTab) do
    if textData[v] then
      textTab[v] = textData[v]
    end
  end
  return textTab
end

function ChatPanel:SendMessage()
  local inputStr = self.inputChat:GetInputText()
  if GLogSwitch.UnityEditor then
    local startIndex, endIndex = string.find(inputStr, "@")
    if startIndex == endIndex and endIndex == 1 then
    else
      inputStr = Regex.Replace(inputStr, "\\d{8,}", "*")
    end
  else
    inputStr = Regex.Replace(inputStr, "\\d{8,}", "*")
  end
  inputStr = string.gsub(inputStr, "<", "*")
  local noSpaceStr = string.gsub(inputStr, "%s+", "")
  local message = self.chatStrHandle:GetChatText(inputStr)
  local textData = self:UpdateTextData(self.textData, self.chatStrHandle:GetTextKeyTab())
  local data = {inputData = textData, message = message}
  if noSpaceStr == "" then
    self:RefreshInputChat()
    return
  end
  EventManager.Dispatch(Event.Chat_SendMessage, data)
end

function ChatPanel:RefreshInputChat()
  self.chatStrHandle:ResetData()
  self.inputChat:SetInputText("")
  self.placeholder:SetText("Nh\225\186\173p n\225\187\153i dung chat")
  self.textData = {}
end

function ChatPanel:RefreshTempData(tempContainer, data)
  tempContainer:SetData(data)
  tempContainer:Refresh()
end

function ChatPanel:SetUItActive(ui, isShow)
  ui:SetActive(isShow)
end

function ChatPanel:RearrangeData(data)
  local totalData = {}
  for k, v in pairs(data) do
    table.insert(totalData, v)
  end
  return totalData
end

function ChatPanel:RefreshUI()
  self.inputChat:SetInputText("")
  self.chatStrHandle:ResetData()
end

function ChatPanel:OnHide()
  self:RefreshUI()
end

function ChatPanel:OnDestroy()
  self:RefreshUI()
end

function ChatPanel:Refresh()
  self:RefreshUI()
end
