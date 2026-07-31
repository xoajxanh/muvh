SkillEffectDataMgr = {}

function SkillEffectDataMgr.AddEffect(effectData, skillData_struct, seffect, index)
  seffect.prefab = effectData.prefab
  seffect.startTime = effectData.startTime + index * effectData.interval
  seffect.lifeTime = effectData.duration
  if effectData.synchronizationStart then
    local newStartTime = SkillUtility.GetInSpeedTime(seffect.startTime, skillData_struct.attackSpeed)
    seffect.startTimeSpeedUp = newStartTime / seffect.startTime
    seffect.startTime = newStartTime
  end
  if effectData.synchronizationDuration then
    local newLifeTime = SkillUtility.GetInSpeedTime(seffect.lifeTime, skillData_struct.attackSpeed)
    seffect.lifeTimeSpeedUp = newLifeTime / seffect.lifeTime
    seffect.lifeTime = newLifeTime
  end
  seffect.targetRoleType = effectData.targetType
  seffect.targetBoneName = effectData.targetBoneName
  seffect.shouldAttachBone = effectData.shouldAttachBone
  local tmpVec = effectData.offset
  seffect.localPos = Vector3(tmpVec.x, tmpVec.y, tmpVec.z)
  tmpVec = effectData.offsetEulerAngles
  seffect.localRot = Vector3(tmpVec.x, tmpVec.y, tmpVec.z)
  tmpVec = effectData.scale
  seffect.localScale = Vector3(tmpVec.x, tmpVec.y, tmpVec.z)
  seffect.followAttackerDir = effectData.followAttackerDir
  seffect.scaleWithBone = effectData.scaleWithBone
end
