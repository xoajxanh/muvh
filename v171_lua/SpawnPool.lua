require("GamePlay/PoolManager/PrefabPool")
SpawnPool = class()

function SpawnPool:ctor(data)
  self:InitAttr(data)
  self:InitGameObject()
end

function SpawnPool:InitAttr(data)
  self.poolName = data.poolName
  self.cullDeSpawned = data.cullDeSpawned
  self.cullAbove = data.cullAbove
  self.cullDelay = data.cullDelay
  self.cullMaxPerPass = data.cullMaxPerPass
  self.cullLoseVitality = data.cullLoseVitality
  self.lastUpdate = Time.time
end

function SpawnPool:InitGameObject()
  self.prefabPools = List:New()
  self.gameObject = CS.UnityEngine.GameObject(self.poolName)
  self.transform = self.gameObject.transform
  self.transform:SetParent(PoolManagerTest.root)
  self.transform.localPosition = Vector3.zero
end

function SpawnPool:CheckNeedUpdate()
  local need = false
  if self.cullDeSpawned and Time.time - self.lastUpdate > self.cullDelay then
    self.lastUpdate = Time.time
    need = true
  end
  return need
end

function SpawnPool:Update()
  if self:CheckNeedUpdate() then
    for _, v in pairs(self.prefabPools.list) do
      v:CullDeSpawned()
    end
  end
end

function SpawnPool:Destroy()
  for _, prefabPool in pairs(self.prefabPools.list) do
    prefabPool:Destroy()
  end
  self.prefabPools = List:New()
end

function SpawnPool:GetPrefabPoolByName(prefabName)
  for _, v in pairs(self.prefabPools.list) do
    if tostring(v.prefabName) == tostring(prefabName) then
      return v
    end
  end
  return nil
end

function SpawnPool:GetPrefabPool(prefabPool)
  for _, v in pairs(self.prefabPools.list) do
    if tostring(v.prefabName) == tostring(prefabPool.prefabName) then
      return v
    end
  end
  return nil
end

function SpawnPool:CreatePrefabPool(prefabPool)
  if self:GetPrefabPool(prefabPool) then
    logError(string.format("\196\144\195\163 th\195\170m v\195\160o pool %s", prefabPool.prefabName))
    return
  end
  prefabPool.spawnPool = self
  self.prefabPools:Add(prefabPool)
end

function SpawnPool:RemovePrefabPool(prefabPool)
  self.prefabPools:Remove(prefabPool)
end

function SpawnPool:Contains(prefabName)
  for _, v in pairs(self.prefabPools.list) do
    if tostring(prefabName) == tostring(v.prefabName) then
      return v:Contains()
    end
  end
  return false
end

function SpawnPool:Spawn(prefabName)
  local object
  for _, v in pairs(self.prefabPools.list) do
    if tostring(prefabName) == tostring(v.prefabName) then
      object = v:Spawn()
      return object
    end
  end
  return object
end

function SpawnPool:DeSpawn(object, prefabName)
  for _, prefabsPool in pairs(self.prefabPools.list) do
    if tostring(prefabName) == tostring(prefabsPool.prefabName) then
      prefabsPool:DeSpawn(object)
      object.transform:SetParent(self.transform, false)
      object.transform:SetLocalPosition(0, 0, 0)
      break
    end
  end
end
