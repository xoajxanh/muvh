Vip_exchangeUI = class(BaseUI)
Vip_exchangeUI.layer = UILayer.Panel
Vip_exchangeUI.orderInLayer = 4
Vip_exchangeUI.hideType = UIHideType.Hide
Vip_exchangeUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_exchangeUI.escClose = UIEscClose.DontClose

function Vip_exchangeUI:InitControls()
  self.Open = self:GetControl("Open")
  self.btn_closeBg = self:GetControl("Open/btn_closeBg")
  self.lab_title = self:GetControl("Open/bg_vip/lab_title")
  self.btn_close = self:GetControl("Open/bg_vip/btn_close")
  self.lab_exchangeNum = self:GetControl("Open/bg_vip/lab_exchangeNum")
  self.go_exchangeMode = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode")
  self.go_everydayRecharge = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_everydayRecharge")
  self.btn_everydayRecharge = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_everydayRecharge/btn_everydayRecharge")
  self.go_preferentialRecharge = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_preferentialRecharge")
  self.btn_preferentialRecharge = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_preferentialRecharge/btn_preferentialRecharge")
  self.btn_SmallItem = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/lab_price/btn_SmallItem")
  self.btn_exchangeItem = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/lab_exchange/btn_exchangeItem")
  self.btn_exchange = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/btn_exchange")
  self.lab_exchange = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/btn_exchange/lab_exchange")
  self.img_redPointfunc = self:GetControl("Open/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode/img_redPointfunc")
  self.bg_tips = self:GetControl("Open/bg_vip/bg_tips")
  self.rechargeMember_des = self:GetControl("Open/bg_vip/rechargeMember_des")
  self.btn_recharge = self:GetControl("Open/bg_vip/btn_recharge")
  self.lab_recharge = self:GetControl("Open/bg_vip/btn_recharge/lab_recharge")
  self.lab_tips = self:GetControl("Open/bg_vip/lab_tips")
end

function Vip_exchangeUI:OnPreLoad()
end

function Vip_exchangeUI:GetMemberDataMgr()
  if gameMgr:GetAvatarManager() then
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr()
  end
  return nil
end

function Vip_exchangeUI:Init()
  self:InitParams()
end

function Vip_exchangeUI:InitParams()
  self.ExchangeData = CommercializeData.ExchangeNewMemberInfo()
  self.remainStrFormat = Localization.GetUIWord("Newmember_5")
  self.errorLog = Localization.GetUIWord("Newmember_7")
  self.obtainIDs = {900, 901}
end

function Vip_exchangeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnExchangeCreat(ctr)
  ctr.lab_priceNum = UIControl(ctr.transform, "lab_price/lab_priceNum")
  ctr.lab_exchangeNum = UIControl(ctr.transform, "lab_exchange/lab_exchangeNum")
  ctr.btn_exchange = UIControl(ctr.transform, "btn_exchange")
  ctr.btn_SmallItemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "lab_price/btn_SmallItem"))
  ctr.btn_SmallmodelData = ItemCellData()
  ctr.exchangeItemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "lab_exchange/btn_exchangeItem"))
  ctr.exchangeItemData = ItemCellData()
end

function Vip_exchangeUI:InitUI()
  local function OnExchangeRefreshFunc(ctr, index, data, ui)
    self:OnExchangeRefresh(ctr, index, data, ui)
    
    if self.ExchangeData and index == table.count(self.ExchangeData) then
      self.go_everydayRecharge:SetSiblingIndex(index + 2)
      self.go_preferentialRecharge:SetSiblingIndex(index + 3)
    end
  end
  
  self.ExchangeContainer = UIContainer(self.go_exchangeMode, self, OnExchangeCreat, OnExchangeRefreshFunc)
end

function Vip_exchangeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Vip_exchangeUI:OnHide()
end

function Vip_exchangeUI:OnDestroy()
end

function Vip_exchangeUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_recharge:SetOnClick(self, self.btn_rechargeOnClick)
  self.btn_everydayRecharge:SetOnClick(self, self.everydayRechargeOnClick)
  self.btn_preferentialRecharge:SetOnClick(self, self.preferentialRechargeOnClick)
end

