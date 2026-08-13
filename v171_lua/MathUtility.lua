MathUtility = {}

function MathUtility:IsSphereCollided2(x1, y1, r1, x2, y2, r2)
  local fMaxDistance = r1 + r2
  local xdis = x2 - x1
  local ydis = y2 - y1
  local len2 = xdis * xdis + ydis * ydis
  if len2 <= fMaxDistance * fMaxDistance then
    return true, len2
  end
  return false, 0
end

function MathUtility.TransNumber(num, point)
  point = point or 0
  point = point - 1
  local numStr = tostring(num)
  local numLength = string.len(numStr)
  if numLength < 5 then
    return numStr
  end
  if 9 < numLength then
    local resNum
    local val = num % 1000000000
    local nums = Mathf.Floor(num / 1000000000)
    if val == 0 then
      resNum = string.format("%s B", nums)
    else
      local valStr = string.format("%09d", val):gsub("0+$", "")
      resNum = string.format("%s.%s B", nums, valStr)
    end
    return resNum
  end
  if 7 <= numLength then
    local resNum
    local val = num % 1000000
    local nums = Mathf.Floor(num / 1000000)
    if val == 0 then
      resNum = string.format("%s M", nums)
    else
      local valStr = string.format("%06d", val):gsub("0+$", "")
      resNum = string.format("%s.%s M", nums, valStr)
    end
    return resNum
  end
  if 5 <= numLength then
    local resNum
    local val = num % 1000
    local nums = Mathf.Floor(num / 1000)
    if val == 0 then
      resNum = string.format("%s A", nums)
    else
      local valStr = string.format("%03d", val):gsub("0+$", "")
      resNum = string.format("%s.%s A", nums, valStr)
    end
    return resNum
  end
end

function MathUtility.TransNumberK(num, point)
  point = point or 0
  point = point - 1
  local numStr = tostring(num)
  local numLength = string.len(numStr)
  if numLength < 5 then
    return numStr
  end
  if 8 < numLength then
    local decimal = ""
    if point ~= -1 then
      decimal = string.sub(numStr, numLength - 7, numLength - 7 + point)
      if tonumber(decimal) == 0 then
        decimal = ""
      else
        decimal = string.format(".%s", decimal)
      end
    end
    local resNum = string.format("%d%sT\225\187\183", Mathf.Floor(num / 100000000), decimal)
    return resNum
  end
  if 4 <= numLength then
    local decimal = ""
    if point ~= -1 then
      decimal = string.sub(numStr, numLength - 2, numLength - 2 + point)
      if tonumber(decimal) == 0 then
        decimal = ""
      else
        decimal = string.format(".%s", decimal)
      end
    end
    local resNum = string.format("%d%sK", Mathf.Floor(num / 1000), decimal)
    return resNum
  end
end

function MathUtility.FormatNum(num)
  if num <= 0 then
    return 0
  else
    local t1, t2 = math.modf(num)
    if 0 < t2 then
      return num
    else
      return t1
    end
  end
end

function MathUtility.FormatFloat(num, n)
  if type(num) ~= "number" then
    return num
  end
  n = n or 0
  n = math.floor(n)
  if n < 0 then
    n = 0
  end
  local nDecimal = 10 ^ n
  local nTemp = math.floor(num * nDecimal)
  local nRet = nTemp / nDecimal
  return nRet
end

function MathUtility.getDigitUnit(left, num)
  if type(left) ~= "number" then
    left = tonumber(left)
  end
  return MathUtility.getHighUint(left, num), MathUtility.getLowerUnit(left, num)
end

function MathUtility.GetRounding(num)
  if type(num) ~= "number" or num == 0 then
    return 0
  end
  local t1, t2 = math.modf(num)
  if t2 == 0 then
    return t1
  elseif t2 < 0.5 then
    return math.floor(num)
  else
    return math.ceil(num)
  end
end

function MathUtility.getHighUint(left, num)
  return bit.rshift(left, num)
end

function MathUtility.getLowerUnit(left, num)
  local opRightNum = 2 ^ num - 1
  return bit.band(left, opRightNum)
end
