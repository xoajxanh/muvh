Vip_Member_PromptUI = class(BaseUI)
Vip_Member_PromptUI.layer = UILayer.Panel
Vip_Member_PromptUI.orderInLayer = 2
Vip_Member_PromptUI.hideType = UIHideType.WaitDestroy
Vip_Member_PromptUI.hideFunc = UIHideFunc.MoveOutOfScreen
Vip_Member_PromptUI.escClose = UIEscClose.DontClose

function Vip_Member_PromptUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.Panel_Tip = self:GetControl("Panel_Tip")
  self.Image_TipBg = self:GetControl("Panel_Tip/Image_TipBg")
  self.img_title = self:GetControl("Panel_Tip/Image_TipBg/img_title")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.btn_buy = self:GetControl("Panel_Tip/Image_TipBg/btns/btn_buy")
  self.btn_money = self:GetControl("Panel_Tip/Image_TipBg/btns/btn_money")
  self.go_model = self:GetControl("Panel_Tip/Image_TipBg/btns/btn_money/go_model")
  self.lab_num = self:GetControl("Panel_Tip/Image_TipBg/btns/btn_money/lab_num")
  self.btn_add = self:GetControl("Panel_Tip/Image_TipBg/btns/btn_money/btn_add")
  self.buy_item = self:GetControl("Buy_Member/buy_item")
  self.btn_3DItem = self:GetControl("Buy_Member/buy_item/Viewport/grid_reward/btn_3DItem")
end

function Vip_Member_PromptUI:Init()
end

function Vip_Member_PromptUI:OnCreate()
  self:InitControls()
  self:InitParams()
  self:InitUI()
  self:RegistUIEvents()
end

function Vip_Member_PromptUI:InitUI()
end

function Vip_Member_PromptUI:InitParams()
  self.rewardContainer = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
  self.itemTemplate = luaTemplateManager.GetNewTemplate(self.btn_money, LuaComponentTemplates.UIItemTemplate)
end

function Vip_Member_PromptUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.Bg_CloseOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_buy:SetOnClick(self, self.btn_buyOnClick)
end

function Vip_Member_PromptUI:Bg_CloseOnClick(control)
  UIManager.Hide(UIID.Vip_Member_PromptUI)
end

function Vip_Member_PromptUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Vip_Member_PromptUI)
end

function Vip_Member_PromptUI:btn_buyOnClick(control)
  if self.buyInfo == nil then
    return
  end
  if self.isCanBuy then
    networkRequest.ReqBuy(self.buyInfo.shopId, 1)
    UIManager.Hide(UIID.Vip_Member_PromptUI)
  elseif self.coinData then
    UIManager.Show(UIID.ItemTipUI, {
      item = self.coinData,
      rightOperate = EItemOperateType.Show,
      ctrl = {
        itemData = self.coinData
      },
      ShowObtain = true
    })
  end
end

function Vip_Member_PromptUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Vip_Member_PromptUI:RegistEvents()
end

function Vip_Member_PromptUI:Refresh()
  if self.args == nil or self.args.buyInfo == nil then
    return
  end
  self.buyInfo = self.args.buyInfo
  self.memberId = self.args.memberId
  self:RefreshView()
  self:RefreshCostView()
  self.coinData = ItemUtility.GenerateItemData(self.costCountData.itemId)
  self.btn_add.itemData = self.coinData
  self.btn_add:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
end

function Vip_Member_PromptUI:RefreshView()
  self.itemBuyTbl = ClientTable.cfg_Item_buyManager:TryGetValue(self.buyInfo.shopId)
  if self.itemBuyTbl then
    local itemCountDataList = TableParse:SpliteStringToItemCountList(self.itemBuyTbl.reward)
    self.rewardContainer:SetData(itemCountDataList)
  end
  if self.buyInfo.name then
    self:SetSprite("Atlas_Language", "img_member_prompt_title_lv" .. self.memberId, self.img_title)
  end
end

function Vip_Member_PromptUI:RefreshCostView()
  if self.itemBuyTbl.cost == nil then
    return
  end
  self.costCountData = ParseUtility.ParseSingleCost(self.itemBuyTbl.cost)
  if self.costCountData == nil then
    return
  end
  local targetCount = self.costCountData.count
  local curCount = BagInfoData.GetItemCountByItemConfigId(self.costCountData.itemId)
  if self.itemTemplate then
    self.itemTemplate:Refresh(self.costCountData)
  end
  self.isCanBuy = targetCount <= curCount
  local showColor = targetCount <= curCount and ItemQuality2ColorDic[0] or ItemQuality2ColorDic[12]
  local curCountText = string.GetColorText(curCount, showColor)
  self.lab_num:SetText(string.format("%s/%s", curCountText, targetCount))
end

function Vip_Member_PromptUI:OnHide()
end

function Vip_Member_PromptUI:OnDestroy()
end
