local MapMonsterPointList = {}
MapMonsterPointList.MapPointList = nil
MapMonsterPointList.TotalMapPointList = nil
MapMonsterPointList.ListSaveCount = 15
MapMonsterPointList.LastAnalysisMapCache = nil

function MapMonsterPointList:AddMapMonsterPoint(mapId)
  if self.MapPointList == nil then
    self.MapPointList = {}
  end
  if self:AnalysisParams(mapId) == false then
    return
  end
  if self.MapPointList[mapId] ~= nil then
    return
  end
  if self.ListSaveCount ~= nil and table.count(self.MapPointList) >= self.ListSaveCount then
    self.MapPointList[next(self.MapPointList)] = nil
  end
  self.MapPointList[mapId] = {}
  local pointIdList = string.split(self.LastAnalysisMapCache.onHookPointListId, "#")
  if type(pointIdList) ~= "table" then
    return
  end
  local mapMonsterPoint
  for k, v in pairs(pointIdList) do
    mapMonsterPoint = LuaClass.MapMonsterPoint:New()
    mapMonsterPoint:RefreshData(tonumber(v), mapId)
    if mapMonsterPoint.AnalysisState then
      table.insert(self.MapPointList[mapId], mapMonsterPoint)
    end
  end
end

function MapMonsterPointList:AddTotalMapMonsterPoint(mapId)
  if self.TotalMapPointList == nil then
    self.TotalMapPointList = {}
  end
  if self:AnalysisParams(mapId) == false then
    return
  end
  if self.TotalMapPointList[mapId] ~= nil then
    return
  end
  if self.ListSaveCount ~= nil and table.count(self.TotalMapPointList) >= self.ListSaveCount then
    self.TotalMapPointList[next(self.MapPointList)] = nil
  end
  self.TotalMapPointList[mapId] = {}
  local vipPointIdList = string.split(self.LastAnalysisMapCache.memberPointListId, "#")
  if type(vipPointIdList) == "table" then
    local mapMonsterPoint
    for k, v in pairs(vipPointIdList) do
      mapMonsterPoint = LuaClass.MapMonsterPoint:New()
      mapMonsterPoint:RefreshData(tonumber(v), mapId)
      if mapMonsterPoint.AnalysisState then
        table.insert(self.TotalMapPointList[mapId], mapMonsterPoint)
      end
    end
  end
  local pointIdList = string.split(self.LastAnalysisMapCache.onHookPointListId, "#")
  if type(vipPointIdList) == "table" then
    local mapMonsterPoint
    for k, v in pairs(pointIdList) do
      mapMonsterPoint = LuaClass.MapMonsterPoint:New()
      mapMonsterPoint:RefreshData(tonumber(v), mapId)
      if mapMonsterPoint.AnalysisState then
        table.insert(self.TotalMapPointList[mapId], mapMonsterPoint)
      end
    end
  end
  table.sort(self.TotalMapPointList[mapId], function(l, r)
    if l == nil or r == nil then
      return false
    end
    if l.PointTbl == nil or r.PointTbl == nil then
      return false
    end
    return l.PointTbl.order < r.PointTbl.order
  end)
end

function MapMonsterPointList:AnalysisParams(mapId)
  if type(mapId) ~= "number" then
    return false
  end
  self.LastAnalysisMapCache = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
  if self.LastAnalysisMapCache == nil or string.isNullOrEmpty(self.LastAnalysisMapCache.onHookPointListId) then
    return false
  end
  return true
end

function MapMonsterPointList:GetMapMonsterPoint(mapId)
  if type(mapId) ~= "number" then
    return
  end
  if type(self.MapPointList) ~= "table" or self.MapPointList[mapId] == nil then
    self:AddMapMonsterPoint(mapId)
  end
  return self.MapPointList[mapId]
end

function MapMonsterPointList:GetTotalMapMonsterPoint(mapId)
  if type(mapId) ~= "number" then
    return
  end
  if type(self.TotalMapPointList) ~= "table" or self.TotalMapPointList[mapId] == nil then
    self:AddTotalMapMonsterPoint(mapId)
  end
  return self.TotalMapPointList[mapId]
end

function MapMonsterPointList:GetTitleName()
  return "Danh s\195\161ch qu\195\161i"
end

function MapMonsterPointList:GetRecommendMapMonsterPoint()
  local satisfyMapMonsterPointData, dissatisfactionMapMonsterPointData
  local allVipMapTbl = ClientTable.cfg_Map_mapManager:GetAllUsingVipMapWithOnHookPointListId()
  local satisfyOnHookPointTbl, dissatisfactionOnHookPointTbl = ClientTable.cfg_OnHook_Point_ListManager:GetSatisfyAndDissatisfactionDic(allVipMapTbl)
  satisfyMapMonsterPointData = self:CreatMapMonsterPointData(satisfyOnHookPointTbl)
  dissatisfactionMapMonsterPointData = self:CreatMapMonsterPointData(dissatisfactionOnHookPointTbl)
  return satisfyMapMonsterPointData, dissatisfactionMapMonsterPointData
end

function MapMonsterPointList:CreatMapMonsterPointData(onHookPointTbl)
  if table.isNullOrEmpty(onHookPointTbl) then
    return nil
  end
  local mapId = ClientTable.cfg_Map_transferManager:GetGroupIdByTransferId(onHookPointTbl.transferId)
  local mapMonsterPointData = LuaClass.MapMonsterPoint:New()
  mapMonsterPointData:RefreshData(onHookPointTbl.id, mapId)
  if mapMonsterPointData.AnalysisState then
    local cfg = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
    if cfg then
      mapMonsterPointData.customName = string.GetColorText(cfg.name, ConditionManager.Check4D(cfg.enterCondition) and "#3CD937" or "#FF2323")
    end
    return mapMonsterPointData
  end
  return nil
end

function MapMonsterPointList:CheckAllVipMapMonsterPointNeedDefenseIsLowerMyDefense(vipMapMonsterPoint)
  if table.isNullOrEmpty(vipMapMonsterPoint) then
    return false
  end
  local myDefense = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow)
  for i, v in pairs(vipMapMonsterPoint) do
    if myDefense < v.PointTbl.defenseBase then
      return false
    end
  end
  return true
end

function MapMonsterPointList:ShowRightMonsterList(mapId)
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(mapId)
  return mapTbl.orEliteBoss == 1
end

return MapMonsterPointList
