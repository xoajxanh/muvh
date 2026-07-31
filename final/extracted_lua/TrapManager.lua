require("GameConst/TrapTypeEnum")
require("GamePlay/Traps/Trap")
require("GamePlay/Traps/UnionFightTrap")
require("GamePlay/Traps/RedFortBuffTrap")
TrapManager = {}
local this = TrapManager
local test
local traps = {}

function TrapManager.Init()
  this.InitTrapRootGo()
end

function TrapManager.InitTrapRootGo()
  this.root = CS.UnityEngine.GameObject("TrapManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
end

function TrapManager.OnEnterGame()
  this.RegistEvents()
end

function TrapManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyTraps()
end

function TrapManager.Update()
  if traps then
    for _, v in pairs(traps) do
      if v then
        v:Update()
      end
    end
  end
end

function TrapManager.GetUnionFightData(trapData)
  local arrowDir = RoleManager.me.cellPos.y <= 114 and -1 or 1
  local cellPos = Vector2Int(trapData.x, trapData.y)
  local position = Scene.GetPosByCell(cellPos)
  local timeInterval = ClientTable.cfg_Map_trapManager:TryGetValue(trapData.configId, "id").typeParam
  local bombTime = trapData.createTime + timeInterval
  local arrowFlyDis = 30
  local speed = 20
  local flyTime = arrowFlyDis / speed
  local startZ = position.z + arrowFlyDis * arrowDir
  local startPos = Vector3(position.x, 9.5, startZ)
  local unionFightData = {
    arrowDir = arrowDir,
    bombTime = bombTime,
    flyTime = flyTime,
    startPos = startPos
  }
  return unionFightData
end

function TrapManager.CreateUnionFightTrap(trapData)
  if traps[trapData.id] then
    return
  end
  local unionFightData = this.GetUnionFightData(trapData)
  local trap = UnionFightTrap(trapData, unionFightData)
  traps[trapData.id] = trap
  return traps[trapData.id]
end

function TrapManager.CreateRedFortBuffTrap(trapData)
  if traps[trapData.id] then
    return
  end
  local trap = RedFortBuffTrap(trapData)
  traps[trapData.id] = trap
  return traps[trapData.id]
end

function TrapManager.DestroyTrap(id)
  local trap = traps[id]
  traps[id] = nil
  if trap then
    trap:Destroy()
    return true
  else
    return false
  end
end

function TrapManager.DestroyTraps()
  for k, v in pairs(traps) do
    v:Destroy()
  end
  traps = {}
end

function TrapManager.GetTrapId(trapId)
  return traps[trapId]
end

function TrapManager.GetTrapsByType(TrapType)
  local targetGroup = List:New()
  for _, v in pairs(traps) do
    if v and v.blockType == TrapType then
      targetGroup:Add(v)
    end
  end
  return targetGroup
end

function TrapManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Trap_OnTrapEnterView, this.OnTrapEnterView)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnTrapLeaveView)
end

function TrapManager.OnTrapEnterView(_, trapData)
  if trapData == nil then
    return
  end
  if trapData.trapType == TrapTypeEnum.UnionFight then
    this.CreateUnionFightTrap(trapData)
  elseif trapData.trapType == TrapTypeEnum.RedFortBuff then
    this.CreateRedFortBuffTrap(trapData)
  end
end

function TrapManager.SetTrap(_, trapTab)
  if trapTab == nil then
    return
  end
  for i, v in ipairs(trapTab) do
    this.OnTrapEnterView(_, v)
  end
end

function TrapManager.OnTrapLeaveView(_, trapData)
  if trapData == nil then
    return
  end
  this.DestroyTrap(trapData.id)
end

TrapManager.Init()
