local MessagePanelTemplate = {}

function MessagePanelTemplate:Init(data)
  self.goCallBack = data.goCallBack
  self.curTogIndex = data.curTogIndex
  self.relevancyBtn = data.relevancyBtn
  self.selectData = nil
  self:InitControls()
  self:InitContainer()
  self:BindUIEvent()
end

function MessagePanelTemplate:InitControls()
  self.btn_refresh = self:GetControl("InteractionUI/btn_refresh")
  self.tog_recordLog = self:GetControl("InteractionUI/tog_recordLog")
  self.choose_MessageType = self:GetControl("InteractionUI/choose_MessageType")
  self.filterInput_Info = self:GetControl("InteractionUI/filterInput_Info")
  self.btn_filterRefresh = self:GetControl("InteractionUI/filterInput_Info/btn_filterRefresh")
  self.btn_clear = self:GetControl("InteractionUI/btn_clear")
  self.item = self:GetControl("showTip/ScrollShowTip/Viewport/showTipTableContent/item")
  self.showTipType = self:GetControl("showTip/showTipType")
  self.showTipTime = self:GetControl("showTip/showTipTime")
  self.netMessage = self:GetControl("showTip/netMessage")
  self.logStackTrack = self:GetControl("showTip/ScrollViewLogStack/Viewport/Content/logStackTrack")
  self.contentGold = self:GetControl("InteractionUI/scroll_View/Viewport/contentGold")
  self.btn_Stow = self:GetControl("MessageTool/btn_Stow")
  self.btn_Open = self:GetControl("MessageTool/btn_Open")
  self.btn_Copy = self:GetControl("MessageTool/btn_Copy")
end

local function InitShowItemUI(ctr)
  ctr.itemBtn = UIControl(ctr.transform, "button")
  ctr.lab_name = UIControl(ctr.transform, "text")
end

local function pairsByKeys(t)
  local keysTab = {}
  for key, _ in pairs(t) do
    keysTab[table.count(keysTab) + 1] = key
  end
  table.sort(keysTab)
  local index = 0
  return function()
    index = index + 1
    return keysTab[index], t[keysTab[index]]
  end
end

function MessagePanelTemplate:InitContainer()
  self.showItemContainer = UIContainer(self.item, self, InitShowItemUI)
end

function MessagePanelTemplate:BindUIEvent()
  self.relevancyBtn:SetOnClick(self, self.ClickGoCallBack)
  self.btn_refresh:SetOnClick(self, self.RefreshOnClick)
  self.tog_recordLog:SetOnToggleChanged(self, self.RecordLogOnToggleChanged)
  self.choose_MessageType:SetOnDropDownValueChanged(self, self.ChooseOnDropDownValueChanged)
  self.btn_filterRefresh:SetOnClick(self, self.btn_filterRefreshOnClick)
  self.btn_clear:SetOnClick(self, self.btn_clearOnClick)
  self.btn_Stow:SetOnClick(self, self.btn_StowOnClick)
  self.btn_Open:SetOnClick(self, self.btn_OpenOnClick)
  self.btn_Copy:SetOnClick(self, self.btn_CopyOnClick)
end

function MessagePanelTemplate:ClickGoCallBack()
  if self.goCallBack then
    self.goCallBack(self.curTogIndex)
  end
end

function MessagePanelTemplate:RefreshOnClick()
  gameMgr:GetGMDataMgr():RefreshMessage()
end

function MessagePanelTemplate:RecordLogOnToggleChanged()
  gameMgr:GetGMDataMgr():SetReceiveState(self.tog_recordLog:GetIsOn())
end

function MessagePanelTemplate:ChooseOnDropDownValueChanged(_, selectIndex)
  gameMgr:GetGMDataMgr():SetMessageType(selectIndex)
end

function MessagePanelTemplate:btn_filterRefreshOnClick()
  local inputNumber = self.filterInput_Info:GetInputText()
  if not string.isNullOrEmpty(inputNumber) then
    gameMgr:GetGMDataMgr():SearchMessageData(tonumber(inputNumber))
  end
end

function MessagePanelTemplate:btn_clearOnClick()
  gameMgr:GetGMDataMgr():ClearMessageDataByType()
end

function MessagePanelTemplate:btn_StowOnClick()
  if self.Root then
    self:StowNode(self.Root)
    if self.showItemContainer then
      self.showItemContainer:SetActiveTable()
    end
    self:AnalysisNode(self.Root)
  end
end

function MessagePanelTemplate:btn_OpenOnClick()
  if self.Root then
    self:OpenNode(self.Root)
    self:AnalysisNode(self.Root)
  end
end

function MessagePanelTemplate:btn_CopyOnClick()
  CS.UnityEngine.GUIUtility.systemCopyBuffer = tostring(self.copyData)
end

function MessagePanelTemplate:Refresh(data, ui)
end

function MessagePanelTemplate:StowNode(node)
  if node.child and table.count(node.child) > 0 then
    for _, child_node in pairsByKeys(node.child) do
      if child_node.isClick then
        child_node.isOpen = false
        self:StowNode(child_node)
      end
    end
  end
end

function MessagePanelTemplate:OpenNode(node)
  if node.child and table.count(node.child) > 0 then
    for _, child_node in pairsByKeys(node.child) do
      if child_node.isClick then
        child_node.isOpen = true
        self:OpenNode(child_node)
      end
    end
  end
end

function MessagePanelTemplate:RefreshLeftListView(data)
  self:ResetRightListViewShow()
  self:RefreshLeftMessageView(data)
end

