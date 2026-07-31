RoleBasicAttributeCalculator = {}

local function GetInitDataByLevelTable(career, attrMap)
  local atrrInitDataBylevel = ConfigManager.cfg_Character_attribute_level_List[attrMap.level]
  local item
  if atrrInitDataBylevel ~= nil then
    for k, v in pairs(atrrInitDataBylevel) do
      local careers = string.split(v.career, "#")
      for i = 1, #careers do
        if tonumber(careers[i]) == career then
          item = v
        end
      end
    end
  end
  if item then
    for k, v in pairs(EAttributeType) do
      local attr = item[k]
      if attr then
        attrMap[k] = item[k]
      end
      attr = item[k .. "_mul"]
      if attr then
        attrMap[k .. "_mul"] = item[k .. "_mul"]
      end
    end
  end
end

function RoleBasicAttributeCalculator.CalcAttribute(career, attrPointMap)
  local charaConfig = ClientTable.cfg_Character_attributeManager:TryGetValue(career)
  local result = {}
  AttributeConfig.GetTableAttributes(charaConfig, result)
  result = AttributeConfig.MergeAttributeMap(result, attrPointMap)
  GetInitDataByLevelTable(career, result)
  return result
end
