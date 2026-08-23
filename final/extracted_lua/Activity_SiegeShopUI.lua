Activity_SiegeShopUI = class(BaseUI)
Activity_SiegeShopUI.layer = UILayer.Panel
Activity_SiegeShopUI.orderInLayer = 0
Activity_SiegeShopUI.hideType = UIHideType.WaitDestroy
Activity_SiegeShopUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiegeShopUI.escClose = UIEscClose.DontClose
Activity_SiegeShopUI.shopData = {}

function Activity_SiegeShopUI:InitControls()
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.Item_Content = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content")
  self.img_information = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content/img_information")
  self.btn_3DItem = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content/img_information/btn_3DItem")
  self.lab_buy = self:GetControl("img_bg/img_frame/Scroll View/Viewport/Item_Content/img_information/btn_buy/lab_buy")
  self.go_gold = self:GetControl("img_bg/currency/go_gold")
  self.go_integral = self:GetControl("img_bg/currency/go_integral")
  self.go_gem = self:GetControl("img_bg/currency/go_gem")
  self.go_meltingPoint = self:GetControl("img_bg/currency/go_meltingPoint")
  self.descBtn = self:GetControl("descBtn")
  self.plane_top = self:GetControl("plane_top")
  self.plane_bottom = self:GetControl("plane_bottom")
end

function Activity_SiegeShopUI:OnPreLoad()
end

function Activity_SiegeShopUI:Init()
  self.showCoins = {
    ECoinsType.gold,
    ECoinsType.integral,
    ECoinsType.gem,
    ECoinsType.warAllianceMoney
  }
  self.nowBuyShopId = nil
end

function Activity_SiegeShopUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_SiegeShopUI:InitUI()
  self.messageContainer = EventContainer(NetManager)
  self.showCoinsGo = {
    self.go_gold,
    self.go_integral,
    self.go_gem,
    self.go_meltingPoint
  }
  self.TogRechargeContainer = UIContainer(self.img_information, self, self.OnShopCreat, self.OnShowTogRefresh)
end

function Activity_SiegeShopUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiegeShopUI:OnHide()
end

function Activity_SiegeShopUI:OnDestroy()
end

function Activity_SiegeShopUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Activity_SiegeShopUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_SiegeShopUI)
  for k, v in pairs(UIManager.sortedUIs) do
    if v.name == UIID.ItemTipUI then
      v:Hide()
    end
  end
end

function Activity_SiegeShopUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Activity_SiegeShopUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function Activity_SiegeShopUI:RegistEvents()
  self.messageContainer:Regist(CountMessage.ResCount, self.OnResCount)
end

function Activity_SiegeShopUI:Refresh()
  self:ReSet()
  self:RefreshData()
end

function Activity_SiegeShopUI.OnShopCreat(ctr)
  ctr.itemCtr = UIControl(ctr.transform)
  ctr.go_model = UIControl(ctr.transform, "btn_3DItem")
  ctr.num = UIControl(ctr.transform, "go_price/img_icon/num")
  ctr.lab_name = UIControl(ctr.transform, "btn_3DItem/lab_name")
  ctr.lab_num = UIControl(ctr.transform, "btn_3DItem/lab_num")
  ctr.img_icon = UIControl(ctr.transform, "go_price/img_icon")
  ctr.lab_limit = UIControl(ctr.transform, "lab_limit")
  ctr.btn_buy = UIControl(ctr.transform, "btn_buy")
  ctr.modelData = ItemCellData()
end

function Activity_SiegeShopUI.OnResCount(_, msg)
  if msg ~= nil then
    Activity_SiegeShopUI.shopData[Activity_SiegeShopUI.nowBuyShopId].limitCount = msg.total - msg.count
  end
  Activity_SiegeShopUI:RefreshData()
end

function Activity_SiegeShopUI:RefreshData()
  Activity_SiegeShopUI.CoinsOnRefresh()
  Activity_SiegeShopUI.TogRechargeContainer:SetData(Activity_SiegeShopUI.shopData)
