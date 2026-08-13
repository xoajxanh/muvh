local ServerMonsterPointList = {}
ServerMonsterPointList.MonsterPointDic = nil

function ServerMonsterPointList:RefreshData(data)
  self.MonsterPointDic = {}
  if data == nil or type(data.bigIconMonsters) ~= "table" or next(data.bigIconMonsters) == nil then
    return
  end
  local analysisState, monsterTbl = false
  for k, v in pairs(data.bigIconMonsters) do
    if v ~= nil and v.configId ~= nil then
      monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(v.configId)
      if monsterTbl ~= nil then
        if self.MonsterPointDic[monsterTbl.type] == nil then
          self.MonsterPointDic[monsterTbl.type] = {}
        end
        if self.MonsterPointDic[monsterTbl.type][v.lid] == nil then
          self.MonsterPointDic[monsterTbl.type][v.lid] = LuaClass.ServerMonsterPoint:New()
        end
        self.MonsterPointDic[monsterTbl.type][v.lid]:RefreshData(v)
        if self.MonsterPointDic[monsterTbl.type][v.lid].analysisState then
          analysisState = true
        end
      end
    end
  end
  if analysisState then
    EventManager.Dispatch(Event.ServerMonsterPointChange)
  end
end

function ServerMonsterPointList:RefreshSingleData(data)
  if data == nil or data.lid == nil or type(self.MonsterPointDic) ~= "table" then
    return
  end
  local monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(data.configId)
  if monsterTbl == nil then
    return
  end
  if self.MonsterPointDic[monsterTbl.type] == nil then
    self.MonsterPointDic[monsterTbl.type] = {}
  end
  if self.MonsterPointDic[monsterTbl.type][data.lid] == nil then
    self.MonsterPointDic[monsterTbl.type][data.lid] = LuaClass.ServerMonsterPoint:New()
  end
  self.MonsterPointDic[monsterTbl.type][data.lid]:RefreshData(data)
  if self.MonsterPointDic[monsterTbl.type][data.lid].analysisState then
    EventManager.Dispatch(Event.ServerSingleMonsterPointChange, self.MonsterPointDic[monsterTbl.type][data.lid])
  end
end

function ServerMonsterPointList:GetMonsterPointListByMonsterType(monsterType)
  if monsterType == nil or self.MonsterPointDic == nil then
    return
  end
  return self.MonsterPointDic[monsterType]
end

function ServerMonsterPointList:GetMonsterPointListByMonsterTypeList(monsterTypeList)
  if type(monsterTypeList) ~= "table" then
    return
  end
  local monsterPointList = {}
  for k, v in pairs(monsterTypeList) do
    local pointList = self:GetMonsterPointListByMonsterType(v)
    if type(pointList) == "table" then
      table.merge(monsterPointList, pointList)
    end
  end
  return monsterPointList
end

function ServerMonsterPointList:GetMonsterPointListByMonsterTypeArea(minMonsterType, maxMonsterType)
  if type(minMonsterType) ~= "number" or type(maxMonsterType) ~= "number" then
    return
  end
  local monsterPointList = {}
  for k = minMonsterType, maxMonsterType do
    local pointList = self:GetMonsterPointListByMonsterType(k)
    if type(pointList) == "table" then
      table.merge(monsterPointList, pointList)
    end
  end
  return monsterPointList
end

return ServerMonsterPointList
