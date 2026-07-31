local WarReportPanelTemplate = {}

function WarReportPanelTemplate:Init(data)
  self.goCallBack = data.goCallBack
  self.curTogIndex = data.curTogIndex
  self.relevancyBtn = data.relevancyBtn
  self:InitControls()
  self:BindUIEvent()
end

function WarReportPanelTemplate:InitControls()
  self.btn_Empty = self:GetControl("btn_Empty")
  self.btn_Refresh = self:GetControl("btn_Refresh")
  self.contentGold = self:GetControl("ScrollView/Viewport/contentGold")
  self.messageText = self:GetControl("MessageView/Viewport/Content/messageText")
end

function WarReportPanelTemplate:BindUIEvent()
  self.relevancyBtn:SetOnClick(self, self.ClickGoCallBack)
  self.btn_Empty:SetOnClick(self, self.btn_EmptyOnClick)
  self.btn_Refresh:SetOnClick(self, self.btn_RefreshOnClick)
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

function WarReportPanelTemplate:ClickGoCallBack()
  if self.goCallBack then
    self.goCallBack(self.curTogIndex)
  end
end

function WarReportPanelTemplate:btn_EmptyOnClick()
  gameMgr:GetGMDataMgr():ClearMessageDataByType()
end

function WarReportPanelTemplate:btn_RefreshOnClick()
  if gameMgr:GetGMDataMgr():GetReceiveState() == false then
    self.messageText:SetText("H\195\163y m\225\187\159 c\195\180ng t\225\186\175c ch\225\186\165p nh\225\186\173n tin nh\225\186\175n v\195\160 \196\145\225\186\163m b\225\186\163o \196\145\195\163 m\225\187\159 ch\225\187\169c n\196\131ng th\195\180ng tin Chi\225\186\191n B\195\161o")
    return
  end
  gameMgr:GetGMDataMgr():SearchMessageData(tonumber(300002))
end

function WarReportPanelTemplate:RefreshLeftListView(data)
  self:ResetRightListViewShow()
  self:RefreshLeftMessageView(data)
end

function WarReportPanelTemplate:ResetRightListViewShow()
  self.messageText:SetText("")
end

function WarReportPanelTemplate:RefreshLeftMessageView(data)
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

function WarReportPanelTemplate:RefreshRightListView(data)
  self:SetButtonPitchOn(data.index)
  self:RefreshRightBottomListView(data)
end

function WarReportPanelTemplate:RefreshRightBottomListView(data)
  if data == nil and data.tableContent == nil then
    return
  end
  self.messageText:SetText(string.GetColorText(table.toString(data.tableContent), ItemQuality2ColorDic[25]))
end

function WarReportPanelTemplate:ResetButtonPitchOn()
  if self.recordDic then
    for i, v in pairs(self.recordDic) do
      v.img_ClickEffect:SetActive(false)
    end
  end
end

function WarReportPanelTemplate:SetButtonPitchOn(index)
  if self.recordDic then
    for i, v in pairs(self.recordDic) do
      v.img_ClickEffect:SetActive(v.data.index == index)
    end
  end
end

function WarReportPanelTemplate:Refresh(data, ui)
end

return WarReportPanelTemplate
