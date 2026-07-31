WarAlliance_Campaign = class(BaseUI)
WarAlliance_Campaign.layer = UILayer.Panel
WarAlliance_Campaign.orderInLayer = 2
WarAlliance_Campaign.hideType = UIHideType.Destroy
WarAlliance_Campaign.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Campaign.escClose = UIEscClose.DontClose

function WarAlliance_Campaign:InitControls()
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.lab_campaignTime = self:GetControl("panel_left/WarAllianceList/lab_campaignTime")
  self.Button_WarAllianceItem = self:GetControl("panel_left/WarAllianceList/WarAllianceListScr/bg_WarAlliancePanel/Viewport/Content/Button_WarAllianceItem")
  self.lab_noCam = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_noCam")
  self.lab_Cam = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam")
  self.btn_get = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/cond/btn_get")
  self.lab_Value = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/cond/lab_Value")
  self.labItem = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/cond/labItem")
  self.btn_fastregist = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/btn_fastregist")
  self.text_fastregist = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/btn_fastregist/text_fastregist")
  self.panel_leader = self:GetControl("panel_leader")
  self.btn_donate = self:GetControl("panel_leader/btn_donate")
  self.btn_cancel_leader = self:GetControl("panel_leader/btn_cancel_leader")
  self.btn_3DItem = self:GetControl("panel_leader/recharge_Campain/btn_3DItem")
  self.panel_ticket = self:GetControl("panel_ticket")
  self.lab_ticName = self:GetControl("panel_ticket/lab_ticName")
  self.lab_count = self:GetControl("panel_ticket/ticket/img_ticBg/lab_count")
  self.btn_jia = self:GetControl("panel_ticket/ticket/btn_jia")
  self.btn_jian = self:GetControl("panel_ticket/ticket/btn_jian")
  self.needItem = self:GetControl("panel_ticket/needTicket/needItem")
  self.myItem = self:GetControl("panel_ticket/myTicket/myItem")
  self.btn_no = self:GetControl("panel_ticket/btn_choose/btn_no")
  self.btn_yes = self:GetControl("panel_ticket/btn_choose/btn_yes")
  self.btn_cancel_ticket = self:GetControl("panel_ticket/btn_cancel_ticket")
end

WarAlliance_Campaign.View_Tag = {Vote = 0, RunFor = 1}
WarAlliance_Campaign.Views = {}

function WarAlliance_Campaign:OnPreLoad()
end

function WarAlliance_Campaign:Init()
end

function WarAlliance_Campaign:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Campaign:InitUI()
  self:InitContent()
end

function WarAlliance_Campaign:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Campaign:OnHide()
end

function WarAlliance_Campaign:OnDestroy()
end

function WarAlliance_Campaign:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.btn_jia:SetOnClick(self, self.btn_jiaOnClick)
  self.btn_jian:SetOnClick(self, self.btn_jianOnClick)
  self.btn_yes:SetOnClick(self, self.btn_yesOnClick)
  self.btn_no:SetOnClick(self, self.btn_noOnClick)
  self.btn_cancel_ticket:SetOnClick(self, self.btn_cancel_ticketOnClick)
  self.btn_fastregist:SetOnClick(self, self.btn_fastregistOnClick)
  self.btn_cancel_leader:SetOnClick(self, self.btn_cancel_leaderOnClick)
  self.btn_donate:SetOnClick(self, self.btn_donateOnClick)
end

function WarAlliance_Campaign:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Campaign)
end

function WarAlliance_Campaign:btn_jiaOnClick(control)
  self.voteCnt = self.voteCnt + 1
  self:RefreshVoteView()
end

function WarAlliance_Campaign:btn_jianOnClick(control)
  self.voteCnt = self.voteCnt - 1
  self:RefreshVoteView()
end

