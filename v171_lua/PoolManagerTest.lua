require("GameConst/PoolConfig")
require("GamePlay/PoolManager/SpawnPool")
PoolManagerTest = {}
PoolManagerTest.root = nil
local this = PoolManagerTest
local spawnPoolMap = {}

function PoolManagerTest.Init()
  this.root = CS.UnityEngine.GameObject("PoolManagerTest").transform
  this.root.position = Vector3(-10000, -10000, -10000)
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
  EventManager.Regist(Event.Game_Restart, this.Destroy)
end

local function CreatePrefabPool(modelType, prefabName)
  local prefabData = PoolConfig[modelType]
  local spawnPool = spawnPoolMap[prefabData.poolName]
  if not spawnPool then
    spawnPool = SpawnPool(prefabData)
    spawnPoolMap[prefabData.poolName] = spawnPool
  end
  if spawnPool:GetPrefabPoolByName(prefabName) then
    return
  end
  local prefabPool = PrefabPool(prefabName)
  spawnPool:CreatePrefabPool(prefabPool)
end

local function GetSpawnPool(modelType)
  local prefabData = PoolConfig[modelType]
  return spawnPoolMap[prefabData.poolName]
end

function PoolManagerTest.Spawn(modelType, prefabName)
  prefabName = ResourceConfig.GetPrefabName(prefabName)
  local spawnPool = GetSpawnPool(modelType)
  if not spawnPool then
    return nil
  end
  return spawnPool:Spawn(prefabName)
end

function PoolManagerTest.Recycle(modelType, prefabName, gameObject)
  if string.isNullOrEmpty(prefabName) then
    return
  end
  if IsNil(gameObject) then
    return
  end
  prefabName = ResourceConfig.GetPrefabName(prefabName)
  local spawnPool = GetSpawnPool(modelType)
  if not spawnPool or not spawnPool:GetPrefabPoolByName(prefabName) then
    CreatePrefabPool(modelType, prefabName)
    spawnPool = GetSpawnPool(modelType)
  end
  spawnPool:DeSpawn(gameObject, prefabName)
end

function PoolManagerTest.Contains(modelType, prefabName)
  prefabName = ResourceConfig.GetPrefabName(prefabName)
  local spawnPool = GetSpawnPool(modelType)
  if not spawnPool then
    return false
  end
  return spawnPool:Contains(prefabName)
end

function PoolManagerTest.Update()
  for _, spawnPool in pairs(spawnPoolMap) do
    spawnPool:Update()
  end
end

function PoolManagerTest.Destroy()
  for _, spawnPool in pairs(spawnPoolMap) do
    spawnPool:Destroy()
  end
  spawnPoolMap = {}
end

PoolManagerTest.Init()
