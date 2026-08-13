Instance_GoldOriginUI = class(BaseUI)
Instance_GoldOriginUI.layer = UILayer.Panel
Instance_GoldOriginUI.orderInLayer = 0
Instance_GoldOriginUI.hideType = UIHideType.WaitDestroy
Instance_GoldOriginUI.hideFunc = UIHideFunc.MoveOutOfScreen
Instance_GoldOriginUI.escClose = UIEscClose.DontClose

function Instance_GoldOriginUI:InitControls()
  self.bg_btnClose = self:GetControl("bg_btnClose")
  self.lab_level = self:GetControl("Middel/level/lab_level")
  self.lab_def = self:GetControl("Middel/def/lab_def")
  self.lab_number = self:GetControl("Middel/tx_number/lab_number")
  self.grid = self:GetControl("Middel/lab_rewards/grid")
  self.btn_3DItem = self:GetControl("Middel/lab_rewards/grid/btn_3DItem")
  self.btn_close = self:GetControl("btn_close")
  self.Enter = self:GetControl("Grid_Btn/Enter")
  self.btn_enter = self:GetControl("Grid_Btn/Enter/btn_enter")
  self.count_L = self:GetControl("Grid_Btn/Enter/count")
  self.lab_count_L = self:GetControl("Grid_Btn/Enter/count/lab_count")
  self.img_icon_L = self:GetControl("Grid_Btn/Enter/count/img_icon")
  self.Mopping = self:GetControl("Grid_Btn/Mopping")
  self.btn_mopping = self:GetControl("Grid_Btn/Mopping/btn_mopping")
  self.count_R = self:GetControl("Grid_Btn/Mopping/count")
  self.lab_count_R = self:GetControl("Grid_Btn/Mopping/count/lab_count")
  self.btn_add = self:GetControl("Grid_Btn/Mopping/count/btn_add")
  self.btn_minus = self:GetControl("Grid_Btn/Mopping/count/btn_minus")
  self.img_icon_R = self:GetControl("Grid_Btn/Mopping/count/img_icon")
  self.descBtn = self:GetControl("descBtn")
end

function Instance_GoldOriginUI:Init()
  self.curSetCount = 1
  self.onceMoppingMaxCount = GlobalConfig.GetGlobalConfig_Number(63000005)
  local cfgMapTransfer = ClientTable.cfg_Map_transferManager:TryGetValue(26000101)
  self.enterCost = cfgMapTransfer and cfgMapTransfer.cost and string.split(cfgMapTransfer.cost, "#") or {}
  local cfgMapinstance = ClientTable.cfg_Map_instanceManager:TryGetValue(260001, "mapId")
  self.rewardInfo = cfgMapinstance and cfgMapinstance.dropItem and TableParse:SpliteStringToItemCountList(cfgMapinstance.dropItem) or {}
  if cfgMapinstance and string.isNullOrEmpty(cfgMapinstance.rewards) == false then
    local boxTblList = ClientTable.cfg_Box_boxManager:GetTabListByIdAndCondition(tonumber(cfgMapinstance.rewards))
    table.sort(boxTblList, function(a, b)
      return a and b and a.layer < b.layer
    end)
    self.rewardInfo = boxTblList or {}
  end
end

function Instance_GoldOriginUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Instance_GoldOriginUI:InitUI()
  self.btn_ItemContainer = UIUtility.BindUIContainerTemp(self.btn_3DItem, LuaComponentTemplates.UIItemTemplate, self, {isShowTips = true})
end

function Instance_GoldOriginUI:RegistUIEvents()
  self.bg_btnClose:SetOnClick(self, self.bg_btnCloseOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_enter:SetOnClick(self, self.btn_enterOnClick)
  self.btn_mopping:SetOnClick(self, self.btn_moppingOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_add:SetOnClick(self, self.btn_addOnClick)
  self.btn_add:SetOnPress(self, self.btn_addOnClick, self.OnStopPress, 1)
  self.btn_minus:SetOnClick(self, self.btn_minusOnClick)
  self.btn_minus:SetOnPress(self, self.btn_minusOnClick, self.OnStopPress, 1)
end

function Instance_GoldOriginUI:bg_btnCloseOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Instance_GoldOriginUI)
end

function Instance_GoldOriginUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Instance_GoldOriginUI)
end

function Instance_GoldOriginUI:btn_enterOnClick(control)
  if table.count(self.enterCost) ~= 2 then
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.enterCost[1]))
  if bagCount >= tonumber(self.enterCost[2]) then
    networkRequest.ReqJoinGoldCaves(1, 1)
    UIManager.Hide(UIID.Instance_GoldOriginUI)
  else
    TipUtility.ShowQuickGetTipPanel(tonumber(self.enterCost[1]))
  end
