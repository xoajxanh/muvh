local AnniversaryActivityBattleOrderPanelTemplate = {}
local root = {}
local BattleOrderGetState = {
  PayLock = enum(1),
  CanGet = enum(2),
  Got = enum(3)
}

function AnniversaryActivityBattleOrderPanelTemplate:Init()
  self:InitControls()
  self:InitUI()
  self:ResgistUIEvents()
end

function AnniversaryActivityBattleOrderPanelTemplate:InitControls()
  self.sw_CelebrationPass = self:GetControl("sw_CelebrationPass")
  self.Content = self:GetControl("sw_CelebrationPass/Viewport/Content")
  self.item_CelebrationPass = self:GetControl("item_CelebrationPass")
end

function AnniversaryActivityBattleOrderPanelTemplate:InitUI()
end

function AnniversaryActivityBattleOrderPanelTemplate:TryInitControls(obj)
  if obj.btn_OrdItemTask == nil then
    obj.btn_OrdItemTask = obj:GetChild("img_dataOrdTask/btn_OrdItemTask")
  end
  if obj.normalState == nil then
    obj.normalState = obj:GetChild("img_dataOrdTask/go_state")
  end
  if obj.normalPayLock == nil then
    obj.normalPayLock = obj:GetChild("img_dataOrdTask/go_state/PayLock")
  end
  if obj.normalCanGet == nil then
    obj.normalCanGet = obj:GetChild("img_dataOrdTask/go_state/CanGet")
  end
  if obj.normalGot == nil then
    obj.normalGot = obj:GetChild("img_dataOrdTask/btn_OrdItemTask/img_select")
  end
  if obj.btn_AdvItemTask == nil then
    obj.btn_AdvItemTask = obj:GetChild("img_dataAdvBuy/btn_AdvItemTask")
  end
  if obj.highState == nil then
    obj.highState = obj:GetChild("img_dataAdvBuy/go_state")
  end
  if obj.highPayLock == nil then
    obj.highPayLock = obj:GetChild("img_dataAdvBuy/go_state/PayLock")
  end
  if obj.highCanGet == nil then
    obj.highCanGet = obj:GetChild("img_dataAdvBuy/go_state/CanGet")
  end
  if obj.highGot == nil then
    obj.highGot = obj:GetChild("img_dataAdvBuy/btn_AdvItemTask/img_select")
  end
  if obj.img_dataNumber == nil then
    obj.img_dataNumber = obj:GetChild("img_bg/img_dataNumber")
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:ResgistUIEvents()
end

function AnniversaryActivityBattleOrderPanelTemplate:Refresh(ui)
  if ui == nil then
    return
  end
  root = ui
  self:SetDefaultLevelIndex()
  self:RefreshItemView(self.selectIndex)
end

function AnniversaryActivityBattleOrderPanelTemplate:SetDefaultLevelIndex()
  self.battleOrderItemTbl = AnniversaryActivity_BattleOrderData.GetBattleOrderRewardData()
  self.selectIndex = AnniversaryActivity_BattleOrderData.battleOrderLevel or 1
  if self.selectIndex == 0 then
    self.selectIndex = 1
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:RefreshItemView(selectIndex)
  if self.itemTableView == nil then
    self.itemTableView = UITableView:CreateTableView(self.sw_CelebrationPass, self.item_CelebrationPass, self.battleOrderItemTbl, EScrollViewDireEnum.Horizontal, self.UpdateCellCallBack, self)
  end
  if self.itemTableView then
    self.itemTableView:ReloadData(selectIndex)
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:UpdateCellCallBack(index)
  if type(self.battleOrderItemTbl) ~= "table" or next(self.battleOrderItemTbl) == nil then
    return
  end
  if self.battleOrderItemTbl[index] ~= nil then
    local cell = self.itemTableView:GetLoadedCell(index)
    self:RefreshRewardOption(self.battleOrderItemTbl[index], cell, index)
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:RefreshRewardOption(data, obj, index)
  self:TryInitControls(obj)
  if not data[1] or not data[2] then
    return
  end
  if data[1].level == data[2].level then
    obj.img_dataNumber:SetText(data[1].level)
  else
    obj.img_dataNumber:SetText("")
  end
  self:ShowItem(data[1], obj.btn_OrdItemTask, obj)
  self:ShowItem(data[2], obj.btn_AdvItemTask, obj)
