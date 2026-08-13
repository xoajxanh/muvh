TornadoMapEffect = class(EffectNew)

function TornadoMapEffect:ctor(data)
  self.speed = 0.3
  EffectNew.ctor(self, data)
end

function TornadoMapEffect:GetParent()
  return MapEffectManager.root
end

function TornadoMapEffect:GetName()
  return "L\225\187\145c Xo\195\161y R\225\187\147ng"
end

function TornadoMapEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function TornadoMapEffect:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function TornadoMapEffect:InitRotation()
  self:SetRotation({
    x = 0,
    y = self.data.rotateY,
    z = 0
  })
end

function TornadoMapEffect:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.transform.localEulerAngles = Vector3(self.dir.x, self.dir.y, self.dir.z)
end

function TornadoMapEffect:DestroyImmediately()
  if self.movement then
    Coroutine.Stop(self.movement)
    self.movement = nil
  end
  MapEffectManager.DestroyTornado()
  MapEffectManager.RefreshMapEffect()
  Coroutine.Break()
end

function TornadoMapEffect:RandomRotation()
  local rotateY = self.transform.localEulerAngles.y
  local randomY = Mathf.Random(30, 45)
  local timeInterval = randomY / 10
  local finalY = 0
  if 90 < rotateY then
    finalY = rotateY - randomY
  else
    finalY = rotateY + randomY
  end
  self.rotateTween = DOTween.To(function(value)
    self.transform.localEulerAngles = Vector3(self.dir.x, rotateY, self.dir.z)
  end, rotateY, finalY, timeInterval)
end

function TornadoMapEffect:DelayShow()
  local fen = self.model.transform:Find("EffectModel/Huanshuyuan_feng/0/feng")
  local render = fen.transform:GetComponent(typeof(CS.UnityEngine.Renderer))
  local material = render.material
  local startColor = material:GetColor("_TintColor")
  material:SetColor("_TintColor", Color(startColor.r, startColor.g, startColor.b, 0))
  self.showTween = DOTween.To(function(value)
    material:SetColor("_TintColor", Color(startColor.r, startColor.g, startColor.b, value))
  end, 0, 1, 3)
end

function TornadoMapEffect:OnLoadEffectModelComplete(go, name)
  local function MoveTowards()
    local randomRoteTime = Mathf.Random(2, 5)
    
    local startTime = 0
    local count = 0
    self:DelayShow()
    while true do
      local forward = self.transform.forward
      self.pos = Vector3.MoveTowards(self.pos, self.pos + forward, self.speed * Time.deltaTime)
      self.transform.localPosition = self.pos
      local viewPos = MainCamera.initCamera:WorldToViewportPoint(self.pos)
      if not (viewPos.x > -1.1 and viewPos.x < 1.2 and -1.1 < viewPos.y) or not (1.2 > viewPos.y) then
        self:DestroyImmediately()
      end
      if randomRoteTime <= startTime and count == 0 then
        self:RandomRotation()
        count = 1
      elseif randomRoteTime > startTime then
        startTime = startTime + Time.deltaTime
      end
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  self.movement = Coroutine.Start(MoveTowards)
end

function TornadoMapEffect:Destroy()
  self:DestroyMovement()
  self:DestroyModel()
  self:DestroyGameObject()
end

function TornadoMapEffect:DestroyMovement()
  if self.movement then
    Coroutine.Stop(self.movement)
    self.movement = nil
  end
  if self.showTween then
    self.showTween:Kill()
    self.showTween = nil
  end
  if self.rotateTween then
    self.rotateTween:Kill()
    self.rotateTween = nil
  end
end
