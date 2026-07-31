local SceneOnPlayerPointDataManager = {}

function SceneOnPlayerPointDataManager:GetMiniSpecialPointTbl()
  if self.mSpecialPointTbl == nil then
    self.mSpecialPointTbl = {}
  end
  return self.mSpecialPointTbl
end

function SceneOnPlayerPointDataManager:Init()
end

function SceneOnPlayerPointDataManager:InitParam()
end

function SceneOnPlayerPointDataManager:BindEventMsg()
end

function SceneOnPlayerPointDataManager:RefreshTeamMemberData(data)
  self:GetMiniSpecialPointTbl()[EMapPointType.Team] = {}
  if data and data.teamMatePosition then
    for i, v in pairs(data.teamMatePosition) do
      self:TrySetPointInfo(i, EMapPointType.Team, v)
    end
  end
  EventManager.Dispatch(Event.UniversalPointDataChanged, EMapPointType.Team)
end

function SceneOnPlayerPointDataManager:RefreshUniversalData(data)
  if data == nil then
    return
  end
  local isChange = false
  local result = false
  self:GetMiniSpecialPointTbl()[data.type] = {}
  for i, v in pairs(data.specialOjbectPosition) do
    result = self:TrySetPointInfo(i, data.type, v)
    if not isChange and result then
      isChange = result
    end
  end
  if isChange then
    EventManager.Dispatch(Event.UniversalPointDataChanged, data.type)
  end
end

function SceneOnPlayerPointDataManager:TrySetPointInfo(index, type, pointData)
  if RoleManager.me == nil or pointData and pointData.roleId == RoleManager.me.id then
    return false
  end
  local copyPoint = {}
  copyPoint.point = pointData
  copyPoint.type = type
  self:SavePointInfo(index, copyPoint)
  return true
end

function SceneOnPlayerPointDataManager:SavePointInfo(index, pointData)
  if pointData.type == nil then
    return
  end
  local indexIsNil = self:GetMiniSpecialPointTbl()[pointData.type][index] == nil
  local targetPointData
  if indexIsNil then
    targetPointData = self:NewMiniPointInfo()
  else
    targetPointData = self:GetMiniSpecialPointTbl()[pointData.type][index]
  end
  targetPointData.X = pointData.point.X
  targetPointData.Y = pointData.point.Y
  targetPointData.type = pointData.type
  targetPointData.name = pointData.point.name
  if indexIsNil then
    table.insert(self:GetMiniSpecialPointTbl()[pointData.type], targetPointData)
  end
end

function SceneOnPlayerPointDataManager:ReqMapUniversalPointCallBack()
  self:ClearUniversalData()
  for i, v in pairs(EMapPointType) do
    if self:IsNeedReq(v) then
      networkRequest.ReqSpecialOjbectPosition(v)
    end
  end
end

function SceneOnPlayerPointDataManager:NewMiniPointInfo()
  local temp = {}
  temp.name = ""
  temp.X = 0
  temp.Y = 0
  temp.type = EMapPointType.None
  return temp
end

function SceneOnPlayerPointDataManager:ClearUniversalData()
  self.mSpecialPointTbl = nil
end

function SceneOnPlayerPointDataManager:IsNeedReq(type)
  return type ~= EMapPointType.Team
end

function SceneOnPlayerPointDataManager:IsShowDetailMap(type)
  return true
end

return SceneOnPlayerPointDataManager
