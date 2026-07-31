local PrivilegeObject = {}
PrivilegeObject.serverData = nil

function PrivilegeObject:Refresh(data)
  self.serverData = data
end

function PrivilegeObject:GetStage()
  if self.serverData == nil then
    return false
  end
  return self.serverData.state == 1
end

function PrivilegeObject:GetRemainTime()
  if self.serverData == nil then
    return 0
  end
  if self.serverData.state == 1 then
    local remainTime = self.serverData.endTime - Time.GetServerTime()
    if remainTime < 0 then
      return 0
    else
      return remainTime
    end
  else
    return self.serverData.totalTime
  end
end

function PrivilegeObject:GetRemainTimeDes()
  if self.serverData == nil then
    return "00:00:00"
  end
  return TimeUtility.ShowTimeHour(self:GetRemainTime() * 0.001)
end

function PrivilegeObject:GetTimeSchedule(totalTime)
  return self:GetRemainTime() * totalTime
end

return PrivilegeObject
