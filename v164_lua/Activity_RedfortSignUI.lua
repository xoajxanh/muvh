Activity_RedfortSignUI = class(BaseUI)
Activity_RedfortSignUI.layer = UILayer.Panel
Activity_RedfortSignUI.orderInLayer = 0
Activity_RedfortSignUI.hideType = UIHideType.WaitDestroy
Activity_RedfortSignUI.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_RedfortSignUI.escClose = UIEscClose.DontClose

function Activity_RedfortSignUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.btn_close = self:GetControl("btn_close")
  self.grid = self:GetControl("Middel/lab_rewards/grid")
  self.rewardItem = self:GetControl("Middel/lab_rewards/grid/rewardItem")
  self.lab_level = self:GetControl("Middel/lab_level/lab_level")
  self.lab_time1 = self:GetControl("Middel/lab_time/lab_time1")
  self.lab_count1 = self:GetControl("Middel/lab_leftcount/lab_count1")
  self.btn_get1 = self:GetControl("Middel/lab_leftcount/btn_get1")
  self.numberPeople = self:GetControl("Middel/numberPeople")
  self.consumeItem = self:GetControl("Middel/lab_requirements/consumeItem")
  self.lab_already = self:GetControl("Middel/lab_requirements/lab_already")
  self.btn_get2 = self:GetControl("Middel/lab_requirements/btn_get2")
  self.btn_sign = self:GetControl("Middel/btn_sign")
  self.lab_signState = self:GetControl("Middel/btn_sign/lab_signState")
end

function Activity_RedfortSignUI:OnPreLoad()
end

function Activity_RedfortSignUI:Init()
end

function Activity_RedfortSignUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_RedfortSignUI:InitUI()
  self:InitRewardItem()
end

function Activity_RedfortSignUI:InitRewardItem()
  local rewardItem = ClientTable.cfg_Activity_overviewManager:TryGetValue(1005).showReward
  rewardItem = string.split(rewardItem, "#")
  for i = 1, #rewardItem do
    local rewardBtn = self.rewardItem:Instantiate()
    rewardBtn = UIControl(rewardBtn.transform)
    rewardBtn:SetActive(true)
    local itemCellData = ItemCellData()
    local itemData = ItemUtility.GenerateItemData(tonumber(rewardItem[i]))
    itemCellData:RefreshData(itemData)
    ItemUtility.ShowItemCell(rewardBtn, itemCellData, self, true)
  end
end

function Activity_RedfortSignUI:InitConsumeItem()
  local itemCellData = ItemCellData()
  local itemData = ItemUtility.GenerateItemData(8000010)
  itemCellData:RefreshData(itemData)
  itemData.count = ""
  ItemUtility.ShowItemCell(self.consumeItem, itemCellData, self, true)
end

function Activity_RedfortSignUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_RedfortSignUI:OnHide()
end

function Activity_RedfortSignUI:OnDestroy()
end

function Activity_RedfortSignUI:RegistUIEvents()
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_sign:SetOnClick(self, self.btn_signOnClick)
end

function Activity_RedfortSignUI:btn_closeOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Activity_RedfortSignUI)
end

function Activity_RedfortSignUI:btn_closeBgOnClick(control)
  EventManager.Dispatch(Event.CancelClickNpc)
  UIManager.Hide(UIID.Activity_RedfortSignUI)
end

function Activity_RedfortSignUI:btn_signOnClick(control)
  EventManager.Dispatch(Event.RedFortApply)
  self:CloseUI()
end

function Activity_RedfortSignUI:RegistEvents()
  self:RegistEvent(Event.Scene_SceneDataChange, self.CloseUI, self)
end

function Activity_RedfortSignUI:CloseUI()
  UIManager.Hide(UIID.Activity_RedfortSignUI)
end

function Activity_RedfortSignUI:Refresh()
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(1005, "activityId").condition
  local singTime = ClientTable.cfg_Activity_globalManager:TryGetValue(100502).effect
  local joinLevel = ClientTable.cfg_Activity_globalManager:TryGetValue(100503).effect
  singTime = tonumber(singTime)
  local a = openActivityCond[#openActivityCond]
  local timeOpenIndex = a[#a][2]
  local isOpen = ConditionManager.Check4D(openActivityCond)
  local intervalTimeStr = timeOpenIndex
  local timeStr = string.split(intervalTimeStr, "-")
  local startTime = TimeUtility.GetTimeStampByStr(timeStr[1])
  local endTime = startTime + singTime * 60
  local waitTime = string.format("%s-%s", timeStr[1], TimeUtility.SwitchHourStamp(endTime))
  local waitCondition = string.format("908#%s", waitTime)
  self.lab_count1:SetText(string.format("%s-%s", timeStr[1], TimeUtility.SwitchHourStamp(endTime)))
  self.lab_time1:SetText(intervalTimeStr)
  if ConditionManager.Check(waitCondition) then
    self.lab_count1:SetColor(EUIColor.Green)
  else
    self.lab_count1:SetColor(EUIColor.Red)
  end
  if isOpen then
    self.lab_time1:SetColor(EUIColor.Green)
  else
    self.lab_time1:SetColor(EUIColor.Red)
  end
  self.lab_level:SetText(joinLevel)
  if RoleManager.me.level < tonumber(joinLevel) then
    self.lab_level:SetColor(EUIColor.Red)
  else
    self.lab_level:SetColor(EUIColor.Green)
  end
end
