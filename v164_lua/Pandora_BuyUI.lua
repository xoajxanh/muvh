Pandora_BuyUI = class(BaseUI)
Pandora_BuyUI.layer = UILayer.Tip
Pandora_BuyUI.orderInLayer = 0
Pandora_BuyUI.hideType = UIHideType.WaitDestroy
Pandora_BuyUI.hideFunc = UIHideFunc.MoveOutOfScreen
Pandora_BuyUI.escClose = UIEscClose.DontClose

function Pandora_BuyUI:InitControls()
  self.Bg_Close = self:GetControl("Bg_Close")
  self.btn_3DItem = self:GetControl("Panel_Tip/Image_TipBg/btn_3DItem")
  self.lab_InputField = self:GetControl("Panel_Tip/Image_TipBg/count/lab_InputField")
  self.btn_add = self:GetControl("Panel_Tip/Image_TipBg/count/btn_add")
  self.btn_minus = self:GetControl("Panel_Tip/Image_TipBg/count/btn_minus")
  self.btn_close = self:GetControl("Panel_Tip/Image_TipBg/btn_close")
  self.Button_Cancel = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_Cancel")
  self.Button_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK")
  self.Text_OK = self:GetControl("Panel_Tip/Image_TipBg/ButtonTriggerView/Button_OK/Text_OK")
end

function Pandora_BuyUI:Init()
end

function Pandora_BuyUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Pandora_BuyUI:InitUI()
  self.countLimit = ClientTable.cfg_Global_globalManager:TryGetValue(77000001).effect or ""
  self.countLowerLimit = self:GetCountLimit(1)
  self.countUpperLimit = self:GetCountLimit(2)
  self:SetBuyCount(self.countLowerLimit)
end

function Pandora_BuyUI:RegistUIEvents()
  self.Bg_Close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.Button_Cancel:SetOnClick(self, self.btn_closeOnClick)
  self.Button_OK:SetOnClick(self, self.Button_OKOnClick)
  self.lab_InputField:SetOnValueChanged(self, self.InputBuyCount)
end

function Pandora_BuyUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Pandora_BuyUI)
end

function Pandora_BuyUI:btn_addOnClick(control)
  if self.buyCount >= self.countUpperLimit then
    return
  end
  self:SetBuyCount(self.buyCount + 1)
end

function Pandora_BuyUI:btn_minusOnClick(control)
  if self.buyCount <= self.countLowerLimit then
    return
  end
  self:SetBuyCount(self.buyCount - 1)
end

function Pandora_BuyUI:Button_OKOnClick(control)
  local bagCount = BagInfoData.GetItemCountByItemConfigId(ECoinsType.pandoraDaiBi)
  if bagCount < self.buyCount then
    FloatingTipUtility.QuickMsg("Xu B\225\186\163o T\195\160ng Pandora kh\195\180ng \196\145\225\187\167!")
    return
  end
  if self.args.data and self.args.data.itemBuyId then
    networkRequest.ReqBuy(self.args.data.itemBuyId, self.buyCount)
    UIManager.Hide(UIID.Pandora_BuyUI)
  end
end

function Pandora_BuyUI:InputBuyCount(control)
  local text = control:GetInputText()
  if text == "" then
    self:SetBuyCount(self.countLowerLimit)
  else
    local num = tonumber(text)
    num = num < self.countLowerLimit and self.countLowerLimit or num
    num = num > self.countUpperLimit and self.countUpperLimit or num
    self:SetBuyCount(num)
  end
end

function Pandora_BuyUI:SetBuyCount(count)
  self.buyCount = count
  self.lab_InputField:SetInputText(self.buyCount)
  local countStr = ""
  local bagCount = BagInfoData.GetItemCountByItemConfigId(ECoinsType.pandoraDaiBi)
  if bagCount >= self.buyCount then
    countStr = string.GetColorText(self.buyCount, ItemQuality2ColorDic[5])
  else
    countStr = string.GetColorText(self.buyCount, ItemQuality2ColorDic[12])
  end
  self.Text_OK:SetText(countStr)
end

function Pandora_BuyUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Pandora_BuyUI:RegistEvents()
end

function Pandora_BuyUI:Refresh()
  self:SetBuyCount(self.countLowerLimit)
  local itemConfigData = self:GetItemConfigData(self.args.data.itemBuyId)
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  local itemData = ItemUtility.GenerateItemData(itemConfigData.id)
  self.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, self, true)
end

function Pandora_BuyUI:GetCountLimit(limit)
  local cfgInfo = string.split(self.countLimit, "#")
  if not cfgInfo or #cfgInfo < 2 then
    return
  end
  return tonumber(cfgInfo[limit]) or 1
end

function Pandora_BuyUI:GetItemConfigData(itemById)
  local itemBuyConfig = ClientTable.cfg_Item_buyManager:TryGetValue(itemById)
  if not itemBuyConfig then
    return nil
  end
  local itemReward = itemBuyConfig.reward
  local itemTab = string.split(itemReward, "#")
  if itemTab and itemTab[1] then
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(itemTab[1]))
    return itemConfig or nil
  end
  return nil
end

function Pandora_BuyUI:OnHide()
  self.buyCount = 1
  self.lab_InputField:SetInputText(self.buyCount)
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
end

function Pandora_BuyUI:OnDestroy()
end
