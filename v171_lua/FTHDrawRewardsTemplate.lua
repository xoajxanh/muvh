local FTHDrawRewardsTemplate = {}

function FTHDrawRewardsTemplate:Init()
  self:InitControls()
  self:BindUIEvent()
end

function FTHDrawRewardsTemplate:InitControls()
  self.item = self:GetControl("btn_TreasureItem")
  self.btn_Baozhu = self:GetControl("btn_Baozhu")
  self.eff_Baozhu = self:GetControl("eff_Baozhu")
end

function FTHDrawRewardsTemplate:BindUIEvent()
  self.btn_Baozhu:SetOnClick(self, self.btn_BaozhuOnClick)
end

function FTHDrawRewardsTemplate:btn_BaozhuOnClick()
  if self.data == nil or self.data.state == nil or type(self.data.state) ~= "number" then
    return
  end
  if self.data.state == GuardRewardStateEnum.CanGet and QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetCurDrawState() == 0 then
    self.btn_Baozhu:SetActive(false)
    self.eff_Baozhu:SetActive(true)
    if self.waitReqServerCoroutine then
      Coroutine.Stop(self.waitReqServerCoroutine)
      self.waitReqServerCoroutine = nil
    end
    self.waitReqServerCoroutine = Coroutine.Start(function()
      QuickFind:GetFirecrackerTreasureHuntingDataMgr():SetCurDrawState(1)
      Coroutine.Wait(1.2)
      networkRequest.ReqFirecrackerTreasureHuntInfo(self.go.transform:GetSiblingIndex())
      Coroutine.Stop(self.waitReqServerCoroutine)
      self.waitReqServerCoroutine = nil
      QuickFind:GetFirecrackerTreasureHuntingDataMgr():SetCurDrawState(0)
    end)
  elseif self.data.state == GuardRewardStateEnum.NotGet then
    FloatingTipUtility.QuickMsg("Ph\195\161o Hoa kh\195\180ng \196\145\225\187\167, h\195\163y nh\225\186\173n Ph\195\161o Hoa ")
  end
end

function FTHDrawRewardsTemplate:Refresh(data, ui)
  self.data = data
  self.root = ui
  self:RefreshModelView()
  self:RefreshUIView()
end

function FTHDrawRewardsTemplate:RefreshModelView()
  if not table.isNullOrEmpty(self.data) and self.data.itemId and self.data.count and self.item and self.root then
    local itemId, count = QuickFind:GetFirecrackerTreasureHuntingDataMgr():GetBoxDataByBoxId(self.data.itemId)
    ItemUtility.ShowItemCellByItemId(itemId == 0 and self.data.itemId or itemId, count == 0 and self.data.count or count, self.item, self.root, true)
  end
end

function FTHDrawRewardsTemplate:RefreshUIView()
  if self.data == nil or self.data.state == nil or type(self.data.state) ~= "number" then
    return
  end
  if self.data.state == GuardRewardStateEnum.NotGet then
    self.btn_Baozhu:SetActive(true)
    self.item:SetActive(false)
    self.eff_Baozhu:SetActive(false)
  elseif self.data.state == GuardRewardStateEnum.CanGet then
    self.btn_Baozhu:SetActive(true)
    self.item:SetActive(false)
    self.eff_Baozhu:SetActive(false)
  elseif self.data.state == GuardRewardStateEnum.Got then
    self.btn_Baozhu:SetActive(false)
    self.item:SetActive(true)
    self.eff_Baozhu:SetActive(false)
  end
end

function FTHDrawRewardsTemplate:OnHide()
  if self.waitReqServerCoroutine then
    Coroutine.Stop(self.waitReqServerCoroutine)
    self.waitReqServerCoroutine = nil
    networkRequest.ReqFirecrackerTreasureHuntInfo(self.go.transform:GetSiblingIndex())
    QuickFind:GetFirecrackerTreasureHuntingDataMgr():SetCurDrawState(0)
  end
end

return FTHDrawRewardsTemplate
