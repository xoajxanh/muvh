MasterSkill_ResetlUI = class(BaseUI)
MasterSkill_ResetlUI.layer = UILayer.Panel
MasterSkill_ResetlUI.orderInLayer = 10
MasterSkill_ResetlUI.hideType = UIHideType.WaitDestroy
MasterSkill_ResetlUI.hideFunc = UIHideFunc.MoveOutOfScreen
MasterSkill_ResetlUI.escClose = UIEscClose.DontClose

function MasterSkill_ResetlUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.resetPointPanelClose = self:GetControl("panel_reset/resetPointPanelClose")
  self.btn_resetPointPanelClose = self:GetControl("panel_reset/btn_resetPointPanelClose")
  self.btn_get2 = self:GetControl("panel_reset/lab_price/btn_get2")
  self.lab_price = self:GetControl("panel_reset/lab_price")
  self.consumeItem = self:GetControl("panel_reset/lab_price/consumeItem")
  self.lab_priceValue = self:GetControl("panel_reset/lab_price/lab_priceValue")
  self.cancelBtn = self:GetControl("panel_reset/cancelBtn")
  self.confirmBtn = self:GetControl("panel_reset/confirmBtn")
  self.Text = self:GetControl("panel_reset/confirmBtn/Text")
end

function MasterSkill_ResetlUI:Init()
end

function MasterSkill_ResetlUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function MasterSkill_ResetlUI:InitUI()
  self:InitParams()
end

function MasterSkill_ResetlUI:InitParams()
  self.freeTime = 0
end

function MasterSkill_ResetlUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.resetPointPanelClose:SetOnClick(self, self.resetPointPanelCloseOnClick)
  self.btn_resetPointPanelClose:SetOnClick(self, self.btn_resetPointPanelCloseOnClick)
  self.cancelBtn:SetOnClick(self, self.cancelBtnOnClick)
  self.confirmBtn:SetOnClick(self, self.confirmBtnOnClick)
end

function MasterSkill_ResetlUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ResetlUI)
end

function MasterSkill_ResetlUI:resetPointPanelCloseOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ResetlUI)
end

function MasterSkill_ResetlUI:btn_resetPointPanelCloseOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ResetlUI)
end

function MasterSkill_ResetlUI:cancelBtnOnClick(control)
  UIManager.Hide(UIID.MasterSkill_ResetlUI)
end

function MasterSkill_ResetlUI:confirmBtnOnClick(control)
  if self:CheckJumpTis() then
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Dashi_10"))
    return
  end
  if self.isMeet then
    networkRequest.ReqResetGrandMaster()
  else
    FloatingTipUtility.QuickMsg(ClientTable.cfg_Ui_wordManager:GetDaShiCoinNotSatisfiedStr())
  end
end

function MasterSkill_ResetlUI:CheckJumpTis()
  local canRest = false
  local canPoint = false
  local data = QuickFind.MasterDataMgr():CurMasterSkillDataBySkillIdDic()
  local point = QuickFind.MasterDataMgr():GetSurplusPointTbl()
  if point then
    for i, v in pairs(point) do
      if 0 < v then
        canPoint = true
        break
      end
    end
  end
  if data then
    for _, v in pairs(data) do
      local level = QuickFind.MasterDataMgr():GetSkillDataBySkillGroup(v.skillGroup)
      if level and 0 < level.level then
        canRest = true
        break
      end
    end
  end
  return canPoint and not canRest
end

function MasterSkill_ResetlUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function MasterSkill_ResetlUI:RegistEvents()
  self:RegistEvent(Event.NewMasterResetSuccess, self.NewMasterResetSuccessCallBack, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.Bag_ResBagChangeCallBack, self)
end

function MasterSkill_ResetlUI:NewMasterResetSuccessCallBack()
  UIManager.Hide(UIID.MasterSkill_ResetlUI)
end

function MasterSkill_ResetlUI:Bag_ResBagChangeCallBack()
  self:RefreshCountView()
end

function MasterSkill_ResetlUI:Refresh()
  self:RefeshData()
  self:RefreshConsumView()
end

function MasterSkill_ResetlUI:RefeshData()
  if QuickFind.MasterDataMgr() == nil then
    return
  end
  local index = 1
  local consumTbl = ClientTable.cfg_Global_globalManager:GetMasterResetConsumTbl()
  if 1 < table.count(consumTbl) then
    self.resetNum = QuickFind.MasterDataMgr():GetResetNum()
    index = self.resetNum <= self.freeTime and 1 or 2
  end
  self.consumabelData = consumTbl[index]
end

function MasterSkill_ResetlUI:RefreshConsumView()
  if self.consumabelData == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(self.consumabelData.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  if self.consumeItem.cellData == nil then
    self.consumeItem.cellData = ItemCellData()
  end
  self.consumeItem.cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(self.consumeItem, self.consumeItem.cellData, self.parentTbl, true)
  self.consumeItem.itemData = itemData
  self:RefreshCountView()
end

function MasterSkill_ResetlUI:RefreshCountView()
  local bagCount = BagInfoData.GetItemTotalCountByItemId(self.consumabelData.itemId)
  self.isMeet = bagCount >= self.consumabelData.count
  local numColor = self.isMeet and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  self.lab_priceValue:SetText(string.GetColorText(self.consumabelData.count == 0 and "Mi\225\187\133n ph\195\173" or self.consumabelData.count, numColor))
end

function MasterSkill_ResetlUI:OnHide()
end

function MasterSkill_ResetlUI:OnDestroy()
end
