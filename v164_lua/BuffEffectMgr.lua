BuffEffectMgr = {}
local this = BuffEffectMgr
local BUFF_SPINE_PARENT = "BuffspineParent"
BuffEffectMgr.m_Effects = {}
BuffEffectMgr.m_CacheDestroy = {}

function BuffEffectMgr.AddEffect(buffData_struct, buffEffect)
  if buffData_struct ~= nil and buffData_struct.buffOwner ~= nil and buffData_struct.buffOwner.CloakingState == true then
    return
  end
  local bEffect = {}
  bEffect.buffCId = buffData_struct.buffCId
  bEffect.buffId = buffData_struct.buffId
  bEffect.prefab = buffEffect.prefab
  bEffect.buffOwnerId = buffData_struct.buffOwnerId
  bEffect.buffOwner = buffData_struct.buffOwner
  if buffEffect.offset ~= nil then
    bEffect.offset = BuffData.GetOffsetByOffset(buffData_struct.buffOwner, buffEffect.offset)
  end
  bEffect.configScale = buffEffect.scale
  bEffect.configOffset = buffEffect.offset
  bEffect.bindPos = buffEffect.bindPos
  this.TryAddEffectList(bEffect)
end

function BuffEffectMgr.TryAddEffectList(bEffect)
  local effectObj, parent = this.LoadEffect(bEffect)
  if parent == SkillMgr.ROOT then
    return
  end
  bEffect.buffEffect = effectObj
  table.insert(this.m_Effects, bEffect)
end

function BuffEffectMgr.Update()
  for _, v in pairs(this.m_CacheDestroy) do
    v.lifeTime = v.lifeTime - Time.deltaTime
    if v.lifeTime <= 0 then
      this.RemoveWaitingDestroyEffect(v.buffId)
    end
  end
end

function BuffEffectMgr.LoadEffect(beffect)
  local buffEffect = BuffData.GetSkillEffect(beffect.prefab)
  local parentRoot = this.GetBuffParent(beffect)
  if parentRoot == nil then
    parentRoot = SkillMgr.ROOT
  end
  local isSkillRoot = parentRoot == SkillMgr.ROOT
  if not isSkillRoot then
    local effect = parentRoot:Find(tostring(beffect.buffCId))
    if effect then
      if buffEffect then
        buffEffect:SetActive(false)
        buffEffect.transform:SetParent(SkillMgr.ROOT)
      end
      return effect.gameObject
    end
  end
  if buffEffect == nil then
    local buffModel = CS.Framework.GameModel(tostring(beffect.buffCId), parentRoot, function(go, name)
      this.OnLoadSkill(beffect, buffEffect)
    end)
    buffModel:LoadAsync(beffect.prefab)
    buffEffect = buffModel.gameObject
  else
    this.OnLoadSkill(beffect, buffEffect)
  end
  local buffEffectTransform = buffEffect.transform
  buffEffectTransform:SetParent(parentRoot)
  buffEffectTransform:SetLocalScale(beffect.configScale.x, beffect.configScale.y, beffect.configScale.z)
  buffEffectTransform:SetLocalPosition(beffect.configOffset.x, beffect.configOffset.y, beffect.configOffset.z)
  buffEffectTransform:SetLocalRotation(0, 0, 0, 1)
  if buffEffect then
    if not isSkillRoot then
      buffEffect:SetActive(true)
    else
      buffEffect:SetActive(false)
      BuffData.AddBuffEffectToPool(beffect.prefab, buffEffect)
    end
  end
  EffAnimatorController.AddEff(parentRoot, {beffect = beffect, buffEffect = buffEffect})
  return buffEffect, parentRoot
end

function BuffEffectMgr.OnLoadSkill(beffect, buffEffect)
  if beffect.buffCId == 12210301 and beffect.buffOwner and beffect.buffOwner.model then
    beffect.particle = buffEffect:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
    if beffect.particle then
      for i = 0, beffect.particle.Length - 1 do
        if beffect.particle[i].shape.shapeType == CS.UnityEngine.ParticleSystemShapeType.SkinnedMeshRenderer then
          local skins = beffect.buffOwner.model.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
          for j = 0, skins.Length - 1 do
            if string.contains(skins[j].name, "Shadow") then
              beffect.particle[i].shape.skinnedMeshRenderer = skins[j]
              beffect.particle[i].shape.useMeshColors = false
            end
          end
          beffect.particle[i].main.simulationSpeed = 1
        end
      end
    end
  end
