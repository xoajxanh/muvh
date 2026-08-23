Duoqi_RewardUI = class(BaseUI)
Duoqi_RewardUI.layer = UILayer.Panel
Duoqi_RewardUI.orderInLayer = 2
Duoqi_RewardUI.hideType = UIHideType.WaitDestroy
Duoqi_RewardUI.hideFunc = UIHideFunc.MoveOutOfScreen
Duoqi_RewardUI.escClose = UIEscClose.DontClose

function Duoqi_RewardUI:InitControls()
  self.rewardListItem = self:GetControl("img_Bg/go_main/panel_DuoQiCross/go_detail/sw_reward/Viewport/Content/panel_personageReward")
  self.btn_close = self:GetControl("img_Bg/bg/btn_close")
  self.btn_closeBg = self:GetControl("btn_closeBg")
end

function Duoqi_RewardUI:Init()
end

function Duoqi_RewardUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function rewardListCreate(ctr1)
  ctr1.title = UIControl(ctr1.transform, "tx_integralReward")
  ctr1.title2 = UIControl(ctr1.transform, "tx_integralReward/img_title_bg/txt_title")
  ctr1.rankItem = UIControl(ctr1.transform, "tx_integralReward/sw_integralReward/Viewport/Content/rankGear")
end

local function rankListCreate(ctr2)
  ctr2.txt = UIControl(ctr2.transform, "")
  ctr2.btnRewards = UIControl(ctr2.transform, "sw_victoriousLeaderReward/Viewport/Content/btn_first")
end

local function rankRewardsCreate(ctr3)
  ctr3.itemCtr = ItemUtility.InitItemCell(UIControl(ctr3.transform))
  ctr3.modelData = ItemCellData()
end

local function rankRewardsRefresh(ctr3, index, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr3.modelData:RecycleRes()
  ctr3.modelData:RefreshData(itemData)
  ctr3.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr3.itemCtr, ctr3.modelData, ui, true)
end

local function rankListRefresh(ctr2, index, data, ui)
  if data == nil then
    return
  end
  ctr2.txt:SetText(data.title)
  local strings = string.split(data.showReward, "&")
  if next(strings) == nil then
    return
  end
  if ctr2.rankRewardListContainer == nil then
    ctr2.rankRewardListContainer = UIContainer(ctr2.btnRewards, ui, rankRewardsCreate, rankRewardsRefresh)
  end
  local rewardInfos = {}
  for i, v in ipairs(strings) do
    local rewardStrs = string.split(v, "#")
    if #rewardStrs ~= 2 then
      return
    end
    table.insert(rewardInfos, {
      itemId = tonumber(rewardStrs[1]),
      count = tonumber(rewardStrs[2])
    })
  end
  ctr2.rankRewardListContainer:SetData(rewardInfos)
end

local function rewardListRefresh(ctr1, index, data, ui)
  local tempCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(data.id)
  if tempCfg == nil or tempCfg.effect == nil then
    return
  end
  local strings = string.split(tempCfg.effect, "&")
  if next(strings) == nil then
    return
  end
  ctr1.title:SetText(strings[1])
  ctr1.title2:SetText(strings[2])
  if ctr1.rankListContainer == nil then
    ctr1.rankListContainer = UIContainer(ctr1.rankItem, ui, rankListCreate, rankListRefresh)
  end
  local rankList
  if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiByMapId() == true then
    rankList = QuickFind:GetDuoQiCrossDataManager():GetRankListByRewardType(index)
  elseif QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
    rankList = QuickFind:GetDuoQiCrossDataManager():GetZhangbaRankListByRewardType(index)
  else
    rankList = QuickFind:GetDuoQiCrossDataManager():GetRankListByRewardType(index)
  end
  ctr1.rankListContainer:SetData(rankList)
end

function Duoqi_RewardUI:InitUI()
  self.rewardListContainer = UIContainer(self.rewardListItem, self, rewardListCreate, rewardListRefresh)
end

function Duoqi_RewardUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Duoqi_RewardUI:btn_closeOnClick()
  UIManager.Hide(UIID.Duoqi_RewardUI)
end

function Duoqi_RewardUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Duoqi_RewardUI:RegistEvents()
  self:RegistEvent(Event.UnionMyLvChangeRefreshUI, self.Refresh, self)
end

function Duoqi_RewardUI:Refresh()
  local rewardListIds = {}
  for i = 1, 3 do
    table.insert(rewardListIds, {
      id = 500220 + i
    })
  end
  self.rewardListContainer:SetData(rewardListIds)
end

function Duoqi_RewardUI:OnHide()
end

function Duoqi_RewardUI:OnDestroy()
end
