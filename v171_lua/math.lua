function math.calcRotateAngle(angle1, angle2)
  local d = (angle2 - angle1) % 360
  
  if 180 < d then
    d = d - 360
  end
  return angle1 + d
end
