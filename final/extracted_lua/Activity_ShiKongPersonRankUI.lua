Activity_ShiKongPersonRankUI = class(BaseUI)
Activity_ShiKongPersonRankUI.layer = UILayer.Panel
Activity_ShiKongPersonRankUI.orderInLayer = 0
Activity_ShiKongPersonRankUI.hideType = UIHideType.WaitDestroy
Activity_ShiKongPersonRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_ShiKongPersonRankUI.escClose = UIEscClose.DontClose

function Activity_ShiKongPersonRankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.person_rank_Item = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.person_img_noRank_My = self:GetControl("img_bg/MyRank/img_noRank")
  self.person_Lab_Rank_My = self:GetControl("img_bg/MyRank/lab_rank")
  self.person_Lab_Name_My = self:GetControl("img_bg/MyRank/lab_name")
  self.person_Lab_unionName_My = self:GetControl("img_bg/MyRank/lab_unionName")
  self.person_Lab_value_My = self:GetControl("img_bg/MyRank/lab_value")
  self.person_Btn_giftItem_My = self:GetControl("img_bg/MyRank/gift/btn_giftItem")
end

function Activity_ShiKongPersonRankUI:Init()
end

function Activity_ShiKongPersonRankUI:OnCreate()
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

local function OnPersonRankItemRefresh(_control, _index, _data, _ui)
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
  _control.lab_name:SetText(_data.name)
  _control.lab_value:SetText(_data.score)
  _control.lab_unionName:SetText(_data.unionName)
  local personRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_PersonRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(personRankRewardInfoData, _data.rank)
  if rankRewardData == nil then
    return
  end
  _control.rewardContainer:SetData(rankRewardData)
end

function Activity_ShiKongPersonRankUI:InitUI()
  self.personRankContainer = UIContainer(self.person_rank_Item, self, OnUnionRankItemCreate, OnPersonRankItemRefresh)
  self.person_Btn_giftItem_MyContainer = UIContainer(self.person_Btn_giftItem_My, self, OnRewardItemCreate, OnRewardItemRefresh)
end

function Activity_ShiKongPersonRankUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_ShiKongPersonRankUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.Activity_ShiKongPersonRankUI)
end

function Activity_ShiKongPersonRankUI:btn_closeOnClick()
  UIManager.Hide(UIID.Activity_ShiKongPersonRankUI)
end

function Activity_ShiKongPersonRankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_ShiKongPersonRankUI:RegistEvents()
end

function Activity_ShiKongPersonRankUI:Refresh()
  self:RefreshPersonRankPanel()
end

function Activity_ShiKongPersonRankUI:RefreshPersonRankPanel()
  self.personRankContainer:SetActiveTable()
  self.person_img_noRank_My:SetActive(true)
  self.person_Lab_Rank_My:SetText("")
  self.person_Lab_Name_My:SetText("")
  self.person_Lab_unionName_My:SetText("")
  self.person_Lab_value_My:SetText("")
  self.person_Btn_giftItem_MyContainer:SetActiveTable()
  local resSpaceCrackSettlementPersonRankInfoData = QuickFind:GetSpaceCrackDataManager().m_ResSpaceCrackSettlementPersonRankInfoData
  if resSpaceCrackSettlementPersonRankInfoData == nil or resSpaceCrackSettlementPersonRankInfoData.ranks == nil then
    return
  end
  self.personRankContainer:SetData(resSpaceCrackSettlementPersonRankInfoData.ranks)
  local selfPersonRankData
  for i, v in ipairs(resSpaceCrackSettlementPersonRankInfoData.ranks) do
    if v.rid == RoleManager.me.id then
      selfPersonRankData = v
      break
    end
  end
  if selfPersonRankData == nil then
    return
  end
  self.person_Lab_Rank_My:SetText(selfPersonRankData.rank)
  self.person_Lab_Name_My:SetText(selfPersonRankData.name)
  self.person_Lab_unionName_My:SetText(selfPersonRankData.unionName)
  self.person_Lab_value_My:SetText(selfPersonRankData.score)
  self.person_img_noRank_My:SetActive(false)
  local personRankRewardInfoData = QuickFind:GetSpaceCrackDataManager().m_PersonRankRewardInfoData
  local rankRewardData = QuickFind:GetSpaceCrackDataManager():GetAppointRankRewardData(personRankRewardInfoData, selfPersonRankData.rank)
  if rankRewardData == nil then
    return
  end
  self.person_Btn_giftItem_MyContainer:SetData(rankRewardData)
end

function Activity_ShiKongPersonRankUI:OnHide()
end

function Activity_ShiKongPersonRankUI:OnDestroy()
end
