WeaponEffectMgr = {}
WeaponEffectMgr.m_Weapons = {}
local this = WeaponEffectMgr

function WeaponEffectMgr.Init()
end

function WeaponEffectMgr.Update()
  for k, v in pairs(this.m_Weapons) do
    this.UpdateWeapon(v)
  end
end

function WeaponEffectMgr.UpdateWeapon(weaponData_struct)
  if weaponData_struct == nil then
    return
  end
  if weaponData_struct.state == EffectState.None then
    weaponData_struct.startTime = weaponData_struct.startTime - Time.deltaTime
    if weaponData_struct.startTime <= 0 then
      weaponData_struct.state = EffectState.Ready
    end
  elseif weaponData_struct.state == EffectState.Ready then
    weaponData_struct.skillEffect = this.LoadEffect(weaponData_struct)
    weaponData_struct.state = EffectState.Running
  elseif weaponData_struct.state == EffectState.Running then
    weaponData_struct.lifeTime = weaponData_struct.lifeTime - Time.deltaTime
    if 0 >= weaponData_struct.lifeTime then
      this.Destroy(weaponData_struct)
    end
  end
end

function WeaponEffectMgr.AddEffect(role, tbl_action, tbl_skill, attackSpeed)
  local effectActive = EffectDisplayController.AddSkillEffect(role.id)
  if not effectActive then
    return
  end
  local weffect = {}
  weffect.skillId = tbl_skill.id
  weffect.groupId = tbl_skill.groupId
  weffect.attackerId = role.id
  weffect.prefab = tbl_action.prefab
  weffect.startTime = tbl_action.startTime
  weffect.weaponAnimation = tbl_action.animation
  if tbl_action.offset ~= nil then
    weffect.offset = SkillData.GetOffsetByOffset(weffect.attackerId, tbl_action.offset)
  end
  weffect.lifeTime = tbl_action.duration
  weffect.weaponPath = tbl_action.weaponPath
  local weaponGo = role.AvatarEquip:GetEquipeGoByIndedx(ERoleEquipPosition.right_weapon)
  if weaponGo then
    local lastWeaponEff
    for i = 1, #this.m_Weapons do
      if this.m_Weapons[i].attackerId == weffect.attackerId then
        lastWeaponEff = this.m_Weapons[i]
      end
    end
    if lastWeaponEff then
      weffect.weapon = lastWeaponEff.weapon
      lastWeaponEff.weapon = nil
      weffect.weaponPos = lastWeaponEff.weaponPos
      weffect.weaponRotate = lastWeaponEff.weaponRotate
      weffect.weaponParent = lastWeaponEff.weaponParent
      weffect.weaponScale = lastWeaponEff.weaponScale
    else
      weffect.weapon = weaponGo.transform
      weffect.weaponPos = weffect.weapon.localPosition
      weffect.weaponRotate = weffect.weapon.localRotation
      weffect.weaponParent = weffect.weapon.parent
      weffect.weaponScale = weffect.weapon.localScale
    end
  end
  if (tbl_action.synchronizationStart or tbl_action.synchronizationDuration) and role and (role.isMe or role.RoleType == ERoleType.Player) then
    if tbl_action.synchronizationStart then
      local newStartTime = SkillUtility.GetInSpeedTime(weffect.startTime, attackSpeed, role.career)
      weffect.startTimeSpeedUp = newStartTime / weffect.startTime
      weffect.startTime = newStartTime
    end
    if tbl_action.synchronizationDuration then
      local newLifeTime = SkillUtility.GetInSpeedTime(weffect.lifeTime, attackSpeed, role.career)
      weffect.lifeTimeSpeedUp = weffect.lifeTime / newLifeTime
      weffect.lifeTime = newLifeTime
    end
  end
  weffect.eid = string.format("%s%s", weffect.prefab, role.id)
  weffect.state = EffectState.None
  table.insert(this.m_Weapons, weffect)
end

