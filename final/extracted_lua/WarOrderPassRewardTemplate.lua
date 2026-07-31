local WarOrderPassRewardTemplate = {}

function WarOrderPassRewardTemplate:Init(param)
  if param then
    self.rootUI = param.rootUI
    self.type = param.type
  end
  self:InitControls()
  self:InitData()
end

function WarOrderPassRewardTemplate:InitControls()
  self.nowControl = self:GetControl()
  if self.type == 1 then
    self.img_dataNumber = self:GetControl("img_dataNumber")
  else
    self.img_dataNumber = self:GetControl("img_dataBg/img_dataNumber")
  end
  self.btn_OrdItemTask = self:GetControl("img_dataOrdTask/btn_OrdItemTask")
  self.btn_AdvItemTask = self:GetControl("img_dataAdvBuy/btn_AdvItemTask")
  self.btn_AdvItemTask_2 = self:GetControl("img_dataAdvBuy/btn_AdvItemTask_2")
  self.itemRewardCtr = {}
  for i, v in pairs(BattlePassRewardTypeEnum) do
    self.itemRewardCtr[v] = {}
  end
  table.insert(self.itemRewardCtr[BattlePassRewardTypeEnum.Ordinary], self.btn_OrdItemTask)
  table.insert(self.itemRewardCtr[BattlePassRewardTypeEnum.Up], self.btn_AdvItemTask)
  table.insert(self.itemRewardCtr[BattlePassRewardTypeEnum.Up], self.btn_AdvItemTask_2)
  for type, ctrList in pairs(self.itemRewardCtr) do
    for i, ctr in ipairs(ctrList) do
      ctr.itemCellData = ItemCellData()
      ctr.Item_BuyGet = ctr:GetChild("Item_BuyGet")
    end
  end
  self.PayLock_1 = self:GetControl("img_dataOrdTask/go_state/PayLock")
  self.PayLock_2 = self:GetControl("img_dataAdvBuy/go_state/PayLock")
  self.payLockCtr = {}
  self.payLockCtr[BattlePassRewardTypeEnum.Ordinary] = self.PayLock_1
  self.payLockCtr[BattlePassRewardTypeEnum.Up] = self.PayLock_2
end

function WarOrderPassRewardTemplate:InitData()
end

function WarOrderPassRewardTemplate:Refresh(data, ui)
  if data.level then
    self.level = data.level
    self.img_dataNumber:SetText("Lv." .. tostring(data.level))
  end
  if data.isRare then
    self:RefreshRareEffect()
  end
  if data.levelReward then
    self:RefreshReward(data.levelReward, ui)
  end
end

function WarOrderPassRewardTemplate:RefreshRareEffect()
end

function WarOrderPassRewardTemplate:RefreshReward(levelReward, ui)
  for type, ctrList in pairs(self.itemRewardCtr) do
    for i, ctr in ipairs(ctrList) do
      local itemInfo = levelReward[type].rewards[i]
      if itemInfo then
        ctr:SetActive(true)
        local itemData = ItemUtility.GenerateItemData(itemInfo.itemId)
        itemData.count = itemInfo.count
        ctr.itemCellData = ctr.itemCellData or ItemCellData()
        ctr.itemCellData:RefreshData(itemData)
        ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
        if levelReward[type].state == GuardRewardStateEnum.CanGet then
          ctr.id = levelReward[type].id
          ctr:SetOnClick(self, self.GetRewardOnClick)
        end
        ctr.Item_BuyGet:SetActive(levelReward[type].state == GuardRewardStateEnum.Got)
      else
        ItemUtility.ReleaseItemCell(ctr, ctr.itemCellData)
        ctr:SetActive(false)
      end
      self.payLockCtr[type]:SetActive(levelReward[type].state == GuardRewardStateEnum.NotGet)
    end
  end
end

function WarOrderPassRewardTemplate:GetRewardOnClick(control)
  local tbl = {}
  tbl.rewardId = {
    control.id
  }
  NetManager.Send(CommerceMessage.ReqZhanLingReward, tbl)
end

function WarOrderPassRewardTemplate:Exit()
  self:ReleaseModel()
end

function WarOrderPassRewardTemplate:ReleaseModel()
  for type, ctrList in pairs(self.itemRewardCtr) do
    for i, ctr in ipairs(ctrList) do
      ItemUtility.ReleaseItemCell(ctr, ctr.itemCellData)
    end
  end
end

return WarOrderPassRewardTemplate
