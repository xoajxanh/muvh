local SceneDataManager = {}

function SceneDataManager:GetSceneEffectDataManager()
  if self.mSceneEffectDataManager == nil then
    self.mSceneEffectDataManager = LuaClass.SceneEffectDataManager:New()
  end
  return self.mSceneEffectDataManager
end

function SceneDataManager:GetSceneOnHookPointDataManager()
  if self.mSceneOnHookPointDataManager == nil then
    self.mSceneOnHookPointDataManager = LuaClass.SceneOnHookPointDataManager:New()
  end
  return self.mSceneOnHookPointDataManager
end

function SceneDataManager:GetScenePointDataManager()
  if self.mScenePointDataManager == nil then
    self.mScenePointDataManager = LuaClass.ScenePointDataManager:New()
  end
  return self.mScenePointDataManager
end

return SceneDataManager
