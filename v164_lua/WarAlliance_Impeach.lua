WarAlliance_Impeach = class(BaseUI)
WarAlliance_Impeach.layer = UILayer.Panel
WarAlliance_Impeach.orderInLayer = 2
WarAlliance_Impeach.hideType = UIHideType.Destroy
WarAlliance_Impeach.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Impeach.escClose = UIEscClose.DontClose

function WarAlliance_Impeach:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.lab_campaignTime = self:GetControl("panel_left/WarAllianceList/lab_campaignTime")
  self.lab_campaignName = self:GetControl("panel_left/WarAllianceList/lab_campaignName")
  self.btn_agree = self:GetControl("panel_left/WarAllianceList/btn_agree")
  self.lab_agree = self:GetControl("panel_left/WarAllianceList/btn_agree/lab_agree")
  self.agreeItem = self:GetControl("panel_left/WarAllianceList/btn_agree/agreeItem")
  self.btn_opposition = self:GetControl("panel_left/WarAllianceList/btn_opposition")
  self.lab_opposition = self:GetControl("panel_left/WarAllianceList/btn_opposition/lab_opposition")
  self.oppItem = self:GetControl("panel_left/WarAllianceList/btn_opposition/oppItem")
  self.panel_agree = self:GetControl("panel_agree")
  self.btn_donate_agree = self:GetControl("panel_agree/btn_donate_agree")
  self.btn_cancel_agree = self:GetControl("panel_agree/btn_cancel_agree")
  self.btn_3DItem_agree = self:GetControl("panel_agree/recharge_Impeach/btn_3DItem_agree")
  self.panel_opposition = self:GetControl("panel_opposition")
  self.btn_donate_opposition = self:GetControl("panel_opposition/btn_donate_opposition")
  self.btn_cancel_opposition = self:GetControl("panel_opposition/btn_cancel_opposition")
  self.btn_3DItem_opposition = self:GetControl("panel_opposition/recharge_Impeach/btn_3DItem_opposition")
end

WarAlliance_Impeach.Views = {}

function WarAlliance_Impeach:OnPreLoad()
end

function WarAlliance_Impeach:Init()
end

function WarAlliance_Impeach:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Impeach:InitUI()
  self:InitContent()
end

function WarAlliance_Impeach:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Impeach:OnHide()
  self:CloseCountDownTimer()
end

function WarAlliance_Impeach:OnDestroy()
end

function WarAlliance_Impeach:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.btn_agree:SetOnClick(self, self.btn_agreeOnClick)
  self.btn_opposition:SetOnClick(self, self.btn_oppositionOnClick)
  self.btn_donate_agree:SetOnClick(self, self.btn_donate_agreeOnClick)
  self.btn_donate_opposition:SetOnClick(self, self.btn_donate_oppositionOnClick)
  self.btn_cancel_agree:SetOnClick(self, self.closeTipView)
  self.btn_cancel_opposition:SetOnClick(self, self.closeTipView)
end

function WarAlliance_Impeach:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Impeach)
end

function WarAlliance_Impeach:btn_agreeOnClick(control)
  self:ShowView(WarAllianceImpeachVote.Agree)
end

function WarAlliance_Impeach:btn_donate_agreeOnClick(control)
  self.isClick = true
  NetManager.Send(UnionMessage.ReqVoteImpeach, {agree = true})
end

function WarAlliance_Impeach:btn_donate_oppositionOnClick(control)
  self.isClick = true
  NetManager.Send(UnionMessage.ReqVoteImpeach, {agree = false})
end

function WarAlliance_Impeach:btn_oppositionOnClick(control)
  self:ShowView(WarAllianceImpeachVote.Oppose)
end

function WarAlliance_Impeach:closeTipView()
  self:ShowView(nil)
end

function WarAlliance_Impeach:RegistEvents()
  self:RegistEvent(Event.WarAlliance_ImpeachInfo, self.RefreshImpeachInfo, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshConsumeItem, self)
