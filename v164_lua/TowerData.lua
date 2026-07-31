TowerData = {}
local this = TowerData
local instanceTbl
local challengedFloor = 0
local challengedCountKey = 3020500
local taskId = 0

local function BossTableInforSet(item)
  local monsterBoss = ClientTable.cfg_Monster_bossManager:TryGetValue(item.mapId, "mapId")
  if not monsterBoss then
    return
  end
  local scaleStr = string.split(monsterBoss.scale, "#")
  item.modelScale = Vector3.right * tonumber(scaleStr[1]) + Vector3.up * tonumber(scaleStr[2]) + Vector3.forward * tonumber(scaleStr[3])
  scaleStr = string.replace(monsterBoss.position, "&", "")
  scaleStr = string.split(scaleStr, "#")
  item.localPos = Vector3.right * tonumber(scaleStr[1]) + Vector3.up * tonumber(scaleStr[2]) + Vector3.forward * tonumber(scaleStr[3] or 0)
  local MonsterTable = ConfigManager.FindConfigs("cfg_Monster_monster", "name", monsterBoss.name)
  if not MonsterTable then
  else
    item.bossModel = MonsterTable[1].model
  end
end

local function TransferInforSet(item)
  local transfer = ClientTable.cfg_Map_transferManager:TryGetValue(item.mapId, "groupId")
  if not transfer then
    logError("N\225\187\153i dung leo th\195\161p, b\225\186\163ng Map_transfer c\195\179 l\225\187\151i")
    return
  end
  item.transferId = transfer.id
  transfer = ClientTable.cfg_Map_mapManager:TryGetValue(transfer.groupId)
  if not transfer then
    logError("N\225\187\153i dung leo th\195\161p, b\225\186\163ng Map_map c\195\179 l\225\187\151i")
    return
  end
  local str = transfer.enterCondition
  if str == nil then
    logError("N\225\187\153i dung leo th\195\161p, Map_map >> tr\198\176\225\187\157ng enterCondition c\195\179 l\225\187\151i")
    return
  end
  str = str[1][#str[1] - 1]
  if str == nil then
    item.countKey = challengedCountKey + 100
    return
  end
  str = str[#str]
  str = str[1]
  item.countKey = tonumber(str)
end

local function BuildInforTable()
  local infors = {}
  for i = 1, #instanceTbl do
    local item = {}
    item.mapId = instanceTbl[i].mapId
    item.name = instanceTbl[i].name
    item.rewards = {}
    local rewardsBoxId = ConfigManager.FindConfigs("cfg_Box_box", "boxId", tonumber(instanceTbl[i].rewards))
    local index = 0
    for k, v in pairs(rewardsBoxId) do
      index = index + 1
      item.rewards[index] = {}
      item.rewards[index].itemId = tonumber(v.itemId)
      item.rewards[index].count = tonumber(v.count)
    end
    item.unique = instanceTbl[i].unique
    BossTableInforSet(item)
    TransferInforSet(item)
    table.insert(infors, item)
  end
  return infors
end

local displayFloor = 1

function TowerData:LoadTowerInstanceData()
  displayFloor = tonumber(GlobalConfig.GetGlobalConfig(3020501))
  instanceTbl = ConfigManager.FindConfigs("cfg_Map_instance", "type", 2205)
  instanceTbl = BuildInforTable()
  table.sort(instanceTbl, function(a, b)
    return a.mapId < b.mapId
  end)
  for i = 1, #instanceTbl do
    instanceTbl[i].floorIndex = i
  end
end

function TowerData:GetDisplayInfor()
  local inforTbl = {}
  if #instanceTbl == 0 then
    return
  end
  local currentFloor = 0
  for i = 1, #instanceTbl do
    local passed = RefreshData.GetInstanceCount(instanceTbl[i].countKey)
    if passed == 1 then
      currentFloor = i
      instanceTbl[i].passed = true
      break
    else
      instanceTbl[i].passed = false
    end
  end
  challengedFloor = currentFloor
  if currentFloor == 0 then
    for i = #instanceTbl, #instanceTbl - displayFloor + 1, -1 do
      table.insert(inforTbl, instanceTbl[i])
    end
    return inforTbl
  end
  if #instanceTbl <= displayFloor then
    return instanceTbl
  end
  if #instanceTbl - currentFloor < displayFloor then
    for i = #instanceTbl, #instanceTbl - displayFloor + 1, -1 do
      table.insert(inforTbl, instanceTbl[i])
    end
  else
    for i = currentFloor, currentFloor + displayFloor - 1 do
      table.insert(inforTbl, instanceTbl[i])
    end
  end
  return inforTbl
end

function TowerData:GetCurrentChallenged()
  return challengedFloor
end

function TowerData.SetCurrentTaskId(taskid)
  taskId = taskid
end

function TowerData.GetCurrentTaskId()
  return taskId
end

function TowerData.GetMaxFloorNum()
  return #instanceTbl
end

function TowerData:GetResidueChallengeCount()
  return RefreshData.GetInstanceCount(challengedCountKey)
end

local runningData

function TowerData:SetRunningInstanceData(data)
  runningData = data
end

function TowerData:GetRunningInstanceData()
  if not runningData then
    for i = 1, #instanceTbl do
      if instanceTbl[i].mapId == SceneData.mapId then
        runningData = instanceTbl[i]
      end
    end
  end
  if not runningData then
    return instanceTbl[1]
  end
  return runningData
end

function TowerData.GetDisplayCount()
  return displayFloor
end

function TowerData.GetInstanceInforByFloorIndex(index)
  return instanceTbl[index]
end

TowerData:LoadTowerInstanceData()