end

function Activity_SiegeShopUI:ReSet()
  self.shopData = {}
  local itemCounts = RefreshData.TotalRefreshTbl
  local items = ConfigManager.FindConfigs("cfg_Item_buy", "type", 17)
  for i, v in pairs(items) do
    local bool = false
    local s = {}
    s.itemId = ParseUtility.ParseUIParam(v.reward)[1]
    s.id = v.id
    if self.args ~= nil and self.args.unionId == RoleManager.me.unionId and RoleManager.me.data.unionPosition == 1 then
      bool = true
    end
    s.limitCount = tonumber(ClientTable.cfg_Count_countManager:TryGetValue(v.countKey, "refreshCountLimit").refreshCountLimit)
    if itemCounts[v.countKey] ~= nil and itemCounts[v.countKey].count ~= 0 then
      s.limitCount = itemCounts[v.countKey].total - itemCounts[v.countKey].count
    end
    s.lab_num = ParseUtility.ParseUIParam(v.reward)[2]
    s.buyCondition = tonumber(ParseUtility.ParseUIParam(v.buyCondition)[2])
    s.lab_name = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(s.itemId)).name
    s.num = ParseUtility.ParseUIParam(v.cost)[2]
    s.currency = ParseUtility.ParseUIParam(v.cost)[1]
    if bool then
      table.insert(self.shopData, s)
    elseif not bool and s.itemId ~= "3000210" and s.itemId ~= "3000200" then
      table.insert(self.shopData, s)
    end
  end
end

function Activity_SiegeShopUI.OnShowTogRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(data.itemId))
  local limitStr = "C\225\186\165p c\225\186\167n: " .. data.buyCondition
  local coinData = ItemUtility.GenerateItemData(tonumber(data.currency))
  ctr.spriteCol = ui:SetSprite("Atlas_Common", coinData.tblItem.icon, ctr.img_icon)
  ctr.lab_name:SetText(data.lab_name)
  ctr.num:SetText(data.num)
  if tonumber(ViewData.meData.level) > data.buyCondition then
    limitStr = "L\198\176\225\187\163t gi\225\187\155i h\225\186\161n mua: " .. data.limitCount
  end
  ctr.lab_limit:SetText(limitStr)
  ctr.btn_buy:SetOnClick(self, function()
    if tonumber(data.limitCount) < 1 then
      FloatingTipUtility.QuickMsg("L\198\176\225\187\163t mua h\195\180m nay \196\145\195\163 c\195\179")
      return
    elseif tonumber(ViewData.meData.level) < data.buyCondition then
      FloatingTipUtility.QuickMsg("Ch\198\176a \196\145\225\187\167 \196\145i\225\187\129u ki\225\187\135n mua")
      return
    end
    if BagInfoData.GetItemCountByItemConfigId(tonumber(data.currency)) < data.num * data.lab_num then
      LimitUtility.NoEnoughPrompt(EBuyTipEnum.noEnoughGold, nil)
      return
    end
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = tonumber(data.id),
      buyCount = tonumber(data.lab_num)
    })
    Activity_SiegeShopUI.nowBuyShopId = _
  end)
  ctr.modelData:RefreshData(itemData)
  ctr.go_model:SetOnClick(self, function()
    UIManager.Show(UIID.ItemTipUI, {
      item = itemData,
      rightOperate = EItemOperateType.Show,
      ctrl = ctr
    })
  end)
  ItemUtility.ShowModel(ctr, ctr.modelData, ui)
end

function Activity_SiegeShopUI.CoinsOnRefresh()
  for i, v in pairs(Activity_SiegeShopUI.showCoins) do
    local coinData = ItemUtility.GenerateItemData(v)
    local count = BagInfoData.GetItemCountByItemConfigId(v)
    coinData.count = count
    ItemUtility.ShowItem(Activity_SiegeShopUI, Activity_SiegeShopUI.showCoinsGo[i], coinData, true)
  end
end
