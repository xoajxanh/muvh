EffectModelConfig = {}
local this = EffectModelConfig
local MODEL_TYPE_TO_DIR = {
  [EEffectModelType.Scene] = "Scene",
  [EEffectModelType.Skill] = "Skill",
  [EEffectModelType.UI] = "UI"
}

function EffectModelConfig.GetModelPath(modelType, id)
  return string.format("Effect/%s/%s.prefab", MODEL_TYPE_TO_DIR[modelType], id)
end

function EffectModelConfig.GetModelDir(modelType)
  return MODEL_TYPE_TO_DIR[modelType]
end
