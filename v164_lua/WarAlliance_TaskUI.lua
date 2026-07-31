WarAlliance_TaskUI = class(BaseUI)
WarAlliance_TaskUI.layer = UILayer.Panel
WarAlliance_TaskUI.orderInLayer = 2
WarAlliance_TaskUI.hideType = UIHideType.Destroy
WarAlliance_TaskUI.hideFunc = UIHideFunc.MoveOutOfScreen
WarAlliance_TaskUI.escClose = UIEscClose.DontClose

function WarAlliance_TaskUI:InitControls()
  self.btn_closeBg = self:GetControl("btn_closeBg")
  self.CloseBtn = self:GetControl("bg/backbg/CloseBtn")
  self.descBtn = self:GetControl("descBtn")
  self.lab_refresh = self:GetControl("Counts/lab_refresh")
  self.task_item = self:GetControl("Scroll View/Viewport/Content/task_item")
end

function WarAlliance_TaskUI:OnPreLoad()
end

function WarAlliance_TaskUI:Init()
end

function WarAlliance_TaskUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function WarAlliance_TaskUI:InitUI()
  self:InitContent()
end

function WarAlliance_TaskUI:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function WarAlliance_TaskUI:OnHide()
end

function WarAlliance_TaskUI:OnDestroy()
end

function WarAlliance_TaskUI:RegistUIEvents()
  self.btn_closeBg:SetOnClick(self, self.CloseBtnOnClick)
  self.CloseBtn:SetOnClick(self, self.CloseBtnOnClick)
  self.descBtn:SetOnClick(self, self.descBtnOnClick)
end

function WarAlliance_TaskUI:CloseBtnOnClick(control)
  UIManager.Hide(UIID.WarAlliance_TaskUI)
end

function WarAlliance_TaskUI:descBtnOnClick(control)
  local lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "WarAlliance_TaskUI")
  UIManager.Show(UIID.System_DescUI, {
    id = lvCfg[1].id
  })
end

function WarAlliance_TaskUI:btn_goOnClick(controls)
  local data = controls.data
  TaskManager.UnionCommonTaskGo(data)
end

function WarAlliance_TaskUI:btn_rewardOnClick(controls)
  local data = controls.data
  NetManager.Send(TaskMessage.ReqSubmitUTask, {
    taskId = data:GetId(),
    type = WarAllianceTaskType.Common
  })
end

local function showOnlyControl(controls, control)
  for index, value in ipairs(controls) do
    value:SetActive(control == value)
  end
end

local function icon_itemOnCreate(ctr)
  ctr.item = UIControl(ctr.transform)
end

local function icon_itemOnRefresh(ctr, _, data, this)
  local itemId = data.id
  local itemCnt = data.cnt
  local itemData = ItemUtility.GenerateItemData(itemId)
  itemData.count = itemCnt
  local cellData = ItemCellData()
  cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.item, cellData, self, true)
end

local function task_itemOnCreate(ctr)
  ctr.lab_TaskDes = UIControl(ctr.transform, "lab_TaskDes")
  ctr.lab_TaskProgress = UIControl(ctr.transform, "lab_TaskProgress")
  ctr.btn_go = UIControl(ctr.transform, "btn_go")
  ctr.btn_reward = UIControl(ctr.transform, "btn_reward")
  ctr.btn_notreward = UIControl(ctr.transform, "btn_notreward")
  ctr.icon_item = UIControl(ctr.transform, "itemContent/icon_item")
  ctr.icon_itemTemp = UIContainer(ctr.icon_item, self, icon_itemOnCreate, icon_itemOnRefresh)
  ctr.exp_item = UIControl(ctr.transform, "exp_item")
end

local function task_itemOnRefresh(ctr, _, data, this)
  local gola = data.goals[1]
  local btns = {
    ctr.btn_go,
    ctr.btn_reward,
    ctr.btn_notreward
  }
  if data:GetState() == TaskStateType.Accept then
    showOnlyControl(btns, ctr.btn_go)
  elseif data:GetState() == TaskStateType.Completed then
    if TaskData.GetUnionCommonTaskCount(data:GetId()) > 0 then
      showOnlyControl(btns, ctr.btn_notreward)
    else
      showOnlyControl(btns, ctr.btn_reward)
    end
  end
  ctr.btn_go.data = data
  ctr.btn_go:SetOnClick(this, this.btn_goOnClick)
  ctr.btn_reward.data = data
  ctr.btn_reward:SetOnClick(this, this.btn_rewardOnClick)
  ctr.lab_TaskDes:SetText(data:GetUnionTaskTitle())
  local currentCount = gola:GetCurFinishCount()
  local targetCount = gola:GetCount()
  local progressColor = currentCount >= targetCount and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[7]
  local progressText = string.format("%s/%d", string.GetColorText(currentCount, progressColor), targetCount)
  ctr.lab_TaskProgress:SetText(progressText)
  local rewards = data:GetRewards()
  local arr = {}
  for key, value in pairs(rewards) do
    table.insert(arr, {id = key, cnt = value})
  end
  ctr.icon_itemTemp:SetData(arr)
  local itemId = 1000060
  local itemCnt = data:GetUnionExp()
  local itemData = ItemUtility.GenerateItemData(itemId)
  itemData.count = itemCnt
  local cellData = ItemCellData()
  cellData:RefreshData(itemData)
  ItemUtility.ShowItemCell(ctr.exp_item, cellData, self, true)
end

function WarAlliance_TaskUI:RegistEvents()
  self:RegistEvent(Event.WarAllianceCommonTask_Update, self.RefreshCommonTask, self)
  self:RegistEvent(Event.TaskCount_Update, self.RefreshCommonTask, self)
end

function WarAlliance_TaskUI:InitContent()
  self.task_itemTemp = UIContainer(self.task_item, self, task_itemOnCreate, task_itemOnRefresh)
end

function WarAlliance_TaskUI:Refresh()
  self:RefreshCommonTask()
end

function WarAlliance_TaskUI:RefreshCommonTask()
  local data = TaskData.unionCommonTask
  self.task_itemTemp:SetData(data)
  self:StartCountDownTimer()
end

function WarAlliance_TaskUI:RefreshTimerText(offset)
  if offset == nil then
    local time = TaskData.unionCommonTaskTime
    if time == nil then
      return
    end
    offset = math.floor((time - Time.GetServerTime()) / 1000)
  end
  local text = TimeUtility.ShowDayTime(offset)
  self.lab_refresh:SetText(string.format("C\195\161ch th\225\187\157i gian l\195\160m m\225\187\155i\n %s ", string.GetColorText(text, ItemQuality2ColorDic[7])))
end

function WarAlliance_TaskUI:OnCountDownTimer()
  local time = TaskData.unionCommonTaskTime
  if time == nil then
    return
  end
  local offset = math.floor((time - Time.GetServerTime()) / 1000)
  self:RefreshTimerText(offset)
  if offset <= 0 then
    self:CloseCountDownTimer()
  end
end

function WarAlliance_TaskUI:StartCountDownTimer()
  self:CloseCountDownTimer()
  self:RefreshTimerText()
  self.countDownTimer = Timer.StartLoopForever(1, self.OnCountDownTimer, self)
end

function WarAlliance_TaskUI:CloseCountDownTimer()
  if self.countDownTimer ~= nil then
    Timer.Stop(self.countDownTimer)
    self.countDownTimer = nil
  end
end
