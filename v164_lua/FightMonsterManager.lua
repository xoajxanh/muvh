FightMonsterManager = {}
local this = FightMonsterManager
FightTragetType = {
  FightId = enum(0),
  FightType = enum()
}
local sockMonster
local distance = 0
local dis = 0

function FightMonsterManager.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.OnReset()
end

function FightMonsterManager.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.OnReset)
end

function FightMonsterManager.RegistEvent()
end

function FightMonsterManager.OnReset()
  this.fightParameter = nil
  this.fightType = nil
  this.monsterList = {}
  sockMonster = nil
  distance = 0
  dis = 0
end

function FightMonsterManager.OnRetTraget(fightParameter)
  if this.fightParameter == fightParameter then
    this.OnReset()
  end
end

function FightMonsterManager.RemoveFightMonster(monster)
  for k, v in pairs(this.monsterList) do
    if monster == tonumber(v) then
      this.monsterList[k] = nil
    end
  end
end

function FightMonsterManager.SetFightMonster(fightType, monsterList, fightParameter)
  if fightType == nil or monsterList == nil then
    return
  end
  if fightType == this.fightType and this.fightParameter == fightParameter then
    return
  end
  this.OnReset()
  this.fightType = fightType
  this.monsterList = monsterList
  this.fightParameter = fightParameter
end

this.pathLength = 10

function FightMonsterManager.GetMonster()
  if this.fightType == nil or this.monsterList == nil then
    return false
  end
  if RoleManager.me ~= nil and RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster then
    if this.fightType == FightTragetType.FightId then
      for l, t in pairs(this.monsterList) do
        if RoleManager.me.TargetAvatar:GetConfigId() == tonumber(t) then
          return RoleManager.me.TargetAvatar
        end
      end
    end
    if this.fightType == FightTragetType.FightType then
      for l, t in pairs(this.monsterList) do
        if RoleManager.me.TargetAvatar.monsterType == tonumber(t) then
          return RoleManager.me.TargetAvatar
        end
      end
    end
  end
  if this.fightType == FightTragetType.FightId then
    for k, v in pairs(RoleManager.GetMonsterRoleByConfigId(this.monsterList, this.sockMonsterDis)) do
      if v ~= nil and RoleTargetManager.GetCanAttackRole(v) then
        local reachable, path, bestGuidePath = Scene.SearchTilePath(RoleManager.me.cellPos, v.cellPos, 0)
        if path ~= nil and #path <= this.pathLength then
          return v
        end
      end
    end
  end
  if this.fightType == FightTragetType.FightType then
    for k, v in pairs(RoleManager.GetMonsterByMonsterType(this.monsterList, this.sockMonsterDis)) do
      if v ~= nil and RoleTargetManager.GetCanAttackRole(v) then
        local reachable, path, bestGuidePath = Scene.SearchTilePath(RoleManager.me.cellPos, v.cellPos, 0)
        if path ~= nil and #path <= this.pathLength then
          return v
        end
      end
    end
  end
  return nil
end

this.sockMonsterDis = 6

function FightMonsterManager.GetCurSockMonster()
  if this.fightType == nil or this.monsterList == nil then
    return false
  end
  if RoleManager.me ~= nil and RoleManager.me.TargetAvatar ~= nil and RoleManager.me.TargetAvatar.RoleType == ERoleType.Monster then
    if this.fightType == FightTragetType.FightId then
      for l, t in pairs(this.monsterList) do
        if RoleManager.me.TargetAvatar:GetConfigId() == tonumber(t) then
          return RoleManager.me.TargetAvatar
        end
      end
    end
    if this.fightType == FightTragetType.FightType then
      for l, t in pairs(this.monsterList) do
        if RoleManager.me.TargetAvatar.monsterType == tonumber(t) then
          return RoleManager.me.TargetAvatar
        end
      end
    end
  end
  if this.fightType == FightTragetType.FightId then
    sockMonster = nil
    distance = 0
    for k, v in pairs(RoleManager.GetMonsterRoleByConfigId(this.monsterList, this.sockMonsterDis)) do
      if RoleTargetManager.GetCanAttackRole(v) then
        dis = Vector2Int.DistancePow(v.cellPos, RoleManager.me.cellPos)
        if sockMonster == nil and distance == 0 then
          distance = dis
          sockMonster = v
        elseif dis < distance then
          distance = dis
          sockMonster = v
        end
      end
    end
    return sockMonster
  end
  if this.fightType == FightTragetType.FightType then
    sockMonster = nil
    distance = 0
    for k, v in pairs(RoleManager.GetMonsterByMonsterType(this.monsterList, this.sockMonsterDis)) do
      if RoleTargetManager.GetCanAttackRole(v) then
        dis = Vector2Int.DistancePow(monsterList.cellPos, RoleManager.me.cellPos)
        if sockMonster == nil and distance == 0 then
          distance = dis
          sockMonster = v
        elseif dis < distance then
          distance = dis
          sockMonster = v
        end
      end
    end
    return sockMonster
  end
end

FightMonsterManager.Init()
