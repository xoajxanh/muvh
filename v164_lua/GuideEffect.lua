GuideEffect = class()
local this = GuideEffect
this.root = CS.UnityEngine.GameObject("GuideManager").transform
CS.UnityEngine.Object.DontDestroyOnLoad(this.root)

function GuideEffect:ctor(data)
  self:InitAttribute(data)
  self:InitGameObject()
  self:InitPosition()
  self:InitScale()
  self:InitRotation()
  self:InitModel()
end

function GuideEffect:InitAttribute(data)
  self.data = data
end

function GuideEffect:Destroy()
  self:DestroyGameObject()
end

function GuideEffect:GetParent()
  return self.data.parent
end

function GuideEffect:GetName()
  return self.data.name
end

function GuideEffect:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function GuideEffect:DestroyGameObject()
  if IsNil(self.gameObject) == true then
    return
  end
  self.model:Destroy()
  CS.Framework.ObjectEx.Destroy(self.gameObject)
  self.gameObject = nil
  self.transform = nil
end

function GuideEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.posX, self.data.posY, self.data.posZ)
end

function GuideEffect:SetPosition(x, y, z)
  self.pos:Set(x, y, z or 0)
  self.transform.localPosition = self.pos
end

function GuideEffect:SetParent(parent)
  self.transform:SetParent(parent)
end

function GuideEffect:InitScale()
  self.scale = Vector3(0, 0, 0)
  self:SetScale(self.data.ScaleX, self.data.ScaleY, self.data.ScaleZ)
end

function GuideEffect:SetScale(x, y, z)
  self.scale:Set(x, y, z or 0)
  self.transform.localScale = self.scale
end

function GuideEffect:InitRotation()
end

function GuideEffect:Update()
end

function GuideEffect:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.model:SetRotation(dir.x, dir.y, dir.z)
end

local MODEL_LAYER = CS.UnityEngine.LayerMask.NameToLayer("UI")

function GuideEffect:GetModelLayer()
  return MODEL_LAYER
end

function GuideEffect:InitModel()
  self.model = EffectModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadEffectModelComplete)
  self.model:Init()
  self:SetModel()
  self.model:SetLayer(self:GetModelLayer())
end

function GuideEffect:SetModel()
  self.model:SetModel(self:GetModelScale())
end

function GuideEffect:GetModelScale()
  return 1
end

function GuideEffect:OnLoadEffectModelComplete(go, name)
end

function GuideEffect:DestroyModel()
  if self.model then
    self.model:Destroy()
    self.model = nil
  end
end

function GuideEffect:SetActive(state)
  if self.model then
    self.model:SetModelActive(state)
  end
end

function GuideEffect:GetActive()
  if self.model then
    return self.model:GetActive()
  end
end
