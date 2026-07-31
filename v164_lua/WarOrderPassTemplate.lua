local WarOrderPassTemplate = {}

function WarOrderPassTemplate:Init(data)
  self:InitControls()
  self:InitData(data)
  self:BindUIEvent()
  self:InitContainer()
end

function WarOrderPassTemplate:InitControls()
  self.nowControl = self:GetControl()
  self.lab_levelValue = self:GetControl("img_Cumulative/level/lab_levelValue")
  self.go_progress = self:GetControl("img_Cumulative/go_progress")
  self.go_alphaFilled = self:GetControl("img_Cumulative/go_alpha/go_alphaFilled")
  self.btn_goWarOrderTask = self:GetControl("btn_goWarOrderTask")
  self.tip = self:GetControl("btn_goWarOrderTask/tip")
  self.btn_money = self:GetControl("WarOrderPassPanel/btn_money")
  self.lab_num = self:GetControl("WarOrderPassPanel/btn_money/lab_num")
  self.btn_Allget = self:GetControl("WarOrderPassPanel/btn_Allget")
  self.img_redPoint = self:GetControl("WarOrderPassPanel/btn_Allget/img_redPoint")
  self.item_WarOrderPass_lastReward = self:GetControl("WarOrderPassPanel/item_WarOrderPass_lastReward")
  self.WarOrderPassPanel = self:GetControl("WarOrderPassPanel")
  self.WarOrderPassTaskPanel = self:GetControl("WarOrderPassTaskPanel")
  self.sw_WarOrderPass = self:GetControl("WarOrderPassPanel/sw_WarOrderPass")
  self.Viewport = self:GetControl("WarOrderPassPanel/sw_WarOrderPass/Viewport")
  self.Content = self:GetControl("WarOrderPassPanel/sw_WarOrderPass/Viewport/Content")
  self.item_WarOrderPass = self:GetControl("WarOrderPassPanel/sw_WarOrderPass/Viewport/Content/item_WarOrderPass")
  self.Item_WarOrderTask = self:GetControl("WarOrderPassTaskPanel/sw_holidayTask/Viewport/Content/Item_WarOrderTask")
  self.txt_lastTimeGift = self:GetControl("txt_lastTimeGift")
  self.img_money_ground = self:GetControl("WarOrderPassPanel/btn_money/img_money_ground")
end

function WarOrderPassTemplate:InitContainer()
  self.lastRewardTemplate = luaTemplateManager.GetNewTemplate(self.item_WarOrderPass_lastReward, LuaComponentTemplates.WarOrderPassRewardTemplate, {
    rootUI = self.rootUI,
    type = 2
  })
  self.item_WarOrderPassContainer = UIUtility.BindUIContainerTemp(self.item_WarOrderPass, LuaComponentTemplates.WarOrderPassRewardTemplate, self.rootUI, {
    rootUI = self.rootUI,
    type = 1
  })
  self.Item_WarOrderTaskContainer = UIUtility.BindUIContainerTemp(self.Item_WarOrderTask, LuaComponentTemplates.WarOrderPassTaskTemplate, self.rootUI)
end

function WarOrderPassTemplate:InitData(data)
  if type(data) == "table" then
    self.rootUI = data.rootUI
    self.activityBaseType = data.activityBaseType
    self.activityIdType = data.activityIdType
  end
  self.btn_money.type = BattlePassRewardTypeEnum.Up
  self.panelList = {}
  self.WarOrderPassPanel.refreshFunc = self.RefreshReward
  self.WarOrderPassTaskPanel.refreshFunc = self.RefreshTask
  table.insert(self.panelList, self.WarOrderPassPanel)
  table.insert(self.panelList, self.WarOrderPassTaskPanel)
  self.cellSizeX = self.Content.layoutGroup.cellSize.x
  self.spaceX = self.Content.layoutGroup.spacing.x
  self.contentPosX = self.Content:GetAnchoredPosition()
  self.targetPosX = self.sw_WarOrderPass:GetSizeDelta()
  self.offsetWide = self.item_WarOrderPass_lastReward:GetSizeDelta()
  self.cost = ClientTable.cfg_Commerce_globalManager:GetWarOrderPassUpCost()
  self.rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(2100001)
  self.switchText = ClientTable.cfg_Commerce_globalManager:GetWarOrderPassSwitchText()
  self.buyPrompt = ClientTable.cfg_Ui_promptwordManager:GetUi_promptwordCount(18)
  self.lab_numPosX, self.lab_numPosY = self.lab_num:GetAnchoredPosition()