end

function Instance_GoldOriginUI:btn_moppingOnClick(control)
  if table.count(self.enterCost) ~= 2 then
    return
  end
  if self.count_R:GetActive() == false then
    self.count_R:SetActive(true)
  else
    local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.enterCost[1]))
    if bagCount // tonumber(self.enterCost[2]) > 0 then
      networkRequest.ReqJoinGoldCaves(2, self.curSetCount)
      UIManager.Hide(UIID.Instance_GoldOriginUI)
      EventManager.Dispatch(Event.CancelClickNpc)
    else
      TipUtility.ShowQuickGetTipPanel(tonumber(self.enterCost[1]))
    end
  end
end

function Instance_GoldOriginUI:btn_addOnClick(control)
  self:RefreshSetCount(self.curSetCount + 1)
end

function Instance_GoldOriginUI:btn_minusOnClick(control)
  self:RefreshSetCount(self.curSetCount - 1)
end

function Instance_GoldOriginUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Instance_GoldOriginUI:RegistEvents()
  self:RegistEvent(Event.Bag_ResBagChange, self.OnBag_ResBagChange, self)
end

function Instance_GoldOriginUI:OnBag_ResBagChange()
  if table.count(self.enterCost) == 2 then
    local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.enterCost[1]))
    self.lab_count_L:SetText(string.GetColorText(bagCount, bagCount >= tonumber(self.enterCost[2]) and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]) .. "/" .. self.enterCost[2])
    self.lab_count_R:SetText(string.GetColorText(self.curSetCount * tonumber(self.enterCost[2]), bagCount // tonumber(self.enterCost[2]) > 0 and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]))
    self.btn_add:SetInteractable(bagCount // tonumber(self.enterCost[2]) > 1)
    self.btn_minus:SetInteractable(bagCount // tonumber(self.enterCost[2]) > 1)
  end
end

function Instance_GoldOriginUI:Refresh()
  self:RefreshReward()
  self:RefreshButton()
  self:RefreshEnterCost()
  self:RefreshSetCount(1)
end

function Instance_GoldOriginUI:RefreshReward()
  self.btn_ItemContainer:SetData(self.rewardInfo or {})
end

function Instance_GoldOriginUI:RefreshButton()
  self.Enter:SetActive(true)
  self.btn_enter:SetActive(true)
  self.count_L:SetActive(true)
  self.Mopping:SetActive(TranScriptData.isFinishedGoldCaves)
  self.btn_mopping:SetActive(TranScriptData.isFinishedGoldCaves)
  self.count_R:SetActive(false)
end

function Instance_GoldOriginUI:RefreshEnterCost()
  if table.count(self.enterCost) == 2 then
    ItemUtility.ShowItemCellByItemId(tonumber(self.enterCost[1]), tonumber(self.enterCost[2]), self.img_icon_L, self, true)
    local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.enterCost[1]))
    self.lab_count_L:SetText(string.GetColorText(bagCount, bagCount >= tonumber(self.enterCost[2]) and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]) .. "/" .. self.enterCost[2])
  end
end

function Instance_GoldOriginUI:RefreshSetCount(count)
  if table.count(self.enterCost) ~= 2 then
    return
  end
  local bagCount = BagInfoData.GetItemTotalCountByItemId(tonumber(self.enterCost[1]))
  self.curCanExchangeCount = bagCount // tonumber(self.enterCost[2])
  local maxCount
  if self.onceMoppingMaxCount and self.curCanExchangeCount then
    local getMinValue = math.min(self.curCanExchangeCount, self.onceMoppingMaxCount)
    maxCount = getMinValue ~= 0 and getMinValue or 1
  end
  if count < 1 then
    count = maxCount
  end
  if maxCount < count then
    count = 1
  end
  self.curSetCount = Mathf.Clamp(count, 1, maxCount)
  self.btn_add:SetInteractable(maxCount ~= 1)
  self.btn_minus:SetInteractable(maxCount ~= 1)
  self.lab_count_R:SetText(string.GetColorText(self.curSetCount * tonumber(self.enterCost[2]), self.curCanExchangeCount > 0 and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]))
  ItemUtility.ShowItemCellByItemId(tonumber(self.enterCost[1]), tonumber(self.enterCost[2]), self.img_icon_R, self, true)
end

function Instance_GoldOriginUI:descBtnOnClick()
  UIManager.Show(UIID.System_DescUI, {id = 1112})
end

function Instance_GoldOriginUI:OnHide()
  self.curSetCount = nil
end
