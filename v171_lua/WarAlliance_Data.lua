WarAlliance_Data = class(BaseUI)
WarAlliance_Data.layer = UILayer.Panel
WarAlliance_Data.orderInLayer = 2
WarAlliance_Data.hideType = UIHideType.Destroy
WarAlliance_Data.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Data.escClose = UIEscClose.DontClose

function WarAlliance_Data:InitControls()
  self.panel_left = self:GetControl("panel_left")
  self.bg_frame = self:GetControl("panel_left/bg_frame")
  self.CloseBtn = self:GetControl("panel_left/bg_frame/CloseBtn")
  self.WarAllianceInfo = self:GetControl("panel_left/WarAllianceInfo")
  self.flag_change = self:GetControl("panel_left/WarAllianceInfo/flag/flag_change")
  self.GradArmbandsItem = self:GetControl("panel_left/WarAllianceInfo/flag/GradArmbandsShow/Viewport/Content/GradArmbandsItem")
  self.MyWarAllianceName = self:GetControl("panel_left/WarAllianceInfo/MyWarAllianceName")
  self.name_change = self:GetControl("panel_left/WarAllianceInfo/MyWarAllianceName/name_change")
  self.lab_WarAllianceLevel = self:GetControl("panel_left/WarAllianceInfo/WarAllianceLevel/lab_WarAllianceLevel")
  self.lab_WarAllianceExp = self:GetControl("panel_left/WarAllianceInfo/WarAllianceExp/lab_WarAllianceExp")
  self.btn_expadd = self:GetControl("panel_left/WarAllianceInfo/WarAllianceExp/btn_expadd")
  self.lab_WarAlliancePeopleNum = self:GetControl("panel_left/WarAllianceInfo/WarAlliancePeopleNum/lab_WarAlliancePeopleNum")
  self.lab_Fund = self:GetControl("panel_left/WarAllianceInfo/WarAllianceFund/lab_Fund")
  self.fund_change = self:GetControl("panel_left/WarAllianceInfo/WarAllianceFund/fund_change")
  self.lab_masterName = self:GetControl("panel_left/WarAllianceInfo/WarAllianceMaster/lab_masterName")
  self.btn_Campaign = self:GetControl("panel_left/WarAllianceInfo/WarAllianceMaster/btn_Campaign")
  self.btn_Impeach = self:GetControl("panel_left/WarAllianceInfo/WarAllianceMaster/btn_Impeach")
  self.btn_Replace = self:GetControl("panel_left/WarAllianceInfo/WarAllianceMaster/btn_Replace")
  self.lab_Notice = self:GetControl("panel_left/WarAllianceInfo/Notice/lab_Notice")
  self.notice_change = self:GetControl("panel_left/WarAllianceInfo/Notice/notice_change")
  self.lab_enemyInfo = self:GetControl("panel_left/WarAllianceInfo/Enemy/Scroll View/Viewport/lab_enemyInfo")
  self.lab_Event = self:GetControl("panel_left/WarAllianceInfo/Event/Scroll View/Viewport/lab_Event")
  self.btn_exitunion = self:GetControl("panel_left/WarAllianceInfo/btn_exitunion")
  self.panel_fund = self:GetControl("panel_fund")
  self.btn_donate = self:GetControl("panel_fund/bg/btn_donate")
  self.btn_cancel = self:GetControl("panel_fund/bg/btn_cancel")
  self.fundInput = self:GetControl("panel_fund/Text/fundInput")
  self.result_fund = self:GetControl("panel_fund/lab_fund/result_fund")
  self.result_contribute = self:GetControl("panel_fund/lab_contribute/result_contribute")
  self.panel_report = self:GetControl("panel_report")
  self.btn_panel_report_yes = self:GetControl("panel_report/bg/btn_panel_report_yes")
  self.btn_panel_report_no = self:GetControl("panel_report/bg/btn_panel_report_no")
  self.noticeInput = self:GetControl("panel_report/noticeInput")
  self.panel_name = self:GetControl("panel_name")
  self.btn_panel_name_yes = self:GetControl("panel_name/btn_panel_name_yes")
  self.btn_panel_name_no = self:GetControl("panel_name/btn_panel_name_no")
  self.txt_count = self:GetControl("panel_name/txt_recharge/bg/txt_count")
  self.btn_3DItem = self:GetControl("panel_name/txt_recharge/btn_3DItem")
  self.warAllianceNameInput = self:GetControl("panel_name/warAllianceNameInput")
  self.panel_leader = self:GetControl("panel_leader")
  self.Panel_Campaign = self:GetControl("panel_leader/Panel_Campaign")
  self.btn_donate_campaign = self:GetControl("panel_leader/Panel_Campaign/btn_donate_campaign")
  self.btn_cancel_campaign = self:GetControl("panel_leader/Panel_Campaign/btn_cancel_campaign")
  self.require_vip_text = self:GetControl("panel_leader/Panel_Campaign/require_vip/require_vip_lab/require_vip_text")
  self.btn_3DItem_campaign = self:GetControl("panel_leader/Panel_Campaign/recharge_Campain/btn_3DItem_campaign")
  self.Panel_Impeach = self:GetControl("panel_leader/Panel_Impeach")
  self.btn_donate_impeach = self:GetControl("panel_leader/Panel_Impeach/btn_donate_impeach")
  self.btn_cancel_impeach = self:GetControl("panel_leader/Panel_Impeach/btn_cancel_impeach")
  self.btn_3DItem_impeach = self:GetControl("panel_leader/Panel_Impeach/recharge_Impeach/btn_3DItem_impeach")
  self.Panel_Replace = self:GetControl("panel_leader/Panel_Replace")
  self.btn_donate_replace = self:GetControl("panel_leader/Panel_Replace/btn_donate_replace")
  self.btn_cancel_replace = self:GetControl("panel_leader/Panel_Replace/btn_cancel_replace")
  self.btn_3DItem_replace = self:GetControl("panel_leader/Panel_Replace/recharge_Replace/btn_3DItem_replace")
