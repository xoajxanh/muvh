Auction_AuctionUI = class(BaseUI)
Auction_AuctionUI.layer = UILayer.Panel
Auction_AuctionUI.orderInLayer = 2
Auction_AuctionUI.hideType = UIHideType.Destroy
Auction_AuctionUI.hideFunc = UIHideFunc.MoveOutOfScreen
Auction_AuctionUI.escClose = UIEscClose.DontClose

function Auction_AuctionUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.go_money = self:GetControl("img_bg/grid_money/go_money")
  self.btn_tabitem = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_tabitem")
  self.btn_mybought = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_mybought")
  self.btn_sale = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_sale")
  self.btn_holyring_sale = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_holyring_sale")
  self.btn_holyskeleton_sale = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_holyskeleton_sale")
  self.btn_zhan_tab = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_zhan_tab")
  self.btn_UnionCamp = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_UnionCamp")
  self.goodsPanel = self:GetControl("goodsPanel")
  self.goodsType = self:GetControl("goodsPanel/goodsType")
  self.MainContent = self:GetControl("goodsPanel/goodsType/Viewport/Content")
  self.btn_all = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_all")
  self.btn_public = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_public")
  self.btn_equip = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_equip")
  self.subContent_equip = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_equip")
  self.btn_suitEquip = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_suitEquip")
  self.subContent_suitEquip = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_suitEquip")
  self.btn_jewelryEquip = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_jewelryEquip")
  self.subContent_jewelryEquip = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_jewelryEquip")
  self.btn_holySpirit = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_holySpirit")
  self.subContent_holySpirit = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_holySpirit")
  self.subContent_holyring = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_holyring")
  self.subContent_holyskeleton = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_holyskeleton")
  self.btn_skillBook = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_skillBook")
  self.btn_material = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_material")
  self.subContent_material = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_material")
  self.btn_diamond = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_diamond")
  self.subContent_diamond = self:GetControl("goodsPanel/goodsType/Viewport/Content/subContent_diamond")
  self.btn_integral = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_integral")
  self.chooseUser = self:GetControl("goodsPanel/filterPanel/chooseUser")
  self.chooseSort = self:GetControl("goodsPanel/filterPanel/chooseSort")
  self.chooseEquipGrade = self:GetControl("goodsPanel/filterPanel/chooseEquipGrade")
  self.chooseRoleLevel = self:GetControl("goodsPanel/filterPanel/chooseRoleLevel")
  local chooseEquip = self:GetControl("goodsPanel/filterPanel/chooseEquipGrade/chooseEquipClassLabel")
  self.chooseEquipClassLabel = chooseEquip.transform:GetComponent("Text")
  self.chooseHolySpiritGrade = self:GetControl("goodsPanel/filterPanel/chooseHolySpiritGrade")
  local choosHolySpirit = self:GetControl("goodsPanel/filterPanel/chooseHolySpiritGrade/chooseHolySpiritLabel")
  self.chooseHolySpiritClassLabel = choosHolySpirit.transform:GetComponent("Text")
  self.AllAuctionPanel = self:GetControl("goodsPanel/AllAuctionPanel")
  self.bg_goodsPanel = self:GetControl("goodsPanel/AllAuctionPanel/Scroll_Goods/bg_goodsPanel")
  self.Viewport = self:GetControl("goodsPanel/AllAuctionPanel/Scroll_Goods/bg_goodsPanel/Viewport")
  self.Content = self:GetControl("goodsPanel/AllAuctionPanel/Scroll_Goods/bg_goodsPanel/Viewport/Content")
  self.Button_goodsItem = self:GetControl("goodsPanel/AllAuctionPanel/Scroll_Goods/bg_goodsPanel/Viewport/Content/Button_goodsItem")
  self.buyNum = self:GetControl("goodsPanel/AllAuctionPanel/Scroll_Goods/bg_goodsPanel/Viewport/Content/Button_goodsItem/buyNum")
  self.img_buy = self:GetControl("goodsPanel/AllAuctionPanel/Scroll_Goods/bg_goodsPanel/Viewport/Content/Button_goodsItem/buyNum/img_buy")
  self.loadBg = self:GetControl("goodsPanel/AllAuctionPanel/loadBg")
  self.UnionAuctionPanel = self:GetControl("goodsPanel/UnionAuctionPanel")
  self.bg_goodsPanelTeam = self:GetControl("goodsPanel/UnionAuctionPanel/Scroll_Goods/bg_goodsPanelTeam")
  self.unionScrollContent = self:GetControl("goodsPanel/UnionAuctionPanel/Scroll_Goods/bg_goodsPanelTeam/Viewport/Content")
  self.Button_UnionItem = self:GetControl("goodsPanel/UnionAuctionPanel/Scroll_Goods/bg_goodsPanelTeam/Viewport/Content/Button_UnionItem")
  self.salePanel = self:GetControl("salePanel")
  self.jiaoyishuiTxt = self:GetControl("salePanel/jiaoyishui_Table/jiaoyishui")
  self.plane_right = self:GetControl("salePanel/plane_right")
  self.lab_goodsTitle = self:GetControl("salePanel/Scroll_Goods/lab_goodsTitle")
  self.Button_SaleRackItem = self:GetControl("salePanel/Scroll_Goods/bg_putaway/Viewport/Content/Button_SaleRackItem")
  self.Scroll_BagInfos = self:GetControl("salePanel/Scroll_BagInfos")
  self.sw_RingBagItem = self:GetControl("salePanel/sw_RingBagItem")
  self.sw_SkeletonBagItem = self:GetControl("salePanel/sw_SkeletonBagItem")
  self.RingItem = self:GetControl("salePanel/sw_RingBagItem/Viewport/Content/RingItem")
  self.SkeletonItem = self:GetControl("salePanel/sw_SkeletonBagItem/Viewport/Content/SkeletonItem")
  self.go_BagContent = self:GetControl("salePanel/Scroll_BagInfos/Viewport/go_BagContent")
  self.tile_bg = self:GetControl("salePanel/Scroll_BagInfos/Viewport/go_BagContent/tile_bg")
  self.go_DragCheck = self:GetControl("salePanel/Scroll_BagInfos/go_DragCheck")
  self.go_ScrollTop = self:GetControl("salePanel/Scroll_BagInfos/go_DragCheck/go_ScrollTop")
  self.go_ScrollBottom = self:GetControl("salePanel/Scroll_BagInfos/go_DragCheck/go_ScrollBottom")
  self.go_DragEdge = self:GetControl("salePanel/Scroll_BagInfos/go_DragCheck/go_DragEdge")
  self.btn_3DItem = self:GetControl("salePanel/Scroll_BagInfos/btn_3DItem")
  self.myBoughtPanel = self:GetControl("myBoughtPanel")
  self.Scroll_TradeHistory = self:GetControl("myBoughtPanel/Scroll_Goods/bg_myPanelTitle")
  self.historyItemTemplate = self:GetControl("myBoughtPanel/Scroll_Goods/historyItemTemplate")
  self.descBtn = self:GetControl("descBtn")
  self.btn_StallPar = self:GetControl("salePanel/btn_StallPar")
  self.go_noStall = self:GetControl("salePanel/btn_StallPar/go_noStall")
  self.mainBtn_OpenStall = self:GetControl("salePanel/btn_StallPar/go_noStall/mainBtn_openStall")
  self.mainlab_OpenStall = self:GetControl("salePanel/btn_StallPar/go_noStall/mainBtn_openStall/Text")
  self.go_yesStall = self:GetControl("salePanel/btn_StallPar/go_yesStall")
  self.mainLab_stallTime = self:GetControl("salePanel/btn_StallPar/go_yesStall/mainLab_stallTime")
  self.mainBtn_stallshout = self:GetControl("salePanel/btn_StallPar/go_yesStall/mainBtn_stallshout")
  self.mainBtn_goToStall = self:GetControl("salePanel/btn_StallPar/go_yesStall/mainBtn_goToStall")
  self.btn_bgStallFrame = self:GetControl("salePanel/btn_StallPar/btn_bgStallFrame")
  self.panel_Stall = self:GetControl("salePanel/panel_Stall")
  self.btn_closeStallPanel = self:GetControl("salePanel/panel_Stall/bg/btn_closeStallPanel")
  self.btn_openStallNoticeList = self:GetControl("salePanel/panel_Stall/lab_stallNotice/btn_openStallNoticeList")
  self.sw_stallNoticeList = self:GetControl("salePanel/panel_Stall/lab_stallNotice/sw_stallNoticeList")
  self.sw_stallNoticeContent = self:GetControl("salePanel/panel_Stall/lab_stallNotice/sw_stallNoticeList/Viewport/Content")
  self.lab_stallNoticeName = self:GetControl("salePanel/panel_Stall/lab_stallNotice/img_stallNoticeBg/lab_stallNoticeName")
  self.btn_sendBuyStall = self:GetControl("salePanel/panel_Stall/btn_sendBuyStall")
  self.dp_StallCity = self:GetControl("salePanel/panel_Stall/lab_stallCity/dp_stallCity")
  self.lab_stallCityCount = self:GetControl("salePanel/panel_Stall/lab_stallCity/lab_stallCityCount")
  self.btn_Bg_Colider = self:GetControl("salePanel/panel_Stall/btn_Bg_Colider")
  self.btn_randomPosition = self:GetControl("salePanel/panel_Stall/lab_stallPosition/btn_randomPosition")
  self.lab_RandomPos = self:GetControl("salePanel/panel_Stall/lab_stallPosition/img_postionBg/lab_RandomPos")
  self.dp_StallTime = self:GetControl("salePanel/panel_Stall/lab_stallTime/dp_stallTime")
  self.item_StallConsume = self:GetControl("salePanel/panel_Stall/lab_stallConsume/img_consumeBg/item_StallConsume")
  self.lab_StallConsumeNum = self:GetControl("salePanel/panel_Stall/lab_stallConsume/img_consumeBg/lab_num")
  self.btn_getPath = self:GetControl("salePanel/panel_Stall/lab_stallConsume/btn_getPath")
  self.panel_StallShout = self:GetControl("salePanel/panel_StallShout")
  self.btn_closeShoutPanel = self:GetControl("salePanel/panel_StallShout/bg/btn_closeShoutPanel")
  self.lab_commodity = self:GetControl("salePanel/panel_StallShout/lab_commodity")
  self.dp_ShoutItemOne = self:GetControl("salePanel/panel_StallShout/lab_commodity/dp_ShoutItemOne")
  self.dp_ShoutItemTwo = self:GetControl("salePanel/panel_StallShout/lab_commodity/dp_ShoutItemTwo")
  self.dp_ShoutIemThree = self:GetControl("salePanel/panel_StallShout/lab_commodity/dp_ShoutIemThree")
  self.lab_ShoutStallPos = self:GetControl("salePanel/panel_StallShout/lab_ShoutPosition/lab_ShoutStallPos")
  self.item_Shout3DItem = self:GetControl("salePanel/panel_StallShout/item_Shout3DItem")
  self.lab_costNum = self:GetControl("salePanel/panel_StallShout/item_Shout3DItem/lab_costNum")
  self.btn_sendShout = self:GetControl("salePanel/panel_StallShout/btn_sendShout")
  self.lab_sendShoutCD = self:GetControl("salePanel/panel_StallShout/btn_sendShout/lab_sendShoutCD")
  self.btn_server_2 = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_server_2")
  self.btn_server_3 = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_server_3")
  self.btn_server_4 = self:GetControl("Scroll_changeTab/Viewport/changeTab/btn_server_4")
  self.btn_holyring = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_holyring")
  self.btn_holyskeleton = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_holyskeleton")
  self.btn_newrunes = self:GetControl("goodsPanel/goodsType/Viewport/Content/btn_newrunes")
end

function Auction_AuctionUI:Init()
  self.OnePriceItem = 0
  self.UnionAuctionItemTab = {}
  self.PutAwayTab = {}
  self.PutAwayBidId = {}
  self.PutAwayData = 0
  self.PutAwayCount = 1
  self.MaxCount = 0
  self.OutOfItem = nil
  self.PutOnItem = nil
  self.IsOneInit = {}
  self.recTimer = {}
  self.CurrentTab = 0
  self.showCoins = {
    ECoinsType.gem,
    ECoinsType.integral
  }
  AuctionData.equipGradeTypeDP = self:GetDefaultGradeByLv()
  AuctionData.page = 1
  self.pageAuctionItemTab = {}
  self.loadType = true
  self.leftTabType = AuctionTabType.All
  self.mainTabType = AuctionRecTimer.None
  self.leftMainTabType = AuctionTabType.None
  self.leftSubTabType = AuctionLeftSubTabType.None
  self.leftTitleSubTab = {}
  self.dp_ShoutOneIndex = 0
  self.dp_ShoutTwoIndex = 0
  self.dp_ShoutThreeIndex = 0
  self.excellFactorConfig = {}
end

function Auction_AuctionUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Auction_AuctionUI:InitUI()
  self:InitAllTabValue()
  AuctionData.isSlider = false
  AuctionData.page = 1
  self:InitContent()
  self:CloseAllStallOnClick()
  self:InitDataOnShow()
  AuctionController.InitFilterMeetTab()
  AuctionController.ResetAllJson()
  self:ShowAuctionTax()
  self:InitTemplate()
end

function Auction_AuctionUI:InitTemplate()
  self.EquipRuneTemplate = UIUtility.BindUIContainerTemp(self.RingItem, LuaComponentTemplates.HolyRingItemDataTemplate, self)
  self.holySkeletonBagUITemplates = UIUtility.BindUIContainerTemp(self.SkeletonItem, LuaComponentTemplates.HolySkeletonCombineSoulBagTemplate, self)
end

function Auction_AuctionUI:OnShow()
  AuctionData.isSlider = false
  AuctionData.page = 1
  AuctionController.InitFilterMeetTab()
  self:InitAllTabValue()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {
    AuctionBtnType.StrideServeBtn_2,
    AuctionBtnType.StrideServeBtn_3,
    AuctionBtnType.StrideServeBtn_4,
    AuctionBtnType.StrideServeBtn_5,
    AuctionBtnType.StrideServeBtn_6,
    AuctionBtnType.StrideServeBtn_7,
    AuctionBtnType.StrideServeBtn_8,
    AuctionBtnType.StrideServeBtn_9
  })
  self:CheackOpenService()
  self:RegistEvents()
  self:PanelShow()
  self:InitArgs()
  self:InitDataOnShow()
  self:ShowAuctionTax()
end

function Auction_AuctionUI:OnHide()
  for k, v in pairs(self.recTimer) do
    Timer.Stop(self.recTimer[k])
    self.recTimer[k] = nil
  end
  self:IsOnPanel(self.goodsPanel)
  self:SetLoadActive(false)
  self:ResetData()
  self:DesToryShoutTimer()
  self:RecycleItemModelRes(self.Button_goodsItemTemp)
  self:RecycleItemModelRes(self.Button_UnionItemTemp)
  self:RecycleItemModelRes(self.Button_SaleRackItemTemp)
  for i, v in pairs(self.holySkeletonBagUITemplates.items) do
    if v.itemTemp then
      v.itemTemp:OnHide()
    end
  end
  self:ClearAuctionRingReliquaryData()
end

function Auction_AuctionUI:RecycleItemModelRes(itemTemp)
  for i = 1, #itemTemp.items do
    local showCellData = itemTemp.items[i].itemCellData
    if showCellData then
      showCellData:RecycleRes()
      showCellData = nil
    end
  end
end

function Auction_AuctionUI:ResetData()
  self.leftTabType = AuctionTabType.All
  AuctionData.equipGradeTypeDP = self:GetDefaultGradeByLv()
  AuctionController.ResetAllJson()
  self:CloseAllStallOnClick()
  AuctionData.isOwnSelfStall = false
end

function Auction_AuctionUI:OnDestroy()
end

function Auction_AuctionUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_mybought:SetOnClick(self, self.btn_myboughtOnClick)
  self.btn_zhan_tab:SetOnClick(self, self.btn_zhan_tabOnClick)
  self.btn_UnionCamp:SetOnClick(self, self.btn_UnionCampOnClick)
  self.btn_sale:SetOnClick(self, self.btn_saleOnClick)
  self.btn_holyring_sale:SetOnClick(self, self.btn_holyring_saleOnClick)
  self.btn_holyskeleton_sale:SetOnClick(self, self.btn_holyskeleton_saleOnClick)
  self.btn_all:SetOnClick(self, self.btn_allOnClick)
  self.btn_public:SetOnClick(self, self.btn_publicOnClick)
  self.btn_equip:SetOnClick(self, self.btn_equipOnClick)
  self.btn_suitEquip:SetOnClick(self, self.btn_suitEquipOnClick)
  self.btn_jewelryEquip:SetOnClick(self, self.btn_jewelryEquipOnClick)
  self.btn_holySpirit:SetOnClick(self, self.btn_holySpiritOnClick)
  self.btn_skillBook:SetOnClick(self, self.btn_skillBookOnClick)
  self.btn_diamond:SetOnClick(self, self.btn_diamondOnClick)
  self.btn_material:SetOnClick(self, self.btn_materialOnClick)
  self.btn_integral:SetOnClick(self, self.btn_integralOnClick)
  self.Button_SaleRackItem:SetOnClick(self, self.Button_SaleRackItemOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_tabitem:SetOnClick(self, self.btn_tabitemOnClick)
  self.btn_holyring:SetOnClick(self, self.btn_holyringOnClick)
  self.btn_holyskeleton:SetOnClick(self, self.btn_holyskeletonOnClick)
  self.btn_newrunes:SetOnClick(self, self.btn_newrunesOnClick)
  self.btn_server_2:SetOnClick(self, self.btn_server_2OnClick)
  self.btn_server_3:SetOnClick(self, self.btn_server_3OnClick)
  self.btn_server_4:SetOnClick(self, self.btn_server_4OnClick)
  self.btn_bgStallFrame:SetOnClick(self, self.CloseAllStallOnClick)
  self.mainBtn_OpenStall:SetOnClick(self, self.OpenStallMainBtnOnClick)
  self.mainBtn_stallshout:SetOnClick(self, self.StallShoutMainBtnOnClick)
  self.mainBtn_goToStall:SetOnClick(self, self.GoToStallPosOnClick)
  self.btn_openStallNoticeList:SetOnClick(self, self.OpenStallNoticeList)
  self.dp_StallCity:SetOnDropDownValueChanged(self, self.OnStallCityDPChanged)
  self.btn_randomPosition:SetOnClick(self, self.RandomStallPosOnClick)
  self.dp_StallTime:SetOnDropDownValueChanged(self, self.OnStallTimeDPChanged)
  self.btn_sendBuyStall:SetOnClick(self, self.SendBuyAuctionOnClick)
  self.btn_closeStallPanel:SetOnClick(self, self.CloseStallPanel)
  self.btn_Bg_Colider:SetOnClick(self, self.OpenStallNoticeList)
  self.dp_ShoutItemOne:SetOnDropDownValueChanged(self, self.OnShoutCostOneDPChanged)
  self.dp_ShoutItemTwo:SetOnDropDownValueChanged(self, self.OnShoutCostTwoDPChanged)
  self.dp_ShoutIemThree:SetOnDropDownValueChanged(self, self.OnShoutCostThreeDPChanged)
  self.btn_sendShout:SetOnClick(self, self.SendShoutOnClick)
  self.btn_closeShoutPanel:SetOnClick(self, self.CloseShoutPanel)
  self.chooseUser:SetOnDropDownValueChanged(self, self.chooseUserChanged)
  self.chooseSort:SetOnDropDownValueChanged(self, self.chooseSortChanged)
  self.chooseEquipGrade:SetOnDropDownValueChanged(self, self.chooseEquipGradeChanged)
  self.chooseEquipGrade:SetOnPointerClick(self, self.chooseEquipGradeOnClick)
  self.chooseRoleLevel:SetOnDropDownValueChanged(self, self.chooseRoleLevelChanged)
  self.chooseHolySpiritGrade:SetOnDropDownValueChanged(self, self.chooseHolySpiritGradeChanged)
  self.chooseHolySpiritGrade:SetOnPointerClick(self, self.chooseHolySpiritGradeOnClick)
  self.bg_goodsPanel:SetOnEndDrag(self, self.bg_goodsPanelOnEndDrag)
  self.bg_goodsPanelTeam:SetOnEndDrag(self, self.bg_goodsPanelOnEndDragTeam)
  self.Content = self.Content.transform
  local auctionGridLayoutGroup = self.Content:GetComponent("GridLayoutGroup")
  self.auctionContentcellSize = auctionGridLayoutGroup.cellSize
  self.auctionContentOffset = auctionGridLayoutGroup.padding.top + math.modf(self.Content.anchoredPosition.y)
  self.unionScrollContent = self.unionScrollContent.transform
  local unionGridLayoutGroup = self.unionScrollContent:GetComponent("GridLayoutGroup")
  self.unionContentcellSize = unionGridLayoutGroup.cellSize
  self.unionContentOffset = unionGridLayoutGroup.padding.top + math.modf(self.unionScrollContent.anchoredPosition.y)
end

function Auction_AuctionUI:bg_goodsPanelOnEndDrag(id, msg)
  if self.leftTabType == AuctionTabType.appoint then
    return
  end
  local slideOffset = 50
  local startPos = self.auctionContentOffset - slideOffset
  local endPos = self.serverAuctionDataLength / 4 * self.auctionContentcellSize.y - self.auctionContentOffset
  if endPos < self.auctionContentOffset then
    endPos = self.auctionContentOffset
  end
  endPos = endPos + slideOffset
  local curPos = math.modf(self.Content.anchoredPosition.y)
  if endPos < curPos then
    self:LoadDown()
    self.loadType = true
    AuctionData.isSlider = true
  elseif startPos > curPos then
    self:LoadUp()
    self.loadType = false
  end
end

function Auction_AuctionUI:bg_goodsPanelOnEndDragTeam(id, msg)
  if self.leftTabType == AuctionTabType.appoint then
    return
  end
  local slideOffset = 50
  local startPos = self.unionContentOffset - slideOffset
  local endPos = self.serverUnionDataLength * self.unionContentcellSize.y - self.unionContentOffset
  if endPos < self.unionContentOffset then
    endPos = self.unionContentOffset
  end
  endPos = endPos + slideOffset
  local curPos = math.modf(self.unionScrollContent.anchoredPosition.y)
  if endPos < curPos then
    self:LoadDown()
    self.loadType = true
    AuctionData.isSlider = true
  elseif startPos > curPos then
    self:LoadUp()
    self.loadType = false
  end
end

function Auction_AuctionUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.Auction_ClosePanel)
  UIManager.Hide(UIID.Auction_AuctionUI)
