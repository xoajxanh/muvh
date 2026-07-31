local Effect = class()

function Effect:Init(prefab, startTime, startPos)
  self.startTime = startTime
  self.startPos = startPos
  self.prefab = prefab
  local modelGo = PoolManagerTest.Spawn(EEffectModelType.Skill, prefab)
  if IsNil(modelGo) then
    if IsNil(self.model) then
      self.model = CS.Framework.GameModel("SkillEffect", self.root, function(go, name)
        self:OnLoadGameModel(go, name)
      end)
    end
    self.model:LoadAsync(prefab)
  else
    modelGo.transform:SetParent(self.root)
    self:OnLoadGameModel(modelGo)
  end
end

function Effect:OnProcessing()
  if self.playing or IsNil(self.gameModel) then
    return
  end
  if Time.unscaledTime >= self.startTime then
    self:Play()
  end
end

function Effect:OnLoadGameModel(go, name)
  self.gameModel = go
  if IsNil(self.gameModel) then
    return
  end
  self:OnBorn()
end

function Effect:OnBorn()
  self.gameModel.transform.position = self.startPos
  self.gameModel:SetActive(false)
end

function Effect:Play()
  if not IsNil(self.gameModel) then
    self.gameModel:SetActive(true)
  end
  self.playing = true
end

function Effect:Stop()
  if not IsNil(self.gameModel) then
    PoolManagerTest.Recycle(EEffectModelType.Skill, self.prefab, self.gameModel)
  end
  self.gameModel = nil
  self.playing = false
  if self.model then
    self.model:DestroyKeepModelObject()
  end
end

Action_RandomRangeEffect = class(Action_Base)
local ERangeTypeEnum = {
  Square = enum(1),
  Circle = enum()
}

local function randomPos(centerPos, radius, rangeType)
  local res = Vector3.zero
  res.x = Mathf.Random(-radius, radius)
  if rangeType == ERangeTypeEnum.Square then
    res.z = Mathf.Random(-radius, radius)
  elseif rangeType == ERangeTypeEnum.Circle then
    local zRange = Mathf.Sqrt(radius * radius - res.x * res.x)
    zRange = Mathf.Round(zRange)
    res.z = Mathf.Random(-zRange, zRange)
  end
  res.x = res.x * 0.001
  res.z = res.z * 0.001
  return res:Add(centerPos)
end

function Action_RandomRangeEffect:Init(caster, actionData, speed, attackerPos, targetPos)
  self.base.Init(self, caster, actionData, speed)
  self.effectCollection = {}
  self.effectCount = 0
  if actionData.countRange.x == actionData.countRange.y then
    self.effectCount = actionData.countRange.x
  else
    self.effectCount = Mathf.Random(actionData.countRange.x, actionData.countRange.y)
  end
  local targetCenterPos = actionData.effectTargetType == SkillEffectTargetType.Self and attackerPos or targetPos
  targetCenterPos = targetCenterPos + actionData.centerOffset
  local effect, startTime, startPos
  for i = 1, self.effectCount do
    effect = Effect()
    startTime = self.startTime + Mathf.Random(actionData.bornTimeRange.x, actionData.bornTimeRange.y) * 0.001
    startPos = randomPos(targetCenterPos, actionData.radius, actionData.rangeType)
    effect:Init(actionData.prefab, startTime, startPos)
    self.effectCollection[tostring(effect)] = effect
  end
end

function Action_RandomRangeEffect:OnProcessing()
  for _, v in pairs(self.effectCollection) do
    v:OnProcessing()
  end
end

function Action_RandomRangeEffect:OnDestroy()
  for _, v in pairs(self.effectCollection) do
    v:Stop()
  end
  self.effectCollection = {}
end
