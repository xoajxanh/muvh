Shop_ShopUI = class(BaseUI)
Shop_ShopUI.layer = UILayer.Panel
Shop_ShopUI.orderInLayer = 3
Shop_ShopUI.hideType = UIHideType.Destroy
Shop_ShopUI.hideFunc = UIHideFunc.MoveOutOfScreen
Shop_ShopUI.escClose = UIEscClose.DontClose

function Shop_ShopUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.lab_title = self:GetControl("bg_shop/lab_title")
  self.btn_close = self:GetControl("bg_shop/btn_close")
  self.go_money = self:GetControl("bg_shop/grid_money/go_money")
  self.btn_money = self:GetControl("bg_shop/grid_money/go_money/btn_money")
  self.tog_shop = self:GetControl("grid_shop/tog_shop")
  self.tog_type = self:GetControl("grid_type/tog_type")
  self.go_item = self:GetControl("scroll_shop/Viewport/Content/go_item")
  self.lab_buy = self:GetControl("scroll_shop/Viewport/Content/go_item/btn_buy/lab_buy")
  self.img_redPoint = self:GetControl("scroll_shop/Viewport/Content/go_item/btn_buy/img_redPoint")
  self.btn_probabilityInformation = self:GetControl("btn_probabilityInformation")
end

function Shop_ShopUI:Init()
  self.shopInfoTbl = {}
  self.curMallIndex = -1
  self.curShopIndex = -1
  self.showCoins = {
    ECoinsType.gem,
    ECoinsType.gemNotTrade,
    ECoinsType.integral,
    ECoinsType.bindIntegral
  }
  self.isRotating = false
  self.index2TypeTbl = ParseUtility.ParseId(GlobalConfig.Shop_Type)
  self.type2IndexTbl = {}
  for i, v in ipairs(self.index2TypeTbl) do
    self.type2IndexTbl[v] = i
  end
  self.index2SubTypeTbl = ParseUtility.ParseId(GlobalConfig.shop_subType)
  self.subType2IndexTbl = {}
  for i, v in ipairs(self.index2SubTypeTbl) do
    self.subType2IndexTbl[v] = i
  end
  self.showCoinsTbl = TableParse:SplitStringToMapListList(GlobalConfig.GetGlobalConfig(2360007), "&", "#", true)
end

function Shop_ShopUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self:RefreshByFunction()
end

function Shop_ShopUI:RefreshByFunction()
end

function Shop_ShopUI:InitUI()
  self:LocalInit()
  self:shopInit()
  local scale = GlobalConfig.GetGlobalConfig(2360005)
  scale = string.split(scale, "&")
  scale = string.split(scale[2], "#")
  self.effectScale = Vector3.right * tonumber(scale[1]) + Vector3.up * tonumber(scale[2]) + Vector3.forward * tonumber(scale[3])
end

function Shop_ShopUI:Type2index(Type)
  return self.type2IndexTbl[Type] or Type
end

function Shop_ShopUI:SubType2Index(subType)
  return self.subType2IndexTbl[subType] or subType
end

function Shop_ShopUI:Index2Type(index)
  return self.index2TypeTbl[index] or index
end

function Shop_ShopUI:Index2SubType(index)
  return self.index2SubTypeTbl[index] or index
end

local function MallOnCreate(ctr)
  ctr.lab_shop = UIControl(ctr.transform, "lab_shop")
  ctr.img_clcikeffct = UIControl(ctr.transform, "img_shopclick/img_clcikeffct1")
end

local function ShopOnCreate(ctr)
  ctr.lab_typename = UIControl(ctr.transform, "lab_typename")
  ctr.img_clcikeffct = UIControl(ctr.transform, "Img_itemclick/img_clcikeffct2")
end

