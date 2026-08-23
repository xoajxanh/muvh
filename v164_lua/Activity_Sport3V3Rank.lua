Activity_Sport3V3Rank = class(BaseUI)
Activity_Sport3V3Rank.layer = UILayer.Panel
Activity_Sport3V3Rank.orderInLayer = 3
Activity_Sport3V3Rank.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Rank.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_Sport3V3Rank.escClose = UIEscClose.DontClose

function Activity_Sport3V3Rank:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.imgTitle = self:GetControl("go_3V3Sport/imgTitle")
  self.tips = self:GetControl("go_3V3Sport/SegLevel/tips")
  self.levelBg = self:GetControl("go_3V3Sport/SegLevel/levelBg")
  self.ImgLevelCount = self:GetControl("go_3V3Sport/SegLevel/levelBg/ImgLevelCount")
  self.imgStar1 = self:GetControl("go_3V3Sport/SegLevel/levelBg/stars/imgStar1")
  self.imgStar2 = self:GetControl("go_3V3Sport/SegLevel/levelBg/stars/imgStar2")
  self.imgStar3 = self:GetControl("go_3V3Sport/SegLevel/levelBg/stars/imgStar3")
  self.imgStar4 = self:GetControl("go_3V3Sport/SegLevel/levelBg/stars/imgStar4")
  self.imgStar5 = self:GetControl("go_3V3Sport/SegLevel/levelBg/stars/imgStar5")
  self.progressCount = self:GetControl("go_3V3Sport/SegLevel/progressBg/progressCount")
  self.ImgTitleName = self:GetControl("go_3V3Sport/SegLevel/titleBg/ImgTitleName")
  self.Result1 = self:GetControl("go_3V3Sport/sportResult/Result/Result1")
  self.Result2 = self:GetControl("go_3V3Sport/sportResult/Result/Result2")
  self.btn_3DItem = self:GetControl("go_3V3Sport/sportResult/sportBox/Viewport/Content/btn_3DItem")
  self.btn_more = self:GetControl("go_3V3Sport/btn_more")
end

function Activity_Sport3V3Rank:Init()
end

function Activity_Sport3V3Rank:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function ScoreInfoOnCreate(ctr)
end

local function ScoreInfoOnRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  itemData.count = data.count or 0
  if not ctr.itemCellData then
    ctr.itemCellData = ItemCellData()
  elseif ctr.itemCellData.model then
    ctr.itemCellData:RecycleRes()
  end
  ctr.itemCellData:RefreshData(itemData)
  ctr.itemCellData.itemData.HonourAttribute = data.honourAttr
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function Activity_Sport3V3Rank:InitUI()
  self.rewardItemsContainer = UIContainer(self.btn_3DItem, self, ScoreInfoOnCreate, ScoreInfoOnRefresh)
  self.starsList = {
    [1] = self.imgStar1,
    [2] = self.imgStar2,
    [3] = self.imgStar3,
    [4] = self.imgStar4,
    [5] = self.imgStar5
  }
end

function Activity_Sport3V3Rank:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_more:SetOnClick(self, self.btn_moreOnClick)
end

function Activity_Sport3V3Rank:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Activity_Sport3V3Rank)
end

function Activity_Sport3V3Rank:btn_moreOnClick(control)
  UIManager.Hide(UIID.Activity_Sport3V3Rank)
end

function Activity_Sport3V3Rank:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Rank:RegistEvents()
  self:RegistEvent(Event.RefreshThreeVThreeRankUIInfo, self.Refresh, self)
end

function Activity_Sport3V3Rank:Refresh(_, data)
  self.data = data or self.args and self.args.data
  if table.isNullOrEmpty(self.data) then
    return
  end
  self:RefreshUIView()
end

function Activity_Sport3V3Rank:RefreshUIView()
  local cfgData = ClientTable.cfg_PVP_3v3_team_stageManager:GetTabDataByStageAndLevel(self.data.stage, self.data.stageLevel)
  self:SetSprite("Atlas_Language", self.data.win and "3V3WinTxt" or "3V3FailTxt", self.imgTitle)
  self:SetSprite("Atlas_Main", cfgData and cfgData.stageNameBg or "3V3LevelBg_01", self.levelBg)
  self:SetSprite("Atlas_Language", cfgData and cfgData.stageLevelName or "3V3Level_01", self.ImgLevelCount)
  local starNum = cfgData and tonumber(cfgData.stageStarsNum) or 0
  for i, star in ipairs(self.starsList) do
    star:SetActive(i <= starNum)
  end
  self.progressCount:SetText(string.format("%d/%d", self.data.score, cfgData and cfgData.levelPoints or 10))
  self:SetSprite("Atlas_Language", cfgData and cfgData.stageName or "3V3LevelName_01", self.ImgTitleName)
  self.Result1:SetActive(true)
  self.Result1:SetText(string.format("\196\144i\225\187\131m + %d", self.data.addScore))
  self.Result2:SetActive(false)
  self.Result2:SetText("")
  self.rewardItemsContainer:SetData(self.data.rewards)
end

function Activity_Sport3V3Rank:OnHide()
  self.args = nil
  self.data = nil
end
