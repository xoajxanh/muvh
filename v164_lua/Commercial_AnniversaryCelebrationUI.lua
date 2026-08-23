Commercial_AnniversaryCelebrationUI = class(BaseUI)
Commercial_AnniversaryCelebrationUI.layer = UILayer.Panel
Commercial_AnniversaryCelebrationUI.orderInLayer = 0
Commercial_AnniversaryCelebrationUI.hideType = UIHideType.WaitDestroy
Commercial_AnniversaryCelebrationUI.hideFunc = UIHideFunc.MoveOutOfScreen
Commercial_AnniversaryCelebrationUI.escClose = UIEscClose.DontClose

function Commercial_AnniversaryCelebrationUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.txt_lastTime = self:GetControl("txt_lastTime")
  self.lab_lastTime = self:GetControl("txt_lastTime/lab_lastTime")
  self.go_NewCharacter = self:GetControl("go_NewCharacter")
  self.go_CelebrationMonster = self:GetControl("go_CelebrationMonster")
  self.go_DailyCelebration = self:GetControl("go_DailyCelebration")
  self.go_CelebrationPass = self:GetControl("go_CelebrationPass")
  self.go_CelebrationShop = self:GetControl("go_CelebrationShop")
  self.go_CelebrationNpc = self:GetControl("go_CelebrationNpc")
  self.Btn_Holiday = self:GetControl("sw_HolidayActivityList/Viewport/Content/Btn_Holiday")
  self.go_Item = self:GetControl("go_DailyCelebration/Scrollview/Viewport/Content/go_Item")
  self.signInLastTimeGift = self:GetControl("go_DailyCelebration/txt_lastTimeGift")
  self.lab_holidayShopcoin = self:GetControl("go_CelebrationShop/lab_holidayShopcoin")
  self.go_Shopitem = self:GetControl("go_CelebrationShop/Viewport/Content/go_Shopitem")
  self.go_bg = self:GetControl("go_CelebrationShop/go_bg")
  self.storeInLastTimeGift = self:GetControl("go_CelebrationShop/txt_lastTimeGift")
  self.npcLastTimeGift = self:GetControl("go_CelebrationNpc/txt_lastTimeGift")
  self.btn_goExperience = self:GetControl("go_CelebrationNpc/btn_goExperience")
  self.npcEffect = self:GetControl("go_CelebrationNpc/btn_goExperience/img_redPoint/Eff_UI_liuguang_kuang")
  self.CelebrationPassPanel = self:GetControl("go_CelebrationPass/CelebrationPassPanel")
  self.lab_levelValue = self:GetControl("go_CelebrationPass/img_Cumulative/level/lab_levelValue")
  self.go_alphaFilled = self:GetControl("go_CelebrationPass/img_Cumulative/go_alpha/go_alphaFilled")
  self.go_progress = self:GetControl("go_CelebrationPass/img_Cumulative/go_alpha/go_progress")
  self.btn_goCelebrationTask = self:GetControl("go_CelebrationPass/btn_goCelebrationTask")
  self.btn_goCelebrationTaskTip = self:GetControl("go_CelebrationPass/btn_goCelebrationTask/tip")
  self.btn_money = self:GetControl("go_CelebrationPass/btn_money")
  self.go_Model = self:GetControl("go_CelebrationPass/go_Model")
  self.battleOrderLastTimeGift = self:GetControl("go_CelebrationPass/txt_lastTimeGift")
  self.CelebrationPassTaskPanel = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel")
  self.btn_dailyTask = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/btn_group/btn_dailytask")
  self.btn_dailyTaskClickEffect = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/btn_group/btn_dailytask/img_clickeffect")
  self.btn_Task = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/btn_group/btn_task")
  self.btn_TaskClickEffect = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/btn_group/btn_task/img_clickeffect")
  self.sw_dailyTask = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/sw_dailyTask")
  self.sw_Task = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/sw_Task")
  self.Item_CelebrationDailyTask = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/sw_dailyTask/Viewport/Content/Item_CelebrationTask")
  self.Item_CelebrationTask = self:GetControl("go_CelebrationPass/CelebrationPassTaskPanel/sw_Task/Viewport/Content/Item_CelebrationTask")
  self.newCharacterLastTimeGift = self:GetControl("go_NewCharacter/txt_lastTimeGift")
  self.monsterLastTimeGift = self:GetControl("go_CelebrationMonster/txt_lastTimeGift")
  self.descBtn = self:GetControl("descBtn")
