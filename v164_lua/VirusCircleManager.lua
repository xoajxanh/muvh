local VirusCircleManager = {}
VirusCircleManager.VirusCircleBaseParams = nil
VirusCircleManager.IsInActivity = false

function VirusCircleManager:GetVirusCircle_Scene()
  if self.mVirusCircle_Scene == nil then
    self.mVirusCircle_Scene = LuaClass.VirusCircle_Scene:New()
  end
  return self.mVirusCircle_Scene
end

function VirusCircleManager:GetVirusCircle_MiniMap()
  if self.mVirusCircle_MiniMap == nil then
    self.mVirusCircle_MiniMap = LuaClass.VirusCircle_MiniMap:New()
  end
  return self.mVirusCircle_MiniMap
end

function VirusCircleManager:ChangeVirusCircle(serverData)
  if self:AnalysisServerData(serverData) == false then
    return
  end
  self:GetVirusCircle_Scene():ChangeVirusCircleByServer(self.VirusCircleBaseParams)
  self:GetVirusCircle_MiniMap():ChangeMiniMapVirusCircle(self.VirusCircleBaseParams)
end

function VirusCircleManager:AnalysisServerData(serverData)
  if serverData == nil or serverData.afterPoint == nil or serverData.width == nil or self.VirusCircleBaseParams ~= nil and self.VirusCircleBaseParams.width ~= nil and serverData.width >= self.VirusCircleBaseParams.width then
    return false
  end
  self.VirusCircleBaseParams = {}
  self.VirusCircleBaseParams.serverData = serverData
  self.VirusCircleBaseParams.lastCenterPoint = Vector2(serverData.beforePoint.X, serverData.beforePoint.Y)
  self.VirusCircleBaseParams.centerPoint = Vector2(serverData.afterPoint.X, serverData.afterPoint.Y)
  self.VirusCircleBaseParams.centerWorldPoint = Scene.GetPosByCell({
    x = serverData.afterPoint.X,
    y = serverData.afterPoint.Y
  })
  self.VirusCircleBaseParams.width = serverData.width
  self.VirusCircleBaseParams.changeStartTime = serverData.shrinkLoopStartTime
  self.VirusCircleBaseParams.changeEndTime = serverData.shrinkLoopEndTime
  self.VirusCircleBaseParams.lastWidth = serverData.beforeWidth
  if serverData.shrinkLoopStartTime ~= nil and serverData.shrinkLoopEndTime ~= nil then
    self.VirusCircleBaseParams.totalTime = serverData.shrinkLoopEndTime - serverData.shrinkLoopStartTime
  end
  if serverData.width ~= nil and serverData.beforeWidth ~= nil then
    self.VirusCircleBaseParams.widthOffset = serverData.beforeWidth - serverData.width
  end
  if serverData.beforePoint.X ~= nil and serverData.afterPoint.X ~= nil then
    self.VirusCircleBaseParams.pointOffset = self.VirusCircleBaseParams.lastCenterPoint - self.VirusCircleBaseParams.centerPoint
  end
  self.IsInActivity = true
  return true
end

function VirusCircleManager:GetDirAndDisByMainPlayerPoint()
  return VirusCircleManager.GetDirAndDisByPoint(self.VirusCircleBaseParams, RoleManager.me.cellPos)
end

function VirusCircleManager.IsLerpCirle(virusCircleBaseParams)
  return virusCircleBaseParams.lastCenterPoint ~= nil and virusCircleBaseParams.lastWidth ~= nil and virusCircleBaseParams.changeStartTime ~= nil and virusCircleBaseParams.changeEndTime ~= nil and virusCircleBaseParams.changeEndTime > Time.GetServerTime()
end

function VirusCircleManager.GetRemainTime(virusCircleBaseParams)
  return (virusCircleBaseParams.changeEndTime - Time.GetServerTime()) * 0.001
end

function VirusCircleManager.GetLerpRatio(virusCircleBaseParams)
  if virusCircleBaseParams.changeEndTime == nil or virusCircleBaseParams.totalTime == nil then
    return 1
  end
  if virusCircleBaseParams.changeEndTime < Time.GetServerTime() then
    return 0
  end
  return (virusCircleBaseParams.changeEndTime - Time.GetServerTime()) / virusCircleBaseParams.totalTime
end

function VirusCircleManager.GetLerpStartPoint(virusCircleBaseParams)
  local ratio = VirusCircleManager.GetLerpRatio(virusCircleBaseParams)
  local offsetVector = {x = 0, y = 0}
  if virusCircleBaseParams.pointOffset ~= nil then
    offsetVector = virusCircleBaseParams.pointOffset * ratio
  end
  return Vector2(virusCircleBaseParams.centerPoint.x + offsetVector.x, virusCircleBaseParams.centerPoint.y + offsetVector.y)
end

function VirusCircleManager.GetLerpStartWidth(virusCircleBaseParams)
  local ratio = VirusCircleManager.GetLerpRatio(virusCircleBaseParams)
  local offsetValue = 0
  if virusCircleBaseParams.widthOffset ~= nil then
    offsetValue = virusCircleBaseParams.widthOffset * ratio
  end
  return virusCircleBaseParams.width + offsetValue
end

function VirusCircleManager.GetMinAndMaxPoint(virusCircleBaseParams)
  local curCenterPoint = VirusCircleManager.GetLerpStartPoint(virusCircleBaseParams)
  local width = VirusCircleManager.GetLerpStartWidth(virusCircleBaseParams)
  local widthOver2 = width * 0.5
  return Vector2(curCenterPoint.x - widthOver2, curCenterPoint.y - widthOver2), Vector2(curCenterPoint.x + widthOver2, curCenterPoint.y + widthOver2)
end

function VirusCircleManager.GetNearestBorder(virusCircleBaseParams, point)
  local minPoint, maxPoint = VirusCircleManager.GetMinAndMaxPoint(virusCircleBaseParams)
  if point.x >= minPoint.x and point.x <= maxPoint.x and point.y >= minPoint.y and point.y <= maxPoint.y then
    return
  end
  local curX, curY
  if point.x < minPoint.x then
    curX = minPoint.x
  elseif point.x > maxPoint.x then
    curX = maxPoint.x
  else
    curX = point.x
  end
  if point.y < minPoint.y then
    curY = minPoint.y
  elseif point.y > maxPoint.y then
    curY = maxPoint.y
  else
    curY = point.y
  end
  return Vector2(curX, curY)
end

function VirusCircleManager.GetDirAndDisByPoint(virusCircleBaseParams, point)
  local nearestBorder = VirusCircleManager.GetNearestBorder(virusCircleBaseParams, point)
  if nearestBorder == nil then
    return
  end
  local distance = Vector2.Distance(nearestBorder, point)
  local directNormal = Vector2.Normalize(nearestBorder - point)
  local angle = Vector2.Angle(Vector2(0, 0), directNormal)
  return distance, angle
end

function VirusCircleManager:Remove()
  self:GetVirusCircle_Scene():RemoveVirusCircle()
  self:GetVirusCircle_MiniMap():Exit()
  self.VirusCircleBaseParams = nil
  self.IsInActivity = false
end

return VirusCircleManager
