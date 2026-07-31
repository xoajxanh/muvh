Main_DownTipsUI = class(BaseUI)
Main_DownTipsUI.layer = UILayer.Panel
Main_DownTipsUI.orderInLayer = 1
Main_DownTipsUI.hideType = UIHideType.WaitDestroy
Main_DownTipsUI.hideFunc = UIHideFunc.MoveOutOfScreen
Main_DownTipsUI.escClose = UIEscClose.DontClose

function Main_DownTipsUI:InitControls()
  self.btn_redFortEnter = self:GetControl("panel_showTips/btn_redFortEnter")
  self.btn_onHookEnter = self:GetControl("panel_showTips/btn_onHookEnter")
  self.btn_guardEnter = self:GetControl("panel_showTips/btn_guardEnter")
  self.btn_quicklyTeamMinimize = self:GetControl("panel_showTips/btn_quicklyTeamMinimize")
  self.lab_MatchingCountown = self:GetControl("panel_showTips/btn_quicklyTeamMinimize/lab_MatchingCountown")
  self.btn_auctionEnter = self:GetControl("panel_showTips/btn_auctionEnter")
  self.btn_auctionZhanEnter = self:GetControl("panel_showTips/btn_auctionZhanEnter")
  self.btn_auctionZhanEnterRedPoint = self:GetControl("panel_showTips/btn_auctionZhanEnter/img_redPoint")
  self.btn_auctionLianEnter = self:GetControl("panel_showTips/btn_auctionLianEnter")
  self.btn_auctionLianEnterRedPoint = self:GetControl("panel_showTips/btn_auctionLianEnter/img_redPoint")
  self.btn_wolfEnter = self:GetControl("panel_showTips/btn_wolfEnter")
  self.wolfEnterCount = self:GetControl("panel_showTips/btn_wolfEnter/wolfEnterCount")
  self.btn_MonthCardMaturit = self:GetControl("panel_showTips/btn_MonthCardMaturit")
  self.btn_memberCardMaturit = self:GetControl("panel_showTips/btn_memberCardMaturit")
  self.btn_EfficientExpired = self:GetControl("panel_showTips/btn_EfficientExpired")
  self.btn_applyTeam = self:GetControl("panel_showTips/btn_applyTeam")
  self.btn_InviteTeam = self:GetControl("panel_showTips/btn_InviteTeam")
  self.btn_goWarAlliance = self:GetControl("panel_showTips/btn_goWarAlliance")
  self.btn_goCompose = self:GetControl("panel_showTips/btn_goCompose")
  self.btn_goRedemption = self:GetControl("panel_showTips/btn_goRedemption")
  self.btn_bubble_3V3Match = self:GetControl("panel_showTips/btn_bubble_3V3Match")
  self.btn_bubble_3V3Team = self:GetControl("panel_showTips/btn_bubble_3V3Team")
  self.btn_duoqiEnter = self:GetControl("panel_showTips/btn_duoqiEnter")
  self.btn_duoqiZhengBa = self:GetControl("panel_showTips/btn_duoqiZhengBa")
  self.btn_MonsterDimension = self:GetControl("panel_showTips/btn_monstertDimension")
  self.btn_sifang = self:GetControl("panel_showTips/btn_sifang")
end

function Main_DownTipsUI:OnPreLoad()
end

function Main_DownTipsUI:Init()
  self.eventContainer = EventContainer(EventManager)
end

function Main_DownTipsUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Main_DownTipsUI:InitUI()
  self.MonthInitTime = 0
  self.MemberInitTime = 0
  self.EfficientTime = 0
  self.OpenDoTween = {}
  self.combineIdList = {}
  self.btn_auctionZhanEnter:SetActive(true)
  self.btn_auctionLianEnter:SetActive(true)
  self:RefreshAuctionEnterBtn()
end

function Main_DownTipsUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Main_DownTipsUI:HideRedFortPrepare()
  if self.countDownPrepareTimer then
    Timer.Stop(self.countDownPrepareTimer)
    self.countDownPrepareTimer = nil
  end
  self.btn_redFortEnter:SetActive(false)
end

function Main_DownTipsUI:OnHide()
  self:HideRedFortPrepare()
  self.btn_onHookEnter:SetActive(false)
  self:AuctionTipsUI(nil)
  AuctionData.isFirstOpenAuctionUnionTips = true
  AuctionData.isFirstOpenAuctionUnionCampTips = true
  self:ColseMonthTimer(ExpiredTypeEnum.PrivilegeCard, self.btn_MonthCardMaturit)
  self:ColseMonthTimer(ExpiredTypeEnum.MemberCard, self.btn_memberCardMaturit)
  self:ColseMonthTimer(ExpiredTypeEnum.Efficient, self.btn_EfficientExpired)
  self.latest3v3InviteData = nil
