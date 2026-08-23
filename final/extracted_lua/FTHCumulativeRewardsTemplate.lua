local FTHCumulativeRewardsTemplate = {}

function FTHCumulativeRewardsTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function FTHCumulativeRewardsTemplate:InitControls()
  self.item = self:GetControl("btn_Item")
  self.lab_count = self:GetControl("TreasureNum")
  self.getEffect = self:GetControl("img_Choose")
  self.img_rewardGet = self:GetControl("rewardGet")
end

function FTHCumulativeRewardsTemplate:BindUIEvent()
  self.getEffect:SetOnClick(self, self.getEffectOnClick)
end

function FTHCumulativeRewardsTemplate:getEffectOnClick()
  if self.data == nil or self.data.state == nil or type(self.data.state) ~= "number" then
    return
  end
  if self.data.state == GuardRewardStateEnum.CanGet then
    networkRequest.ReqGetFireAlreadyReceived(self.data.id)
  end
end

function FTHCumulativeRewardsTemplate:Refresh(data, ui)
  if data == nil or ui == nil then
    self:UIControl():SetActive(false)
    return
  end
  self.data = data
  self.root = ui
  self:RefreshModelView()
  self:RefreshUIView()
end

function FTHCumulativeRewardsTemplate:RefreshModelView()
  local itemId, count = QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetBoxDataByBoxId(self.data.itemId)
  ItemUtility.ShowItemCellByItemId(itemId == 0 and self.data.itemId or itemId, count == 0 and self.data.count or count, self.item, self.root, true)
end

function FTHCumulativeRewardsTemplate:RefreshUIView()
  self.lab_count:SetText(tostring(self.data.Times or 0) .. " l\225\186\167n")
  if self.data.state == GuardRewardStateEnum.NotGet then
    self.getEffect:SetActive(false)
    self.img_rewardGet:SetActive(false)
  elseif self.data.state == GuardRewardStateEnum.CanGet then
    self.getEffect:SetActive(true)
    self.img_rewardGet:SetActive(false)
  elseif self.data.state == GuardRewardStateEnum.Got then
    self.getEffect:SetActive(false)
    self.img_rewardGet:SetActive(true)
  end
end

return FTHCumulativeRewardsTemplate