local function BtnStateRefresh(ctr)
  ctr.img_clcikeffct:SetActive(false)
  if ctr.lab_shop then
    ctr.lab_shop:SetText(string.format("<color=#999999>%s</color>", ctr.tabName))
  else
    ctr.lab_typename:SetText(string.format("<color=#999999>%s</color>", ctr.tabName))
  end
  
  local function AddCreatObj()
    GuideUtility.AddCreatObj("Shop_ShopUI", ctr)
  end
  
  Timer.Start(0.1, AddCreatObj)
end

local function ItemLabCreate(ctr)
  ctr.icon = UIControl(ctr.transform, "img_money_ground")
  ctr.lab = UIControl(ctr.transform, "lab_num")
  ctr.ModelData = ItemCellData()
end

local function ItemLabRefresh(ctr, index, data, ui)
  local tab = ClientTable.cfg_Item_itemManager:TryGetValue(data.itemId)
  if tab.bindEqualItem > 0 then
    tab = ClientTable.cfg_Item_itemManager:TryGetValue(tab.bindEqualItem)
  end
  ui:SetSprite("Atlas_Common", tab.icon, ctr.icon, false)
  local numStr = data.count
  local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(data.itemId)
  if bagCoinCount < data.count then
    numStr = string.format("<color=red>%s</color>", numStr)
  end
  ctr.lab:SetText(numStr)
end

local function ItemOnCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform, "btn_3DItem"))
  ctr.itemCtr.img_grrow.gameObject:GetComponent(typeof(UnityEngineUI.Image)).enabled = false
  ctr.itemModelData = ItemCellData()
  ctr.moneyCtr = UIControl(ctr.transform, "ScrollLab/Viewport/Content/btn_money")
  ctr.limitCtr = UIControl(ctr.transform, "lab_buylimit")
  ctr.txt_buylimit = UIControl(ctr.transform, "txt_buylimit")
  ctr.buyCtr = UIControl(ctr.transform, "Img_bg")
  ctr.bgBlack = UIControl(ctr.transform, "Img_bg/bgBlack")
  ctr.eff_UI_annuikuang = UIControl(ctr.transform, "Eff_UI_annuikuang")
  ctr.img_is_recommend = UIControl(ctr.transform, "img_is_recommend")
  ctr.costModelData = ItemCellData()
  ctr.Name = UIControl(ctr.transform, "Name")
end

local GuideEffecName = "Eff_UI_annuikuang06"