end

function WarOrderPassTemplate:BindUIEvent()
  self.sw_WarOrderPass:SetOnScrollRectChanged(self, self.sw_WarOrderPassOnChange)
  self.btn_goWarOrderTask:SetOnClick(self, self.SwitchPanelOnClick)
  self.btn_money:SetOnClick(self, self.btn_moneyOnClick)
  self.btn_Allget:SetOnClick(self, self.btn_AllgetOnClick)
end

function WarOrderPassTemplate:SwitchPanelOnClick()
  for i, v in ipairs(self.panelList) do
    v:SetActive(not v:GetActive())
    if v:GetActive() then
      v.refreshFunc(self)
      self.tip:SetText(self.switchText[i])
    end
  end
end

function WarOrderPassTemplate:btn_moneyOnClick(control)
  if self.activityBaseType == ActivityBaseType.CommerceActivity then
    if BagInfoData.GetItemTotalCountByItemId(self.cost.itemId) < self.cost.count then
      local tipStr = LocalizationUtility.GetContentByKey("huobibuzu")
      FloatingWordUtility.QuickMsg(tipStr)
      UIManager.Hide(UIID.Commercial_CombineActivityUI)
      RechargeData.BuyDiamond()
      return
    end
    local promptTipArgs = {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = self.buyPrompt,
      ok = function()
        NetManager.Send(CommerceMessage.ReqBuyZhanLing, {
          type = control.type
        })
      end
    }
    UIManager.Show(UIID.PromptTipUI, promptTipArgs)
  elseif self.activityBaseType == ActivityBaseType.LimitedTimeActivity then
    local itemPrice = math.floor(self.rechargeCfg.rmb / 100)
    DataToCSharpMgr.Pay({
      amount = itemPrice,
      product_Id = self.rechargeCfg.id,
      product_name = self.rechargeCfg.name
    })
  end
end

function WarOrderPassTemplate:btn_AllgetOnClick()
  local canGetRewardList = self:GetMiracleBattlePassMgr():GetCanGetRewardList()
  if canGetRewardList then
    local tbl = {}
    tbl.rewardId = {}
    tbl.rewardId = canGetRewardList
    NetManager.Send(CommerceMessage.ReqZhanLingReward, tbl)
  end
end

function WarOrderPassTemplate:sw_WarOrderPassOnChange()
  self.contentPosX = self.Content:GetAnchoredPosition()
  self:GetMiracleBattlePassMgr():CalculateRareRewardListDistance(self.cellSizeX, self.spaceX, self.contentPosX, self.targetPosX)
end

function WarOrderPassTemplate:Refresh()
  self:RefreshLevel()
  self:RefreshReward()
  self:sw_WarOrderPassOnChange()
  self:RefreshRareReward()
  self:RefreshBtnMoney()
  self:RefreshTime()
  self:RefreshRedPoint()
end

function WarOrderPassTemplate:RefreshLevel()
  local level = self:GetMiracleBattlePassMgr():GetLevel()
  if level then
    self.lab_levelValue:SetText(tostring(level))
  end
  local curExp = self:GetMiracleBattlePassMgr():GetCurExp()
  local nextExp = self:GetMiracleBattlePassMgr():GetNextExp()
  self.go_progress:SetText(tostring(curExp) .. "/" .. tostring(nextExp))
  local progress = curExp / nextExp
  if progress < 0 then
    progress = 0
  end
  if 1 < progress then
    progress = 1
  end
  self.go_alphaFilled:SetFillAmount(progress)
end