end

function Main_DownTipsUI:OnDestroy()
end

function Main_DownTipsUI:RegistUIEvents()
  self.eventContainer:Regist(Event.WarAlliance_IsHavaUnion, self.RefreshAuctionEnterBtn)
  self.eventContainer:Regist(Event.Camp_ChangeUnionCamp, self.RefreshAuctionEnterBtn)
  self.btn_auctionEnter:SetOnClick(self, self.AuctionRecommendOnClick)
  self.btn_auctionZhanEnterRedPoint:SetOnClick(self, self.OnAuctionZhanBtnClick)
  self.btn_auctionLianEnterRedPoint:SetOnClick(self, self.OnAuctionLianBtnClick)
  self.btn_wolfEnter:SetOnClick(self, self.btn_wolfEnterOnClick)
  self.btn_quicklyTeamMinimize:SetOnClick(self, self.btn_quiTeamMiniOnClick)
  self.btn_guardEnter:SetOnClick(self, self.btn_guardEnterOnClick)
  self.btn_MonthCardMaturit:SetOnClick(self, self.btn_MonthCardMaturitOnClick)
  self.btn_memberCardMaturit:SetOnClick(self, self.btn_memberCardMaturitOnClick)
  self.btn_EfficientExpired:SetOnClick(self, self.btn_EfficientExpiredOnClick)
  self.btn_applyTeam:SetOnClick(self, self.btn_applyTeamOnClick)
  self.btn_InviteTeam:SetOnClick(self, self.btn_InviteTeamOnClick)
  self.btn_goWarAlliance:SetOnClick(self, self.btn_goWarAllianceOnClick)
  self.btn_goRedemption:SetOnClick(self, self.btn_goRedemptionOnClick)
  self.btn_goCompose:SetOnClick(self, self.CombineBtnClick)
  self.btn_bubble_3V3Match:SetOnClick(self, self.btn_bubble_3V3MatchOnClick)
  self.btn_bubble_3V3Team:SetOnClick(self, self.btn_bubble_3V3TeamOnClick)
  self.btn_duoqiEnter:SetOnClick(self, self.btn_duoqiEnterOnClick)
  self.btn_duoqiZhengBa:SetOnClick(self, self.btn_duoqiZhengBaOnClick)
  self.btn_MonsterDimension:SetOnClick(self, self.btn_MonsterDimensionOnClick)
  self.btn_sifang:SetOnClick(self, self.btn_sifangOnClick)
end

function Main_DownTipsUI:btn_sifangOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.SiFangZhengBa
  })
end

function Main_DownTipsUI:btn_redFortEnterOnClick(control)
  UIManager.Show(UIID.Activity_RedfortEnterUI)
end

function Main_DownTipsUI:btn_onHookEnterOnClick(control)
  UIManager.Show(UIID.OnHook)
end

function Main_DownTipsUI:AuctionRecommendOnClick(control)
  UIManager.Show(UIID.AuctionRecommendTIpsUI, {
    ItemInfo = control.info
  })
  self.btn_auctionZhanEnterRedPoint:SetActive(false)
end

function Main_DownTipsUI:OnAuctionZhanBtnClick(control)
  Main_DownTipsUI:OnOpenAuctionPanel(AuctionTileTabType.Union)
end

function Main_DownTipsUI:OnAuctionLianBtnClick(control)
  Main_DownTipsUI:OnOpenAuctionPanel(AuctionTileTabType.UnionCamp)
end

function Main_DownTipsUI:OnOpenAuctionPanel(_openFirstTab)
  local tab
  if _openFirstTab == AuctionTileTabType.Union then
    tab = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Auction_warAllianceRemind")
  elseif _openFirstTab == AuctionTileTabType.UnionCamp then
    tab = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Auction_unionRemind")
  end
  local textContent = tab and tab or ""
  local title = {
    title = "",
    textContent = textContent,
    cancelText = nil,
    okText = nil,
    cancel = nil,
    ok = self.btn_OpenAuctionOnClick,
    okArgs = _openFirstTab
  }
  UIManager.Show(UIID.PromptTipUI, title)
end

function Main_DownTipsUI.btn_OpenAuctionOnClick(_args)
  UIManager.Hide(UIID.PromptTipUI)
  UIManager.Show(UIID.Auction_AuctionUI, {openFirstTab = _args})
  if _args == AuctionTileTabType.Union then
    AuctionData.isFirstOpenAuctionUnionTips = false
  elseif _args == AuctionTileTabType.UnionCamp then
    AuctionData.isFirstOpenAuctionUnionCampTips = false
  end
  Main_DownTipsUI:RefreshAuctionEnterBtn()