function Vip_exchangeUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Vip_exchangeUI)
end

function Vip_exchangeUI:btn_exchangeOnClick(control)
  if self.countData == nil then
    return
  end
  if self.countData.buyExpNum >= self.countData.buyExpNumLimit then
    FloatingTipUtility.QuickMsg(self.errorLog)
    return
  end
  if BagInfoData.GetItemTotalCountByItemId(control.moneyitem) < control.mun then
    local BusinessPay
    if control.moneyitem == ECoinsType.gem then
      BusinessPay = BusinessPayType.Vvip
    end
    if control.moneyItemData then
      UIManager.Show(UIID.ItemTipUI, {
        item = control.moneyItemData,
        rightOperate = EItemOperateType.Show,
        ctrl = control.moneyItemData,
        ShowObtain = true,
        BusinessPay = BusinessPay
      })
    end
    return
  end
  NetManager.Send(ItemBuyMessage.ReqBuy, {
    goodId = control.id,
    buyCount = 1
  })
end

function Vip_exchangeUI:btn_rechargeOnClick(control)
  if self.buyInfo == nil or self.buyInfo.type == nil then
    return
  end
  if self.buyInfo.type == EBuyMethodType.BuyTips then
    UIManager.Show(UIID.Vip_Member_PromptUI, {
      memberId = self.curMemberLevel + 1,
      buyInfo = self.buyInfo
    })
  elseif self.buyInfo.type == EBuyMethodType.Recharge then
    if self.buyInfo.shopId then
      local rechargeTbl = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(self.buyInfo.shopId)
      if rechargeTbl then
        DataToCSharpMgr.Pay({
          amount = rechargeTbl.rmb,
          product_Id = self.buyInfo.shopId
        })
      end
    end
  elseif self.buyInfo.type == EBuyMethodType.JumpPanel then
    NavigationUtility.ClickNavigationByNavId(tonumber(self.buyInfo.shopId))
  end
end

function Vip_exchangeUI:everydayRechargeOnClick(control)
  if self.everydayObtainTbl then
    UIManager.JumpShow(UIPanelType.SortAndHide, self.everydayObtainTbl.name, self.everydayObtainArgs)
  end
end

function Vip_exchangeUI:preferentialRechargeOnClick(control)
  if self.preferentialObtainTbl then
    UIManager.JumpShow(UIPanelType.SortAndHide, self.preferentialObtainTbl.name, self.preferentialObtainArgs)
  end
end

function Vip_exchangeUI:RegistEvents()
  self:RegistEvent(Event.MemberLevelChanged, self.MemberLevelChangedCallBack, self)
  self:RegistEvent(Event.MemberBuyExpCountChanged, self.MemberBuyExpCountChangedCallBack, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChangeCallBack, self)
end

function Vip_exchangeUI:MemberLevelChangedCallBack()
  self:RefreshData()
  self:RefreshMemberLevelView()
  self:RefreshBuyView()
end

function Vip_exchangeUI:MemberBuyExpCountChangedCallBack()
  self:RefreshData()
  self:RefreshTopView()
end

function Vip_exchangeUI:Bag_ResBagChangeCallBack()
  self:RefreshListView()
end

function Vip_exchangeUI:Refresh()
  if self:GetMemberDataMgr() == nil then
    return
  end
  self:RefreshData()
  self:RefreshView()
end

function Vip_exchangeUI:RefreshData()
  self.countData = self:GetMemberDataMgr():GetBuyExpCountData()
  self.buyInfo = self:GetMemberDataMgr():GetMemberCurBuyInfo()
  local curLevel = self:GetMemberDataMgr():GetMemberLevle()
  self.curTbl = ClientTable.cfg_MemberManager:TryGetValue(curLevel)
  if self.obtainIDs then
    if table.count(self.obtainIDs) > 0 then
      self.everydayObtainTbl = ClientTable.cfg_Obtain_obtainManager:TryGetValue(self.obtainIDs[1])
      if self.everydayObtainTbl then
        self.everydayObtainArgs = {
          openFirstTab = self.everydayObtainTbl.subSubType,
          openSecondTab = self.everydayObtainTbl.position,
          itemBuyID = self.everydayObtainTbl.itemBuyID,
          shopID = self.everydayObtainTbl.shopId
        }
      end
    end
    if table.count(self.obtainIDs) > 1 then
      self.preferentialObtainTbl = ClientTable.cfg_Obtain_obtainManager:TryGetValue(self.obtainIDs[2])
      if self.preferentialObtainTbl then
        self.preferentialObtainArgs = {
          openFirstTab = self.preferentialObtainTbl.subSubType,
          openSecondTab = self.preferentialObtainTbl.position,
          itemBuyID = self.preferentialObtainTbl.itemBuyID,
          shopID = self.preferentialObtainTbl.shopId
        }
      end
    end
  end