end

function Commercial_AnniversaryCelebrationUI:Init()
end

function Commercial_AnniversaryCelebrationUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

local function ShowModelCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.modelData = ItemCellData()
end

local function ShowModelRefresh(ctr, _, data, ui)
  local id = tonumber(data)
  local itemData = ItemUtility.GenerateItemData(id)
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function Commercial_AnniversaryCelebrationUI:InitUI()
  self.BtnList = {
    [AnniversaryActivityEnum.SignIn] = self.go_DailyCelebration,
    [AnniversaryActivityEnum.Store] = self.go_CelebrationShop,
    [AnniversaryActivityEnum.NpcActivity] = self.go_CelebrationNpc,
    [AnniversaryActivityEnum.BattleOrder] = self.go_CelebrationPass,
    [AnniversaryActivityEnum.NewCharacter] = self.go_NewCharacter,
    [AnniversaryActivityEnum.Monster] = self.go_CelebrationMonster
  }
  self.descList = {
    [AnniversaryActivityEnum.SignIn] = 1138,
    [AnniversaryActivityEnum.Store] = 1143,
    [AnniversaryActivityEnum.NpcActivity] = 1142,
    [AnniversaryActivityEnum.BattleOrder] = 1141,
    [AnniversaryActivityEnum.NewCharacter] = 1139,
    [AnniversaryActivityEnum.Monster] = 1140
  }
  self.lastTimeGiftList = {
    [AnniversaryActivityEnum.SignIn] = self.signInLastTimeGift,
    [AnniversaryActivityEnum.Store] = self.storeInLastTimeGift,
    [AnniversaryActivityEnum.NpcActivity] = self.npcLastTimeGift,
    [AnniversaryActivityEnum.BattleOrder] = self.battleOrderLastTimeGift,
    [AnniversaryActivityEnum.NewCharacter] = self.newCharacterLastTimeGift,
    [AnniversaryActivityEnum.Monster] = self.monsterLastTimeGift
  }
  self.BtnHolidayContainer = UIUtility.BindUIContainerTemp(self.Btn_Holiday, LuaComponentTemplates.AnniversaryActivityPageTemplate, self)
  self.SignInItemContainer = UIUtility.BindUIContainerTemp(self.go_Item, LuaComponentTemplates.AnniversaryActivitySignInTemplate, self)
  self.StoreItemContainer = UIUtility.BindUIContainerTemp(self.go_Shopitem, LuaComponentTemplates.AnniversaryActivityStoreTemplate, self)
  self.battleOrderPanelTemp = luaTemplateManager.GetNewTemplate(self.CelebrationPassPanel, LuaComponentTemplates.AnniversaryActivityBattleOrderPanelTemplate, self)
  self.battleOrderDailyTaskItemContainer = UIUtility.BindUIContainerTemp(self.Item_CelebrationDailyTask, LuaComponentTemplates.AnniversaryActivityBattleOrderDailyTaskTemplate, self)
  self.battleOrderActivityTaskItemContainer = UIUtility.BindUIContainerTemp(self.Item_CelebrationTask, LuaComponentTemplates.AnniversaryActivityBattleOrderActivityTaskTemplate, self)
  self.switchText = ClientTable.cfg_Commerce_globalManager:GetWarOrderPassSwitchText()
  self.btn_goCelebrationTaskTip:SetText(self.switchText[1])
  self.btn_TaskClickEffect:SetActive(false)
  self.txt_lastTime:SetActive(false)
  self.descBtn:SetActive(true)
  self.newCharacterTemplate = luaTemplateManager.GetNewTemplate(self.go_NewCharacter, LuaComponentTemplates.AnniversaryActivityNewCharacterTemplate, self)
  self.monsterTemplate = luaTemplateManager.GetNewTemplate(self.go_CelebrationMonster, LuaComponentTemplates.AnniversaryActivityMonsterTemplate, self)