local function ItemRefresh(ctr, index, data, ui)
  local shopInfo = ParseUtility.ParseSingleCost(data.reward)
  local tbl = ClientTable.cfg_Item_itemManager:TryGetValue(shopInfo.itemId)
  if not tbl then
    logError("id v\225\186\173t ph\225\186\169m" .. shopInfo.itemId .. "Kh\195\180ng t\225\187\147n t\225\186\161i, ki\225\187\131m tra l\225\186\161i b\225\186\163ng item_buy")
    return
  end
  local itemData = ItemUtility.GenerateItemData(shopInfo.itemId)
  itemData.count = shopInfo.count
  ctr.itemModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.itemModelData, ui, true)
  local itemName = tbl.name
  if tbl.colorShow > 0 then
    itemName = string.format("<color=%s>%s</color>", ItemQuality2ColorDic[tbl.colorShow], itemName)
  end
  ctr.itemCtr.nameCtr:SetText(itemName)
  local textWidth = ctr.itemCtr.nameCtr.text.preferredWidth
  local bgWith = ctr.itemCtr.nameCtr:GetSizeDelta()
  if textWidth > bgWith then
    ctr.Name.transform:GetComponent("AutoScrollText").text = itemName
    ctr.itemCtr.nameCtr:SetActive(false)
    ctr.Name:SetActive(true)
  else
    ctr.itemCtr.nameCtr:SetActive(true)
    ctr.Name:SetActive(false)
  end
  if data.distinguishCareer ~= 0 and RoleUtility.GetCurrentCareerCategory() == tonumber(data.distinguishCareer) then
    ctr.img_is_recommend:SetActive(true)
  elseif data.recommend == 1 then
    ctr.img_is_recommend:SetActive(true)
  else
    ctr.img_is_recommend:SetActive(false)
  end
  if not string.isNullOrEmpty(data.cost) then
    if ctr.ModelCtrTbl == nil then
      ctr.ModelCtrTbl = UIContainer(ctr.moneyCtr, ui, ItemLabCreate, ItemLabRefresh)
    end
    local costInfo = ParseUtility.ParsShopSingleCost(data.cost)
    ctr.ModelCtrTbl:SetData(costInfo)
  else
    ctr.moneyCtr:SetActive(false)
  end
  local buyLimitShow = LimitUtility.GetLimitShow(data.buyCondition)
  local str, limitType = LimitUtility.GetTipText(buyLimitShow, data)
  ctr.limitCtr:SetActive(true)
  ctr.txt_buylimit:SetActive(true)
  ctr.txt_buylimit:SetText(str)
  if not string.isNullOrEmpty(str) and (string.contains(str, LocalizationUtility.GetContentByKey("ShopUi_9")) or string.contains(str, LocalizationUtility.GetContentByKey("ShopUi_7")) or string.contains(str, LocalizationUtility.GetContentByKey("ShopUi_8")) or string.contains(str, LocalizationUtility.GetContentByKey("ShopUi_15"))) then
    ctr.txt_buylimit:SetText("")
  end
  ctr.bgBlack:SetActive(false)
  if data.countKey and 0 < data.countKey then
    local remainder = RefreshData.GetLimitCount(data.countKey)
    ctr.bgBlack:SetActive(not (0 < remainder))
    local countTab = ClientTable.cfg_Count_countManager:TryGetValue(data.countKey, "key")
    if string.isNullOrEmpty(countTab.refreshRule) then
      str = string.format("D%sA", remainder)
      if remainder == 0 then
        ctr:SetActive(false)
      end
    else
      local refreshRuleTbl = string.split(countTab.refreshRule, "#")
      local refreshType = tonumber(refreshRuleTbl[1])
      if refreshType == EConditionEnum.timeMonthMoreThanOrEqual then
        str = LocalizationUtility.GetContentByKey("ShopUi_7")
        str = str .. remainder
      elseif refreshType == EConditionEnum.timeWeekendMoreThanOrEqual then
        str = string.format("C%sA", remainder)
      else
        str = string.format("B%sA", remainder)
      end
    end
    ctr.limitCtr:SetText(str)
    if 0 < remainder then
      ctr.limitCtr:SetColor("0xFFFFFFFF")
    else
      ctr.limitCtr:SetColor("0x606060FF")
    end
  else
    ctr.limitCtr:SetText("")
  end
  ctr.buyCtr.shop = data
  ctr.buyCtr.itemInfo = itemData
  ctr.buyCtr.limitType = limitType
  ctr.buyCtr.button.onClick:RemoveAllListeners()
  if not ctr.bgBlack.transform.gameObject.activeSelf then
    ctr.buyCtr:SetOnClick(ui, ui.BuyBtnOnClick)
  end
  
  local function AddCreatObj()
    GuideUtility.AddCreatObj("Shop_ShopUI", ctr.buyCtr)
  end
  
  Timer.Start(0.1, AddCreatObj)
  local effectItem = ctr.buyCtr.transform:Find(GuideEffecName)
  if ui.args and ui.args.subPosition then
    if data.id == ui.args.subPosition then
      if not effectItem then
        effectItem = UIEffectUtility.SetUIEffect(GuideEffecName, ctr.buyCtr, true, ui.effectScale)
        effectItem.transform.localPosition = Vector2.up * -93
      else
        effectItem.gameObject:SetActive(true)
      end
      if ui.args.taskType == RoleTaskType.SkillTask or ui.args.taskType == RoleTaskType.MiracleTask then
        ctr.buyCtr.taskType = ui.args.taskType
      end
      local countLine = math.floor(ui.showCount / 4) + 2
      local pos = index < 5 and 0 or index
      pos = pos > (countLine - 2) * 4 and ui.showCount + 4 or pos
      ui.showPosition = math.ceil(pos / 4) / countLine
    elseif effectItem then
      effectItem.gameObject:SetActive(false)
    end
  else
    if effectItem then
      effectItem.gameObject:SetActive(false)
    end
    ctr.buyCtr.taskType = nil
  end
  if ui.args ~= nil and ui.args.itemBuyID == data.id then
    if not ctr.eff_UI_annuikuang.gameObject.activeSelf then
      ctr.eff_UI_annuikuang.gameObject:SetActive(true)
      ui.effectFrame = ctr.eff_UI_annuikuang
    end
  elseif ctr.eff_UI_annuikuang.gameObject.activeSelf then
    ctr.eff_UI_annuikuang.gameObject:SetActive(false)
  end
