HitEffectMgr = {}
HitEffectMgr.m_Effects = {}
local this = HitEffectMgr

function HitEffectMgr.Init()
end

function HitEffectMgr.Update()
  for k, v in pairs(this.m_Effects) do
    this.UpdateEffect(v)
  end
end

function HitEffectMgr.UpdateEffect(effectData_struct)
  if effectData_struct == nil then
    return
  end
  if effectData_struct.state == EffectState.None then
    effectData_struct.startTime = effectData_struct.startTime - Time.deltaTime
    if effectData_struct.startTime <= 0 then
      effectData_struct.state = EffectState.Ready
    end
  elseif effectData_struct.state == EffectState.Ready then
    effectData_struct.skillEffect = this.LoadEffect(effectData_struct)
    effectData_struct.state = EffectState.Running
  elseif effectData_struct.state == EffectState.Running then
    effectData_struct.lifeTime = effectData_struct.lifeTime - Time.deltaTime
    if 0 >= effectData_struct.lifeTime then
      this.Destroy(effectData_struct.eid)
    end
  end
end

function HitEffectMgr.AddEffect(hit_struct, role)
  local heffect = {}
  heffect.prefab = hit_struct.hitEffect
  heffect.startTime = hit_struct.startTime
  heffect.lifeTime = hit_struct.duration
  if hit_struct.offset ~= nil then
    if role ~= nil then
      heffect.offset = SkillData.GetOffsetByOffset(role.id, hit_struct.offset)
    else
      heffect.offset = hit_struct.offset
    end
  end
  heffect.configOffset = hit_struct.offset
  heffect.target = role
  heffect.scale = hit_struct.scale
  heffect.sname = string.format("%shit", role.id)
  heffect.eid = string.format("%s%s", heffect.prefab, Time.time)
  heffect.state = EffectState.None
  table.insert(this.m_Effects, heffect)
end

function HitEffectMgr.AddEffectByPos(hit_struct, targetPos)
  local heffect = {}
  heffect.prefab = hit_struct.hitEffect
  heffect.startTime = hit_struct.startTime
  heffect.lifeTime = hit_struct.duration
  if hit_struct.offset ~= nil then
    heffect.offset = hit_struct.offset
  end
  heffect.configOffset = hit_struct.offset
  heffect.targetPos = targetPos
  heffect.scale = hit_struct.scale
  heffect.sname = string.format("%shit", "targetpos")
  heffect.eid = string.format("%s%s", heffect.prefab, Time.time)
  heffect.state = EffectState.None
  table.insert(this.m_Effects, heffect)
end

function HitEffectMgr.LoadEffect(effectData_struct)
  local skillEffect = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_Skill, effectData_struct.prefab)
  local parentRoot = this.GetSkillParent(effectData_struct)
  if skillEffect == nil then
    local skillModel = CS.Framework.GameModel(tostring(effectData_struct.sname), parentRoot, function(go, name)
      this.OnLoadSkill(effectData_struct, skillEffect)
    end)
    skillModel:LoadAsync(effectData_struct.prefab)
    skillEffect = skillModel.gameObject
  else
    skillEffect:SetActive(false)
    skillEffect.gameObject.name = tostring(effectData_struct.sname)
    this.OnLoadSkill(effectData_struct, skillEffect)
  end
  skillEffect.transform:SetParent(parentRoot)
  if skillEffect then
    skillEffect:SetActive(true)
  end
  if effectData_struct.target ~= nil then
    skillEffect.transform.position = effectData_struct.target.pos + effectData_struct.offset
    if effectData_struct.target.model then
      skillEffect.transform.eulerAngles = Vector3(0, effectData_struct.target.model.transform.eulerAngles.y, 0)
    end
  elseif effectData_struct.targetPos then
    skillEffect.transform.position = effectData_struct.targetPos + effectData_struct.offset
  end
  if effectData_struct.scale then
    skillEffect.transform.localScale = Vector3(effectData_struct.scale.x, effectData_struct.scale.y, effectData_struct.scale.z)
  end
  return skillEffect
end

function HitEffectMgr.GetSkillParent(effectData_struct)
  return SkillMgr.ROOT
end

function HitEffectMgr.OnLoadSkill(effectData_struct, skillEffect)
end

function HitEffectMgr.Destroy(eid)
  for i = 1, #this.m_Effects do
    if this.m_Effects[i].eid == eid then
      if this.m_Effects[i].skillEffect then
        PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Skill, this.m_Effects[i].prefab, this.m_Effects[i].skillEffect)
      end
      table.remove(this.m_Effects, i)
      return
    end
  end
end

function HitEffectMgr.RoleExit(rid)
  for k, v in pairs(this.m_Effects) do
    if v.tid == rid then
      this.Destroy(v.eid)
      break
    end
  end
end
