local CampPlayerInfo = {}
CampPlayerInfo._serverData = nil
CampPlayerInfo._inView = nil

function CampPlayerInfo:RefreshInfo(data)
  if data.id == nil then
    return
  end
  self._serverData = data
  self._inView = RoleManager.GetRoleById(data.id) ~= nil
end

function CampPlayerInfo:GetId()
  return self._serverData.id
end

function CampPlayerInfo:GetName()
  return self._serverData.name
end

function CampPlayerInfo:GetLevel()
  return self._serverData.level
end

function CampPlayerInfo:GetCareer()
  return self._serverData.career
end

function CampPlayerInfo:GetGroupId()
  return self._serverData.groupType
end

function CampPlayerInfo:GetKillNum()
  return self._serverData.killNum
end

function CampPlayerInfo:GetDieNum()
  return self._serverData.dieNum
end

function CampPlayerInfo:GetState()
  if self._serverData.status == EThreeVSThreePlayerState.OffLine then
    return EThreeVSThreePlayerState.OffLine
  end
  local reviveRemainTime = self:GetReviveRemainTime()
  if 0 < reviveRemainTime then
    return EThreeVSThreePlayerState.Die
  end
  if self._inView == false then
    return EThreeVSThreePlayerState.OutView
  end
  return EThreeVSThreePlayerState.ALive
end

function CampPlayerInfo:EnterView()
  self._inView = true
end

function CampPlayerInfo:ExitView()
  self._inView = false
end

function CampPlayerInfo:GetInView()
  return self._inView
end

function CampPlayerInfo:GetReviveRemainTime()
  return TimeUtility.GetRemainSecTime(self._serverData.reviveTime)
end

return CampPlayerInfo
