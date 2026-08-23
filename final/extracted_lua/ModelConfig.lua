ModelConfig = {}
local this = ModelConfig
local MODEL_TYPE_TO_DIR = {
  [1] = "Weapon",
  [2] = "NPC",
  [3] = "Charactor",
  [4] = "Mount",
  [5] = "Monster",
  [6] = "Pet",
  [7] = "Gold"
}

function ModelConfig.GetConfig(id)
  return ConfigManager.GetConfig("cfg_model", id)
end

function ModelConfig.GetModelPath(modelType, id)
  return string.format("Model/%s/%s.prefab", MODEL_TYPE_TO_DIR[modelType], id)
end

function ModelConfig.GetModelDir(modelType)
  return MODEL_TYPE_TO_DIR[modelType]
end

function ModelConfig.GetCommentModelPath(id, name)
  if id == 21 then
    return string.format("Model/%s.prefab", name)
  elseif id % 100 == ERoleEquipPosition.footPrintIndex then
    local paths = string.split(name, "/")
    local nameKey = paths[#paths]
    return string.format("Effect/Scene/%s.prefab", nameKey)
  end
  return string.format("Model/Charactor/%s.prefab", name)
end

function ModelConfig.GetWeaponModelPath(id, name)
  return string.format("Model/Skill/%s/%s.prefab", id, name)
end

function ModelConfig.GetShadowModelPath(id, name)
  return string.format("Model/Charactor/%s/%s.prefab", id, name)
end

function ModelConfig.GetAnimationPrefix(id)
  local cfg = this.GetConfig(id)
  local prefix = cfg and cfg.animationPrefix
  if prefix == "" then
  end
  return prefix
end
