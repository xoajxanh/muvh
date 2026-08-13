ColorUtility = {}

function ColorUtility.ColorToInt(color)
  local r = Mathf.Round(color.r * 255)
  local g = Mathf.Round(color.g * 255)
  local b = Mathf.Round(color.b * 255)
  local a = Mathf.Round(color.a * 255)
  return r << 24 | g << 16 | b << 8 | a
end

function ColorUtility.IntToColor(rgba)
  local r = (rgba >> 24) / 255
  local g = (rgba >> 16 & 255) / 255
  local b = (rgba >> 8 & 255) / 255
  local a = (rgba & 255) / 255
  local res = Color(r, g, b, a)
  return res
end

function ColorUtility.ColorToColor32(color)
  return {
    r = math.ceil(color.r * 255),
    g = math.ceil(color.g * 255),
    b = math.ceil(color.b * 255),
    a = 255
  }
end

function ColorUtility.SetUIColor(uicontrol, color)
  local colorInt = ColorUtility.ColorToInt(color)
  uicontrol:SetColor(colorInt)
end

function ColorUtility.GetConsumableCountStr(curValue, maxValue, _type)
  if curValue == nil or maxValue == nil or type(curValue) ~= "number" or type(maxValue) ~= "number" then
    return ""
  end
  local numColor = maxValue <= curValue and ItemQuality2ColorDic[5] or ItemQuality2ColorDic[27]
  if _type == nil or _type == EConsumableStrType.All then
    return string.GetColorText(curValue .. "/" .. maxValue, numColor)
  elseif _type == EConsumableStrType.Normal then
    return string.GetColorText(curValue, numColor) .. "/" .. maxValue
  end
end

function ColorUtility.HexToColor(hex)
  hex = string.gsub(hex, "#", "")
  local r = tonumber(string.sub(hex, 1, 2), 16) / 255
  local g = tonumber(string.sub(hex, 3, 4), 16) / 255
  local b = tonumber(string.sub(hex, 5, 6), 16) / 255
  return Color(r, g, b)
end

function ColorUtility.HexToHexCode(hex)
  hex = string.gsub(hex, "#", "")
  local colorInt = tonumber(hex, 16)
  local hexCode = string.format("0x%XFF", colorInt)
  return hexCode
end

function ColorUtility.StrToHexColorStr(str)
  local targetColorStr = string.match(str, "#%x*")
  if string.isNullOrEmpty(targetColorStr) then
    return str
  end
  return string.format("0x%sFF", string.sub(targetColorStr, 2))
end
