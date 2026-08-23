local cfg_Map_minimapManager = {}

function cfg_Map_minimapManager:GetName()
  return "cfg_Map_minimapManager"
end

function cfg_Map_minimapManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_minimap")
  end
  return self.dic
end

setmetatable(cfg_Map_minimapManager, TableManagerBase)

function cfg_Map_minimapManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

cfg_Map_minimapManager.MapPointTypeDic = nil

function cfg_Map_minimapManager:TryInitMapPointTypeDic()
  if self.MapPointTypeDic ~= nil then
    return self.MapPointTypeDic
  end
  self.MapPointTypeDic = {}
  local miniMapTblList = self:GetDic()
  if type(miniMapTblList) ~= "table" then
    return
  end
  local mapPointDic, pointList
  for k, v in pairs(miniMapTblList) do
    if self:IsCachePoint(v) then
      mapPointDic = self.MapPointTypeDic[v.type]
      if mapPointDic == nil then
        self.MapPointTypeDic[v.type] = {}
        mapPointDic = self.MapPointTypeDic[v.type]
      end
      pointList = mapPointDic[v.mid]
      if pointList == nil then
        mapPointDic[v.mid] = {}
        pointList = mapPointDic[v.mid]
      end
      table.insert(pointList, v)
    end
  end
end

function cfg_Map_minimapManager:IsCachePoint(pointTbl)
  if pointTbl.type == MapPointType.MonsterPoint then
    return pointTbl.guideShow == 0
  end
  return true
end

function cfg_Map_minimapManager:GetMonsterPointList(mapId)
  if type(mapId) ~= "number" then
    return
  end
  self:TryInitMapPointTypeDic()
  if type(self.MapPointTypeDic) ~= "table" or type(self.MapPointTypeDic[MapPointType.MonsterPoint]) ~= "table" then
    return
  end
  return self.MapPointTypeDic[MapPointType.MonsterPoint][mapId]
end

return cfg_Map_minimapManager
