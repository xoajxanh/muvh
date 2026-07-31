Activity_DuoqiRankUI = class(BaseUI)
Activity_DuoqiRankUI.layer = UILayer.Panel
Activity_DuoqiRankUI.orderInLayer = 2
Activity_DuoqiRankUI.hideType = UIHideType.WaitDestroy
Activity_DuoqiRankUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_DuoqiRankUI.escClose = UIEscClose.DontClose

function Activity_DuoqiRankUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("img_bg/btn_close")
  self.settleItem = self:GetControl("img_bg/Scroll View/Viewport/Content/person_rank")
  self.obj_noRank = self:GetControl("img_bg/MyRank/img_noRank")
  self.txt_myUnionRank = self:GetControl("img_bg/MyRank/lab_rank")
  self.txt_myUnionName = self:GetControl("img_bg/MyRank/lab_Name")
  self.txt_myUnionLevel = self:GetControl("img_bg/MyRank/lab_occupation")
  self.txt_myLeaderName = self:GetControl("img_bg/MyRank/lab_level")
  self.txt_myUnionScore = self:GetControl("img_bg/MyRank/lab_integral")
  self.myRewardItem = self:GetControl("img_bg/MyRank/lab_rank_gift/btn_giftItem")
  self.myStrongholdMultiple = self:GetControl("img_bg/MyRank/lab_severaltime")
end

function Activity_DuoqiRankUI:Init()
end

function Activity_DuoqiRankUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnSettleRewardCreate(ctr1)
  ctr1.itemCtr = ItemUtility.InitItemCell(UIControl(ctr1.transform))
  ctr1.modelData = ItemCellData()
end

local function OnSettleItemCreate(ctr2)
  ctr2.img_bg = UIControl(ctr2.transform, "")
  ctr2.img_rankIcon = UIControl(ctr2.transform, "img_rankIcon")
  ctr2.txt_rank = UIControl(ctr2.transform, "lab_rank")
  ctr2.unionName = UIControl(ctr2.transform, "lab_legionName")
  ctr2.unionLevel = UIControl(ctr2.transform, "lab_legionLevel")
  ctr2.leaderName = UIControl(ctr2.transform, "lab_legionLeader")
  ctr2.unionScore = UIControl(ctr2.transform, "lab_integral")
  ctr2.settleRewardItem = UIControl(ctr2.transform, "lab_rank_gift/btn_giftItem")
  ctr2.strongholdMultiple = UIControl(ctr2.transform, "lab_severaltime")
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
  local ShowUnionNameStr = data.unionName
  if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
    ShowUnionNameStr = "S" .. data.serverId .. "." .. data.unionName
  end
  ctr2.unionName:SetText(ShowUnionNameStr)
  ctr2.unionLevel:SetText("LV." .. data.unionLevel)
  ctr2.leaderName:SetText(data.leaderName)
  ctr2.unionScore:SetText(data.score)
  local strongholdMultiple = QuickFind:GetDuoQiCrossDataManager():GetStrongholdMultipleByUnionId(data.unionId)
  local showNum, _ = math.modf(strongholdMultiple)
  ctr2.strongholdMultiple:SetText("x" .. tostring(showNum))
  if ctr2.settleRewardContainter == nil then
    ctr2.settleRewardContainter = UIContainer(ctr2.settleRewardItem, ui, OnSettleRewardCreate, OnSettleRewardRefresh)
  end
  local showRewardCfg
  if ui.args ~= nil and ui.args.isUseZhengBaCfg == true then
    showRewardCfg = QuickFind:GetDuoQiCrossDataManager():GetUnionShowRewardCfgByRank(data.rank, true)
  else
    showRewardCfg = QuickFind:GetDuoQiCrossDataManager():GetUnionShowRewardCfgByRank(data.rank)
  end
  ctr2.settleRewardContainter:SetData(showRewardCfg)
end

function Activity_DuoqiRankUI:InitUI()
  self.settleContainer = UIContainer(self.settleItem, self, OnSettleItemCreate, OnSettleItemRefresh)
  self.myRewardContainer = UIContainer(self.myRewardItem, self, OnSettleRewardCreate, OnSettleRewardRefresh)
end

function Activity_DuoqiRankUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
end

function Activity_DuoqiRankUI:btn_closeOnClick()
  UIManager.Hide(UIID.Activity_DuoqiRankUI)
end

function Activity_DuoqiRankUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_DuoqiRankUI:RegistEvents()
  self:RegistEvent(Event.ResUnionInfo, self.Refresh, self)
  self:RegistEvent(Event.RefreshSettlementOfUnion, self.Refresh, self)
  self:RegistEvent(Event.UnionMyLvChangeRefreshUI, self.Refresh, self)
end

function Activity_DuoqiRankUI:Refresh()
  local unionRankList = QuickFind:GetDuoQiCrossDataManager():GetUnionRankList()
  if unionRankList == nil then
    return
  end
  self.settleContainer:SetData(unionRankList)
  local myUnionInfos = QuickFind:GetDuoQiCrossDataManager():GetMyUnionRank()
  if myUnionInfos == nil then
    self.obj_noRank:SetActive(true)
    self.txt_myUnionRank:SetActive(false)
    self.txt_myUnionName:SetText(WarAllianceData.MyWarAllianceData.name)
    self.txt_myUnionLevel:SetText("LV." .. WarAllianceData.MyWarAllianceData.level)
    self.txt_myLeaderName:SetText(WarAllianceData.MyWarAllianceData.leaderName)
    self.txt_myUnionScore:SetText("0")
  else
    self.obj_noRank:SetActive(false)
    self.txt_myUnionRank:SetActive(true)
    self.txt_myUnionRank:SetText(myUnionInfos.rank)
    local ShowMyUnionNameStr = myUnionInfos.unionName
    if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
      ShowMyUnionNameStr = "S" .. myUnionInfos.serverId .. "." .. myUnionInfos.unionName
    end
    self.txt_myUnionName:SetText(ShowMyUnionNameStr)
    self.txt_myUnionLevel:SetText("LV." .. myUnionInfos.unionLevel)
    self.txt_myLeaderName:SetText(myUnionInfos.leaderName)
    self.txt_myUnionScore:SetText(myUnionInfos.score)
    local mydata
    if self.args ~= nil and self.args.isUseZhengBaCfg == true then
      mydata = QuickFind:GetDuoQiCrossDataManager():GetUnionShowRewardCfgByRank(myUnionInfos.rank, true)
    else
      mydata = QuickFind:GetDuoQiCrossDataManager():GetUnionShowRewardCfgByRank(myUnionInfos.rank)
    end
    if mydata == nil then
      return
    end
    self.myRewardContainer:SetData(mydata)
  end
  local strongholdMultiple = QuickFind:GetDuoQiCrossDataManager():GetStrongholdMultipleByUnionId(RoleManager.me.unionId)
  local showNum, _ = math.modf(strongholdMultiple)
  self.myStrongholdMultiple:SetText("x" .. tostring(showNum))
end

function Activity_DuoqiRankUI:OnHide()
end

function Activity_DuoqiRankUI:OnDestroy()
end
