MapMonster = {}
local this = MapMonster
local sockMonster
local distance = 0
local monsterInfo
local checkPoint = Vector2Int(0, 0)
local dis = 0

function MapMonster.Init()
  sockMonster = nil
  distance = 0
  monsterInfo = nil
  checkPoint = Vector2Int(0, 0)
  dis = 0
end

this.pathLength = 10
this.sockMonsterDis = 6
this.monsterType = {2002, 2001}

function MapMonster.GetMonster()
  if RoleManager.me ~= nil and RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster and (RoleManager.me.TargetAvatar.monsterType == 2002 or RoleManager.me.TargetAvatar.monsterType == 2001) then
    return RoleManager.me.TargetAvatar
  end
  sockMonster = nil
  for k, v in pairs(RoleManager.GetMonsterByMonsterType(this.monsterType, this.sockMonsterDis)) do
    if v ~= nil and RoleTargetManager.GetCanAttackRole(v) then
      local reachable, path, bestGuidePath = Scene.SearchTilePath(RoleManager.me.cellPos, v.cellPos, 0)
      if path ~= nil and #path <= this.pathLength then
        return v
      end
    end
  end
  return sockMonster
end

function MapMonster.FindMonsterData()
  distance = 0
  monsterInfo = SceneData.GetCurrentMapMonActiveData()
  if monsterInfo == nil then
    return nil
  end
  sockMonster = nil
  for k, v in pairs(monsterInfo) do
    if v ~= nil then
      checkPoint:Set(v.x, v.y)
      dis = Vector2Int.DistancePow(checkPoint, RoleManager.me.cellPos)
      if distance == 0 then
        distance = dis
        sockMonster = v
      elseif distance > dis then
        distance = dis
        sockMonster = v
      end
    end
  end
  return sockMonster
end

MapMonster.Init()
