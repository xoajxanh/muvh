local MapManager = {}

function MapManager:GetMapMonsterPointData()
  if self.mMapMonsterPointData == nil then
    self.mMapMonsterPointData = LuaClass.MapMonsterPointList:New()
  end
  return self.mMapMonsterPointData
end

function MapManager:GetMapTransferListData()
  if self.mMapTransferListData == nil then
    self.mMapTransferListData = LuaClass.MapTransferListData:New()
  end
  return self.mMapTransferListData
end

function MapManager:GetMapServerMonsterPoint()
  if self.mServerMonsterPointList == nil then
    self.mServerMonsterPointList = LuaClass.ServerMonsterPointList:New()
  end
  return self.mServerMonsterPointList
end

function MapManager:Logout()
  self:GetMapTransferListData():OnDestruct()
end

return MapManager