end

function Main_DownTipsUI:btn_wolfEnterOnClick(control)
  Activity_LangHunYaoSaiData.TalentBtnOnClick = true
  NetManager.Send(ActivityMessage.ReqLangHunYaoSaiTalent)
end

function Main_DownTipsUI:btn_quiTeamMiniOnClick()
  UIManager.Show(UIID.Team_TeamUpQuicklyUI)
  if TeamUpQuicklyData.State > 2 then
    TeamUpQuicklyData.State = 0
  end
  self.btn_quicklyTeamMinimize:SetActive(false)
  self.btn_quicklyTeamMinimize.rawImage.material:SetFloat("_InnerGlowLerpRate", 0)
end

function Main_DownTipsUI:btn_guardEnterOnClick(control)
  if control.bubbleInfo.args then
    UIManager.Show(control.bubbleInfo.uiName, control.bubbleInfo.args)
  else
    UIManager.Show(control.bubbleInfo.uiName)
  end
  if control.bubbleInfo.type == BubbleTypeEnum.ItemOverdue then
    BubbleData.RemoveBubbleById(control.bubbleInfo.id)
  end
  self.btn_guardEnter:SetActive(false)
end

function Main_DownTipsUI:btn_MonthCardMaturitOnClick(control)
  ExpiredPromptData.ShowSortUI(ExpiredTypeEnum.PrivilegeCard)
end

function Main_DownTipsUI:btn_memberCardMaturitOnClick(control)
  ExpiredPromptData.ShowSortUI(ExpiredTypeEnum.MemberCard)
end

function Main_DownTipsUI:btn_EfficientExpiredOnClick(control)
  ExpiredPromptData.ShowSortUI(ExpiredTypeEnum.Efficient)
end

