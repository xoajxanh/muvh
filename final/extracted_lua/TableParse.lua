local TableParse = {}

function TableParse:SplitStringToStrList(str, sep)
  local newTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c)
      table.insert(newTbl, c)
    end)
  end
  return newTbl
end

function TableParse:SplitStringToIntList(str, sep)
  local newTbl = {}
  local num = 0
  if str then
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c)
      num = tonumber(c)
      table.insert(newTbl, num or 0)
    end)
  end
  return newTbl
end

function TableParse:SplitStringToStrListList(str, sep1, sep2)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", sep1)
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    pattern = string.format("([^%s]+)", sep2)
    for i, v in pairs(sepTbl) do
      local temp = {}
      string.gsub(v, pattern, function(c)
        table.insert(temp, c)
      end)
      table.insert(newTbl, temp)
    end
  end
  return newTbl
end

function TableParse:SplitStringToIntListList(str, sep1, sep2)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", sep1)
    local num = 0
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    pattern = string.format("([^%s]+)", sep2)
    for i, v in pairs(sepTbl) do
      local temp = {}
      string.gsub(v, pattern, function(c)
        num = tonumber(c)
        table.insert(temp, num or 0)
      end)
      table.insert(newTbl, temp)
    end
  end
  return newTbl
end

function TableParse:SpliteStringToItemCountList(str)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", "&")
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    local totalCount = table.count(sepTbl)
    pattern = string.format("([^%s]+)", "#")
    local itemStrTbl = {}
    for i = 1, totalCount do
      itemStrTbl = {}
      string.gsub(sepTbl[i], pattern, function(c)
        table.insert(itemStrTbl, c)
      end)
      if 1 < table.count(itemStrTbl) and tonumber(itemStrTbl[1]) and tonumber(itemStrTbl[2]) then
        table.insert(newTbl, {
          itemId = tonumber(itemStrTbl[1]),
          count = tonumber(itemStrTbl[2])
        })
      end
    end
  end
  return newTbl
end

function TableParse:GetBoxListChangeItemCountList(data)
  if data == nil then
    return
  end
  local ItemCountDataList = {}
  for i, v in pairs(data) do
    local itemInfo = {}
    itemInfo.itemId = v.itemId
    itemInfo.count = v.count
    table.insert(ItemCountDataList, itemInfo)
  end
  return ItemCountDataList
end

function TableParse:SpliteStringToExChangeList(str, isNeedSort)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", "&")
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    local totalCount = table.count(sepTbl)
    pattern = string.format("([^%s]+)", "#")
    local exChangeStrTbl = {}
    for i = 1, totalCount do
      exChangeStrTbl = {}
      string.gsub(sepTbl[i], pattern, function(c)
        table.insert(exChangeStrTbl, c)
      end)
      if table.count(exChangeStrTbl) > 6 then
        table.insert(newTbl, {
          gear = tonumber(exChangeStrTbl[1]) or 0,
          coinItemId = tonumber(exChangeStrTbl[2]) or 0,
          coinNum = tonumber(exChangeStrTbl[3]) or 0,
          masterExpPillItemId = tonumber(exChangeStrTbl[4]) or 0,
          masterExpPillNum = tonumber(exChangeStrTbl[5]) or 0,
          targetItemId = tonumber(exChangeStrTbl[6]) or 0,
          targetNum = tonumber(exChangeStrTbl[7]) or 0
        })
      end
    end
    if isNeedSort then
      function self.exChangeRule(a, b)
        return a and b and a.gear < b.gear
      end
      
      table.sort(newTbl, self.exChangeRule)
    end
  end
  return newTbl
end

function TableParse:SplitStringToRuneFusionPageNameList(str)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", "&")
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    local totalCount = table.count(sepTbl)
    pattern = string.format("([^%s]+)", "#")
    local runePageNameTbl = {}
    for i = 1, totalCount do
      runePageNameTbl = {}
      string.gsub(sepTbl[i], pattern, function(c)
        table.insert(runePageNameTbl, c)
      end)
      if table.count(runePageNameTbl) >= 2 then
        newTbl[tonumber(runePageNameTbl[1])] = runePageNameTbl[2]
      end
    end
  end
  return newTbl
