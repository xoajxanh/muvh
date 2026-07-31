SkillBulletMgr = {}

function SkillBulletMgr.AddBullet(bulletData, pbullet, dirIndex, skillData_struct)
  if bulletData == nil then
    return
  end
  pbullet.startTime, pbullet.startTimeSpeedUp = SkillBulletMgr.RandomStartTime(bulletData, skillData_struct.attackSpeed)
  pbullet.prefab = bulletData.prefab
  pbullet.type = bulletData.bulletType
  pbullet.offsetEulerAngles = bulletData.offsetEulerAngles
  pbullet.group = dirIndex
  pbullet.hits = bulletData.hits.hitStruct
  pbullet.scale = Vector3.NewFrom(bulletData.scale)
  pbullet.through = bulletData.through
  pbullet.startBone = bulletData.startBoneName
  pbullet.targetBone = bulletData.targetBoneName
  pbullet.speed = bulletData.speed
  pbullet.lifeTime = bulletData.duration
  pbullet.traceTargetBone = bulletData.traceTargetBone
  pbullet.offset = SkillData.GetOffsetByOffset(skillData_struct.attackerId, bulletData.offset)
  pbullet.targetOffset = SkillData.GetOffsetByOffset(skillData_struct.targetId, bulletData.targetOffset)
  if bulletData.synchronizationDuration then
    local newLifeTime = SkillUtility.GetInSpeedTime(pbullet.lifeTime, skillData_struct.attackSpeed)
    pbullet.lifeTimeSpeedUp = newLifeTime / pbullet.lifeTime
    pbullet.lifeTime = newLifeTime
  end
end

function SkillBulletMgr.RandomStartTime(bulletConfig, attackSpeed)
  local startTime = 0
  local startTimeSpeedUp = 1
  local startTimeRange = bulletConfig.startTimeRange
  startTimeRange = {
    x = math.floor(startTimeRange.x),
    y = math.floor(startTimeRange.y)
  }
  if startTimeRange.x == startTimeRange.y then
    startTime = startTimeRange.x
  else
    startTime = Mathf.Random(startTimeRange.x, startTimeRange.y)
  end
  startTime = startTime * 0.001
  if startTime <= 0 then
    startTime = bulletConfig.startTime
  end
  if bulletConfig.synchronizationStart then
    startTime = SkillUtility.GetInSpeedTime(startTime, attackSpeed)
  end
  return startTime, startTimeSpeedUp
end