function Main_DownTipsUI:btn_applyTeamOnClick(control)
  local openType = {
    openType = ShowTeamType.MyApplyType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function Main_DownTipsUI:btn_InviteTeamOnClick(control)
  local openType = {
    openType = ShowTeamType.MyApplyType
  }
  UIManager.Show(UIID.Team_TeamInfoUI, {type = openType})
end

function Main_DownTipsUI:btn_goWarAllianceOnClick(control)
  EventManager.Dispatch(Event.WarAlliance_OpenInviteMembershipView)
end

function Main_DownTipsUI:btn_goRedemptionOnClick()
  PathFinderManager.FlyTransferScene(PlayerControlForceData.RedemJumpParam[1], nil, {
    npcId = PlayerControlForceData.RedemJumpParam[2]
  }, Purpose.ClickNpc)
end

function Main_DownTipsUI:RegistEvents()
  self:RegistEvent(Event.AuctionTipsUI, self.AuctionTipsUI, self)
  self:RegistEvent(Event.TalentBtnShow, self.ShowWolfEnterBtn, self)
  self:RegistEvent(Event.LangHunTalentCountChange, self.SetWolfEnterCount, self)
  self:RegistEvent(Event.Team_TeamUpQuicklyMinimize, self.TeamUpQuicklyMiniMize, self)
  self:RegistEvent(Event.Team_MatchingCountown, self.MatchingCountown, self)
  self:RegistEvent(Event.Team_MatchingSuccessful, self.SetMinimizeEffect, self)
  self:RegistEvent(Event.Team_MatchingFail, self.SetMinimizeEffect, self)
  self:RegistEvent(Event.Bubble_BubbleRefresh, self.OnBubbleRefresh, self)
  self:RegistEvent(Event.GamePlay_Back2Choose, self.OnBubbleReset, self)
  self:RegistEvent(Event.GamePlay_Leave, self.OnBubbleReset, self)
  self:RegistEvent(Event.Role_OnChangeMap, self.OnMapChange, self)
  self:RegistEvent(Event.MemberPrivilegeCardBubbleTips, self.MemberPrivilegeCardBubbleTips, self)
  self:RegistEvent(Event.Buff_RoleMonthCardBuff, self.MonthCardBuy, self)
  self:RegistEvent(Event.EfficientExpired_DownTips, self.EfficientExpired_DownTips, self)
  self:RegistEvent(Event.EfficientExpiredTips, self.EfficientExpiredTips, self)
  self:RegistEvent(Event.Team_InviteListUpdate, self.ShowInviteBtn, self)
  self:RegistEvent(Event.Team_AskListUpdate, self.ShowAskBtn, self)
  self:RegistEvent(Event.UpdateAllianceInvite, self.ShowInviteMembershipBtn, self)
  self:RegistEvent(Event.GamePlay_Leave, self.SwitchRoleHideChild, self)
  self:RegistEvent(Event.GamePlay_Back2Choose, self.SwitchRoleHideChild, self)
  self:RegistEvent(Event.Team_TransferLeader, self.SwitchRoleHideChild, self)
  self:RegistEvent(Event.Team_QuitTeam, self.SwitchRoleHideChild, self)
  self:RegistEvent(Event.CanCombineTip, self.OnCombineTip, self)
  self:RegistEvent(Event.GamePlay_Leave, self.OnGamePlay_Leave, self)
  self:RegistEvent(Event.GamePlay_Back2Choose, self.OnGamePlay_Leave, self)
  self:RegistEvent(Event.EquipRedemptionRefresh, self.RefreshEquipRedemption, self)
  self:RegistEvent(Event.TemporaryMemberLevelChanged, self.MemberVipDataChange, self)
  self:RegistEvent(Event.MemberLevelChanged, self.MemberVipDataChange, self)
  self:RegistEvent(Event.ThreeVSThreeMatchingMinimize, self.ThreeVSThreeMatchingMinimizeCallBack, self)
  self:RegistEvent(Event.RefreshMonsterDimension, self.RefreshMonsterDimension, self)
  self:RegistEvent(Event.ThreeVSThreeInviteUIMinimize, self.ThreeVSThreeInviteUIMinimizeCallBack, self)
  self:RegistEvent(Event.ThreeVThreeMatchSuccessTransferToMap, self.ThreeVsThreeMatchSuccessCallBack, self)
  self:RegistEvent(Event.ThreeVThreeMatchTimeOut, self.ThreeVsThreeMatchTimeOutCallBack, self)
  self:RegistEvent(Event.ThreeVThreeCancleMatchSuccess, self.ThreeVThreeCancleMatchSuccessCallBack, self)
  self:RegistEvent(Event.ThreeVSThreeInviteUIAndBubbleHide, self.ThreeVSThreeInviteUIAndBubbleHideCallBack, self)
  self:RegistEvent(Event.ShowBtnDuoQiEnter, self.RefreshBtnDuoQiEnter, self)
  self:RegistEvent(Event.EnterUnionMap, self.RefreshBtnDuoQiEnter, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.RefreshBtnDuoQiEnter, self)
  self:RegistEvent(Event.Role_OnLoginedMap, self.RefreshBtnDuoQiEnter, self)
  self:RegistEvent(Event.ShowBtnDuoQiZhengBaEnter, self.RefreshBtnDuoQiZhengBa, self)
  self:RegistEvent(Event.EnterUnionMap, self.RefreshBtnDuoQiZhengBa, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.RefreshBtnDuoQiZhengBa, self)
  self:RegistEvent(Event.Role_OnLoginedMap, self.RefreshBtnDuoQiZhengBa, self)
  self:RegistEvent(Event.CheckSiFangZhengBaOpen, self.RefreshBtnSiFangZhengBa, self)
  self:RegistEvent(Event.EnterFourPartyRivalryScene, self.RefreshBtnSiFangZhengBa, self)
  self:RegistEvent(Event.Role_MyLvChanged, self.RefreshBtnSiFangZhengBa, self)
  self:RegistEvent(Event.Role_OnLoginedMap, self.RefreshBtnSiFangZhengBa, self)
end

function Main_DownTipsUI:OnGamePlay_Leave()
  self.btn_goCompose:SetActive(false)
  self.btn_bubble_3V3Match:SetActive(false)
  self.btn_bubble_3V3Team:SetActive(false)
end

function Main_DownTipsUI:ThreeVsThreeMatchSuccessCallBack(_, data)
  self.btn_bubble_3V3Match:SetActive(false)
  self.btn_bubble_3V3Team:SetActive(false)
  UIManager.Show(UIID.Tip_3V3Begin, {Data = data})
end

function Main_DownTipsUI:ThreeVsThreeMatchTimeOutCallBack()
  self.btn_bubble_3V3Match:SetActive(false)
end

function Main_DownTipsUI:ThreeVThreeCancleMatchSuccessCallBack()
  self.btn_bubble_3V3Match:SetActive(false)
end

function Main_DownTipsUI:ThreeVSThreeInviteUIAndBubbleHideCallBack()
  if UIManager.IsVisible(UIID.Activity_Sport3V3Invite) then
    UIManager.Hide(UIID.Activity_Sport3V3Invite)
  end
  self.btn_bubble_3V3Team:SetActive(false)
end

function Main_DownTipsUI:CombineTipAction(combineId)
  if self.curCombineState and ItemCombineData:CheckTodayOnlyOnceState(combineId) then
    for i, v in pairs(self.combineIdList) do
      if v.id == combineId then
        table.remove(self.combineIdList, i)
        break
      end
    end
    self:RefreshCombineTipsBtn()
  end
  UIManager.UICloseType(UIPanelType.SortAndHide, true)
  UIManager.Show(UIID.Item_CombineUI, {combineId = combineId})
end

function Main_DownTipsUI:CombineTipCancelAction(combineId)
  if self.curCombineState and ItemCombineData:CheckTodayOnlyOnceState(combineId) then
    for i, v in pairs(self.combineIdList) do
      if v.id == combineId then
        table.remove(self.combineIdList, i)
        break
      end
    end
    self:RefreshCombineTipsBtn()
  end
end

function Main_DownTipsUI:OnCombineTip(_, data)
  self.combineIdList = data
  self:RefreshCombineTipsBtn()
end

function Main_DownTipsUI:RefreshCombineTipsBtn()
  if #self.combineIdList == 0 or not TipUtility.IsOpenCombineUI then
    if self.btn_goCompose.transform.gameObject.activeSelf then
      self.btn_goCompose:SetActive(false)
    end
    return
  end
  self.btn_goCompose:SetActive(true)
end

function Main_DownTipsUI:CombineBtnClick()
  if self.combineIdList == nil or next(self.combineIdList) == nil then
    return
  end
  local openDir = PlayerControlForceData.ComposeIsOpen()
  if openDir then
    UIManager.JumpShow(UIPanelType.SortAndHide, UIID.Item_CombineUI, {
      npcConfigID = PlayerControlForceData.composeJumpParam[2],
      combineId = self.combineIdList[1].id
    })
  else
    local boxes = ItemboxDisplayManager.GetBox(ViewData.meData.career, self.combineIdList[1].rewardBoxId)
    boxes = ItemboxDisplayManager.GenerateItemShowData(boxes[1])
    local type = boxes.tblItem.type
    local color
    if type == 1 then
      color = ItemQuality2ColorDic[EItemColorEnum.white]
    elseif type == 3 then
      color = ItemQuality2ColorDic[EItemColorEnum.white]
    elseif type == 5 then
      color = ItemQuality2ColorDic[EItemColorEnum.gold]
    elseif type == 6 then
      color = ItemQuality2ColorDic[EItemColorEnum.gold]
    end
    color = color or ItemQuality2ColorDic[boxes.tblItem.quality]
    boxes = string.GetColorText(LocalizationUtility.GetContentByKey(self.combineIdList[1].combineFormula), color)
    if self.mCombineTipAction == nil then
      function self.mCombineTipAction(id)
        self:CombineTipAction(id)
      end
    end
    if self.mCombineTipCancelAction == nil then
      function self.mCombineTipCancelAction(id)
        self:CombineTipCancelAction(id)
      end
    end
    TipUtility.QuickShowPrompt({
      id = PromptWordType.CombinePrompt,
      contentFormatArgs = boxes,
      okArgs = self.combineIdList[1].id,
      okAction = self.mCombineTipAction,
      cancelArgs = self.combineIdList[1].id,
      cancelAction = self.mCombineTipCancelAction,
      closeArgs = self.combineIdList[1].id,
      closeCallBack = self.mCombineTipCancelAction,
      onlyOnce = true,
      onlyOnceArgs = self.combineIdList[1].id,
      onlyOnceAction = function(id, isOn)
        self.curCombineState = isOn
        ItemCombineData:SetTodayOnlyOnceState(id, isOn)
      end
    })
  end
end

function Main_DownTipsUI:btn_bubble_3V3MatchOnClick()
  UIManager.Show(UIID.CrossServer_IntoUI)
  self.btn_bubble_3V3Match:SetActive(false)
end

function Main_DownTipsUI:btn_duoqiEnterOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiCross
  })
