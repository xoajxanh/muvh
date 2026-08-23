require("GamePlay/Effect/EffectModelConfig")
EffectModel = class()

function EffectModel:ctor(parent, name, data)
  self.parent = parent
  self.name = name
  self.data = data
end

function EffectModel:Init()
  self.gameObject = CS.UnityEngine.GameObject(self.name or DEFAULT_MODEL)
  self.transform = self.gameObject.transform
  self.transform:SetParent(self.parent, false)
  self:SetPosition(0, 0, 0)
  self:InitScale()
end

function EffectModel:Destroy()
  if IsNil(self.gameObject) == true then
    return
  end
  if not (self.data and self.data.model and self.data.modelType) or not self.gameObject then
    return
  end
  if self.modelObject then
    PoolManagerTest.Recycle(self.data.modelType, self.data.model, self.modelObject)
  end
  self.OnLoadModel = nil
  if self.model then
    self.model:StopLoad()
    self.model:ClearCallBack()
  end
  self.model = nil
  self.modelObject = nil
  self.transform = nil
  UnityEngineLua.GameObject.Destroy(self.gameObject)
  self.gameObject = nil
end

function EffectModel:SetRotation(x, y, z)
  self.transform.localEulerAngles = Vector3(x, y, z)
end

function EffectModel:SetPosition(x, y, z)
  self.transform.localPosition = Vector3(x, y, z)
end

function EffectModel:SetModelActive(active)
  if self.model and self.model.gameObject then
    self.model.gameObject:SetActive(active)
  end
end

function EffectModel:GetModelActive()
  if self.model and self.model.gameObject then
    return self.model.gameObject.activeSelf
  end
end

function EffectModel:InitScale()
  self.scale = Vector3(1, 1, 1)
end

function EffectModel:SetScale(x, y, z)
  self.scale:Set(x, y, z)
  self.transform.localScale = Vector3(x, y, z)
end

function EffectModel:GetScale()
  return self.scale
end

function EffectModel:InitModel()
  if not self.model then
    self.model = CS.Framework.GameModel("EffectModel", self.transform, function(go, name)
      self:OnLoadGameModel(go, name)
    end)
  end
  self:RefreshModelLayer()
end

function EffectModel:OnLoadGameModel(go, name)
  if not name then
    self:SetEffectModel(go)
  end
  if self.OnLoadModel then
    self.OnLoadModel(go, name)
  end
end

function EffectModel:SetEffectModel(go)
  if not self.model then
    PoolManagerTest.Recycle(self.data.modelType, self.data.model, go)
    return
  end
  self.modelObject = go
  if self.modelObject and self.data then
    local modelObjectTf = self.modelObject.transform
    modelObjectTf:SetParent(self.model.transform, false)
    modelObjectTf:SetLocalPosition(0, 0, 0)
    modelObjectTf:SetLocalRotation(0, 0, 0, 1)
    self.modelObject:SetActive(true)
  end
  self:SetModelScale(self.modelScale)
end

function EffectModel:SetModelScale(scale)
  if scale ~= nil and self.modelObject ~= nil then
    self.modelObject.transform:SetLocalScale(scale)
  end
end

function EffectModel:SetModel(modelScale)
  self.modelScale = modelScale
  if self.data == nil or modelScale == nil then
    return
  end
  if self.modelID == self.data.model then
    return
  end
  self.modelID = self.data.model
  self:InitModel()
  local modelGo = PoolManagerTest.Spawn(self.data.modelType, self.data.model)
  if modelGo then
    self:OnLoadGameModel(modelGo.gameObject)
  else
    self.model:LoadAsync(EffectModelConfig.GetModelPath(self.data.modelType, self.modelID))
  end
end

function EffectModel:GetModelScale()
  return self.modelScale
end

function EffectModel:GetActive()
  if self.model and self.model.gameObject then
    return self.model.gameObject.activeSelf
  end
end

function EffectModel:SetLayer(layer)
  if self.layer == layer then
    return
  end
  self.layer = layer
  self:RefreshModelLayer()
end

function EffectModel:RefreshModelLayer()
  if self.layer and self.model then
    self.model:SetLayer(self.layer)
  end
end