end

function Commercial_AnniversaryCelebrationUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_goCelebrationTask:SetOnClick(self, self.btn_goCelebrationTaskOnClick)
  self.btn_money:SetOnClick(self, self.btn_moneyOnClick)
  self.btn_dailyTask:SetOnClick(self, self.btn_dailyTaskOnClick)
  self.btn_Task:SetOnClick(self, self.btn_TaskOnClick)
  self.btn_goExperience:SetOnClick(self, self.btn_goExperienceOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function Commercial_AnniversaryCelebrationUI:descBtnOnClick(control)
  if not self.nowIndex then
    return
  end
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "id", self.descList[self.nowIndex])
  if 0 < #lvCfg then
    UIManager.Show(UIID.System_DescUI, {
      id = lvCfg[1].id
    })
  end
end

function Commercial_AnniversaryCelebrationUI:btn_goExperienceOnClick(control)
  UIManager.Hide(UIID.Commercial_AnniversaryCelebrationUI)
  PathFinderManager.JumpMapMoveToNpc({npcId = 10400001}, nil, Purpose.ClickNpc)
end

function Commercial_AnniversaryCelebrationUI:btn_TaskOnClick(control)
  self.sw_dailyTask:SetActive(false)
  self.sw_Task:SetActive(true)
  self.btn_dailyTaskClickEffect:SetActive(false)
  self.btn_TaskClickEffect:SetActive(true)
end

function Commercial_AnniversaryCelebrationUI:btn_dailyTaskOnClick(control)
  self.sw_dailyTask:SetActive(true)
  self.sw_Task:SetActive(false)
  self.btn_dailyTaskClickEffect:SetActive(true)
  self.btn_TaskClickEffect:SetActive(false)
end

function Commercial_AnniversaryCelebrationUI:btn_moneyOnClick(control)
  if not AnniversaryActivity_BattleOrderData.commerceId then
    return
  end
  local rechargeInfo = ClientTable.cfg_Commerce_RechargeoverviewManager:TryGetValue(AnniversaryActivity_BattleOrderData.commerceId, "commerceId")
  local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(rechargeInfo.rechargeId)
  local itemPrice = math.floor(rechargeCfg.rmb / 100)
  DataToCSharpMgr.Pay({
    amount = itemPrice,
    product_Id = rechargeCfg.id,
    product_name = rechargeCfg.name
  })
end

function Commercial_AnniversaryCelebrationUI:btn_goCelebrationTaskOnClick(control)
  if self.CelebrationPassPanel:GetActive() then
    self.CelebrationPassPanel:SetActive(false)
    self.CelebrationPassTaskPanel:SetActive(true)
    self:btn_dailyTaskOnClick()
    self.btn_goCelebrationTaskTip:SetText(self.switchText[2])
  else
    self.CelebrationPassPanel:SetActive(true)
    self.CelebrationPassTaskPanel:SetActive(false)
    self.btn_goCelebrationTaskTip:SetText(self.switchText[1])
  end
end

function Commercial_AnniversaryCelebrationUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Commercial_AnniversaryCelebrationUI)
end

function Commercial_AnniversaryCelebrationUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Commercial_AnniversaryCelebrationUI)
end

function Commercial_AnniversaryCelebrationUI:BtnHolidayOnClick(control)
  local data = control.data
  if not data then
    return
  end
  if control.onClick then
    self:ChangeTogState(data)
    self:ChangeViewState(data)
  end
end

