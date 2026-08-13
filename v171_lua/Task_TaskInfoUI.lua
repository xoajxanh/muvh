Task_TaskInfoUI = class(BaseUI)
Task_TaskInfoUI.layer = UILayer.Panel
Task_TaskInfoUI.orderInLayer = 0
Task_TaskInfoUI.hideType = UIHideType.WaitDestroy
Task_TaskInfoUI.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TaskInfoUI.escClose = UIEscClose.DontClose

function Task_TaskInfoUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Panel_Task = self:GetControl("Panel_Task")
  self.text_dialogue = self:GetControl("Panel_Task/text_dialogue")
  self.img_task = self:GetControl("Panel_Task/img_task")
  self.text_taskName = self:GetControl("Panel_Task/text_taskName")
  self.Content = self:GetControl("Panel_Task/lab_taskrewards/Scroll View/Viewport/Content")
  self.btn_3DItem = self:GetControl("Panel_Task/lab_taskrewards/Scroll View/Viewport/Content/btn_3DItem")
  self.btn_accept = self:GetControl("btn_accept")
  self.btn_submit = self:GetControl("btn_submit")
  self.btn_reward = self:GetControl("btn_reward")
  self.btn_close = self:GetControl("btn_close")
  self.lab_requirements = self:GetControl("lab_requirements")
  self.btn_3Dcost = self:GetControl("lab_requirements/taskcost/btn_3Dcost")
  self.btn_get2 = self:GetControl("lab_requirements/btn_get2")
  self.lab_consumeCount = self:GetControl("lab_requirements/lab_consumeCount")
end

local task

function Task_TaskInfoUI:Init()
  task = self.args
  if not task then
    task = TaskController.curTask
  end
end

function Task_TaskInfoUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Task_TaskInfoUI:InitUI()
  self:InitContent()
  if not self.args then
    return
  end
end

function Task_TaskInfoUI:OnShow()
  self:RegistEvents()
  self:Refresh()
  self:AddCoolDownTime()
end

function Task_TaskInfoUI:AddCoolDownTime()
  if AutoTaskManage.NewPeriod() then
    if self.countDownTimer then
      Timer.Stop(self.countDownTimer)
      self.countDownTimer = nil
    end
    local autoTime = ClientTable.cfg_Global_globalManager:TryGetValue(2460101, "id").effect
    if autoTime and tonumber(autoTime) > 0 then
      self:StartAutoCurTask(tonumber(autoTime))
    end
  end
end

function Task_TaskInfoUI:StartAutoCurTask(autoTime)
  self.countDownTimer = Timer.StartLoop(autoTime / 1000, 1, function()
    local taskState = task:GetState()
    if taskState == TaskStateType.Acceptable then
      self:btn_acceptOnClick()
    end
    if taskState == TaskStateType.Accept then
      self:btn_submitOnClick()
    end
    if taskState == TaskStateType.Completed then
      self:btn_submitOnClick()
    end
  end)
end

function Task_TaskInfoUI:SetArgs(args)
  self.args = args
  task = self.args
  if not task then
    task = TaskController.curTask
  end
end

function Task_TaskInfoUI:OnHide()
  if self.countDownTimer then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end

function Task_TaskInfoUI:OnDestroy()
end

function Task_TaskInfoUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_CloseClick)
  self.btn_close:SetOnClick(self, self.CloseClick)
  self.btn_accept:SetOnClick(self, self.btn_acceptOnClick)
  self.btn_submit:SetOnClick(self, self.btn_submitOnClick)
  self.btn_reward:SetOnClick(self, self.btn_submitOnClick)
end

function Task_TaskInfoUI:CloseClick(control)
  UIManager.Hide(UIID.TaskInfoUI)
  AutoTaskManage.AddListenerRoleCommitFail(task)
  RoleManager.me:SetTarget(nil)
end

function Task_TaskInfoUI:btn_CloseClick(control)
  self:btn_submitOnClick()
end

function Task_TaskInfoUI:TaskChangeClose()
  UIManager.Hide(UIID.TaskInfoUI)
  RoleManager.me:SetTarget(nil)
end

function Task_TaskInfoUI:btn_acceptOnClick(control)
  EventManager.Dispatch(Event.Task_BtnAcceptClick, task:GetId())
  self:TaskChangeClose()
end

