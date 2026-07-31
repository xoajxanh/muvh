WarAlliance_Task = class(BaseUI)
WarAlliance_Task.layer = UILayer.Panel
WarAlliance_Task.orderInLayer = 0
WarAlliance_Task.hideType = UIHideType.WaitDestroy
WarAlliance_Task.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_Task.escClose = UIEscClose.DontClose

function WarAlliance_Task:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.CloseBtn = self:GetControl("bg/backbg/CloseBtn")
  self.taskContent = self:GetControl("taskContent")
  self.uniontaskitem = self:GetControl("taskContent/uniontaskitem")
  self.unionTaskCount = self:GetControl("Counts/task/unionTaskCount")
  self.helpCount = self:GetControl("Counts/help/helpCount")
  self.shuaxin = self:GetControl("Counts/shuaxin")
  self.updateCount = self:GetControl("Counts/shuaxin/updateCount")
  self.xiaohao = self:GetControl("Counts/xiaohao")
  self.xiaoHaoNum = self:GetControl("Counts/xiaohao/xiaoHaoNum")
  self.updateBtn = self:GetControl("Counts/updateBtn")
end

function WarAlliance_Task:OnPreLoad()
end

function WarAlliance_Task:Init()
end

function WarAlliance_Task:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_Task:InitUI()
  self:InitContent()
end

local function InitRewardItemControls(item)
  local itemCellData = ItemCellData()
  item.itemCellData = itemCellData
end

local function ItemRewardRefresh(item, _, rewards, ui)
  local itemInfo = ItemUtility.GenerateItemData(tonumber(rewards.itemID))
  itemInfo.count = rewards.itemNum
  item.itemCellData:RefreshData(itemInfo)
  ItemUtility.ShowItemCell(item, item.itemCellData, ui, true)
end

local function InitTaskItemControls(ctr)
  ctr.unionTaskTitle = UIControl(ctr.transform, "taskTitle")
  ctr.unionTaskDetail = UIControl(ctr.transform, "taskDetail")
  ctr.unionTaskProgress = UIControl(ctr.transform, "taskDetail/taskProgress")
  ctr.unionTaskLevel = UIControl(ctr.transform, "taskLv")
  ctr.unionTaskAcceptable = UIControl(ctr.transform, "Acceptable")
  ctr.unionTaskAccept = UIControl(ctr.transform, "Accept")
  ctr.unionTaskCompleted = UIControl(ctr.transform, "Completed")
  ctr.unionTaskHelp = UIControl(ctr.transform, "Help")
  ctr.unionTaskNoHelp = UIControl(ctr.transform, "Help/help")
  ctr.unionTaskHaveHelp = UIControl(ctr.transform, "Help/haveHelp")
  ctr.isInUnionTask = UIControl(ctr.transform, "closeUnionTask")
  ctr.rewardContent = UIControl(ctr.transform, "rewardContent/btn_3DItem")
end

local function ItemTaskRefresh(ctr, _, unionTask, ui)
  if not ctr.ItemTemp then
    ctr.ItemTemp = UIContainer(ctr.rewardContent, ui, InitRewardItemControls, ItemRewardRefresh)
  end
  local rewards = unionTask:GetRewards()
  local allRewards = {}
  for k, v in pairs(rewards) do
    table.insert(allRewards, {itemID = k, itemNum = v})
  end
  ctr.ItemTemp:SetData(allRewards)
  local isInProgress = TaskData.IsUnionTaskProgress()
  if isInProgress then
    if unionTask.state == TaskStateType.Accept then
      ctr.isInUnionTask:SetActive(false)
    else
      ctr.isInUnionTask:SetActive(true)
    end
  else
    ctr.isInUnionTask:SetActive(false)
  end
  ctr.unionTaskTitle:SetText(unionTask.unionTaskTitle)
  ctr.unionTaskDetail:SetText(unionTask:GetUnionTaskTitle())
  ctr.unionTaskProgress:SetText(unionTask:GetUnionTaskJuTiInfo())
  local level, leveDes = unionTask:GetUnionTaskLevelDes()
  for i = 0, ctr.unionTaskLevel.transform.childCount - 1 do
    local child = ctr.unionTaskLevel.transform:GetChild(i)
    if i == tonumber(level - 1) then
      child:SetActive(true)
    else
      child:SetActive(false)
    end
  end
  ctr.unionTaskAcceptable.gameObject:SetActive(unionTask.state == TaskStateType.Acceptable)
  ctr.unionTaskAccept:SetActive(false)
  ctr.unionTaskHelp:SetActive(false)
  ctr.unionTaskCompleted:SetActive(unionTask.state == TaskStateType.Completed)
  if unionTask.state == TaskStateType.Accept then
    if unionTask.canHelp then
      ctr.unionTaskHelp:SetActive(true)
      ctr.unionTaskNoHelp:SetActive(true)
      ctr.unionTaskHaveHelp:SetActive(false)
    else
      ctr.unionTaskAccept:SetActive(true)
    end
  end
  ctr.unionTaskAcceptable:SetOnClick(ui, function()
    ui:AcceptableUnionTask(unionTask.taskId)
  end)
  ctr.unionTaskCompleted:SetOnClick(ui, function()
    ui:ReceiveUnionTaskAward(unionTask.taskId)
  end)
  ctr.unionTaskHelp:SetOnClick(ui, function()
    ui:AskUnionTaskHelp(unionTask)
    ctr.unionTaskNoHelp:SetActive(false)
    ctr.unionTaskHaveHelp:SetActive(true)
  end)