end

WarAlliance_Data.Master_Btns = {}
WarAlliance_Data.Master_Tip_Views = {}

function WarAlliance_Data:OnPreLoad()
end

function WarAlliance_Data:Init()
  self.MyPosition = {}
end

function WarAlliance_Data:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Data:InitUI()
  self:InitContent()
end

function WarAlliance_Data:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Data:OnHide()
end

function WarAlliance_Data:OnDestroy()
end

function WarAlliance_Data:RegistUIEvents()
  self.btn_exitunion:SetOnClick(self, self.btn_exitunionOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.notice_change:SetOnClick(self, self.notice_changeOnClick)
  self.name_change:SetOnClick(self, self.name_changeOnClick)
  self.flag_change:SetOnClick(self, self.flag_changeOnClick)
  self.fund_change:SetOnClick(self, self.fund_changeOnClick)
  self.btn_panel_report_yes:SetOnClick(self, self.btn_panel_report_yesOnClick)
  self.btn_panel_report_no:SetOnClick(self, self.btn_panel_report_noOnClick)
  self.btn_donate:SetOnClick(self, self.btn_donateOnClick)
  self.btn_cancel:SetOnClick(self, self.btn_cancelOnClick)
  self.btn_Campaign:SetOnClick(self, self.btn_CampaignOnClick)
  self.btn_Impeach:SetOnClick(self, self.btn_ImpeachOnClick)
  self.btn_Replace:SetOnClick(self, self.btn_ReplaceOnClick)
  self.btn_donate_campaign:SetOnClick(self, self.btn_donate_campaignOnClick)
  self.btn_donate_impeach:SetOnClick(self, self.btn_donate_impeachOnClick)
  self.btn_donate_replace:SetOnClick(self, self.btn_donate_replaceOnClick)
  self.btn_cancel_campaign:SetOnClick(self, self.closeMasterTipView)
  self.btn_cancel_impeach:SetOnClick(self, self.closeMasterTipView)
  self.btn_cancel_replace:SetOnClick(self, self.closeMasterTipView)
  self.btn_panel_name_yes:SetOnClick(self, self.btn_panel_name_yesOnClick)
  self.btn_panel_name_no:SetOnClick(self, self.btn_panel_name_noOnClick)
  self.fundInput:SetOnValueChanged(self, self.fundInputOnChanged)
  self.warAllianceNameInput:SetOnValueChanged(self, self.warAllianceNameInputValueChanged)
  self.warAllianceNameInput:SetOnEndEdit(self, self.warAllianceNameInputEndEdit)
end

function WarAlliance_Data:warAllianceNameInputValueChanged(control)
  self.limit = self.warAllianceNameInput.transform:GetComponent("InputField")
  if self.limit.characterLimit ~= 9 then
    self.limit.characterLimit = 9
  end
end

function WarAlliance_Data:warAllianceNameInputEndEdit(control)
  local inputText = self.warAllianceNameInput:GetInputText()
  local length = string.GetKoreanStrCount(inputText)
  if 7 < length then
    self.limit.text = string.KoreanStrSub(inputText, 1, 6)
  end
  self.limit = 7
end

function WarAlliance_Data:btn_exitunionOnClick()
  if QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpen() == true then
    FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetCanNotOperateStr())
    return
  end
  UIManager.Show(UIID.PromptTipUI, {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = string.GetColorText("X\195\161c nh\225\186\173n tho\195\161t guild?", "#DCE1E5"),
    okText = "X\195\161c nh\225\186\173n",
    ok = function()
      NetManager.Send(UnionMessage.ReqQuitUnion)
    end
  })
