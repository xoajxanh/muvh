local SceneOnHookPointDataManager = {}

function SceneOnHookPointDataManager:Init()
  self:InitPointDic()
end

function SceneOnHookPointDataManager:InitPointDic()
  self.AllPointDic = {}
  local dic = ClientTable.cfg_OnHook_OnLinePointManager:GetDic()
  for i, v in pairs(dic) do
    if self.AllPointDic[v.mapId] == nil then
      self.AllPointDic[v.mapId] = {}
    end
    local pointList = self:GetTablePosList(v)
    for i, p in pairs(pointList) do
      self.AllPointDic[v.mapId][p] = 1
    end
  end
end

function SceneOnHookPointDataManager:GetTablePosList(tbl)
  local pointList = {}
  if tbl == nil then
    return pointList
  end
  local posStr = string.split(tbl.position, "#")
  local centerX = 0
  local centerY = 0
  if #posStr == 2 then
    centerX = tonumber(posStr[1])
    centerY = tonumber(posStr[2])
  end
  local range = tbl.bornRange
  for i = -range, range do
    for j = -range, range do
      local nowPoint = self:HookPointChange(centerX + i, centerY + j)
      table.insert(pointList, nowPoint)
    end
  end
  return pointList
end

function SceneOnHookPointDataManager:IsHookPoint(x, y, mapID)
  if mapID == nil then
    mapID = SceneData.mapId
  end
  if self.AllPointDic == nil then
    return false
  end
  if self.AllPointDic[mapID] == nil then
    return false
  end
  local nowNumber = self:HookPointChange(x, y)
  if self.AllPointDic[mapID][nowNumber] ~= nil then
    return true
  end
  return false
end

function SceneOnHookPointDataManager:IsMainPlayerInTheOnHookPoint()
  if RoleManager.me == nil then
    return false
  end
  if RoleManager.me.cellPos == nil then
    return false
  end
  return self:IsHookPoint(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y, SceneData.mapId)
end

function SceneOnHookPointDataManager:HookPointChange(x, y)
  return x * 100000 + y
end

return SceneOnHookPointDataManager
