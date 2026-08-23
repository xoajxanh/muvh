local SceneEffectProcessor = {}
SceneEffectProcessor.EffectObjList = nil
SceneEffectProcessor.FreeEffectObjList = nil

function SceneEffectProcessor:GetEffectRoot()
  if self.mEffectRoot == nil then
    self.mEffectRoot = CS.UnityEngine.GameObject("SceneEffectRoot").transform
    CS.UnityEngine.Object.DontDestroyOnLoad(self.mEffectRoot)
  end
  return self.mEffectRoot
end

function SceneEffectProcessor:InstantiationEffect(data)
  if self.EffectObjList == nil then
    self.EffectObjList = {}
  end
  local sceneEffectObj
  if self.EffectObjList[data.Id] ~= nil then
    sceneEffectObj = self.EffectObjList[data.Id]
  end
  if sceneEffectObj == nil and type(self.FreeEffectObjList) == "table" then
    local nextId = next(self.FreeEffectObjList)
    if nextId then
      sceneEffectObj = self.FreeEffectObjList[nextId]
      self.FreeEffectObjList[nextId] = nil
    end
  end
  if sceneEffectObj == nil then
    sceneEffectObj = LuaClass.SceneEffectObj:New()
  end
  sceneEffectObj:RefreshModel(data, self:GetEffectRoot())
  self.EffectObjList[data.Id] = sceneEffectObj
end

function SceneEffectProcessor:RemoveEffect(id)
  if type(self.EffectObjList) ~= "table" or self.EffectObjList[id] == nil then
    return
  end
  local effectObj = self.EffectObjList[id]
  effectObj:Hide()
  self.EffectObjList[id] = nil
  if self.FreeEffectObjList == nil then
    self.FreeEffectObjList = {}
  end
  table.insert(self.FreeEffectObjList, effectObj)
end

function SceneEffectProcessor:Destroy()
  if type(self.EffectObjList) == "table" then
    local removeIdList = {}
    for k, v in pairs(self.EffectObjList) do
      table.insert(removeIdList, v.EffectData.Id)
    end
    for k, v in pairs(removeIdList) do
      self:RemoveEffect(v)
    end
  end
end

return SceneEffectProcessor