end

function Vip_exchangeUI:RefreshView()
  self:RefreshTopView()
  self:RefreshListView()
  self:RefreshMemberLevelView()
  self:RefreshBuyView()
end

function Vip_exchangeUI:RefreshTopView()
  if self.countData then
    local curCount = self.countData.buyExpNumLimit - self.countData.buyExpNum
    local color = curCount ~= 0 and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
    self.lab_exchangeNum:SetText(string.format(self.remainStrFormat, string.GetColorText(curCount, color) .. "/" .. self.countData.buyExpNumLimit))
  end
end

function Vip_exchangeUI:RefreshListView()
  if self.ExchangeData then
    self.ExchangeContainer:SetData(self.ExchangeData)
  else
    self.ExchangeContainer:SetData({})
  end
  if self.everydayObtainTbl and ConditionManager.Check4D(self.everydayObtainTbl.condition) then
    self.go_everydayRecharge:SetActive(true)
  else
    self.go_everydayRecharge:SetActive(false)
  end
  if self.preferentialObtainTbl and ConditionManager.Check4D(self.preferentialObtainTbl.condition) then
    self.go_preferentialRecharge:SetActive(true)
  else
    self.go_preferentialRecharge:SetActive(false)
  end
end

function Vip_exchangeUI:OnExchangeRefresh(ctr, _, data, ui)
  local cost = string.split(data.cost, "#")
  local moneyitem = tonumber(cost[1])
  local mun = tonumber(cost[2])
  ctr.btn_exchange.moneyItemData = ItemUtility.GenerateItemData(EBindCoinsType[tonumber(moneyitem)])
  ctr.btn_SmallmodelData:RefreshData(ctr.btn_exchange.moneyItemData)
  ItemUtility.ShowItemCell(ctr.btn_SmallItemCtr, ctr.btn_SmallmodelData, ui, true)
  local MoneyCount = BagInfoData.GetItemTotalCountByItemId(tonumber(moneyitem))
  local color = mun <= MoneyCount and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  ctr.lab_priceNum:SetText(string.GetColorText(mun, color))
  local reward = string.split(data.reward, "#")
  local rewardcount = tonumber(reward[2])
  local btn_exchanges = ItemUtility.GenerateItemData(tonumber(reward[1]))
  ctr.exchangeItemData:RefreshData(btn_exchanges)
  ItemUtility.ShowItemCell(ctr.exchangeItemCtr, ctr.exchangeItemData, ui, true)
  ctr.lab_exchangeNum:SetText(rewardcount)
  ctr.btn_exchange.id = data.id
  ctr.btn_exchange.moneyitem = moneyitem
  ctr.btn_exchange.mun = mun
  ctr.btn_exchange:SetOnClick(ui, ui.btn_exchangeOnClick)
end

function Vip_exchangeUI:RefreshMemberLevelView()
  if self.curTbl and self.curTbl.tips3 ~= "" then
    self.lab_tips:SetText(Localization.GetUIWord(self.curTbl.tips3))
  else
    self.lab_tips:SetText("")
  end
end

function Vip_exchangeUI:RefreshBuyView()
  if self.curTbl then
    self.rechargeMember_des:SetText(self.curTbl.buyName)
  else
    self.rechargeMember_des:SetText("")
  end
  self.btn_recharge:SetActive(self.buyInfo ~= nil and self.buyInfo.type ~= 0)
  self.bg_tips:SetActive(self.buyInfo ~= nil and self.buyInfo.type ~= 0)
end
