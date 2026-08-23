local CampInfo = {}
CampInfo._playerList = nil
CampInfo._playerDic = nil
CampInfo.GroupId = nil
CampInfo.KillNum = nil

function CampInfo:RefreshInfo(data)
  if data.groupType == nil or data.playerInfo == nil then
    return
  end
  self:Destroy()
  self.KillNum = data.killCount or 0
  self.GroupId = data.groupType
  self._playerDic = {}
  self._playerList = {}
  for k, v in pairs(data.playerInfo) do
    local playerInfo = LuaClass.CampPlayerInfo:New()
    self._playerDic[v.id] = playerInfo
    playerInfo:RefreshInfo(v)
    table.insert(self._playerList, playerInfo)
  end
end

function CampInfo:RefreshPlayerInfo(data)
  if self._playerDic == nil or self._playerDic[data.id] == nil then
    return
  end
  self._playerDic[data.id]:RefreshInfo(data)
end

function CampInfo:GetPlayerInfo(id)
  return self._playerDic and self._playerDic[id]
end

function CampInfo:GetPlayerInfoList()
  return self._playerList
end

function CampInfo:IsContainMainPlayer()
  local playerInfo = self:GetPlayerInfo(RoleManager.me.id)
  return playerInfo ~= nil
end

function CampInfo:IsInPlayerList(id)
  return self:GetPlayerInfo(id) ~= nil
end

function CampInfo:Destroy()
  self.GroupId = nil
  self.KillNum = nil
  self._playerDic = nil
end

return CampInfo