end

function AnniversaryActivityBattleOrderPanelTemplate:ShowItem(reward, control, obj)
  if reward.reward == "" then
    return
  end
  local showData = {}
  local giftData = string.split(reward.reward, "#")
  showData.itemId = tonumber(giftData[1])
  showData.count = tonumber(giftData[2])
  obj.reward = reward
  obj.showData = showData
  local itemData = ItemUtility.GenerateItemData(showData.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = showData.count or 0
  if not control.itemCellData then
    control.itemCellData = ItemCellData()
  elseif control.itemCellData.model then
    control.itemCellData:RecycleRes()
  end
  control.itemCellData:RefreshData(itemData)
  local tipOrGet = true
  local state = BattleOrderGetState.PayLock
  if (reward.type == 1 or AnniversaryActivity_BattleOrderData.isUnLockHighReward == true and reward.type == 2) and reward.level and reward.level <= AnniversaryActivity_BattleOrderData.battleOrderLevel then
    state = BattleOrderGetState.CanGet
    tipOrGet = false
    for i, v in pairs(AnniversaryActivity_BattleOrderData.hasRewardId) do
      if v == reward.id then
        state = BattleOrderGetState.Got
        tipOrGet = true
        break
      end
    end
  end
  ItemUtility.ShowItemCell(control, control.itemCellData, ui, tipOrGet)
  if reward.type == 1 then
    self:SetRewardState(state, tipOrGet, obj)
  else
    self:SetHighRewardState(state, tipOrGet, obj)
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:SetRewardState(state, tipOrGet, obj)
  obj.normalState:SetActive(state == BattleOrderGetState.PayLock or state == BattleOrderGetState.CanGet)
  obj.normalPayLock:SetActive(state == BattleOrderGetState.PayLock)
  obj.normalGot:SetActive(state == BattleOrderGetState.Got)
  if not tipOrGet then
    obj.btn_OrdItemTask:SetOnClickParam(self, self.CanGetOnClick, {
      reward = obj.reward,
      showData = obj.showData
    })
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:SetHighRewardState(state, tipOrGet, obj)
  obj.highState:SetActive(state == BattleOrderGetState.PayLock or state == BattleOrderGetState.CanGet)
  obj.highPayLock:SetActive(state == BattleOrderGetState.PayLock)
  obj.highGot:SetActive(state == BattleOrderGetState.Got)
  if not tipOrGet then
    obj.btn_AdvItemTask:SetOnClickParam(self, self.CanGetOnClick, {
      reward = obj.reward,
      showData = obj.showData
    })
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:CanGetOnClick(obj)
  if obj.param.reward.id and obj.param.reward.commerceId then
    local rewardId = {}
    table.insert(rewardId, obj.param.reward.id)
    NetManager.Send(CommerceMessage.ReqAnniversaryReward, {
      rewardId = rewardId,
      commerceId = obj.param.reward.commerceId
    })
    self:ShowRewardTip(obj.param.reward)
  end
end

function AnniversaryActivityBattleOrderPanelTemplate:ShowRewardTip(rewardData)
  local str = string.split(rewardData.reward, "#")
  local ItemInfo = ItemUtility.GenerateItemData(tonumber(str[1]))
  ItemInfo.count = tonumber(str[2])
  local ItemData = {}
  table.insert(ItemData, ItemInfo)
  UIManager.Show(UIID.Tip_RewardTipUI, {rewards = ItemData})
end

return AnniversaryActivityBattleOrderPanelTemplate