function WarAlliance_Campaign:btn_yesOnClick(control)
  if self.voteCnt == nil or self.voteInfo == nil then
    return
  end
  self.isVoteClick = true
  NetManager.Send(UnionMessage.ReqVoteSelectUnionLeader, {
    rid = ViewData.meData.id,
    selectRid = self.voteInfo.info.roleId,
    count = self.voteCnt
  })
end

function WarAlliance_Campaign:btn_noOnClick(control)
  self.voteCnt = nil
  self:RefreshVoteView()
end

function WarAlliance_Campaign:btn_cancel_ticketOnClick(control)
  self:ShowView(nil)
end

function WarAlliance_Campaign:btn_fastregistOnClick(control)
  self:ShowView(WarAlliance_Campaign.View_Tag.RunFor)
end

function WarAlliance_Campaign:btn_cancel_leaderOnClick(control)
  self:ShowView(nil)
end

function WarAlliance_Campaign:btn_donateOnClick(control)
  self.isRunForClick = true
  NetManager.Send(UnionMessage.ReqInitiateSelectUnionLeader, {
    rid = ViewData.meData.id
  })
end

function WarAlliance_Campaign:Button_WarAllianceItemOnClick(control)
  local data = control.data
  self.voteInfo = data
  self:RefreshVoteView()
  self:ShowView(WarAlliance_Campaign.View_Tag.Vote)
end

local function Button_WarAllianceItemOnCreate(ctr)
  ctr.itemCtr = UIControl(ctr.transform)
  ctr.img_clickeffect = UIControl(ctr.transform, "img_clickeffect")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.lab_level = UIControl(ctr.transform, "lab_level")
  ctr.lab_number = UIControl(ctr.transform, "lab_number")
end

local function Button_WarAllianceItemOnRefresh(ctr, _, data, this)
  ctr.lab_name:SetText(data.info.name)
  ctr.lab_level:SetText(data.info.level)
  ctr.lab_number:SetText(data.vote)
  ctr.itemCtr.data = data
  ctr.itemCtr:SetOnClick(this, this.Button_WarAllianceItemOnClick)
end

function WarAlliance_Campaign:RegistEvents()
  self:RegistEvent(Event.WarAlliance_CampaignInfo, self.RefreshCampaignInfo, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshConsumeItem, self)
end

function WarAlliance_Campaign:InitContent()
  WarAlliance_Campaign.Views = {
    [WarAlliance_Campaign.View_Tag.Vote] = self.panel_ticket,
    [WarAlliance_Campaign.View_Tag.RunFor] = self.panel_leader
  }
  self.Button_WarAllianceItemTemp = UIContainer(self.Button_WarAllianceItem, self, Button_WarAllianceItemOnCreate, Button_WarAllianceItemOnRefresh)
end

function WarAlliance_Campaign:Refresh()
  WarAllianceData.IsShowCampaignRedPoint = false
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  self.voteCnt = nil
  self.voteInfo = nil
  self:ShowView(nil)
  self:RefreshCampaignInfo()
  self:RefreshConsumeItem()
end

function WarAlliance_Campaign:RefreshCampaignInfo()
  if self.isRunForClick then
    self:ShowView(nil)
    self.isRunForClick = false
  end
  if self.isVoteClick then
    self:ShowView(nil)
    self.isVoteClick = false
  end
  local info = WarAllianceData.CampaignInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Campaign
    })
    return
  end
  local datas = {}
  for id, vote_num in pairs(info.roleInfo) do
    for index, info in ipairs(info.info) do
      if id == info.roleId then
        table.insert(datas, {info = info, vote = vote_num})
        break
      end
    end
  end
  self.Button_WarAllianceItemTemp:SetData(datas)
  local isShow = WarAllianceData.IsJoinCampaign()
  self.lab_noCam:SetActive(not isShow)
  self.lab_Cam:SetActive(isShow)
  local isJoined = WarAllianceData.IsJoinedCampaign()
  self.btn_fastregist:SetInteractable(not isJoined)
  local btnText = isJoined and "\196\144\195\163 tham gia" or "Tham d\225\187\177 Tranh C\225\187\173"
  self.text_fastregist:SetText(btnText)
  self:SetSprite("Atlas_Common", isJoined and "ty_btn_grey" or "ty_btn_new_one_new", self.btn_fastregist)
  self:StartCountDownTimer()
