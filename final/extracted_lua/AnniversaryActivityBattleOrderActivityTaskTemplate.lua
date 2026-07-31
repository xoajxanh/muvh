local AnniversaryActivityBattleOrderActivityTaskTemplate = {}

function AnniversaryActivityBattleOrderActivityTaskTemplate:Init()
  self:InitControls()
  self:RegistUIEvents()
end

function AnniversaryActivityBattleOrderActivityTaskTemplate:InitControls()
  self.taskNum = self:GetControl("icoTask/taskNum")
  self.taskDecs = self:GetControl("tipTask/taskDecs")
  self.lab_CanNotGet = self:GetControl("go_state/lab_CanNotGet")
  self.lab_taskProgress = self:GetControl("go_state/lab_taskProgress")
  self.btn_get = self:GetControl("go_state/btn_get")
  self.Item_alreadyGet = self:GetControl("go_state/Item_alreadyGet")
end

function AnniversaryActivityBattleOrderActivityTaskTemplate:RegistUIEvents()
  self.lab_CanNotGet:SetOnClick(self, self.lab_CanNotGetOnClick)
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
end

function AnniversaryActivityBattleOrderActivityTaskTemplate:lab_CanNotGetOnClick()
  AnniversaryActivityController.GoTask(self.data)
end

function AnniversaryActivityBattleOrderActivityTaskTemplate:btn_getOnClick(control)
end

function AnniversaryActivityBattleOrderActivityTaskTemplate:Refresh(data, ui)
  self.data = data
  self.taskGoalData = AnniversaryActivity_BattleOrderData.GetBattleOrderTaskInfo(data.mission)
  self.goalInfo = data.goalInfo
  self.taskNum:SetText(data.reward and data.reward[2] or "")
  self.taskDecs:SetText(data.description or "")
  self.goalInfo = data.goalInfo
  if not self.goalInfo then
    return
  end
  local state = TaskStateEnum.CanNotGet
  if data.type ~= 5 and self.goalInfo.overTimes >= self.goalInfo.countTotal then
    state = TaskStateEnum.Got
  end
  self:SetTaskState(state)
end

function AnniversaryActivityBattleOrderActivityTaskTemplate:SetTaskState(state)
  self.lab_taskProgress:SetActive(state == TaskStateEnum.CanNotGet)
  self.lab_CanNotGet:SetActive(state == TaskStateEnum.CanNotGet and self.data.toFunction and self.data.toFunction ~= "")
  self.Item_alreadyGet:SetActive(state == TaskStateEnum.Got)
  if state == TaskStateEnum.CanNotGet then
    local str = ClientTable.cfg_Ui_wordManager:TryGetValue("ZhouNianQing_activitytask").content
    self.lab_taskProgress:SetText(string.format(str, self.goalInfo.overTimes))
  end
end

return AnniversaryActivityBattleOrderActivityTaskTemplate