end

function WarAlliance_Data:CloseBtnOnClick(control)
  if UIManager.IsVisible(UIID.WarAlliance_ChangeBadge) then
    UIManager.Hide(UIID.WarAlliance_menuUI)
    UIManager.Hide(UIID.WarAlliance_ChangeBadge)
  end
  UIManager.Hide(UIID.WarAlliance_Member)
  UIManager.Hide(UIID.WarAlliance_Data)
end

function WarAlliance_Data:notice_changeOnClick()
  self.panel_report:SetActive(true)
end

function WarAlliance_Data:flag_changeOnClick()
  if not UIManager.IsVisible(UIID.WarAlliance_ChangeBadge) then
    UIManager.Show(UIID.WarAlliance_ChangeBadge)
  end
end

function WarAlliance_Data:name_changeOnClick()
  if not self.panel_name:GetActive() then
    self.warAllianceNameInput:SetInputText()
    self:RefreshChangeNamePanel()
    self.panel_name:SetActive(true)
  end
end

function WarAlliance_Data:fund_changeOnClick()
  self.fundInput:SetInputText()
  self.panel_fund:SetActive(true)
end

function WarAlliance_Data:btn_panel_report_yesOnClick()
  local NoticeText = self.noticeInput:GetInputText()
  NetManager.Send(UnionMessage.ReqUnionInfoChange, {type = 3, desc = NoticeText})
  self.panel_report:SetActive(false)
end

function WarAlliance_Data:btn_panel_report_noOnClick()
  self.panel_report:SetActive(false)
end

function WarAlliance_Data:btn_donateOnClick()
  local num = self.fundInput:GetInputText()
  if num == "" then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "S\225\187\145 l\198\176\225\187\163ng kh\195\180ng \196\145\198\176\225\187\163c \196\145\225\187\131 tr\225\187\145ng"
    })
    return
  end
  if tonumber(num) <= 0 then
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = "S\225\187\145 l\198\176\225\187\163ng kh\195\180ng \196\145\198\176\225\187\163c b\225\186\177ng 0"
    })
    return
  end
  NetManager.Send(UnionMessage.ReqUnionDonate, {
    type = tonumber(num)
  })
  self.panel_fund:SetActive(false)
end

function WarAlliance_Data:btn_cancelOnClick()
  self.panel_fund:SetActive(false)
end

function WarAlliance_Data:btn_CampaignOnClick()
  local info = WarAllianceData.CampaignInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Campaign
    })
    return
  end
  if not WarAllianceData.IsCampaigning() then
    self:ShowMasterTipView(WarAllianceMasterEventType.Campaign)
  else
    EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.CAMPAIGN)
  end
end

function WarAlliance_Data:btn_ImpeachOnClick()
  local info = WarAllianceData.ImpeachInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Impeach
    })
    return
  end
  if not WarAllianceData.IsImpeaching() then
    self:ShowMasterTipView(WarAllianceMasterEventType.Impeach)
  else
    EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.IMPEACH)
  end
