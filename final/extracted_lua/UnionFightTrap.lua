UnionFightTrap = class(Trap)
UnionFightTrap.trapType = TrapTypeEnum.UnionFight

function UnionFightTrap:ctor(data, unionFightData)
  self.modelComplete = false
  self.length = 20
  self.wide = 20
  self.height = 5
  self:InitTrapData(unionFightData)
  self:InitAttribute(data)
  self:InitGameObject()
  self:InitPosition()
  self:InitFlyArgs()
end

function UnionFightTrap:InitTrapData(unionFightData)
  self.arrowDir = unionFightData.arrowDir
  self.bombTime = unionFightData.bombTime
  self.flyTime = unionFightData.flyTime * 1000
  self.startPos = Vector3(unionFightData.startPos.x, unionFightData.startPos.y + 1, unionFightData.startPos.z)
end

function UnionFightTrap:Destroy()
  self:DestroyModel()
  self:DestroyGameObject()
end

function UnionFightTrap:IsShowMeScreen()
  if not MainCamera.target or not self.transform then
    return
  end
  local modelPos = self.transform.localPosition
  local viewPos = MainCamera.initCamera:WorldToViewportPoint(modelPos)
  if viewPos.x < 1.1 and viewPos.x > -0.1 and 1.1 > viewPos.y and -0.1 < viewPos.y then
    return true
  else
    return false
  end
end

function UnionFightTrap:Update()
  self:UpdateMove()
  if not self.model and self:IsShowMeScreen() then
    self:InitModel()
  end
end

function UnionFightTrap:InitPosition()
  self:InitCell()
  self.isMoving = true
  local position = Scene.GetPosByCell(self.cellPos)
  self.endPos = Vector3(0, 0, 0)
  self.endPos:Set(position.x, position.y + 0.1, position.z)
  self:SetPosition(10000, -10000, 10000)
end

function UnionFightTrap:SetPosition(x, y, z)
  self.transform.localPosition = Vector3(x, y, z)
end

function UnionFightTrap:GetPosition()
  return self.endPos
end

function UnionFightTrap:InitModel()
  self.model = EffectModel(self.transform, nil, self.data)
  self.model.OnLoadModel = bind(self, self.OnLoadTrapModelComplete)
  self.model:Init()
  self.model:SetModel(self:GetModelScale())
  self:SetModel()
  self:SetFallingStone()
end

local function Parabola(startPos, endPos, height, t)
  local function Func(x)
    return 2 * (-height * x * x + height * x)
  end
  
  local mid = Vector3.Lerp(startPos, endPos, t)
  return Vector3(mid.x, Func(t) + Mathf.Lerp(startPos.y, endPos.y, t), mid.z)
end

function UnionFightTrap:OnLoadTrapModelComplete(go, name)
end

function UnionFightTrap:InitFlyArgs()
  self.defaultHeight = 10
  local curTime = Time.GetServerTime()
  local intervalTime = self.bombTime - curTime
  local delayTime = intervalTime - self.flyTime > 0 and intervalTime - self.flyTime or 0
  local offsetFly = intervalTime - self.flyTime < 0 and intervalTime - self.flyTime or 0
  self.delayTimeEnd = Time.GetServerTime() + delayTime
  self.flyTime = self.flyTime + offsetFly
  self.flyTimeEnd = self.flyTime + self.delayTimeEnd
  self.destroyOffset = 2000 + self.flyTimeEnd
end

function UnionFightTrap:UpdateMove()
  if Time.GetServerTime() <= self.delayTimeEnd then
    return
  end
  if Time.GetServerTime() > self.delayTimeEnd and Time.GetServerTime() < self.flyTimeEnd then
    local value = Mathf.Clamp(1 - (self.flyTimeEnd - Time.GetServerTime()) / self.flyTime, 0, 1)
    local newPos = Parabola(self.startPos, self.endPos, self.defaultHeight, value)
    local oldPos = self.transform.localPosition
    self:SetPosition(newPos.x, newPos.y, newPos.z)
    local dir = newPos - oldPos
    dir = Vector3.Normalize(dir)
    local x = -Mathf.Atan(dir.y / dir.z) * Mathf.Rad2Deg
    if self.model then
      if self.configId == 103102 and self.fallingStoneModel and self.fallingStoneModel:GetModelActive() then
        self.fallingStoneModel:SetModelActive(false)
      end
      if self.arrowDir == -1 then
        self:SetRotation({
          x = x,
          y = 0,
          z = 0
        })
      else
        self:SetRotation({
          x = x + 180,
          y = 0,
          z = 0
        })
      end
    end
  end
  if Time.GetServerTime() >= self.flyTimeEnd and Time.GetServerTime() < self.destroyOffset and self.configId == 103102 and self.fallingStoneModel and not self.fallingStoneModel:GetModelActive() then
    if self.model then
      self.model:SetModelActive(false)
    end
    self.fallingStoneModel:SetModelActive(true)
  end
  if Time.GetServerTime() >= self.destroyOffset and not TrapManager.DestroyTrap(self.id) then
    self:Destroy()
  end
end

function UnionFightTrap:DestroyModel()
  if self.model then
    self:SetRotation({
      x = 0,
      y = 0,
      z = 0
    })
    self.model:SetModelActive(true)
    self.model:Destroy()
    self.model = nil
  end
  if self.fallingStoneModel then
    self.fallingStoneModel:SetModelActive(false)
    self.fallingStoneModel:Destroy()
    self.fallingStoneModel = nil
  end
end

function UnionFightTrap:SetFallingStone()
  if self.configId == 103102 then
    local modelData = {
      model = "Eff_yunshi_02",
      modelType = EEffectModelType.Scene
    }
    self.fallingStoneModel = EffectModel(self.transform, nil, modelData)
    self.fallingStoneModel.OnLoadModel = bind(self, self.OnFailStoneModelComplete)
    self.fallingStoneModel:Init()
    self.fallingStoneModel:SetModel(self:GetModelScale())
    self.fallingStoneModel:SetLayer(self:GetModelLayer())
  end
end

function UnionFightTrap:OnFailStoneModelComplete(go, name)
  self.fallingStoneModel:SetModelActive(false)
end
