Activity_SiFangRankUI = class(BaseUI)
Activity_SiFangRankUI.layer = UILayer.Panel
Activity_SiFangRankUI.orderInLayer = 0
Activity_SiFangRankUI.hideType = UIHideType.WaitDestroy
Activity_SiFangRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_SiFangRankUI.escClose = UIEscClose.DontClose

function Activity_SiFangRankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.person_rank = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.lab_rank = self:GetControl("img_bg/MyRank/lab_rank")
  self.img_noRank = self:GetControl("img_bg/MyRank/img_noRank")
  self.lab_campName = self:GetControl("img_bg/MyRank/lab_campName")
  self.lab_campIcon = self:GetControl("img_bg/MyRank/lab_campIcon")
  self.lab_legionLeader = self:GetControl("img_bg/MyRank/lab_legionLeader")
  self.lab_integral = self:GetControl("img_bg/MyRank/lab_integral")
  self.btn_giftItem = self:GetControl("img_bg/MyRank/lab_rank_gift/btn_giftItem")
  self.MyRank = self:GetControl("img_bg/MyRank")
  self.myUnion_rank = self:GetControl("img_bg/MyRank/lab_rank")
  self.myUnion_campName = self:GetControl("img_bg/MyRank/lab_campName")
  self.myUnion_campIcon = self:GetControl("img_bg/MyRank/lab_campIcon")
  self.myUnion_legionLeader = self:GetControl("img_bg/MyRank/lab_legionLeader")
  self.myUnion_integral = self:GetControl("img_bg/MyRank/lab_integral")
  self.myUnion_giftItem = self:GetControl("img_bg/MyRank/lab_rank_gift/btn_giftItem")
  self.myUnion_win = self:GetControl("img_bg/MyRank/lab_settlement/lab_win")
  self.myUnion_lose = self:GetControl("img_bg/MyRank/lab_settlement/lab_lose")
end

function Activity_SiFangRankUI:Init()
end

function Activity_SiFangRankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnCreateRewardItem(ctr)
  ctr.itemCtr = UIControl(ctr.transform)
  ctr.modelData = ItemCellData()
end

local function OnRefreshRewardItem(ctr, _, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(tonumber(data[1]))
  itemData.count = tonumber(data[2])
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr, ctr.modelData, ui, true)
end

local function OnCreateRankItem(ctr)
  ctr.lab_rank = UIControl(ctr.transform, "lab_rank")
  ctr.img_rankIcon = UIControl(ctr.transform, "img_rankIcon")
  ctr.lab_campName = UIControl(ctr.transform, "lab_campName")
  ctr.lab_campIcon = UIControl(ctr.transform, "lab_campIcon")
  ctr.lab_legionLeader = UIControl(ctr.transform, "lab_legionLeader")
  ctr.lab_integral = UIControl(ctr.transform, "lab_integral")
  ctr.lab_win = UIControl(ctr.transform, "lab_settlement/lab_win")
  ctr.lab_lose = UIControl(ctr.transform, "lab_settlement/lab_lose")
  ctr.btn_giftItem = UIControl(ctr.transform, "lab_rank_gift/btn_giftItem")
end

local function OnRefreshRankItem(ctr, _, data, ui)
  if data == nil then
    return
  end
  if ctr.img_RankIconCoroutine then
    Coroutine.Stop(ctr.img_RankIconCoroutine)
    ctr.img_RankIconCoroutine = nil
  end
  local isShowRankIcon = data.rank <= 3
  ctr.lab_rank:SetText(data.rank)
  ctr.lab_rank:SetActive(not isShowRankIcon)
  ctr.img_rankIcon:SetActive(isShowRankIcon)
  if isShowRankIcon then
    ctr.img_RankIconCoroutine = ui:SetSprite("Atlas_Main", "ico_" .. data.rank, ctr.img_rankIcon, true)
  end
  local unionCfg = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(data.campId)
  ui:SetSprite("Atlas_Common", unionCfg.campImage, ctr.lab_campIcon, true)
  ctr.lab_campName:SetText(unionCfg.unionName)
  ctr.lab_legionLeader:SetText(data.campLeader)
  ctr.lab_integral:SetText(data.score)
  if ctr.rewardContainer == nil then
    ctr.rewardContainer = UIContainer(ctr.btn_giftItem, ui, OnCreateRewardItem, OnRefreshRewardItem)
  end
end

