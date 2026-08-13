UIEffectUtility = {}
local this = UIEffectUtility
UIEffectUtility.UIEffect = {}
UIEffectUtility.UIEffectParentMap = {}

function UIEffectUtility.SetUIEffect(EffName, gameObject, state, scale, pos)
  local effectData = {
    name = EffName,
    model = EffName,
    parent = gameObject.transform,
    modelType = EEffectModelType.UI,
    ScaleX = scale and scale.x or gameObject.transform.localScale.x,
    ScaleY = scale and scale.y or gameObject.transform.localScale.y,
    posX = pos and pos.x or 0,
    posY = pos and pos.y or 0,
    posZ = pos and pos.z or 0
  }
  local Effect = GuideEffect(effectData)
  Effect:SetActive(state or true)
  return Effect
end

function UIEffectUtility.SetUIEffectParent(EffName, gameObject, state, scale)
  state = state == nil and true or state
  if this.UIEffectParentMap[gameObject.name] then
    for k, v in pairs(this.UIEffectParentMap[gameObject.name]) do
      if v:GetName() == EffName then
        v:SetActive(state)
        return v
      end
    end
  end
  local effectData = {
    name = EffName,
    model = EffName,
    parent = gameObject.transform,
    modelType = EEffectModelType.UI,
    ScaleX = scale and scale.x or gameObject.transform.localScale.x,
    ScaleY = scale and scale.y or gameObject.transform.localScale.y
  }
  local Effect = GuideEffect(effectData)
  Effect:SetActive(state)
  if not this.UIEffectParentMap[gameObject.name] then
    this.UIEffectParentMap[gameObject.name] = {}
  end
  table.insert(this.UIEffectParentMap[gameObject.name], Effect)
  return Effect
end

function UIEffectUtility:SetUIBtnEffectLayer(_ui, _effect)
  if _ui == nil or _effect == nil or IsNil(_effect.gameObject) then
    return
  end
  local orderLayer = _ui.root.canvas.sortingOrder
  local renders = _effect.transform:GetComponentsInChildren(typeof(CS.UnityEngine.Renderer))
  for i = 0, renders.Length - 1 do
    renders[i].sortingOrder = orderLayer + 50
  end
end

function UIEffectUtility:EffectOrderLayerSet(_ui, _effect)
  if _ui == nil or _effect == nil or IsNil(_effect.gameObject) then
    return
  end
  local orderLayer = _ui.root.canvas.sortingOrder
  local particles = _effect.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if particles then
    for i = 0, particles.Length - 1 do
      local renderer = particles[i].gameObject:GetComponent(typeof(CS.UnityEngine.Renderer))
      if renderer then
        renderer.sortingOrder = orderLayer + 50
      end
    end
  end
end

function UIEffectUtility.DestroyAllEffect()
  for k, v in pairs(this.UIEffectParentMap) do
    this.DestroyEffect(v)
  end
  this.UIEffectParentMap = {}
end

function UIEffectUtility.DestroyEffect(effect)
  for k, v in pairs(effect) do
    v:Destroy()
  end
end