end

function WarAlliance_Data:btn_ReplaceOnClick()
  local info = WarAllianceData.ReplaceInfo
  if info == nil then
    NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
      type = WarAllianceMasterEventType.Replace
    })
    return
  end
  if not WarAllianceData.IsReplaceing() then
    self:ShowMasterTipView(WarAllianceMasterEventType.Replace)
  else
    EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.REPLACE)
  end
end

function WarAlliance_Data:btn_donate_campaignOnClick()
  self.isCampaignClick = true
  NetManager.Send(UnionMessage.ReqInitiateSelectUnionLeader, {
    rid = ViewData.meData.id
  })
end

function WarAlliance_Data:btn_donate_impeachOnClick()
  self.isImpeachClick = true
  NetManager.Send(UnionMessage.ReqInitiateImpeach, {
    rid = ViewData.meData.id
  })
end

function WarAlliance_Data:btn_donate_replaceOnClick()
  self.isReplaceClick = true
  NetManager.Send(UnionMessage.ReqInitiateReplaceUnionLeader, {
    rid = ViewData.meData.id
  })
end

function WarAlliance_Data:closeMasterTipView()
  self:ShowMasterTipView(nil)
end

function WarAlliance_Data:fundInputOnChanged(_, value)
  local ratio = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10030001), "#")
  if value == "" or value == nil then
    value = 0
  end
  self.result_fund:SetText(math.modf(value * tonumber(ratio[2])))
  self.result_contribute:SetText(math.modf(value * tonumber(ratio[4])))
end

function WarAlliance_Data:btn_panel_name_yesOnClick(control)
  if not self.canChangeName then
    LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, control)
    return
  end
  local name = self.warAllianceNameInput:GetInputText()
  NetManager.Send(UnionMessage.ReqUnionInfoChange, {type = 1, desc = name})
  self.panel_name:SetActive(false)
end

function WarAlliance_Data:btn_panel_name_noOnClick()
  self.panel_name:SetActive(false)
end

function WarAlliance_Data:RegistEvents()
  self:RegistEvent(Event.WarAlliance_MyWarAllianceData, self.InitMyWarAlliance, self)
  self:RegistEvent(Event.WarAlliance_Notice, self.WarAlliance_Notice, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshChangeNamePanel, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshMasterInfo, self)
  self:RegistEvent(Event.WarAlliance_MasterMemberInfo, self.RefreshMasterInfo, self)
  self:RegistEvent(Event.WarAlliance_ImpeachInfo, self.RefreshImpeachInfo, self)
  self:RegistEvent(Event.WarAlliance_ReplaceInfo, self.RefreshReplaceInfo, self)
  self:RegistEvent(Event.WarAlliance_CampaignInfo, self.RefreshCampaignInfo, self)
end

function WarAlliance_Data:InitContent()
  self.GradArmbandsItemTemp = UIContainer(self.GradArmbandsItem)
  WarAlliance_Data.Master_Btns = {
    [WarAllianceMasterEventType.Campaign] = self.btn_Campaign,
    [WarAllianceMasterEventType.Impeach] = self.btn_Impeach,
    [WarAllianceMasterEventType.Replace] = self.btn_Replace
  }
  WarAlliance_Data.Master_Tip_Views = {
    [WarAllianceMasterEventType.Campaign] = self.Panel_Campaign,
    [WarAllianceMasterEventType.Impeach] = self.Panel_Impeach,
    [WarAllianceMasterEventType.Replace] = self.Panel_Replace
  }
end

function WarAlliance_Data:Refresh()
  NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
    type = WarAllianceMasterEventType.Impeach
  })
  NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
    type = WarAllianceMasterEventType.Replace
  })
  NetManager.Send(UnionMessage.ReqGetUnionEventInfo, {
    type = WarAllianceMasterEventType.Campaign
  })
  self.panel_fund:SetActive(false)
  self.panel_report:SetActive(false)
  self.panel_name:SetActive(false)
  self.panel_leader:SetActive(false)
  self:InitMyWarAlliance()
  self:RefreshChangeNamePanel()
  self:RefreshMasterInfo()
  self:ShowMasterTipView(nil)
