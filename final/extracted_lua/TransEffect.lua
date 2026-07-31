TransEffect = class(EffectNew)

function TransEffect:ctor(data)
  EffectNew.ctor(self, data)
end

function TransEffect:GetParent()
  return TransManager.root
end

function TransEffect:GetName()
  return "Tr\225\186\173n D\225\187\139ch Chuy\225\187\131n"
end

function TransEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function TransEffect:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function TransEffect:InitRotation()
  self:SetRotation(self.data.rotate)
end

function TransEffect:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.transform.localEulerAngles = Vector3(self.dir.x, self.dir.y, self.dir.z)
end

function TransEffect:DestroyImmediately()
  TransManager.DestroyTransById(1)
end

function TransEffect:DelayShow()
end

function TransEffect:GetModelScale()
  return self.data.scale or 1
end

function TransEffect:SetOnActive(flag)
  self.gameObject:SetActive(flag)
end

function TransEffect:OnLoadEffectModelComplete(go, name)
end

function TransEffect:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
  TransEffect:DestroyImmediately()
end

function TransEffect:DestroyModel()
  self:SetRotation({
    x = 0,
    y = 0,
    z = 0
  })
  self.model:SetModelActive(true)
  self.model:Destroy()
  self.model = nil
end
