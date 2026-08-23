ResourceConfig = {}
local this = ResourceConfig
local Res_TYPE_TO_DIR = {
  [ResourceTypeEnum.Model_Equip] = "Model/Weapon",
  [ResourceTypeEnum.Model_NPC] = "Model/NPC",
  [ResourceTypeEnum.Model_Charactor] = "Model/Charactor",
  [ResourceTypeEnum.Model_Mount] = "Model/Mount",
  [ResourceTypeEnum.Model_Monster] = "Model/Monster",
  [ResourceTypeEnum.Model_Pet] = "Model/Pet",
  [ResourceTypeEnum.Model_Gold] = "Model/Gold",
  [ResourceTypeEnum.Effect_Scene] = "Effect/Scene",
  [ResourceTypeEnum.Effect_Skill] = "Effect/Skill",
  [ResourceTypeEnum.Effect_UI] = "Effect/UI"
}

function ResourceConfig.GetPathByItemData(itemData)
  local path = ""
  local iType = itemData.tblItem.type
  local subType = itemData.tblItem.subType
  local modelName = itemData.tblItem.model
  if iType == EItemType.Equipe then
    modelName = RoleEquipUtility.GetEquipUIModelName(itemData)
    path = this.GetCommentModelPath(subType, modelName)
  elseif iType == EItemType.Resources then
    path = string.format("Model/Gold/%s.prefab", modelName)
  else
    path = string.format("Model/Item/%s.prefab", modelName)
  end
  return path
end

function ResourceConfig.GetUIPathByItemData(itemData)
  local path = ""
  local iType = itemData.tblItem.type
  local subType = itemData.tblItem.subType
  local modelName = itemData.tblItem.model
  if itemData.tblItem.modelUi == 1 then
    modelName = modelName .. "_ui"
  end
  if iType == EItemType.Equipe then
    modelName = RoleEquipUtility.GetEquipUIModelName(itemData)
    path = this.GetCommentModelPath(subType, modelName)
  elseif iType == EItemType.Resources then
    path = string.format("Model/Gold/%s.prefab", modelName)
  else
    path = string.format("Model/Item/%s.prefab", modelName)
  end
  return path
end

function ResourceConfig.GetUIEffectPathByItemData(effectName)
  return string.format("Effect/Item/%s.prefab", effectName)
end

function ResourceConfig.GetCommentModelPath(subtype, name)
  local path = ""
  if subtype == EItemSubtype.Guards then
    path = string.format("Model/%s.prefab", name)
  else
    path = string.format("Model/Charactor/%s.prefab", name)
  end
  return path
end

function ResourceConfig.GetPrefabName(path)
  return Path.GetFileNameWithoutExtension(tostring(path))
end

function ResourceConfig.GetModelPath(modelType, modelName)
  local nameKey = this.GetPrefabName(modelName)
  return string.format("%s/%s.prefab", Res_TYPE_TO_DIR[modelType], nameKey)
end

function ResourceConfig.GetResDir(modelType)
  return Res_TYPE_TO_DIR[modelType]
end

function ResourceConfig.GetWeaponModelPath(id, name)
  return string.format("Model/Skill/%s/%s.prefab", id, name)
end

function ResourceConfig.GetShadowModelPath(id, name)
  return string.format("Model/Charactor/%s/%s.prefab", id, name)
end

function ResourceConfig.GetConfig(id)
  return ConfigManager.GetConfig("cfg_model", id)
end

function ResourceConfig.GetAnimationPrefix(id)
  local cfg = this.GetConfig(id)
  local prefix = cfg and cfg.animationPrefix
  if prefix == "" then
  end
  return prefix
end
