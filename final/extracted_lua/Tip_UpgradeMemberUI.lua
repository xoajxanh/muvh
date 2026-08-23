Tip_UpgradeMemberUI = class(BaseUI)
Tip_UpgradeMemberUI.layer = UILayer.Tip
Tip_UpgradeMemberUI.orderInLayer = 8
Tip_UpgradeMemberUI.hideType = UIHideType.WaitDestroy
Tip_UpgradeMemberUI.hideFunc = UIHideFunc.MoveOutOfScreen
Tip_UpgradeMemberUI.escClose = UIEscClose.DontClose

function Tip_UpgradeMemberUI:InitControls()
  self.btn_Close = self:GetControl("btn_Close")
  self.img_btn = self:GetControl("memberBuyPanel/btn_memberBuyPanelBuy/img_btn")
  self.lab_count = self:GetControl("memberBuyPanel/count/lab_count")
  self.lab_InputField = self:GetControl("memberBuyPanel/count/lab_InputField")
  self.btn_add = self:GetControl("memberBuyPanel/count/btn_add")
  self.btn_minus = self:GetControl("memberBuyPanel/count/btn_minus")
  self.lab_txt = self:GetControl("memberBuyPanel/lab_txt")
  self.txt_finalPriceValue2 = self:GetControl("memberBuyPanel/price/txt_finalPriceValue2")
  self.img_icon = self:GetControl("memberBuyPanel/price/img_icon")
end

local delayTime = 1
local intervalTime = 0.06

function Tip_UpgradeMemberUI:Init()
  self.buyItemInfo = ClientTable.cfg_Item_buyManager:TryGetValue(610001)
  self.costTbl = ParseUtility.ParseSingleCost(self.buyItemInfo.cost)
  self.rewardTbl = ParseUtility.ParseSingleCost(self.buyItemInfo.reward)
  self.upgradeMemberTipData = LuaClass.UpgradeMemberTipData:New(self.rewardTbl.count)
end

function Tip_UpgradeMemberUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
  self.costItemData = ItemCellData()
  local ItemData = ItemUtility.GenerateItemData(self.costTbl.itemId)
  self.costItemData:RefreshData(ItemData)
  ItemUtility.ShowItemCell(self.img_icon, self.costItemData, self, false)
end

function Tip_UpgradeMemberUI:InitUI()
  self.lab_count:SetActive(false)
  self.lab_InputField:SetActive(true)
end

function Tip_UpgradeMemberUI:RegistUIEvents()
  self.btn_Close:SetOnClick(self, self.btn_CloseOnClick)
  self.img_btn:SetOnClick(self, self.btn_BuyOnClick)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
  self.btn_add:SetOnPress(self, self.btn_addOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.btn_minus:SetOnPress(self, self.btn_minusOnLongPress, self.btn_OnLongPressEnd, delayTime)
  self.lab_InputField:SetOnEndEdit(self, self.lab_InputFieldOnEndEdit)
end

function Tip_UpgradeMemberUI:btn_CloseOnClick(control)
  UIManager.Hide(UIID.UpgradeMemberTipUI)
end

function Tip_UpgradeMemberUI:btn_BuyOnClick(control)
  if self.isCanBuy then
    NetManager.Send(ItemBuyMessage.ReqBuy, {
      goodId = self.buyItemInfo.id,
      buyCount = self.buyNum
    })
    UIManager.Hide(UIID.UpgradeMemberTipUI)
  else
    local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
    FloatingTipUtility.QuickMsg(tipStr)
  end
end

function Tip_UpgradeMemberUI:btn_addOnClick(control)
  self.upgradeMemberTipData:SetAddExp(tonumber(self.lab_InputField:GetInputText()) + self.rewardTbl.count)
end

function Tip_UpgradeMemberUI:btn_addOnLongPress(control)
  if not self:GetTimeDown() then
    return
  end
  self:btn_addOnClick(nil)
end

function Tip_UpgradeMemberUI:btn_minusOnClick(control)
  self.upgradeMemberTipData:SetAddExp(tonumber(self.lab_InputField:GetInputText()) - self.rewardTbl.count)
end

function Tip_UpgradeMemberUI:btn_minusOnLongPress(control)
  if not self:GetTimeDown() then
    return
  end
  self:btn_minusOnClick(nil)
end

function Tip_UpgradeMemberUI:lab_InputFieldOnEndEdit(control)
  local inputStr = self.lab_InputField:GetInputText()
  if inputStr ~= "" then
    self.upgradeMemberTipData:SetAddExp(tonumber(inputStr))
  else
    self.upgradeMemberTipData:SetAddExp(0)
  end
end

function Tip_UpgradeMemberUI:btn_OnLongPressEnd(control)
  intervalTime = 0.3
end

function Tip_UpgradeMemberUI:GetTimeDown()
  intervalTime = intervalTime - Time.deltaTime
  if intervalTime <= 0 then
    intervalTime = 0.06
    return true
  end
  return false
end

function Tip_UpgradeMemberUI:OnShow()
  self.upgradeMemberTipData:InitData()
  self:RegistEvents()
  self:Refresh()
end

function Tip_UpgradeMemberUI:RegistEvents()
  self:RegistEvent(Event.UpgradeMemberTipChanged, self.Refresh, self)
end

function Tip_UpgradeMemberUI:Refresh()
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Newmember_5")
  local addExp = tostring(self.upgradeMemberTipData:GetAddExp())
  local vipInfo = ClientTable.cfg_MemberManager:TryGetValue(self.upgradeMemberTipData:GetUpLevelId())
  local levelName = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Newmember_name_" .. tostring(vipInfo.id // 100))
  local starNum = tostring(vipInfo.starnum)
  local labStr = string.format(content, addExp, levelName, starNum)
  self.lab_txt:SetText(labStr)
  self.lab_InputField:SetInputText(addExp)
  self.buyNum = self.upgradeMemberTipData:GetAddExp() // self.rewardTbl.count * self.costTbl.count
  if BagInfoData.GetItemTotalCountByItemId(self.costTbl.itemId) < self.buyNum then
    self.txt_finalPriceValue2:SetText(string.GetColorText(self.buyNum, ItemQuality2ColorDic[EItemColorEnum.red]))
    self.isCanBuy = false
  else
    self.txt_finalPriceValue2:SetText(tostring(self.buyNum))
    self.isCanBuy = true
  end
end

function Tip_UpgradeMemberUI:OnHide()
  UIManager.Hide(UIID.UpgradeMemberTipUI)
end

function Tip_UpgradeMemberUI:OnDestroy()
end
