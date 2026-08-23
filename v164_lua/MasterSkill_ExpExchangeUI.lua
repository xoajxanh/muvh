MasterSkill_ExpExchangeUI = class(BaseUI)
MasterSkill_ExpExchangeUI.layer = UILayer.Panel
MasterSkill_ExpExchangeUI.orderInLayer = 10
MasterSkill_ExpExchangeUI.hideType = UIHideType.WaitDestroy
MasterSkill_ExpExchangeUI.hideFunc = UIHideFunc.MoveOutOfScreen
MasterSkill_ExpExchangeUI.escClose = UIEscClose.DontClose

function MasterSkill_ExpExchangeUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_ExpCloseBg = self:GetControl("panel_Exp/btn_ExpCloseBg")
  self.btn_ExpClose = self:GetControl("panel_Exp/bg_vip/btn_ExpClose")
  self.lab_exchangeNum = self:GetControl("panel_Exp/bg_vip/lab_exchangeNum")
  self.go_exchangeMode = self:GetControl("panel_Exp/bg_vip/sw_exchangeMode/Viewport/Content/go_exchangeMode")
  self.btn_minus = self:GetControl("panel_Exp/bg_vip/Item/count/btn_minus")
  self.btn_add = self:GetControl("panel_Exp/bg_vip/Item/count/btn_add")
  self.lab_count = self:GetControl("panel_Exp/bg_vip/Item/count/lab_count")
  self.btn_3DItem = self:GetControl("panel_Exp/bg_vip/Item/btn_3DItem")
  self.lab_name = self:GetControl("panel_Exp/bg_vip/Item/lab_name")
end

function MasterSkill_ExpExchangeUI:Init()
  self.labFormat = "L\198\176\225\187\163t \196\145\225\187\149i c\195\178n l\225\186\161i h\195\180m nay: %s"
  
  function self.clickCallBack(data, control)
    self:ClickModelCallBack(data, control)
  end
  
  self.curExchangeCount = 1
  self.curSurplusExChangCount = 1
  self.curCanExchangeCount = 1
end

function MasterSkill_ExpExchangeUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function MasterSkill_ExpExchangeUI:InitUI()
  self.modeContainer = UIUtility.BindUIContainerTemp(self.go_exchangeMode, LuaComponentTemplates.UIExchangeUnitTemplate, self, {
    clickCallBack = self.clickCallBack
  })
end

function MasterSkill_ExpExchangeUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_ExpCloseBg:SetOnClick(self, self.btn_ExpCloseBgOnClick)
  self.btn_ExpClose:SetOnClick(self, self.btn_ExpCloseOnClick)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
  self.btn_add:SetOnPress(self, self.btn_addOnClick, self.OnStopPress, 1)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.btn_minus:SetOnPress(self, self.btn_minusOnClick, self.OnStopPress, 1)
end

function MasterSkill_ExpExchangeUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ExpExchangeUI)
end

function MasterSkill_ExpExchangeUI:btn_ExpCloseBgOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ExpExchangeUI)
end

function MasterSkill_ExpExchangeUI:btn_ExpCloseOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ExpExchangeUI)
end

function MasterSkill_ExpExchangeUI:btn_addOnClick(control)
  self:RefreshExchangeViewByExchangeCount(self.curExchangeCount + 1)
end

function MasterSkill_ExpExchangeUI:btn_minusOnClick(control)
  self:RefreshExchangeViewByExchangeCount(self.curExchangeCount - 1)
end

function MasterSkill_ExpExchangeUI:OnStopPress()
end

function MasterSkill_ExpExchangeUI:RefreshExchangeViewByExchangeCount(count)
  if QuickFind.MasterDataMgr() == nil then
    return
  end
  local exchangeInfo = QuickFind.MasterDataMgr():GetExChangeInfo()
  self.curSurplusExChangCount = exchangeInfo and exchangeInfo.value or 0
  local masterExpPillItemId = ClientTable.cfg_Global_globalManager:GetMasterExpPillItemID()
  local bagMasterExpPillCount = BagInfoData.GetItemTotalCountByItemId(masterExpPillItemId or 3003001)
  self.curCanExchangeCount = bagMasterExpPillCount
  local maxCount
  if self.curSurplusExChangCount and self.curCanExchangeCount then
    local getMinValue = math.min(self.curCanExchangeCount, self.curSurplusExChangCount)
    maxCount = getMinValue ~= 0 and getMinValue or 1
  end
  if count < 1 then
    count = maxCount
  end
  if maxCount < count then
    count = 1
  end
  self.curExchangeCount = Mathf.Clamp(count, 1, maxCount)
  self.btn_add:SetInteractable(maxCount ~= 1)
  self.btn_minus:SetInteractable(maxCount ~= 1)
  self.lab_count:SetText(self.curExchangeCount or "1")
  local costBaseTbl = ClientTable.cfg_Global_globalManager:GetBaseMasterExChangeTbl()
  for i = 1, #costBaseTbl do
    costBaseTbl[i].coinNum = costBaseTbl[i].coinNum * self.curExchangeCount
    costBaseTbl[i].masterExpPillNum = costBaseTbl[i].masterExpPillNum * self.curExchangeCount
    costBaseTbl[i].targetNum = costBaseTbl[i].targetNum * self.curExchangeCount
  end
  self.modeContainer:SetData(costBaseTbl)