end

function BuffEffectMgr.GetBuffParent(buffData_struct)
  local parent
  if buffData_struct.buffOwner ~= nil and buffData_struct.buffOwner.model then
    if buffData_struct.bindPos == 0 then
      parent = buffData_struct.buffOwner:GetModelNode(BUFF_SPINE_PARENT)
    elseif buffData_struct.bindPos == 1 then
      parent = buffData_struct.buffOwner.model.BuffAnchor
    elseif buffData_struct.bindPos == 2 then
      parent = buffData_struct.buffOwner.model.parent
    elseif buffData_struct.bindPos == 3 and buffData_struct.buffOwner.Head then
      parent = buffData_struct.buffOwner.Head:GetBuffAnchor()
    elseif buffData_struct.bindPos == 4 and buffData_struct.buffOwnerId == RoleManager.me.id then
      parent = UIManager.root
    end
  end
  if IsNil(parent) then
    if not buffData_struct.buffOwner.addFalseBuffEffect then
      buffData_struct.buffOwner.addFalseBuffEffect = {}
    end
    table.insert(buffData_struct.buffOwner.addFalseBuffEffect, buffData_struct)
    parent = SkillMgr.ROOT
  end
  return parent
end

function BuffEffectMgr.Destroy(buffId, removeType, buffOwnerId)
  for i = #this.m_Effects, 1, -1 do
    if this.m_Effects[i].buffOwnerId == buffOwnerId and this.m_Effects[i].buffId == buffId then
      this.m_Effects[i].lifeTime = this.GetBuffDestoryTime(this.m_Effects[i].buffOwnerId, this.m_Effects[i].buffCId, removeType)
      if this.m_Effects[i].lifeTime ~= nil and this.m_Effects[i].lifeTime > 0 then
        table.insert(this.m_CacheDestroy, this.m_Effects[i])
      elseif not IsNil(this.m_Effects[i].buffEffect) then
        this.m_Effects[i].buffEffect:SetActive(false)
        this.m_Effects[i].buffEffect.transform:SetParent(SkillMgr.ROOT)
        BuffData.AddBuffEffectToPool(this.m_Effects[i].prefab, this.m_Effects[i].buffEffect)
      end
      table.remove(this.m_Effects, i)
    end
  end
end

function BuffEffectMgr.RemoveWaitingDestroyEffect(buffId)
  for i = #this.m_CacheDestroy, 1, -1 do
    if this.m_CacheDestroy[i].buffId == buffId then
      if not IsNil(this.m_CacheDestroy[i].buffEffect) then
        this.m_CacheDestroy[i].buffEffect:SetActive(false)
        this.m_CacheDestroy[i].buffEffect.transform:SetParent(SkillMgr.ROOT)
        BuffData.AddBuffEffectToPool(this.m_CacheDestroy[i].prefab, this.m_CacheDestroy[i].buffEffect)
      end
      table.remove(this.m_CacheDestroy, i)
    end
  end
end

function BuffEffectMgr.GetBuffDestoryTime(rid, buffCId, removeType)
  if buffCId == 12210301 and removeType == RoleBuffRemoveType.CastSkill then
    for i = 1, #this.m_Effects do
      if this.m_Effects[i].buffOwnerId == rid and this.m_Effects[i].buffCId == buffCId and this.m_Effects[i].buffEffect then
        local particle = this.m_Effects[i].buffEffect:GetComponentsInChildren(typeof(CS.UnityEngine.ParticleSystem))
        if particle then
          for i = 0, particle.Length - 1 do
            if particle[i].shape.shapeType == CS.UnityEngine.ParticleSystemShapeType.SkinnedMeshRenderer then
              particle[i].main.simulationSpeed = 3
            end
          end
        end
      end
    end
    return 1.5
  end
  return 0
end

local changeColorEquipPos = {
  ERoleEquipPosition.helm,
  ERoleEquipPosition.wing,
  ERoleEquipPosition.armor,
  ERoleEquipPosition.glove,
  ERoleEquipPosition.pant,
  ERoleEquipPosition.boot,
  ERoleEquipPosition.nechushou
}
local OtherColorParam = {105883}

local function IsOtherColorMaterial(id)
  for i = 1, #OtherColorParam do
    if id == OtherColorParam[i] then
      return true
    end
  end
  return false
end

