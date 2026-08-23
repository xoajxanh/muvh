local AnniversaryActivityBattleOrderTemplate = {}
local BattleOrderGetState = {
  PayLock = enum(1),
  CanGet = enum(2),
  Got = enum(3)
}

function AnniversaryActivityBattleOrderTemplate:Init()
  self:InitControls()
  self:RegistUIEvents()
end

function AnniversaryActivityBattleOrderTemplate:InitControls()
  self.btn_OrdItemTask = self:GetControl("img_dataOrdTask/btn_OrdItemTask")
  self.normalState = self:GetControl("img_dataOrdTask/go_state")
  self.normalPayLock = self:GetControl("img_dataOrdTask/go_state/PayLock")
  self.normalCanGet = self:GetControl("img_dataOrdTask/go_state/CanGet")
  self.normalGot = self:GetControl("img_dataOrdTask/btn_OrdItemTask/img_select")
  self.btn_AdvItemTask = self:GetControl("img_dataAdvBuy/btn_AdvItemTask")
  self.highState = self:GetControl("img_dataAdvBuy/go_state")
  self.highPayLock = self:GetControl("img_dataAdvBuy/go_state/PayLock")
  self.highCanGet = self:GetControl("img_dataAdvBuy/go_state/CanGet")
  self.highGot = self:GetControl("img_dataAdvBuy/btn_AdvItemTask/img_select")
  self.img_dataNumber = self:GetControl("img_bg/img_dataNumber")
end

function AnniversaryActivityBattleOrderTemplate:RegistUIEvents()
  self.btn_OrdItemTask:SetOnClick(self, self.NormalCanGetOnClick)
  self.btn_AdvItemTask:SetOnClick(self, self.HighCanGetOnClick)
end

function AnniversaryActivityBattleOrderTemplate:NormalCanGetOnClick(control)
  if self.rewardData[1].id and self.rewardData[1].commerceId then
    local rewardId = {}
    table.insert(rewardId, self.rewardData[1].id)
    NetManager.Send(CommerceMessage.ReqAnniversaryReward, {
      rewardId = rewardId,
      commerceId = self.rewardData[1].commerceId
    })
    self:ShowRewardTip(self.rewardData[1])
  end
end

function AnniversaryActivityBattleOrderTemplate:HighCanGetOnClick(control)
  if self.rewardData[2].id and self.rewardData[2].commerceId then
    local rewardId = {}
    table.insert(rewardId, self.rewardData[2].id)
    NetManager.Send(CommerceMessage.ReqAnniversaryReward, {
      rewardId = rewardId,
      commerceId = self.rewardData[2].commerceId
    })
    self:ShowRewardTip(self.rewardData[2])
  end
end

function AnniversaryActivityBattleOrderTemplate:ShowRewardTip(rewardData)
  local str = string.split(rewardData.reward, "#")
  local ItemInfo = ItemUtility.GenerateItemData(tonumber(str[1]))
  ItemInfo.count = tonumber(str[2])
  local ItemData = {}
  table.insert(ItemData, ItemInfo)
  UIManager.Show(UIID.Tip_RewardTipUI, {rewards = ItemData})
end

function AnniversaryActivityBattleOrderTemplate:Refresh(data, ui)
  if not data[1] or not data[2] then
    return
  end
  self.rewardData = data
  if data[1].level == data[2].level then
    self.img_dataNumber:SetText(data[1].level)
  else
    self.img_dataNumber:SetText("")
  end
  self:ShowItem(data[1], self.btn_OrdItemTask)
  self:ShowItem(data[2], self.btn_AdvItemTask)
end

function AnniversaryActivityBattleOrderTemplate:ShowItem(reward, control)
  if reward.reward == "" then
    self.btn_OrdItemTask:SetActive(false)
    return
  end
  local showData = {}
  local giftData = string.split(reward.reward, "#")
  showData.itemId = tonumber(giftData[1])
  showData.count = tonumber(giftData[2])
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
    self:SetRewardState(state, tipOrGet)
  else
    self:SetHighRewardState(state, tipOrGet)
  end
end

function AnniversaryActivityBattleOrderTemplate:SetRewardState(state, tipOrGet)
  self.normalState:SetActive(state == BattleOrderGetState.PayLock or state == BattleOrderGetState.CanGet)
  self.normalPayLock:SetActive(state == BattleOrderGetState.PayLock)
  self.normalGot:SetActive(state == BattleOrderGetState.Got)
  if not tipOrGet then
    self.btn_OrdItemTask:SetOnClick(self, self.NormalCanGetOnClick)
  end
end

function AnniversaryActivityBattleOrderTemplate:SetHighRewardState(state, tipOrGet)
  self.highState:SetActive(state == BattleOrderGetState.PayLock or state == BattleOrderGetState.CanGet)
  self.highPayLock:SetActive(state == BattleOrderGetState.PayLock)
  self.highGot:SetActive(state == BattleOrderGetState.Got)
  if not tipOrGet then
    self.btn_AdvItemTask:SetOnClick(self, self.HighCanGetOnClick)
  end
end

return AnniversaryActivityBattleOrderTemplate
