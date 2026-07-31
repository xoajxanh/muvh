local AnniversaryActivityNpcActivityTaskTemplate = {}

function AnniversaryActivityNpcActivityTaskTemplate:Init()
  self:InitControls()
  self:RegistUIEvents()
end

function AnniversaryActivityNpcActivityTaskTemplate:InitControls()
  self.lab_task = self:GetControl("Img_bg/lab_task")
  self.lab_taskProgress = self:GetControl("Img_bg/Btn_group/lab_taskProgress")
  self.btn_go = self:GetControl("Img_bg/Btn_group/btn_go")
  self.btn_get = self:GetControl("Img_bg/Btn_group/btn_get")
  self.img_got = self:GetControl("Img_bg/Btn_group/img_got")
  self.lab_exp = self:GetControl("Img_bg/img_icon/lab_exp")
end

function AnniversaryActivityNpcActivityTaskTemplate:RegistUIEvents()
  self.btn_go:SetOnClick(self, self.btn_goOnClick)
  self.btn_get:SetOnClick(self, self.btn_getOnClick)
end

function AnniversaryActivityNpcActivityTaskTemplate:btn_goOnClick(control)
  AnniversaryActivityController.GoTask(self.data)
end

function AnniversaryActivityNpcActivityTaskTemplate:btn_getOnClick(control)
end

function AnniversaryActivityNpcActivityTaskTemplate:Refresh(data, ui)
  self.data = data
  self.taskGoalData = AnniversaryActivity_NPCActivityData.GetNpcActivityTaskGoalData(data.mission)
  self.lab_exp:SetText(data.reward[2])
  self.goalInfo = data.goalInfo
  if not self.goalInfo then
    return
  end
  local state = TaskStateEnum.CanNotGet
  if self.goalInfo.overTimes >= self.goalInfo.countTotal then
    state = TaskStateEnum.Got
  end
  self:SetTaskState(state)
end

function AnniversaryActivityNpcActivityTaskTemplate:SetTaskState(state)
  self.btn_go:SetActive(state == TaskStateEnum.CanNotGet and self.data.toFunction and self.data.toFunction ~= "")
  self.btn_get:SetActive(state == TaskStateEnum.CanGet)
  self.img_got:SetActive(state == TaskStateEnum.Got)
  if self.data.description then
    if state == TaskStateEnum.CanNotGet then
      self.lab_task:SetText(self.data.description .. " " .. self.goalInfo.current .. "/" .. self.goalInfo.count)
    else
      self.lab_task:SetText(self.data.description)
    end
  else
    self.lab_task:SetText("")
  end
end

return AnniversaryActivityNpcActivityTaskTemplate
