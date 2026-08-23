local DuoQiCrossGomainTemplate = {}

function DuoQiCrossGomainTemplate:Init(root)
  self.root = root
  self:InitControls()
  self:InitUI()
  self:BindUIEvent()
end

function DuoQiCrossGomainTemplate:InitControls()
  self.go_main = self:GetControl("go_main")
  self.go_detail = self:GetControl("go_detail")
  self.btn_detail = self:GetControl("go_main/img_Bg/btn_detail")
  self.btn_closeDetail = self:GetControl("go_detail/btn_close")
  self.btn_goScene = self:GetControl("go_main/img_Bg/btn_goScene")
  self.btn_itemGoMain = self:GetControl("go_main/img_Bg/img_ActivityDes/sw_reward/Viewport/Content/btn_Item")
  self.rewardListItem = self:GetControl("go_detail/sw_reward/Viewport/Content/panel_personageReward")
  self.txt_openTime = self:GetControl("go_main/img_Bg/img_ActivityDes/time/lab_time")
  self.txt_needLevel = self:GetControl("go_main/img_Bg/img_ActivityDes/level/lab_level")
  self.btnGoToZhengBa = self:GetControl("go_main/img_Bg/btn_ZhengBa")
end

local function rewardGoMainCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function rewardGoMainRefresh(ctr, index, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = 0
  ctr.modelData:RecycleRes()
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
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
    ctr2.rankRewardListContainer = UIContainer(ctr2.btnRewards, ui.root, rankRewardsCreate, rankRewardsRefresh)
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
  local rankList = QuickFind:GetDuoQiCrossDataManager():GetRankListByRewardType(index)
  ctr1.rankListContainer:SetData(rankList)
end

function DuoQiCrossGomainTemplate:InitUI()
  self.rewardGoMainContainer = UIContainer(self.btn_itemGoMain, self.root, rewardGoMainCreate, rewardGoMainRefresh)
  self.rewardListContainer = UIContainer(self.rewardListItem, self, rewardListCreate, rewardListRefresh)
end

function DuoQiCrossGomainTemplate:Btn_detailOnClick()
  self.go_detail:SetActive(true)
  self.go_main:SetActive(false)
end

function DuoQiCrossGomainTemplate:Btn_closeDetailOnClick()
  self.go_main:SetActive(true)
  self.go_detail:SetActive(false)
end

function DuoQiCrossGomainTemplate:Btn_goSceneOnClick()
  local canEnter = QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpenAndCanEnter()
  if canEnter == false then
    local isActiOpen = QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpen()
    if isActiOpen == false then
      FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetUnionActiNotOpenStr())
      return
    end
    local needLevel = QuickFind:GetDuoQiCrossDataManager():GetNeedRoleLevel()
    if needLevel > ViewData.meData.level then
      FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetLevelLackStr())
      return
    end
    if WarAllianceData.MyWarAllianceData.id == nil then
      FloatingTipUtility.QuickMsg(QuickFind:GetDuoQiCrossDataManager():GetUnionLackStr())
      return
    end
    return
  end
  local mapData = {mapId = 1020601}
  SceneController.OnReqTransferTransmitMap(nil, mapData)
end

function DuoQiCrossGomainTemplate:btnGoToZhengBaOnClick()
  UIManager.JumpShow(UIPanelType.SortAndHide, UIID.CrossServer_IntoUI, {
    openFirstTab = CrossServerTabType.DuoQiZhengBa
  })
end

function DuoQiCrossGomainTemplate:BindUIEvent()
  self.btn_detail:SetOnClick(self, self.Btn_detailOnClick)
  self.btn_closeDetail:SetOnClick(self, self.Btn_closeDetailOnClick)
  self.btn_goScene:SetOnClick(self, self.Btn_goSceneOnClick)
  self.btnGoToZhengBa:SetOnClick(self, self.btnGoToZhengBaOnClick)
end

function DuoQiCrossGomainTemplate:Refresh()
  QuickFind:GetDuoQiCrossDataManager():RefreshPerAndUnionRewards()
  self:UIControl():SetActive(true)
  local goMainRewardCfg = QuickFind:GetDuoQiCrossDataManager():GetRewardsOfEntrance()
  if goMainRewardCfg == nil then
    return
  end
  local itemsIdCfg = string.split(goMainRewardCfg, "&")
  local rewardInfos = {}
  if next(itemsIdCfg) ~= nil then
    for i, v in ipairs(itemsIdCfg) do
      table.insert(rewardInfos, {
        itemId = tonumber(v)
      })
    end
  end
  self.rewardGoMainContainer:SetData(rewardInfos)
  local rewardListIds = {}
  for i = 1, 3 do
    table.insert(rewardListIds, {
      id = 500220 + i
    })
  end
  self.rewardListContainer:SetData(rewardListIds)
  self:SetColorOfOpenTimeAndLevel()
end

function DuoQiCrossGomainTemplate:SetColorOfOpenTimeAndLevel()
  local isActiOpen = QuickFind:GetDuoQiCrossDataManager():IsDuoQiActivityOpen()
  if isActiOpen == true then
    self.txt_openTime:SetColor(EUIColor.Green)
    QuickFind:GetDuoQiCrossDataManager():SetIsGreenOpenTimeStr(true)
  else
    self.txt_openTime:SetColor(EUIColor.Red)
    QuickFind:GetDuoQiCrossDataManager():SetIsGreenOpenTimeStr(false)
  end
  local needLevel = QuickFind:GetDuoQiCrossDataManager():GetNeedRoleLevel()
  if needLevel > ViewData.meData.level then
    self.txt_needLevel:SetColor(EUIColor.Red)
  else
    self.txt_needLevel:SetColor(EUIColor.Green)
  end
end

function DuoQiCrossGomainTemplate:OnDisable()
end

function DuoQiCrossGomainTemplate:Exit()
  self.go_main:SetActive(true)
  self.go_detail:SetActive(false)
  self:UIControl():SetActive(false)
end

return DuoQiCrossGomainTemplate