function Commercial_AnniversaryCelebrationUI:OnShow()
  self:RegistEvents()
  networkRequest.ReqGetCommercialActivityTab(CommercializeActivityTab.Anniversary)
  self:Refresh()
end

function Commercial_AnniversaryCelebrationUI:RegistEvents()
  self:RegistEvent(Event.Commer_HolidayTog, self.RefreshTog, self)
  self:RegistEvent(Event.AnniversaryPanelRefresh, self.OpenPanel, self)
  self:RegistEvent(Event.RefreshAnniversaryCelebrationBattleOrderUI, self.ShowBattleOrderPanel, self)
  self:RegistEvent(Event.Bag_ResBagChange, self.RefreshStoreCoin, self)
  self:RegistEvent(Event.RefreshAnniversaryStoreSingleCount, self.RefreshStoreGift, self)
  self:RegistEvent(Event.RefreshAnniversaryNewCharacterGiftCount, self.ShowNewCharacterPanel, self)
  self:RegistEvent(Event.RefreshAnniversaryMonsterGiftCount, self.ShowMonsterPanel, self)
end

function Commercial_AnniversaryCelebrationUI:Refresh()
end

function Commercial_AnniversaryCelebrationUI:ShowSignInReward()
  local infoData = AnniversaryActivity_SignInData.GetSignInInfo()
  self.SignInItemContainer:SetData(infoData)
end

function Commercial_AnniversaryCelebrationUI:ShowStoreShowGift()
  self:RefreshStoreCoin()
  self:RefreshStoreGift()
end

function Commercial_AnniversaryCelebrationUI:RefreshStoreCoin()
  local nowShopCoinCount = AnniversaryActivity_StoreData.GetMemoryStoneCount()
  self.lab_holidayShopcoin:SetText(nowShopCoinCount)
end

function Commercial_AnniversaryCelebrationUI:RefreshStoreGift()
  local infoData = ClientTable.cfg_Item_buyManager:GetAnniversaryActivityStoreShowGift()
  self.StoreItemContainer:SetData(infoData)
end

function Commercial_AnniversaryCelebrationUI:ShowBattleOrderReward()
  self:ShowPetModel()
  local nowLevel = AnniversaryActivity_BattleOrderData.GetBattleOrderLevel()
  self.lab_levelValue:SetText(nowLevel or "")
  local nowExp = AnniversaryActivity_BattleOrderData.GetBattleOrderExp()
  local nextExp = AnniversaryActivity_BattleOrderData.GetBattleOrderNextExp()
  if nowExp and nextExp then
    if self.lastBattleOrderExp == nil and self.lastBattleOrderLevel == nil then
      if nextExp == "MAX" then
        self.go_progress:SetText(nextExp)
        self.go_alphaFilled:SetFillAmount(1)
      else
        self.go_progress:SetText(nowExp .. "/" .. nextExp)
        self.go_alphaFilled:SetFillAmount(nowExp / nextExp)
        self.lastBattleOrderExp = nowExp / nextExp
        self.lastBattleOrderLevel = nowLevel
      end
    elseif self.lastBattleOrderExp and self.lastBattleOrderLevel then
      if self.doTween then
        self.doTween:Kill()
        self.doTween = nil
      end
      local startValue, finishValue
      if self.lastBattleOrderLevel == nowLevel then
        startValue = nextExp == "MAX" and 1 or self.lastBattleOrderExp
      else
        startValue = 0
      end
      if nextExp == "MAX" then
        finishValue = 1
        self.go_progress:SetText(nextExp)
      else
        finishValue = nowExp / nextExp
        self.go_progress:SetText(nowExp .. "/" .. nextExp)
      end
      self.doTween = DOTween.To(function(value)
        self.go_alphaFilled:SetFillAmount(value)
      end, startValue, finishValue, 1):SetEase(Ease.OutQuad)
      self.lastBattleOrderExp = finishValue
      self.lastBattleOrderLevel = nowLevel
    end
  end
  self.battleOrderPanelTemp:Refresh(self)
  self.btn_money:SetActive(not AnniversaryActivity_BattleOrderData.GetIsUnLockHighReward())
