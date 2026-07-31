Activity_WolffortRankUI = class(BaseUI)
Activity_WolffortRankUI.layer = UILayer.Panel
Activity_WolffortRankUI.orderInLayer = 0
Activity_WolffortRankUI.hideType = UIHideType.WaitDestroy
Activity_WolffortRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_WolffortRankUI.escClose = UIEscClose.DontClose

function Activity_WolffortRankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.lab_time = self:GetControl("img_bg/lab_time")
  self.lab_timeLoss = self:GetControl("img_bg/lab_timeLoss")
  self.person_rank = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.lab_myName = self:GetControl("img_bg/MyItem/lab_myName")
  self.lab_myOccupation = self:GetControl("img_bg/MyItem/lab_myOccupation")
  self.lab_myLevel = self:GetControl("img_bg/MyItem/lab_myLevel")
  self.lab_myKill_rank = self:GetControl("img_bg/MyItem/lab_myKill_rank")
  self.lab_myRank = self:GetControl("img_bg/MyItem/txt_myRank/lab_myRank")
  self.btn_myGiftItem = self:GetControl("img_bg/MyItem/lab_myGift/btn_myGiftItem")
end

function Activity_WolffortRankUI:OnPreLoad()
end

local function RewardCreat(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(ctr)
  ctr.ModelData = ItemCellData()
end

local function RewardRefresh(ctr, _, info, ui)
  local reward = string.split(info, "#")
  local itemData = ItemUtility.GenerateItemData(tonumber(reward[1]))
  itemData.count = tonumber(reward[2])
  ctr.ModelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.ModelData, ui, true)
end

local function ItemCreate(ctr)
  ctr.lab_rank = UIControl(ctr.transform, "lab_rank")
  ctr.lab_img_rank = UIControl(ctr.transform, "lab_img_rank")
  ctr.lab_name = UIControl(ctr.transform, "lab_name")
  ctr.lab_occupation = UIControl(ctr.transform, "lab_occupation")
  ctr.lab_level = UIControl(ctr.transform, "lab_level")
  ctr.lab_kill_rank = UIControl(ctr.transform, "lab_kill_rank")
  ctr.rewardItem = UIControl(ctr.transform, "lab_rank_gift/btn_giftItem")
  ctr.rewardContainer = UIContainer(ctr.rewardItem, self, RewardCreat, RewardRefresh)
end

local function ItemRefresh(ctr, _, info, ui)
  ctr.lab_rank:SetText(info.rank)
  if info.rank > 3 then
    ctr.lab_img_rank:SetActive(false)
  else
    ctr.lab_img_rank:SetActive(true)
    ui:SetSprite("Atlas_Main", "ico_" .. info.rank, ctr.lab_img_rank, false)
  end
  ctr.lab_name:SetText(info.name)
  ctr.lab_occupation:SetText(RoleUtility.GteCareerNameByType(info.carreer))
  ctr.lab_level:SetText(info.level)
  ctr.lab_kill_rank:SetText(info.score)
  local rewardItemStrs = string.split(info.reward, "&")
  ctr.rewardContainer:SetData(rewardItemStrs)
end

function Activity_WolffortRankUI:Init()
end

function Activity_WolffortRankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_WolffortRankUI:InitUI()
  self.RanksInforContainer = UIContainer(self.person_rank, self, ItemCreate, ItemRefresh)
  self.MyGiftContainer = UIContainer(self.btn_myGiftItem, self, RewardCreat, RewardRefresh)
end

function Activity_WolffortRankUI:OnShow()
  if self.args.success then
    self.lab_time:SetActive(true)
    self.lab_timeLoss:SetActive(false)
  else
    self.lab_time:SetActive(false)
    self.lab_timeLoss:SetActive(true)
  end
  self:RegistEvents()
  self:Refresh()
end

function Activity_WolffortRankUI:OnHide()
end

function Activity_WolffortRankUI:OnDestroy()
end

function Activity_WolffortRankUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_WolffortRankUI:btn_closeBgOnClick(control)
end

function Activity_WolffortRankUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Activity_WolffortRankUI)
end

function Activity_WolffortRankUI:RegistEvents()
end

function Activity_WolffortRankUI:Refresh()
  self.RanksInforContainer:SetData(Activity_LangHunYaoSaiData.Ranks.ranks)
  self.lab_myName:SetText(Activity_LangHunYaoSaiData.Ranks.myRank.name)
  self.lab_myOccupation:SetText(RoleUtility.GteCareerNameByType(Activity_LangHunYaoSaiData.Ranks.myRank.carreer))
  self.lab_myLevel:SetText(Activity_LangHunYaoSaiData.Ranks.myRank.level)
  self.lab_myKill_rank:SetText(Activity_LangHunYaoSaiData.Ranks.myRank.score)
  local rewards = string.split(Activity_LangHunYaoSaiData.Ranks.myRank.reward, "&")
  self.MyGiftContainer:SetData(rewards)
  self.lab_myRank:SetText(Activity_LangHunYaoSaiData.Ranks.myRank.rank)
end
