local WarOrderPassTaskTemplate = {}

function WarOrderPassTaskTemplate:Init(rootUI)
  self:InitControls(rootUI)
end

function WarOrderPassTaskTemplate:InitControls(rootUI)
  self.rootUI = rootUI
  self.nowControl = self:GetControl()
  self.taskNum = self:GetControl("icoTask/taskNum")
  self.taskDecs = self:GetControl("tipTask/taskDecs")
  self.lab_taskProgress = self:GetControl("go_state/lab_taskProgress")
end

function WarOrderPassTaskTemplate:Refresh(data, ui)
  if data.getExp then
    self.taskNum:SetText(tostring(data.getExp))
  end
  local isFinish = false
  if data.finishTimes and data.totalTimes then
    local text = ""
    if data.finishTimes < data.totalTimes then
      text = "C\195\179 th\225\187\131 ho\195\160n th\195\160nh (%s/%s)"
    else
      text = "\196\144\195\163 ho\195\160n th\195\160nh (%s/%s)"
      isFinish = true
    end
    text = string.format(text, tostring(data.finishTimes), tostring(data.totalTimes))
    self.lab_taskProgress:SetText(text)
  end
  if data.des and data.curCount and data.totalCount then
    local text = "%s(%s/%s)"
    if isFinish then
      text = string.format(text, data.des, tostring(data.totalCount), tostring(data.totalCount))
    else
      text = string.format(text, data.des, tostring(data.curCount), tostring(data.totalCount))
    end
    self.taskDecs:SetText(text)
  end
end

return WarOrderPassTaskTemplate