function WarOrderPassTemplate:RefreshReward()
  local rewardInfoList = self:GetMiracleBattlePassMgr():GetLevelRewardInfoList()
  self.item_WarOrderPassContainer:SetData(rewardInfoList)
  local index = self:GetMiracleBattlePassMgr():GetStartIndex()
  self.Content:SetAnchoredPosition(-(self.cellSizeX + self.spaceX) * (index - 1), 0)
end

function WarOrderPassTemplate:RefreshRareReward()
  local rareInfo = self:GetMiracleBattlePassMgr():GetShowRareReward()
  if rareInfo then
    self.item_WarOrderPass_lastReward:SetActive(true)
    self.Viewport:SetSizeDelta(0, 0)
    self.lastRewardTemplate:Refresh(rareInfo, self.rootUI)
  else
    self.Viewport:SetSizeDelta(self.offsetWide, 0)
    self.item_WarOrderPass_lastReward:SetActive(false)
  end
end

function WarOrderPassTemplate:RefreshTask()
  local taskInfoList = self:GetMiracleBattlePassMgr():GetTaskInfoList()
  self.Item_WarOrderTaskContainer:SetData(taskInfoList)
end

function WarOrderPassTemplate:RefreshBtnMoney()
  local isUp = self:GetMiracleBattlePassMgr():IsHasType(self.btn_money.type)
  self.btn_money:SetActive(not isUp)
  local text = "Chi\225\186\191n L\225\187\135nh Ti\225\186\191n B\225\186\173c %s"
  if self.activityBaseType == ActivityBaseType.CommerceActivity then
    self.img_money_ground:SetActive(true)
    text = string.format(text, tostring(self.cost.count))
    self.lab_num:SetAnchoredPosition(self.lab_numPosX, self.lab_numPosY)
  elseif self.activityBaseType == ActivityBaseType.LimitedTimeActivity then
    self.img_money_ground:SetActive(false)
    if #tostring(self.rechargeCfg.rmb) > 4 then
      text = string.format(text, tostring(math.floor(self.rechargeCfg.rmb / 1000)) .. "K")
    else
      text = string.format(text, tostring(math.floor(self.rechargeCfg.rmb)) .. " VN\196\144")
    end
  end
  self.lab_num:SetAnchoredPosition(self.lab_numPosX, self.lab_numPosY)
  self.lab_num:SetText(text)
end

function WarOrderPassTemplate:RefreshTime()
  if self.RemainTimeLoop ~= nil then
    Timer.Stop(self.RemainTimeLoop)
  end
  self.RemainTimeLoop = Timer.StartLoopForever(1, function()
    self.txt_lastTimeGift:SetText(self:GetMiracleBattlePassMgr():GetRemainTimeDes())
  end)
end

function WarOrderPassTemplate:RefreshRedPoint()
  local isShow = false
  isShow = self:GetMiracleBattlePassMgr():CheckRedPointState()
  self.img_redPoint:SetActive(isShow)
end

function WarOrderPassTemplate:Exit()
  self:ResetPanel()
  self:DestroyTime()
  local template
  if type(self.item_WarOrderPassContainer) == "table" and type(self.item_WarOrderPassContainer.items) == "table" then
    for k, v in pairs(self.item_WarOrderPassContainer.items) do
      template = v.itemTemp
      if template.Exit ~= nil then
        template:Exit()
      end
    end
  end
  self.lastRewardTemplate:Exit()
end

function WarOrderPassTemplate:ResetPanel()
  for i, v in ipairs(self.panelList) do
    v:SetActive(i == 1)
  end
  self.tip:SetText(self.switchText[1])
end

function WarOrderPassTemplate:DestroyTime()
  Timer.Stop(self.RemainTimeLoop)
  self.RemainTimeLoop = nil
end

function WarOrderPassTemplate:GetMiracleBattlePassMgr()
  if gameMgr:GetGlobalActivityDataManager():GetActivityManger(self.activityBaseType) and gameMgr:GetGlobalActivityDataManager():GetActivityManger(self.activityBaseType):GetActivityData(self.activityIdType) then
    return gameMgr:GetGlobalActivityDataManager():GetActivityManger(self.activityBaseType):GetActivityData(self.activityIdType)
  end
end

return WarOrderPassTemplate
