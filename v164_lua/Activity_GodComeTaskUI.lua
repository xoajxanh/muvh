Activity_GodComeTaskUI = class(BaseUI)
Activity_GodComeTaskUI.layer = UILayer.Panel
Activity_GodComeTaskUI.orderInLayer = 0
Activity_GodComeTaskUI.hideType = UIHideType.Hide
Activity_GodComeTaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_GodComeTaskUI.escClose = UIEscClose.DontClose

function Activity_GodComeTaskUI:InitControls()
  self.RootPanel = self:GetControl("RootPanel")
  self.AllPanel = self:GetControl("RootPanel/AllPanel")
  self.subPanel = self:GetControl("RootPanel/AllPanel/panel/subPanel")
  self.GoalPanel = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel")
  self.lab_instance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/lab_instance")
  self.warAllianceBossInstance = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance")
  self.labboss_time = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/tx_time/labboss_time")
  self.lab_layer = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/layout/lab_layer")
  self.lab_rewardsBlood = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/lab_rewardsBlood")
  self.ContentBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/lab_rewardsBlood/ScrollView/Viewport/ContentBloodCastle")
  self.btn_ItemBloodCastle = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/warAllianceBossInstance/lab_rewardsBlood/ScrollView/Viewport/ContentBloodCastle/btn_ItemBloodCastle")
  self.descBtn = self:GetControl("RootPanel/AllPanel/panel/subPanel/GoalPanel/descBtn")
  self.bg_countdown = self:GetControl("RootPanel/bg_countdown")
  self.lab_countdown = self:GetControl("RootPanel/bg_countdown/lab_countdown")
  self.btn_Exit = self:GetControl("RootPanel/btn_Exit")
  self.lab_time = self:GetControl("RootPanel/btn_Exit/lab_time")
  self.fightTime = self:GetControl("RootPanel/btn_Exit/fightTime")
  self.lab_fightTimeValue = self:GetControl("RootPanel/btn_Exit/fightTime/lab_fightTimeValue")
end

local AllGodstimer

function Activity_GodComeTaskUI:OnPreLoad()
end

function Activity_GodComeTaskUI:Init()
end

function Activity_GodComeTaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_GodComeTaskUI:InitUI()
  self:InitRewardCtr()
end

function Activity_GodComeTaskUI:OnShow()
  if LeftTopPanelManager.GetCurrentPanelType() == PanelType.GodComePaneType then
    self.AllPanel:SetActive(true)
  else
    self.AllPanel:SetActive(false)
  end
  self:RegistEvents()
  self:Refresh()
  self:RootPanelState(true)
end

function Activity_GodComeTaskUI:RootPanelState(state)
  self.RootPanel:SetActive(state)
end

function Activity_GodComeTaskUI:OnHide()
  if AllGodstimer then
    Timer.Stop(AllGodstimer)
    AllGodstimer = nil
  end
  TranScriptData.ClearData()
end

function Activity_GodComeTaskUI:OnDestroy()
end

