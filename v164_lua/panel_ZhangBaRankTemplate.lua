local panel_ZhangBaRankTemplate = {}

function panel_ZhangBaRankTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function panel_ZhangBaRankTemplate:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.settleItem = self:GetControl("img_bg/Scroll View/Viewport/Content/union_rank")
  self.obj_noRank = self:GetControl("img_bg/MyRank/img_noRank")
  self.txt_myUnionRank = self:GetControl("img_bg/MyRank/lab_rank")
  self.txt_myUnionName = self:GetControl("img_bg/MyRank/lab_unionName")
  self.txt_myUnionLevel = self:GetControl("img_bg/MyRank/lab_occupation")
  self.txt_myLeaderName = self:GetControl("img_bg/MyRank/lab_name")
  self.txt_myUnionScore = self:GetControl("img_bg/MyRank/lab_value")
  self.myRewardItem = self:GetControl("img_bg/MyRank/gift/btn_giftItem")
end

local function OnSettleRewardCreate(ctr1)
  ctr1.itemCtr = ItemUtility.InitItemCell(UIControl(ctr1.transform))
  ctr1.modelData = ItemCellData()
end

local function OnSettleItemCreate(ctr2)
  ctr2.img_bg = UIControl(ctr2.transform, "")
  ctr2.img_rankIcon = UIControl(ctr2.transform, "img_rankIcon")
  ctr2.txt_rank = UIControl(ctr2.transform, "lab_rank")
  ctr2.unionName = UIControl(ctr2.transform, "lab_unionName")
  ctr2.unionLevel = UIControl(ctr2.transform, "lab_legionLevel")
  ctr2.leaderName = UIControl(ctr2.transform, "lab_name")
  ctr2.unionScore = UIControl(ctr2.transform, "lab_value")
  ctr2.settleRewardItem = UIControl(ctr2.transform, "gift/btn_giftItem")
end

local function OnSettleRewardRefresh(ctr1, index, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr1.modelData:RecycleRes()
  ctr1.modelData:RefreshData(itemData)
  ctr1.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr1.itemCtr, ctr1.modelData, ui, true)
end

local function OnSettleItemRefresh(ctr2, index, data, ui)
  if data.rank <= 3 and data.rank >= 1 then
    local infos = QuickFind:GetDuoQiCrossDataManager():GetRankMaterialOfSettleByRank(data.rank)
    ui:SetSprite(infos.bgAtlas, infos.bgName, ctr2.img_bg)
    ctr2.img_rankIcon:SetActive(true)
    ctr2.txt_rank:SetActive(false)
    ui:SetSprite(infos.iconAtlas, infos.iconName, ctr2.img_rankIcon)
  else
    ctr2.img_rankIcon:SetActive(false)
    ctr2.txt_rank:SetActive(true)
    ctr2.txt_rank:SetText(data.rank)
  end
  ctr2.unionName:SetText("S" .. data.serverId .. "." .. data.unionName)
  ctr2.unionLevel:SetText("LV." .. data.unionLevel)
  ctr2.leaderName:SetText(data.leaderName)
  ctr2.unionScore:SetText(data.score)
  if ctr2.settleRewardContainter == nil then
    ctr2.settleRewardContainter = UIContainer(ctr2.settleRewardItem, ui, OnSettleRewardCreate, OnSettleRewardRefresh)
  end
  local showRewardCfg = QuickFind:GetDuoQiCrossDataManager():GetUnionShowRewardCfgByRank(data.rank, true)
  ctr2.settleRewardContainter:SetData(showRewardCfg)
end

function panel_ZhangBaRankTemplate:InitUI()
  self.settleContainer = UIContainer(self.settleItem, self.root, OnSettleItemCreate, OnSettleItemRefresh)
  self.myRewardContainer = UIContainer(self.myRewardItem, self.root, OnSettleRewardCreate, OnSettleRewardRefresh)
end

function panel_ZhangBaRankTemplate:BindUIEvent()
end

function panel_ZhangBaRankTemplate:Refresh(data)
  if data == nil then
    return
  end
  self.settleContainer:SetData(data)
  local myUnionInfos = QuickFind:GetDuoQiZhengBaManager():GetMyUnionRankOfZhengBa()
  if myUnionInfos == nil then
    self.obj_noRank:SetActive(true)
    self.txt_myUnionRank:SetActive(false)
    self.txt_myUnionName:SetText("")
    self.txt_myUnionLevel:SetText("")
    self.txt_myLeaderName:SetText("")
    self.txt_myUnionScore:SetText("")
  else
    self.obj_noRank:SetActive(false)
    self.txt_myUnionRank:SetActive(true)
    self.txt_myUnionRank:SetText(myUnionInfos.rank)
    self.txt_myUnionName:SetText("S" .. myUnionInfos.serverId .. "." .. myUnionInfos.unionName)
    self.txt_myUnionLevel:SetText("LV." .. myUnionInfos.unionLevel)
    self.txt_myLeaderName:SetText(myUnionInfos.leaderName)
    self.txt_myUnionScore:SetText(myUnionInfos.score)
    local mydata = QuickFind:GetDuoQiCrossDataManager():GetUnionShowRewardCfgByRank(myUnionInfos.rank, true)
    if mydata == nil then
      return
    end
    self.myRewardContainer:SetData(mydata)
  end
end

function panel_ZhangBaRankTemplate:OnDisable()
end

function panel_ZhangBaRankTemplate:Exit()
  self:UIControl():SetActive(false)
end

return panel_ZhangBaRankTemplate