end

function Main_DownTipsUI:btn_duoqiZhengBaOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiZhengBa
  })
end

function Main_DownTipsUI:btn_bubble_3V3TeamOnClick()
  if self.latest3v3InviteData then
    UIManager.Show(UIID.Activity_Sport3V3Invite, {
      data = self.latest3v3InviteData
    })
  end
  self.btn_bubble_3V3Team:SetActive(false)
end

function Main_DownTipsUI:AuctionTipsUI(_, data)
  if TipData.AuctionOpen then
    self.btn_auctionEnter.info = data
    local open = data and true or false
    self.btn_auctionEnter:SetActive(open)
  end
end

function Main_DownTipsUI:OnBubbleRefresh()
  for i, v in pairs(BubbleData.BubbleList) do
    if v.subType and v.subType == BubbleArticlesType.Pet then
      self.btn_guardEnter.bubbleInfo = v
      self.btn_guardEnter:SetActive(true)
      return
    end
  end
  self.btn_guardEnter:SetActive(false)
end

function Main_DownTipsUI:OnBubbleReset()
  BubbleData.RemoveAllBubble()
  self:OnBubbleRefresh()
end

function Main_DownTipsUI:OnMapChange()
  BubbleData.RemoveMapBubble()
  self:OnBubbleRefresh()
