Direction8 = CS.Framework.Direction8
Direction8Utility = {}

function Direction8Utility.GetRoleDirInDirection8(dir)
  dir = Mathf.Round(dir)
  dir = dir - 22.5
  while dir < 0 do
    dir = dir + 360
  end
  while 360 <= dir do
    dir = dir - 360
  end
  if 0 < dir and dir <= 45 then
    return Direction8.RightUp
  elseif 45 < dir and dir <= 90 then
    return Direction8.Right
  elseif 90 < dir and dir <= 135 then
    return Direction8.RightDown
  elseif 135 < dir and dir <= 180 then
    return Direction8.Down
  elseif 180 < dir and dir <= 225 then
    return Direction8.LeftDown
  elseif 225 < dir and dir <= 270 then
    return Direction8.Left
  elseif 270 < dir and dir <= 315 then
    return Direction8.LeftUp
  end
  return Direction8.Up
end

function Direction8Utility:GetAngleByDir(dir)
  if dir == Direction.RIGHTUP then
    return 45
  elseif dir == Direction.RIGHT then
    return 90
  elseif dir == Direction.RIGHTDOWN then
    return 135
  elseif dir == Direction.DOWN then
    return 180
  elseif dir == Direction.LEFTDOWN then
    return 225
  elseif dir == Direction.LEFT then
    return 270
  elseif dir == Direction.LEFTUP then
    return 315
  else
    return 0
  end
end

function Direction8Utility:GetDirectionByOffset(x, y)
  local angle = Mathf.Atan2(y, x) * Mathf.Rad2Deg + 22.5
  while angle < 0 do
    angle = angle + 360
  end
  while 360 <= angle do
    angle = angle - 360
  end
  if 0 <= angle and angle < 45 then
    return Direction8.Right
  end
  if 45 <= angle and angle < 90 then
    return Direction8.RightUp
  end
  if 90 <= angle and angle < 135 then
    return Direction8.Up
  end
  if 135 <= angle and angle < 180 then
    return Direction8.LeftUp
  end
  if 180 <= angle and angle < 225 then
    return Direction8.Left
  end
  if 225 <= angle and angle < 270 then
    return Direction8.LeftDown
  end
  if 270 <= angle and angle < 315 then
    return Direction8.Down
  end
  return Direction8.RightDown
end

function Direction8Utility.GetDirectionOffsetByDir(dir)
  if type(dir) ~= "number" then
    return Vector2.zero
  end
  local directionEnum = Direction8Utility.GetRoleDirInDirection8(dir)
  local vector2Int = Direction8Utility.GetDirectionOffset(directionEnum)
  return Vector2(vector2Int.x, vector2Int.y)
end

function Direction8Utility.GetDirectionOffset(direction)
  if direction == Direction8.Up then
    return Vector2Int(0, 1)
  end
  if direction == Direction8.Down then
    return Vector2Int(0, -1)
  end
  if direction == Direction8.Left then
    return Vector2Int(-1, 0)
  end
  if direction == Direction8.Right then
    return Vector2Int(1, 0)
  end
  if direction == Direction8.LeftUp then
    return Vector2Int(-1, 1)
  end
  if direction == Direction8.RightUp then
    return Vector2Int(1, 1)
  end
  if direction == Direction8.LeftDown then
    return Vector2Int(-1, -1)
  end
  if direction == Direction8.RightDown then
    return Vector2Int(1, -1)
  end
  return Vector2Int(0, 0)
end

function Direction8Utility:GetJoyStickDirectionCellOffset(direction)
  if direction == Direction8.Up then
    return Vector2Int(-1, 1)
  end
  if direction == Direction8.Down then
    return Vector2Int(1, -1)
  end
  if direction == Direction8.Left then
    return Vector2Int(-1, -1)
  end
  if direction == Direction8.Right then
    return Vector2Int(1, 1)
  end
  if direction == Direction8.LeftUp then
    return Vector2Int(-1, 0)
  end
  if direction == Direction8.RightUp then
    return Vector2Int(0, 1)
  end
  if direction == Direction8.LeftDown then
    return Vector2Int(0, -1)
  end
  if direction == Direction8.RightDown then
    return Vector2Int(1, 0)
  end
  return Vector2Int(0, 0)
end

