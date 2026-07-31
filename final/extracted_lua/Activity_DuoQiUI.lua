Activity_DuoQiUI = class(BaseUI)
Activity_DuoQiUI.layer = UILayer.Panel
Activity_DuoQiUI.orderInLayer = -400
Activity_DuoQiUI.hideType = UIHideType.WaitDestroy
Activity_DuoQiUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_DuoQiUI.escClose = UIEscClose.DontClose
local BtnsState = {
  AllGrey = 1,
  RightGrey = 2,
  NotGrey = 3
}

function Activity_DuoQiUI:InitControls()
  self.btn_Exit = self:GetControl("btn_Exit")
  self.Time_Text = self:GetControl("btn_Exit/eventCountdown_lab/Time_Text")
  self.btn_BoxReward = self:GetControl("btn_BoxReward")
  self.btn_UnionRank = self:GetControl("btn_Allrank")
  self.tog_PersonalScore = self:GetControl("TaskRankBar/tog_Task")
  self.tog_UnionRanking = self:GetControl("TaskRankBar/tog_Ranking")
  self.panel_PersonalScore = self:GetControl("panel_Task")
  self.Personage_points = self:GetControl("panel_Task/GearPosition_points/Personage_points")
  self.btn_desc = self:GetControl("btn_desc")
  self.panel_UnionRanking = self:GetControl("Panel_Ranking")
  self.go_UnionRank = self:GetControl("Panel_Ranking/sw_rankList/Viewport/Content/go_ranking1")
  self.obj_noRank = self:GetControl("Panel_Ranking/go_rankingMe/img_noRank")
  self.txt_OwnRank = self:GetControl("Panel_Ranking/go_rankingMe/lab_rank")
  self.txt_OwnName = self:GetControl("Panel_Ranking/go_rankingMe/lab_Name")
  self.txt_OwnScore = self:GetControl("Panel_Ranking/go_rankingMe/lab_integral")
  self.btn_getReward = self:GetControl("panel_Task/btn_getReward")
  self.rewardsTip = self:GetControl("getReward_TipBg")
  self.rewardsTip_btnClose = self:GetControl("getReward_TipBg/btn_close")
  self.personalRewardItem = self:GetControl("panel_Task/img_bg_taskDes/sw_reward/Viewport/Content/btn_Item")
  self.getRewardTipItem = self:GetControl("getReward_TipBg/img_bg_taskDes/sw_reward/Viewport/Content/btn_Item")
  self.btn_oneReward = self:GetControl("getReward_TipBg/ButtonTriggerView/Button_oneReward")
  self.btn_doubleReward = self:GetControl("getReward_TipBg/ButtonTriggerView/Button_doubleReward")
  self.txt_GearPosition_points = self:GetControl("panel_Task/GearPosition_points")
  self.obj_collectParent = self:GetControl("obj_collectParent")
  self.btn_collect = self:GetControl("obj_collectParent/collect_button")
  self.progress_collect = self:GetControl("obj_collectParent/collect_button/progress_collect")
  self.obj_processBar = self:GetControl("Progress_bar")
  self.img_progressFill = self:GetControl("Progress_bar/img_progressFill")
  self.img_AllRewardGeted = self:GetControl("panel_Task/img_bg_taskDes/img_finish")
  self.btn_needGold = self:GetControl("getReward_TipBg/ButtonTriggerView/Button_doubleReward/btn_needGold")
  self.txt_needGold = self:GetControl("getReward_TipBg/ButtonTriggerView/Button_doubleReward/Text_needGold")
  self.img_leftNotClick = self:GetControl("getReward_TipBg/ButtonTriggerView/Button_oneReward/img_unclick")
  self.img_rightNotClick = self:GetControl("getReward_TipBg/ButtonTriggerView/Button_doubleReward/img_unclick")
  self.rob_button = self:GetControl("plunder_button")
end

function Activity_DuoQiUI:Init()
end

function Activity_DuoQiUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function OnUnionRankCreate(ctr)
  ctr.img_bg = UIControl(ctr.transform, "img_bg")
  ctr.img_rankIcon = UIControl(ctr.transform, "img_rankIcon1")
  ctr.txt_name = UIControl(ctr.transform, "lab_Name")
  ctr.txt_score = UIControl(ctr.transform, "lab_integral")
  ctr.txt_rank = UIControl(ctr.transform, "lab_rank")