function Task_TaskInfoUI:btn_submitOnClick(control)
  self:TaskChangeClose()
  EventManager.Dispatch(Event.Task_BtnSubmitClick, task:GetId())
end

function Task_TaskInfoUI:btn_rewardOnClick(control)
  EventManager.Dispatch(Event.Task_BtnRewardClick, task:GetId())
  self:TaskChangeClose()
end

local function InitTaskRewardItemControls(ctr)
  ctr.itemCellData = ItemCellData()
end

local function ItemTaskRewardRefresh(ctr, _, rewards, ui)
  if not ctr.itemCellData.itemData or ctr.itemCellData.itemData.tblItem.itemId ~= tonumber(rewards.itemID) then
    local itemData = ItemUtility.GenerateItemData(rewards.itemID)
    ctr.itemCellData:RefreshData(itemData)
  end
  ctr.itemCellData.itemData.count = rewards.itemNum
  ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
end

local function InitTaskCostItemControls(ctr)
  ctr.itemCellData = ItemCellData()
end

local function ItemCostRefresh(ctr, _, rewards, ui)
  if not ctr.itemCellData.itemData or ctr.itemCellData.itemData.tblItem.itemId ~= tonumber(rewards.itemID) then
    local itemData = ItemUtility.GenerateItemData(rewards.itemID)
    ctr.itemCellData:RefreshData(itemData)
    ctr.itemCellData.itemData.count = rewards.itemNum
    ItemUtility.ShowItemCell(ctr, ctr.itemCellData, ui, true)
    local bagCount = BagInfoData.GetItemCountByItemConfigId(tonumber(rewards.itemID))
    local strTx = " "
    if bagCount >= tonumber(rewards.itemNum) then
      bagCount = bagCount == 1 and "1" or MathUtility.TransNumber(bagCount, 1)
      rewards.itemNum = rewards.itemNum == 1 and rewards.itemNum or MathUtility.TransNumber(rewards.itemNum, 1)
      strTx = string.format("<color=green>%s/%s</color>", bagCount, rewards.itemNum)
      ui.btn_get2:SetActive(false)
    else
      bagCount = bagCount == 1 and "1" or MathUtility.TransNumber(bagCount, 1)
      rewards.itemNum = rewards.itemNum == 1 and rewards.itemNum or MathUtility.TransNumber(rewards.itemNum, 1)
      strTx = string.format("<color=red>%s/%s</color>", bagCount, rewards.itemNum)
      ui.btn_get2:SetActive(true)
    end
    ui.lab_consumeCount:SetText(strTx)
    ui.btn_get2.itemData = itemData
    ui.btn_get2:SetOnClick(ItemUtility, ItemUtility.ClickObtainItemBtn)
  end
end

function Task_TaskInfoUI:InitContent()
  self.taskRewardItemTemp = UIContainer(self.btn_3DItem, self, InitTaskRewardItemControls, ItemTaskRewardRefresh)
  self.taskCostItemTemp = UIContainer(self.btn_3Dcost, self, InitTaskCostItemControls, ItemCostRefresh)
end

function Task_TaskInfoUI:RegistEvents()
end

function Task_TaskInfoUI:Refresh()
  local task = self.args
  local taskState = task:GetState()
  self.text_taskName:SetText(task:GetName())
  if taskState == TaskStateType.Acceptable then
    self.text_dialogue:SetText(task:GetAcceptTips())
  elseif taskState == TaskStateType.Completed then
    self.text_dialogue:SetText(task:GetRewardTips())
  end
  self.btn_accept:SetActive(taskState == TaskStateType.Acceptable)
  self.btn_submit:SetActive(taskState == TaskStateType.Accept)
  self.btn_reward:SetActive(taskState == TaskStateType.Completed)
  self.lab_requirements.gameObject:SetActive(false)
  if taskState == TaskStateType.Acceptable and task:GetTaskTypeID() == RoleTaskType.TransferTask then
    self.lab_requirements:SetActive(true)
    local curReward = task:GetCost()
    local curCost = {}
    for k, v in pairs(curReward) do
      table.insert(curCost, {itemID = k, itemNum = v})
    end
    self.taskCostItemTemp:SetData(curCost)
  end
  local rewards = task:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(k)
    if itemConfig and itemConfig.subType ~= 301 then
      table.insert(allRewards, {itemID = k, itemNum = v})
    end
  end
  self.taskRewardItemTemp:SetData(allRewards)
end