function MessagePanelTemplate:ResetRightListViewShow()
  if self.showItemContainer then
    self.showItemContainer:SetActiveTable()
  end
  self.showTipType:SetText("")
  self.showTipTime:SetText("")
  self.netMessage:SetText("")
  self.logStackTrack:SetText("")
end

function MessagePanelTemplate:RefreshLeftMessageView(data)
  if data == nil then
    return
  end
  self.selectData = GmMessageData.GetMessageDataManager(data)
  if self.selectData == nil or table.count(self.selectData) == 0 then
    self.contentGold:SetTopGridMaxCount(0)
    return
  end
  self:ResetButtonPitchOn()
  if self.recordDic == nil then
    self.recordDic = {}
  end
  local length = table.count(self.selectData)
  self.contentGold:SetTopGridMaxCount(length)
  local index = length - 1
  for _, v in pairsByKeys(self.selectData) do
    v.index = _
    local object = self.contentGold:GetTopGridObjectList()[index]
    if self.recordDic[object] == nil then
      self.recordDic[object] = luaTemplateManager.GetNewTemplate(object, LuaComponentTemplates.MessageItemTemplate)
    end
    index = index - 1
    self.recordDic[object]:Refresh(v)
  end
end

function MessagePanelTemplate:RefreshRightListView(data)
  self:ResetRightListViewShow()
  self:RefreshRightTopListView(data)
  self:RefreshRightBottomListView(data)
end

function MessagePanelTemplate:RefreshRightTopListView(data)
  self:SetButtonPitchOn(data.index)
  self.showTipType:SetText(data.typeName)
  self.showTipTime:SetText(data.time)
  self.netMessage:SetText(string.format("%s  %s", data.id, data.messageIdToName))
end

function MessagePanelTemplate:RefreshRightBottomListView(data)
  if data == nil and data.tableContent == nil then
    return
  end
  self.copyData, self.Root = nil, nil
  if data.type == GM_DataEnum.NetWork then
    self.Root = GM_MessageTreeLogic.GetTree(data.tableContent)
    if self.Root then
      self:AnalysisNode(self.Root)
      local strData = self:GetCopyText(self.Root, {})
      if not string.isNullOrEmpty(strData) then
        self.copyData = table.concat(strData, "\n")
      end
    end
  elseif data.type == GM_DataEnum.Log then
    self.logStackTrack:SetText(string.GetColorText(table.toString(data.tableContent), ItemQuality2ColorDic[7]))
    self.copyData = data.tableContent or ""
  end
end

function MessagePanelTemplate:AnalysisNode(node)
  if node.child == nil or table.count(node.child) == 0 then
    return
  end
  for _, child_node in pairsByKeys(node.child) do
    local obj = self.showItemContainer:GetOrCreateItem(child_node.index)
    obj.rectTransform:SetAsLastSibling()
    obj:SetActive(true)
    obj.lab_name.transform.localPosition = Vector3.New((child_node.tab - 1) * 20, 0, 0)
    if child_node.name ~= nil then
      if type(child_node.value) == "table" and 0 < table.count(child_node.value) then
        obj.lab_name:SetText(string.format("   <color=#E8D04B>%s%s</color>", child_node.isOpen and "\226\150\188" or "\226\150\182", tostring(child_node.name)))
      else
        obj.lab_name:SetText(string.format("   <color=#E8D04B>%s</color> : <color=#FF69B4>%s</color>", tostring(child_node.name), tostring(type(child_node.value) == "table" and table.toString(child_node.value) or child_node.value)))
      end
    end
    if child_node.isClick then
      obj.itemBtn:SetOnClick(self, function()
        if not child_node.isOpen then
          child_node.isOpen = true
          self.showItemContainer:SetActiveTable()
          self:AnalysisNode(self.Root)
        else
          child_node.isOpen = false
          self.showItemContainer:SetActiveTable()
          self:AnalysisNode(self.Root)
        end
        if child_node.value ~= nil and table.count(child_node.value) > 0 then
          obj.lab_name:SetText(string.format("   <color=#E8D04B>%s%s</color>", child_node.isOpen and "\226\150\188" or "\226\150\182", tostring(type(child_node.name) == "table" and table.toString(child_node.name) or child_node.name)))
        end
      end)
    else
      obj.itemBtn:SetOnClick(self, function()
      end)
    end
    if child_node.isOpen then
      self:AnalysisNode(child_node)
    end
  end
end

function MessagePanelTemplate:GetCopyText(node, dataTab)
  if node == nil or node.child == nil or table.count(node.child) == 0 then
    return
  end
  for i, child_node in pairsByKeys(node.child) do
    if child_node.name ~= nil then
      local str = ""
      if type(child_node.value) == "table" and 0 < table.count(child_node.value) then
        str = string.format("%s%s", child_node.isOpen and "\226\150\188" or "\226\150\182", tostring(child_node.name))
      else
        str = string.format("%s: %s", tostring(child_node.name), tostring(type(child_node.value) == "table" and table.toString(child_node.value) or child_node.value))
      end
      table.insert(dataTab, str)
      if child_node.child then
        self:GetCopyText(child_node, dataTab)
      end
    end
  end
  return dataTab
end

function MessagePanelTemplate:ResetButtonPitchOn()
  if self.recordDic then
    for i, v in pairs(self.recordDic) do
      v.img_ClickEffect:SetActive(false)
    end
  end
end

function MessagePanelTemplate:SetButtonPitchOn(index)
  if self.recordDic then
    for i, v in pairs(self.recordDic) do
      v.img_ClickEffect:SetActive(v.data.index == index)
    end
  end
end

return MessagePanelTemplate
