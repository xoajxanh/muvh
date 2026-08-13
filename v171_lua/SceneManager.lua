local SceneManager = {}

function SceneManager:GetSceneDataManager()
  if self.mSceneDataManager == nil then
    self.mSceneDataManager = LuaClass.SceneDataManager:New()
  end
  return self.mSceneDataManager
end

function SceneManager:GetSceneEffectProcessor()
  if self.mSceneEffectProcessor == nil then
    self.mSceneEffectProcessor = LuaClass.SceneEffectProcessor:New()
  end
  return self.mSceneEffectProcessor
end

function SceneManager:GetCameraManager()
  if self.mCameraManager == nil then
    self.mCameraManager = LuaClass.CameraManager:New()
  end
  return self.mCameraManager
end

function SceneManager:Init()
  self:BindEvents()
end

function SceneManager:BindEvents()
  self:RegistEvent(Event.Scene_EffectAdd, function(id, addEffectDataList)
    self:OnEffectAdd(addEffectDataList)
  end)
  self:RegistEvent(Event.Scene_EffectRemove, function()
    self:OnEffectRemove()
  end)
end

function SceneManager:OnEffectAdd(addEffectDataList)
  if type(addEffectDataList) ~= "table" or next(addEffectDataList) == nil then
    return
  end
  for k, v in pairs(addEffectDataList) do
    if self:CheckSceneEffectShow(v) then
      self:GetSceneEffectProcessor():InstantiationEffect(v)
    end
  end
end

function SceneManager:CheckSceneEffectShow(data)
  if data and data.ServerData and data.ServerData.fromId and data.EffectTbl and data.EffectTbl.closeEffect == 1 then
    if data.ServerData.fromId == RoleManager.me.id then
      return true
    else
      local role = RoleManager.GetRoleById(data.ServerData.fromId)
      if role then
        return not role.HideSkillEffect
      end
    end
  end
  return true
end

function SceneManager:OnEffectRemove()
  local sceneRemoveEffectIdList = self:GetSceneDataManager():GetSceneEffectDataManager():GetRemoveEffectIdList()
  if type(sceneRemoveEffectIdList) ~= "table" or next(sceneRemoveEffectIdList) == nil then
    return
  end
  for k, v in pairs(sceneRemoveEffectIdList) do
    self:GetSceneEffectProcessor():RemoveEffect(v)
  end
end

function SceneManager:OnDestruct()
  self:GetSceneEffectProcessor():Destroy()
  self:GetSceneDataManager():OnDestruct()
end

return SceneManager