end

function Auction_AuctionUI:SetIsUnionPanel(isUnion)
  self.AllAuctionPanel:SetActive(not isUnion)
  self.UnionAuctionPanel:SetActive(isUnion)
  self.btn_public:SetActive(not isUnion)
  self.btn_integral:SetActive(not isUnion)
  self:SetScrollMainContent()
  self:ResetDropDownCommpent(self.chooseSort, AuctionSortType.default, true, AuctionFilterType.SortType)
end

function Auction_AuctionUI:btn_tabitemOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.AuctionTab) then
    return
  end
  self.mainTabType = AuctionRecTimer.AuctionTab
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.System)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.strideDealType, AuctionData.toServerValue.defServerType)
  self.Content.localPosition = Vector3.zero
  self:SetIsUnionPanel(false)
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.AuctionTab
  if control.openSecondTabIndex and control.openSecondTabObj then
    self:OnLeftBtnsClick(control.openSecondTabIndex, control.openSecondTabObj)
    control.openSecondTabIndex = nil
    control.openSecondTabObj = nil
  else
    self:OnLeftBtnsClick(1, self.btn_all)
  end
  self:IsOnPanel(self.goodsPanel)
end

function Auction_AuctionUI:btn_server_2OnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.AuctionTab) then
    return
  end
  self.mainTabType = AuctionRecTimer.AuctionTab
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.System)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.strideDealType, control.strideDealType)
  self.Content.localPosition = Vector3.zero
  self:SetIsUnionPanel(false)
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.AuctionTab
  if control.openSecondTabIndex and control.openSecondTabObj then
    self:OnLeftBtnsClick(control.openSecondTabIndex, control.openSecondTabObj)
    control.openSecondTabIndex = nil
    control.openSecondTabObj = nil
  else
    self:OnLeftBtnsClick(1, self.btn_all)
  end
  self:IsOnPanel(self.goodsPanel)
end

function Auction_AuctionUI:btn_server_3OnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.AuctionTab) then
    return
  end
  self.mainTabType = AuctionRecTimer.AuctionTab
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.System)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.strideDealType, control.strideDealType)
  self.Content.localPosition = Vector3.zero
  self:SetIsUnionPanel(false)
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.AuctionTab
  if control.openSecondTabIndex and control.openSecondTabObj then
    self:OnLeftBtnsClick(control.openSecondTabIndex, control.openSecondTabObj)
    control.openSecondTabIndex = nil
    control.openSecondTabObj = nil
  else
    self:OnLeftBtnsClick(1, self.btn_all)
  end
  self:IsOnPanel(self.goodsPanel)
end

function Auction_AuctionUI:btn_server_4OnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.AuctionTab) then
    return
  end
  self.mainTabType = AuctionRecTimer.AuctionTab
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.System)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.strideDealType, control.strideDealType)
  self.Content.localPosition = Vector3.zero
  self:SetIsUnionPanel(false)
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.AuctionTab
  if control.openSecondTabIndex and control.openSecondTabObj then
    self:OnLeftBtnsClick(control.openSecondTabIndex, control.openSecondTabObj)
    control.openSecondTabIndex = nil
    control.openSecondTabObj = nil
  else
    self:OnLeftBtnsClick(1, self.btn_all)
  end
  self:IsOnPanel(self.goodsPanel)
end

function Auction_AuctionUI:btn_zhan_tabOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.Union) then
    return
  end
  self.mainTabType = AuctionRecTimer.Union
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.Union)
  self:RefreshUnionOrUnionCamp(control, AuctionRecTimer.Union)
end

function Auction_AuctionUI:btn_UnionCampOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.UnionCamp) then
    return
  end
  self.mainTabType = AuctionRecTimer.UnionCamp
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.CampUnion)
  self:RefreshUnionOrUnionCamp(control, AuctionRecTimer.UnionCamp)
end

function Auction_AuctionUI:RefreshUnionOrUnionCamp(control, _aucRecTimerEnum)
  self.unionScrollContent.localPosition = Vector3.zero
  self:SetIsUnionPanel(true)
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = _aucRecTimerEnum
  if control.openSecondTabIndex and control.openSecondTabObj then
    self:OnLeftBtnsClick(control.openSecondTabIndex, control.openSecondTabObj)
    control.openSecondTabIndex = nil
    control.openSecondTabObj = nil
  else
    self:OnLeftBtnsClick(1, self.btn_all)
  end
  self:IsOnPanel(self.goodsPanel)
end

function Auction_AuctionUI:btn_myboughtOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.History) then
    return
  end
  self.mainTabType = AuctionRecTimer.History
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.History
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.History)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_DefValue)
  AuctionController.SendReqLsTrade()
  AuctionData.MyBoughtTab = true
  self:IsOnPanel(self.myBoughtPanel)
end

function Auction_AuctionUI:btn_holyring_saleOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.MyPutOn) then
    return
  end
  self.mainTabType = AuctionRecTimer.MyPutOn
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.MyPutOn
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.PutOn)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_DefValue)
  AuctionController.SendReqLsTrade()
  self:IsOnPanel(self.salePanel, self.sw_RingBagItem)
  self:RefreshTagFour()
  self:RingBagChange()
  self.Button_SaleRackItem.gameObject:SetActive(false)
end

function Auction_AuctionUI:btn_holyskeleton_saleOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.MyPutOn) then
    return
  end
  self.mainTabType = AuctionRecTimer.MyPutOn
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.MyPutOn
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.PutOn)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_DefValue)
  AuctionController.SendReqLsTrade()
  self:IsOnPanel(self.salePanel, self.sw_SkeletonBagItem)
  self:RefreshTagFour()
  self:SkeletonBagChange()
  self.Button_SaleRackItem.gameObject:SetActive(false)
end

function Auction_AuctionUI:btn_saleOnClick(control)
  if self:CheckMainTabSendReq(AuctionRecTimer.MyPutOn) then
    return
  end
  self.mainTabType = AuctionRecTimer.MyPutOn
  self:SetButtonPitchOn(self.titleTab, control)
  self:DesToryRecTimer()
  self.CurrentTab = AuctionRecTimer.MyPutOn
  AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.PutOn)
  AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_DefValue)
  AuctionController.SendReqLsTrade()
  self:IsOnPanel(self.salePanel, self.Scroll_BagInfos)
  self:RefreshTagFour()
  self.Button_SaleRackItem.gameObject:SetActive(false)
end

function Auction_AuctionUI:btn_allOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.All) then
    return
  end
  self.leftMainTabType = AuctionTabType.All
  self:OnLeftBtnsClick(AuctionTabType.All, control)
end

function Auction_AuctionUI:btn_publicOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.Public) then
    return
  end
  self.leftMainTabType = AuctionTabType.Public
  self:OnLeftBtnsClick(AuctionTabType.Public, control)
end

function Auction_AuctionUI:btn_equipOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.Equip) then
    return
  end
  self.leftMainTabType = AuctionTabType.Equip
  self:OnLeftBtnsClick(AuctionTabType.Equip, control)
end

function Auction_AuctionUI:btn_suitEquipOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.SuitEquip) then
    return
  end
  self.leftMainTabType = AuctionTabType.SuitEquip
  self:OnLeftBtnsClick(AuctionTabType.SuitEquip, control)
end

function Auction_AuctionUI:btn_jewelryEquipOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.JewelryEquip) then
    return
  end
  self.leftMainTabType = AuctionTabType.JewelryEquip
  self:OnLeftBtnsClick(AuctionTabType.JewelryEquip, control)
end

function Auction_AuctionUI:btn_holySpiritOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.HolySpirit) then
    return
  end
  self.leftMainTabType = AuctionTabType.HolySpirit
  self:OnLeftBtnsClick(AuctionTabType.HolySpirit, control)
end

function Auction_AuctionUI:btn_holyringOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.HolyRing) then
    return
  end
  self.leftMainTabType = AuctionTabType.HolyRing
  self:OnLeftBtnsClick(AuctionTabType.HolyRing, control)
end

function Auction_AuctionUI:btn_holyskeletonOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.Reliquary) then
    return
  end
  self.leftMainTabType = AuctionTabType.Reliquary
  self:OnLeftBtnsClick(AuctionTabType.Reliquary, control)
end

function Auction_AuctionUI:btn_newrunesOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.Newrunes) then
    return
  end
  self.leftMainTabType = AuctionTabType.Newrunes
  self:OnLeftBtnsClick(AuctionTabType.Newrunes, control)
end

function Auction_AuctionUI:btn_skillBookOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.SkillBook) then
    return
  end
  self.leftMainTabType = AuctionTabType.SkillBook
  self:OnLeftBtnsClick(AuctionTabType.SkillBook, control)
end

function Auction_AuctionUI:btn_materialOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.Material) then
    return
  end
  self.leftMainTabType = AuctionTabType.Material
  self:OnLeftBtnsClick(AuctionTabType.Material, control)
end

function Auction_AuctionUI:btn_diamondOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.Currency) then
    return
  end
  self.leftMainTabType = AuctionTabType.Currency
  self:OnLeftBtnsClick(AuctionTabType.Currency, control)
end

function Auction_AuctionUI:btn_integralOnClick(control)
  if self:CheckLeftMainTabSendReq(AuctionTabType.appoint) then
    return
  end
  self.leftMainTabType = AuctionTabType.appoint
  self:OnLeftBtnsClick(AuctionTabType.appoint, control)
end

function Auction_AuctionUI.btn_cancelPanelConfirmOnClick(control)
  NetManager.Send(TradeMessage.ReqPutOff, {
    tid = control.tid,
    type = control.type
  })
  UIManager.Hide(UIID.ItemTipUI)
end

local centerHostId, hostId

function Auction_AuctionUI:btn_directBuyPanelBuyOnClick()
  local scaleNum = 0
  if self.OnePriceItem.item ~= nil then
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(self.OnePriceItem.item.itemId)
    if itemConfig.salenum == 0 then
      scaleNum = 1
    else
      scaleNum = itemConfig.salenum
    end
  end
  local price = tonumber(self.input_price:GetInputText())
  if price > BagInfoData.GetMeetPutOnItemCountByItemId(tonumber(self.OnePriceItem.pItemId)) and self.OnePriceItem.pItemId == 1000030 then
    UIManager.Hide(UIID.ItemTipUI)
    UIManager.Hide(UIID.PromptTipUI)
    RechargeData.BuyDiamond()
    return
  end
  if self.OnePriceItem.preBuyer ~= nil and 0 < #self.OnePriceItem.preBuyer and self:IsMeBuyer(self.OnePriceItem.preBuyer) then
    FloatingTipUtility.QuickMsg("B\225\186\161n \196\145\195\163 thanh to\195\161n r\225\187\147i")
    UIManager.Hide(UIID.ItemTipUI)
    return
  elseif price > BagInfoData.GetMeetPutOnItemCountByItemId(self.OnePriceItem.pItemId) then
    FloatingTipUtility.QuickMsg("Ti\225\187\129n kh\195\180ng \196\145\225\187\167")
    UIManager.Hide(UIID.ItemTipUI)
    return
  end
  NetManager.Send(TradeMessage.ReqStartBuy, {
    centerHostId = centerHostId,
    hostId = hostId,
    tid = self.OnePriceItem.tid,
    buyPrice = price,
    type = self.OnePriceItem.type,
    count = tonumber(self.lab_count:GetText())
  })
  UIManager.Hide(UIID.ItemTipUI)
end

function Auction_AuctionUI:IsMeBuyer(preBuyer)
  for i = 1, #preBuyer do
    if RoleManager.me.id == preBuyer[i].id then
      return true
    end
  end
  return false
end

function Auction_AuctionUI:Button_SaleRackItemOnClick(itemInfo)
  self.OutOfItem = itemInfo
  local ItemInfo = AuctionData.GetItemConfigInfo(itemInfo.item)
  self:openPutOnTipUI(ItemInfo, AuctionTipOpenType.putOff)
end

function Auction_AuctionUI:OpenVip(_index)
  local uiWord = ""
  if _index == 7 then
    uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Tqgezinew1")
  elseif 7 < _index and _index <= 9 then
    uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Tqgezinew2")
  elseif 9 < _index and _index <= 11 then
    uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Tqgezinew3")
  elseif 11 < _index and _index <= 15 then
    uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Tqgezinew4")
  elseif 15 < _index then
    uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Tqgezi3")
  end
  FloatingTipUtility.QuickMsg(uiWord)
end

function Auction_AuctionUI:PutOnTips(go)
  local prompTipArgs = {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = "H\195\163y cho v\225\186\173t ph\225\186\169m l\195\170n k\225\187\135",
    ok = function()
      UIManager.Hide(UIID.PromptTipUI)
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Auction_AuctionUI:btn_notarizesaleOnClick()
  local PutOnNum = table.count(AuctionData.AutoRackTable)
  local count = tonumber(self.lab_count:GetText())
  if count < self.MinNum then
    FloatingTipUtility.QuickMsg(string.format("SL l\195\170n k\225\187\135 \195\173t nh\225\186\165t l\195\160 %d", self.MinNum))
    return
  end
  if PutOnNum >= AuctionData.GetTotalPutOnNumber() then
    local str = LocalizationUtility.GetContentByKey("Auction_yiman")
    FloatingWordUtility.QuickBtnMsg({
      parent = self.PutOnBtn,
      msgStr = str
    })
    return
  end
  local isPut = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310010))
  if isPut == 0 and self.PutAwayData.intensify ~= nil and self.PutAwayData.additional ~= nil and (0 < self.PutAwayData.intensify or 0 < self.PutAwayData.additional) then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("AuctionTips_1"))
    UIManager.Hide(UIID.ItemTipUI)
    return
  end
  local ItemId
  if self.PutAwayData.id == 0 then
    ItemId = self.PutAwayData.itemId
  else
    ItemId = self.PutAwayData.id
  end
  NetManager.Send(TradeMessage.ReqPutOn, {
    uniqueId = ItemId,
    count = count,
    lowPrice = tonumber(self.input_price:GetInputText()) or 1,
    highPrice = tonumber(self.input_price:GetInputText()) or 1,
    type = 0
  })
  self.PutAwayCount = 1
  UIManager.Hide(UIID.ItemTipUI)
end

function Auction_AuctionUI:OnLeftBtnsClick(index, control)
  AuctionData.page = 1
  self:SetButtonPitchOn(self.leftTitleTab, control)
  self:ShowScrollView(index)
  if index == AuctionTabType.Equip then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.EquipTabLis)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_equip, index)
  elseif index == AuctionTabType.SuitEquip then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.SuitEquipTabLis)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_suitEquip, index)
  elseif index == AuctionTabType.JewelryEquip then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.JewelryEquipTabLis)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_jewelryEquip, index)
  elseif index == AuctionTabType.Material then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.MaterialTabList)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_material, index)
  elseif index == AuctionTabType.Currency then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.CurrencyTabList)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_diamond, index)
  elseif index == AuctionTabType.HolyRing then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.HolyRingTabList)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_holyring, index)
  elseif index == AuctionTabType.Reliquary then
    local subContentDeltaY = self:GetSubContentDeltaY(AuctionData.ReliquaryTabList)
    self:SetScrollSubContent(subContentDeltaY, self.subContent_holyskeleton, index)
  else
    self:SetScrollMainContent()
  end
end

function Auction_AuctionUI:ShowScrollView(index)
  self.leftTabType = index
  self:ResetDropDownValue()
  if index == AuctionTabType.appoint then
    self:TabOnClick(AuctionTabType.appoint)
  else
    self:TabOnClick(index, 0)
  end
end

function Auction_AuctionUI:ResetDropDownValue()
  self:ResetDropDownEquipGrade(true)
  self:ResetDropDownCommpent(self.chooseUser, AuctionJobType.default, true, AuctionFilterType.CareerType)
  local isShowChooseUserState = self.leftTabType ~= AuctionTabType.Currency and self.leftTabType ~= AuctionTabType.appoint and self.leftTabType ~= AuctionTabType.Material and self.leftTabType ~= AuctionTabType.JewelryEquip and self.leftTabType ~= AuctionTabType.HolySpirit and self.leftTabType ~= AuctionTabType.Reliquary and self.leftTabType ~= AuctionTabType.HolyRing and self.leftTabType ~= AuctionTabType.Newrunes
  self.chooseUser:SetActive(isShowChooseUserState)
  self:ResetDropDownCommpent(self.chooseSort, AuctionSortType.default, true, AuctionFilterType.SortType)
  local isChooseSortState = self.leftTabType ~= AuctionTabType.appoint
  self.chooseSort:SetActive(isChooseSortState)
  self:ResetDropDownCommpent(self.chooseRoleLevel, AuctionRoleLevelType.default, true, AuctionFilterType.RoleLevel)
  local isChooseSuitEquip = self.leftTabType == AuctionTabType.SuitEquip or self.leftTabType == AuctionTabType.JewelryEquip
  self.chooseRoleLevel:SetActive(isChooseSuitEquip)
  self:ResetDropDownCommpent(self.chooseHolySpiritGrade, AuctionHolySpiritGradeType.default, true, AuctionFilterType.HolySpiritGradeType)
  local isShowChooseHolySpiritGradeState = self.leftTabType == AuctionTabType.HolySpirit
  self.chooseHolySpiritGrade:SetActive(isShowChooseHolySpiritGradeState)
