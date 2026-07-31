local cfg_OnHook_Point_ListManager = {}

function cfg_OnHook_Point_ListManager:GetName()
  return "cfg_OnHook_Point_ListManager"
end

function cfg_OnHook_Point_ListManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_OnHook_Point_List")
  end
  return self.dic
end

setmetatable(cfg_OnHook_Point_ListManager, TableManagerBase)

function cfg_OnHook_Point_ListManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_OnHook_Point_ListManager:GetDicMatchWithSelfDefense(vipMapTbl)
  if table.isNullOrEmpty(vipMapTbl) then
    return nil, nil
  end
  local idList = {}
  for i, map in pairs(vipMapTbl) do
    local ids = string.split(map.onHookPointListId, "#")
    table.combine(idList, ids)
  end
  local greaterTbl = {}
  local lowerTbl = {}
  for i, v in pairs(self:GetDic()) do
    if table.contains(idList, tostring(v.id)) and v.isMemberPoint == 1 then
      if QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow) >= v.defenseBase then
        table.insert(greaterTbl, v)
      else
        table.insert(lowerTbl, v)
      end
    end
  end
  table.sort(greaterTbl, function(a, b)
    if a and b then
      if a.defenseBase == b.defenseBase then
        return a.id < b.id
      else
        return a.defenseBase < b.defenseBase
      end
    else
      return false
    end
  end)
  table.sort(lowerTbl, function(a, b)
    if a and b then
      if a.defenseBase == b.defenseBase then
        return a.id > b.id
      else
        return a.defenseBase > b.defenseBase
      end
    else
      return false
    end
  end)
  return table.remove(greaterTbl), table.remove(lowerTbl)
end

function cfg_OnHook_Point_ListManager:GetAllVipMapPointDic(vipMapTbl)
  if table.isNullOrEmpty(vipMapTbl) then
    return {}
  end
  local myDefense = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.monsterDamageAbsorptionShow)
  local tblByMap = {}
  for i, map in pairs(vipMapTbl) do
    if tblByMap[map.groupId] == nil then
      tblByMap[map.groupId] = {}
    end
    local ids = string.split(map.onHookPointListId, "#")
    for k, id in pairs(ids) do
      local dic = self:TryGetValue(tonumber(id), "id")
      local needDefense = dic and dic.defenseBase
      table.insert(tblByMap[map.groupId], {
        id = tonumber(id),
        dic = dic,
        needDefense = needDefense or 9999999999,
        enterConditionIsEnough = ConditionManager.Check4D(map.enterCondition),
        defenseBaseIsEnough = needDefense and myDefense >= needDefense or false
      })
    end
  end
  return tblByMap
end

function cfg_OnHook_Point_ListManager:GetSatisfyAndDissatisfactionDic(vipMapTbl)
  if table.isNullOrEmpty(vipMapTbl) then
    return nil, nil
  end
  local tblByMap = self:GetAllVipMapPointDic(vipMapTbl)
  if table.isNullOrEmpty(tblByMap) then
    return nil, nil
  end
  local curVipMap = ClientTable.cfg_Map_mapManager:GetVipMapTbl(SceneData.mapId)
  if table.isNullOrEmpty(curVipMap) then
    return nil, nil
  end
  table.sort(tblByMap[curVipMap.groupId], function(a, b)
    if a and b then
      if a.needDefense == b.needDefense then
        return a.id < b.id
      else
        return a.needDefense < b.needDefense
      end
    else
      return false
    end
  end)
  local count = table.count(tblByMap[curVipMap.groupId])
  local maxDefenseData = 0 < count and tblByMap[curVipMap.groupId][count] or nil
  local curId = maxDefenseData and maxDefenseData.id or 999999999
  local curNeedDefense = maxDefenseData and maxDefenseData.needDefense or 999999999
  if ConditionManager.Check4D(curVipMap.enterCondition) then
    local satisfyData, dissatisfactionData
    local curTbl = {}
    for i, mapData in pairs(tblByMap) do
      for j, idData in pairs(mapData) do
        if curNeedDefense <= idData.needDefense and idData.enterConditionIsEnough and idData.defenseBaseIsEnough then
          table.insert(curTbl, idData)
        end
      end
    end
    table.sort(curTbl, function(a, b)
      if a and b then
        if a.needDefense == b.needDefense then
          return a.id < b.id
        else
          return a.needDefense < b.needDefense
        end
      else
        return false
      end
    end)
    satisfyData = table.count(curTbl) > 0 and table.remove(curTbl).dic or nil
    local nextTbl = {}
    for i, mapData in pairs(tblByMap) do
      for j, idData in pairs(mapData) do
        if satisfyData then
          if idData.needDefense >= satisfyData.defenseBase and idData.id > satisfyData.id then
            table.insert(nextTbl, idData)
          end
        elseif curNeedDefense <= idData.needDefense and curId < idData.id then
          table.insert(nextTbl, idData)
        end
      end
    end
    table.sort(nextTbl, function(a, b)
      if a and b then
        if a.needDefense == b.needDefense then
          return a.id > b.id
        else
          return a.needDefense > b.needDefense
        end
      else
        return false
      end
    end)
    dissatisfactionData = table.count(nextTbl) > 0 and table.remove(nextTbl).dic or nil
    return satisfyData, dissatisfactionData
  else
    return self:GetDicMatchWithSelfDefense(vipMapTbl)
  end
  return nil, nil
end

return cfg_OnHook_Point_ListManager
