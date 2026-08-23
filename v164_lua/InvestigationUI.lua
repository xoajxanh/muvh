InvestigationUI = class(BaseUI)
InvestigationUI.layer = UILayer.Panel
InvestigationUI.orderInLayer = 0
InvestigationUI.hideType = UIHideType.WaitDestroy
InvestigationUI.hideFunc = UIHideFunc.MoveOutOfScreen
InvestigationUI.escClose = UIEscClose.DontClose

function InvestigationUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Panel_Chat = self:GetControl("Panel_Chat")
  self.ScrollView = self:GetControl("Panel_Chat/ScrollView")
  self.Content = self:GetControl("Panel_Chat/ScrollView/Viewport/Content")
  self.chatFather = self:GetControl("Panel_Chat/ScrollView/Viewport/Content/chatFather")
  self.Text_Message = self:GetControl("Panel_Chat/ScrollView/Viewport/Content/chatFather/Text_Message")
  self.headPortrait = self:GetControl("Panel_Chat/ScrollView/Viewport/Content/chatFather/go_selfPlayerChar/img_headFrame/headPortrait")
  self.InputField_ChatInput = self:GetControl("Panel_Chat/InputField_ChatInput")
  self.Placeholder = self:GetControl("Panel_Chat/InputField_ChatInput/Placeholder")
  self.Text = self:GetControl("Panel_Chat/InputField_ChatInput/Text")
  self.Button_send = self:GetControl("Panel_Chat/Button_send")
  self.img_GM_bg = self:GetControl("Panel_Chat/img_GM_bg")
  self.btn_3DItem1 = self:GetControl("Panel_Chat/img_GM_bg/content/btn_3DItem1")
  self.btn_anwser = self:GetControl("Panel_Chat/img_GM_bg/btn_anwser")
  self.btn_close = self:GetControl("btn_close")
end

function InvestigationUI:OnPreLoad()
end

function InvestigationUI:Init()
  self.awardList = {}
  local rewardid = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2150003)
  local rewarddata = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(rewardid))
  for i = 1, #rewarddata do
    table.insert(self.awardList, rewarddata[i])
  end
end

function InvestigationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnRewardCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function OnRewardRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

local function OnChatCreat(ctr)
  ctr.Text_Message = UIControl(ctr.transform, "Text_Message")
  ctr.go_selfPlayerChar = UIControl(ctr.transform, "go_selfPlayerChar")
  ctr.headPortrait = UIControl(ctr.transform, "go_selfPlayerChar/img_headFrame/headPortrait")
  ctr.lab_name = UIControl(ctr.transform, "go_selfPlayerChar/lab_name")
  ctr.lab_playChar = UIControl(ctr.transform, "go_selfPlayerChar/img_charBubble/lab_playChar")
  ctr.go_GMChar = UIControl(ctr.transform, "go_GMChar")
  ctr.lab_SystemChar = UIControl(ctr.transform, "go_GMChar/img_SystemCharBubble/lab_SystemChar")
end

local function OnChatRefresh(ctr, _, data, ui)
  ctr.go_selfPlayerChar:SetActive(data.mode == 1)
  ctr.go_GMChar:SetActive(data.mode == 2)
  if data.mode == 1 then
    ctr.lab_name:SetText(RoleManager.me.name)
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(RoleManager.me.career, "id").headPortrait
    ui:SetSprite("Atlas_headPortrait", spriteName, ctr.headPortrait)
    ctr.lab_playChar:SetText(data.text)
  else
    ctr.lab_SystemChar:SetText(data.text)
  end
  ctr.Text_Message:SetText(data.time)
  if _ == #ChatData.QuestionChatList then
    ui:RefreshPosition()
  end
end

function InvestigationUI:InitUI()
  self.RewardContainer = UIContainer(self.btn_3DItem1, self, OnRewardCreat, OnRewardRefresh)
  self.ChatContainer = UIContainer(self.chatFather, self, OnChatCreat, OnChatRefresh)
  self.RewardContainer:SetData(self.awardList)
end

function InvestigationUI:OnShow()
  self:RegistEvents()
end

function InvestigationUI:OnHide()
  self.InputField_ChatInput:SetInputText("")
end

function InvestigationUI:OnDestroy()
end

function InvestigationUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.headPortrait:SetOnClick(self, self.headPortraitOnClick)
  self.Button_send:SetOnClick(self, self.Button_sendOnClick)
  self.btn_3DItem1:SetOnClick(self, self.btn_3DItem1OnClick)
  self.btn_anwser:SetOnClick(self, self.btn_anwserOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function InvestigationUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.InvestigationUI)
end

function InvestigationUI:headPortraitOnClick(control)
end

function InvestigationUI:Button_sendOnClick(control)
  if string.isNullOrEmpty(self.Text:GetText()) then
    return
  end
  ChatData.SetMeChatData(self.Text:GetText())
  NetManager.Send(ChatMessage.ReqSendFeedback, {
    msg = self.Text:GetText()
  })
  self.InputField_ChatInput:SetInputText("")
end

function InvestigationUI:btn_3DItem1OnClick(control)
end

function InvestigationUI:btn_anwserOnClick(control)
  local pid = RoleDeclareManager.GetPid()
  local cfg_survey = ClientTable.cfg_surveyManager:TryGetValue(pid)
  if cfg_survey and cfg_survey.condition then
    local conditionResult = ConditionManager.Check4D(cfg_survey.condition)
    if conditionResult and cfg_survey.link ~= "" then
      Application.OpenURL(cfg_survey.link)
    end
  end
end

function InvestigationUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.InvestigationUI)
end

function InvestigationUI:img_titleOnClick(control)
end

function InvestigationUI:RegistEvents()
  self:RegistEvent(Event.Chat_GMRefresh, self.Refresh, self)
  NetManager.Send(ChatMessage.ReqFeedbacks)
end

function InvestigationUI:Refresh()
  self.img_GM_bg:SetActive(not ChatData.GetQuestionAward)
  self.ChatContainer:SetData(ChatData.QuestionChatList)
  local size = ChatData.GetQuestionAward and 0 or 60
  self.Content:SetVerticalLayoutGroupPaddingTop(size)
end

function InvestigationUI:RefreshPosition()
  local size = ChatData.GetQuestionAward and 0 or 60
  local num = ChatData.GetQuestionAward and 6 or 5
  if num < #ChatData.QuestionChatList then
    self.Content.transform.anchoredPosition3D = Vector3.New(0, #ChatData.QuestionChatList * 60 + size, 0)
  end
end
