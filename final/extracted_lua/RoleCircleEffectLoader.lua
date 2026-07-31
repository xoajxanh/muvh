local RoleCircleEffectLoader = {}

function RoleCircleEffectLoader:GetDefaultPosition()
  return {
    x = 0,
    y = 0,
    z = 0
  }
end

function RoleCircleEffectLoader:GetDefaultRotation()
  return self:GetDefaultPosition()
end

function RoleCircleEffectLoader:GetDefaultScale()
  return {
    x = 1,
    y = 1,
    z = 1
  }
end

function RoleCircleEffectLoader:Spawn(name, func, funcParam)
  local obj = PoolManagerTest.Spawn(EEffectModelType.Scene, name)
  if obj then
    if func then
      func(obj, funcParam)
    end
  else
    Coroutine.Start(self.LoadRoleCircleEffect, self, name, func, funcParam)
  end
end

function RoleCircleEffectLoader:LoadRoleCircleEffect(name, func, funcParam)
  local path = self:GetPathByName(name)
  local async = CS.Framework.ResourceManager.InstantiateAsync(path)
  Coroutine.Yield(async)
  if not async or async.isError then
    func(nil, funcParam)
    Coroutine.Break()
  end
  if async and async.gameObject and not IsNil(async.gameObject) then
    func(async.gameObject, funcParam)
  end
end

function RoleCircleEffectLoader:Recycle(obj, name, recycleFunc)
  if obj == nil or IsNil(obj) then
    return
  end
  if name == nil or string.isNullOrEmpty(name) then
    return
  end
  PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Scene, name, obj)
  if recycleFunc then
    recycleFunc()
  end
end

function RoleCircleEffectLoader:GetPathByName(name)
  return ResourceConfig.GetModelPath(ResourceTypeEnum.Effect_Scene, ResourceConfig.GetPrefabName(name))
end

return RoleCircleEffectLoader