end

function Main_DownTipsUI:ColseMonthTimer(type, ctr)
  ctr:SetActive(false)
  local Cor
  if type == ExpiredTypeEnum.Efficient then
    Cor = self.OpenDoTween[ExpiredTypeEnum.Efficient]
  elseif type == ExpiredTypeEnum.MemberCard then
    Cor = self.OpenDoTween[ExpiredTypeEnum.MemberCard]
    local data = {
      memberCardData = {}
    }
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():CardInfo(IndexerEnum.set, data)
  elseif type == ExpiredTypeEnum.PrivilegeCard then
    Cor = self.OpenDoTween[ExpiredTypeEnum.PrivilegeCard]
    local data = {
      privilegeCardData = {}
    }
    gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():CardInfo(IndexerEnum.set, data)
  end
  if Cor ~= nil then
    Timer.Stop(Cor)
    Cor = nil
  end
  if ctr.quence then
    ctr.quence:Kill(true)
    ctr.quence = nil
  end
end

function Main_DownTipsUI:OpenMonthDoTween(ctr, time)
  local quence = DOTween.Sequence()
  local fragment1 = ctr.image:DOFade(1, 0.8)
  local fragment2 = ctr.image:DOFade(0, 0.8)
  quence:Append(fragment1)
  quence:Append(fragment2)
  quence:SetLoops(time, CS.DG.Tweening.LoopType.Yoyo):OnComplete(function()
    fragment1:Kill(true)
    fragment2:Kill(true)
  end)
  ctr.quence = quence
end

function Main_DownTipsUI:MemberPrivilegeCardBubbleTips()
  local mCardInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():CardInfo(IndexerEnum.get)
  if mCardInfo and mCardInfo.privilegeCardData and table.count(mCardInfo.privilegeCardData) > 0 then
    local time = mCardInfo.privilegeCardData.time
    if not self.btn_MonthCardMaturit.gameObject.activeSelf then
      self.btn_MonthCardMaturit:SetActive(true)
      self.MonthInitTime = tonumber(time)
    end
    self:OpenMonthDoTween(self.btn_MonthCardMaturit, self.MonthInitTime)
    self.btn_MonthCardMaturit:SetActive(true)
    self.OpenDoTween[ExpiredTypeEnum.PrivilegeCard] = Timer.StartLoop(self.MonthInitTime, 1, function()
      self:ColseMonthTimer(ExpiredTypeEnum.PrivilegeCard, self.btn_MonthCardMaturit)
    end)
  end
  if mCardInfo and mCardInfo.memberCardData and 0 < table.count(mCardInfo.memberCardData) then
    local time = mCardInfo.memberCardData.time
    if not self.btn_memberCardMaturit.gameObject.activeSelf then
      self.btn_memberCardMaturit:SetActive(true)
      self.MemberInitTime = tonumber(time)
    end
    self:OpenMonthDoTween(self.btn_memberCardMaturit, self.MemberInitTime)
    self.btn_memberCardMaturit:SetActive(true)
    self.OpenDoTween[ExpiredTypeEnum.MemberCard] = Timer.StartLoop(self.MemberInitTime, 1, function()
      self:ColseMonthTimer(ExpiredTypeEnum.MemberCard, self.btn_memberCardMaturit)
    end)
  end
end

function Main_DownTipsUI:EfficientExpiredTips(_, data)
  if 0 < data then
    self:ColseMonthTimer(ExpiredTypeEnum.Efficient, self.btn_EfficientExpired)
  end
end

function Main_DownTipsUI:EfficientExpired_DownTips()
  if not self.btn_EfficientExpired.gameObject.activeSelf then
    self.btn_EfficientExpired:SetActive(true)
    self.EfficientTime = tonumber(GlobalConfig.efficientmaturitTime)
  end
  self:OpenMonthDoTween(self.btn_EfficientExpired, self.EfficientTime)
  self.btn_EfficientExpired:SetActive(true)
  self.OpenDoTween[ExpiredTypeEnum.Efficient] = Timer.StartLoop(self.EfficientTime, 1, function()
    self:ColseMonthTimer(ExpiredTypeEnum.Efficient, self.btn_EfficientExpired)
  end)
