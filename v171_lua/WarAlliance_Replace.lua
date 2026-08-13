WarAlliance_Replace = class(BaseUI)
WarAlliance_Replace.layer = UILayer.Panel
WarAlliance_Replace.orderInLayer = 2
WarAlliance_Replace.hideType = UIHideType.Destroy
WarAlliance_Replace.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Replace.escClose = UIEscClose.DontClose

function WarAlliance_Replace:InitControls()
  self.btn_closeBg = self:GetControl("panel_left/btn_closeBg")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.lab_campaignTime = self:GetControl("panel_left/WarAllianceList/lab_campaignTime")
  self.Button_WarAllianceItem = self:GetControl("panel_left/WarAllianceList/WarAllianceListScr/bg_WarAlliancePanel/Viewport/Content/Button_WarAllianceItem")
  self.lab_noCam = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_noCam")
  self.lab_Cam = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam")
  self.btn_get = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/cond/btn_get")
  self.labItem = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/cond/labItem")
  self.btn_fastregist = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/btn_fastregist")
  self.text_fastregist = self:GetControl("panel_left/WarAllianceList/campaign_ condition/lab_Cam/btn_fastregist/text_fastregist")
  self.panel_leader = self:GetControl("panel_leader")
  self.btn_donate = self:GetControl("panel_leader/btn_donate")
  self.btn_cancel = self:GetControl("panel_leader/btn_cancel")
  self.btn_3DItem = self:GetControl("panel_leader/recharge_Replace/btn_3DItem")
end

function WarAlliance_Replace:OnPreLoad()
end

function WarAlliance_Replace:Init()
end

function WarAlliance_Replace:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Replace:InitUI()
  self:InitContent()
end

function WarAlliance_Replace:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Replace:OnHide()
end

function WarAlliance_Replace:OnDestroy()
end

function WarAlliance_Replace:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.btn_fastregist:SetOnClick(self, self.btn_fastregistOnClick)
  self.btn_donate:SetOnClick(self, self.btn_donateOnClick)
  self.btn_cancel:SetOnClick(self, self.btn_cancelOnClick)
end

function WarAlliance_Replace:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Replace)
end

function WarAlliance_Replace:btn_fastregistOnClick(control)
  self.panel_leader:SetActive(true)
end

function WarAlliance_Replace:btn_donateOnClick(control)
  self.isClick = true
  NetManager.Send(UnionMessage.ReqInitiateReplaceUnionLeader, {
    rid = ViewData.meData.id
  })
end

function WarAlliance_Replace:btn_cancelOnClick(control)
  self.panel_leader:SetActive(false)
  self.isClick = false
end

local function Button_WarAllianceItemOnCreate(ctr)
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.lab_number = UIControl(ctr.transform, "lab_number")
end

local function Button_WarAllianceItemOnRefresh(ctr, _, data, ui)
  ctr.lab_name:SetText(data.name)
  ctr.lab_number:SetText(data.level)
end

function WarAlliance_Replace:RegistEvents()
  self:RegistEvent(Event.WarAlliance_ReplaceInfo, self.RefreshReplaceInfo, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshConsumeItem, self)
end

function WarAlliance_Replace:InitContent()
  self.Button_WarAllianceItemTemp = UIContainer(self.Button_WarAllianceItem, self, Button_WarAllianceItemOnCreate, Button_WarAllianceItemOnRefresh)
end

function WarAlliance_Replace:Refresh()
  WarAllianceData.IsShowReplaceRedPoint = false
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
  self.isClick = false
  self.panel_leader:SetActive(false)
  self:RefreshReplaceInfo()
  self:RefreshConsumeItem()
end

function WarAlliance_Replace:RefreshReplaceInfo()
  if self.isClick then
    self.panel_leader:SetActive(false)
    self.isClick = false
  end
  local info = WarAllianceData.ReplaceInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Replace
    })
    return
  end
  self.Button_WarAllianceItemTemp:SetData(info.info)
  local isShow = WarAllianceData.IsJoinReplace()
  self.lab_noCam:SetActive(not isShow)
  self.lab_Cam:SetActive(isShow)
  local isJoined = WarAllianceData.IsJoinedReplace()
  self.btn_fastregist:SetInteractable(not isJoined)
  local btnText = isJoined and "\196\144\195\163 tham gia" or "Tham gia thay th\225\186\191"
  self.text_fastregist:SetText(btnText)
  self:SetSprite("Atlas_Common", isJoined and "ty_btn_grey" or "ty_btn_new_one_new", self.btn_fastregist)
  self:StartCountDownTimer()
end

function WarAlliance_Replace:RefreshConsumeItem()
  local temp = ""
  temp = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010304)
  temp = string.split(temp, "#")
  self:ShowConsumeItem(self.labItem, tonumber(temp[1]), tonumber(temp[2]))
  self:ShowConsumeItem(self.btn_3DItem, tonumber(temp[1]), tonumber(temp[2]))
  self.btn_get.itemData = ItemUtility.GenerateItemData(tonumber(temp[1]))
  self.btn_get.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_get:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function WarAlliance_Replace:RefreshTimerText(offset)
  if offset == nil then
    local info = WarAllianceData.ReplaceInfo
    if info == nil then
      return
    end
    offset = math.floor((info.time - Time.GetServerTime()) / 1000)
  end
  if offset <= 0 then
    self.lab_campaignTime:SetText("\196\144ang ch\225\187\157 t\225\187\149ng k\225\186\191t")
  else
    local text = TimeUtility.ShowDayTime(offset)
    self.lab_campaignTime:SetText(string.format("K\225\186\191t th\195\186c thay th\225\186\191 sau: %s", text))
  end
end

function WarAlliance_Replace:OnCountDownTimer()
  local info = WarAllianceData.ReplaceInfo
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

function WarAlliance_Replace:StartCountDownTimer()
  self:CloseCountDownTimer()
  self:RefreshTimerText()
  self.countDownTimer = Timer.StartLoopForever(1, self.OnCountDownTimer, self)
end

function WarAlliance_Replace:CloseCountDownTimer()
  if self.countDownTimer ~= nil then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function WarAlliance_Replace:ShowConsumeItem(item, id, count)
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
