AttributeUtility = {}

function AttributeUtility.GetAttributeFormatDes(attributeName)
  if attributeName == "healthRecoveryMultiplier" then
    return "+%d%%"
  elseif attributeName == "minimumPhysBaseDmg" or attributeName == "minimumWizBaseDmg" or attributeName == "career_minimumPhysBaseDmg" or attributeName == "career_minimumWizBaseDmg" or attributeName == "career_minimumCurseBaseDmg" then
    return "%d~%d"
  else
    return "+%d"
  end
end

function AttributeUtility.GetAttributeValue(value, career)
  if type(value) == "string" or type(value) == "number" then
    return tonumber(value)
  end
  if type(value) == "table" and career ~= nil then
    for k, v in pairs(value) do
      if type(v) ~= "table" or #v < 2 then
        break
      end
      if v[1] == career then
        return v[2]
      end
    end
  end
  return 0
end
