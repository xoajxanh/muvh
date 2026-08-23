RoleEquipOutEffect = class()

function RoleEquipOutEffect:ctor(role, RoleEquip)
  self.avater = role
  self.roleEquip = RoleEquip
  self.OutEffectDic = {}
end

function RoleEquipOutEffect:DestroyAll()
  if self.OutEffectDic == nil then
    return
  end
  for i, v in pairs(self.OutEffectDic) do
    self:DestroyEffect(i)
  end
  self.OutEffectDic = {}
end

function RoleEquipOutEffect.GetEffectModelName(dataItem)
  if dataItem == nil or dataItem.tblEquip == nil then
    return
  end
  return dataItem.tblEquip.bodyEffect
end

function RoleEquipOutEffect:LoadEffect(parent, dataItem, parList, layer)
  local modelName = self.GetEffectModelName(dataItem)
  local parentModelName = parent.name
  if modelName == "" or modelName == nil or parent == nil or parList == nil then
    self:DestroyEffect(parentModelName)
    return
  end
  if self.OutEffectDic[parentModelName] then
    if self.OutEffectDic[parentModelName].modelName == modelName and self.OutEffectDic[parentModelName].EffectModel ~= nil then
      self.OutEffectDic[parentModelName].EffectModel:SetModelActive(true)
      return
    else
      self:DestroyEffect(parentModelName)
    end
  end
  local effectData = {
    modelType = EEffectModelType.Skill,
    model = modelName
  }
  local effectModelList = {}
  for i, v in pairs(parList) do
    if v ~= nil then
      local effectModel = self:LoadModel(v.transform, modelName, effectData, layer)
      table.insert(effectModelList, effectModel)
    end
  end
  local RoleEquipOutEffectData = {
    EffectModel = effectModelList,
    modelName = modelName,
    parentModelName = parentModelName
  }
  self.OutEffectDic[parentModelName] = RoleEquipOutEffectData
end

function RoleEquipOutEffect:LoadModel(par, modelName, effectData, layer)
  local Effect = EffectModel(par, modelName, effectData)
  Effect:Init()
  Effect:SetModel(1)
  Effect:SetLayer(layer)
  return Effect
end

function RoleEquipOutEffect:DestroyEffect(parentModelName)
  if self.OutEffectDic[parentModelName] and self.OutEffectDic[parentModelName].EffectModel ~= nil then
    for i, v in pairs(self.OutEffectDic[parentModelName].EffectModel) do
      v:Destroy()
    end
    self.OutEffectDic[parentModelName] = {}
  end
end
