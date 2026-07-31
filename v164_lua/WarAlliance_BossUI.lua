WarAlliance_BossUI = class(BaseUI)
WarAlliance_BossUI.layer = UILayer.Panel
WarAlliance_BossUI.orderInLayer = 0
WarAlliance_BossUI.hideType = UIHideType.WaitDestroy
WarAlliance_BossUI.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_BossUI.escClose = UIEscClose.DontClose

function WarAlliance_BossUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.CloseBtn = self:GetControl("bg/backbg/CloseBtn")
  self.title = self:GetControl("panel/title")
  self.Re_Content = self:GetControl("panel/reward_sc/Viewport/Re_Content")
  self.btn_3DItem = self:GetControl("panel/reward_sc/Viewport/Re_Content/btn_3DItem")
  self.Boss_Content = self:GetControl("panel/boss_detail/boss_sc/Boss_Content")
  self.bossitem = self:GetControl("panel/boss_detail/boss_sc/Boss_Content/bossitem")
  self.lab_time = self:GetControl("panel/lab_time")
  self.btn_enter = self:GetControl("panel/btn_enter")
  self.notbtn_enter = self:GetControl("panel/notbtn_enter")
end

function WarAlliance_BossUI:Init()
  self.transcriptId = 1001
  self.GradBossActivityAward = 100112
end

function WarAlliance_BossUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_BossUI:InitUI()
  self:InitContent()
  GradData.GetGradBossTime()
  self:InitConfigurationData()
end

local function InitBossItemControls(ctr)
  ctr.bossName = UIControl(ctr.transform, "lab_bossname")
  ctr.bossLevel = UIControl(ctr.transform, "lab_bosslevel")
  ctr.kill = UIControl(ctr.transform, "kill")
  ctr.head = UIControl(ctr.transform, "img_headFrame/img_head")
end

local function ItemBossRefresh(ctr, _, itemData, ui)
  ctr.bossName:SetText(tostring(itemData.name))
  ctr.bossLevel:SetText(tostring(tonumber(itemData.level) .. "Lv"))
  if not string.isNullOrEmpty(itemData.head) then
    ui:SetSprite("Atlas_headPortrait", itemData.head, ctr.head)
  end
  ctr.kill:SetActive(itemData.isKill)
end

local function InitRewardItemControls(ctr)
  if ctr.itemCellData then
    ctr.itemCellData:Reset()
  else
    local itemCellData = ItemCellData()
    ctr.itemCellData = itemCellData
  end
end

local function ItemRewardRefresh(ctr, _, rewards, ui)
  if not ctr.itemCellData.itemData or ctr.itemCellData.itemData.tblItem.itemId ~= tonumber(rewards.itemID) then
    local itemData = ItemUtility.GenerateItemData(rewards.itemID)
    ctr.itemCellData:RefreshData(itemData)
  end
  ctr.itemCellData.itemData.count = rewards.itemNum
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

function WarAlliance_BossUI:InitContent()
  self.GradBossItemTemp = UIContainer(self.bossitem, self, InitBossItemControls, ItemBossRefresh)
  self.GradRewadItemTemp = UIContainer(self.btn_3DItem, self, InitRewardItemControls, ItemRewardRefresh)
end

function WarAlliance_BossUI:InitConfigurationData()
end

function WarAlliance_BossUI:RefreshBoss()
  GradData.RefushBossInfo()
  self.GradBossItemTemp:SetDataKTable(GradData.floorMonster)
end

function WarAlliance_BossUI:RefreshRewad()
  local curWeekReward = GradData.GetReward()
  local allRewards = {}
  for k, v in pairs(curWeekReward) do
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(k)
    if itemConfig and itemConfig.subType ~= 301 then
      table.insert(allRewards, {itemID = k, itemNum = v})
    end
  end
  self.GradRewadItemTemp:SetData(allRewards)
end

function WarAlliance_BossUI:RefreshEnterActivityTime()
  GradData.SortWeekTime()
  self.openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(self.transcriptId, "activityId")
  self.title:SetText(self.openActivityCond.activityName)
  local isOpen = ConditionManager.Check4D(self.openActivityCond.condition) and GradData.GradKillBossList.activityState == GradBossActivityEnum.Running
  local isEnter = WarAllianceData.CheckActivityEnter(self.transcriptId) == WarAllianceActivityEnterCondition.Success
  local isShow = isOpen and isEnter
  self.btn_enter:SetActive(isShow)
  self.notbtn_enter:SetActive(not isShow)
  local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_9")
  self.lab_time:SetText(content .. tostring(GradData.activityTime))
end

function WarAlliance_BossUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_BossUI:OnHide()
end

function WarAlliance_BossUI:OnDestroy()
end

function WarAlliance_BossUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.CloseBtn:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_enter:SetOnClick(self, self.EnterBossEc)
  self.notbtn_enter:SetOnClick(self, self.EnterBossEc)
end

function WarAlliance_BossUI:btn_closeBgOnClick()
  UIManager.Hide(UIID.WarAlliance_BossUI)
end

function WarAlliance_BossUI:EnterBossEc()
  WarAllianceData.TryEnterActivity(self.transcriptId, self, self.EnterBossMap)
end

function WarAlliance_BossUI:EnterBossMap()
  if GradData.GradKillBossList.activityState ~= GradBossActivityEnum.Running then
    FloatingTipUtility.QuickMsg(LocalizationUtility.GetContentByKey("warAllianceBoss_2"))
    return
  end
  self:btn_closeBgOnClick()
  local count = GradData.GetCurCount()
  if count <= GradData.maxFloor then
    local transferId = GradData.GetSingleInfo(count)
    if transferId then
      local mapData = {mapId = transferId}
      SceneController.OnReqTransferTransmitMap(nil, mapData)
    end
  else
    local content = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("warAllianceBoss_1")
    FloatingTipUtility.QuickMsg(content)
  end
end

function WarAlliance_BossUI:RegistEvents()
  self:RegistEvent(Event.WarAlliance_BossUIUpdate, self.RefushWarAllianceBossUI, self)
end

function WarAlliance_BossUI:RefushWarAllianceBossUI()
  self:RefreshBoss()
  self:RefreshRewad()
  self:RefreshEnterActivityTime()
end

function WarAlliance_BossUI:Refresh()
  EventManager.Dispatch(Event.WarAlliance_KillBoss)
end
