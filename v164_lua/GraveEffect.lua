GraveEffect = class(EffectNew)

function GraveEffect:ctor(data)
  EffectNew.ctor(self, data)
end

function GraveEffect:GetParent()
  return GraveManager.root
end

function GraveEffect:GetName()
  return "Bia m\225\187\153"
end

function GraveEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function GraveEffect:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function GraveEffect:InitRotation()
  self:SetRotation({
    x = 0,
    y = self.data.rotateY,
    z = 0
  })
end

function GraveEffect:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.transform.localEulerAngles = Vector3(self.dir.x, self.dir.y, self.dir.z)
end

function EffectNew:GetModelScale()
  return 0.4
end

function GraveEffect:DelayShow()
end

function GraveEffect:SetOnActive(flag)
  self.gameObject:SetActive(flag)
end

function GraveEffect:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
  self:DestroyHeadUI()
end

function GraveEffect:DestroyModel()
  self:SetRotation({
    x = 0,
    y = 0,
    z = 0
  })
  self.model:SetModelActive(true)
  self.model:Destroy()
  self.model = nil
end

function GraveEffect:OnLoadEffectModelComplete(go, name)
  self:InitHeadUI()
end

function GraveEffect:InitHeadUI()
  if self.gameObject and self.Head then
    self.Head:RefreshData(self, self.data)
    return
  end
  self.Head = GraveHead3DMesh(self, self.data)
end

function GraveEffect:DestroyHeadUI()
  if self.Head ~= nil then
    self.Head:Destroy()
  end
end