end

function Auction_AuctionUI:ResetDropDownEquipGrade(isByDefalutGradeLv)
  if isByDefalutGradeLv == true then
    local defaultEquipGradeType = AuctionData.equipGradeTypeDP
    if self.leftTabType == AuctionTabType.Equip then
      self:ResetDropDownCommpent(self.chooseEquipGrade, defaultEquipGradeType, true, AuctionFilterType.EquipGradeType)
      self.chooseEquipGrade:SetActive(true)
    else
      self:ResetDropDownCommpent(self.chooseEquipGrade, AuctionEquipClassType.default, true, AuctionFilterType.EquipGradeType)
      self.chooseEquipGrade:SetActive(false)
    end
  else
    self:ResetDropDownCommpent(self.chooseEquipGrade, AuctionEquipClassType.default, true, AuctionFilterType.EquipGradeType)
    self.chooseEquipGrade:SetActive(false)
  end
end

local function OnSaleRackItemCreate(control)
  control.btn_3DItem = UIControl(control.transform, "itemPanel/btn_3DItem")
  control.lab_name = UIControl(control.transform, "itemPanel/lab_name")
  control.lab_time = UIControl(control.transform, "itemPanel/lab_value")
  control.timeType = UIControl(control.transform, "itemPanel/lab_time")
  control.lab_value = UIControl(control.transform, "itemPanel/price/lab_value")
  control.itemPanel = UIControl(control.transform, "itemPanel")
  control.buyNumBG = UIControl(control.transform, "itemPanel/buyNum")
  control.img_buy = UIControl(control.transform, "itemPanel/buyNum/img_buy")
  control.buyNum = UIControl(control.transform, "itemPanel/buyNum/lab_buyNum")
  control.openBg = UIControl(control.transform, "openBg")
  control.vipBg = UIControl(control.transform, "vipBg")
  control.img_vip = UIControl(control.transform, "vipBg/img_vip")
  control.img_vipOpen = UIControl(control.transform, "vipBg/img_vipOpen")
  control.img_vvipOpen = UIControl(control.transform, "vipBg/img_vvipOpen")
  control.img_not_open = UIControl(control.transform, "vipBg/img_not_open")
  control.img_icon = UIControl(control.transform, "itemPanel/price/img_icon")
  control.MyName = UIControl(control.transform, "itemPanel/MyName")
  control.img_icon_diamond = UIControl(control.transform, "itemPanel/price/img_icon_diamond")
  control.buyType = AuctionTipOpenType.appoint
end

local function OnGoodsItemCreate(control)
  control.btn_3DItem = UIControl(control.transform, "btn_3DItem")
  control.lab_name = UIControl(control.transform, "lab_name")
  control.price_value = UIControl(control.transform, "price/lab_value")
  control.lab_time = UIControl(control.transform, "lab_value")
  control.timeType = UIControl(control.transform, "lab_time")
  control.buyNumBG = UIControl(control.transform, "buyNum")
  control.img_buy = UIControl(control.transform, "buyNum/img_buy")
  control.buyNum = UIControl(control.transform, "buyNum/lab_buyNum")
  control.img_icon = UIControl(control.transform, "price/img_icon")
  control.isMeBg = UIControl(control.transform, "isMeBg")
  control.MyName = UIControl(control.transform, "MyName")
  control.MyNameAutoScrollText = control.MyName.transform:GetComponent("AutoScrollText")
  control.buyType = AuctionTipOpenType.appoint
end

local function OnUnionItemCreate(control)
  control.btn_3DItem = UIControl(control.transform, "btn_3DItem")
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_time = UIControl(control.transform, "lab_value")
  control.price_value = UIControl(control.transform, "price/lab_value")
  control.img_icon = UIControl(control.transform, "price/img_icon")
  control.btn_price = UIControl(control.transform, "price/btn_price")
  control.img_oneIcon = UIControl(control.transform, "onePrice/img_oneIcon")
  control.lab_oneValue = UIControl(control.transform, "onePrice/lab_oneValue")
  control.btn_onePrice = UIControl(control.transform, "onePrice/btn_onePrice")
  control.lab_inAuction = UIControl(control.transform, "price/lab_inAuction")
  control.lab_myAuction = UIControl(control.transform, "price/lab_myAuction")
end

local function OnMyBoughtItemCreate(control)
  control.Bg = UIControl(control.transform, "img_frame")
  control.lab_name = UIControl(control.transform, "lab_name")
  control.lab_time = UIControl(control.transform, "lab_time")
  control.lab_state = UIControl(control.transform, "lab_state")
  control.lab_price = UIControl(control.transform, "price/lab_value")
  control.img_priceIcon = UIControl(control.transform, "price/img_icon")
  control.buyType = AuctionTipOpenType.appoint
end

local function CoinOnCreate(ctr)
  ctr.coinCtr = UIControl(ctr.transform, "btn_money")
  ctr.getCtr = UIControl(ctr.transform, "btn_get")
  ctr.countCtr = UIControl(ctr.transform, "btn_money/img_icon/num")
end

local function CoinsOnRefresh(ctr, _, configId, ui)
  local coinData = ItemUtility.GenerateItemData(configId)
  local count = BagInfoData.GetMeetPutOnItemCountByItemId(configId)
  coinData.count = count
  ItemUtility.ShowItem(ui, ctr.coinCtr, coinData, true)
  if count == 1 and (configId == ECoinsType.gem or configId == ECoinsType.integral) then
    ctr.countCtr:SetText(count)
  end
  ctr.getCtr.itemData = coinData
  ctr.getCtr:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Auction_AuctionUI:InitContent()
  self.meData = ViewData.meData
  self.Button_SaleRackItemTemp = UIContainer(self.Button_SaleRackItem, self, OnSaleRackItemCreate)
  self.Button_goodsItemTemp = UIContainer(self.Button_goodsItem, self, OnGoodsItemCreate)
  self.Button_UnionItemTemp = UIContainer(self.Button_UnionItem, self, OnUnionItemCreate)
  self.coinContainer = UIContainer(self.go_money, self, CoinOnCreate, CoinsOnRefresh)
  for i = 1, #AuctionData.LeftTagTabList do
    self.IsOneInit[i] = true
  end
  self.leftTitleTab = {
    self.btn_all,
    self.btn_public,
    self.btn_equip,
    self.btn_suitEquip,
    self.btn_jewelryEquip,
    self.btn_holySpirit,
    self.btn_skillBook,
    self.btn_material,
    self.btn_diamond,
    self.btn_integral,
    self.btn_holyring,
    self.btn_holyskeleton,
    self.btn_newrunes
  }
  self.titleTab = {
    self.btn_mybought,
    self.btn_sale,
    self.btn_tabitem,
    self.btn_zhan_tab,
    self.btn_UnionCamp,
    self.btn_server_2,
    self.btn_server_3,
    self.btn_server_4,
    self.btn_holyring_sale,
    self.btn_holyskeleton_sale
  }
  self.leftTitleSubContentTab = {
    self.subContent_equip,
    self.subContent_suitEquip,
    self.subContent_jewelryEquip,
    self.subContent_material,
    self.subContent_diamond,
    self.subContent_holyring,
    self.subContent_holyskeleton
  }
  self.dragTbl = UIDragCellContainer(self, nil, self.Button_ShowUseOperation, {
    curCellCount = BagInfoData.curBagCellCount,
    totalCellCount = BagInfoData.bagCellCount,
    colCount = 8
  })
  self.serverGroupBtn = {
    [1] = self.btn_server_2,
    [2] = self.btn_server_3,
    [3] = self.btn_server_4
  }
end

function Auction_AuctionUI:Button_ShowUseOperation(control)
  if control.data.itemData == nil then
    return
  end
  local itemCellData = control.data:GetData()
  local itemData = itemCellData.itemData
  self:openPutOnTipUI(itemData, AuctionTipOpenType.putOn)
end

function Auction_AuctionUI:PanelShow()
  EventManager.Dispatch(Event.Auction_OpenPanel)
  AuctionData.page = 1
  if self.Content then
    self.Content.localPosition = Vector3.zero
  end
  self.leftTabType = AuctionTabType.All
  self.CurrentTab = AuctionRecTimer.AuctionTab
  self:SetButtonPitchOn(self.titleTab, self.btn_tabitem)
  self:SetButtonPitchOn(self.leftTitleTab, self.btn_all)
  self:IsOnPanel(self.goodsPanel)
  self:SetIsUnionPanel(false)
  self:ResetDropDownValue()
  self:InitTab()
  self:RefreshCoin()
end

function Auction_AuctionUI:InitBagData(msg)
  if msg then
    if msg.removeItems then
      for _, itemData in ipairs(msg.removeItems) do
        self.dragTbl:RemoveData(itemData)
      end
    end
    if msg.showItems then
      for _, itemInfo in pairs(msg.showItems) do
        local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(itemInfo.id)
        local isMeetCondition = AuctionController.CheckMeetPutOnCondition(equipTab, itemInfo.bind, itemInfo.intensify, itemInfo.additional, false)
        if itemInfo.minAuctionPrice ~= "" and isMeetCondition then
          self.dragTbl:AddItemInfo(itemInfo, true)
        end
      end
    end
    if table.count(msg.removeItems) > 0 or table.count(msg.showItems) > 0 then
      return
    end
  end
  self.dragTbl:SetParam(nil, self.Button_ShowUseOperation, true, true)
  local PublicityTimeNum = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2310011)
  local itemTab = table.clone(BagInfoData.TotalItems)
  local bagData = {}
  for k, v in pairs(itemTab) do
    local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(v.tblItem.id)
    local isMeetCondition = AuctionController.CheckMeetPutOnCondition(equipTab, v.bind, v.intensify, v.additional, false)
    if v.tblItem.minAuctionPrice ~= "" and isMeetCondition then
      table.insert(bagData, v)
    end
  end
  for k, v in pairs(string.split(PublicityTimeNum, "#")) do
    local item = ItemUtility.GenerateItemData(tonumber(v))
    item.count = BagInfoData.GetMeetPutOnItemCountByItemId(item.itemId)
    if item.count > 0 then
      table.insert(bagData, 1, item)
    end
  end
  self.dragTbl:SetData(bagData, "Auction_AuctionUI:InitBagData")
end

function Auction_AuctionUI:RingBagChange()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData() then
    local HolyRingBag = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData()
    if HolyRingBag then
      local c_HonlyRingBag = table.clone(HolyRingBag)
      for i, v in ipairs(c_HonlyRingBag) do
        local TransitionItem = ItemUtility.GenerateItemData(v.ItemId)
        v.bind = v.ItemInfo.bind
        v.intensify = v.ItemInfo.intensify
        v.count = v.Count
        v.id = v.ItemInfo.id
        v.itemId = v.ItemId
        v.tblItem = TransitionItem.tblItem
        v.tblEquip = TransitionItem.tblEquip
        v.serverInfo = v.ItemInfo
        if v.tblEquip and v.tblItem and v.tblItem.type == 6 and v.tblItem.subType == 620 then
          v.wingAttr = v.ItemInfo.wingAttr
        end
        
        function v.OnClick()
          self:HolyRingItemOnClick(v)
        end
        
        function v.AuctionUIHolyRingItemClick()
          self:openPutOnTipUI(v, AuctionTipOpenType.putOn)
        end
      end
      self.EquipRuneTemplate:SetData(c_HonlyRingBag)
    end
  end
end

function Auction_AuctionUI:HolyRingItemOnClick(data)
  for i, v in pairs(self.EquipRuneTemplate.items) do
    if v.itemTemp and v.itemTemp.data.ItemInfo then
      v.itemTemp:RefreshSrecct(v.itemTemp.data.ItemInfo.id == data.ItemInfo.id)
    end
  end
end

function Auction_AuctionUI:SkeletonBagItemOnClick(data)
  for i, v in pairs(self.holySkeletonBagUITemplates.items) do
    if v.itemTemp and v.itemTemp.data.ItemInfo then
      v.itemTemp:SetSelect(v.itemTemp.data.ItemInfo.id == data.ItemInfo.id)
    end
  end
end

function Auction_AuctionUI:SkeletonBagChange()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr() and gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData then
    local ReliquaryBag = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData
    if ReliquaryBag then
      local c_ReliquaryBag = table.clone(ReliquaryBag)
      for i, v in ipairs(c_ReliquaryBag) do
        local TransitionItem = ItemUtility.GenerateItemData(v.ItemId)
        v.bind = v.ItemInfo.bind
        v.intensify = v.ItemInfo.intensify
        v.count = v.ItemCount
        v.id = v.ItemInfo.id
        v.itemId = v.ItemId
        v.tblItem = TransitionItem.tblItem
        v.tblEquip = TransitionItem.tblEquip
        v.serverInfo = v.ItemInfo
        if v.tblEquip and v.tblItem and v.tblItem.type == 6 and v.tblItem.subType == 620 then
          v.wingAttr = v.ItemInfo.wingAttr
        end
        v.Auction_AuctionUI = true
        
        function v.AuctionUIItemOnClick()
          self:SkeletonBagItemOnClick(v)
        end
        
        function v.AuctionUISkeletonItemClick()
          self:openPutOnTipUI(v, AuctionTipOpenType.putOn)
        end
      end
      self.holySkeletonBagUITemplates:SetData(c_ReliquaryBag)
    end
  end
end

function Auction_AuctionUI:ClearAuctionRingReliquaryData()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr() and gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData then
    local ReliquaryBag = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData
    for i, v in pairs(ReliquaryBag) do
      v.AuctionUIItemOnClick = nil
      v.Auction_AuctionUI = false
      v.AuctionUISkeletonItemClick = nil
    end
  end
  if gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData() then
    local HolyRingBag = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData()
    for i, v in pairs(HolyRingBag) do
      v.OnClick = nil
      v.AuctionUIHolyRingItemClick = nil
    end
  end
end

function Auction_AuctionUI:AddOtherBagData(bagData)
  if gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr() and gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData() then
    local HolyRingBag = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData()
    if HolyRingBag and table.count(HolyRingBag) > 0 then
      for i, v in pairs(HolyRingBag) do
        local HolyRingBagClone = {}
        local TransitionItem = ItemUtility.GenerateItemData(v.ItemId)
        HolyRingBagClone.bind = v.ItemInfo.bind
        HolyRingBagClone.intensify = v.ItemInfo.intensify
        HolyRingBagClone.count = v.Count
        HolyRingBagClone.id = v.ItemInfo.id
        HolyRingBagClone.itemId = v.ItemId
        HolyRingBagClone.tblItem = TransitionItem.tblItem
        HolyRingBagClone.tblEquip = TransitionItem.tblEquip
        HolyRingBagClone.serverInfo = v.ItemInfo
        if HolyRingBagClone.tblEquip and HolyRingBagClone.tblItem and HolyRingBagClone.tblItem.type == 6 and HolyRingBagClone.tblItem.subType == 620 then
          HolyRingBagClone.wingAttr = v.ItemInfo.wingAttr
        end
        local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(HolyRingBagClone.tblItem.id)
        local isMeetCondition = AuctionController.CheckMeetPutOnCondition(equipTab, HolyRingBagClone.bind, HolyRingBagClone.intensify, HolyRingBagClone.additional, false)
        if HolyRingBagClone.tblItem.minAuctionPrice ~= "" and isMeetCondition then
          table.insert(bagData, HolyRingBagClone)
        end
      end
    end
  end
  if gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr() and gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData then
    local ReliquaryBag = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData
    if ReliquaryBag and table.count(ReliquaryBag) > 0 then
      for i, v in pairs(ReliquaryBag) do
        local ReliquaryBagClone = {}
        local TransitionItem = ItemUtility.GenerateItemData(v.ItemId)
        ReliquaryBagClone.bind = v.ItemInfo.bind
        ReliquaryBagClone.intensify = v.ItemInfo.intensify
        ReliquaryBagClone.count = v.ItemCount
        ReliquaryBagClone.id = v.ItemInfo.id
        ReliquaryBagClone.itemId = v.ItemId
        ReliquaryBagClone.tblItem = TransitionItem.tblItem
        ReliquaryBagClone.tblEquip = TransitionItem.tblEquip
        ReliquaryBagClone.serverInfo = v.ItemInfo
        if ReliquaryBagClone.tblEquip and ReliquaryBagClone.tblItem and ReliquaryBagClone.tblItem.type == 6 and ReliquaryBagClone.tblItem.subType == 620 then
          ReliquaryBagClone.wingAttr = v.ItemInfo.wingAttr
        end
        local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(ReliquaryBagClone.tblItem.id)
        local isMeetCondition = AuctionController.CheckMeetPutOnCondition(equipTab, ReliquaryBagClone.bind, ReliquaryBagClone.intensify, ReliquaryBagClone.additional, false)
        if ReliquaryBagClone.tblItem.minAuctionPrice ~= "" and isMeetCondition then
          table.insert(bagData, ReliquaryBagClone)
        end
      end
    end
  end
end

function Auction_AuctionUI:InitArgs()
  if self.args then
    self:SetArgsPutOn()
  else
    self:btn_allOnClick(self.btn_all)
  end
end

function Auction_AuctionUI:InitDataOnShow()
  self.excellFactorConfig = {}
  self:SetExcellConfigByGlobal(1170008, {
    2,
    3,
    5,
    7
  })
  self:SetExcellConfigByGlobal(1170009, {20})
  self:SetExcellConfigByGlobal(1170010, {0})
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

function Auction_AuctionUI:RefreshStrideServerBtn()
  if self.isOpenService then
    for i, v in pairs(self.serverGroupBtn) do
      v:SetActive(false)
      v.strideDealType = 0
    end
    local serverGroupData = AuctionData.GetServerGroupData()
    local LoginServerGroup = LoginData.serverList
    local serverInfo = {}
    if LoginServerGroup then
      serverInfo = LoginServerGroup
    end
    if serverGroupData then
      for key, value in pairsByKeys(serverGroupData) do
        if self.serverGroupBtn[key] then
          self.serverGroupBtn[key]:SetActive(true)
          self.serverGroupBtn[key]:GetChild("Text"):SetText(string.format("%sS\195\160n Giao D\225\187\139ch SV", self:SetServerBtnName(value, serverInfo)))
          self.serverGroupBtn[key].strideDealType = value
        end
      end
    end
  end
end

function Auction_AuctionUI:SetServerBtnName(value, serverInfo)
  if table.count(serverInfo) > 0 then
    for i, v in pairs(serverInfo) do
      if value == v[5] then
        return v[1]
      end
    end
  end
  return tostring(value)
end

function Auction_AuctionUI:CheackOpenService()
  self.isOpenService = false
  local openCondition = ClientTable.cfg_Function_functionManager:TryGetValue(AuctionBtnType.StrideServeBtn_2).condition
  if ConditionManager.Check4D(openCondition) then
    self.isOpenService = true
  end
end

function Auction_AuctionUI:SetExcellConfigByGlobal(globalId, types)
  local global_Group = ClientTable.cfg_Global_globalManager:TryGetValue(globalId)
  if global_Group == nil then
    return
  end
  local infoArray = string.split(global_Group.effect, "&")
  local infos = {}
  for i = 1, #infoArray do
    local tab = {}
    local infoStr = string.split(infoArray[i], "#")
    if #infoStr == 2 then
      tab.num = tonumber(infoStr[1])
      tab.factor = tonumber(infoStr[2])
      table.insert(infos, tab)
    end
  end
  for key, value in pairs(types) do
    self.excellFactorConfig[value] = infos
  end
end

function Auction_AuctionUI:InitAllTabValue()
  self.mainTabType = AuctionRecTimer.None
  self.leftMainTabType = AuctionTabType.None
  self.leftSubTabType = AuctionLeftSubTabType.None
end