end

function WarAlliance_Data:InitMyWarAlliance()
  local data = WarAllianceData.MyWarAllianceData
  if table.count(data) > 1 then
    if data ~= nil then
      local level = data.level
      local UnionItem = ClientTable.cfg_union_unionLevelManager:TryGetValue(level)
      local UnionItemNext = ClientTable.cfg_union_unionLevelManager:TryGetValue(tonumber(level + 1))
      local MemberCount = tostring(data.count .. "/" .. UnionItem.unionMax)
      local ExpCount
      if UnionItemNext ~= nil then
        ExpCount = tostring(data.exp .. "/" .. UnionItemNext.unionExp)
      else
        ExpCount = tostring(data.exp)
      end
      local strArr = {}
      if data.event ~= nil then
        for i = table.count(data.event), 1, -1 do
          table.insert(strArr, table.concat({
            tostring(TimeUtility.SwitchTimeStamp(data.event[i].time * 1000)),
            "\194\160",
            data.event[i].msg
          }))
        end
      end
      local strEvent = table.concat(strArr, "\n")
      strEvent = string.replace(strEvent, " ", "\194\160")
      self.lab_Event:SetText(strEvent)
      self.lab_Fund:SetText(data.money)
      self.MyWarAllianceName:SetText(data.name)
      self.lab_masterName:SetText(data.leaderName == "" and "Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i" or data.leaderName)
      self.btn_expadd.itemData = ItemUtility.GenerateItemData(1000060)
      self.btn_expadd.OpenTipsType = EOpenTipsType.FastBuy
      self.btn_expadd:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
      self.lab_WarAllianceLevel:SetText(level)
      self.lab_WarAllianceExp:SetText(ExpCount)
      self.lab_Notice:SetText(data.announce)
      self.lab_WarAlliancePeopleNum:SetText(MemberCount)
      self.MyPosition = data
      if data.enemyUnions and #data.enemyUnions > 0 then
        local text = ""
        for i = 1, #data.enemyUnions do
          text = text .. data.enemyUnions[i] .. "   "
        end
        self.lab_enemyInfo:SetText(text)
      else
        self.lab_enemyInfo:SetText(string.GetColorText("Ch\225\187\151 Tr\225\187\145ng Ch\225\187\157 Ng\198\176\225\187\157i", ItemQuality2ColorDic[0]))
      end
    end
    self:InitArmband()
  end
end

function WarAlliance_Data:InitArmband()
  self.GradArmbandsItemTemp:SetActiveTable()
  local data = WarAllianceData.MyWarAllianceData
  if data ~= nil then
    if data.logo ~= "" then
      local num = WarAllianceData.ArmbandsDesignGridNum
      for i = 1, num do
        local obj = self.GradArmbandsItemTemp:GetOrCreateItem(i)
        obj:SetActive(true)
        if data.logo[i] == 0 then
          local isActive = true
          obj.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = not isActive
        else
          obj.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = true
          obj:SetColor(data.logo[i])
        end
      end
    end
    local isShow = WarAllianceData.MyWarAllianceData.position <= WarAllianceMemberType.viceLeader
    self.name_change:SetActive(isShow)
    self.flag_change:SetActive(isShow)
    self.notice_change:SetActive(isShow)
  end
end

function WarAlliance_Data:WarAlliance_Notice(id, data)
  if data ~= nil and data.type == 3 then
    self.lab_Notice:SetText(data.desc)
  end
end

