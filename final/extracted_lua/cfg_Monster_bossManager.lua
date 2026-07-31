local cfg_Monster_bossManager = {}

function cfg_Monster_bossManager:GetName()
  return "cfg_Monster_bossManager"
end

function cfg_Monster_bossManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_boss")
  end
  return self.dic
end

setmetatable(cfg_Monster_bossManager, TableManagerBase)

function cfg_Monster_bossManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Monster_bossManager:GetRecommendWildIndex(level, monsterTblList, isAngel)
  if level == nil then
    return
  end
  if self.wildRecommendLevel == level then
    return self.wildRecommendIndex, self.recommendMonsterBossTbl
  end
  local bossTypeList = monsterTblList
  if bossTypeList == nil then
    bossTypeList = MonsterData.GetMonsterBossType(MonsterBossType.wildBoss)
  end
  self.wildRecommendIndex = 1
  for k, v in pairs(bossTypeList) do
    if isAngel ~= nil and isAngel and self:AngelBossWildMonsterBossCanKill(v) == false then
      return self.wildRecommendIndex, self.recommendMonsterBossTbl
    end
    if self:WildMonsterBossCanKill(v) == false then
      return self.wildRecommendIndex, self.recommendMonsterBossTbl
    end
    self.wildRecommendIndex = k
    self.recommendMonsterBossTbl = v
  end
  return self.wildRecommendIndex, self.recommendMonsterBossTbl
end

function cfg_Monster_bossManager:GetArgsIndex(monsterTblList, monsterId)
  for k, v in pairs(monsterTblList) do
    if v.id == monsterId then
      return k, v
    end
  end
end

function cfg_Monster_bossManager:WildMonsterBossCanKill(monsterBossTbl)
  if monsterBossTbl == nil then
    return false
  end
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(monsterBossTbl.mapId)
  local levelRestrict = mapTbl.refertolevel
  if levelRestrict == nil then
    levelRestrict = mapTbl.enterCondition
  end
  if levelRestrict == nil or levelRestrict[1] == nil or type(levelRestrict[1][1]) ~= "table" or #levelRestrict[1][1] < 2 then
    return false
  end
  local conditionType = levelRestrict[1][1][1]
  local level = levelRestrict[1][1][2]
  if conditionType == 7001 then
    return ConditionManager.Check4D({
      {
        levelRestrict[1][1]
      }
    }), level, conditionType
  elseif conditionType == 101 then
    return ConditionManager.Check4D({
      {
        levelRestrict[1][1]
      }
    }), level, conditionType
  end
  return ConditionManager.Check4D(levelRestrict), level, conditionType
end

function cfg_Monster_bossManager:AngelBossWildMonsterBossCanKill(monsterBossTbl)
  if monsterBossTbl == nil then
    return false
  end
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(monsterBossTbl.mapId)
  local levelRestrict = mapTbl.refertolevel
  if levelRestrict == nil then
    levelRestrict = mapTbl.enterCondition
  end
  if levelRestrict == nil or levelRestrict[1] == nil or type(levelRestrict[1][1]) ~= "table" or #levelRestrict[1][1] < 2 then
    return false
  end
  local conditionType = levelRestrict[1][1][1]
  local level = levelRestrict[1][1][2]
  return ConditionManager.Check4D(levelRestrict), level, conditionType
end

return cfg_Monster_bossManager