end

function WarAlliance_Campaign:RefreshConsumeItem()
  local temp = ""
  temp = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010102)
  temp = string.split(temp, "#")
  self:ShowConsumeItem(self.labItem, tonumber(temp[1]), tonumber(temp[2]))
  self:ShowConsumeItem(self.btn_3DItem, tonumber(temp[1]), tonumber(temp[2]))
  self.btn_get.itemData = ItemUtility.GenerateItemData(tonumber(temp[1]))
  self.btn_get.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  self:RefreshVoteView()
end

local MIN_VOTE = 1
local MAX_VOTE = 99

function WarAlliance_Campaign:RefreshVoteView()
  if self.voteInfo then
    self.lab_ticName:SetText(string.format("B\225\187\143 phi\225\186\191u cho <color=#e6e600>%s</color>", self.voteInfo.info.name))
  end
  local temp = ""
  temp = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010103)
  temp = string.split(temp, "#")
  local itemID = tonumber(temp[1])
  local count = tonumber(temp[2])
  local bagCount = BagInfoData.GetItemTotalCountByItemId(itemID)
  self.voteCnt = self.voteCnt or MIN_VOTE
  if self.voteCnt < MIN_VOTE then
    self.voteCnt = MAX_VOTE - self.voteCnt
  end
  if self.voteCnt > MAX_VOTE then
    self.voteCnt = self.voteCnt - MAX_VOTE
  end
  self.lab_count:SetText(self.voteCnt)
  self:ShowConsumeItem(self.needItem, itemID, self.voteCnt * count)
  self:ShowUseItem(self.myItem, itemID)
end

function WarAlliance_Campaign:RefreshTimerText(offset)
  if offset == nil then
    local info = WarAllianceData.CampaignInfo
    if info == nil then
      return
    end
    offset = math.floor((info.time - Time.GetServerTime()) / 1000)
  end
  if offset <= 0 then
    self.lab_campaignTime:SetText("\196\144ang ch\225\187\157 t\225\187\149ng k\225\186\191t")
  else
    local text = TimeUtility.ShowDayTime(offset)
    self.lab_campaignTime:SetText(string.format("K\225\186\191t th\195\186c tranh c\225\187\173 sau: %s", text))
  end
end

function WarAlliance_Campaign:OnCountDownTimer()
  local info = WarAllianceData.CampaignInfo
  if info == nil then
    return
  end
  local offset = math.floor((info.time - Time.GetServerTime()) / 1000)
  self:RefreshTimerText(offset)
  if offset <= 0 then
    self:CloseCountDownTimer()
    EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.INFO)
  end
end

function WarAlliance_Campaign:StartCountDownTimer()
  self:CloseCountDownTimer()
  self:RefreshTimerText()
  self.countDownTimer = Timer.StartLoopForever(1, self.OnCountDownTimer, self)
end

function WarAlliance_Campaign:CloseCountDownTimer()
  if self.countDownTimer ~= nil then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function WarAlliance_Campaign:ShowConsumeItem(item, id, count)
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

function WarAlliance_Campaign:ShowUseItem(item, id)
  local itemData = ItemUtility.GenerateItemData(id)
  local bagCount = BagInfoData.GetItemTotalCountByItemId(id)
  local cellData = ItemCellData()
  cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(item, cellData, self, true)
  item.countCtr:SetText(bagCount)
  item.countCtr:SetActive(true)
end

function WarAlliance_Campaign:ShowView(type)
  if not type then
    self.voteCnt = nil
    self.isVoteClick = false
    self.isRunForClick = false
  end
  for t, view in pairs(WarAlliance_Campaign.Views) do
    view:SetActive(t == type)
  end
end
