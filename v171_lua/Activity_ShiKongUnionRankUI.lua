Activity_ShiKongUnionRankUI = class(BaseUI)
Activity_ShiKongUnionRankUI.layer = UILayer.Panel
Activity_ShiKongUnionRankUI.orderInLayer = 0
Activity_ShiKongUnionRankUI.hideType = UIHideType.WaitDestroy
Activity_ShiKongUnionRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_ShiKongUnionRankUI.escClose = UIEscClose.DontClose

function Activity_ShiKongUnionRankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.union_rank_Item = self:GetControl("img_bg/Scroll View/Viewport/Content/union_rank")
  self.btn_PersonUp = self:GetControl("btn_PersonUp")
end

function Activity_ShiKongUnionRankUI:Init()
end

function Activity_ShiKongUnionRankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnUnionRankItemCreate(_control)
  _control.lab_rank = UIControl(_control.transform, "lab_rank")
  _control.img_rankIcon = UIControl(_control.transform, "img_rankIcon")
  _control.lab_name = UIControl(_control.transform, "lab_name")
  _control.lab_value = UIControl(_control.transform, "lab_value")
  _control.lab_unionName = UIControl(_control.transform, "lab_unionName")
  _control.btn_giftItem = UIControl(_control.transform, "gift/btn_giftItem")
  _control.rankIconDic = {
    [1] = "ico_1",
    [2] = "ico_2",
    [3] = "ico_3"
  }
end

local function OnRewardItemCreate(_control)
  _control.itemCtr = ItemUtility.InitItemCell(UIControl(_control.transform))
  _control.modelData = ItemCellData()
end

local function OnRewardItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  local itemData = ItemUtility.GenerateItemData(_data.itemId)
  itemData.count = _data.count
  _control.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(_control.itemCtr, _control.modelData, _ui, true)
end

local function OnUnionRankItemRefresh(_control, _index, _data, _ui)
  if _data == nil then
    return
  end
  _control:SetActive(true)
  if _control.rewardContainer == nil then
    _control.rewardContainer = UIContainer(_control.btn_giftItem, _ui, OnRewardItemCreate, OnRewardItemRefresh)
  end
  _control.rewardContainer:SetActiveTable()
  if _data.rank <= 3 then
    _ui:SetSprite("Atlas_Main", _control.rankIconDic[_data.rank], _control.img_rankIcon)
    _control.lab_rank:SetText("")
  else
    _control.img_rankIcon:SetActive(false)
    _control.lab_rank:SetText(_data.rank)
  end
  _control.lab_unionName:SetText(string.format("S%s.%s", _data.serverId, _data.unionName))
  _control.lab_name:SetText(_data.leaderName or _data.unionLeaderName)
  _control.lab_value:SetText(_data.score)
  local unionRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_UnionRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(unionRankRewardInfoData, _data.rank)
  if rankRewardData == nil then
    return
  end
  _control.rewardContainer:SetData(rankRewardData)
end

function Activity_ShiKongUnionRankUI:InitUI()
  self.unionRankContainer = UIContainer(self.union_rank_Item, self, OnUnionRankItemCreate, OnUnionRankItemRefresh)
end

function Activity_ShiKongUnionRankUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_PersonUp:SetOnClick(self, self.btn_PersonUpOnClick)
end

function Activity_ShiKongUnionRankUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Activity_ShiKongUnionRankUI)
end

function Activity_ShiKongUnionRankUI:btn_closeOnClick()
  UIManager.Hide(UIID.Activity_ShiKongUnionRankUI)
end

function Activity_ShiKongUnionRankUI:btn_PersonUpOnClick()
  UIManager.Hide(UIID.Activity_ShiKongUnionRankUI)
  UIManager.Show(UIID.Activity_ShiKongPersonRankUI)
end

function Activity_ShiKongUnionRankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_ShiKongUnionRankUI:RegistEvents()
end

function Activity_ShiKongUnionRankUI:Refresh()
  self:RefreshUnionRankPanel()
end

function Activity_ShiKongUnionRankUI:RefreshUnionRankPanel()
  self.unionRankContainer:SetActiveTable()
  local resSpaceCrackSettlementUnionRankInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackSettlementUnionRankInfoData
  if resSpaceCrackSettlementUnionRankInfoData == nil or resSpaceCrackSettlementUnionRankInfoData.ranks == nil then
    return
  end
  self.unionRankContainer:SetData(resSpaceCrackSettlementUnionRankInfoData.ranks)
end

function Activity_ShiKongUnionRankUI:OnHide()
end

function Activity_ShiKongUnionRankUI:OnDestroy()
end
