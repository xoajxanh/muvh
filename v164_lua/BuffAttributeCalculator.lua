BuffAttributeCalculator = {}
local this = BuffAttributeCalculator

function BuffAttributeCalculator.CollectBuffAttribute(rid)
  local roleBuffs = BuffData.GetBuffs(rid)
  local result = {}
  for _, buff_struct in pairs(roleBuffs) do
    for key, v in pairs(buff_struct.attribute) do
      if not result[key] then
        result[key] = 0
      end
      local diffrent = false
      for k, val in pairs(ClientServersDifferenceAttribute) do
        if key == val then
          diffrent = true
          break
        end
      end
      if diffrent then
        if buff_struct.showAttribute then
          if buff_struct.showAttribute[key] then
            result[key] = result[key] + buff_struct.showAttribute[key]
          else
            result[key] = result[key] + 0
          end
        else
          logError(string.format("buff %s kh\195\180ng t\225\187\147n t\225\186\161i, kh\195\180ng th\225\187\131 hi\225\187\131n th\225\187\139 thu\225\187\153c t\195\173nh %", buff_struct.buffCId, key))
          result[key] = result[key] + v
        end
      else
        result[key] = result[key] + v
      end
    end
  end
  result[122] = nil
  return result
end

function BuffAttributeCalculator.CalcBuffAttribute(rid)
  local roleBuffs = BuffData.GetBuffs(rid)
  local result = {}
  local resultMoveSpeed_mul = 1
  local addMoveSpeed_mul = 0
  local subAttackSpeedIncrease = 1
  local addAttackSpeedIncrease = 0
  for _, buff_struct in pairs(roleBuffs) do
    if 0 < table.count(buff_struct.buffConfig.attribute) then
      local attrMap = this.CalcSingleBuffAttribute(buff_struct.buffConfig.attribute)
      local moveSpeed_mul = attrMap.moveSpeed_mul and attrMap.moveSpeed_mul or 0
      local subAttackSpeed = attrMap.attackSpeedIncrease and attrMap.attackSpeedIncrease or 0
      if moveSpeed_mul < 0 then
        moveSpeed_mul = moveSpeed_mul * AttributeConfig.MULTIRATIO_RATIO
        resultMoveSpeed_mul = resultMoveSpeed_mul * (1 + moveSpeed_mul)
      else
        addMoveSpeed_mul = addMoveSpeed_mul + moveSpeed_mul * AttributeConfig.MULTIRATIO_RATIO
      end
      if subAttackSpeed < 0 then
        subAttackSpeed = subAttackSpeed * AttributeConfig.MULTIRATIO_RATIO
        subAttackSpeedIncrease = subAttackSpeedIncrease * (1 + subAttackSpeed)
      else
        addAttackSpeedIncrease = addAttackSpeedIncrease + subAttackSpeed
      end
      result = AttributeConfig.MergeAttributeMap(result, attrMap)
    end
  end
  result.moveSpeed_mul = math.floor((addMoveSpeed_mul - (1 - resultMoveSpeed_mul)) * 10000)
  result.attackSpeedIncrease_fAdd = addAttackSpeedIncrease - (1 - subAttackSpeedIncrease)
  result.attackSpeedIncrease = 0
  return result
end

function BuffAttributeCalculator.CalcSingleBuffAttribute(attributeMap)
  local attrMap = {}
  local isAttr, attrName
  for k, v in pairs(attributeMap) do
    isAttr, attrName = AttributeConfig.IsAttribute(k), k
    if isAttr then
      attrMap[attrName] = v
    end
  end
  return attrMap
end