function BuffEffectMgr.ChangeColor(buff_struct, add, equipeObj, obj)
  local colorSet = add and buff_struct.buffAction.colorSet or Color(1, 1, 1)
  if equipeObj then
    MaterialChange.SetMaterialMainColor(equipeObj, colorSet)
    BuffEffectMgr.ChangeCacheMat(buff_struct.buffOwner, colorSet)
  else
    if not buff_struct.buffOwner then
      if not buff_struct.buffOwnerId then
        logError("buffOwnerId trong buff_struct kh\195\180ng t\225\187\147n t\225\186\161i")
        return
      end
      local role = RoleManager.GetRoleById(buff_struct.buffOwnerId)
      local info
      if not role then
        info = "RoleManager \196\145\195\163 t\225\187\147n t\225\186\161i nh\195\162n v\225\186\173t"
      else
        info = "RoleManager kh\195\180ng t\225\187\147n t\225\186\161i nh\195\162n v\225\186\173t"
      end
      return
    end
    if buff_struct.buffOwner.data.roleType == ERoleType.Monster then
      local target
      if buff_struct.buffOwner.model then
        target = buff_struct.buffOwner.model.modelObject
      end
      if not target and obj then
        target = obj.gameObject
      end
      if target then
        MaterialChange.SetMaterialMainColor(target, colorSet)
        BuffEffectMgr.ChangeCacheMat(buff_struct.buffOwner, colorSet)
        if IsOtherColorMaterial(buff_struct.buffOwner.configId) then
          local skinnedMeshRenderers = target:GetComponentsInChildren(typeof(UnityEngineLua.SkinnedMeshRenderer))
          local mats, mat
          for i = 0, skinnedMeshRenderers.Length - 1 do
            mats = skinnedMeshRenderers[i].materials
            for j = 0, mats.Length - 1 do
              mat = mats[j]
              mat:SetColor("_TintColor", colorSet)
            end
          end
        end
      end
    elseif buff_struct.buffOwner.AvatarEquip then
      local partCount = 0
      for pos, obj in pairs(buff_struct.buffOwner.AvatarEquip.equipPosObj) do
        if table.contains(changeColorEquipPos, pos % 100) then
          MaterialChange.SetMaterialMainColor(obj, colorSet)
          BuffEffectMgr.ChangeCacheMat(buff_struct.buffOwner, colorSet)
          partCount = partCount + 1
        end
      end
      if partCount < 1 and buff_struct.buffOwner.model then
        partCount = buff_struct.buffOwner.model.gameObject
        MaterialChange.SetMaterialMainColor(partCount, colorSet)
        BuffEffectMgr.ChangeCacheMat(buff_struct.buffOwner, colorSet)
      end
      if buff_struct.buffOwner.AvatarEquip.equipPosObj[-1] then
        MaterialChange.SetMaterialMainColor(buff_struct.buffOwner.AvatarEquip.equipPosObj[-1], colorSet)
        BuffEffectMgr.ChangeCacheMat(buff_struct.buffOwner, colorSet)
      end
    end
  end
end

function BuffEffectMgr.ChangeColorByRoleId(roleId, add, pos)
  local buff_struct = BuffData.ColorDic[roleId] and BuffData.ColorDic[roleId].buff_struct
  if buff_struct and buff_struct.buffOwner and buff_struct.buffAction and buff_struct.buffAction.isBuffColorSet and buff_struct.buffOwner.AvatarEquip and (table.contains(changeColorEquipPos, pos % 100) or pos == -1) then
    local a = buff_struct.buffOwner.AvatarEquip.equipPosObj[pos]
    if a then
      this.ChangeColor(buff_struct, add, a)
    end
  end
end

function BuffEffectMgr.ChangeCacheMat(role, color)
  if role ~= nil and type(role.materialsMap) ~= "table" then
    return
  end
  for k, v in pairs(role.materialsMap) do
    for j = 0, v.Length - 1 do
      local mat = v[j]
      mat:SetColor("_Color", color)
    end
  end
end

function BuffEffectMgr.SetBuffEffectShouorHied(buffOwnerId, isActive)
  if this.m_Effects == nil then
    return
  end
  for i = #this.m_Effects, 1, -1 do
    if this.m_Effects[i] ~= nil and this.m_Effects[i].buffEffect and this.m_Effects[i].buffOwnerId == buffOwnerId then
      this.m_Effects[i].buffEffect:SetActive(isActive)
    end
  end
end