function Auction_AuctionUI:input_priceOnChanged(_, priceNum)
  local price = self.PutAwayData.tblItem.minAuctionPrice
  local pri = string.split(price, "#")
  local minPrice = tonumber(pri[1])
  local maxPrice = tonumber(pri[2])
  local input_price = minPrice
  if not string.isNullOrEmpty(self.input_price:GetInputText()) then
    input_price = tonumber(self.input_price:GetInputText())
  end
  if input_price == nil or minPrice >= input_price then
    input_price = minPrice
    self.input_price:SetInputText(minPrice)
    self.InputAllPrice:SetInputText(minPrice * self:SwitchPrice(self.PutAwayCount, self.PutAwayData.itemId))
  elseif input_price == nil or maxPrice <= input_price then
    input_price = maxPrice
    self.input_price:SetInputText(maxPrice)
    self.InputAllPrice:SetInputText(maxPrice * self:SwitchPrice(self.PutAwayCount, self.PutAwayData.itemId))
  else
    self.input_price:SetInputText(tonumber(priceNum))
    self.InputAllPrice:SetInputText(math.modf(tonumber(priceNum) * self:SwitchPrice(self.PutAwayCount, self.PutAwayData.itemId)))
  end
  local sliderPrice = (input_price - minPrice) / (maxPrice - minPrice)
  self.change_price.slider.value = Mathf.Clamp(sliderPrice, 0, 1)
end

function Auction_AuctionUI:UpdatePriceValueChange(_, sliderValue)
  local price = self.PutAwayData.tblItem.minAuctionPrice
  local pri = string.split(price, "#")
  local minPrice = tonumber(pri[1])
  local maxPrice = tonumber(pri[2])
  local sliderPrice = math.floor(sliderValue * (maxPrice - minPrice)) + minPrice
  sliderPrice = Mathf.Clamp(sliderPrice, minPrice, maxPrice)
  self.input_price:SetInputText(sliderPrice)
  self.InputAllPrice:SetInputText(sliderPrice * self:SwitchPrice(self.PutAwayCount))
end

function Auction_AuctionUI:Button_btn_bidding(control)
  if AuctionData.RoleID == control.itemInfo.sellerId then
    TipUtility.ShowPrompt("tishi", "AuctionTips_4")
    return
  end
end

function Auction_AuctionUI:Button_btn_buy(control)
  if AuctionData.RoleID == control.itemInfo.sellerId then
    TipUtility.ShowPrompt("tishi", "AuctionTips_4")
    return
  end
  self.OnePriceItem = control.itemInfo
  local itemInfo = AuctionData.GetItemConfigInfo(self.OnePriceItem.item)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemInfo,
    ctrl = control,
    rightOperate = EItemOperateType.Show,
    openType = TipsOpenType.AuctionOpen,
    buyType = control.buyType,
    contrast = true,
    isAuction = true
  })
end

function Auction_AuctionUI:InitTab(id, msg)
  self.btn_tabitem:SetActive(true)
  if RedPointChecker_Ext.isHaveUnionAuctionData and AuctionData.CheackUnion() then
    self.btn_zhan_tab:SetActive(true)
  else
    self.btn_zhan_tab:SetActive(false)
  end
  if RedPointChecker_Ext.isHaveUnionCampAuctionData and AuctionData.CheackUnionCamp() then
    self.btn_UnionCamp:SetActive(true)
  else
    self.btn_UnionCamp:SetActive(false)
  end
  self:InitLeftSubTag(self.subContent_equip, AuctionData.EquipTabLis, AuctionTabType.Equip)
  self:InitLeftSubTag(self.subContent_suitEquip, AuctionData.SuitEquipTabLis, AuctionTabType.SuitEquip)
  self:InitLeftSubTag(self.subContent_jewelryEquip, AuctionData.JewelryEquipTabLis, AuctionTabType.JewelryEquip)
  self:InitLeftSubTag(self.subContent_material, AuctionData.MaterialTabList, AuctionTabType.Material)
  self:InitLeftSubTag(self.subContent_diamond, AuctionData.CurrencyTabList, AuctionTabType.Currency)
  self:InitLeftSubTag(self.subContent_holyring, AuctionData.HolyRingTabList, AuctionTabType.HolyRing)
  self:InitLeftSubTag(self.subContent_holyskeleton, AuctionData.ReliquaryTabList, AuctionTabType.Reliquary)
end

function Auction_AuctionUI:InitLeftSubTag(subContent, auctionDataList, auctionTabType)
  local subContainer = subContent.transform:GetComponent("UIScrollContainer")
  subContainer.MaxCount = #auctionDataList
  if subContainer and self.IsOneInit[auctionTabType] then
    for i = 1, #auctionDataList do
      local go = subContainer:GetScrollGoByIndex(i - 1)
      local objControl = UIControl(go.transform)
      local data = auctionDataList[i]
      local nameLabel = UIControl(objControl.transform, "num")
      nameLabel:SetText(data)
      table.insert(self.leftTitleSubTab, objControl)
      objControl:SetOnClick(self, function()
        if not self:CheckLeftSubTabSendReq(i) then
          self:TabOnClick(auctionTabType, i, objControl)
          self.leftSubTabType = i
        end
      end)
    end
    self.IsOneInit[auctionTabType] = false
  end
end

function Auction_AuctionUI:Auction_SetPanel(_, msg)
  self.buyType = msg.type
  self.lab_count = msg.lab_count
  self.input_price = msg.AuctionInputPrice
  self.inputText_price = msg.AuctionInputTextPrice
  self.btn_add = msg.btn_add
  self.btn_minus = msg.btn_minus
  self.PutAwayData = msg.itemInfo
  self.MaxCount = msg.itemInfo.count
  self.PutOnBtn = msg.AuctionBtn
  self.putOnTips = msg.putOnTips
  self.lab_putOnPrice = msg.lab_putOnPrice
  self.InputAllPrice = msg.InputAllPrice
  self.change_price = msg.change_price
  self.itemId = msg.itemInfo.itemId
  self.input_price:SetInputText(1)
  self.input_price:SetInteractable(true)
  if msg.itemInfo.tblItem.salenum == 0 then
    self.MinNum = 1
  else
    self.MinNum = msg.itemInfo.tblItem.salenum
  end
  self.lab_count.transform:GetComponent("Text").color = Color.white
  self.lab_count:SetText(self.MinNum)
  self.btn_add:SetActive(false)
  self.btn_minus:SetActive(false)
  if msg.itemInfo.count <= 1 then
    msg.count:SetActive(false)
    msg.price.transform.localPosition = Vector3(17, 40, 0)
  else
    msg.count:SetActive(true)
    msg.price.transform.localPosition = Vector3(17, 15, 0)
  end
  if self.buyType == AuctionTipOpenType.putOn then
    if msg.itemInfo.count <= 1 then
      msg.priceTitle:SetText("Gi\195\161 b\195\161n")
      msg.bg_buy:SetSizeDelta(230, 180)
      msg.bg_buy:SetAnchoredPosition(0, -97)
      msg.change_price.transform.localPosition = Vector3(0, -15, 0)
      msg.AuctionBtn.transform.localPosition = Vector3(0, 65, 0)
    else
      msg.priceTitle:SetText("\196\144\198\161n gi\195\161")
      msg.bg_buy:SetSizeDelta(230, 240)
      msg.bg_buy:SetAnchoredPosition(0, -123)
      msg.change_price.transform.localPosition = Vector3(0, -77, 0)
      msg.AuctionBtn.transform.localPosition = Vector3(0, 11, 0)
    end
    msg.change_price:SetActive(true)
    self.putOnTips:SetActive(false)
    local price = msg.itemInfo.tblItem.minAuctionPrice
    if price == "" then
      FloatingTipUtility.QuickMsg("V\225\186\173t ph\225\186\169m kh\195\180ng th\225\187\131 cho l\195\170n k\225\187\135")
      UIManager.Hide(UIID.ItemTipUI)
      return
    end
    self.PutOnItem = msg.itemInfo
    local pri = string.split(price, "#")
    local minPrice = tonumber(pri[1])
    local maxPrice = tonumber(pri[2])
    self.PutAwayCount = self.MinNum
    self.lab_putOnPrice:SetText(string.format("%d~%d", minPrice, maxPrice))
    msg.change_price.slider.minValue = 0
    msg.change_price.slider.maxValue = 1
    msg.change_price.slider.value = 0
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_ground"))
    self:ResetInputTextColor(self.inputText_price)
    self.input_price:SetInputText(minPrice)
    self.input_price:SetInteractable(true)
    NetManager.Send(TradeMessage.ReqLookItemAveragePrice, {
      itemId = msg.itemInfo.itemId
    })
    self.btn_add:SetActive(msg.itemInfo.count > self.MinNum)
    self.btn_add:SetInteractable(msg.itemInfo.count > self.MinNum)
    self.btn_minus:SetActive(msg.itemInfo.count > self.MinNum)
    msg.allPrice:SetActive(msg.itemInfo.count > 1)
    local haveCount = BagInfoData.GetMeetPutOnItemCountByItemId(self.PutAwayData.itemId)
    if haveCount < self.MinNum then
      self.lab_count:SetText(haveCount)
      self.lab_count.transform:GetComponent("Text").color = Color.red
      local integerPart, floatPart = math.modf(haveCount / self.MinNum)
      self.InputAllPrice:SetInputText(math.floor(minPrice * floatPart))
      self.btn_add:SetActive(false)
    else
      local afterPrice = self:SwitchPrice(minPrice * self.MinNum, self.PutAwayData.itemId)
      self.InputAllPrice:SetInputText(afterPrice)
      self.btn_add:SetActive(true)
    end
  elseif self.buyType == AuctionTipOpenType.appoint then
    msg.priceTitle:SetText("Gi\195\161")
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_subscribe"))
    local needCount = tonumber(self.OnePriceItem.highPrice) * self:SwitchPrice(self.MaxCount, msg.itemInfo.itemId)
    self:SetInputTextColor(self.inputText_price, self.OnePriceItem.pItemId, needCount)
    self.input_price:SetInputText(needCount)
    self.lab_count:SetText(msg.itemInfo.count)
    self.input_price:SetInteractable(false)
  elseif self.buyType == AuctionTipOpenType.putOff then
    msg.priceTitle:SetText("\196\144\198\161n gi\195\161")
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_unground"))
    self.input_price:SetInputText(tonumber(self.OutOfItem.highPrice))
    self.input_price:SetInteractable(false)
    self.lab_count:SetText(msg.itemInfo.count)
  elseif self.buyType == AuctionTipOpenType.unionBuy then
    msg.priceTitle:SetText("Gi\195\161")
    msg.AuctionText:SetText("\196\144\225\186\165u Gi\195\161")
    self.lab_count:SetText(msg.itemInfo.count)
    local needCount = tonumber(self.OnePriceItem.lowPrice) * self:SwitchPrice(self.MaxCount, msg.itemInfo.itemId)
    self:SetInputTextColor(self.inputText_price, self.OnePriceItem.pItemId, needCount)
    self.input_price:SetInputText(needCount)
    self.input_price:SetInteractable(false)
  elseif self.buyType == AuctionTipOpenType.unionOneBuy then
    msg.priceTitle:SetText("Gi\195\161")
    self.lab_count:SetText(msg.itemInfo.count)
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_buy"))
    local needCount = tonumber(self.OnePriceItem.highPrice) * self:SwitchPrice(self.MaxCount, msg.itemInfo.itemId)
    self:SetInputTextColor(self.inputText_price, self.OnePriceItem.pItemId, needCount)
    self.input_price:SetInputText(needCount)
    self.input_price:SetInteractable(false)
  else
    msg.priceTitle:SetText("Gi\195\161")
    msg.AuctionText:SetText(LocalizationUtility.GetContentByKey("Auction_buy"))
    local needCount = tonumber(self.OnePriceItem.highPrice) * self:SwitchPrice(self.MaxCount, msg.itemInfo.itemId)
    self:SetInputTextColor(self.inputText_price, self.OnePriceItem.pItemId, needCount)
    self.input_price:SetInputText(needCount)
    self.input_price:SetInteractable(false)
    self.lab_count:SetText(msg.itemInfo.count)
  end
  local itemMoney = ClientTable.cfg_Item_itemManager:TryGetValue(msg.itemInfo.itemId, "id").auction
  if itemMoney ~= "" then
    local iconId = string.split(string.split(itemMoney, "&")[1], "#")[2]
    local moneyData = ItemUtility.GenerateItemData(tonumber(iconId) or 1000020)
    msg.img_icon.moneyModel:RefreshData(moneyData)
    ItemUtility.ShowItemCell(msg.img_icon, msg.img_icon.moneyModel, nil, false)
    msg.allImg_icon.moneyModel:RefreshData(moneyData)
    ItemUtility.ShowItemCell(msg.allImg_icon, msg.allImg_icon.moneyModel, nil, false)
  end
  msg.AuctionBtn:SetOnClick(self, self.AuctionBtnOnClick)
  msg.btn_add:SetOnClick(self, self.btn_addOnClick)
  msg.btn_add:SetOnPress(self, self.btn_addOnClick, self.btn_addOnStopPress, 1)
  msg.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  msg.btn_minus:SetOnPress(self, self.btn_minusOnClick, self.btn_minusOnStopPress, 1)
  msg.AuctionInputPrice:SetOnEndEdit(self, self.input_priceOnChanged)
  msg.change_price:SetOnSliderValueChanged(self, self.UpdatePriceValueChange)
end

function Auction_AuctionUI:AuctionBtnOnClick()
  if self.buyType == AuctionTipOpenType.putOn then
    if AuctionData.CheckPutAway() then
      local time = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemId, "id").auctionPublicityTime
      if time and 0 < time then
        self:btn_notarizesaleOnClick()
      else
        self:btn_notarizesaleOnClick()
      end
    else
      TipUtility.QuickShowPrompt({
        id = PromptWordType.AuctionPutAway
      })
    end
  elseif self.buyType == AuctionTipOpenType.appoint then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChatError_1")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = string.GetColorText("Sau khi k\225\186\191t th\195\186c th\225\187\157i k\225\187\179 c\195\180ng b\225\187\145, <color=#1add1f>b\225\187\145c ra 1 ng\198\176\225\187\157i ch\198\161i nh\225\186\173n v\225\186\173t ph\225\186\169m n\195\160y</color> t\225\187\171 trong ng\198\176\225\187\157i ch\198\161i \196\145\225\186\183t mua tr\198\176\225\187\155c\nNg\198\176\225\187\157i ch\198\161i kh\195\161c ho\195\160n tr\225\186\163 ti\225\187\129n \196\145\225\186\183t mua qua th\198\176", "#DCE1E5"),
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        self:btn_directBuyPanelBuyOnClick()
      end
    })
  elseif self.buyType == AuctionTipOpenType.putOff then
    if 0 < table.count(self.OutOfItem.preBuyer) then
      self.OutOfItem.isPutOffItem = false
      local textContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("salePanel_1")
      local okContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("salePanel_2")
      local cancelContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("salePanel_3")
      local title = {
        title = "",
        textContent = textContent,
        cancelText = cancelContent,
        okText = okContent,
        cancel = nil,
        ok = self.btn_cancelPanelConfirmOnClick,
        okArgs = self.OutOfItem
      }
      UIManager.Show(UIID.PromptTipUI, title)
    else
      self.OutOfItem.isPutOffItem = true
      AuctionController.SetSendToServerJson(ConditionJsonEnum.mainType, AuctionData.toServerValue.PutOn)
      AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_DefValue)
      AuctionController.SendReqLsTrade()
    end
  elseif self.buyType == AuctionTipOpenType.unionBuy then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChatError_1")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = string.GetColorText("X\195\161c nh\225\186\173n tham d\225\187\177 \196\144\225\186\165u Gi\195\161\239\188\159 ", "#E6E600FF"),
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        self:btn_directBuyPanelBuyOnClick()
      end
    })
  elseif self.buyType == AuctionTipOpenType.unionOneBuy then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("ChatError_1")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = string.GetColorText("X\195\161c nh\225\186\173n mua ngay v\225\187\155i gi\195\161 trinh s\195\161t?", "#E6E600FF"),
      okText = "X\195\161c nh\225\186\173n",
      ok = function()
        self:btn_directBuyPanelBuyOnClick()
      end
    })
  else
    self:btn_directBuyPanelBuyOnClick()
  end
end

function Auction_AuctionUI:btn_addOnClick()
  self.PutAwayCount = tonumber(self.lab_count:GetText())
  if self.buyType == AuctionTipOpenType.putOn then
    local count = self.PutAwayCount + self.MinNum
    local haveCount = BagInfoData.GetMeetPutOnItemCountByItemId(self.PutAwayData.itemId)
    if count > haveCount then
      count = haveCount
    end
    local putAwayCount = self:GetScaleMaxNum(count, self.PutAwayData.itemId)
    local putAwayPriceUint = self:SwitchPrice(putAwayCount, self.PutAwayData.itemId)
    local price = math.modf(tonumber(self.InputAllPrice:GetInputText()) / self:SwitchPrice(self.PutAwayCount, self.PutAwayData.itemId) * putAwayPriceUint)
    self.input_price:SetInputText(math.floor(price / putAwayPriceUint))
    self.InputAllPrice:SetInputText(price)
  elseif self.buyType == AuctionTipOpenType.appoint then
  elseif self.buyType == AuctionTipOpenType.putOff then
  else
    local price = math.modf(tonumber(self.input_price:GetInputText()) / self.PutAwayCount * (self.PutAwayCount + self.MinNum))
    self.input_price:SetInputText(price)
  end
  self.PutAwayCount = self.PutAwayCount + self.MinNum
  local haveCount = BagInfoData.GetMeetPutOnItemCountByItemId(self.PutAwayData.itemId)
  if haveCount < self.PutAwayCount then
    self.PutAwayCount = haveCount
  end
  if self.PutAwayCount < self.MaxCount then
    self.lab_count:SetText(self:GetScaleMaxNum(self.PutAwayCount, self.PutAwayData.itemId))
    self.btn_add:SetInteractable(true)
  else
    self.lab_count:SetText(self:GetScaleMaxNum(self.PutAwayCount, self.PutAwayData.itemId))
    self.btn_add:SetInteractable(false)
  end
  if self.PutAwayCount > 1 then
    self.btn_minus:SetInteractable(true)
  end
end

function Auction_AuctionUI:btn_minusOnClick()
  self.PutAwayCount = tonumber(self.lab_count:GetText())
  if self.buyType == AuctionTipOpenType.putOn then
    if self.PutAwayCount - self.MinNum < 1 then
      local laterScaleMaxNum = self:GetScaleMaxNum(self.MaxCount)
      local price = math.floor(tonumber(self.InputAllPrice:GetInputText()) / self.PutAwayCount * laterScaleMaxNum)
      local count = laterScaleMaxNum
      self.input_price:SetInputText(math.modf(price / self:SwitchPrice(count)))
      self.InputAllPrice:SetInputText(price)
    else
      local count = self.PutAwayCount - self.MinNum
      if count < self.MinNum then
        count = self.MinNum
      end
      local putAwayCount = self:GetScaleMaxNum(count)
      local putAwayPriceUint = self:SwitchPrice(putAwayCount)
      local price = math.modf(tonumber(self.InputAllPrice:GetInputText()) / self:SwitchPrice(self.PutAwayCount) * putAwayPriceUint)
      self.input_price:SetInputText(math.modf(price / self:SwitchPrice(putAwayCount)))
      self.InputAllPrice:SetInputText(price)
    end
  elseif self.buyType == AuctionTipOpenType.appoint then
  elseif self.buyType == AuctionTipOpenType.putOff then
  elseif self.PutAwayCount == 1 then
    self.PutAwayCount = self.MaxCount + self.MinNum
    local price = math.modf(tonumber(self.input_price:GetInputText()) * self.MaxCount)
    self.input_price:SetInputText(price)
  else
    local price = math.modf(tonumber(self.input_price:GetInputText()) / self.PutAwayCount * (self.PutAwayCount - self.MinNum))
    self.input_price:SetInputText(price)
  end
  self.PutAwayCount = self.PutAwayCount - self.MinNum
  if self.PutAwayCount < self.MinNum and self.PutAwayCount >= 1 then
    self.PutAwayCount = self.MinNum
  end
  if self.PutAwayCount < 1 then
    self.lab_count:SetText(self:GetScaleMaxNum(self.MaxCount))
    self.btn_minus:SetInteractable(true)
  else
    self.lab_count:SetText(self:GetScaleMaxNum(self.PutAwayCount))
    self.btn_minus:SetInteractable(true)
  end
  if self.PutAwayCount < self.MaxCount then
    self.btn_add:SetInteractable(true)
  end
  self.PutAwayCount = tonumber(self.lab_count:GetText())
  if tonumber(self.lab_count:GetText()) >= self:GetScaleMaxNum(self.MaxCount) then
    self.btn_add:SetInteractable(false)
  end
