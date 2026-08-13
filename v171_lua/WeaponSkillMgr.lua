WeaponSkillMgr = {}
local this = WeaponSkillMgr

function WeaponSkillMgr.AddEffect(skillData_struct, WeaponSkillActionData, WeaponActionStruct)
  local skillBullet = {}
  skillBullet.startTime = WeaponSkillActionData.startTime
  skillBullet.duration = WeaponSkillActionData.duration
  skillBullet.synchronizationStart = WeaponSkillActionData.synchronizationStart
  skillBullet.synchronizationDuration = WeaponSkillActionData.synchronizationDuration
  skillBullet.startBoneName = WeaponSkillActionData.startBoneName
  skillBullet.offset = WeaponSkillActionData.offset
  skillBullet.targetBoneName = WeaponSkillActionData.targetBoneName
  skillBullet.targetOffset = WeaponSkillActionData.targetOffset
  skillBullet.offsetEulerAngles = WeaponSkillActionData.offsetEulerAngles
  skillBullet.through = WeaponSkillActionData.through
  skillBullet.group = WeaponSkillActionData.group
  skillBullet.bulletType = WeaponSkillActionData.bulletType
  local skillWConfig = WeaponActionStruct
  skillBullet.prefab = skillWConfig.prefab
  if WeaponSkillActionData.bulletType and skillWConfig.weaponBulletType and skillWConfig.weaponBulletType ~= WeaponBulletType.Normal then
    if skillWConfig.weaponBulletType == WeaponBulletType.MoveInCSharpe then
      skillBullet.bulletType = WeaponSkillActionData.bulletType == BulletType.TargetPos and BulletType.MoveInCSharpeTargetPos or BulletType.MoveInCSharpeTargetDir
    elseif skillWConfig.weaponBulletType == WeaponBulletType.Bezier then
      skillBullet.bulletType = BulletType.MoveInBezier
    end
  end
  skillBullet.speed = skillWConfig.speed
  skillBullet.scale = skillWConfig.scale
  skillBullet.hits = skillWConfig.hits
  return skillBullet
end