end

function TableParse:SplitStringToMapList(str, sep1, sep2)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", sep1)
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    local totalCount = table.count(sepTbl)
    pattern = string.format("([^%s]+)", sep2)
    local mapTbl = {}
    for i = 1, totalCount do
      mapTbl = {}
      string.gsub(sepTbl[i], pattern, function(c)
        table.insert(mapTbl, c)
      end)
      if table.count(mapTbl) >= 2 then
        newTbl[tonumber(mapTbl[1])] = mapTbl[2]
      end
    end
  end
  return newTbl
end

function TableParse:SplitStringToMapListList(str, sep1, sep2, isTonumber)
  local newTbl = {}
  local sepTbl = {}
  if str then
    local pattern = string.format("([^%s]+)", sep1)
    string.gsub(str, pattern, function(c)
      table.insert(sepTbl, c)
    end)
    local totalCount = table.count(sepTbl)
    pattern = string.format("([^%s]+)", sep2)
    local mapTbl = {}
    for i = 1, totalCount do
      mapTbl = {}
      string.gsub(sepTbl[i], pattern, function(c)
        table.insert(mapTbl, c)
      end)
      if table.count(mapTbl) >= 2 then
        if newTbl[tonumber(mapTbl[1])] == nil then
          newTbl[tonumber(mapTbl[1])] = {}
        end
        for i = 2, table.count(mapTbl) do
          table.insert(newTbl[tonumber(mapTbl[1])], isTonumber and tonumber(mapTbl[i]) or mapTbl[i])
        end
      end
    end
  end
  return newTbl
end

function TableParse:GetAttributeValueDes(tbl, attributeNameList)
  local attributeConfigList = self:GetAttributeConfigList(tbl, attributeNameList)
  return self:GetMainPlayerAttributeValue(attributeConfigList)
end

function TableParse:GetAttributeConfigList(tbl, attributeNameList)
  if tbl == nil or attributeNameList == nil then
    return
  end
  local configAttributeList
  for k, v in pairs(attributeNameList) do
    local attributeConfigTbl = tbl[v]
    if type(attributeConfigTbl) == "table" then
      if configAttributeList == nil then
        configAttributeList = {}
      end
      table.insert(configAttributeList, attributeConfigTbl)
    end
  end
  return configAttributeList
end

function TableParse:GetMainPlayerAttributeValue(configAttribute)
  if type(configAttribute) ~= "table" or next(configAttribute) == nil then
    return ""
  end
  local sepTbl
  local mainPlayerCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
  local firstPattern = string.format("([^%s]+)", "&")
  local secondPattern = string.format("([^%s]+)", "#")
  local index = 1
  local attributeDes
  for k, v in pairs(configAttribute) do
    local configAttribute = v
    if type(configAttribute) == "string" then
      local curTbl = {}
      string.gsub(configAttribute, firstPattern, function(c)
        curTbl[index] = {}
        string.gsub(c, secondPattern, function(c)
          table.insert(curTbl[index], c)
        end)
        index = index + 1
      end)
      sepTbl = curTbl
    else
      sepTbl = configAttribute
    end
    if type(sepTbl) == "table" then
      for k, v in pairs(sepTbl) do
        if type(v) == "table" and 1 < #v and tonumber(v[1]) == mainPlayerCareer then
          attributeDes = string.isNullOrEmpty(attributeDes) and tostring(v[2]) or attributeDes .. " ~ " .. tostring(v[2])
          break
        end
      end
    end
  end
  return attributeDes
end

function TableParse:GetCareerAttribute(attributeList, career)
  if type(attributeList) ~= "table" or type(career) ~= "number" then
    return 0
  end
  for k, v in pairs(attributeList) do
    if 1 < #v and v[1] == career then
      return v[2]
    end
  end
end