function Activity_SiFangRankUI:InitUI()
  self.rankContainer = UIContainer(self.person_rank, self, OnCreateRankItem, OnRefreshRankItem)
  self.myUnionRewardContainer = UIContainer(self.myUnion_giftItem, self, OnCreateRewardItem, OnRefreshRewardItem)
end

function Activity_SiFangRankUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_SiFangRankUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_SiFangRankUI)
end

function Activity_SiFangRankUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_SiFangRankUI)
end

function Activity_SiFangRankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_SiFangRankUI:RegistEvents()
  self:RegistEvent(Event.RefreshSiFangRankUI, self.Refresh, self)
end

function Activity_SiFangRankUI:Refresh()
  if FourPartyRivalryManager.m_FourPartyRivalryRankData == nil then
    return
  end
  local campRankDataList = FourPartyRivalryManager.m_FourPartyRivalryRankData.campList
  if table.count(campRankDataList) > 0 then
    table.sort(campRankDataList, function(a, b)
      return a.rank < b.rank
    end)
    self.rankContainer:SetData(campRankDataList)
    self:ChangeCampState()
    self:ShowRankReward()
  end
end

function Activity_SiFangRankUI:RefreshMyCampRank(rankData)
  self.myUnion_rank:SetText(rankData.rank)
  local campName = ClientTable.cfg_Activity_sifangCampManager:TryGetValue(rankData.campId)
  self.myUnion_campName:SetText(campName.unionName)
  if campName and campName.campImage then
    self:SetSprite("Atlas_Common", campName.campImage, self.myUnion_campIcon, true)
  end
  self.myUnion_legionLeader:SetText(rankData.campLeader)
  self.myUnion_integral:SetText(rankData.score)
  local rewardTbl = QuickFind:GetSiFangZhengBaDataManager():GetRankRewardData(SiFangZhengBaRewardType.AllUnionReward)[rankData.rank]
  if rewardTbl then
    local allRewardStr = string.split(rewardTbl.showReward, "&")
    local allRewardData = {}
    for i, v in ipairs(allRewardStr) do
      table.insert(allRewardData, string.split(v, "#"))
    end
    self.myUnionRewardContainer:SetData(allRewardData)
  end
  local isFinish = FourPartyRivalryManager.m_FourPartyRivalryRankData.close
  if isFinish == true then
    if rankData.rank == 1 then
      self.myUnion_win:SetActive(true)
      self.myUnion_lose:SetActive(false)
    else
      self.myUnion_win:SetActive(false)
      self.myUnion_lose:SetActive(true)
    end
  else
    self.myUnion_win:SetActive(false)
    self.myUnion_lose:SetActive(false)
  end
end

function Activity_SiFangRankUI:ChangeCampState()
  if self.rankContainer == nil or type(self.rankContainer) ~= "table" then
    return
  end
  if FourPartyRivalryManager.m_FourPartyRivalryRankData == nil or FourPartyRivalryManager.m_FourPartyRivalryRankData.close == false then
    for i = 1, #self.rankContainer.items do
      self.rankContainer.items[i].lab_win:SetActive(false)
      self.rankContainer.items[i].lab_lose:SetActive(false)
    end
    return
  end
  for i = 1, #self.rankContainer.items do
    if i == 1 then
      self.rankContainer.items[i].lab_win:SetActive(true)
      self.rankContainer.items[i].lab_lose:SetActive(false)
    else
      self.rankContainer.items[i].lab_win:SetActive(false)
      self.rankContainer.items[i].lab_lose:SetActive(true)
    end
  end
end

function Activity_SiFangRankUI:ShowRankReward()
  if self.rankContainer == nil or type(self.rankContainer) ~= "table" then
    return
  end
  local rewardTbl = QuickFind:GetSiFangZhengBaDataManager():GetRankRewardData(SiFangZhengBaRewardType.AllUnionReward)
  if rewardTbl == nil then
    return
  end
  for i = 1, #self.rankContainer.items do
    if self.rankContainer.items[i].rewardContainer == nil or rewardTbl[i] == nil then
      return
    end
    local allRewardStr = string.split(rewardTbl[i].showReward, "&")
    local allRewardData = {}
    for i, v in ipairs(allRewardStr) do
      table.insert(allRewardData, string.split(v, "#"))
    end
    self.rankContainer.items[i].rewardContainer:SetData(allRewardData)
  end
end

function Activity_SiFangRankUI:OnHide()
end

function Activity_SiFangRankUI:OnDestroy()
end