function WarAlliance_Data:RefreshChangeNamePanel()
  self.canChangeName = false
  local globalID = 10000006
  local goldTbl = ClientTable.cfg_Global_globalManager:TryGetValue(globalID)
  local effects = string.split(goldTbl.effect, "/")
  local itemID, needCount
  for index, effect in ipairs(effects) do
    local temp = string.split(effect, "#")
    itemID = tonumber(temp[1])
    needCount = tonumber(temp[2])
    local haveCount = BagInfoData.GetItemTotalCountByItemId(itemID)
    if needCount <= haveCount then
      self.canChangeName = true
      break
    end
  end
  local data = WarAllianceData.MyWarAllianceData
  local countText
  if data.changeNameTimes <= 0 then
    countText = string.GetColorText("L\225\186\167n \196\145\225\186\167u mi\225\187\133n ph\195\173", ItemQuality2ColorDic[0])
    self.canChangeName = true
  elseif self.canChangeName then
    countText = string.GetColorText(needCount, ItemQuality2ColorDic[0])
  else
    countText = string.GetColorText(needCount, ItemQuality2ColorDic[7])
  end
  self.txt_count:SetText(countText)
  local itemData = ItemUtility.GenerateItemData(itemID)
  self.btn_3DItem.itemCellData = self.btn_3DItem.itemCellData or ItemCellData()
  self.btn_3DItem.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.btn_3DItem.itemCellData, self, true)
end

function WarAlliance_Data:RefreshMasterInfo()
  local data = WarAllianceData.MyWarAllianceData
  local masterData = WarAllianceData.MasterMemberInfo
  local memberCfg = ClientTable.cfg_union_memberManager:TryGetValue(data.position, "id")
  if WarAllianceData.IsShowCampaign() then
    self:ShowMasterBtn(WarAllianceMasterEventType.Campaign)
  elseif WarAllianceData.IsShowReplace() then
    self:ShowMasterBtn(WarAllianceMasterEventType.Replace)
  elseif WarAllianceData.IsShowImpeach() then
    self:ShowMasterBtn(WarAllianceMasterEventType.Impeach)
  else
    self:ShowMasterBtn(nil)
  end
  local items = {
    self.btn_3DItem_campaign,
    self.btn_3DItem_impeach,
    self.btn_3DItem_replace
  }
  local globalIds = {
    10010102,
    10010202,
    10010304
  }
  for index, id in ipairs(globalIds) do
    local effect = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(id)
    local arr = string.split(effect, "#")
    self:ShowMasterConsumeItem(items[index], tonumber(arr[1]), tonumber(arr[2]))
  end
  local vip = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(10010101)
  if vip then
    local vipLvStr = string.split(vip, "&")
    if 1 < #vipLvStr then
      local vipLvStr2 = string.split(vipLvStr[2], "#")
      if 1 < #vipLvStr2 then
        local vipLv = tonumber(vipLvStr2[2])
        local vipTab = ClientTable.cfg_MemberManager:TryGetValue(vipLv)
        local curLV = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberLevle()
        local strColor = vipLv <= curLV and "#00FF00" or "#FF0000"
        self.require_vip_text:SetText(string.GetColorText(vipTab.name, strColor))
      end
    end
  end
end

function WarAlliance_Data:ShowMasterConsumeItem(item, id, count)
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

function WarAlliance_Data:ShowMasterBtn(type)
  for t, btn in pairs(WarAlliance_Data.Master_Btns) do
    btn:SetActive(t == type)
  end
end

function WarAlliance_Data:ShowMasterTipView(type)
  self.isImpeachClick = false
  self.isReplaceClick = false
  self.isCampaignClick = false
  for t, view in pairs(WarAlliance_Data.Master_Tip_Views) do
    view:SetActive(t == type)
  end
  self.panel_leader:SetActive(type ~= nil)
end

function WarAlliance_Data:RefreshImpeachInfo()
  local info = WarAllianceData.ImpeachInfo
  if self.isImpeachClick then
    if WarAllianceData.IsImpeaching() then
      EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.IMPEACH)
    end
    self.isImpeachClick = false
  end
end

function WarAlliance_Data:RefreshCampaignInfo()
  local info = WarAllianceData.CampaignInfo
  if self.isCampaignClick then
    if WarAllianceData.IsCampaigning() then
      EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.CAMPAIGN)
    end
    self.isCampaignClick = false
  end
end

function WarAlliance_Data:RefreshReplaceInfo()
  local info = WarAllianceData.ReplaceInfo
  if self.isReplaceClick then
    if WarAllianceData.IsReplaceing() then
      EventManager.Dispatch(Event.WarAlliance_SelectMenu, WarAlliance_menuUI.Tag.REPLACE)
    end
    self.isReplaceClick = false
  end
end
