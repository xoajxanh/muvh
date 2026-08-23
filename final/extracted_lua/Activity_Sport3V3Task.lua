Activity_Sport3V3Task = class(BaseUI)
Activity_Sport3V3Task.layer = UILayer.Panel
Activity_Sport3V3Task.orderInLayer = 0
Activity_Sport3V3Task.hideType = UIHideType.WaitDestroy
Activity_Sport3V3Task.hideFunc = UIHideFunc.MoveOutOfScreen
Activity_Sport3V3Task.escClose = UIEscClose.DontClose

function Activity_Sport3V3Task:InitControls()
  self.subPanel = self:GetControl("panel/subPanel")
  self.tog_Task = self:GetControl("panel/subPanel/TaskTeamBar/tog_Task")
  self.TaskBackground = self:GetControl("panel/subPanel/TaskTeamBar/tog_Task/TaskBackground")
  self.TaskCheckmark = self:GetControl("panel/subPanel/TaskTeamBar/tog_Task/TaskBackground/TaskCheckmark")
  self.tog_Team = self:GetControl("panel/subPanel/TaskTeamBar/tog_Team")
  self.TaskPanel = self:GetControl("panel/subPanel/TaskPanel")
  self.Normal3v3Task = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task")
  self.lab_Task1Title = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task/lab_Task1Title")
  self.lab_Task1 = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task/lab_Task1")
  self.lab_numTask1 = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task/lab_Task1/lab_numTask1")
  self.lab_Task2Title = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task/lab_Task2Title")
  self.lab_Task2 = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task/lab_Task2")
  self.lab_numTask2 = self:GetControl("panel/subPanel/TaskPanel/Normal3v3Task/lab_Task2/lab_numTask2")
  self.NormalFIFATask = self:GetControl("panel/subPanel/TaskPanel/NormalFIFATask")
  self.Normal10v10Task = self:GetControl("panel/subPanel/TaskPanel/Normal10v10Task")
  self.lab_Task3Title = self:GetControl("panel/subPanel/TaskPanel/Normal10v10Task/lab_Task3Title")
  self.lab_Task3 = self:GetControl("panel/subPanel/TaskPanel/Normal10v10Task/lab_Task3")
  self.MemberPanel = self:GetControl("panel/subPanel/MemberPanel")
  self.Content_Members = self:GetControl("panel/subPanel/MemberPanel/sc_member/Viewport/Content_Members")
  self.btn_member = self:GetControl("panel/subPanel/MemberPanel/sc_member/Viewport/Content_Members/btn_member")
end

function Activity_Sport3V3Task:Init()
end

function Activity_Sport3V3Task:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Activity_Sport3V3Task:InitUI()
end

function Activity_Sport3V3Task:RegistUIEvents()
  self.btn_member:SetOnClick(self, self.btn_memberOnClick)
end

function Activity_Sport3V3Task:btn_memberOnClick(control)
end

function Activity_Sport3V3Task:OnShow()
  self:RegistEvents()
  self:Refresh()
end

function Activity_Sport3V3Task:RegistEvents()
  self:RegistEvent(Event.ThreeVSThreeTaskDataChange, self.Refresh, self)
end

function Activity_Sport3V3Task:Refresh()
  local data = QuickFind:GetThreeVsThreeDataMgr():GetThreeTask()
  self.lab_Task1:SetText(data[1].description)
  self.lab_numTask1:SetText(data[1].tblCount)
  self.lab_Task2:SetText(data[2].description)
  self.lab_numTask2:SetText(data[2].tblCount)
end

function Activity_Sport3V3Task:OnHide()
end

function Activity_Sport3V3Task:OnDestroy()
end
