DragonFlyEffect = class(EffectNew)

function DragonFlyEffect:ctor(data)
  self.isModelComplete = false
  self.speed = 7
  local effectData = {
    modelType = EModelType.Monster,
    model = "Monster32"
  }
  table.merge(effectData, data)
  EffectNew.ctor(self, effectData)
end

local tempPos1 = Vector3()

function DragonFlyEffect:Update()
  if self.isModelComplete then
    local forward = self.transform.forward
    Vector3.MoveTowardsNonAlloc(self.pos, tempPos1:CopyFromAdd(self.pos, forward), self.speed * Time.deltaTime, self.pos)
    self.transform.localPosition = self.pos
    local viewPos = MainCamera.initCamera:WorldToViewportPoint(self.pos)
    if not (viewPos.x > -1.1) or not (-1.1 < viewPos.y) then
      Activity_DragonAttackManager.DestroyDragon()
      Activity_DragonAttackManager.RefreshDragonFlyEffect()
    end
  end
end

function DragonFlyEffect:InitModel()
  self.model = RoleModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadEffectModelComplete)
  self.model:Init()
  self:SetModel()
  self.model:SetLayer(self:GetModelLayer())
end

function DragonFlyEffect:GetParent()
  return MapEffectManager.root
end

function DragonFlyEffect:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject("H\225\187\143a Long T\225\186\173p K\195\173ch - H\225\187\143a Long")
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function DragonFlyEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function DragonFlyEffect:InitRotation()
  self.dir = Vector3(0, 0, 0)
  self:SetRotation(Vector3(0, 180, 0))
end

function DragonFlyEffect:SetRotation(dir)
  if not dir then
    return
  end
  self.dir = dir
  self.transform.localEulerAngles = Vector3(self.dir.x, self.dir.y, self.dir.z)
end

function EffectNew:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
  self.transform.localPosition = self.pos
end

function DragonFlyEffect:StartMove()
  local function MoveTowards()
    while true do
      local forward = self.transform.forward
      
      self.pos = Vector3.MoveTowards(self.pos, self.pos + forward, self.speed * Time.deltaTime)
      self.transform.localPosition = self.pos
      local viewPos = MainCamera.initCamera:WorldToViewportPoint(self.pos)
      if not (viewPos.x > -1.1) or not (-1.1 < viewPos.y) then
        self:Destroy()
      end
      Coroutine.WaitForEndOfFrame()
    end
  end
  
  self.movement = Coroutine.Start(MoveTowards)
end

function DragonFlyEffect:OnLoadEffectModelComplete(go, name)
  self.isModelComplete = true
  self.model:SetForceUpdate()
  self.model:PlayAnimation("attack3")
  self.model:SetRotation(0, 0, 0)
end

function DragonFlyEffect:Destroy()
  self:SetRotation(Vector3(0, 0, 0))
  self:DestroyMovement()
  self:DestroyModel()
  self:DestroyGameObject()
  self = nil
end

function DragonFlyEffect:DestroyMovement()
  if self.movement then
    Coroutine.Stop(self.movement)
    self.movement = nil
  end
end

function DragonFlyEffect:DestroyModel()
  self.model:Destroy()
  self.model = nil
end

function DragonFlyEffect:SetModel()
  self.model:SetModel(self:GetModelScale())
end

function DragonFlyEffect:GetModelScale()
  return 0.35
end