end

function Commercial_AnniversaryCelebrationUI:ShowPetModel()
  if self.isShowModel then
    return
  end
  local showModelData = AnniversaryActivity_BattleOrderData.GetShowModelData()
  if not showModelData or #showModelData == 0 then
    return
  end
  local itemData = ItemUtility.GenerateItemData(tonumber(showModelData[1]))
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  self.go_Model.transform.localPosition = Vector3(-312, -21.6, -400)
  self.curShowModel = CS.Framework.GameModel("EffectModel", self.go_Model.transform, function(go, name)
  end)
  local path = string.format("Model/Pet/%s.prefab", itemData.tblItem.model)
  self.curShowModel.transform.localPosition = Vector3(10, -300, 0)
  self.curShowModel.transform.eulerAngles = Vector3(0, 150, 0)
  self.curShowModel.transform.localScale = Vector3(250, 250, 250)
  self.curShowModel:LoadAsync(path)
  self.curShowModel:SetLayer(UI_LAYER)
  self.isShowModel = true
end

function Commercial_AnniversaryCelebrationUI:ShowBattleOrderTask()
  local dailyTaskData, activityTaskData = AnniversaryActivity_BattleOrderData.GetBattleOrderAllTaskData()
  self.battleOrderDailyTaskItemContainer:SetData(dailyTaskData)
  self.battleOrderActivityTaskItemContainer:SetData(activityTaskData)
end

function Commercial_AnniversaryCelebrationUI:RefreshTog(_)
  self.BtnGroup = AnniversaryActivity_ActivityData.GetActivityTog(1)
  if table.count(self.BtnGroup) == 0 then
    self:btn_closeOnClick()
    return
  end
  self.BtnHolidayContainer:SetData(self.BtnGroup)
  self:ChangeTogState(self.BtnGroup[1])
  self:ChangeViewState(self.BtnGroup[1])
end

function Commercial_AnniversaryCelebrationUI:ChangeTogState(data)
  for i, v in pairs(self.BtnGroup) do
    if v.group == data.group then
      local tog = self.BtnHolidayContainer.items[i].itemTemp
      if tog then
        tog:SetClickEffect(true)
      end
    else
      local tog = self.BtnHolidayContainer.items[i].itemTemp
      if tog then
        tog:SetClickEffect(false)
      end
    end
  end
end

function Commercial_AnniversaryCelebrationUI:ChangeViewState(data)
  local index = data.group
  if index ~= AnniversaryActivityEnum.NpcActivity then
    NetManager.Send(CommerceMessage.ReqGetCommercialActivityInfo, {
      icon = CommercializeActivityTab.Anniversary,
      groupId = index
    })
  end
  self:SetPanelActive(data)
end

function Commercial_AnniversaryCelebrationUI:OpenPanel(_, data)
  local index = data.group
  self:CheckRedPoint()
  self:SetOpeningInfo(data)
  if index == AnniversaryActivityEnum.SignIn then
    self:ShowSignInReward()
  elseif index == AnniversaryActivityEnum.Store then
    self:ShowStoreShowGift()
  elseif index == AnniversaryActivityEnum.NpcActivity then
  elseif index == AnniversaryActivityEnum.BattleOrder then
  elseif index == AnniversaryActivityEnum.NewCharacter then
    self:ResetNewCharacterPanel()
    self:ShowNewCharacterPanel()
  elseif index == AnniversaryActivityEnum.Monster then
    self:ResetMonsterPanel()
    self:ShowMonsterPanel()
  end
end

function Commercial_AnniversaryCelebrationUI:ShowNewCharacterPanel()
  self.newCharacterTemplate:Refresh()
  self:CheckRedPoint()
end

function Commercial_AnniversaryCelebrationUI:ResetNewCharacterPanel()
  self.newCharacterTemplate:ShowPanel()
end

