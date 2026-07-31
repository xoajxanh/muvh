SpecialSkillEffect = {}
local this = SpecialSkillEffect

function SpecialSkillEffect.DisposeSpecial(effectData_struct, skillEffect)
  if skillEffect == nil then
    return
  end
  if effectData_struct.groupId == SkillGroupEnum.XiFengCi and effectData_struct.targetRoleType == SkillEffectTargetType.Target and effectData_struct.target and effectData_struct.target.model then
    this.DisposeXiFengCi(effectData_struct, skillEffect)
  elseif effectData_struct.groupId == SkillGroupEnum.XinChengYiNu and skillEffect.transform.childCount > 0 then
    this.DisposeXinChengYiNu(effectData_struct, skillEffect)
  elseif effectData_struct.groupId == SkillGroupEnum.ShengLingMonster and effectData_struct.target and effectData_struct.target.model then
    this.DisposeShengLingMonster(effectData_struct, skillEffect)
  elseif effectData_struct.groupId == SkillGroupEnum.ShengLingPlayer and effectData_struct.target and effectData_struct.target.model then
    if effectData_struct.weaponId and effectData_struct.weaponId == 2090080 then
      this.DisposeShengLingPlayer(effectData_struct, skillEffect)
    end
  elseif effectData_struct.groupId == SkillGroupEnum.PiLiXuanFengZhan then
    this.DisposePiLiXuanFengZhan(effectData_struct, skillEffect)
  elseif effectData_struct.groupId == SkillGroupEnum.ZhiMingYiJi and effectData_struct.attacker and effectData_struct.target then
    this.DisposeZhiMingYiJi(effectData_struct, skillEffect)
  elseif effectData_struct.groupId == SkillGroupEnum.GuiMeiSkill then
    this.DisposeGuiMeiSkill(effectData_struct, skillEffect)
  end
end

function SpecialSkillEffect.DisposeGuiMeiSkill(effectData_struct, skillEffect)
  effectData_struct.particle = skillEffect:GetComponentInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if effectData_struct.particle == nil then
    return
  end
  if effectData_struct.attacker == nil or effectData_struct.attacker.model == nil then
    return
  end
  local skinnedMeshRenderer = effectData_struct.attacker.model.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  effectData_struct.particle.shape.skinnedMeshRenderer = skinnedMeshRenderer
end

function SpecialSkillEffect.DisposeXiFengCi(effectData_struct, skillEffect)
  effectData_struct.particle = skillEffect:GetComponentInChildren(typeof(CS.UnityEngine.ParticleSystem))
  if effectData_struct.particle == nil then
    return
  end
  effectData_struct.particles = {}
  local modelScale = effectData_struct.target:GetModelScale()
  if modelScale then
    effectData_struct.particle.main.startSizeMultiplier = 0.14 / modelScale
  end
  effectData_struct.particle.gameObject:SetActive(false)
  local skinnedMeshRenderers = effectData_struct.target.model.gameObject:GetComponentsInChildren(typeof(CS.UnityEngine.SkinnedMeshRenderer))
  for i = 0, skinnedMeshRenderers.Length - 1 do
    if i <= #effectData_struct.particles then
      table.insert(effectData_struct.particles, CS.UnityEngine.GameObject.Instantiate(effectData_struct.particle.gameObject))
    end
    effectData_struct.particles[i + 1].transform:SetParent(effectData_struct.particle.transform.parent)
    effectData_struct.particles[i + 1].transform.position = effectData_struct.particle.transform.position
    effectData_struct.particles[i + 1].transform.localScale = effectData_struct.particle.transform.localScale
    effectData_struct.particles[i + 1]:GetComponent(typeof(CS.UnityEngine.ParticleSystem)).shape.skinnedMeshRenderer = skinnedMeshRenderers[i]
    effectData_struct.particles[i + 1]:SetActive(true)
  end
end

function SpecialSkillEffect.DestoryXiFengCi(effectData_struct)
  if effectData_struct.particles then
    for i = 1, #effectData_struct.particles do
      effectData_struct.particle.gameObject:SetActive(true)
      CS.UnityEngine.GameObject.Destroy(effectData_struct.particles[i])
    end
  end
end

function SpecialSkillEffect.DisposePiLiXuanFengZhan(effectData_struct, skillEffect)
  if skillEffect == nil then
    return
  end
  local animation = skillEffect:GetComponentInChildren(typeof(CS.UnityEngine.Animation))
  if animation and effectData_struct.lifeTimeSpeedUp then
    CS.Framework.AnimationEx.PlayAnimationInSpeed(animation, "AnimEff_Z_pilixuanfengzhan", 1 / effectData_struct.lifeTimeSpeedUp)
  end
end

function SpecialSkillEffect.Destory(effectData_struct)
  if effectData_struct.groupId == SkillGroupEnum.XiFengCi then
    this.DestoryXiFengCi(effectData_struct)
  end
end

function SpecialSkillEffect.DisposeXinChengYiNu(effectData_struct, skillEffect)
  local go = skillEffect.transform:GetChild(0)
  if go and go.childCount >= 6 then
    if effectData_struct.preserved < 1 then
      for i = 0, go.childCount - 1 do
        go:GetChild(i).gameObject:SetActive(i <= 1)
      end
    elseif effectData_struct.preserved < 5.8 then
      for i = 0, go.childCount - 1 do
        go:GetChild(i).gameObject:SetActive(i <= 3)
      end
    else
      for i = 0, go.childCount - 1 do
        go:GetChild(i).gameObject:SetActive(true)
      end
    end
  end
end

function SpecialSkillEffect.DisposeShengLingMonster(effectData_struct, skillEffect)
  local shenglingCurve = skillEffect:GetComponentInChildren(typeof(CS.Framework.ShengLingCurveManager))
  if shenglingCurve ~= nil then
    shenglingCurve:PlayEffect(effectData_struct.target.model.transform, function()
      SkillEffectMgr.Destroy(effectData_struct.eid)
    end)
  end
end

function SpecialSkillEffect.DisposeShengLingPlayer(effectData_struct, skillEffect)
  local shenglingCurve = skillEffect:GetComponentInChildren(typeof(CS.Framework.ShengLingCurveManager))
  if shenglingCurve ~= nil then
    shenglingCurve:PlayEffect(effectData_struct.target.model.transform, nil)
  end
end

function SpecialSkillEffect.DisposeZhiMingYiJi(effectData_struct, skillEffect)
  local zhiMingYiJi = skillEffect:GetComponentInChildren(typeof(CS.Framework.EffectZhiMingYiJiLine))
  if zhiMingYiJi ~= nil then
    local distance = Vector3.Distance(effectData_struct.attacker.pos, effectData_struct.target.pos)
    local showCount = Mathf.Floor(distance - 1)
    showCount = 0 < showCount and showCount or 1
    showCount = showCount < 5 and showCount or 4
    zhiMingYiJi:Show(showCount)
  end
end
