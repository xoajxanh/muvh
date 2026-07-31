local cfg_Map_mapManager = {}

function cfg_Map_mapManager:GetName()
  return "cfg_Map_mapManager"
end

function cfg_Map_mapManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_map")
  end
  return self.dic
end

setmetatable(cfg_Map_mapManager, TableManagerBase)

function cfg_Map_mapManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_mapManager:IsVipMap(_mapId)
  local mapIdStr = tostring(_mapId)
  local mapFlag = string.sub(mapIdStr, 1, 4)
  if MapTypeFlag.VIP == tonumber(mapFlag) then
    return true
  else
    return false
  end
end

function cfg_Map_mapManager:IsRecommendMemberMap(mapId)
  local mapTbl = self:TryGetValue(mapId)
  if mapTbl == nil or mapTbl.indexCondition == nil then
    return false
  end
  if string.isNullOrEmpty(mapTbl.indexCondition) then
    return true
  end
  return ConditionManager.Check(mapTbl.indexCondition)
end

function cfg_Map_mapManager:GetConditionParam(conditionCfg)
  local conditionTab = {
    paramLevelGEqual = 0,
    paramMemberLevelGreater = 0,
    paramMemberLevelEqual = 0
  }
  if type(conditionCfg) == "table" then
    local groupStr = conditionCfg
    for i = 1, #groupStr do
      local singleStrs = groupStr[i]
      for j = 1, #singleStrs do
        local singleCondition = singleStrs[j]
        local stype = tonumber(singleCondition[1])
        local param = singleCondition[2]
        if stype == EConditionEnum.levelGEqual then
          conditionTab.paramLevelGEqual = param
        elseif stype == EConditionEnum.memberLevelGreater then
          conditionTab.paramMemberLevelGreater = param
        elseif stype == EConditionEnum.memberLevelGEqual then
          conditionTab.paramMemberLevelEqual = param
        end
      end
    end
  end
  return conditionTab
end

function cfg_Map_mapManager:IsNowMapChangeHorseState(mapTable, nowMountId)
  if mapTable == nil or nowMountId == nil or tonumber(nowMountId) == nil then
    return false
  end
  local nowStr = string.split(mapTable.mountParameter, "#")
  if nowStr ~= nil then
    for i, v in pairs(nowStr) do
      if tonumber(nowMountId) == tonumber(v) then
        return true
      end
    end
  end
  return false
end

function cfg_Map_mapManager:CurMapIsVipMap(mapId)
  for i, v in pairs(self:GetDic()) do
    if v.id == mapId then
      return v.vipSign == 1
    end
  end
end

function cfg_Map_mapManager:GetAllUsingVipMapWithOnHookPointListId()
  local mapTbl = {}
  for i, v in pairs(self:GetDic()) do
    if v.vipSign == 1 and v.onHookPointListId ~= "" and v.creatmap == 0 then
      table.insert(mapTbl, v)
    end
  end
  table.sort(mapTbl, function(a, b)
    if a and b then
      return a.id < b.id
    else
      return false
    end
  end)
  return mapTbl
end

function cfg_Map_mapManager:GetVipMapTbl(mapId)
  if mapId == nil or type(mapId) ~= "number" then
    return nil
  end
  for i, dic in pairs(self:GetDic()) do
    if dic.id == mapId then
      if self:CurMapIsVipMap(mapId) then
        return dic
      else
        local mapTbl = self:TryGetValue(mapId, "id")
        local index = mapTbl and mapTbl.index
        for i, vipMap in pairs(self:GetAllUsingVipMapWithOnHookPointListId()) do
          if vipMap.index == index then
            return vipMap
          end
        end
      end
    end
  end
  return nil
end

return cfg_Map_mapManager