function Commercial_AnniversaryCelebrationUI:ShowMonsterPanel()
  self.monsterTemplate:Refresh()
end

function Commercial_AnniversaryCelebrationUI:ResetMonsterPanel()
  self.monsterTemplate:ShowPanel()
end

function Commercial_AnniversaryCelebrationUI:ShowBattleOrderPanel()
  self:ShowBattleOrderReward()
  self:ShowBattleOrderTask()
end

function Commercial_AnniversaryCelebrationUI:SetPanelActive(data)
  local index = data.group
  self.nowIndex = index
  for i, v in pairs(self.BtnList) do
    if i == index then
      v:SetActive(true)
      self:ShowPanel(index)
    else
      v:SetActive(false)
      self:HidePanel(index)
    end
  end
end

local DaojiTime = 0

function Commercial_AnniversaryCelebrationUI:RefreshTime(timeControl)
  if 0 < DaojiTime then
    DaojiTime = DaojiTime - 1
    local DaoJiShi = TimeUtility.ShowDayHourMin(DaojiTime)
    timeControl:SetText("Th\225\187\157i gian c\195\178n: " .. DaoJiShi)
  else
    timeControl:SetText("S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c")
  end
end

function Commercial_AnniversaryCelebrationUI:SetOpeningInfo(data)
  if self.lastTimeGiftList[data.group] == nil then
    return
  end
  if self.destoryTimeSchedule then
    self:SetDestroyTime()
  end
  local down = TimeUtility.InTweenyearTimeTheEnd(data.deadline[1][2])
  local Difference = TimeUtility.RefreshSec(down)
  local DaoJiShi
  if Difference <= 0 then
    DaoJiShi = "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
    self.lastTimeGiftList[data.group]:SetText(DaoJiShi)
  else
    DaoJiShi = TimeUtility.ShowDayHourMin(Difference)
    self.lastTimeGiftList[data.group]:SetText("Th\225\187\157i gian c\195\178n: " .. DaoJiShi)
    DaojiTime = Difference
    self.destoryTimeSchedule = Timer.StartLoopForever(1, self.RefreshTime, self, self.lastTimeGiftList[data.group])
  end
end

function Commercial_AnniversaryCelebrationUI:SetDestroyTime()
  if self.destoryTimeSchedule then
    Timer.Stop(self.destoryTimeSchedule)
    self.destoryTimeSchedule = nil
  end
end

function Commercial_AnniversaryCelebrationUI:CheckRedPoint()
  local pageTemplate
  if type(self.BtnHolidayContainer) == "table" and type(self.BtnHolidayContainer.items) == "table" then
    for i, v in pairs(self.BtnHolidayContainer.items) do
      pageTemplate = v.itemTemp
      if pageTemplate.CheckRedPoint ~= nil then
        pageTemplate:CheckRedPoint()
      end
    end
  end
end

function Commercial_AnniversaryCelebrationUI:ShowPanel(index)
  if index == AnniversaryActivityEnum.BattleOrder then
    self.CelebrationPassPanel:SetActive(true)
    self.CelebrationPassTaskPanel:SetActive(false)
    self.btn_goCelebrationTaskTip:SetText(self.switchText[1])
  elseif index == AnniversaryActivityEnum.NpcActivity then
    self.npcEffect:SetActive(AnniversaryActivity_NPCActivityData.CheckRedPoint())
  end
end

function Commercial_AnniversaryCelebrationUI:HidePanel(index)
  if index == AnniversaryActivityEnum.BattleOrder then
    if self.doTween then
      self.doTween:Kill()
      self.doTween = nil
    end
    self.lastBattleOrderExp = nil
    self.lastBattleOrderLevel = nil
  end
end

function Commercial_AnniversaryCelebrationUI:OnHide()
  self:SetDestroyTime()
  for i, v in pairs(self.BtnList) do
    v:SetActive(false)
  end
end

function Commercial_AnniversaryCelebrationUI:OnDestroy()
end
