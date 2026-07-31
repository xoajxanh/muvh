FourPartyRivalryUtility = {}

function FourPartyRivalryUtility:IsPointInTriangle(_point)
  if _point == nil or _point.x == nil or _point.y == nil then
    return false
  end
  local activityEffect = ClientTable.cfg_Activity_globalManager:TryGetValue(500532).effect
  if string.isNullOrEmpty(activityEffect) then
    return false
  end
  local activityEffectTab = TableParse:SplitStringToIntListList(activityEffect, "&", "#")
  local polygon = {}
  for i = table.count(activityEffectTab), 1, -1 do
    table.insert(polygon, {
      x = activityEffectTab[i][1],
      y = activityEffectTab[i][2]
    })
  end
  local triangles = self:Triangulate(polygon)
  if triangles == nil or table.count(triangles) == 0 then
    return false
  end
  for _, triangle in ipairs(triangles) do
    if self:IsPointInsideTriangle(_point, triangle[1], triangle[2], triangle[3]) then
      return true
    end
  end
  return false
end

function FourPartyRivalryUtility:Triangulate(_polygon)
  if _polygon == nil or table.count(_polygon) < 3 then
    return
  end
  local triangles = {}
  local n = table.count(_polygon)
  while 3 <= n do
    for i = 1, n do
      local curr = i
      local next = i % n + 1
      local prev = (i - 2 + n) % n + 1
      local b = _polygon[curr]
      local c = _polygon[next]
      local a = _polygon[prev]
      local cross = (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)
      if not (cross <= 0) then
        local isEar = true
        for j = 1, n do
          if j ~= prev and j ~= curr and j ~= next and self:IsPointInsideTriangle(_polygon[j], a, b, c) then
            isEar = false
            break
          end
        end
        if isEar then
          table.insert(triangles, {
            {
              x = a.x,
              y = a.y
            },
            {
              x = b.x,
              y = b.y
            },
            {
              x = c.x,
              y = c.y
            }
          })
          table.remove(_polygon, curr)
          n = n - 1
          break
        end
      end
    end
  end
  return triangles
end

function FourPartyRivalryUtility:IsPointInsideTriangle(_point, _a, _b, _c)
  if _point == nil or _a == nil or _b == nil or _c == nil then
    return false
  end
  local v0x = _c.x - _a.x
  local v0y = _c.y - _a.y
  local v1x = _b.x - _a.x
  local v1y = _b.y - _a.y
  local v2x = _point.x - _a.x
  local v2y = _point.y - _a.y
  local dot00 = v0x * v0x + v0y * v0y
  local dot01 = v0x * v1x + v0y * v1y
  local dot02 = v0x * v2x + v0y * v2y
  local dot11 = v1x * v1x + v1y * v1y
  local dot12 = v1x * v2x + v1y * v2y
  local invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
  local u = (dot11 * dot02 - dot01 * dot12) * invDenom
  local v = (dot00 * dot12 - dot01 * dot02) * invDenom
  return 0 <= u and 0 <= v and u + v <= 1
end