end

function Main_DownTipsUI:RefreshEquipRedemption()
  if #EquipRedemptionData.equipGetData ~= 0 and #EquipRedemptionData.equipLostData ~= 0 then
    self.btn_goRedemption:SetActive(false)
  else
    self.btn_goRedemption:SetActive(true)
  end
end

function Main_DownTipsUI:MemberVipDataChange()
  if gameMgr:GetAvatarManager() and gameMgr:GetAvatarManager():GetMainPlayer() and gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr() then
    local memberData = gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
    if memberData:IsHideDownTips() then
      self:ColseMonthTimer(ExpiredTypeEnum.MemberCard, self.btn_memberCardMaturit)
    end
  end
end

function Main_DownTipsUI:ThreeVSThreeMatchingMinimizeCallBack(_, data)
  self.btn_bubble_3V3Match:SetActive(data.state)
end

function Main_DownTipsUI:ThreeVSThreeInviteUIMinimizeCallBack(_, latestInviteData)
  self.latest3v3InviteData = latestInviteData
  self.btn_bubble_3V3Team:SetActive(true)
end

function Main_DownTipsUI:MonthCardBuy()
  local mSilverCard = RoleManager.me.data.equipsData.StoneData[CommercializeEquipCell.GoldCard]
  if mSilverCard then
    self:ColseMonthTimer(ExpiredTypeEnum.PrivilegeCard, self.btn_MonthCardMaturit)
  end
end

function Main_DownTipsUI:Refresh()
  if not TeamUpQuicklyData.TeamInfor then
    self.btn_quicklyTeamMinimize:SetActive(false)
  end
  self.btn_InviteTeam:SetActive(table.count(InvitationData.GetInvitedToTeamData()) > 0)
  self.btn_applyTeam:SetActive(0 < table.count(TeamData.askInList))
  self.btn_goWarAlliance:SetActive(0 < table.count(InvitationData.GetInvitedToAllianceData()))
  self.btn_MonsterDimension:SetActive(false)
  self:RefreshBtnDuoQiEnter()
  self:RefreshBtnDuoQiZhengBa()
end

function Main_DownTipsUI:StartRedFortEnterTimer()
  if RedFortData.InRedFortActivity then
    return
  end
  local timeCounter = RedFortData.prepareCountDown - Time.GetServerSecondTime()
  if timeCounter <= 0 then
    return
  end
  self.btn_redFortEnter:SetActive(true)
  
  local function StartTimer()
    if timeCounter <= 0 and self.countDownPrepareTimer then
      Timer.Stop(self.countDownPrepareTimer)
      self.countDownPrepareTimer = nil
      self.btn_redFortEnter:SetActive(false)
    end
    timeCounter = timeCounter - 1
  end
  
  StartTimer()
  self.countDownPrepareTimer = Timer.StartLoopForever(1, StartTimer)
end

function Main_DownTipsUI:HideRedFortTimer()
  if self.countDownPrepareTimer then
    Timer.Stop(self.countDownPrepareTimer)
    self.countDownPrepareTimer = nil
    self.btn_redFortEnter:SetActive(false)
  end
end

function Main_DownTipsUI:ShowOnHookBtn(_, state)
end

function Main_DownTipsUI:ShowWolfEnterBtn(_, state)
  self.btn_wolfEnter:SetActive(state)
end

function Main_DownTipsUI:SetWolfEnterCount(_, count)
  self.wolfEnterCount:SetText(Activity_LangHunYaoSaiData.Count)
end

function Main_DownTipsUI:ShowInviteBtn(id, data)
  self.btn_InviteTeam:SetActive(data and 0 < data)
end

function Main_DownTipsUI:ShowAskBtn(id, data)
  self.btn_applyTeam:SetActive(data and 0 < data)
end

function Main_DownTipsUI:ShowInviteMembershipBtn(id, data)
  self.btn_goWarAlliance:SetActive(data and 0 < data)
end

function Main_DownTipsUI:SwitchRoleHideChild()
  self.btn_InviteTeam:SetActive(false)
  self.btn_applyTeam:SetActive(false)
  self.btn_goWarAlliance:SetActive(false)
  self.btn_goRedemption:SetActive(false)
end

local minimizeCloseTime = 0