function Activity_GodComeTaskUI:RegistUIEvents()
  self.btn_ItemBloodCastle:SetOnClick(self, self.btn_ItemBloodCastleOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
  self.btn_Exit:SetOnClick(self, self.btn_ExitOnClick)
end

function Activity_GodComeTaskUI:btn_ItemBloodCastleOnClick(control)
end

function Activity_GodComeTaskUI:descBtnOnClick(control)
end

function Activity_GodComeTaskUI:btn_ExitOnClick(control)
  local cfg_Uiword = ClientTable.cfg_Ui_wordManager:TryGetValue("GodCome_1", "id")
  local prompTipArgs = {
    title = "Nh\225\186\175c nh\225\187\159",
    textContent = cfg_Uiword.content,
    ok = function()
      self:OnHide()
      TranScriptController.ReqExitAllGods()
    end,
    canel = function()
      UIManager.Hide(this.name)
    end
  }
  UIManager.Show(UIID.PromptTipUI, prompTipArgs)
end

function Activity_GodComeTaskUI:RegistEvents()
  self:RegistEvent(Event.UpdateGodComeTaskUI, self.UpdateGodComeTaskUIFunc, self)
  self:RegistEvent(Event.UpdateGodComeEnterView, self.UpdateGodComeEnterViewFunc, self)
  self:RegistEvent(Event.DisabledCloseBtn, self.DisabledCloseBtnFunc, self)
  self:RegistEvent(Event.Scene_ShowLoading, self.Scene_ShootSceneFunc, self)
end

function Activity_GodComeTaskUI:DisabledCloseBtnFunc()
  if TranScriptData.InAllGodCloseBtn then
    self.btn_Exit:SetInteractable(true)
  else
    self.btn_Exit:SetInteractable(false)
  end
end

function Activity_GodComeTaskUI:UpdateGodComeTaskUIFunc()
  if TranScriptData.InAllGodsscript then
    local cfgMapinstance = ConfigManager.FindConfigs("cfg_Map_instance", "mapId", TranScriptData.InAllGodsscriptData.mapId)[1]
    if cfgMapinstance then
      EventManager.Dispatch(Event.HiddenbtnForecast)
      self.lab_instance:SetText(cfgMapinstance.name)
      local AwardData = {}
      local AwardDataDimension = {}
      local AwardTab = string.split(cfgMapinstance.dropItem, "&")
      for i = 1, table.count(AwardTab) do
        AwardData[i] = string.split(AwardTab[i], "#")
      end
      self.AllGodsItemTemp:SetData(AwardData)
      self:UpdateGodComeMonster(TranScriptData.InAllGodsscriptData)
      self:AllGodsCountDown()
    end
  end
end

function Activity_GodComeTaskUI:AllGodsCountDown()
  local surplusTime = TranScriptData.InAllGodsscriptData.endTime - Time.GetServerSecondTime()
  
  local function UpdateTimer()
    surplusTime = surplusTime - 1
    local timeStr = TimeUtility.ShowTimeWithColon(surplusTime)
    if (surplusTime <= 0 or TranScriptData.InAllGodsscript == false) and AllGodstimer then
      Timer.Stop(AllGodstimer)
      AllGodstimer = nil
    end
    self.lab_fightTimeValue:SetText(timeStr)
  end
  
  if not AllGodstimer then
    AllGodstimer = Timer.StartLoop(1, surplusTime, UpdateTimer)
  end
end

function Activity_GodComeTaskUI:UpdateGodComeEnterViewFunc()
  local Monsterdata = TranScriptData.AllGodsBossData
  self:UpdateGodComeMonster(Monsterdata)
end

function Activity_GodComeTaskUI:UpdateGodComeMonster(Monsterdata)
  if Monsterdata then
    if Monsterdata.boss.belongCampName == "" and Monsterdata.boss.ownerName == "" then
      self.lab_layer:SetText("Kh\195\180ng s\225\187\159 h\225\187\175u")
    elseif Monsterdata.boss.belongCampName ~= "" then
      self.lab_layer:SetText(Monsterdata.boss.belongCampName)
    else
      self.lab_layer:SetText(Monsterdata.boss.ownerName)
    end
  else
    self.lab_layer:SetText("Kh\195\180ng s\225\187\159 h\225\187\175u")
  end
end

local function OnItemRewardCreate(ctr)
  ctr.itemCtr = ItemUtility.InitItemCell(UIControl(ctr.transform))
  ctr.lab_num = UIControl(ctr.transform, "lab_num")
  ctr.modelData = ItemCellData()
end

local function OnItemRewardRefresh(ctr, _, data, ui)
  local itemData = ItemUtility.GenerateItemData(tonumber(data[1]))
  data.count = data[2]
  itemData.count = data.count
  ctr.modelData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.itemCtr, ctr.modelData, ui, true)
end

function Activity_GodComeTaskUI:InitRewardCtr()
  self.AllGodsItemTemp = UIContainer(self.btn_ItemBloodCastle, self, OnItemRewardCreate, OnItemRewardRefresh)
end

function Activity_GodComeTaskUI:Refresh()
  self:DisabledCloseBtnFunc()
end

function Activity_GodComeTaskUI:Scene_ShootSceneFunc()
  if TranScriptData.InAllGodsscript then
    self:OnHide()
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
    EventManager.Dispatch(Event.Task_ChangePanelState)
  end
end