function WeaponEffectMgr.LoadEffect(weaponData_struct)
  local skillEffect = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_Skill, weaponData_struct.prefab)
  if skillEffect == nil then
    local skillModel = CS.Framework.GameModel(tostring(weaponData_struct.skillId), SkillMgr.ROOT, function(go, name)
      this.OnLoadCallBack(weaponData_struct, skillEffect)
    end)
    skillEffect = skillModel.gameObject
    skillModel:LoadAsync(weaponData_struct.prefab)
  else
    skillEffect.gameObject.name = tostring(weaponData_struct.skillId)
    this.OnLoadCallBack(weaponData_struct, skillEffect)
  end
  skillEffect:SetActive(true)
  return skillEffect
end

function WeaponEffectMgr.OnLoadCallBack(weaponData_struct, skillEffect)
  if weaponData_struct.attackerId ~= nil and weaponData_struct.attackerId ~= 0 then
    local attacker = RoleManager.GetRoleById(weaponData_struct.attackerId)
    if attacker ~= nil then
      skillEffect.transform.position = attacker.pos + weaponData_struct.offset
      skillEffect.transform.eulerAngles = Vector3(0, attacker.model.transform.eulerAngles.y, 0)
    end
  end
  this.WeaponAnimation(weaponData_struct, skillEffect)
end

function WeaponEffectMgr.WeaponAnimation(weaponData_struct, skillEffect)
  if skillEffect == nil or IsNil(skillEffect) then
    return
  end
  if weaponData_struct.weapon == nil or IsNil(weaponData_struct.weapon) then
    return
  end
  local skillEffectTrans = skillEffect.transform:Find(weaponData_struct.weaponPath)
  if skillEffectTrans and not IsNil(skillEffectTrans) then
    weaponData_struct.weapon:SetParent(skillEffectTrans)
    weaponData_struct.weapon:SetLocalPosition(0, 0, 0)
    weaponData_struct.weapon:SetLocalRotation(0, 0, 0, 1)
    this.WeaponResidueShadow(weaponData_struct, skillEffect)
  end
  local animation = skillEffect.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animation))
  if animation then
    local speed = 1 / weaponData_struct.lifeTime
    CS.Framework.AnimationEx.PlayAnimationInSpeed(animation, weaponData_struct.weaponAnimation, speed)
  end
end

function WeaponEffectMgr.Destroy(weapon)
  local i = 1
  while i <= #this.m_Weapons do
    if this.m_Weapons[i] == weapon then
      if not IsNil(this.m_Weapons[i].weapon) then
        this.m_Weapons[i].weapon:SetParent(this.m_Weapons[i].weaponParent)
        this.m_Weapons[i].weapon.localPosition = this.m_Weapons[i].weaponPos
        this.m_Weapons[i].weapon.localRotation = this.m_Weapons[i].weaponRotate
        this.m_Weapons[i].weapon.localScale = this.m_Weapons[i].weaponScale
      end
      if not IsNil(this.m_Weapons[i].skillEffect) then
        PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Skill, this.m_Weapons[i].prefab, this.m_Weapons[i].skillEffect)
        EffectDisplayController.RemoveSkillEffect(this.m_Weapons[i].attackerId)
      end
      table.remove(this.m_Weapons, i)
    else
      i = i + 1
    end
  end
end

function WeaponEffectMgr.RoleExit(rid)
  for k, v in pairs(this.m_Weapons) do
    if v.attackerId == rid then
      this.Destroy(v.eid)
      break
    end
  end
end

function WeaponEffectMgr.ChangeScene()
  for k, v in pairs(this.m_Weapons) do
    this.Destroy(v.eid)
  end
end

function WeaponEffectMgr.WeaponResidueShadow(weffect, skillEffect)
  if weffect.groupId == SkillGroupEnum.PiLiXuanFengZhan then
    weffect.pilihuixuancanyin = skillEffect:GetComponentInChildren(typeof(CS.Framework.EffectPiLiXuanFengWeapon))
  end
  if weffect.pilihuixuancanyin then
    local lifeTimeSpeedUp = 1
    if weffect.lifeTimeSpeedUp then
      lifeTimeSpeedUp = weffect.lifeTimeSpeedUp
    end
    weffect.pilihuixuancanyin:Play(weffect.attackerId, lifeTimeSpeedUp)
  end
end