end

function Auction_AuctionUI:IsOnPanel(PanelName, bagName)
  self.plane_right:SetActive(PanelName == self.salePanel)
  self.btn_StallPar:SetActive(false)
  self:SetLoadActive(false)
  local TooleIsOn = {
    self.goodsPanel,
    self.salePanel,
    self.myBoughtPanel
  }
  local BagIsOn = {
    self.Scroll_BagInfos,
    self.sw_RingBagItem,
    self.sw_SkeletonBagItem
  }
  for i = 1, #TooleIsOn do
    if TooleIsOn[i] == PanelName then
      TooleIsOn[i].gameObject:SetActive(true)
    else
      TooleIsOn[i].gameObject:SetActive(false)
    end
  end
  if bagName then
    for i = 1, #BagIsOn do
      if BagIsOn[i] == bagName then
        BagIsOn[i].gameObject:SetActive(true)
      else
        BagIsOn[i].gameObject:SetActive(false)
      end
    end
  end
end

function Auction_AuctionUI:ShowPageAuction()
  if self.CurrentTab ~= AuctionRecTimer.AuctionTab then
    return
  end
  if table.count(AuctionData.PageAuctionData) <= 0 and AuctionData.isSlider then
    if AuctionData.page > 1 then
      AuctionData.page = AuctionData.page - 1
      if 0 >= AuctionData.page then
        AuctionData.page = 1
      end
    end
    self:SetLoadActive(false)
    self.loadType = false
    AuctionController.SendReqLsTrade()
    AuctionData.isSlider = false
    return
  end
  self:DesToryRecTimer()
  for i = 1, #self.pageAuctionItemTab do
    self.pageAuctionItemTab[i]:SetActive(false)
  end
  local PutOnInfo = AuctionData.PageAuctionData
  self.serverAuctionDataLength = #PutOnInfo
  if 0 < #PutOnInfo then
    self.pageAuctionItemTab = {}
    for i = 1, #PutOnInfo do
      local PutOnInfoData = PutOnInfo[i]
      local obj = self.Button_goodsItemTemp:GetOrCreateItem(i)
      local itemInfo = AuctionData.GetItemConfigInfo(PutOnInfoData.item)
      local item = ClientTable.cfg_Item_itemManager:TryGetValue(PutOnInfoData.item.itemId, "id")
      local price = PutOnInfoData.highPrice * self:SwitchPrice(PutOnInfoData.item.count, PutOnInfoData.item.itemId)
      local haveCount = BagInfoData.GetMeetPutOnItemCountByItemId(PutOnInfoData.pItemId)
      if price <= haveCount then
        price = string.GetColorText(price, ItemQuality2ColorDic[0])
      else
        price = string.GetColorText(price, ItemQuality2ColorDic[7])
      end
      obj.price_value:SetText(price)
      obj.item = item
      local addTime = math.modf(PutOnInfoData.addTime / 1000)
      local endTime = math.modf(PutOnInfoData.endTime / 1000)
      self:CreatRecTimer(i, obj, addTime, endTime, AuctionRecTimer.AuctionTab)
      local titleStr = string.GetColorText(itemInfo.tblItem.name, ItemQuality2ColorDic[itemInfo.tblItem.colorShow])
      obj.lab_name:SetText(titleStr)
      local textWidth = obj.lab_name.text.preferredWidth
      local bgWith = obj.lab_name:GetSizeDelta()
      if textWidth > bgWith then
        obj.MyNameAutoScrollText.text = titleStr
        obj.lab_name:SetActive(false)
        obj.MyName:SetActive(true)
      else
        obj.lab_name:SetActive(true)
        obj.MyName:SetActive(false)
      end
      if PutOnInfoData.preBuyer ~= nil and 0 < #PutOnInfoData.preBuyer then
        obj.img_buy:SetActive(true)
        obj.buyNum:SetActive(true)
        obj.buyNum:SetText(#PutOnInfoData.preBuyer or 0)
      else
        obj.img_buy:SetActive(false)
        obj.buyNum:SetActive(false)
      end
      local isMeHeadIcon = PutOnInfoData.sellerId == self.meData.id
      if isMeHeadIcon then
        local career = RoleUtility.GetBasicCareer(RoleManager.me.career)
        self:SetSprite("Atlas_headPortrait", AuctionData.CareerType[career], obj.isMeBg, false)
        obj.isMeBg:SetActive(true)
      elseif obj.isMeBg.gameObject.activeSelf == true then
        obj.isMeBg:SetActive(false)
      end
      if item.auction ~= nil and item.auction ~= "" then
        local currencyId = string.split(string.split(item.auction, "&")[1], "#")[2]
        local currencyTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(currencyId), "id")
        self:SetSprite("Atlas_Common", currencyTab.icon, obj.img_icon, false)
      end
      obj.itemInfo = PutOnInfoData
      obj.itemCellData = obj.itemCellData or ItemCellData()
      obj:SetOnClick(self, self.Button_btn_buy)
      if itemInfo.count == 1 then
        itemInfo.count = nil
      end
      obj.itemCellData:RefreshData(itemInfo)
      ItemUtility.ShowItemCell(obj.btn_3DItem, obj.itemCellData, self)
      obj:SetActive(true)
      table.insert(self.pageAuctionItemTab, obj.gameObject)
    end
  end
  if self.loadType and AuctionData.page >= 2 then
    self.Content.localPosition = Vector3.zero
  end
  self:SetLoadActive(false)
end

function Auction_AuctionUI:ShowUnionOrUnionCampData()
  if self.CurrentTab == AuctionRecTimer.Union and AuctionData.mainType == AuctionData.toServerValue.Union then
    self:ShowUnionData()
  elseif self.CurrentTab == AuctionRecTimer.UnionCamp and AuctionData.mainType == AuctionData.toServerValue.CampUnion then
    self:ShowUnionData()
  end
end

function Auction_AuctionUI:ShowUnionData()
  if table.count(AuctionData.PageAuctionData) <= 0 and AuctionData.isSlider then
    if AuctionData.page > 1 then
      AuctionData.page = AuctionData.page - 1
      if 0 >= AuctionData.page then
        AuctionData.page = 1
      end
    end
    self:SetLoadActive(false)
    self.loadType = false
    AuctionController.SendReqLsTrade()
    AuctionData.isSlider = false
    return
  end
  self:DesToryRecTimer()
  for i = 1, #self.pageAuctionItemTab do
    self.pageAuctionItemTab[i]:SetActive(false)
  end
  if self.leftTabType == AuctionTabType.Public or self.leftTabType == AuctionTabType.appoint then
    return
  end
  local PutOnInfo = AuctionData.PageAuctionData
  self.serverUnionDataLength = #PutOnInfo
  if 0 < #PutOnInfo then
    self.pageAuctionItemTab = {}
    for i = 1, #PutOnInfo do
      local obj = self.Button_UnionItemTemp:GetOrCreateItem(i)
      local itemInfo = AuctionData.GetItemConfigInfo(PutOnInfo[i].item)
      local haveCount = BagInfoData.GetMeetPutOnItemCountByItemId(PutOnInfo[i].pItemId)
      local lowPrice = PutOnInfo[i].lowPrice * PutOnInfo[i].item.count
      if haveCount >= lowPrice then
        lowPrice = string.GetColorText(lowPrice, ItemQuality2ColorDic[0])
      else
        lowPrice = string.GetColorText(lowPrice, ItemQuality2ColorDic[7])
      end
      obj.price_value:SetText(lowPrice)
      local hightPrice = PutOnInfo[i].highPrice * PutOnInfo[i].item.count
      if haveCount >= hightPrice then
        hightPrice = string.GetColorText(hightPrice, ItemQuality2ColorDic[0])
      else
        hightPrice = string.GetColorText(hightPrice, ItemQuality2ColorDic[7])
      end
      obj.lab_oneValue:SetText(hightPrice)
      local item = ClientTable.cfg_Item_itemManager:TryGetValue(PutOnInfo[i].item.itemId, "id")
      obj.item = item
      local addTime = math.modf(PutOnInfo[i].addTime / 1000)
      local endTime = math.modf(PutOnInfo[i].endTime / 1000)
      self:CreatRecTimer_Union(i, obj, addTime, endTime)
      local titleStr = string.GetColorText(itemInfo.tblItem.name, ItemQuality2ColorDic[itemInfo.tblItem.colorShow])
      obj.lab_name:SetText(titleStr)
      if item.auction ~= nil and item.auction ~= "" then
        local currencyId = string.split(string.split(item.auction, "&")[1], "#")[2]
        local currencyTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(currencyId), "id")
        self:SetSprite("Atlas_Common", currencyTab.icon, obj.img_icon, false)
        self:SetSprite("Atlas_Common", currencyTab.icon, obj.img_oneIcon, false)
      end
      obj.btn_price.itemInfo = PutOnInfo[i]
      obj.btn_onePrice.itemInfo = PutOnInfo[i]
      obj.btn_price.buyType = AuctionTipOpenType.unionBuy
      obj.btn_onePrice.buyType = AuctionTipOpenType.unionOneBuy
      obj.btn_price:SetOnClick(self, self.Button_btn_buy)
      obj.btn_onePrice:SetOnClick(self, self.Button_btn_buy)
      obj.itemCellData = obj.itemCellData or ItemCellData()
      if itemInfo.count == 1 then
        itemInfo.count = nil
      end
      obj.itemCellData:RefreshData(itemInfo)
      ItemUtility.ShowItemCell(obj.btn_3DItem, obj.itemCellData, self, true)
      if PutOnInfo[i].buyer == nil then
        obj.lab_inAuction:SetActive(false)
        obj.lab_myAuction:SetActive(false)
      elseif PutOnInfo[i].buyer and PutOnInfo[i].buyer.id == ViewData.meData.id then
        obj.lab_inAuction:SetActive(false)
        obj.lab_myAuction:SetActive(true)
      else
        obj.lab_inAuction:SetActive(true)
        obj.lab_myAuction:SetActive(false)
      end
      obj:SetActive(true)
      table.insert(self.pageAuctionItemTab, i, obj.gameObject)
    end
  end
  if self.loadType and AuctionData.page >= 2 then
    self.unionScrollContent.localPosition = Vector3.zero
  end
  self:SetLoadActive(false)
end

function Auction_AuctionUI:Auction_excellentPrice(_, msg)
  local excellentWeight = 1
  if self.PutOnItem and self.PutOnItem.excellence ~= nil then
    excellentWeight = self:GetExcellentWeight(self.PutOnItem.tblItem.id, self.PutOnItem.excellence)
  end
  local price = self.PutOnItem.tblItem.minAuctionPrice
  local pri = string.split(price, "#")
  local minPrice = tonumber(pri[1])
  local maxPrice = tonumber(pri[2])
  if msg and tonumber(msg.price) ~= 0 then
    local nowPrice = math.floor(msg.price * excellentWeight)
    nowPrice = Mathf.Clamp(nowPrice, minPrice, maxPrice)
    self.input_price:SetInputText(nowPrice)
    local sliderPrice = (nowPrice - minPrice) / (maxPrice - minPrice)
    self.change_price.slider.value = sliderPrice
  else
    local recommendPrice = ClientTable.cfg_Item_itemManager:TryGetValue(msg.itemId, "id").recommend
    if recommendPrice ~= 0 then
      local nowPrice = math.floor(recommendPrice * excellentWeight)
      nowPrice = Mathf.Clamp(nowPrice, minPrice, maxPrice)
      self.input_price:SetInputText(nowPrice)
      local sliderPrice = (nowPrice - minPrice) / (maxPrice - minPrice)
      self.change_price.slider.value = sliderPrice
    end
  end
end

function Auction_AuctionUI:Auction_LookHistory()
  AuctionData.MyHistoryData = AuctionData.SortByTime(false, AuctionData.MyHistoryData)
  if not self.tableView then
    self:CreateUITableView()
  else
    self.tableView:ReloadData(1)
  end
end

local openGrid = 8

function Auction_AuctionUI:ShowPutAway()
  local PutOnInfo = AuctionData.AutoRackTable
  local mTotalPutOnNum = AuctionData.GetTotalPutOnNumber()
  local mMemberLevel = AuctionData.GetMemberLevel()
  self:UpdatePutData()
  self.PutAwayTab = {}
  self.PutAwayBidId = {}
  self.Button_SaleRackItemTemp:SetActiveTable()
  for i = 1, mTotalPutOnNum do
    local obj = self.Button_SaleRackItemTemp:GetOrCreateItem(i)
    if PutOnInfo[i] ~= nil then
      local itemInfo = AuctionData.GetItemConfigInfo(PutOnInfo[i].item)
      local item = ClientTable.cfg_Item_itemManager:TryGetValue(PutOnInfo[i].item.itemId, "id")
      obj.item = item
      obj.lab_value:SetText(PutOnInfo[i].lowPrice * self:SwitchPrice(PutOnInfo[i].item.count, PutOnInfo[i].item.itemId))
      local addTime = math.modf(PutOnInfo[i].addTime / 1000)
      local endTime = math.modf(PutOnInfo[i].endTime / 1000)
      self:CreatRecTimer(i, obj, addTime, endTime, AuctionRecTimer.MyPutOn)
      local titleStr = string.GetColorText(itemInfo.tblItem.name, ItemQuality2ColorDic[itemInfo.tblItem.colorShow])
      obj.lab_name:SetText(titleStr)
      local textWidth = obj.lab_name.text.preferredWidth
      local bgWith = obj.lab_name:GetSizeDelta()
      if textWidth > bgWith then
        obj.MyName.transform:GetComponent("AutoScrollText").text = titleStr
        obj.lab_name:SetActive(false)
        obj.MyName:SetActive(true)
      else
        obj.lab_name:SetActive(true)
        obj.MyName:SetActive(false)
      end
      if PutOnInfo[i].preBuyer ~= nil and #PutOnInfo[i].preBuyer > 0 then
        obj.img_buy:SetActive(true)
        obj.buyNum:SetActive(true)
        obj.buyNum:SetText(#PutOnInfo[i].preBuyer or 0)
      else
        obj.img_buy:SetActive(false)
        obj.buyNum:SetActive(false)
      end
      obj.itemCellData = obj.itemCellData or ItemCellData()
      if PutOnInfo[i].item.count == 1 then
        itemInfo.count = nil
      end
      obj.itemCellData:RefreshData(itemInfo)
      ItemUtility.ShowItemCell(obj.btn_3DItem, obj.itemCellData, self, true)
      if item.auction ~= "" then
        local iconId = string.split(string.split(item.auction, "&")[1], "#")[2]
        local isTure = iconId == "1000030" and true or false
        obj.img_icon_diamond.gameObject:SetActive(isTure)
        obj.img_icon.gameObject:SetActive(not isTure)
      end
      local control = UIControl(obj.transform)
      control.itemInfo = PutOnInfo[i]
      obj:SetOnClick(self, function()
        self:Button_SaleRackItemOnClick(PutOnInfo[i])
      end)
      table.insert(self.PutAwayBidId, PutOnInfo[i].tid or 0)
      table.insert(self.PutAwayTab, obj)
      obj.vipBg:SetActive(false)
    else
      local vipActive = PutOnInfo[i] == nil and i > mTotalPutOnNum
      obj.vipBg:SetActive(vipActive)
      if vipActive then
        if i <= 15 then
          obj.img_vipOpen:SetActive(i > mTotalPutOnNum)
        else
          obj.img_not_open:SetActive(15 < i)
          obj.img_vipOpen:SetActive(not (15 < i))
        end
      end
      obj.vipBg:SetOnClick(self, function()
        self:OpenVip(i)
      end)
    end
    obj.itemPanel:SetActive(PutOnInfo[i] ~= nil)
    obj.openBg:SetActive(PutOnInfo[i] == nil and obj.vipBg:GetActive() == false)
    obj.openBg:SetOnClick(self, function()
      if AuctionData.CheckPutAway() then
        self:PutOnTips(obj.openBg)
      else
        TipUtility.QuickShowPrompt({
          id = PromptWordType.AuctionPutAway
        })
      end
    end)
    obj:SetActive(true)
    self.lab_goodsTitle:SetText(string.format(LocalizationUtility.GetContentByKey("Auction_count"), #PutOnInfo, AuctionData.GetTotalPutOnNumber()))
  end
  self:InitStalButtonState()
end

function Auction_AuctionUI:UpdatePutData()
  if self.OutOfItem == nil or self.OutOfItem.isPutOffItem == nil or self.OutOfItem.isPutOffItem == false then
    return
  end
  for i = 1, #AuctionData.AutoRackTable do
    local putInfo = AuctionData.AutoRackTable[i]
    if self.OutOfItem.tid == putInfo.tid then
      if putInfo.preBuyer ~= nil and #putInfo.preBuyer > 0 then
        do
          local textContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("salePanel_1")
          local okContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("salePanel_2")
          local cancelContent = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("salePanel_3")
          local title = {
            title = "",
            textContent = textContent,
            cancelText = cancelContent,
            okText = okContent,
            cancel = nil,
            ok = self.btn_cancelPanelConfirmOnClick,
            okArgs = self.OutOfItem
          }
          UIManager.Show(UIID.PromptTipUI, title)
        end
        break
      end
      self.btn_cancelPanelConfirmOnClick(self.OutOfItem)
      break
    end
  end
  self.OutOfItem.isPutOffItem = false
end

function Auction_AuctionUI:UpdateAuction()
  if self.CurrentTab == AuctionRecTimer.AuctionTab then
    self:DesToryRecTimer()
    self:ShowPageAuction()
  end
  if self.CurrentTab == AuctionRecTimer.Union or self.CurrentTab == AuctionRecTimer.UnionCamp then
    self:ShowUnionOrUnionCampData()
  end
end

function Auction_AuctionUI:UpdateShelf()
  if self.CurrentTab == AuctionRecTimer.MyPutOn then
    self:DesToryRecTimer()
  end
  self:ShowPutAway()
end

function Auction_AuctionUI:UpdatePutAway()
  for i = 1, #self.PutAwayTab do
    if self.PutAwayBidId[i] == self.OutOfItem.tid then
      self.PutAwayTab[i]:Destroy()
      self.Button_SaleRackItemTemp:DesToryItem(i)
      if self.recTimer[i] ~= nil then
        Timer.Stop(self.recTimer[i])
        self.recTimer[i] = nil
      end
    end
  end
  local num = #self.PutAwayTab - 1
  if num == 0 then
    self.lab_goodsTitle:SetText(string.format(LocalizationUtility.GetContentByKey("Auction_count0"), AuctionData.GetTotalPutOnNumber()))
    self:DesToryRecTimer()
  end
end

function Auction_AuctionUI:TabOnClick(TabType, data, obj)
  self:SetButtonPitchOn(self.leftTitleSubTab, obj)
  self.leftTabType = TabType
  if TabType == AuctionTabType.All then
    AuctionController.SetSendToServerJson(ConditionJsonEnum.allItem, AuctionData.toServerValue.allItem)
  elseif TabType == AuctionTabType.Public then
    AuctionController.SetSendToServerJson(ConditionJsonEnum.prebuyData, AuctionData.toServerValue.prebuyData)
  elseif TabType == AuctionTabType.Equip then
    local tradeTab
    local equipGradeServer = AuctionData.equipGradeTypeDP
    if data == AuctionData.LeftSubTabDefault.Default then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Equip]
      self:ResetDropDownEquipGrade(true)
    elseif data == AuctionData.LeftSubTabDefault.Equip_Wing then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipSuit, AuctionData.toServerValue.itemEquipNoJudge)
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, AuctionData.toServerValue.EquipClass_defalult)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Wing]
      self:ResetDropDownEquipGrade(false)
    elseif data == AuctionData.LeftSubTabDefault.Equip_BigAngelSuit then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipSuit, AuctionData.toServerValue.itemEquipNoJudge)
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, AuctionData.toServerValue.EquipClass_defalult)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.BigAngelSuit]
      self:ResetDropDownEquipGrade(false)
    elseif data == AuctionData.LeftSubTabDefault.Equip_Weapon then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Weapon]
      self:ResetDropDownEquipGrade(true)
    elseif data == AuctionData.LeftSubTabDefault.Equip_Helmet then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Helmet]
      self:ResetDropDownEquipGrade(true)
    elseif data == AuctionData.LeftSubTabDefault.Equip_Armour then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Armour]
      self:ResetDropDownEquipGrade(true)
    elseif data == AuctionData.LeftSubTabDefault.Equip_EgGuard then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.EgGuard]
      self:ResetDropDownEquipGrade(true)
    elseif data == AuctionData.LeftSubTabDefault.Equip_HandGuard then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HandGuard]
      self:ResetDropDownEquipGrade(true)
    elseif data == AuctionData.LeftSubTabDefault.Equip_Shoe then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, equipGradeServer)
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Shoe]
      self:ResetDropDownEquipGrade(true)
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_Equip, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.SuitEquip then
    local tradeTab
    if data == AuctionData.LeftSubTabDefault.Default then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip]
    elseif data == AuctionData.LeftSubTabDefault.SuitEquip_Weapon then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip_Weapon]
    elseif data == AuctionData.LeftSubTabDefault.SuitEquip_Helmet then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip_Helmet]
    elseif data == AuctionData.LeftSubTabDefault.SuitEquip_Armour then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip_Armour]
    elseif data == AuctionData.LeftSubTabDefault.SuitEquip_EgGuard then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip_EgGuard]
    elseif data == AuctionData.LeftSubTabDefault.SuitEquip_HandGuard then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip_HandGuard]
    elseif data == AuctionData.LeftSubTabDefault.SuitEquip_Shoe then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SuitEquip_Shoe]
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_SuitEquip, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.JewelryEquip then
    local tradeTab
    if data == AuctionData.LeftSubTabDefault.Default then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip]
    elseif data == AuctionData.LeftSubTabDefault.JewelryEquip_Necklace then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip_Necklace]
    elseif data == AuctionData.LeftSubTabDefault.JewelryEquip_Earrings then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip_Earrings]
    elseif data == AuctionData.LeftSubTabDefault.JewelryEquip_Rings then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip_Rings]
    elseif data == AuctionData.LeftSubTabDefault.JewelryEquip_ReinNecklace then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip_ReinNecklace]
    elseif data == AuctionData.LeftSubTabDefault.JewelryEquip_ReinEarrings then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip_ReinEarrings]
    elseif data == AuctionData.LeftSubTabDefault.JewelryEquip_ReinRings then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryEquip_ReinRings]
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_JewelryEquip, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.HolySpirit then
    local tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolySpirit]
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_HolySpirit, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.Reliquary then
    local tradeTab
    if data == AuctionData.LeftSubTabDefault.Default then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Reliquary]
    elseif data == AuctionData.LeftSubTabDefault.ReliquarySmallTag_1 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Reliquary_1]
    elseif data == AuctionData.LeftSubTabDefault.ReliquarySmallTag_2 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Reliquary_2]
    elseif data == AuctionData.LeftSubTabDefault.ReliquarySmallTag_3 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Reliquary_3]
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_Reliquary, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.HolyRing then
    local tradeTab
    if data == AuctionData.LeftSubTabDefault.Default then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolyRing]
    elseif data == AuctionData.LeftSubTabDefault.HolyRingSmallTag_1 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolyRing_1]
    elseif data == AuctionData.LeftSubTabDefault.HolyRingSmallTag_2 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolyRing_2]
    elseif data == AuctionData.LeftSubTabDefault.HolyRingSmallTag_3 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolyRing_3]
    elseif data == AuctionData.LeftSubTabDefault.HolyRingSmallTag_4 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolyRing_4]
    elseif data == AuctionData.LeftSubTabDefault.HolyRingSmallTag_5 then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.HolyRing_5]
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_HolyRing, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.Newrunes then
    local tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Newrunes]
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_Newrunes, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.SkillBook then
    local tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SkillBooks]
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_SkillBook, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.Material then
    local tradeTab
    if data == AuctionData.LeftSubTabDefault.Default then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Material]
    elseif data == AuctionData.LeftSubTabDefault.Mat_Gem then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Gem]
    elseif data == AuctionData.LeftSubTabDefault.Mat_Ticket then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.TicketMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_Wing then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.WingMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_Jewelry then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.JewelryMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_Skill then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.SkillMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_FluorescentGems then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.FluorescentGems]
    elseif data == AuctionData.LeftSubTabDefault.Mat_BigAngelSuit then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.BigAngelSuitMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_EquipSuperpositionStone then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.EquipSuperpositionStone]
    elseif data == AuctionData.LeftSubTabDefault.Mat_GuardMat then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.GuardMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_ArmbandsMat then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.ArmbandsMat]
    elseif data == AuctionData.LeftSubTabDefault.Mat_MasterExperiencePotion then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.MasterExperiencePotion]
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_Mat, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.Currency then
    local tradeTab
    if data == AuctionData.LeftSubTabDefault.Default then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Currency]
    elseif data == AuctionData.LeftSubTabDefault.Currency_Miracle then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.MiracleCurrency]
    elseif data == AuctionData.LeftSubTabDefault.Currency_Diamond then
      tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Diamond]
    end
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_Currency, AuctionData.toServerValue.TradeScreenControl, tradeTab)
  elseif TabType == AuctionTabType.appoint then
    AuctionController.SetSendToServerJson(ConditionJsonEnum.prebuy, AuctionData.toServerValue.prebuy)
    AuctionController.SendReqLsTrade()
    return
  end
  self:ScreenList()
