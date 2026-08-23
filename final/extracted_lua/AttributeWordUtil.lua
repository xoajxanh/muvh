AttributeWordUtil = {}
local this = AttributeWordUtil

function AttributeWordUtil.GetUIWord(attrKey, wordType, prefix, fix)
  prefix = prefix or ""
  fix = fix or ""
  attrKey = string.format("%s%s%s", prefix, attrKey, fix)
  local config = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(attrKey)
  if config == nil then
    return
  end
  return config[wordType]
end

function AttributeWordUtil.GetUIWordNew(attrKey, wordType, minValue, maxValue)
  local config = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(attrKey)
  if not string.isNullOrEmpty(config.equipConstant) then
    if config.equipConstant == EquipAttributeCalculateType.Ratio and attrKey ~= "attackSpeed" and attrKey ~= "physAndWizDmgLevel" then
      return string.format(config[wordType], MathUtility.FormatNum(minValue / 100), "%", MathUtility.FormatNum(maxValue / 100), "%")
    elseif config.equipConstant == EquipAttributeCalculateType.Constant or attrKey == "attackSpeed" or attrKey == "physAndWizDmgLevel" then
      return string.format(config[wordType], minValue, maxValue)
    end
  end
end