end

function MasterSkill_ExpExchangeUI:ClickModelCallBack(data, control)
  if self.isZero then
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiNoTimeStr())
    return
  end
  if data then
    local bagCoinCount = BagInfoData.GetItemTotalCountByItemId(data.coinItemId)
    local bagMasterExpPillCount = BagInfoData.GetItemTotalCountByItemId(data.masterExpPillItemId)
    local isCoinEnough = bagCoinCount >= data.coinNum
    local isMasterExpPillEnough = bagMasterExpPillCount >= data.masterExpPillNum
    local isMeet = isCoinEnough and isMasterExpPillEnough
    if isMeet then
      local item = BagInfoData.GetItemByConfigID(data.masterExpPillItemId)
      local count = self.curExchangeCount or 1
      if item and item.id then
        networkRequest.ReqExchangeGrandMasterExp(data.gear, item.id, count)
      end
    elseif not isCoinEnough then
      FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiCoinNotSatisfiedStr())
      self:ShowItemTipUI(data.coinItemId, control)
    elseif not isMasterExpPillEnough then
      FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiMasterExpPillNotSatisfiedStr())
      self:ShowItemTipUI(data.masterExpPillItemId, control)
    end
  end
end

function MasterSkill_ExpExchangeUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function MasterSkill_ExpExchangeUI:RegistEvents()
  self:RegistEvent(Event.NewMasterExChangeDataChanged, self.ExChangeDataChangedCallBack, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChangeCallBack, self)
end

function MasterSkill_ExpExchangeUI:ExChangeDataChangedCallBack()
  self:RefreshTodaySurplusExchangeCountView()
  self:RefreshExchangeViewByExchangeCount(1)
  self:RefeshTemplatesBtnView()
end

function MasterSkill_ExpExchangeUI:Bag_ResBagChangeCallBack()
  self:RefreshExchangeViewByExchangeCount(1)
  self:RefeshTemplatesBtnView()
end

function MasterSkill_ExpExchangeUI:Refresh()
  self:RefreshMasterExpPillModeView()
  self:RefreshTodaySurplusExchangeCountView()
  self:RefreshExchangeViewByExchangeCount(1)
  self:RefeshTemplatesBtnView()
end

function MasterSkill_ExpExchangeUI:RefreshTodaySurplusExchangeCountView()
  if QuickFind.MasterDataMgr() == nil then
    return
  end
  local exchangeInfo = QuickFind.MasterDataMgr():GetExChangeInfo()
  local isMeet = exchangeInfo.value > 0
  local numColor = isMeet and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  self.lab_exchangeNum:SetText(string.format(self.labFormat, string.GetColorText(exchangeInfo.value .. "/" .. exchangeInfo.maxValue, numColor)))
end

function MasterSkill_ExpExchangeUI:RefeshTemplatesBtnView()
  if QuickFind.MasterDataMgr() == nil then
    return
  end
  self.isZero = QuickFind.MasterDataMgr():GetExChangeInfo().value == 0
  for i, v in pairs(self.modeContainer.items) do
    if v and v.itemTemp then
      v.itemTemp:RefrshBtnView(not self.isZero)
    end
  end
end

function MasterSkill_ExpExchangeUI:ShowItemTipUI(itemId, control)
  if itemId == nil or control == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  control.itemData = itemData
  control.OpenTipsType = EOpenTipsType.FastBuy
  UIManager.Show(UIID.ItemTipUI, {
    item = control.itemData,
    rightOperate = EItemOperateType.Show,
    ctrl = control,
    ShowObtain = true,
    BusinessPay = control.BusinessPay,
    OpenWay = control.OpenTipsType,
    countDownTime = control.countDownTime
  })
end

function MasterSkill_ExpExchangeUI:RefreshMasterExpPillModeView()
  local masterExpPillItemId = ClientTable.cfg_Global_globalManager:GetMasterExpPillItemID()
  local itemData = ItemUtility.GenerateItemData(masterExpPillItemId or 3003001)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = BagInfoData.GetItemTotalCountByItemId(masterExpPillItemId or 3003001)
  if not self.itemCellData then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.btn_3DItem, self.itemCellData, self, true)
  self.lab_name:SetText(itemData.tblItem.name or "Thu\225\187\145c EXP B\225\186\173c Th\225\186\167y")
end

function MasterSkill_ExpExchangeUI:OnHide()
  if self.itemCellData then
    self.itemCellData:RecycleRes()
    self.itemCellData = nil
  end
  EventManager.Dispatch(Event.NewMasterSkillExpExchangeUIHide)
end