end

function Auction_AuctionUI:chooseUserChanged(control, index)
  if self.chooseUser.isSynchToServer then
    return
  end
  self:ResetDropDownCommpent(self.chooseUser, index, false, AuctionFilterType.CareerType)
end

function Auction_AuctionUI:chooseEquipGradeChanged(control, index)
  AuctionData.equipGradeTypeDP = index
  self.chooseEquipClassLabel.color = Color.green
  if self.chooseEquipGrade.isSynchToServer then
    return
  end
  self:ResetDropDownCommpent(self.chooseEquipGrade, index, false, AuctionFilterType.EquipGradeType)
end

function Auction_AuctionUI:chooseEquipGradeOnClick(control)
  local objContent = UIControl(self.chooseEquipGrade.transform, "Dropdown List/Viewport/Content")
  if objContent == nil then
    return
  end
  for i = 1, objContent.transform.childCount do
    local childTrans = objContent.transform:GetChild(i - 1)
    local itemLabTrans = childTrans:Find("Item Label")
    if itemLabTrans then
      local itemLab = itemLabTrans:GetComponent("Text")
      if itemLab then
        itemLab.color = Color.green
      end
    end
  end
end

function Auction_AuctionUI:chooseHolySpiritGradeChanged(control, index)
  self.chooseHolySpiritClassLabel.color = Color.green
  if self.chooseHolySpiritGrade.isSynchToServer then
    return
  end
  self:ResetDropDownCommpent(self.chooseHolySpiritGrade, index, false, AuctionFilterType.HolySpiritGradeType)
end

function Auction_AuctionUI:chooseHolySpiritGradeOnClick(control)
  local objContent = UIControl(self.chooseHolySpiritGrade.transform, "Dropdown List/Viewport/Content")
  if objContent == nil then
    return
  end
  for i = 1, objContent.transform.childCount do
    local childTrans = objContent.transform:GetChild(i - 1)
    local itemLabTrans = childTrans:Find("Item Label")
    if itemLabTrans then
      local itemLab = itemLabTrans:GetComponent("Text")
      if itemLab then
        itemLab.color = Color.green
      end
    end
  end
end

function Auction_AuctionUI:chooseSortChanged(control, index)
  if self.chooseSort.isSynchToServer then
    return
  end
  self:ResetDropDownCommpent(self.chooseSort, index, false, AuctionFilterType.SortType)
end

function Auction_AuctionUI:chooseRoleLevelChanged(control, index)
  if self.chooseRoleLevel.isSynchToServer then
    return
  end
  self:ResetDropDownCommpent(self.chooseRoleLevel, index, false, AuctionFilterType.RoleLevel)
end

function Auction_AuctionUI:RefreshFilterType(dropDownTrans, dropIndex, filterType)
  if filterType == AuctionFilterType.CareerType then
    if dropIndex == AuctionJobType.default then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.Career_Defalut)
    elseif dropIndex == AuctionJobType.Career_Swordman then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.Career_Swordman)
    elseif dropIndex == AuctionJobType.Career_Mage then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.Career_Mage)
    elseif dropIndex == AuctionJobType.Career_SmartSagittary then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.Career_SmartSagittary)
    elseif dropIndex == AuctionJobType.Career_AgilitySagittary then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.Career_AgilitySagittary)
    elseif dropIndex == AuctionJobType.Career_SpellSword then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.Career_SpellSword)
    elseif dropIndex == AuctionJobType.SummonMagician then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.career, AuctionData.toServerValue.SummonMagician)
    end
  elseif filterType == AuctionFilterType.SortType then
    if dropIndex == AuctionSortType.default then
      if self.leftTabType == AuctionTabType.All then
        AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_TimeDown)
      else
        AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_PriceUp)
      end
    elseif dropIndex == AuctionSortType.priceUp then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_PriceUp)
    elseif dropIndex == AuctionSortType.priceDown then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_PriceDown)
    elseif dropIndex == AuctionSortType.timeUp then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_TimeUp)
    elseif dropIndex == AuctionSortType.timeDown then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_TimeDown)
    end
  elseif filterType == AuctionFilterType.EquipGradeType then
    if dropIndex == AuctionEquipClassType.default then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipSuit, AuctionData.toServerValue.itemEquipNoJudge)
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, AuctionData.toServerValue.EquipClass_defalult)
    else
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipSuit, AuctionData.toServerValue.itemEquip_YesSuit_NotExcellent)
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, dropIndex)
    end
  elseif filterType == AuctionFilterType.RoleLevel then
    if dropIndex == AuctionRoleLevelType.default then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.roleLevel, AuctionData.toServerValue.RoleLevel_defalult)
    else
      AuctionController.SetSendToServerJson(ConditionJsonEnum.roleLevel, dropIndex)
    end
  elseif filterType == AuctionFilterType.HolySpiritGradeType then
    if dropIndex == AuctionHolySpiritGradeType.default then
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, AuctionData.toServerValue.EquipClass_defalult)
    else
      AuctionController.SetSendToServerJson(ConditionJsonEnum.itemEquipClass, dropIndex)
    end
  end
  if dropDownTrans.isSynchToServer then
    dropDownTrans.isSynchToServer = false
  else
    self:ScreenList()
  end
end

function Auction_AuctionUI:ScreenList()
  AuctionController.SendReqLsTrade()
  self:SetLoadActive(true)
end

function Auction_AuctionUI:LoadUp()
  if AuctionData.page == 1 then
    return
  end
  if AuctionData.page > 1 then
    AuctionData.page = AuctionData.page - 1
  end
  AuctionController.SendReqLsTrade()
  self:SetLoadActive(true)
end

function Auction_AuctionUI:LoadDown()
  AuctionData.page = AuctionData.page + 1
  AuctionController.SendReqLsTrade()
  self:SetLoadActive(true)
end

function Auction_AuctionUI:OnBagChange(_, msg)
  self:RefreshTagFour(msg)
  self:RefreshStallCostItem()
  self:RefreshShoutCostItem()
end

function Auction_AuctionUI:RefreshTagFour(msg)
  self:InitBagData(msg)
end

local function AuctionState(obj, state)
  if obj.btn_bidding ~= nil and obj.btn_buy ~= nil then
    obj.btn_bidding:SetInteractable(state)
    obj.btn_buy:SetInteractable(state)
  end
end

function Auction_AuctionUI:CreatRecTimer(i, obj, addTime, endTime, TimeType)
  local curTime = Time.GetServerSecondTime()
  local surplusTime = endTime - curTime
  local publicTime = math.modf(addTime + obj.item.auctionPublicityTime / 1000 - curTime)
  if self.CurrentTab == TimeType then
    if publicTime <= 0 then
      publicTime = 0
      obj.buyNumBG:SetActive(false)
    end
    
    local function UpdateRecommendBtn()
      if obj ~= nil and IsNil(obj.gameObject) == false then
        if 0 < publicTime then
          local timeStr = TimeUtility.ShowTimeReserveWithColon(publicTime)
          obj.lab_time:SetText(timeStr)
          obj.timeType:SetText(LocalizationUtility.GetContentByKey("Auction_gongshitime"))
          obj.buyType = AuctionTipOpenType.appoint
          obj.buyNumBG:SetActive(true)
          obj.timeType:SetActive(true)
          obj.lab_time:SetActive(true)
          AuctionState(obj, false)
          publicTime = publicTime - 1
          surplusTime = surplusTime - 1
        else
          if surplusTime <= 0 then
            surplusTime = 0
          end
          local timeStr = TimeUtility.ShowTimeReserveWithColon(surplusTime)
          obj.lab_time:SetText(timeStr)
          obj.timeType:SetText("Th\225\187\157i gian l\195\170n k\225\187\135: ")
          obj.buyType = AuctionTipOpenType.buy
          AuctionState(obj, true)
          obj.buyNumBG:SetActive(false)
          obj.timeType:SetActive(false)
          obj.lab_time:SetActive(false)
          if self.recTimer[i] then
            Timer.Stop(self.recTimer[i])
            self.recTimer[i] = nil
          end
          surplusTime = surplusTime - 1
        end
      end
    end
    
    UpdateRecommendBtn()
    if self.recTimer[i] == nil then
      local data = {timeType = TimeType}
      self.recTimer[i] = Timer.StartLoop(1, surplusTime, UpdateRecommendBtn, data)
    end
  end
end

function Auction_AuctionUI:CreatRecTimer_Union(i, obj, addTime, endTime)
  local curTime = Time.GetServerSecondTime()
  local surplusTime = endTime - curTime
  if surplusTime <= 0 then
    surplusTime = 0
  end
  if self.CurrentTab == AuctionRecTimer.Union or self.CurrentTab == AuctionRecTimer.UnionCamp then
    local function UpdateRecommendBtn()
      if obj ~= nil and IsNil(obj.gameObject) == false then
        if 0 < surplusTime then
          obj.lab_time:SetActive(true)
          
          AuctionState(obj, false)
          surplusTime = surplusTime - 1
          local timeStr = TimeUtility.ShowTimeReserveWithColon(surplusTime)
          obj.lab_time:SetText(timeStr)
        else
          if surplusTime <= 0 then
            surplusTime = 0
          end
          local timeStr = TimeUtility.ShowTimeReserveWithColon(surplusTime)
          obj.lab_time:SetText(timeStr)
        end
      end
    end
    
    if self.recTimer[i] == nil then
      local data = {
        timeType = self.CurrentTab
      }
      self.recTimer[i] = Timer.StartLoop(1, surplusTime, UpdateRecommendBtn, data)
    end
  end
end

function Auction_AuctionUI:DesToryRecTimer()
  local tagType = AuctionRecTimer.AuctionTab
  if self.recTimer ~= nil then
    for k, v in pairs(self.recTimer) do
      tagType = v.args[1].timeType
      if v.args[1].timeType == self.CurrentTab then
        Timer.Stop(self.recTimer[k])
        self.recTimer[k] = nil
      end
    end
    if tagType == self.CurrentTab then
      self.recTimer = {}
    end
  end
end

function Auction_AuctionUI:DesToryShoutTimer()
  if self.stallShoutCDObj then
    Timer.Stop(self.stallShoutCDObj)
  end
  self.stallShoutCDObj = nil
  if self.stallCountTimeObj then
    Timer.Stop(self.stallCountTimeObj)
  end
  self.stallCountTimeObj = nil
end

function Auction_AuctionUI:descBtnOnClick()
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Auction_AuctionUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Auction_AuctionUI:CloseAllStallOnClick()
  if self.panel_Stall.gameObject.activeSelf then
    self.panel_Stall:SetActive(false)
  end
  if self.panel_StallShout.gameObject.activeSelf then
    self.panel_StallShout:SetActive(false)
  end
  self.btn_bgStallFrame:SetActive(false)
end

function Auction_AuctionUI:OpenStallMainBtnOnClick()
  self.panel_Stall:SetActive(true)
  self.btn_bgStallFrame:SetActive(true)
  self.btn_Bg_Colider:SetActive(false)
  self.sw_stallNoticeList:SetActive(false)
  self:InitOpenStallPanel()
end

function Auction_AuctionUI:StallShoutMainBtnOnClick()
  self.panel_StallShout:SetActive(true)
  self.btn_bgStallFrame:SetActive(true)
  self:InitShoutPanel()
end

function Auction_AuctionUI:GoToStallPosOnClick()
  local stallCityTab = ClientTable.cfg_Auction_stallPositionManager:TryGetValue(AuctionData.stallAuctionInfo.position)
  local positionArray = string.split(stallCityTab.position, "#")
  local targetCell = {}
  targetCell.x = tonumber(positionArray[1])
  targetCell.y = tonumber(positionArray[2])
  PathFinderManager.JumpMapToMoveToPos(stallCityTab.map, targetCell, nil, nil, nil, nil, self.OpenSelfStall)
  EventManager.Dispatch(Event.Auction_ClosePanel)
  UIManager.Hide(UIID.Auction_AuctionUI)
end

function Auction_AuctionUI:OpenSelfStall()
  UIManager.Show(UIID.Auction_StallUI, {
    position = AuctionData.stallAuctionInfo.position
  })
end

function Auction_AuctionUI:OpenStallNoticeList()
  local isEnable = self.sw_stallNoticeList.gameObject.activeSelf
  if isEnable == true then
    self:RefreshStallNoticeName()
  else
    self.sw_stallNoticeContent.transform.localPosition = Vector3(self.sw_stallNoticeContent.transform.localPosition.x, -self.sw_stallNoticeContentY / 2)
  end
  self.btn_Bg_Colider:SetActive(not isEnable)
  self.sw_stallNoticeList:SetActive(not isEnable)
end

function Auction_AuctionUI:ChooseNoticeTogChanged(control)
  local choBg = UIControl(control.transform, "choBg")
  local checkmark = UIControl(control.transform, "Background/Checkmark")
  local isChoose = choBg.gameObject.activeSelf
  if isChoose == false and table.count(self.chooseNoticeTabList) == 5 then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_6"))
  end
  if isChoose == false and table.count(self.chooseNoticeTabList) < 5 then
    local info = {}
    info.stallNameTab = control.stallNameTab
    info.toggle = control
    self.chooseNoticeTabList[control.stallNameTab.id] = info
    choBg:SetActive(true)
    checkmark:SetActive(true)
  else
    self.chooseNoticeTabList[control.stallNameTab.id] = nil
    choBg:SetActive(false)
    checkmark:SetActive(false)
  end
end

