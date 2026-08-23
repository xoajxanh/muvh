local CameraManager = {}

function CameraManager:GetCameraObj()
  if self.mCameraObj == nil then
    self.mCameraObj = LuaClass.CameraObj:New()
  end
  return self.mCameraObj
end

function CameraManager:CameraMovePoint(cameraMovePointParam)
  if self:CheckParams(cameraMovePointParam) == false then
    return
  end
  local cameraTargetPosition = self:GetCameraObj():GetCameraTargetPosition(cameraMovePointParam.targetCell)
  if cameraTargetPosition == nil then
    return
  end
  EventManager.Dispatch(Event.Logic_ActiveMainUI, false)
  Main_JoyStickUI.holdingJoyStick = true
  self.tweenSequence = DOTween.Sequence()
  self.tweenSequence:Append(self:GetCameraObj():GetMainCamera().transform:DOMove(cameraTargetPosition, cameraMovePointParam.time))
  self.tweenSequence:AppendCallback(function()
    if type(cameraMovePointParam.arrivePointFunction) == "function" then
      cameraMovePointParam.arrivePointFunction()
    end
    if cameraMovePointParam.endWaitTime == nil then
      self:ArrivePointDefaultCallBack(cameraMovePointParam.cantEndBackMe)
    end
  end)
  if cameraMovePointParam.endWaitTime ~= nil then
    self.tweenSequence:InsertCallback(cameraMovePointParam.time + cameraMovePointParam.endWaitTime, function()
      if type(cameraMovePointParam.endWaitFunction) == "function" then
        cameraMovePointParam.endWaitFunction()
      end
      self:ArrivePointDefaultCallBack(cameraMovePointParam.cantEndBackMe)
    end)
  end
end

function CameraManager:CheckParams(cameraMovePointParam)
  return cameraMovePointParam ~= nil and cameraMovePointParam.targetCell ~= nil and cameraMovePointParam.time ~= nil
end

function CameraManager:ArrivePointDefaultCallBack(cantEndBackMe)
  if not cantEndBackMe then
    self:GetCameraObj():GetMainCamera().AttachRole(RoleManager.me)
  end
  EventManager.Dispatch(Event.Logic_ActiveMainUI, true)
  Main_JoyStickUI.holdingJoyStick = false
end

function CameraManager:DestroyTweenSequence()
  if self.tweenSequence then
    self.tweenSequence:Kill()
    self.tweenSequence = nil
  end
end

function CameraManager:ShakeCamera(CameraShakeParam)
  if self:AdjustParams(CameraShakeParam) == false then
    return
  end
  return self:GetCameraObj():GetMainCamera().transform:DOShakePosition(CameraShakeParam.time, CameraShakeParam.strength, CameraShakeParam.vibrato, CameraShakeParam.random, CameraShakeParam.snapping, CameraShakeParam.fadeOut)
end

function CameraManager:AdjustParams(CameraShakeParam)
  if CameraShakeParam == nil or CameraShakeParam.time == nil then
    return false
  end
  CameraShakeParam.strength = CameraShakeParam.strength == nil and 1 or CameraShakeParam.strength
  CameraShakeParam.vibrato = CameraShakeParam.vibrato == nil and 10 or CameraShakeParam.vibrato
  CameraShakeParam.random = CameraShakeParam.random == nil and 90 or CameraShakeParam.random
  if CameraShakeParam.snapping == nil then
    CameraShakeParam.snapping = false
  end
  CameraShakeParam.fadeOut = CameraShakeParam.fadeOut == nil and true or CameraShakeParam.fadeOut
  return true
end

function CameraManager:StopCameraTween(tween)
  if tween == nil then
    return
  end
  tween:Kill()
end

function CameraManager:OnDestruct()
  self:DestroyTweenSequence()
  self:RunBaseFunction("OnDestruct")
end

return CameraManager
