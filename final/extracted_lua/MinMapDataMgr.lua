local MinMapDataMgr = {}

function MinMapDataMgr:Init()
end

function MinMapDataMgr:RegistEvent()
end

function MinMapDataMgr:SetCurSelfMapInfo(_info, mapTransferDataTab)
  for key, v2 in ipairs(_info) do
    for i3, v3 in ipairs(mapTransferDataTab[v2.groupId]) do
      if v3.groupId == SceneData.groupId then
        self.mCurSelfMapKey = key
        self.mCurSelfMapInfo = _info
      end
    end
  end
end

function MinMapDataMgr:GetNextMapInfo()
  if self.mCurSelfMapInfo == nil or self.mCurSelfMapKey == 0 or self.mCurSelfMapKey == nil then
    return nil
  end
  local nextIndex
  if self.mCurSelfMapKey + 1 <= table.count(self.mCurSelfMapInfo) then
    nextIndex = self.mCurSelfMapKey + 1
  end
  local isMax = self.mCurSelfMapKey + 1 == table.count(self.mCurSelfMapInfo)
  if nextIndex == nil then
    return nil
  else
    return self.mCurSelfMapInfo[nextIndex], isMax
  end
end

return MinMapDataMgr
