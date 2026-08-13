UnionFightEffect = class(EffectNew)

function UnionFightEffect:ctor(data)
  self.isModelComplete = false
  self:InitSpeed(data)
  EffectNew.ctor(self, data)
end

function UnionFightEffect:Update()
  if self.isModelComplete then
    self.isModelComplete = false
    self:StartMove()
  end
end

function UnionFightEffect:InitSpeed(data)
  if data.model == "Eff_yunshi_01" then
    self.speed = 7
  else
    self.speed = 4
  end
end

function UnionFightEffect:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject(self:GetName())
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function UnionFightEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function UnionFightEffect:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function UnionFightEffect:DestroyImmediately()
  self:Destroy()
  Activity_SiegeManager.screenEffects[self.data.id] = nil
end

function UnionFightEffect:StartMove()
  self.movement = DOTween.Sequence()
  self.movement:AppendCallback(function()
    local forward = self.transform.forward * self.data.moveDir * -1
    self.pos = Vector3.MoveTowards(self.pos, self.pos + forward, self.speed * Time.deltaTime)
    self.transform.localPosition = self.pos
    local viewPos = MainCamera.initCamera:WorldToViewportPoint(self.pos)
    if self.data.moveDir == -1 then
      if not (viewPos.x < 1.2) or not (1.2 > viewPos.y) then
        self:DestroyImmediately()
      end
    elseif not (viewPos.x > -1.1) or not (viewPos.y > -1.1) then
      self:DestroyImmediately()
    end
  end)
  self.movement:SetEase(Ease.Linear)
  self.movement:SetLoops(-1)
end

function UnionFightEffect:OnLoadEffectModelComplete(go, name)
  self.isModelComplete = true
end

function UnionFightEffect:Destroy()
  self:DestroyMovement()
  self:DestroyModel()
  self:DestroyGameObject()
end

function UnionFightEffect:DestroyMovement()
  if self.movement then
    self.movement:Kill()
    self.movement = nil
  end
end

function UnionFightEffect:DestroyModel()
  self.model:Destroy()
  self.model = nil
end

function UnionFightEffect:SetModel()
  self.model:SetModel(1)
end
