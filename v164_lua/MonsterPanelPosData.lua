MonsterPanelPosData = {}
local this = MonsterPanelPosData
local vipMapIndex = 100700
local vipMapIndexTwo = 101110

function MonsterPanelPosData.Sort(v, type)
  v.mapCount = this.shuffle(v.mapCount)
  table.sort(v.mapCount, function(a, b)
    local mapDataA = ClientTable.cfg_Map_mapManager:TryGetValue(a.mapId, "id")
    local mapDataB = ClientTable.cfg_Map_mapManager:TryGetValue(b.mapId, "id")
    local levelA = mapDataA.enterCondition[1][1][2]
    local levelB = mapDataB.enterCondition[1][1][2]
    a.index = mapDataA.index
    b.index = mapDataB.index
    a.level = levelA
    b.level = levelB
    if a.count == 0 or b.count == 0 then
      return a.count > b.count
    end
    if (a.index == vipMapIndex or vipMapIndexTwo or b.index == vipMapIndex or vipMapIndexTwo) and (not (a.index == vipMapIndex or vipMapIndexTwo) or b.index ~= vipMapIndex and not vipMapIndexTwo) then
      return a.index < b.index
    end
    if not type and (RoleManager.me.level < tonumber(levelA) or RoleManager.me.level < tonumber(levelB)) and (not (RoleManager.me.level < tonumber(levelA)) or not (RoleManager.me.level < tonumber(levelB))) then
      return a.level < b.level
    end
    if not type then
      return a.mapId < b.mapId
    end
  end)
end

function MonsterPanelPosData.shuffle(t)
  if type(t) ~= "table" then
    return
  end
  local tab = {}
  local index = 1
  while #t ~= 0 do
    local n = math.random(0, #t)
    if t[n] ~= nil then
      tab[index] = t[n]
      table.remove(t, n)
      index = index + 1
    end
  end
  return tab
end

function MonsterPanelPosData.MapSort(mapList)
  if mapList == nil then
    return
  end
  table.sort(mapList, function(a, b)
    if a.mapId == b.mapId then
      local aline = a.line % 3
      if aline == 0 then
        aline = 3
      end
      local bline = b.line % 3
      if bline == 0 then
        bline = 3
      end
      return aline < bline
    end
    return a.mapId < b.mapId
  end)
  local vipMapList = {}
  local normalMapListDic = {}
  local normalMapList = {}
  for i, v in pairs(mapList) do
    if v.mapTable ~= nil and v.mapTable.vipSign == 1 then
      table.insert(vipMapList, v)
    else
      if normalMapListDic[v.mapId] == nil then
        normalMapListDic[v.mapId] = {}
        table.insert(normalMapList, normalMapListDic[v.mapId])
      end
      table.insert(normalMapListDic[v.mapId], v)
    end
  end
  local sortList = {}
  local index = 0
  for i, v in pairs(normalMapList) do
    for inormal, vnormal in pairs(v) do
      table.insert(sortList, vnormal)
    end
    if index == 0 then
    end
    index = index + 1
  end
  for ivip, vvip in pairs(vipMapList) do
    table.insert(sortList, vvip)
  end
  return sortList
end

function MonsterPanelPosData.GetMonsterMapData(bossTbl)
  for i, v in pairs(SceneData.MonsterMapData) do
    if v.bossId == bossTbl.id then
      this.Sort(v)
      local num = 0
      for j = 1, table.count(v.mapCount) do
        if v.mapCount[j].index == vipMapIndex or v.mapCount[j].index == vipMapIndexTwo then
          num = j
          break
        end
      end
      if num ~= 0 and #v.mapCount > 3 then
        local data = v.mapCount[num]
        table.remove(v.mapCount, num)
        table.insert(v.mapCount, 4, data)
      end
      v.mapCount = this.MapSort(v.mapCount)
      return v.mapCount
    end
  end
  return nil
end