local function CloseQuicklyTeamMinimize(self, timeCount)
  Coroutine.Wait(timeCount)
  if not TeamUpQuicklyData.TeamInfor or TeamUpQuicklyData.TeamInfor.match or not TeamUpQuicklyData.IsLeader() then
  end
  self.btn_quicklyTeamMinimize:SetActive(false)
  TeamUpQuicklyData.TeamInfor = nil
  minimizeCloseTime = 0
end

function Main_DownTipsUI:SetMinimizeEffect(id)
  UIManager.Hide(UIID.Item_CombineUI)
  UIManager.Hide(UIID.Item_CombinePreviewUI)
  UIManager.Show(UIID.Team_TeamUpQuicklyUI)
  self.btn_quicklyTeamMinimize:SetActive(false)
  local countDown = (TeamUpQuicklyData.TeamInfor.endTime - Time.GetServerTime()) * 0.001
  Coroutine.Start(CloseQuicklyTeamMinimize, self, countDown)
end

function Main_DownTipsUI:TeamUpQuicklyMiniMize(id, msg)
  self.btn_quicklyTeamMinimize:SetActive(msg)
  self.btn_quicklyTeamMinimize.rawImage.material:SetFloat("_InnerGlowLerpRate", 0)
  self.lab_MatchingCountown:SetText("")
end

local flickerCtr = 0
local addOrSubtract = true

function Main_DownTipsUI:MatchingCountown(id, msg)
  self.lab_MatchingCountown:SetText(msg)
  if TeamUpQuicklyData.State > 1 then
    if 0.4 < flickerCtr then
      addOrSubtract = false
      flickerCtr = 0.4
    end
    if flickerCtr < 0 then
      addOrSubtract = true
      flickerCtr = 0
    end
    if addOrSubtract then
      flickerCtr = flickerCtr + 0.02
    else
      flickerCtr = flickerCtr - 0.02
    end
  else
    flickerCtr = 0
  end
  self.btn_quicklyTeamMinimize.rawImage.material:SetFloat("_InnerGlowLerpRate", flickerCtr)
  if msg <= 0 then
    self.lab_MatchingCountown:SetText("")
  end
end

function Main_DownTipsUI:RefreshAuctionEnterBtn()
  EventManager.Dispatch(Event.RP_RedPointRefresh, {
    index = ERedPointType.btnFunc,
    state = true
  })
end

function Main_DownTipsUI:RefreshMonsterDimension(_, isShow)
  self.btn_MonsterDimension:SetActive(isShow)
end

function Main_DownTipsUI:btn_MonsterDimensionOnClick()
  UIManager.Show(UIID.Tip_MonsterTipUI)
end

function Main_DownTipsUI:RefreshBtnDuoQiEnter(_, data)
  local isOpenUnionAndLevelOk = QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpenAndLevelOk()
  local isInUnionMap = QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi()
  if isOpenUnionAndLevelOk == nil or isInUnionMap == nil then
    return
  end
  if isOpenUnionAndLevelOk and not isInUnionMap and TranScriptData.InTranscript == false and TranScriptData.InAllGodsscript == false then
    self.btn_duoqiEnter:SetActive(true)
    QuickFind:GetDuoQiCrossDataManager():SetIsShowBtnDuoQiEnter(true)
    return
  end
  self.btn_duoqiEnter:SetActive(false)
  QuickFind:GetDuoQiCrossDataManager():SetIsShowBtnDuoQiEnter(false)
end

function Main_DownTipsUI:RefreshBtnDuoQiZhengBa(_, data)
  local isOpenUnionAndLevelOk = QuickFind:GetDuoQiCrossDataManager():IsZhengBaActivityOpenAndLevelOk()
  local isInUnionMap = QuickFind:GetDuoQiCrossDataManager():IsEnterDuoQi()
  if isOpenUnionAndLevelOk == nil or isInUnionMap == nil then
    return
  end
  if isOpenUnionAndLevelOk and not isInUnionMap and TranScriptData.InTranscript == false and TranScriptData.InAllGodsscript == false then
    self.btn_duoqiZhengBa:SetActive(true)
    QuickFind:GetDuoQiCrossDataManager():SetIsShowBtnDuoQiZhengBaEnter(true)
    return
  end
  self.btn_duoqiZhengBa:SetActive(false)
  QuickFind:GetDuoQiCrossDataManager():SetIsShowBtnDuoQiZhengBaEnter(false)
end

function Main_DownTipsUI:RefreshBtnSiFangZhengBa()
  local isOpen = SiFangZhengBaController.CheckActivityOpen()
  self.btn_sifang:SetActive(isOpen)
end