function Auction_AuctionUI:OnStallCityDPChanged(_control, _index)
  local mapId = self.stallMapTabList[_index + 1].id
  if mapId == AuctionStallMap.ShengZhiGuoDu and not AuctionController.CheckStallCondition(self.stallCityMapTabList) then
    local uiWord = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Stall_9").content
    FloatingTipUtility.QuickMsg(uiWord)
    self.dp_StallCity:SetSelectValue(self.dp_StallCityIndex - 1)
    return
  end
  if self.dp_StallCityIndex == _index + 1 then
    return
  end
  self.dp_StallCityIndex = _index + 1
  local toServeMsg = {}
  toServeMsg.type = mapId
  AuctionController.ReqAuctionStallPosition(TradeMessage.ReqAuctionStallPosition, toServeMsg)
end

function Auction_AuctionUI:RandomStallPosOnClick()
  local toServeMsg = {}
  toServeMsg.type = self.stallMapTabList[self.dp_StallCityIndex].id
  AuctionController.ReqAuctionStallPosition(TradeMessage.ReqAuctionStallPosition, toServeMsg)
end

function Auction_AuctionUI:OnStallTimeDPChanged(_control, _index)
  self.dp_StallTimeIndex = _index + 1
  self:RefreshStallCostItem()
end

function Auction_AuctionUI:SendBuyAuctionOnClick()
  if self:IsMeetStallCost() == false then
    ItemUtility.ClickObtainItemBtn(nil, self.btn_getPath)
    return
  end
  local toServeMsg = {}
  toServeMsg.title = self:GetNoticeNameStr(false)
  if toServeMsg.title == nil or toServeMsg.title == "" then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_8"))
    return
  end
  toServeMsg.position = AuctionData.serverStallPositionData.position
  toServeMsg.stallCost = self.dp_StallTimeIndex
  AuctionController.ReqBuyAuctionPosition(TradeMessage.ReqBuyAuctionPosition, toServeMsg)
end

function Auction_AuctionUI:CloseStallPanel()
  self.panel_Stall:SetActive(false)
end

function Auction_AuctionUI:OnShoutCostOneDPChanged(_control, _index)
  if _index ~= 0 then
    if self.choosedDPIndexList[_index] == nil then
      self.choosedDPIndexList[_index] = _index
    elseif self.choosedDPIndexList[self.dp_ShoutTwoIndex] ~= nil or self.choosedDPIndexList[self.dp_ShoutThreeIndex] ~= nil then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_3"))
      self.dp_ShoutItemOne:SetSelectValue(self.defaultVal1)
      return
    end
  end
  if self.defaultVal1 ~= 0 then
    self.choosedDPIndexList[self.defaultVal1] = nil
  end
  self.defaultVal1 = _index
  self.dp_ShoutOneIndex = _index
end

function Auction_AuctionUI:OnShoutCostTwoDPChanged(_control, _index)
  if _index ~= 0 then
    if self.choosedDPIndexList[_index] == nil then
      self.choosedDPIndexList[_index] = _index
    elseif self.choosedDPIndexList[self.dp_ShoutOneIndex] ~= nil or self.choosedDPIndexList[self.dp_ShoutThreeIndex] ~= nil then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_3"))
      self.dp_ShoutItemTwo:SetSelectValue(self.defaultVal2)
      return
    end
  end
  if self.defaultVal2 ~= 0 then
    self.choosedDPIndexList[self.defaultVal2] = nil
  end
  self.defaultVal2 = _index
  self.dp_ShoutTwoIndex = _index
end

function Auction_AuctionUI:OnShoutCostThreeDPChanged(_control, _index)
  if _index ~= 0 then
    if self.choosedDPIndexList[_index] == nil then
      self.choosedDPIndexList[_index] = _index
    elseif self.choosedDPIndexList[self.dp_ShoutTwoIndex] ~= nil or self.choosedDPIndexList[self.dp_ShoutOneIndex] ~= nil then
      FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_3"))
      self.dp_ShoutIemThree:SetSelectValue(self.defaultVal3)
      return
    end
  end
  if self.defaultVal3 ~= 0 then
    self.choosedDPIndexList[self.defaultVal3] = nil
  end
  self.defaultVal3 = _index
  self.dp_ShoutThreeIndex = _index
end

function Auction_AuctionUI:SendShoutOnClick()
  if self.stallShoutTimeCD > 0 then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_4"))
    return
  end
  if 0 >= #AuctionData.AutoRackTable then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_5"))
    return
  end
  if self:IsMeetShoutCost() == false then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("Stall_2"))
    return
  end
  local toServerMsg = {}
  toServerMsg.id = 20001
  toServerMsg.arg1 = {}
  toServerMsg.arg2 = {}
  local itemsName = ""
  if self:GetChatItemName(self.dp_ShoutOneIndex) ~= nil then
    itemsName = self:GetChatItemName(self.dp_ShoutOneIndex)
  end
  if self:GetChatItemName(self.dp_ShoutTwoIndex) ~= nil then
    itemsName = itemsName .. self:GetChatItemName(self.dp_ShoutTwoIndex)
  end
  if self:GetChatItemName(self.dp_ShoutThreeIndex) ~= nil then
    itemsName = itemsName .. self:GetChatItemName(self.dp_ShoutThreeIndex)
  end
  local coordinateStr = self:GetStallCoordinateStr()
  table.insert(toServerMsg.arg1, itemsName)
  table.insert(toServerMsg.arg1, coordinateStr)
  ChatController.ReqAnnounce(ChatMessage.ReqAnnounce, toServerMsg)
  local stallCityTab = ClientTable.cfg_Auction_stallPositionManager:TryGetValue(AuctionData.stallAuctionInfo.position)
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(stallCityTab.map, "id")
  local posStallArray = string.split(stallCityTab.position, "#")
  UIManager.Show(UIID.ChatUI)
  Chat_ChatUI:ResetChatInfo()
  local posStall = {}
  posStall.x = tonumber(posStallArray[1])
  posStall.y = tonumber(posStallArray[2])
  posStall.mapId = stallCityTab.map
  posStall.scenceName = mapTbl.name
  local systemChat = "%s %s %s h\195\160ng m\225\187\155i l\195\170n k\225\187\135, gi\195\161 \198\176u \196\145\195\163i, v\225\187\139 tr\195\173 s\225\186\161p h\195\160ng %s, hoan ngh\195\170nh c\195\161c \195\180ng ch\225\187\167 \196\145\225\186\191n ch\225\187\141n mua"
  local toServrStr = string.format(systemChat, self:AddChatItemInfo(self.dp_ShoutOneIndex), self:AddChatItemInfo(self.dp_ShoutTwoIndex), self:AddChatItemInfo(self.dp_ShoutThreeIndex), Chat_ChatUI:AddChatInfo(ChatInfoEnum.POS, posStall))
  if posStall.mapId == AuctionStallMap.ShengZhiGuoDu and AuctionData.CheackIsOpenSZGD() then
    Chat_ChatUI:SendMessageChatInfo(toServrStr, ChatChannelEnum.CROSS_REALM)
  else
    Chat_ChatUI:SendMessageChatInfo(toServrStr, ChatChannelEnum.WORLD)
  end
  UIManager.Hide(UIID.ChatUI)
end

function Auction_AuctionUI:AddChatItemInfo(_dpIndex)
  if _dpIndex == nil or _dpIndex == 0 or AuctionData.AutoRackTable[_dpIndex] == nil then
    return ""
  end
  local itemId = AuctionData.AutoRackTable[_dpIndex].item.itemId
  local data = {}
  data.itemData = AuctionData.GetItemConfigInfo(AuctionData.AutoRackTable[_dpIndex].item)
  data.itemData.count = 1
  return Chat_ChatUI:AddChatInfo(ChatInfoEnum.ITEM, data)
end

function Auction_AuctionUI:CloseShoutPanel()
  self.panel_StallShout:SetActive(false)
end

function Auction_AuctionUI:ClearObj()
  for i = 1, #self.PutAwayTab do
    self.PutAwayTab[i]:Destroy()
  end
  self.Button_SaleRackItemTemp:DesToryTable()
  self.PutAwayTab = {}
end

function Auction_AuctionUI:RegistEvents()
  self:RegistEvent(Event.Auction_InitPutAway, self.ShowPutAway, self)
  self:RegistEvent(Event.Auction_InitTab, self.InitTab, self)
  self:RegistEvent(Event.Auction_UpdateAuctionData, self.UpdateAuction, self)
  self:RegistEvent(Event.Auction_Shelf, self.UpdateShelf, self)
  self:RegistEvent(Event.Auction_LookHistory, self.Auction_LookHistory, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBagChange, self)
  self:RegistEvent(Event.HolyRingBagChange, self.RingBagChange, self)
  self:RegistEvent(Event.SacredBoneBagChange, self.SkeletonBagChange, self)
  self:RegistEvent(Event.Auction_UpdatePutAway, self.UpdatePutAway, self)
  self:RegistEvent(Event.Auction_SetPanel, self.Auction_SetPanel, self)
  self:RegistEvent(Event.Auction_excellentPrice, self.Auction_excellentPrice, self)
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
  self:RegistEvent(Event.Auction_LookUnion, self.ShowUnionOrUnionCampData, self)
  self:RegistEvent(Event.Auction_PageAuctionData, self.ShowPageAuction, self)
  self:RegistEvent(Event.UpdateCd, self.UpdateCd, self)
  self:RegistEvent(Event.Auction_SetServerBtn, self.RefreshStrideServerBtn, self)
end

function Auction_AuctionUI:OnCoinChanged()
  self:RefreshCoin()
  self:RefreshUIGrid()
end

function Auction_AuctionUI:RefreshCoin()
  self.coinContainer:SetDataKTable(self.showCoins)
end

function Auction_AuctionUI:RefreshUIGrid()
  if self.panel_Stall:GetActive() then
    return
  end
  self:UpdateAuction()
end

function Auction_AuctionUI:SetButtonPitchOn(ObjTab, Control)
  for k, v in pairs(ObjTab) do
    if v == Control then
      v:GetChild("img_clickeffect"):SetActive(true)
    else
      v:GetChild("img_clickeffect"):SetActive(false)
    end
  end
end

function Auction_AuctionUI:SetArgsPutOn()
  if self.args.itemData then
    self:btn_saleOnClick(self.btn_sale)
    self:openPutOnTipUI(self.args.itemData, AuctionTipOpenType.putOn)
  end
  if self.args.RecomBuy then
    self:RecomBuyShow(self.args.RecomBuy)
  end
  if self.args.openFirstTab then
    if self.args.openFirstTab == AuctionTileTabType.AuctionTab then
      if self.args.openSecondTab then
        self.btn_tabitem.openSecondTabIndex = self.args.openSecondTab
        self.btn_tabitem.openSecondTabObj = self.leftTitleTab[self.args.openSecondTab]
      end
      self:btn_tabitemOnClick(self.btn_tabitem)
    elseif self.args.openFirstTab == AuctionTileTabType.Union then
      if self.args.openSecondTab then
        self.btn_zhan_tab.openSecondTabIndex = self.args.openSecondTab
        self.btn_zhan_tab.openSecondTabObj = self.leftTitleTab[self.args.openSecondTab]
      end
      self:btn_zhan_tabOnClick(self.btn_zhan_tab)
    elseif self.args.openFirstTab == AuctionTileTabType.UnionCamp then
      if self.args.openSecondTab then
        self.btn_UnionCamp.openSecondTabIndex = self.args.openSecondTab
        self.btn_UnionCamp.openSecondTabObj = self.leftTitleTab[self.args.openSecondTab]
      end
      self:btn_UnionCampOnClick(self.btn_UnionCamp)
    elseif self.args.openFirstTab == AuctionTileTabType.History then
      self:btn_myboughtOnClick(self.btn_mybought)
    elseif self.args.openFirstTab == AuctionTileTabType.MyAuction or tonumber(self.args.openFirstTab) == AuctionTileTabType.MyAuction then
      self:btn_saleOnClick(self.btn_sale)
    elseif self.args.openFirstTab == AuctionTileTabType.Holyring_sale then
      self:btn_saleOnClick(self.btn_holyring_sale)
    elseif self.args.openFirstTab == AuctionTileTabType.Holyskeleton_sale then
      self:btn_saleOnClick(self.btn_holyskeleton_sale)
    end
    self:ResetArgsPutOn()
  end
  if self.args.index then
    local tradeTab = AuctionData.filterMeetTabs[AuctionData.TradeScreen.Equip]
    AuctionController.SetSendToServerJson(ConditionJsonEnum.TradeScreenControl_Equip, AuctionData.toServerValue.TradeScreenControl, tradeTab)
    AuctionController.SetSendToServerJson(ConditionJsonEnum.sort, AuctionData.toServerValue.Sort_PriceDown)
    AuctionController.SendReqLsTrade()
  end
end

function Auction_AuctionUI:ResetArgsPutOn()
  for k, v in pairs(self.titleTab) do
    if v.openSecondTabIndex ~= nil or v.openSecondTabObj ~= nil then
      v.openSecondTabIndex = nil
      v.openSecondTabObj = nil
    end
  end
end

function Auction_AuctionUI:openPutOnTipUI(itemData, buyType)
  UIManager.Show(UIID.ItemTipUI, {
    item = itemData,
    rightOperate = EItemOperateType.Show,
    openType = TipsOpenType.AuctionOpen,
    buyType = buyType,
    isUp = true
  })
end

function Auction_AuctionUI:RecomBuyShow(count)
  local cellY = self.Content:GetComponent("GridLayoutGroup").cellSize.y
  local viewY = self.Viewport.transform.localPosition.y
  local X = self.Content.localPosition.x
  local Z = self.Content.localPosition.z
  viewY = cellY * count + viewY
  local pos = Vector3.New(X, viewY, Z)
  self.Content.localPosition = pos
end

function Auction_AuctionUI:SetLoadActive(Active)
  self.loadBg:SetActive(Active)
end

function Auction_AuctionUI:SwitchPrice(beforePrice, itemId)
  local laterPriceCount = beforePrice
  if itemId ~= nil then
    local scaleNum
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
    if itemConfig.salenum == 0 then
      scaleNum = 1
    else
      scaleNum = itemConfig.salenum
    end
    laterPriceCount = math.floor(beforePrice / scaleNum)
  elseif self.MinNum ~= nil then
    laterPriceCount = math.floor(beforePrice / self.MinNum)
  end
  return laterPriceCount
end

function Auction_AuctionUI:GetScaleMaxNum(beforeScaleMaxNum, itemId)
  local laterScaleMaxNum = beforeScaleMaxNum
  if itemId ~= nil then
    local scaleNum
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
    if itemConfig.salenum == 0 then
      scaleNum = 1
    else
      scaleNum = itemConfig.salenum
    end
    laterScaleMaxNum = math.floor(beforeScaleMaxNum / scaleNum) * scaleNum
  elseif self.MinNum ~= nil then
    laterScaleMaxNum = math.floor(beforeScaleMaxNum / self.MinNum) * self.MinNum
  end
  return laterScaleMaxNum
end

function Auction_AuctionUI:SetInputTextColor(inputTextColor, needItemId, needCount)
  if inputTextColor == nil then
    return
  end
  local bagCount = BagInfoData.GetMeetPutOnItemCountByItemId(needItemId)
  local colorCountStr = needCount <= bagCount and Color.paleYellow or Color.red
  inputTextColor.transform:GetComponent("Text").color = colorCountStr
end

function Auction_AuctionUI:ResetInputTextColor(inputTextColor, needItemId, needCount)
  if inputTextColor == nil then
    return
  end
  inputTextColor.transform:GetComponent("Text").color = Color.paleYellow
end

function Auction_AuctionUI:ResetDropDownCommpent(dropDownTrans, dropIndex, isSynchToServer, filterType)
  if dropDownTrans == nil then
    return
  end
  if dropIndex == nil then
    dropIndex = 0
  end
  dropDownTrans.isSynchToServer = isSynchToServer
  dropDownTrans:SetSelectValue(dropIndex)
  self:RefreshFilterType(dropDownTrans, dropIndex, filterType)
end

function Auction_AuctionUI:CreateUITableView()
  if self.CurrentTab ~= AuctionRecTimer.History then
    return
  end
  self.tableView = UITableView()
  self.tableView:SetLowerMargin(0)
  self.tableView:SetScrollView(self.Scroll_TradeHistory)
  self.tableView:SetScalarForCellInTableView(self, self.ScalarForCellInTableView)
  self.tableView:SetUpperMargin(0)
  self.tableView:SetTotalCellCount(self, self.NumberOfCellsInTableView)
  self.tableView:SetCellAtIndexInTableView(self, self.CellAtIndexInTableView)
  self.tableView:SetCellAtIndexInTableViewWillAppear(self, self.CellAtIndexInTableViewWillAppear)
  self.tableView:ReloadData(1)
end

function Auction_AuctionUI:ScalarForCellInTableView()
  local _, sizeY = self.historyItemTemplate:GetSizeDelta()
  return sizeY
end

function Auction_AuctionUI:NumberOfCellsInTableView()
  return #AuctionData.MyHistoryData
end

function Auction_AuctionUI:CellAtIndexInTableView(index)
  return self.tableView:ReuseOrCreateCell(self.historyItemTemplate)
end

function Auction_AuctionUI:CellAtIndexInTableViewWillAppear(index)
  local tradeData = AuctionData.MyHistoryData[index]
  local tradeCell = self.tableView:GetLoadedCell(index)
  local Bg = tradeCell:GetChild("img_frame")
  local lab_name = tradeCell:GetChild("lab_name")
  local lab_time = tradeCell:GetChild("lab_time")
  local lab_state = tradeCell:GetChild("lab_state")
  local lab_price = tradeCell:GetChild("price/lab_value")
  local img_priceIcon = tradeCell:GetChild("price/img_icon")
  local buyType = AuctionTipOpenType.appoint
  local itemInfo = ItemUtility.GenerateItemData(tradeData.itemId)
  local titleStr = string.GetColorText(itemInfo.tblItem.name, ItemQuality2ColorDic[itemInfo.tblItem.colorShow])
  if tradeData.count > 1 then
    lab_name:SetText(titleStr .. "*" .. tradeData.count)
  else
    lab_name:SetText(titleStr)
  end
  lab_time:SetText(TimeUtility.SwitchTimeStamp(tradeData.time * 1000))
  local item = ClientTable.cfg_Item_itemManager:TryGetValue(tradeData.itemId, "id")
  if item.auction ~= nil and item.auction ~= "" then
    local currencyId = string.split(string.split(item.auction, "&")[1], "#")[2]
    local currencyTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(currencyId), "id")
    self:SetSprite("Atlas_Common", currencyTab.icon, img_priceIcon, false)
  end
  local price = tradeData.price
  if tradeData.type == AuctionHistoryType.sell then
    lab_state:SetText((string.GetColorText(LocalizationUtility.GetContentByKey("Auction_sell"), ItemQuality2ColorDic[5])))
    lab_price:SetText(string.GetColorText("+" .. price, ItemQuality2ColorDic[5]))
  elseif tradeData.type == AuctionHistoryType.buy then
    lab_state:SetText((string.GetColorText(LocalizationUtility.GetContentByKey("Auction_buy"), ItemQuality2ColorDic[7])))
    lab_price:SetText(string.GetColorText("-" .. price, ItemQuality2ColorDic[7]))
  elseif tradeData.type == AuctionHistoryType.appoint then
    lab_state:SetText((string.GetColorText(LocalizationUtility.GetContentByKey("Auction_subscribe"), ItemQuality2ColorDic[7])))
    lab_price:SetText(string.GetColorText("-" .. price, ItemQuality2ColorDic[7]))
  else
    lab_state:SetText((string.GetColorText("Ho\195\160n ti\225\187\129n \196\145\225\186\183t mua", ItemQuality2ColorDic[5])))
    lab_price:SetText(string.GetColorText("+" .. price, ItemQuality2ColorDic[5]))
  end
  Bg:SetActive(index % 2 == 0)
  tradeCell:SetActive(true)
end

