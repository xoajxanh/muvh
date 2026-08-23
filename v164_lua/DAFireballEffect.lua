DAFireballEffect = class(EffectNew)

function DAFireballEffect:ctor(data)
  self.isModelComplete = false
  self.speed = 6
  local effectData = {
    modelType = EEffectModelType.Scene,
    model = "Eff_huolonglaixi"
  }
  table.merge(effectData, data)
  EffectNew.ctor(self, effectData)
end

function DAFireballEffect:InitAttribute(data)
  self.data = data
  self.index = data.index
end

function DAFireballEffect:Update()
  if self.isModelComplete then
    self.isModelComplete = false
    self:StartMove()
  end
end

function DAFireballEffect:GetParent()
  return MapEffectManager.root
end

function DAFireballEffect:InitGameObject()
  self.gameObject = CS.UnityEngine.GameObject("H\225\187\143a Long T\225\186\173p K\195\173ch - C\225\186\167u L\225\187\173a")
  self.transform = self.gameObject.transform
  self.transform:SetParent(self:GetParent())
end

function DAFireballEffect:InitPosition()
  self.pos = Vector3(0, 0, 0)
  self.startPos = Vector3(self.data.x, self.data.y, self.data.z)
  self:SetPosition(self.data.x, self.data.y, self.data.z)
end

function DAFireballEffect:SetPosition(x, y, z)
  self.pos:Set(x, y, z)
end

local function SinMove(x)
  return Mathf.Sin(Mathf.PI * x)
end

local tempPos1 = Vector3()
local tempPos2 = Vector3()

function DAFireballEffect:StartMove()
  self.model:SetModelActive(false)
  self.movement = DOTween.Sequence()
  self.movement:AppendCallback(function()
    self.model:SetModelActive(true)
  end)
  local randomXNum = Random.Range(2, 3)
  local randomYNum = Random.Range(2, 3)
  self.movement:Append(DOTween.To(function(value)
    local offsetY = SinMove(randomXNum * value)
    local offsetX = SinMove(randomYNum * value)
    Vector3.MoveTowardsNonAlloc(self.pos, tempPos1:CopyFromSub(self.pos, self.transform.forward), self.speed * Time.deltaTime, tempPos2)
    self:SetPosition(tempPos2.x, tempPos2.y, tempPos2.z)
    tempPos2.x = tempPos2.x + offsetX
    tempPos2.y = tempPos2.y + offsetY
    self.transform.localPosition = tempPos2
  end, 0, 1, self.data.moveTime):SetEase(Ease.Linear):OnComplete(function()
    self.timerDestroy = Timer.Start(1, function()
      self:Destroy()
      Activity_DragonAttackManager.screenEffects[self.index] = nil
    end)
  end))
end

function DAFireballEffect:OnLoadEffectModelComplete(go, name)
  self.isModelComplete = true
end

function DAFireballEffect:Destroy()
  if self.timerDestroy then
    Timer.Stop(self.timerDestroy)
    self.timerDestroy = nil
  end
  self:DestroyMovement()
  self:DestroyModel()
  self:DestroyGameObject()
end

function DAFireballEffect:DestroyMovement()
  if self.movement then
    self.movement:Kill()
    self.movement = nil
  end
end

function DAFireballEffect:DestroyModel()
  self.model:Destroy()
  self.model = nil
end

function DAFireballEffect:GetModelScale()
  return 1
end

function DAFireballEffect:SetModel()
  self.model:SetModel(self:GetModelScale())
end