end

local function CoinOnCreate(ctr)
  ctr.coinCtr = UIControl(ctr.transform, "btn_money")
  ctr.getCtr = UIControl(ctr.transform, "btn_get")
end

local function CoinsOnRefresh(ctr, _, configId, ui)
  local coinData = ItemUtility.GenerateItemData(configId)
  local count = BagInfoData.GetItemCountByItemConfigId(configId)
  coinData.count = count
  ItemUtility.ShowItem(ui, ctr.coinCtr, coinData, true)
  ctr.coinCtr.countCtr:SetText(coinData.count)
  ctr.getCtr.itemData = coinData
  if configId == ECoinsType.gem then
    ctr.getCtr.BusinessPay = BusinessPayType.Shop_Diamond
  end
  ctr.getCtr:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Shop_ShopUI:shopInit()
  self.mallContainer = UIContainer(self.tog_shop, self, MallOnCreate, BtnStateRefresh)
  self.shopContainer = UIContainer(self.tog_type, self, ShopOnCreate, BtnStateRefresh)
  self.shopCtrTbl = UIContainer(self.go_item, self, ItemOnCreate, ItemRefresh)
  self.coinContainer = UIContainer(self.go_money, self, CoinOnCreate, CoinsOnRefresh)
  self.viewScroll = self.shopCtrTbl.transform.parent.parent.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ScrollRect))
end

function Shop_ShopUI:OnShow()
  EventManager.Dispatch(Event.Fuc_SingleRefresh, {4000004})
  self:RegistEvents()
  self.ShowMoment = true
  self:Refresh()
end

local function CloseTip()
  Coroutine.Yield()
  UIManager.Hide(UIID.ItemTipUI)
end

function Shop_ShopUI:OnHide()
  self:OnInit()
  for i = 1, #self.shopCtrTbl.items do
    local ctrBtn = self.shopCtrTbl.items[i]
    ctrBtn.itemModelData:RecycleRes()
    ctrBtn.costModelData:RecycleRes()
  end
  self:ResetAddEffect()
end

function Shop_ShopUI:OnDestroy()
end

function Shop_ShopUI:Update()
  if self.isRotating then
    for _, itemCtr in pairs(self.shopCtrTbl.items) do
      if itemCtr.itemModelData and itemCtr.itemModelData:GetModelData() then
        RoleEquipUtility.EquipModelRotation(itemCtr.itemModelData:GetModelData(), itemCtr.itemModelData.itemData.tblItem.SpinAxis, 2)
      end
    end
  end
end

function Shop_ShopUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_probabilityInformation:SetOnClick(self, self.btn_probabilityInformationOnClick)
end

function Shop_ShopUI:btn_probabilityInformationOnClick()
  local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000004)
  if name then
    CS.MuInterface.Instance:OnWebviewClick(name)
  end
end