function Auction_AuctionUI:SetScrollSubContent(subContentDeltaY, subContent, auctionTabType)
  if subContent.gameObject.activeSelf then
    subContent:SetActive(false)
    self:SetScrollMainContent()
  else
    for i = 1, #self.leftTitleSubContentTab do
      if self.leftTitleSubContentTab[i] ~= subContent then
        self.leftTitleSubContentTab[i]:SetActive(false)
      end
    end
    subContent.transform.sizeDelta = Vector2(subContent.transform.sizeDelta.x, subContentDeltaY)
    self.MainContent.transform.sizeDelta = Vector2(self.MainContent.transform.sizeDelta.x, self:GetMainContentDeltaY() + subContentDeltaY)
    local verticalLayoutGroup = subContent.transform:GetComponent("VerticalLayoutGroup")
    verticalLayoutGroup:CalculateLayoutInputVertical()
    verticalLayoutGroup:SetLayoutVertical()
    subContent:SetActive(true)
  end
end

function Auction_AuctionUI:SetScrollMainContent()
  self.subContent_equip:SetActive(false)
  self.subContent_material:SetActive(false)
  self.subContent_diamond:SetActive(false)
  self.subContent_suitEquip:SetActive(false)
  self.subContent_jewelryEquip:SetActive(false)
  self.subContent_holySpirit:SetActive(false)
  self.subContent_holyring:SetActive(false)
  self.subContent_holyskeleton:SetActive(false)
  self.MainContent.transform.sizeDelta = Vector2(self.MainContent.transform.sizeDelta.x, self:GetMainContentDeltaY())
  local verticalLayoutGroup = self.MainContent.transform:GetComponent("VerticalLayoutGroup")
  verticalLayoutGroup:CalculateLayoutInputVertical()
  verticalLayoutGroup:SetLayoutVertical()
  self.MainContent:SetActive(true)
end

function Auction_AuctionUI:GetSubContentDeltaY(contentTabList)
  local subSpacing = 7
  local subTagCount = #contentTabList
  local subContentDeltaY = subTagCount * 34 + (subTagCount - 1) * subSpacing
  return subContentDeltaY
end

function Auction_AuctionUI:GetMainContentDeltaY()
  local mainTagCount = 0
  if self.CurrentTab == AuctionRecTimer.Union then
    mainTagCount = #AuctionData.LeftTagTabList - 2
  else
    mainTagCount = #AuctionData.LeftTagTabList
  end
  local mainSpacing = 2
  self.mainContentDeltaY = mainTagCount * 50 + (mainTagCount - 1) * mainSpacing
  return self.mainContentDeltaY
end

function Auction_AuctionUI:GetDefaultGradeByLv()
  local globalTab = ClientTable.cfg_Global_globalManager:TryGetValue(1170005)
  local infoArray = string.split(globalTab.effect, "&")
  local roleLevel = ViewData.meData.level
  local curGrade = 1
  for i = 1, #infoArray do
    local info = string.split(infoArray[i], "#")
    local minLv = tonumber(info[2])
    local maxLv = tonumber(info[3])
    if roleLevel >= minLv and roleLevel <= maxLv then
      curGrade = tonumber(info[1])
      break
    end
  end
  for key, value in pairs(AuctionData.EquipClassInfo) do
    if curGrade >= value.minClass and curGrade <= value.maxClass then
      return value.dpIndex
    end
  end
  return 0
end

function Auction_AuctionUI:GetExcellentWeight(itemId, excellenceList)
  local equipTab = ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
  local excellentWeight = 0
  local excellentFactor = 0
  if equipTab and (equipTab.excellentNumber ~= "" or equipTab.createNumber ~= "" or equipTab.createFixedExcellent ~= "") then
    if excellenceList ~= nil and equipTab.suitId ~= "" then
      for i = 1, #excellenceList do
        local equipExcellenceTab = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(excellenceList[i])
        excellentWeight = excellentWeight + equipExcellenceTab.excellentAddition / 10000
      end
      excellentFactor = excellentFactor + #excellenceList
    end
    local equipSubType = equipTab.subType
    if self.excellFactorConfig[equipSubType] == nil then
      equipSubType = 0
    end
    if self.excellFactorConfig[equipSubType] ~= nil then
      for key, value in pairs(self.excellFactorConfig[equipSubType]) do
        if value.num == excellentFactor then
          excellentFactor = value.factor / 10000
          break
        end
      end
    end
  end
  if excellentWeight == 0 then
    excellentWeight = 1
  end
  if excellentFactor == 0 then
    excellentFactor = 1
  end
  return excellentWeight * excellentFactor
end

function Auction_AuctionUI:InitStalButtonState()
  self.btn_bgStallFrame:SetActive(false)
  self.panel_Stall:SetActive(false)
  self.panel_StallShout:SetActive(false)
  if AuctionData.isOwnSelfStall then
    self.mainlab_OpenStall:SetText("Xem s\225\186\161p h\195\160ng")
    self.go_noStall:SetActive(false)
    self.go_yesStall:SetActive(true)
    if self.stallCountTimeObj then
      Timer.Stop(self.stallCountTimeObj)
      self.stallCountTimeObj = nil
    end
    local stallCountTime = AuctionData.stallAuctionInfo.endTime - Time.GetServerSecondTime()
    self.stallCountTimeObj = Timer.StartLoop(1, stallCountTime, function()
      if 1 <= stallCountTime then
        stallCountTime = stallCountTime - 1
        local timeStr = TimeUtility.ShowTimeReserveWithColon(stallCountTime)
        self.mainLab_stallTime:SetText(timeStr)
      else
        self.mainLab_stallTime:SetText("00:00:00")
      end
    end)
  else
    self.mainlab_OpenStall:SetText("M\225\187\159 b\195\160y b\195\161n")
    self.go_noStall:SetActive(true)
    self.go_yesStall:SetActive(false)
  end
end

function Auction_AuctionUI:InitOpenStallPanel()
  self:InitStallNoticeDropList()
  self:RefreshStallNoticeName()
  self:InitStallCityDropList()
  self:InitStallTimeDropList()
  self:RefreshStallCostItem()
  local toServeMsg = {}
  toServeMsg.type = self.stallMapTabList[self.dp_StallCityIndex].id
  AuctionController.ReqAuctionStallPosition(TradeMessage.ReqAuctionStallPosition, toServeMsg)
end

function Auction_AuctionUI:InitStallNoticeDropList()
  if self.chooseNoticeTabList == nil then
    self.chooseNoticeTabList = {}
    local stallNameTabList = ClientTable.cfg_Auction_stallNameManager:GetDic()
    local container = self.sw_stallNoticeContent.transform:GetComponent("UIScrollContainer")
    container.MaxCount = table.count(stallNameTabList)
    for i, v in pairs(stallNameTabList) do
      local goTrans = container:GetScrollGoByIndex(i - 1).transform
      local label = UIControl(goTrans, "Label")
      local objControl = UIControl(goTrans)
      local choBg = UIControl(goTrans, "choBg")
      local checkmark = UIControl(goTrans, "Background/Checkmark")
      label:SetText(v.name)
      objControl:SetIsOn(false)
      choBg:SetActive(false)
      checkmark:SetActive(false)
      objControl.stallNameTab = v
      objControl:SetOnToggleChanged(self, self.ChooseNoticeTogChanged)
    end
    local mainSpacing = 8
    self.sw_stallNoticeContentY = math.ceil(container.MaxCount / 3) * 44 + (math.ceil(container.MaxCount / 3) - 1) * mainSpacing
    self.sw_stallNoticeContent.transform.sizeDelta = Vector2(self.sw_stallNoticeContent.transform.sizeDelta.x, self.sw_stallNoticeContentY)
  else
    for i, value in pairs(self.chooseNoticeTabList) do
      local infoTab = value
      local choBg = UIControl(infoTab.toggle.transform, "choBg")
      local checkmark = UIControl(infoTab.toggle.transform, "Background/Checkmark")
      choBg:SetActive(false)
      checkmark:SetActive(false)
    end
    self.chooseNoticeTabList = {}
  end
end

function Auction_AuctionUI:InitStallCityDropList()
  self.stallMapTabList = {}
  self.stallCityRemainStall = {}
  self.stallCityMapTabList = {}
  self.stallCityTabList, self.stallCityMapTabList, self.stallCityRemainStall = AuctionController.GetStallMapType()
  local mapIndex = 1
  self.dp_StallCity.dropdown:ClearOptions()
  for i, v in pairs(self.stallCityMapTabList) do
    local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(v.map, "id")
    self.stallMapTabList[mapIndex] = mapTab
    self.dp_StallCity.dropdown:AddOption(mapTab.name)
    mapIndex = mapIndex + 1
  end
  self.dp_StallCityIndex = 1
  self.dp_StallCity:SetSelectValue(self.dp_StallCityIndex - 1)
end

function Auction_AuctionUI:InitStallTimeDropList()
  if self.stallTabList == nil then
    self.dp_StallTime.dropdown:ClearOptions()
    self.stallTabList = ClientTable.cfg_Auction_stallManager:GetDic()
    for i, v in pairs(self.stallTabList) do
      self.dp_StallTime.dropdown:AddOption(tostring(math.floor(v.stallTime / 1000 / 60 / 60)) .. " gi\225\187\157")
    end
  end
  self.dp_StallTimeIndex = 1
  self.dp_StallTime:SetSelectValue(0)
end

function Auction_AuctionUI:RefreshStallNoticeName()
  local noticeNameStr = self:GetNoticeNameStr(true)
  self.lab_stallNoticeName:SetText(noticeNameStr)
end

function Auction_AuctionUI:RefreshStallChooseCity()
  local mapTabId = AuctionData.serverStallPositionData.type
  local enoughNum = AuctionData.serverStallPositionData.enoughNum
  local str = "(S\225\186\161p h\195\160ng tr\225\187\145ng" .. enoughNum .. "/" .. self.stallCityRemainStall[mapTabId].stallPosCount .. ")"
  self.lab_stallCityCount:SetText(str)
end

function Auction_AuctionUI:RefreshStallRandomPos()
  local mapTabId = AuctionData.serverStallPositionData.type
  local mapTab = ClientTable.cfg_Map_mapManager:TryGetValue(mapTabId, "id")
  local stallCityId = AuctionData.serverStallPositionData.position
  local stallCityTab = self.stallCityTabList[stallCityId]
  local positionArray = string.split(stallCityTab.position, "#")
  local coordinateStr = mapTab.name .. ":" .. positionArray[1] .. "," .. positionArray[2]
  self.lab_RandomPos:SetText(coordinateStr)
end

function Auction_AuctionUI:RefreshStallCostItem()
  if self.stallTabList == nil then
    return
  end
  local costItemInfo = self.stallTabList[self.dp_StallTimeIndex].stallCost
  local itemId = tonumber(costItemInfo[1])
  local costCount = tonumber(costItemInfo[2])
  local haveCount = BagInfoData.GetItemCountByItemConfigId(itemId)
  local itemCellData = ItemCellData()
  local itemData = ItemUtility.GenerateItemData(itemId)
  itemData.count = costCount
  itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.item_StallConsume, itemCellData, self, true)
  self.btn_getPath.itemData = itemData
  self.btn_getPath.OpenTipsType = EOpenTipsType.FastBuy
  self.btn_getPath:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  local costColorStr = ""
  if costCount <= haveCount then
    costColorStr = ItemQuality2ColorDic[5]
  else
    costColorStr = ItemQuality2ColorDic[7]
  end
  local strDis = string.format("<color=%s>%d</color>/%d", costColorStr, haveCount, costCount)
  self.lab_StallConsumeNum:SetText(strDis)
end

function Auction_AuctionUI:RefreshStallOnPosChange()
  self:RefreshStallChooseCity()
  self:RefreshStallRandomPos()
end

function Auction_AuctionUI:InitShoutPanel()
  self:InitShoutGoodsDPList()
  self:InitShoutCDTime()
  self:InitShoutStallPos()
  self:RefreshShoutCostItem()
end

function Auction_AuctionUI:InitShoutGoodsDPList()
  self.choosedDPIndexList = {}
  self.defaultVal1 = 0
  self.defaultVal2 = 0
  self.defaultVal3 = 0
  self.dp_ShoutOneIndex = 0
  self.dp_ShoutTwoIndex = 0
  self.dp_ShoutThreeIndex = 0
  self.dp_ShoutItemOne.dropdown:ClearOptions()
  self.dp_ShoutItemTwo.dropdown:ClearOptions()
  self.dp_ShoutIemThree.dropdown:ClearOptions()
  local dp_ShoutCostTips = "Kh\195\180ng c\195\179 v\225\186\173t ph\225\186\169m"
  self.dp_ShoutItemOne.dropdown:AddOption(dp_ShoutCostTips)
  self.dp_ShoutItemTwo.dropdown:AddOption(dp_ShoutCostTips)
  self.dp_ShoutIemThree.dropdown:AddOption(dp_ShoutCostTips)
  for i, v in pairs(AuctionData.AutoRackTable) do
    local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(AuctionData.AutoRackTable[i].item.itemId, "id")
    self.dp_ShoutItemOne.dropdown:AddOption(itemTab.name)
    self.dp_ShoutItemTwo.dropdown:AddOption(itemTab.name)
    self.dp_ShoutIemThree.dropdown:AddOption(itemTab.name)
  end
end

function Auction_AuctionUI:InitShoutStallPos()
  local coordinateStr = self:GetStallCoordinateStr()
  self.lab_ShoutStallPos:SetText(coordinateStr)
end

function Auction_AuctionUI:InitShoutCDTime()
  local cdMap = RoleManager.me.data.cdMap[20001]
  if cdMap ~= nil then
    if cdMap.endTime == 0 or cdMap.endTime == nil then
      self.stallShoutTimeCD = 0
      self.lab_sendShoutCD:SetText(string.format("G\225\187\173i chat (%d)", 0))
    else
      self.stallShoutTimeCD = math.floor(cdMap.endTime / 1000 - Time.GetServerSecondTime())
      self:StartShoutTimeDown()
    end
  else
    self.stallShoutTimeCD = 0
    self.lab_sendShoutCD:SetText("G\225\187\173i chat")
  end
end

function Auction_AuctionUI.UpdateCd(_this, id, msg)
  if msg.key and msg.type == 29 then
    _this.stallShoutTimeCD = math.floor(msg.endTime / 1000 - Time.GetServerSecondTime())
    _this:StartShoutTimeDown()
  end
end

function Auction_AuctionUI:StartShoutTimeDown()
  if self.stallShoutTimeCD <= 0 then
    self.stallShoutTimeCD = 0
    self.lab_sendShoutCD:SetText("G\225\187\173i chat")
    return
  end
  if self.stallShoutCDObj then
    Timer.Stop(self.stallShoutCDObj)
    self.stallShoutCDObj = nil
  end
  self.stallShoutCDObj = Timer.StartLoop(1, self.stallShoutTimeCD, function()
    if self.stallShoutTimeCD >= 1 then
      self.stallShoutTimeCD = self.stallShoutTimeCD - 1
      self.lab_sendShoutCD:SetText(string.format("G\225\187\173i chat (%d)", self.stallShoutTimeCD))
    else
      self.lab_sendShoutCD:SetText(string.format("G\225\187\173i chat"))
    end
  end)
end

function Auction_AuctionUI:RefreshShoutCostItem()
  local globalTab = ClientTable.cfg_Global_globalManager:TryGetValue(1170003)
  local infoArray = string.split(globalTab.effect, "#")
  local itemId = tonumber(infoArray[1])
  local costCount = tonumber(infoArray[2])
  local itemCellData = ItemCellData()
  local itemData = ItemUtility.GenerateItemData(itemId)
  local haveCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  local costStr = ""
  if costCount <= haveCount then
    costStr = string.GetColorText(costCount, ItemQuality2ColorDic[5])
  else
    costStr = string.GetColorText(costCount, ItemQuality2ColorDic[7])
  end
  itemData.count = costStr
  itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.item_Shout3DItem, itemCellData, self, true)
  self.lab_costNum:SetActive(false)
end

function Auction_AuctionUI:GetChatItemName(_dpIndex)
  local itemName
  if _dpIndex == nil or _dpIndex == 0 or AuctionData.AutoRackTable[_dpIndex] == nil then
    itemName = nil
  else
    local itemId = AuctionData.AutoRackTable[_dpIndex].item.itemId
    local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(itemId)
    itemName = "[" .. itemTab.name .. "]"
  end
  return itemName
end

function Auction_AuctionUI:GetNoticeNameStr(isUsedClient)
  local showStr = ""
  local index = 1
  local maxCount = table.count(self.chooseNoticeTabList)
  for i, value in pairs(self.chooseNoticeTabList) do
    if value ~= nil then
      if isUsedClient then
        showStr = showStr .. value.stallNameTab.name
      else
        if index == maxCount then
          showStr = showStr .. value.stallNameTab.name
        else
          showStr = showStr .. value.stallNameTab.name .. "#"
        end
        index = index + 1
      end
    end
  end
  return showStr
end

function Auction_AuctionUI:GetStallCoordinateStr()
  local stallPositionTabId = AuctionData.stallAuctionInfo.position
  local stallCityTab = ClientTable.cfg_Auction_stallPositionManager:TryGetValue(stallPositionTabId)
  local positionArray = string.split(stallCityTab.position, "#")
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(stallCityTab.map, "id")
  local coordinateStr = mapTbl.name .. ":" .. positionArray[1] .. "," .. positionArray[2]
  return coordinateStr
end

function Auction_AuctionUI:IsMeetShoutCost()
  local globalTab = ClientTable.cfg_Global_globalManager:TryGetValue(1170003)
  local infoArray = string.split(globalTab.effect, "#")
  local itemId = tonumber(infoArray[1])
  local costCount = tonumber(infoArray[2])
  local haveCount = BagInfoData.GetItemTotalCountByItemId(itemId)
  return costCount <= haveCount
end

function Auction_AuctionUI:IsMeetStallCost()
  if self.stallTabList == nil then
    return false
  end
  local costItemInfo = self.stallTabList[self.dp_StallTimeIndex].stallCost
  local itemId = costItemInfo[1]
  local costCount = costItemInfo[2]
  local haveCount = BagInfoData.GetItemCountByItemConfigId(itemId)
  return costCount <= haveCount
end

function Auction_AuctionUI:ShowAuctionTax()
  local cfg_Gloab = ClientTable.cfg_Global_globalManager:TryGetValue(2310005)
  local infoArray = string.split(cfg_Gloab.effect, "#")
  local auctionTax = tonumber(infoArray[1]) * 0.01
  local unionTax = tonumber(infoArray[2]) * 0.01
  if AuctionData.CheackIsOpenSZGD() then
    self.jiaoyishuiTxt:SetText(string.format("Thu\225\186\191 giao d\225\187\139ch Li\195\170n SV %d%%" .. "Thu\225\186\191 giao d\225\187\139ch %d%%", auctionTax, auctionTax))
  else
    self.jiaoyishuiTxt:SetText(string.format("Thu\225\186\191 giao d\225\187\139ch %d%%", auctionTax))
  end
end

function Auction_AuctionUI:CheckMainTabSendReq(_clickTab)
  local isNotSendReq = self.mainTabType == _clickTab
  if not isNotSendReq then
    AuctionData.isSlider = false
    AuctionData.page = 1
    self.leftMainTabType = AuctionTabType.None
    self.leftSubTabType = AuctionLeftSubTabType.None
  end
  return false
end

function Auction_AuctionUI:CheckLeftMainTabSendReq(_clickTab)
  local isNotSendReq = self.leftMainTabType == _clickTab
  if not isNotSendReq then
    AuctionData.isSlider = false
    AuctionData.page = 1
    self.leftSubTabType = AuctionLeftSubTabType.None
  end
  return false
end

function Auction_AuctionUI:CheckLeftSubTabSendReq(_clickTab)
  local isNotSendReq = self.leftSubTabType == _clickTab
  if not isNotSendReq then
    AuctionData.isSlider = false
    AuctionData.page = 1
  end
  return false
end