end

function WarAlliance_Task:InitContent()
  self.taskItemTemp = UIContainer(self.uniontaskitem, self, InitTaskItemControls, ItemTaskRefresh)
end

function WarAlliance_Task:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_Task:OnHide()
end

function WarAlliance_Task:OnDestroy()
end

function WarAlliance_Task:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.btn_closeBgOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.updateBtn:SetOnClick(self, self.updateUnionTak)
end

function WarAlliance_Task:btn_closeBgOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Task)
end

function WarAlliance_Task:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_Task)
end

function WarAlliance_Task:updateUnionTak(control)
  local isInProgress = TaskData.IsUnionTaskProgress()
  if isInProgress then
    local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_8")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = tostring(titleStr)
    })
  else
    NetManager.Send(TaskMessage.ReqFlushUTask)
  end
end

function WarAlliance_Task:RegistEvents()
  self:RegistEvent(Event.GradTask_Update, self.RefushPageInfo, self)
end

function WarAlliance_Task:Refresh()
  self:RefushPageInfo()
end

function WarAlliance_Task:RefushPageInfo()
  if TaskData.AllUnionTasks ~= nil then
    local allTask = {}
    for k, v in pairs(TaskData.AllUnionTasks) do
      table.insert(allTask, v)
    end
    self.taskItemTemp:SetData(allTask)
  end
  if TaskData.canAcceptCount ~= nil then
    local unionTaskCountStr = "(" .. TaskData.canAcceptCount .. "/" .. TaskData.GetCanUnionTaskCount() .. ")"
    self.unionTaskCount:SetText(unionTaskCountStr)
  end
  if TaskData.canAssistCount ~= nil then
    local helpCountStr = "(" .. TaskData.canAssistCount .. "/" .. TaskData.GetCanHelpUnionTaskCount() .. ")"
    self.helpCount:SetText(helpCountStr)
  end
  if TaskData.freeFlushCount ~= nil and TaskData.freeFlushCount > 0 then
    self.shuaxin:SetActive(true)
    self.xiaohao:SetActive(false)
    local freeFlushCount = TaskData.freeFlushCount
    local freeFlushCountStr = "(" .. freeFlushCount .. "/" .. TaskData.GetTotalFreeUnionTaskCount() .. ")"
    self.updateCount:SetText(freeFlushCountStr)
  else
    self.shuaxin:SetActive(false)
    self.xiaohao:SetActive(true)
    local xiaoHaoNumStr = tonumber(TaskData.GetDiamondNumToUpdatePage())
    self.xiaoHaoNum:SetText(xiaoHaoNumStr)
  end
end

function WarAlliance_Task:AcceptableUnionTask(unionTaskId)
  if TaskData.canAcceptCount > 0 then
    local msg = {taskId = unionTaskId}
    NetManager.Send(TaskMessage.ReqAcceptUTask, msg)
  else
    local titleStr = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("UnionWord_7")
    UIManager.Show(UIID.PromptTipUI, {
      title = "Nh\225\186\175c nh\225\187\159",
      textContent = tostring(titleStr)
    })
  end
end

function WarAlliance_Task:ReceiveUnionTaskAward(unionTaskId)
  local msg = {taskId = unionTaskId}
  NetManager.Send(TaskMessage.ReqSubmitUTask, msg)
end

function WarAlliance_Task:AskUnionTaskHelp(unionTask)
  EventManager.Dispatch(Event.ClickAskHelp, unionTask)
end