function Shop_ShopUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Shop)
  if RoleManager.me.TargetAvatar and RoleManager.me.TargetAvatar.RoleType == ERoleType.NPC then
    RoleManager.me.TargetAvatar:OnCancelTouch()
  end
  if self.args and self.args.TipJump and TeamUpQuicklyData.TeamInfor then
    UIManager.Show(UIID.Team_TeamUpQuicklyUI)
  end
  if self.args and self.args.openPanel == UIID.SkillUI then
    UIManager.Show(UIID.SkillUI)
  end
end

function Shop_ShopUI:MallBtnOnClick(control)
  if control.mallIndex == self.curMallIndex then
    if not self.forceRefreshMall then
      return
    else
      self.forceRefreshType = true
    end
  else
    self.curShopIndex = -1
    self.forceRefreshType = true
  end
  self:RefreshAddEffect()
  self.forceRefreshMall = false
  self.curMallIndex = control.mallIndex
  self.mallContainer:RefreshKTable()
  self:SetBtnState(control, true)
  local curTypeTbl = self.shopInfoTbl[self.curMallIndex]
  self:RefreshType(curTypeTbl, control.mType)
  self:RefreshCoin()
end

function Shop_ShopUI:TypeBtnOnClick(control)
  if control.subIndex == self.curShopIndex and not self.forceRefreshType then
    return
  end
  self:RefreshAddEffect()
  self.forceRefreshType = false
  self.curShopIndex = control.subIndex
  self.shopContainer:RefreshKTable()
  self:SetBtnState(control, true)
  local curTypeTbl = self.shopInfoTbl[self.curMallIndex]
  local curShopInfo = curTypeTbl[self.curShopIndex]
  self:RefreshShop(curShopInfo)
end

function Shop_ShopUI:CoinGetOnClick(control)
end

local shopTypeTbl = {
  1000010,
  1000020,
  1000030,
  1000040
}

function Shop_ShopUI:BuyBtnOnClick(control)
  self:RefreshAddEffect()
  self:OnBuyItemInShop(control.shop, control)
end

function Shop_ShopUI:RefreshAddEffect()
  if self.effectFrame ~= nil then
    self.effectFrame:SetActive(false)
    if self.args ~= nil then
      self.args.itemBuyID = nil
      self.effectFrame = nil
    end
  end
end

function Shop_ShopUI:ResetAddEffect()
  if self.effectFrame ~= nil then
    self.effectFrame = nil
  end
  if self.args ~= nil then
    self.args.itemBuyID = nil
  end
end

function Shop_ShopUI:RegistEvents()
  self:RegistEvent(Event.Bag_CoinChanged, self.OnCoinChanged, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.OnResBagChange, self)
  self:RegistEvent(Event.RefreshShop, self.OnRefreshShop, self)
  self:RegistEvent(Event.RefreshSingleCountShop, self.OnRefreshShop, self)
end

function Shop_ShopUI:OnCoinChanged()
  self:RefreshCoin()
end

function Shop_ShopUI:OnResBagChange()
  self.bagRefreshPos = self.viewScroll.normalizedPosition
  self:RefreshMall(true)
end

function Shop_ShopUI:OnRefreshShop(_, msg)
  self:RefreshMall(false, msg)
end

function Shop_ShopUI:Refresh()
  self:OnRefresh()
  self.isRotating = true
end

local function SortCommodity(a, b)
  if a.commodityRanking < b.commodityRanking then
    return true
  elseif a.commodityRanking == b.commodityRanking then
    return a.id < b.id
  else
    return false
  end
end

