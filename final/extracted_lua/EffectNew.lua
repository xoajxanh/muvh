EffectNew = class()

function EffectNew:ctor(data)
  self:InitAttribute(data)
  self:InitGameObject()
  self:InitPosition()
  self:InitRotation()
  self:InitModel()
end

function EffectNew:InitAttribute(data)
  self.data = data
end

function EffectNew:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
end

function EffectNew:GetParent()
  return Effect.root
end

function EffectNew:GetName()
  return self.data.name
end

function EffectNew:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function EffectNew:DestroyGameObject()
  CS.Framework.ObjectEx.Destroy(self.gameObject)
  self.gameObject = nil
  self.transform = nil
end

function EffectNew:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function EffectNew:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function EffectNew:InitRotation()
end

function EffectNew:Update()
end

function EffectNew:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.model:SetRotation(dir.x, dir.y, dir.z)
end

function EffectNew:GetModelLayer()
  return ROLE_LAYER
end

function EffectNew:InitModel()
  self.model = EffectModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadEffectModelComplete)
  self.model:Init()
  self:SetModel()
  self.model:SetLayer(self:GetModelLayer())
end

function EffectNew:SetModel()
  self.model:SetModel(self:GetModelScale())
end

function EffectNew:GetModelScale()
  return 1
end

function EffectNew:OnLoadEffectModelComplete(go, name)
end

function EffectNew:DestroyModel()
  self.model:Destroy()
  self.model = nil
end
