CameraEffectMgr = {}
local this = CameraEffectMgr
local cameraEffect
local isExcuting = false

function CameraEffectMgr.Update()
  if cameraEffect == nil then
    return
  end
  if cameraEffect.state == EffectState.None then
    isExcuting = true
    cameraEffect.startTime = cameraEffect.startTime - Time.deltaTime
    if cameraEffect.startTime <= 0 then
      cameraEffect.state = EffectState.Ready
    end
  elseif cameraEffect.state == EffectState.Ready then
    cameraEffect.state = EffectState.Running
  elseif cameraEffect.state == EffectState.Running then
    cameraEffect.oldDelta = cameraEffect.delta
    cameraEffect.delta = cameraEffect.delta + Time.deltaTime * cameraEffect.direction * cameraEffect.speed
    if Mathf.Abs(cameraEffect.delta) >= cameraEffect.offset then
      cameraEffect.delta = (0 < cameraEffect.delta and 1 or -1) * cameraEffect.offset
      cameraEffect.direction = cameraEffect.direction * -1
    end
    if 0 > cameraEffect.oldDelta * cameraEffect.delta then
      cameraEffect.recordTime = cameraEffect.recordTime + 1
    end
    if cameraEffect.recordTime >= cameraEffect.times then
      isExcuting = false
      cameraEffect.camera:SetLocalEulerAngles(cameraEffect.roatatePos.x, cameraEffect.roatatePos.y, cameraEffect.roatatePos.z)
      cameraEffect = nil
      return
    end
    cameraEffect.tempValue = cameraEffect.roatatePos + Vector3(cameraEffect.delta, 0, 0)
    cameraEffect.camera:SetLocalEulerAngles(cameraEffect.tempValue.x, cameraEffect.tempValue.y, cameraEffect.tempValue.z)
  end
end

function CameraEffectMgr.Play(tblAction)
  if isExcuting then
    return
  end
  cameraEffect = {}
  cameraEffect.cameraType = tblAction.cameraType
  cameraEffect.offset = tblAction.offset
  cameraEffect.startTime = tblAction.startTime
  cameraEffect.lifeTime = tblAction.costTime
  if tblAction.synchronizationStart or tblAction.synchronizationDuration then
    if tblAction.synchronizationStart then
      local newStartTime = SkillUtility.GetInSpeedTime(tblAction.startTime, ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue], RoleManager.me.career)
      cameraEffect.startTimeSpeedUp = newStartTime / cameraEffect.startTime
      cameraEffect.startTime = newStartTime
    end
    if tblAction.synchronizationDuration then
      local newLifeTime = SkillUtility.GetInSpeedTime(tblAction.costTime, ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue], RoleManager.me.career)
      cameraEffect.lifeTimeSpeedUp = newLifeTime / tblAction.costTime
      cameraEffect.lifeTime = newLifeTime
    end
  end
  cameraEffect.speed = tblAction.offset / cameraEffect.lifeTime
  cameraEffect.times = tblAction.times
  cameraEffect.state = EffectState.None
  cameraEffect.camera = CS.UnityEngine.Camera.main.transform
  cameraEffect.roatatePos = cameraEffect.camera.localEulerAngles
  cameraEffect.direction = 1
  cameraEffect.delta = 0
  cameraEffect.oldDelta = 0
  cameraEffect.recordTime = -1
end