function Shop_ShopUI:ShopInfoRefresh()
  self.shopInfoTbl = {}
  local shopTbl = ShopData.GetShopInfo()
  if shopTbl == nil then
    return
  end
  for _, shopConfig in pairs(shopTbl) do
    if not self.shopInfoTbl[self:Type2index(shopConfig.type)] then
      self.shopInfoTbl[self:Type2index(shopConfig.type)] = {}
    end
    local shopType = self.shopInfoTbl[self:Type2index(shopConfig.type)]
    if not shopType[self:SubType2Index(shopConfig.subtype)] then
      shopType[self:SubType2Index(shopConfig.subtype)] = {}
    end
    shopConfig.add_LimitCount = 0
    if shopConfig.countKey ~= 0 and shopConfig.countKey ~= nil and shopConfig.countKey ~= "" then
      shopConfig.add_LimitCount = RefreshData.GetLimitCount(shopConfig.countKey)
    end
    if shopConfig.buyCondition ~= 0 and shopConfig.buyCondition ~= nil and shopConfig.buyCondition ~= "" then
      shopConfig.add_LimitShow = LimitUtility.GetLimitShow(shopConfig.buyCondition)
    end
    table.insert(shopType[self:SubType2Index(shopConfig.subtype)], shopConfig)
  end
  for _, shopType in pairs(self.shopInfoTbl) do
    for _, shopConfig in pairs(shopType) do
      table.sort(shopConfig, function(a, b)
        if a.countKey ~= 0 and a.add_LimitCount == 0 and b.countKey ~= 0 and b.add_LimitCount == 0 then
          return SortCommodity(a, b)
        end
        if a.countKey ~= 0 and a.add_LimitCount == 0 then
          return false
        end
        if b.countKey ~= 0 and b.add_LimitCount == 0 then
          return true
        end
        if a.add_LimitShow and b.add_LimitShow then
          return SortCommodity(a, b)
        end
        if a.add_LimitShow then
          return false
        end
        if b.add_LimitShow then
          return true
        end
        return SortCommodity(a, b)
      end)
    end
  end
end

function Shop_ShopUI:ShopInfoPartRefresh()
  if self.curMallIndex == -1 or self.curShopIndex == -1 then
    return
  end
  local shopType = self:Index2Type(self.curMallIndex)
  local shopTypeIndex = self:Type2index(shopType)
  local shopSubType = self:Index2SubType(self.curShopIndex)
  local shopTbl = ShopData.GetShopInfo2(shopType, shopSubType)
  if not (shopTbl ~= nil and shopType and shopTypeIndex) or not shopSubType then
    return
  end
  if self.shopInfoTbl[shopTypeIndex] and self.shopInfoTbl[shopTypeIndex][shopSubType] then
    self.shopInfoTbl[shopTypeIndex][shopSubType] = {}
  end
  for _, shopConfig in pairs(shopTbl) do
    if self:Index2Type(self.curMallIndex) == shopConfig.type and self:Index2SubType(self.curShopIndex) == shopConfig.subtype then
      if not self.shopInfoTbl[self:Type2index(shopConfig.type)] then
        self.shopInfoTbl[self:Type2index(shopConfig.type)] = {}
      end
      local shopType = self.shopInfoTbl[self:Type2index(shopConfig.type)]
      if not shopType[self:SubType2Index(shopConfig.subtype)] then
        shopType[self:SubType2Index(shopConfig.subtype)] = {}
      end
      shopConfig.add_LimitCount = 0
      if shopConfig.countKey ~= 0 and shopConfig.countKey ~= nil and shopConfig.countKey ~= "" then
        shopConfig.add_LimitCount = RefreshData.GetLimitCount(shopConfig.countKey)
      end
      if shopConfig.buyCondition ~= 0 and shopConfig.buyCondition ~= nil and shopConfig.buyCondition ~= "" then
        shopConfig.add_LimitShow = LimitUtility.GetLimitShow(shopConfig.buyCondition)
      end
      table.insert(shopType[self:SubType2Index(shopConfig.subtype)], shopConfig)
    end
  end
  if self.shopInfoTbl and self.shopInfoTbl[shopTypeIndex] and self.shopInfoTbl[shopTypeIndex][shopSubType] then
    local info = self.shopInfoTbl[shopTypeIndex][shopSubType]
    table.sort(info, function(a, b)
      if a.countKey ~= 0 and a.add_LimitCount == 0 and b.countKey ~= 0 and b.add_LimitCount == 0 then
        return SortCommodity(a, b)
      end
      if a.countKey ~= 0 and a.add_LimitCount == 0 then
        return false
      end
      if b.countKey ~= 0 and b.add_LimitCount == 0 then
        return true
      end
      if a.add_LimitShow and b.add_LimitShow then
        return SortCommodity(a, b)
      end
      if a.add_LimitShow then
        return false
      end
      if b.add_LimitShow then
        return true
      end
      return SortCommodity(a, b)
    end)
  end
