Task_TransferUI = class(BaseUI)
Task_TransferUI.layer = UILayer.Panel
Task_TransferUI.orderInLayer = 0
Task_TransferUI.hideType = UIHideType.WaitDestroy
Task_TransferUI.hideFunc = UIHideFunc.MoveOutOfScreen
Task_TransferUI.escClose = UIEscClose.DontClose

function Task_TransferUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.Panel_Task = self:GetControl("Panel_Task")
  self.transfer_step1 = self:GetControl("Panel_Task/transfer_info/img_step1/transfer_step1")
  self.transfer_step2 = self:GetControl("Panel_Task/transfer_info/img_step2/transfer_step2")
  self.transfer_step3 = self:GetControl("Panel_Task/transfer_info/img_step3/transfer_step3")
  self.lab_attributegrow = self:GetControl("Panel_Task/task_name/lab_attributegrow")
  self.lab_requirements = self:GetControl("Panel_Task/lab_requirements")
  self.btn_3Dcost = self:GetControl("Panel_Task/lab_requirements/taskcost/btn_3Dcost")
  self.btn_get2 = self:GetControl("Panel_Task/lab_requirements/btn_get2")
  self.lab_consumeCount = self:GetControl("Panel_Task/lab_requirements/lab_consumeCount")
  self.lab_progress = self:GetControl("Panel_Task/task_progress/lab_progress")
  self.btn_close = self:GetControl("Panel_Task/btn_close")
  self.btn_submit = self:GetControl("Panel_Task/btn_submit")
  self.text_taskName = self:GetControl("Panel_Task/text_taskName")
end

function Task_TransferUI:OnPreLoad()
end

function Task_TransferUI:Init()
end

function Task_TransferUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Task_TransferUI:InitUI()
  self:InitContent()
end

function Task_TransferUI:OnShow()
  self:RegistEvents()
  self:Refresh()
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

function Task_TransferUI:InitContent()
  self.taskCostItemTemp = UIContainer(self.btn_3Dcost, self, InitTaskCostItemControls, ItemCostRefresh)
end

function Task_TransferUI:OnHide()
end

function Task_TransferUI:OnDestroy()
end

function Task_TransferUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.btn_3Dcost:SetOnClick(self, self.btn_3DcostOnClick)
  self.btn_get2:SetOnClick(self, self.btn_get2OnClick)
  self.btn_close:SetOnClick(self, self.btn_closeOnClick)
  self.btn_submit:SetOnClick(self, self.btn_submitOnClick)
end

function Task_TransferUI:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.Task_TransferUI)
end

function Task_TransferUI:btn_3DcostOnClick(control)
end

function Task_TransferUI:btn_get2OnClick(control)
end

function Task_TransferUI:btn_closeOnClick(control)
  UIManager.Hide(UIID.Task_TransferUI)
end

function Task_TransferUI:btn_submitOnClick(control)
  UIManager.Hide(UIID.Task_TransferUI)
  if self.args ~= nil then
    local task = self.args
    if self.args.subPosition ~= nil then
      local taskId = self.args.subPosition
      task = TaskData.GetTaskById(taskId)
    end
    if task ~= nil then
      EventManager.Dispatch(Event.Task_BtnSubmitClick, task:GetId())
    end
  end
end

function Task_TransferUI:RegistEvents()
end

function Task_TransferUI:Refresh()
  if self.args ~= nil then
    local task = self.args
    if self.args.subPosition ~= nil then
      local taskId = self.args.subPosition
      task = TaskData.GetTaskById(taskId)
    end
    if task ~= nil then
      local taskState = task:GetState()
      self.lab_progress:SetText(task:GetTaskMonsterProgress())
      if taskState == TaskStateType.Acceptable then
        self.lab_attributegrow:SetText(task:GetAcceptTips())
      elseif taskState == TaskStateType.Accept then
        self.lab_attributegrow:SetText(task:GetRewardTips())
      elseif taskState == TaskStateType.Completed then
        self.lab_attributegrow:SetText(task:GetRewardTips())
      end
      self.text_taskName:SetText(task:GetName())
      self.btn_submit:SetActive(taskState == TaskStateType.Completed)
      self.lab_requirements:SetActive(true)
      local curReward = task:GetCompleteCost()
      local curCost = {}
      for k, v in pairs(curReward) do
        table.insert(curCost, {itemID = k, itemNum = v})
      end
      self.taskCostItemTemp:SetData(curCost)
    end
  end
end
