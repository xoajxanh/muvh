local SurrenderData = {}
SurrenderData._serverData = nil

function SurrenderData:Refresh(data)
  if data.sum == nil then
    return
  end
  self._serverData = data
  if self:GetRemainTimeRatio() > 0 then
    EventManager.Dispatch(Event.ThreeVSThreeSurrenderDataChange, self)
  end
end

function SurrenderData:GetTotalPlayer()
  if self._serverData == nil then
    return 0
  end
  return self._serverData.sum
end

function SurrenderData:GetVoteResult()
  if self._serverData == nil then
    return {}
  end
  return self._serverData.vote
end

function SurrenderData:GetRemainTimeRatio()
  if self._serverData == nil or self._serverData.endTime == nil then
    return 0
  end
  local overTotalTime = ClientTable.cfg_Activity_globalManager:GetOverThreeVSThreeSurrenderPanelTotalTime()
  local remainTime = TimeUtility.GetRemainSecTime(self._serverData.endTime)
  return overTotalTime * remainTime
end

function SurrenderData:MainPlayerCanVote()
  if self._serverData == nil then
    return false
  end
  if self._serverData.rids == nil then
    return true
  end
  for k, v in pairs(self._serverData.rids) do
    if v == RoleManager.me.id then
      return false
    end
  end
  return true
end

function SurrenderData:IsInSurrenderTime()
  return self:GetRemainTimeRatio() > 0
end

return SurrenderData