end

local function WaitFormat(self, pos)
  Coroutine.Yield()
  self.viewScroll.normalizedPosition = Vector2.up * (1 - pos)
  if self.bagRefreshPos then
    self.viewScroll.normalizedPosition = self.bagRefreshPos
    self.bagRefreshPos = nil
  end
end

function Shop_ShopUI:RefreshShop(shopInfos)
  self.showCount = #shopInfos
  self.showPosition = 0
  self.shopCtrTbl:SetData(shopInfos)
  if self.showPosition then
    Coroutine.Start(WaitFormat, self, self.showPosition)
  end
end

function Shop_ShopUI:RefreshType(typeInfos, mType)
  self.shopContainer:RemoveKTable()
  local curTypeCtr
  local firstIndex = -1
  if typeInfos == nil or table.count(typeInfos) == 0 then
    return
  end
  for index, _ in pairs(typeInfos) do
    local subtype = self:Index2SubType(index)
    local typeCtr = self.shopContainer:GetOrCreateItem(index)
    local typeName = LocalizationUtility.GetContentByKey("shopsubtype" .. mType .. "_" .. subtype)
    typeCtr.lab_typename:SetText(typeName)
    typeCtr.tabName = typeName
    if self.args and self.args.subtype and typeInfos[self.args.subtype] then
      firstIndex = self:SubType2Index(self.args.subtype)
      self.args.subtype = nil
    end
    if firstIndex == -1 then
      firstIndex = index
    end
    if index == self.curShopIndex then
      curTypeCtr = typeCtr
    end
    typeCtr.subIndex = index
    typeCtr:SetOnClick(self, self.TypeBtnOnClick)
  end
  if curTypeCtr == nil then
    curTypeCtr = self.shopContainer:GetOrCreateItem(firstIndex)
    self.curShopIndex = firstIndex
    if self.args and self.args.openSecondTab and self.ShowMoment then
      curTypeCtr = self.shopContainer:GetOrCreateItem(self.args.openSecondTab)
      self.curShopIndex = self.args.openSecondTab
      self.ShowMoment = false
    end
  end
  self:TypeBtnOnClick(curTypeCtr)
end

function Shop_ShopUI:OnRefreshMall()
  if self.args and self.args.subPosition and self.args.subPosition > 0 then
    local shopConfig = ClientTable.cfg_Item_buyManager:TryGetValue(self.args.subPosition)
    if shopConfig ~= nil and shopConfig.id == self.args.subPosition then
      self.args.openFirstTab = self:Type2index(shopConfig.type)
      self.args.openSecondTab = self:SubType2Index(shopConfig.subtype)
    end
  end
  self.mallContainer:RemoveKTable()
  local curMallCtr
  local firstIndex = -1
  local shopInfoTblKeys = {}
  for k in pairs(self.shopInfoTbl) do
    table.insert(shopInfoTblKeys, k)
  end
  table.sort(shopInfoTblKeys)
  for i, v in ipairs(shopInfoTblKeys) do
    local index = v
    local mType = self:Index2Type(index)
    local mallCtr = self.mallContainer:GetOrCreateItem(index)
    local shopName = LocalizationUtility.GetContentByKey("shoptype_" .. mType)
    mallCtr.lab_shop:SetText(shopName)
    mallCtr.tabName = shopName
    mallCtr.mType = mType
    if self.args and self.args.type then
      firstIndex = self:Type2index(self.args.type)
      self.args.type = nil
    end
    if firstIndex == -1 then
      firstIndex = index
    end
    if index == self.curMallIndex then
      curMallCtr = mallCtr
    end
    mallCtr.mallIndex = index
    mallCtr:SetOnClick(self, self.MallBtnOnClick)
  end
  if curMallCtr == nil then
    curMallCtr = self.mallContainer:GetOrCreateItem(firstIndex)
    self.curMallIndex = firstIndex
    if self.args and self.args.openFirstTab and self.ShowMoment then
      curMallCtr = self.mallContainer:GetOrCreateItem(self.args.openFirstTab)
    end
  end
  self:MallBtnOnClick(curMallCtr)