function Direction8Utility:GetJoyStickNormalOffset(x, y)
  local angle = Mathf.Atan2(y, x) * Mathf.Rad2Deg + 22.5
  while angle < 0 do
    angle = angle + 360
  end
  while 360 <= angle do
    angle = angle - 360
  end
  if 0 <= angle and angle < 45 then
    return self:GetJoyStickDirectionCellOffset(Direction8.Right)
  end
  if 45 <= angle and angle < 90 then
    return self:GetJoyStickDirectionCellOffset(Direction8.RightUp)
  end
  if 90 <= angle and angle < 135 then
    return self:GetJoyStickDirectionCellOffset(Direction8.Up)
  end
  if 135 <= angle and angle < 180 then
    return self:GetJoyStickDirectionCellOffset(Direction8.LeftUp)
  end
  if 180 <= angle and angle < 225 then
    return self:GetJoyStickDirectionCellOffset(Direction8.Left)
  end
  if 225 <= angle and angle < 270 then
    return self:GetJoyStickDirectionCellOffset(Direction8.LeftDown)
  end
  if 270 <= angle and angle < 315 then
    return self:GetJoyStickDirectionCellOffset(Direction8.Down)
  end
  return self:GetJoyStickDirectionCellOffset(Direction8.RightDown)
end

function Direction8Utility:GetOppositeDirection(direction)
  if direction == Direction8.Up then
    return Vector2Int(0, -1)
  end
  if direction == Direction8.Down then
    return Vector2Int(0, 1)
  end
  if direction == Direction8.Left then
    return Vector2Int(1, 0)
  end
  if direction == Direction8.Right then
    return Vector2Int(-1, 0)
  end
  if direction == Direction8.LeftUp then
    return Vector2Int(1, -1)
  end
  if direction == Direction8.RightUp then
    return Vector2Int(-1, -1)
  end
  if direction == Direction8.LeftDown then
    return Vector2Int(1, 1)
  end
  if direction == Direction8.RightDown then
    return Vector2Int(-1, 1)
  end
  return Direction8.Max
end

function Direction8Utility:GetOffsetZByAngle(angle)
  while angle < 0 do
    angle = angle + 360
  end
  while 360 <= angle do
    angle = angle - 360
  end
  return Vector3(Mathf.Sin(Mathf.Deg2Rad * angle), 0, Mathf.Cos(Mathf.Deg2Rad * angle))
end

function Direction8Utility:GetOffsetXByAngle(angle)
  while angle < 0 do
    angle = angle + 360
  end
  while 360 <= angle do
    angle = angle - 360
  end
  return Vector3(Mathf.Cos(Mathf.Deg2Rad * angle), 0, -Mathf.Sin(Mathf.Deg2Rad * angle))
end

function Direction8Utility:GetChangedPosition(angle, offset)
  local m00 = Mathf.Cos(Mathf.Deg2Rad * angle)
  local m01 = 0
  local m03 = 0
  local m10 = 0
  local m12 = 0
  local m13 = 0
  local m21 = 0
  local m23 = 0
  local m30 = 0
  local m31 = 0
  local m32 = 0
  local m02 = Mathf.Sin(Mathf.Deg2Rad * angle)
  local m11 = 1
  local m33 = 1
  local m20 = -Mathf.Sin(Mathf.Deg2Rad * angle)
  local m22 = Mathf.Cos(Mathf.Deg2Rad * angle)
  return Vector3(m00 * offset.x + m10 * offset.y + m20 * offset.z, offset.y, m02 * offset.x + m12 * offset.y + m22 * offset.z)
end

function Direction8Utility:GetOffsetZByAngleAccurate(angle)
  while angle < 0 do
    angle = angle + 360
  end
  while 360 <= angle do
    angle = angle - 360
  end
  return Vector3.Normalize(Vector3(Mathf.Sin(Mathf.Deg2Rad * angle), 0, Mathf.Cos(Mathf.Deg2Rad * angle)))
end

function Direction8Utility:GetOffsetXByAngleAccurate(angle)
  while angle < 0 do
    angle = angle + 360
  end
  while 360 <= angle do
    angle = angle - 360
  end
  return Vector3.Normalize(Vector3(Mathf.Cos(Mathf.Deg2Rad * angle), 0, -Mathf.Sin(Mathf.Deg2Rad * angle)))
end

function Direction8Utility.ChangeDir(vec2, angle)
  local radian = Mathf.PI / 180
  local value = angle * radian
  local sin = Mathf.Sin(value)
  local cos = Mathf.Cos(value)
  local newX = vec2.x * cos + vec2.y * sin
  local newY = vec2.x * -sin + vec2.y * cos
  return Vector2(newX, newY)
end
