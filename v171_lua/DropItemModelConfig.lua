DropItemModelConfig = {}
local this = DropItemModelConfig
local MODEL_TYPE_TO_DIR = {
  [EModelType.EquipItem] = "Charactor",
  [EModelType.Gold] = "Gold",
  [EModelType.InstanceItem] = "InstanceItem",
  [EModelType.Item] = "Item",
  [EModelType.Pet] = "Pet"
}

function DropItemModelConfig.GetConfig(id)
  return ConfigManager.GetConfig("cfg_model", id)
end

function DropItemModelConfig.GetModelPath(modelType, id)
  return string.format("Model/%s/%s.prefab", MODEL_TYPE_TO_DIR[modelType], id)
end

function DropItemModelConfig.GetModelDir(modelType)
  return MODEL_TYPE_TO_DIR[modelType]
end