end

function Shop_ShopUI:SetBtnState(btnCtr, state)
  btnCtr.img_clcikeffct:SetActive(state)
  if btnCtr.lab_shop then
    btnCtr.lab_shop:SetText(string.format("<color=#dcele5>%s</color>", btnCtr.tabName))
  else
    btnCtr.lab_typename:SetText(string.format("<color=#dcele5>%s</color>", btnCtr.tabName))
  end
end

function Shop_ShopUI:RefreshCoin()
  self:SetCoinData()
  self.coinContainer:RemoveKTable()
  self.coinContainer:SetDataKTable(self.showCoins)
end

function Shop_ShopUI:SetCoinData()
  local mType = self.index2TypeTbl[self.curMallIndex]
  local showCoinsTbl = self.showCoinsTbl or {}
  self.showCoins = mType and showCoinsTbl[mType] and showCoinsTbl[mType] or {}
end

function Shop_ShopUI:RefreshMall(bagChange, msg)
  self.forceRefreshMall = true
  self.forceRefreshType = true
  if not bagChange then
    self:ShopInfoPartRefresh()
  elseif msg and msg.levelChange then
    self:ShopInfoRefresh()
  end
  self:OnRefreshMall()
end

function Shop_ShopUI:OnRefresh()
  self:ShopInfoRefresh()
  self:RefreshMall()
  self:RefreshCoin()
end

function Shop_ShopUI:OnInit()
  self.forceRefreshMall = true
  self.forceRefreshType = true
  self.shopInfoTbl = {}
  self.curMallIndex = -1
  self.curShopIndex = -1
  self.isRotating = false
end

function Shop_ShopUI:OnBuyItemInShop(cfgData, ctr)
  local shopInfo = ParseUtility.ParseSingleCost(cfgData.reward)
  local itemData = ItemUtility.GenerateItemData(shopInfo.itemId)
  local costTbl
  if not string.isNullOrEmpty(cfgData.cost) then
    costTbl = ParseUtility.ParseSingleCost(cfgData.cost)
  end
  if not costTbl then
    costTbl = {}
    costTbl.count = 0
    costTbl.itemId = shopTypeTbl[self.curShopIndex]
  end
  local buyInfor = {
    costTbl = costTbl,
    shopInfo = cfgData,
    ctrl = ctr,
    panel = self
  }
  ShopData.currentBuyControl = buyInfor
  local control = {itemInfo = itemData, shop = cfgData}
  if tonumber(shopInfo.itemId) == 53090001 or tonumber(shopInfo.itemId) == 53090002 or tonumber(shopInfo.itemId) == 53090003 then
    control.itemInfo.tipsPosition = Vector3(0, -30, 0)
  end
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemInfo,
    openType = TipsOpenType.ShopOpen,
    rightOperate = EItemOperateType.Show
  })
end

function Shop_ShopUI:LocalInit()
  self.lab_title:SetText(LocalizationUtility.GetContentByKey("shop"))
end