function TableParse:GetCareerConditionAttribute(rewardStr)
  if type(rewardStr) ~= "string" then
    return 0
  end
  local itemTable = {}
  
  local function ProcessItemData(itemStr)
    local items = string.split(itemStr, "#")
    local item = {}
    item.itemId = tonumber(items[1])
    item.count = tonumber(items[2])
    return item
  end
  
  local rewardSple = string.split(rewardStr, "$")
  for i, v in ipairs(rewardSple) do
    local rewardValue = string.split(v, "_")
    local isOpen = ConditionManager.Check4D(rewardValue[1])
    if isOpen then
      local reward = string.split(rewardValue[2], "&")
      for n, m in ipairs(reward) do
        itemTable[#itemTable + 1] = ProcessItemData(m)
      end
    end
  end
  return itemTable
end

function TableParse:SplitStringToNamingList(str)
  local newTbl = {}
  if str then
    local pattern = string.split(str, "&")
    for i, v in ipairs(pattern) do
      pattern = string.split(v, "#")
      newTbl[tonumber(pattern[1])] = {}
      newTbl[tonumber(pattern[1])] = pattern[2]
    end
  end
  return newTbl
end

function TableParse:SplitStringToVectorData(str, sep, ratio)
  local newTbl = {}
  local num = 0
  local count = 0
  ratio = ratio or 1
  if str then
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(str, pattern, function(c)
      num = tonumber(c)
      if count == 0 then
        newTbl.x = num * ratio or 0
      elseif count == 1 then
        newTbl.y = num * ratio or 0
      elseif count == 2 then
        newTbl.z = num * ratio or 0
      end
      count = count + 1
    end)
  end
  return newTbl
end

function TableParse:GetValueDes(costomData)
  if costomData == nil then
    return
  end
  if costomData.minValue == nil and costomData.maxValue == nil then
    return
  end
  local minValue, maxValue, minValueDes, maxValueDes, valueDes
  local calculateType = costomData.calculateType or EquipAttributeCalculateType.Constant
  if calculateType == EquipAttributeCalculateType.Constant then
    minValueDes = costomData.minValue
    maxValueDes = costomData.maxValue
  elseif calculateType == EquipAttributeCalculateType.Ratio then
    minValue = costomData.minValue and MathUtility.FormatNum(MathUtility.FormatFloat(tonumber(costomData.minValue) * 0.01, 1))
    maxValue = costomData.maxValue and MathUtility.FormatNum(MathUtility.FormatFloat(tonumber(costomData.maxValue) * 0.01, 1))
    minValueDes = minValue and minValue .. "%"
    maxValueDes = maxValue and maxValue .. "%"
  end
  if minValueDes and maxValueDes then
    valueDes = string.format("%s ~ %s", minValueDes, maxValueDes)
  elseif minValueDes and maxValueDes == nil then
    valueDes = minValueDes
  end
  return valueDes
end

function TableParse:GetAttributeList(curLevelCfg, nextLevelCfg, checkAttributeEnum)
  if curLevelCfg == nil then
    return {}
  end
  local attributeList, attributeInfo = {}
  for k, v in ipairs(checkAttributeEnum) do
    local curMinValue, curMaxValue, nextMinValue, nextMaxValue, curValueDes, nextValueDes
    for i = 1, table.count(v.attributeConfigName) do
      local finalValue
      local tblValue = curLevelCfg[v.attributeConfigName[i]]
      if type(tblValue) == "table" then
        for k, valueTbl in pairs(tblValue) do
          if type(valueTbl) == "table" and 2 <= #valueTbl and valueTbl[1] == RoleUtility.GetBasicCareer(RoleManager.me.career) then
            finalValue = valueTbl[2]
            break
          end
        end
      elseif type(tblValue) == "number" then
        finalValue = tblValue
      end
      if i == 1 then
        curMinValue = finalValue
      elseif i == 2 then
        curMaxValue = finalValue
      end
      if nextLevelCfg then
        local finalValue
        local tblValue = nextLevelCfg[v.attributeConfigName[i]]
        if type(tblValue) == "table" then
          for k, valueTbl in pairs(tblValue) do
            if type(valueTbl) == "table" and 2 <= #valueTbl and valueTbl[1] == RoleUtility.GetBasicCareer(RoleManager.me.career) then
              finalValue = valueTbl[2]
              break
            end
          end
        elseif type(tblValue) == "number" then
          finalValue = tblValue
        end
        if i == 1 then
          nextMinValue = finalValue
        elseif i == 2 then
          nextMaxValue = finalValue
        end
      end
    end
    curValueDes = self:GetValueDes({
      minValue = curMinValue,
      maxValue = curMaxValue,
      calculateType = v.calculateType
    })
    nextValueDes = self:GetValueDes({
      minValue = nextMinValue,
      maxValue = nextMaxValue,
      calculateType = v.calculateType
    })
    local isInsert = true
    if curValueDes == nil and nextValueDes == nil or curValueDes and nextValueDes and (curValueDes == "0 ~ 0" or curValueDes == "0% ~ 0%" or curValueDes == 0 or curValueDes == "0%") and (nextValueDes == "0 ~ 0" or nextValueDes == "0% ~ 0%" or nextValueDes == 0 or nextValueDes == "0%") or curValueDes and nextValueDes == nil and (curValueDes == "0 ~ 0" or curValueDes == "0% ~ 0%" or curValueDes == 0 or curValueDes == "0%") then
      isInsert = false
    end
    if isInsert then
      attributeInfo = {}
      attributeInfo.name = v.attributeName
      attributeInfo.curValue = curValueDes
      attributeInfo.curValueColor = v.curValueColor
      attributeInfo.nextIsNil = nextLevelCfg == nil
      attributeInfo.isUp = nextLevelCfg ~= nil
      attributeInfo.nextValue = nextValueDes
      table.insert(attributeList, attributeInfo)
    end
  end
  return attributeList
end

function TableParse:GenerateAttributeNameAndValueList(curLevelCfg, checkAttributeEnum, attributeNameAndValue)
  for k, v in ipairs(checkAttributeEnum) do
    local curMinValue, curMaxValue
    for i = 1, table.count(v.attributeConfigName) do
      local finalValue
      local tblValue = curLevelCfg and curLevelCfg[v.attributeConfigName[i]]
      if type(tblValue) == "table" then
        for k, valueTbl in pairs(tblValue) do
          if type(valueTbl) == "table" and 2 <= #valueTbl and valueTbl[1] == RoleUtility.GetBasicCareer(RoleManager.me.career) then
            finalValue = valueTbl[2]
            break
          end
        end
      elseif type(tblValue) == "number" then
        finalValue = tblValue
      end
      if i == 1 then
        curMinValue = finalValue or 0
      elseif i == 2 then
        curMaxValue = finalValue or 0
      end
    end
    if attributeNameAndValue[v.attributeName] == nil then
      attributeNameAndValue[v.attributeName] = {
        minValue = curMinValue,
        maxValue = curMaxValue,
        calculateType = v.calculateType,
        sortId = k
      }
    else
      if attributeNameAndValue[v.attributeName].minValue then
        attributeNameAndValue[v.attributeName].minValue = attributeNameAndValue[v.attributeName].minValue + curMinValue
      end
      if attributeNameAndValue[v.attributeName].maxValue then
        attributeNameAndValue[v.attributeName].maxValue = attributeNameAndValue[v.attributeName].maxValue + curMaxValue
      end
    end
  end
end

function TableParse:GetAttributeNameAndValueDesList(attributeNameAndValue)
  if attributeNameAndValue == nil then
    return {}
  end
  local attributeNameAndValueDes = {}
  for attributeName, v in pairs(attributeNameAndValue) do
    local curValueDes = self:GetValueDes(v)
    local isInsert = true
    if curValueDes == nil or curValueDes == "0 ~ 0" or curValueDes == "0% ~ 0%" or curValueDes == 0 or curValueDes == "0%" then
      isInsert = false
    end
    if isInsert then
      table.insert(attributeNameAndValueDes, {
        attributeName = attributeName,
        valueDes = curValueDes,
        sortId = v.sortId
      })
    end
  end
  table.sort(attributeNameAndValueDes, function(a, b)
    return a and b and a.sortId < b.sortId or false
  end)
  return attributeNameAndValueDes
end

return TableParse
