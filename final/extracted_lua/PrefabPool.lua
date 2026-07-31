PrefabPool = class()
setgetters(PrefabPool, {
  totalCount = function(self)
    local count = 0
    count = count + self.deSpawned:Count()
    return count
  end
})

function PrefabPool:ctor(data, spawnPool)
  self.spawnPool = spawnPool
  self:InitAttr(data)
end

function PrefabPool:InitAttr(prefabName)
  self.prefabName = prefabName
  self.lastActiveTime = Time.time
  self.deSpawned = List:New()
end

function PrefabPool:CheckCullDeSpawned()
  local need = false
  if Time.time - self.lastActiveTime > self.spawnPool.cullLoseVitality then
    self.lastActiveTime = Time.time
    need = true
  end
  return need
end

function PrefabPool:CullDeSpawned()
  if self:CheckCullDeSpawned() then
    for _ = 1, self.spawnPool.cullMaxPerPass do
      if self.deSpawned:Count() > self.spawnPool.cullAbove then
        local object = self.deSpawned:PopUp()
        CS.Framework.ObjectEx.Destroy(object)
      else
        break
      end
    end
  end
  if self.deSpawned:Count() == 0 then
    self:DoDestroy()
  end
end

function PrefabPool:DoDestroy()
  self.deSpawned = List:New()
  self.spawnPool:RemovePrefabPool(self)
  self.spawnPool = nil
end

function PrefabPool:Destroy()
  for _, v in pairs(self.deSpawned.list) do
    CS.Framework.ObjectEx.Destroy(v.gameObject)
  end
  self:DoDestroy()
end

function PrefabPool:Spawn()
  self.lastActiveTime = Time.time
  local object
  if self.deSpawned:Count() == 0 then
    return nil
  else
    object = self.deSpawned:PopUp()
  end
  object:SetActive(true)
  return object
end

function PrefabPool:DeSpawn(object)
  self.lastActiveTime = Time.time
  self.deSpawned:Add(object)
  object.gameObject:SetActive(false)
end

function PrefabPool:Contains()
  return self.deSpawned:Count() > 0
end
