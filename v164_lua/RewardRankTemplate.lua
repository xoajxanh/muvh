local RewardRankTemplate = {}

function RewardRankTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function RewardRankTemplate:InitControls()
  self.imgBox = self:GetControl("sportBox/Viewport/Content/imgBox")
  self.tips = self:GetControl("tipTitle/tips")
  self.tips_sky = self:GetControl("tipTitle/tips/tips_sky")
  self.go_rankGift = self:GetControl("go_rankGift")
  self.btn_closeBg1 = self:GetControl("go_rankGift/btn_closeBg1")
  self.giftTitle = self:GetControl("go_rankGift/bg_gift/giftTitle")
  self.AllstarGift_btnclose = self:GetControl("go_rankGift/bg_gift/AllstarGift_btnclose")
  self.item_AllstarGift = self:GetControl("go_rankGift/bg_gift/scroll_shop/Viewport/Content/item_AllstarGift")
end

local function ImgBoxOnCreate(ctr)
  ctr.nameBox = UIControl(ctr.transform, "nameBox")
end

local function ImgBoxOnRefresh(ctr, _, data, ui)
  ui:SetSprite("Atlas_Main", data.showIcon or "3V3Box_01", ctr)
  ui:SetSprite("Atlas_Language", data.showIconName or "3V3BoxName_01", ctr.nameBox)
  ctr:SetOnClick(ctr, function()
    local selfTemplate = ui.panel_ThreeVsThreeCrossgomain.sportMatch3V3Template.rewardRankTemplate
    selfTemplate.go_rankGift:SetActive(true)
    ui:SetSprite("Atlas_Language", data.titleIcon, selfTemplate.giftTitle)
    local giftData = TableParse:SpliteStringToItemCountList(data.showItem)
    selfTemplate.allGiftContainer:SetData(giftData)
  end)
end

local function AllGiftOnCreate(ctr)
end

local function AllGiftOnRefresh(ctr, _, data, ui)
  ItemUtility.ShowItemCellByItemId(data.itemId, data.count, ctr, ui, true)
end

function RewardRankTemplate:InitUI()
  self.imgBoxContainer = UIContainer(self.imgBox, self.root, ImgBoxOnCreate, ImgBoxOnRefresh)
  self.allGiftContainer = UIContainer(self.item_AllstarGift, self.root, AllGiftOnCreate, AllGiftOnRefresh)
end

function RewardRankTemplate:BindUIEvent()
  self.btn_closeBg1:SetOnClick(self, self.btn_closeBg1OnClick)
  self.AllstarGift_btnclose:SetOnClick(self, self.AllstarGift_btncloseOnClick)
end

function RewardRankTemplate:btn_closeBg1OnClick()
  self.go_rankGift:SetActive(false)
end

function RewardRankTemplate:AllstarGift_btncloseOnClick()
  self.go_rankGift:SetActive(false)
end

function RewardRankTemplate:Refresh()
  self:RefreshUIView()
end

function RewardRankTemplate:RefreshUIView()
  local cfg_Activity_global = ClientTable.cfg_Activity_globalManager:TryGetValue(500003, "id")
  local seasonDay = cfg_Activity_global and string.isNullOrEmpty(cfg_Activity_global.effect) == false and tonumber(cfg_Activity_global.effect)
  local cfg = ClientTable.cfg_Activity_overviewManager:TryGetValue(5001, "activityId")
  local surplusDayCount = 0
  local nowWeek, oneWeekTotalDay = TimeUtility.GetWeekTime(Time.GetServerTime()), 7
  surplusDayCount = oneWeekTotalDay - nowWeek
  local colorDayCount = string.GetColorText(surplusDayCount, surplusDayCount <= 0 and ItemQuality2ColorDic[EItemColorEnum.red] or ItemQuality2ColorDic[EItemColorEnum.green])
  local tipsStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Activity_3v3_1")
  if not string.isNullOrEmpty(tipsStr) then
    self.tips:SetText(string.format(tipsStr, colorDayCount))
  end
  self.tips_sky:SetActive(false)
  local allSeasonRewards = ClientTable.cfg_PVP_3v3_team_stageManager:GetSeasonRewards()
  self.imgBoxContainer:SetData(allSeasonRewards)
end

function RewardRankTemplate:OnHide()
end

return RewardRankTemplate
