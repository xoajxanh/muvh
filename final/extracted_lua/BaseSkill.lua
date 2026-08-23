BaseSkill = {}
local this = BaseSkill

function BaseSkill.Exec()
end

function BaseSkill.AddSkill(skillData_struct)
  this.SkillStateRun(skillData_struct)
end

function BaseSkill.SkillStateRun(skillData_struct)
  this.DisposeBullet(skillData_struct)
  this.DisposeHeiLongBoTrailEffect(skillData_struct)
end

function BaseSkill.RoleExit(rid)
  BulletMgr.RoleExit(rid)
  SkillEffectMgr.RoleExit(rid)
  WeaponEffectMgr.RoleExit(rid)
end

function BaseSkill.ChangeScene()
  SkillEffectMgr.ChangeScene()
  BulletMgr.ChangeScene()
  WeaponEffectMgr.ChangeScene()
end

function BaseSkill.DisposeBullet(skillData_struct)
  if skillData_struct == nil or this.IsEffectShow(skillData_struct) == false then
    return
  end
  if skillData_struct.ActionBulletData then
    for i = 1, #skillData_struct.ActionBulletData do
      skillData_struct.addType = 1
      skillData_struct.index = i
      BulletMgr.AddBullet(skillData_struct, skillData_struct.ActionBulletData[i])
    end
  end
end

function BaseSkill.DisposeHeiLongBoTrailEffect(skillData_struct)
  if skillData_struct == nil or not this.IsEffectShow(skillData_struct) then
    return
  end
  if skillData_struct.ActionHeiLongBoTrailBulletData then
    for i = 1, #skillData_struct.ActionHeiLongBoTrailBulletData do
      skillData_struct.addType = 1
      skillData_struct.index = i
      BulletMgr.AddHeiLongBoTrailBullet(skillData_struct, skillData_struct.ActionHeiLongBoTrailBulletData[i])
    end
  end
end

function BaseSkill.DisposeEffect(skillData_struct)
  if skillData_struct == nil or this.IsEffectShow(skillData_struct) == false then
    return
  end
  local effectData
  if skillData_struct.ActionEffectData then
    for i = 1, #skillData_struct.ActionEffectData do
      skillData_struct.addType = 1
      skillData_struct.index = i
      effectData = skillData_struct.ActionEffectData[i]
      if effectData then
        SkillEffectMgr.AddEffect(effectData, skillData_struct)
        if effectData.cloneWithServerPath then
          for j = 2, #skillData_struct.positions do
            SkillEffectMgr.AddEffect(effectData, skillData_struct, j - 1)
          end
        end
      end
    end
  end
end

function BaseSkill.DisposeUIEffect(skillData_struct)
  if skillData_struct == nil or this.IsEffectShow(skillData_struct) == false then
    return
  end
  local effectData
  if skillData_struct.ActionEffectData then
    for i = 1, #skillData_struct.ActionEffectData do
      skillData_struct.addType = 1
      skillData_struct.index = i
      effectData = skillData_struct.ActionEffectData[i]
      if effectData then
        SkillEffectMgr.AddUIEffect(effectData, skillData_struct)
        if effectData.cloneWithServerPath then
          for j = 2, #skillData_struct.positions do
            SkillEffectMgr.AddUIEffect(effectData, skillData_struct, j - 1)
          end
        end
      end
    end
  end
end

function BaseSkill.IsEffectShow(skillData_struct)
  if skillData_struct and skillData_struct.attacker and skillData_struct.attacker.HideSkillEffect then
    return false
  end
  return true
end

function BaseSkill.DisposeAni(skillData_struct)
  if skillData_struct.attacker and skillData_struct.ActionWeaponData and #skillData_struct.ActionWeaponData > 0 then
    WeaponEffectMgr.AddEffect(skillData_struct.attacker, skillData_struct.ActionWeaponData[1], skillData_struct.tblSkill, skillData_struct.attackSpeed)
  end
end

function BaseSkill.DisposeCameraEffect(skillData_struct)
  if skillData_struct.attackerId == ViewData.meData.id and skillData_struct.skillConfig and skillData_struct.skillConfig.actions and skillData_struct.skillConfig.actions.ActionCameraData and #skillData_struct.skillConfig.actions.ActionCameraData > 0 then
    CameraEffectMgr.Play(skillData_struct.skillConfig.actions.ActionCameraData[1])
  end
end