end

function WarAlliance_Impeach:InitContent()
  WarAlliance_Impeach.Views = {
    [WarAllianceImpeachVote.Agree] = self.panel_agree,
    [WarAllianceImpeachVote.Oppose] = self.panel_opposition
  }
end

function WarAlliance_Impeach:Refresh()
  WarAllianceData.IsShowImpeachRedPoint = false
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  self:ShowView(nil)
  self:RefreshConsumeItem()
  self:RefreshImpeachInfo()
end

function WarAlliance_Impeach:RefreshConsumeItem()
  local temp = ""
  temp = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010203)
  temp = string.split(temp, "#")
  self:ShowConsumeItem(self.agreeItem, tonumber(temp[1]), tonumber(temp[2]))
  self:ShowConsumeItem(self.oppItem, tonumber(temp[1]), tonumber(temp[2]))
  self:ShowConsumeItem(self.btn_3DItem_agree, tonumber(temp[1]), tonumber(temp[2]))
  self:ShowConsumeItem(self.btn_3DItem_opposition, tonumber(temp[1]), tonumber(temp[2]))
end

function WarAlliance_Impeach:RefreshImpeachInfo()
  if self.isClick then
    self:ShowView(nil)
    self.isClick = false
  end
  local info = WarAllianceData.ImpeachInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Impeach
    })
    return
  end
  local isVote = info.type ~= WarAllianceImpeachVote.None
  self.lab_campaignName:SetText(string.format("\196\144\225\187\147ng \195\189 t\225\187\145 c\195\161o Tr\198\176\225\187\159ng guild <color=#FF8a00>%s</color>?", info.leaderName))
  self.lab_agree:SetText(info.agree)
  self.lab_opposition:SetText(info.disagree)
  if isVote then
  end
  self.btn_agree.button.enabled = not isVote
  self.btn_opposition.button.enabled = not isVote
  self:StartCountDownTimer()
end

function WarAlliance_Impeach:RefreshTimerText(offset)
  if offset == nil then
    local info = WarAllianceData.ImpeachInfo
    if info == nil then
      return
    end
    offset = math.floor((info.time - Time.GetServerTime()) / 1000)
  end
  if offset <= 0 then
    self.lab_campaignTime:SetText("\196\144ang ch\225\187\157 t\225\187\149ng k\225\186\191t")
  else
    local text = TimeUtility.ShowDayTime(offset)
    self.lab_campaignTime:SetText(string.format("K\225\186\191t th\195\186c t\225\187\145 c\195\161o sau: %s", text))
  end
end

function WarAlliance_Impeach:OnCountDownTimer()
  local info = WarAllianceData.ImpeachInfo
  if info == nil then
    return
  end
  local offset = math.floor((info.time - Time.GetServerTime()) / 1000)
  self:RefreshTimerText(offset)
  if offset <= 0 then
    self:CloseCountDownTimer()
  end
end

function WarAlliance_Impeach:StartCountDownTimer()
  self:CloseCountDownTimer()
  self:RefreshTimerText()
  self.countDownTimer = Timer.StartLoopForever(1, self.OnCountDownTimer, self)
end

function WarAlliance_Impeach:CloseCountDownTimer()
  if self.countDownTimer ~= nil then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function WarAlliance_Impeach:ShowConsumeItem(item, id, count)
  local itemData = ItemUtility.GenerateItemData(id)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
  local cellData = ItemCellData()
  cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(item, cellData, self, true)
  local strColor = count <= bagCount and "#00FF00" or "#FF0000"
  local countT = Mathf.NumberShowFormat(count, 1)
  item.countCtr:SetText(string.GetColorText(countT, strColor))
  item.countCtr:SetActive(true)
end

function WarAlliance_Impeach:ShowView(type)
  self.isClick = false
  for t, view in pairs(WarAlliance_Impeach.Views) do
    view:SetActive(t == type)
  end
end
