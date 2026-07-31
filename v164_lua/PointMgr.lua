PointMgr = {}
local this = PointMgr

function PointMgr.InitBezier(points)
  local bezier = {}
  bezier.points = points
  bezier.lines = this.CreateLine(points)
  return bezier
end

function PointMgr.CreateLine(points)
  local lines = {}
  for i = 1, #points do
    this.index = i + 1
    if this.index > #points then
      break
    end
    local line = {}
    line.startPoint = points[i]
    line.endPoint = points[this.index]
    table.insert(lines, line)
  end
  return lines
end

function PointMgr.GetBezierPoint(bezier, t)
  if t < 0 then
    t = 0
  elseif 1 < t then
    t = 1
  end
  if bezier.lines == nil then
    return
  end
  local bufListLine = {}
  for i = 1, #bezier.lines do
    table.insert(bufListLine, bezier.lines[i])
  end
  while 1 < #bufListLine do
    bufListLine = this.CaculateResoultLine(bufListLine, t)
  end
  if #bufListLine == 1 then
    return this.GetPoint(bufListLine[1], t)
  end
  return Vector3(0, 0, 0)
end

function PointMgr.GetPoint(point, t)
  if t < 0 then
    t = 0
  elseif 1 < t then
    t = 1
  end
  return (point.endPoint - point.startPoint) * t + point.startPoint
end

function PointMgr.CaculateResoultLine(lines, t)
  local final = {}
  for i = 1, #lines - 1 do
    this.index = i + 1
    local line = {}
    line.startPoint = this.GetPoint(lines[i], t)
    line.endPoint = this.GetPoint(lines[this.index], t)
    table.insert(final, line)
  end
  return final
end
