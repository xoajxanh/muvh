local CameraObj = {}

function CameraObj:GetMainCamera()
  return MainCamera
end

function CameraObj:GetCameraPosition()
  if MainCamera ~= nil then
    return MainCamera.transform.position
  end
end

function CameraObj:GetCameraTargetPosition(targetCellPos)
  if targetCellPos == nil or RoleManager.me == nil or self:GetMainCamera().transform == nil then
    return
  end
  local playerPosition, targetPointPosition = Scene.GetPosByCell(RoleManager.me.cellPos), Scene.GetPosByCell(targetCellPos)
  local targetNormal = targetPointPosition - playerPosition
  return self:GetMainCamera().transform.position + targetNormal
end

return CameraObj
