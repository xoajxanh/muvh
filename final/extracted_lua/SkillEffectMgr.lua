SkillEffectMgr = {}
require("GamePlay/FightFramework/Skill/SpecialSkillEffect")
SkillEffectMgr.m_Effects = {}
local this = SkillEffectMgr

function SkillEffectMgr.Init()
end

function SkillEffectMgr.Update()
  for k, v in pairs(this.m_Effects) do
    this.UpdateEffect(v)
  end
end

local timer = 0

function SkillEffectMgr.UpdateEffect(effectData_struct)
  if effectData_struct == nil then
    return
  end
  if effectData_struct.state == EffectState.None then
    effectData_struct.startTime = effectData_struct.startTime - Time.deltaTime
    if effectData_struct.startTime <= 0 then
      effectData_struct.state = EffectState.Ready
      this.UpdateEffect(effectData_struct)
      return
    end
  elseif effectData_struct.state == EffectState.Ready then
    effectData_struct.skillEffect = this.LoadEffect(effectData_struct)
    effectData_struct.state = EffectState.Running
    this.UpdateEffect(effectData_struct)
    return
  elseif effectData_struct.state == EffectState.Running then
    effectData_struct.lifeTime = effectData_struct.lifeTime - Time.deltaTime
    if 0 >= effectData_struct.lifeTime then
      this.Destroy(effectData_struct.eid)
    end
  end
end

function SkillEffectMgr.AddEffect(effectData, skillData_struct, index)
  if string.isNullOrEmpty(effectData.prefab) then
    return
  end
  local effectActive = EffectDisplayController.AddSkillEffect(skillData_struct.attackerId)
  if not effectActive then
    return
  end
  local seffect = {}
  index = index or 0
  SkillEffectDataMgr.AddEffect(effectData, skillData_struct, seffect, index)
  seffect.weaponId = skillData_struct.weaponId
  seffect.skillId = skillData_struct.skillId
  seffect.groupId = skillData_struct.groupId
  seffect.attackerId = skillData_struct.attackerId
  seffect.tid = skillData_struct.targetId
  seffect.preserved = skillData_struct.preserved
  seffect.attacker = skillData_struct.attacker
  seffect.target = skillData_struct.target
  seffect.targetPos = skillData_struct.targetPos
  seffect.eid = string.format("%s%s%s", seffect.prefab, Time.time, tostring(skillData_struct.index))
  seffect.state = EffectState.None
  table.insert(this.m_Effects, seffect)
end

function SkillEffectMgr.AddUIEffect(effectData, skillData_struct, index)
  if string.isNullOrEmpty(effectData.prefab) then
    return
  end
  local seffect = {}
  index = index or 0
  SkillEffectDataMgr.AddEffect(effectData, skillData_struct, seffect, index)
  seffect.weaponId = skillData_struct.weaponId
  seffect.skillId = skillData_struct.skillId
  seffect.groupId = skillData_struct.groupId
  seffect.attackerId = skillData_struct.attackerId
  seffect.tid = skillData_struct.targetId
  seffect.preserved = skillData_struct.preserved
  seffect.attacker = skillData_struct.attacker
  seffect.target = skillData_struct.target
  seffect.targetPos = skillData_struct.targetPos
  seffect.eid = string.format("%s%s%s", seffect.prefab, Time.time, tostring(skillData_struct.index))
  seffect.state = EffectState.None
  seffect.isUI = skillData_struct.isUI
  table.insert(this.m_Effects, seffect)
end

function SkillEffectMgr.LoadEffect(effectData_struct)
  local skillEffect = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_Skill, effectData_struct.prefab)
  local parentRoot = this.GetSkillParent(effectData_struct)
  if skillEffect == nil then
    local skillModel = CS.Framework.GameModel(tostring(effectData_struct.skillId), parentRoot, function(go, name)
      this.OnLoadSkill(effectData_struct, skillEffect)
    end)
    skillModel:LoadAsync(effectData_struct.prefab)
    skillEffect = skillModel.gameObject
    skillEffect.transform:SetParent(parentRoot)
    if effectData_struct.scaleWithBone then
      skillEffect.transform.localScale = effectData_struct.localScale
    else
      local scale = parentRoot and parentRoot.lossyScale.x or 1
      skillEffect.transform.localScale = effectData_struct.localScale * 1 / scale
    end
    skillEffect.transform.localEulerAngles = effectData_struct.localRot
    if parentRoot then
      skillEffect.transform.localPosition = effectData_struct.localPos
    else
      skillEffect.transform.position = effectData_struct.targetPos
    end
    if not effectData_struct.shouldAttachBone then
      skillEffect.transform:SetParent(nil)
    end
  else
    skillEffect:SetActive(false)
    skillEffect.gameObject.name = tostring(effectData_struct.skillId)
    skillEffect.transform:SetParent(parentRoot)
    if effectData_struct.scaleWithBone then
      skillEffect.transform.localScale = effectData_struct.localScale
    else
      local scale = parentRoot and parentRoot.lossyScale.x or 1
      skillEffect.transform.localScale = effectData_struct.localScale / scale
    end
    skillEffect.transform.localEulerAngles = effectData_struct.localRot
    if parentRoot then
      skillEffect.transform.localPosition = effectData_struct.localPos
    else
      skillEffect.transform.position = effectData_struct.targetPos
    end
    if not effectData_struct.shouldAttachBone then
      skillEffect.transform:SetParent(nil)
    end
    this.OnLoadSkill(effectData_struct, skillEffect)
  end
  if skillEffect then
    skillEffect:SetActive(true)
  end
  return skillEffect
end

function SkillEffectMgr.GetSkillParent(effectData_struct)
  if effectData_struct.targetRoleType == SkillEffectTargetType.Target and effectData_struct.target then
    return SkillUtility.GetRolePos(effectData_struct.target, effectData_struct.targetBoneName)
  elseif effectData_struct.targetRoleType == SkillEffectTargetType.Self and effectData_struct.attacker then
    return SkillUtility.GetRolePos(effectData_struct.attacker, effectData_struct.targetBoneName)
  end
  return SkillMgr.ROOT
end

function SkillEffectMgr.OnLoadSkill(effectData_struct, skillEffect)
  if skillEffect == nil then
    return
  end
  SpecialSkillEffect.DisposeSpecial(effectData_struct, skillEffect)
end

function SkillEffectMgr.Destroy(eid)
  local i = 1
  while i <= #this.m_Effects do
    if this.m_Effects[i].eid == eid then
      SpecialSkillEffect.Destory(this.m_Effects[i])
      if this.m_Effects[i].skillEffect ~= nil then
        PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Skill, this.m_Effects[i].prefab, this.m_Effects[i].skillEffect)
        EffectDisplayController.RemoveSkillEffect(this.m_Effects[i].attackerId)
      end
      table.remove(this.m_Effects, i)
    else
      i = i + 1
    end
  end
end

function SkillEffectMgr.RoleExit(rid)
  for k, v in pairs(this.m_Effects) do
    if v.tid ~= nil and v.tid == rid and v.targetRoleType == SkillEffectTargetType.Target or v.attackerId ~= nil and v.attackerId == rid and v.targetRoleType == SkillEffectTargetType.Self then
      this.Destroy(v.eid)
    end
  end
end

function SkillEffectMgr.ChangeScene()
  for k, v in pairs(this.m_Effects) do
    this.Destroy(v.eid)
  end
end
