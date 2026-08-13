local ConnectionGiftOpenTipsUITemp = {}

function ConnectionGiftOpenTipsUITemp:Init()
  self:InitControls()
end

function ConnectionGiftOpenTipsUITemp:InitControls()
  self.taskLab_name = self:GetControl("lab_name")
  self.checkLab_name = self:GetControl("Check/lab_name")
  self.Check = self:GetControl("Check")
end

function ConnectionGiftOpenTipsUITemp:Refresh(data)
  self.data = data
  if not self.data then
    return
  end
  self:RefreshItemData(self.data)
end

function ConnectionGiftOpenTipsUITemp:RefreshItemData(data)
  self.Check:SetActive(false)
  if data then
    local Count = 0
    local count = 0
    local taskGoal = ClientTable.cfg_Task_goalManager:TryGetValue(tonumber(data.task), "goalId")
    Count = taskGoal.goalCount
    count = data.count
    if taskGoal.type == 1607 then
    end
    if data.isBol then
      self.taskLab_name:SetText("")
      self.Check:SetActive(data.isBol)
      self.checkLab_name:SetText(string.format(taskGoal.goalTips, Count))
    else
      self.taskLab_name:SetText(string.format(taskGoal.goalTips, count))
    end
  end
end

return ConnectionGiftOpenTipsUITemp
