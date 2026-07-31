function string.stringToNumberArray(srcStr, sep)
  local paramStrs = string.split(srcStr, sep)
  
  local result = {}
  for i = 1, #paramStrs do
    table.insert(result, tonumber(paramStrs[i]))
  end
  return result
end