end

local function OnUnionRankRefresh(ctr, index, data, ui)
  if data == nil then
    return
  end
  ctr.txt_name:SetText(data.unionName)
  ctr.txt_score:SetText(data.score)
  if data.rank <= 3 and data.rank >= 1 then
    local infos = QuickFind:GetDuoQiCrossDataManager():GetRankMaterialOfSettleByRank(data.rank)
    ui:SetSprite(infos.bgAtlas, infos.bgName, ctr.img_bg)
    ctr.img_rankIcon:SetActive(true)
    ctr.txt_rank:SetActive(false)
    ui:SetSprite(infos.iconAtlas, infos.iconName, ctr.img_rankIcon)
  else
    ctr.img_rankIcon:SetActive(false)
    ctr.txt_rank:SetActive(true)
    ctr.txt_rank:SetText(data.rank)
  end
end

local function personalRewardCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function personalRewardRefresh(ctr, index, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RecycleRes()
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  local canGet = QuickFind:GetDuoQiCrossDataManager():IsCanGetReward()
  ctr.transform:Find("bg_light_line").gameObject:SetActive(canGet)
end

local function RewardsTipCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function RewardTipRefresh(ctr, index, data, ui)
  if data == nil then
    return
  end
  local itemData = ItemUtility.GenerateItemData(data.itemId)
  itemData.count = data.count
  ctr.modelData:RecycleRes()
  ctr.modelData:RefreshData(itemData)
  ctr.modelData.itemData.tipsPosition = Vector3(0, -35, 0)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
  local canGet = QuickFind:GetDuoQiCrossDataManager():IsCanGetReward()
  ctr.transform:Find("bg_light_line").gameObject:SetActive(canGet)
end

function Activity_DuoQiUI:InitUI()
  self.UnionRankContainer = UIContainer(self.go_UnionRank, self, OnUnionRankCreate, OnUnionRankRefresh)
  self.personalRewardContainer = UIContainer(self.personalRewardItem, self, personalRewardCreate, personalRewardRefresh)
  self.rewardsTipContainer = UIContainer(self.getRewardTipItem, self, RewardsTipCreate, RewardTipRefresh)
end

function Activity_DuoQiUI:RegistUIEvents()
  self.tog_PersonalScore:SetOnToggleChanged(self, self.tog_PersonalScoreOnChanged)
  self.tog_UnionRanking:SetOnToggleChanged(self, self.tog_TeamRankingOnChanged)
  self.btn_getReward:SetOnClick(self, self.btn_getRewardOnClick)
  self.rewardsTip_btnClose:SetOnClick(self, self.rewardsTip_btnCloseOnClick)
  self.btn_BoxReward:SetOnClick(self, self.btn_BoxRewardOnClick)
  self.btn_desc:SetOnClick(self, self.btn_descOnClick)
  self.btn_UnionRank:SetOnClick(self, self.btn_UnionRankOnClick)
  self.btn_Exit:SetOnClick(self, self.ExitOnClick)
  self.btn_oneReward:SetOnClick(self, self.btn_oneRewardOnClick)
  self.btn_doubleReward:SetOnClick(self, self.btn_doubleRewardOnClick)
  self.btn_collect:SetOnClick(self, self.btn_collectOnlick)
  self.rob_button:SetOnClick(self, self.rob_buttonOnlick)
end

function Activity_DuoQiUI:ExitOnClick(ctr)
  local tempCfg
  if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiByMapId() == true then
    tempCfg = ClientTable.cfg_Ui_promptwordManager:TryGetValue(68)
  elseif QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
    tempCfg = ClientTable.cfg_Ui_promptwordManager:TryGetValue(129)
  else
    tempCfg = ClientTable.cfg_Ui_promptwordManager:TryGetValue(68)
  end
  if tempCfg == nil or tempCfg.title == nil or tempCfg.content == nil or tempCfg.leftButton == nil or tempCfg.rightButton == nil then
    return
  end
  local prompTipArgs = {
    title = tempCfg.title,
    textContent = tempCfg.content,
    cancelText = tempCfg.leftButton,
    okText = tempCfg.rightButton,
    ok = function()
      TranScriptController.ReqExitUnionMap()
    end,
    canel = function()
      UIManager.Hide(this.name)
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Activity_DuoQiUI:btn_oneRewardOnClick()
  if self.GetBtnsState == nil then
    return
  end
  if self.GetBtnsState == BtnsState.AllGrey then
    return
  end
  local showGearId = QuickFind:GetDuoQiCrossDataManager():GetShowGearId()
  if showGearId == nil then
    return
  end
  networkRequest.ReqGetFlagActivityReward(showGearId, 1)
  local isGetNowLastReward = QuickFind:GetDuoQiCrossDataManager():IsGetNowLastReward()
  if isGetNowLastReward == true then
    self.rewardsTip:SetActive(false)
  end
end

function Activity_DuoQiUI:btn_doubleRewardOnClick()
  if self.GetBtnsState == nil then
    return
  end
  if self.GetBtnsState == BtnsState.RightGrey or self.GetBtnsState == BtnsState.AllGrey then
    return
  end
  local showGearId = QuickFind:GetDuoQiCrossDataManager():GetShowGearId()
  if showGearId == nil then
    return
  end
  networkRequest.ReqGetFlagActivityReward(showGearId, 2)
  local isGetNowLastReward = QuickFind:GetDuoQiCrossDataManager():IsGetNowLastReward()
  if isGetNowLastReward == true then
    self.rewardsTip:SetActive(false)
  end
end

function Activity_DuoQiUI:btn_collectOnlick()
  if self.processLoop ~= nil then
    Timer.Stop(self.processLoop)
    self.processLoop = nil
  end
  local boxId = QuickFind:GetDuoQiCrossDataManager():GetCollectingBoxId()
  local needTime = QuickFind:GetDuoQiCrossDataManager():GetCollectTime()
  self.btn_collect.gameObject:GetComponent("Button").enabled = false
  local setProcessTime = 0.05
  local littleProcess = setProcessTime * 1000 / needTime
  if boxId == nil then
    return
  end
  networkRequest.ReqFlagActivityCollectBox(boxId, 1)
  local process = 0
  self.progress_collect:SetFillAmount(process)
  self.processLoop = Timer.StartLoopForever(setProcessTime, function()
    process = process + littleProcess
    self.progress_collect:SetFillAmount(process)
    if 1 <= process then
      Timer.Stop(self.processLoop)
      self.processLoop = nil
      QuickFind:GetDuoQiCrossDataManager():SetIsCollectState(false)
      self.btn_collect:SetActive(false)
      self.progress_collect:SetFillAmount(0)
      networkRequest.ReqFlagActivityCollectBox(boxId, 2)
    end
  end)
end

function Activity_DuoQiUI:rob_buttonOnlick()
  local viewData = ViewData.GetGameObjectsInView()
  if viewData == nil or next(viewData) == nil then
    return
  end
  local strongholdAroundData = QuickFind:GetDuoQiCrossDataManager():GetStrongholdAroundData()
  if next(strongholdAroundData) == nil then
    return
  end
  local miniDis = 1000
  local miniKey
  for i, v in pairs(viewData) do
    if v.unionId ~= nil and v.unionId == strongholdAroundData.unionId and v.serverCoord ~= nil then
      local distance = Vector2.DistancePow(v.serverCoord, RoleManager.me.cellPos)
      if miniDis > distance then
        miniDis = distance
        miniKey = i
      end
    end
  end
  if miniKey ~= nil then
    local hitObj = {}
    hitObj.name = tostring(miniKey)
    local Avatar = RoleManager.GetRoleByModel(hitObj)
    RoleManager.me:SetTarget(Avatar)
    RoleManager.me:SetAutoFight(AutoFightStrKey.ReleaseSkill)
    return
  end
  local tip = QuickFind:GetDuoQiCrossDataManager():GetNoEnemyOfFlagTip()
  if string.isNullOrEmpty(tip) ~= true then
    FloatingTipUtility.QuickMsg(tip)
  end
end

function Activity_DuoQiUI:tog_PersonalScoreOnChanged(ctr, isOn)
  if isOn then
    self.panel_PersonalScore:SetActive(true)
    self.panel_UnionRanking:SetActive(false)
  end
end

function Activity_DuoQiUI:tog_TeamRankingOnChanged(ctr, isOn)
  if isOn then
    self.panel_PersonalScore:SetActive(false)
    self.panel_UnionRanking:SetActive(true)
  end
end

function Activity_DuoQiUI:btn_getRewardOnClick()
  if QuickFind:GetDuoQiCrossDataManager():GetIsAllRewardGeted() == true then
    return
  end
  self.rewardsTip:SetActive(true)
end

function Activity_DuoQiUI:rewardsTip_btnCloseOnClick()
  self.rewardsTip:SetActive(false)
end

function Activity_DuoQiUI:btn_BoxRewardOnClick()
  UIManager.Show(UIID.Duoqi_RewardUI)
end

function Activity_DuoQiUI:btn_descOnClick()
  if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiByMapId() == true then
    UIManager.Show(UIID.System_DescUI, {id = 1117})
  elseif QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
    UIManager.Show(UIID.System_DescUI, {id = 1153})
  else
    UIManager.Show(UIID.System_DescUI, {id = 1117})
  end
end

function Activity_DuoQiUI:btn_UnionRankOnClick()
  UIManager.Show(UIID.Activity_DuoqiRankUI)
end

function Activity_DuoQiUI:OnResUnionInfo(_)
  self:Refresh()
end

function Activity_DuoQiUI:OpenFlagRobButton(_, isOpen)
  if QuickFind:GetDuoQiCrossDataManager():GetIsRobBtnOpen() ~= isOpen then
    QuickFind:GetDuoQiCrossDataManager():SetIsRobBtnOpen(isOpen)
    self.rob_button:SetActive(isOpen)
  end
end

function Activity_DuoQiUI:OpenCollectionButton(_, isOpen)
  if QuickFind:GetDuoQiCrossDataManager():GetIsCollectState() ~= isOpen then
    QuickFind:GetDuoQiCrossDataManager():SetIsCollectState(isOpen)
    self.btn_collect:SetActive(isOpen)
    if isOpen == false and self.processLoop ~= nil then
      Timer.Stop(self.processLoop)
      self.processLoop = nil
    end
    self.btn_collect.gameObject:GetComponent("Button").enabled = true
  end
end

function Activity_DuoQiUI:CloseCollectionButton()
  if QuickFind:GetDuoQiCrossDataManager():GetIsCollectState() == true then
    if self.processLoop ~= nil then
      Timer.Stop(self.processLoop)
      self.processLoop = nil
    end
    QuickFind:GetDuoQiCrossDataManager():SetIsCollectState(false)
    self.btn_collect:SetActive(false)
    self.progress_collect:SetFillAmount(0)
  end
end

function Activity_DuoQiUI:OnUnionProcess(_, data)
  if data ~= nil and data.percentage ~= nil then
    self.img_progressFill:SetFillAmount(data.percentage / 100)
    QuickFind:GetDuoQiCrossDataManager():SetIsProcessResReturn(true)
  end
end

function Activity_DuoQiUI:OnOpenUnionProcess(_, isOpen)
  self.obj_processBar:SetActive(isOpen)
end

function Activity_DuoQiUI:OnUnionEndTimer(_, time)
  local showTxt = TimeUtility.ShowTimeWithColon(time)
  self.Time_Text:SetText(showTxt)
end

function Activity_DuoQiUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_DuoQiUI:RegistEvents()
  self:RegistEvent(Event.ResUnionInfo, self.OnResUnionInfo, self)
  self:RegistEvent(Event.OpenCollectionButton, self.OpenCollectionButton, self)
  self:RegistEvent(Event.CanNotCollectBox, self.CloseCollectionButton, self)
  self:RegistEvent(Event.UnionProcess, self.OnUnionProcess, self)
  self:RegistEvent(Event.OpenUnionProcess, self.OnOpenUnionProcess, self)
  self:RegistEvent(Event.UnionEndTimer, self.OnUnionEndTimer, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.SetRewardTipDown, self)
  self:RegistEvent(Event.ResUnionInfo, self.SetRewardTipDown, self)
  self:RegistEvent(Event.OpenCollectParent, self.SetCollectParent, self)
  self:RegistEvent(Event.OpenFlagRobButton, self.OpenFlagRobButton, self)
  self:RegistEvent(Event.UnionMyLvChangeRefreshUI, self.Refresh, self)
end

function Activity_DuoQiUI:Refresh()
  local unionRankList = QuickFind:GetDuoQiCrossDataManager():GetUnionRankList()
  if unionRankList == nil then
    return
  end
  self.UnionRankContainer:SetData(unionRankList)
  local personalRewardCfgOne = QuickFind:GetDuoQiCrossDataManager():GetPersonalCfgOfOwn()
  if personalRewardCfgOne == nil then
    return
  end
  self.personalRewardContainer:SetData(personalRewardCfgOne)
  self.rewardsTipContainer:SetData(personalRewardCfgOne)
  local ownUnionRank = QuickFind:GetDuoQiCrossDataManager():GetOwnUnionRank()
  if ownUnionRank == nil then
    self.txt_OwnRank:SetActive(false)
    self.obj_noRank:SetActive(true)
    self.txt_OwnName:SetText(WarAllianceData.MyWarAllianceData.name)
    self.txt_OwnScore:SetText("0")
  else
    self.txt_OwnRank:SetActive(true)
    self.obj_noRank:SetActive(false)
    self.txt_OwnRank:SetText(ownUnionRank.rank)
    self.txt_OwnName:SetText(ownUnionRank.unionName)
    self.txt_OwnScore:SetText(ownUnionRank.score)
  end
  local limitScore
  if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiByMapId() == true then
    limitScore = QuickFind:GetDuoQiCrossDataManager():GetRankLimitScore()
  elseif QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
    limitScore = QuickFind:GetDuoQiCrossDataManager():GetRankLimitScoreOfZhengBa()
  else
    limitScore = QuickFind:GetDuoQiCrossDataManager():GetRankLimitScore()
  end
  if limitScore == nil then
    return
  end
  self.txt_GearPosition_points:SetText("/" .. limitScore)
  local points = QuickFind:GetDuoQiCrossDataManager():GetMyPlayerScore()
  if points == nil then
    points = 0
  end
  if limitScore > points then
    self.Personage_points:SetText(string.format("<color=#FF0000>%d</color>", points))
  else
    self.Personage_points:SetText(string.format("<color=#00FF00>%d</color>", points))
  end
  local isGetAllRewards = QuickFind:GetDuoQiCrossDataManager():GetIsAllRewardGeted()
  self.img_AllRewardGeted:SetActive(isGetAllRewards)
  self:SetRewardTipDown()
end

function Activity_DuoQiUI:SetRewardTipDown()
  local needItemId, needCount
  if QuickFind:GetDuoQiCrossDataManager():IsInDuoQiByMapId() == true then
    needItemId, needCount = QuickFind:GetDuoQiCrossDataManager():GetItemIdAndCountOfDuoQi()
  elseif QuickFind:GetDuoQiCrossDataManager():IsInDuoQiZhengBaByMapId() == true then
    needItemId, needCount = QuickFind:GetDuoQiCrossDataManager():GetItemIdAndCountOfZhengBa()
  else
    needItemId, needCount = QuickFind:GetDuoQiCrossDataManager():GetItemIdAndCountOfDuoQi()
  end
  if needItemId == nil or needCount == nil then
    return
  end
  ItemUtility.ShowItemCellByItemId(needItemId, 0, self.btn_needGold, self, false)
  local count = BagInfoData.GetItemTotalCountByItemId(needItemId)
  if needCount > count then
    self.txt_needGold:SetText(string.format("<color=#FF0000>%d</color>", needCount))
  else
    self.txt_needGold:SetText(string.format("<color=#00FF00>%d</color>", needCount))
  end
  local btnsState = QuickFind:GetDuoQiCrossDataManager():GetBtnsState(needItemId, needCount)
  self.GetBtnsState = btnsState
  self.img_leftNotClick:SetActive(btnsState == BtnsState.AllGrey)
  self.img_rightNotClick:SetActive(btnsState == BtnsState.RightGrey or btnsState == BtnsState.AllGrey)
end

function Activity_DuoQiUI:SetCollectParent(_, data)
  if data ~= nil and self.isOpenCollectParent ~= data then
    self.obj_collectParent:SetActive(data)
    self.isOpenCollectParent = data
  end
end

function Activity_DuoQiUI:OnHide()
  QuickFind:GetDuoQiCrossDataManager():SetIsRobBtnOpen(false)
  self.rob_button:SetActive(false)
  self:CloseCollectionButton()
end

function Activity_DuoQiUI:OnDestroy()
end
