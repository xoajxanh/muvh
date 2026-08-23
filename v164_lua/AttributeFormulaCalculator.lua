AttributeFormulaCalculator = {}
local AttributeFormulaConfig
local this = AttributeFormulaCalculator
this.attackSpeedUIRatio = 0
local attackSpeedGlobal = {}
local paramMultiRatioTable = {default = 1.0E-7}

local function GetParamMultiRatio(attrName)
  return paramMultiRatioTable[attrName] or paramMultiRatioTable.default
end

local function getKey(career, attEnum)
  return string.format("%d%s", career, attEnum)
end

local function Init()
  this.attackSpeedUIRatio = ClientTable.cfg_Global_globalManager:TryGetValue(2430003, "id").effect / 100000000
  local attackSpeedStr = ClientTable.cfg_Global_globalManager:TryGetValue(2430001, "id").effect
  attackSpeedStr = string.split(attackSpeedStr, "&")
  for i = 1, #attackSpeedStr do
    local item = string.split(attackSpeedStr[i], "#")
    attackSpeedGlobal[tonumber(item[1])] = tonumber(item[2])
  end
  local tbl = ConfigManager.GetConfigTable("cfg_AttributeFormula")
  local key
  AttributeFormulaConfig = {}
  for _, v in pairs(tbl) do
    key = getKey(v.career, v.field)
    AttributeFormulaConfig[key] = v
  end
end

local function getConfig(career, attType)
  local key = getKey(career, attType)
  return AttributeFormulaConfig[key]
end

local function calcExtraAttr(baseVal, ratio, paramMultiRatio)
  if ratio == nil or ratio == 0 or baseVal == 0 then
    return 0
  end
  local ratioAbs = math.abs(ratio)
  local result = 0
  result = baseVal * ratioAbs * paramMultiRatio
  if ratio < 0 then
    result = result * baseVal
  end
  return result
end

local function getExtraAttrMap(baseAttr, formulaItem, baseAttrMap, considerEx)
  if formulaItem == nil or baseAttr == 0 then
    return {}
  end
  local extraAttr = {}
  local key, exmul, exadd, paramMultiRatio
  for k, _ in pairs(C_AttributeFormula_Attributes) do
    paramMultiRatio = GetParamMultiRatio(k)
    extraAttr[k] = calcExtraAttr(baseAttr, formulaItem[k], paramMultiRatio)
    if considerEx then
      exmul = baseAttrMap[k .. CAttributeFixFlag.EXMUL] and baseAttrMap[k .. CAttributeFixFlag.EXMUL] * AttributeConfig.MULTIRATIO_RATIO or 0
      exadd = baseAttrMap[k .. CAttributeFixFlag.EXADD] or 0
      extraAttr[k] = extraAttr[k] * (1 + exmul) + exadd
    end
    key = k .. CAttributeFixFlag.MUL
    extraAttr[key] = calcExtraAttr(baseAttr, formulaItem[key], paramMultiRatio)
    key = k .. CAttributeFixFlag.FADD
    extraAttr[key] = calcExtraAttr(baseAttr, formulaItem[key], paramMultiRatio)
  end
  return extraAttr
end

local function addExtraMap2BaseMap(baseMap, extraMap, reason)
  if extraMap == nil then
    return
  end
  for k, v in pairs(extraMap) do
    if EAttributeType[k] == EAttributeType.attackSpeed then
      baseMap.attackSpeedIncrease = baseMap.attackSpeedIncrease and baseMap.attackSpeedIncrease * (1 + v) or 1 + v
    else
      baseMap[k] = baseMap[k] and baseMap[k] + v or v
    end
  end
end

local function DealWithServersDifference()
end

function AttributeFormulaCalculator.CalcFinalAttribute(career, attrMap)
  if not attrMap then
    return
  end
  local baseAttrMapResult = table.clone(attrMap)
  local result = {}
  local formulaItem, key, base, mul, fAdd, baseAttr, relativeAttr, paramMultiRatio, extraAttr
  for k, _ in pairs(attrMap) do
    formulaItem = getConfig(0, k)
    if formulaItem then
      key = formulaItem.field
      base = attrMap[key] or 0
      key = formulaItem.field .. CAttributeFixFlag.MUL
      mul = attrMap[key] or 0
      key = formulaItem.field .. CAttributeFixFlag.FADD
      fAdd = attrMap[key] or 0
      baseAttr = base * (1 + mul * AttributeConfig.MULTIRATIO_RATIO) + fAdd
      key = formulaItem.secField
      base = attrMap[key] or 0
      key = formulaItem.secField .. CAttributeFixFlag.MUL
      mul = attrMap[key] or 0
      key = formulaItem.secField .. CAttributeFixFlag.FADD
      fAdd = attrMap[key] or 0
      relativeAttr = base * (1 + mul * AttributeConfig.MULTIRATIO_RATIO) + fAdd
      relativeAttr = 0 < relativeAttr and relativeAttr or 1
      baseAttr = baseAttr * relativeAttr
      extraAttr = getExtraAttrMap(baseAttr, formulaItem, attrMap)
      addExtraMap2BaseMap(baseAttrMapResult, extraAttr, {
        funcName = "parisattrMap1",
        targetEnum = k
      })
    end
    formulaItem = getConfig(career, k)
    if formulaItem then
      key = formulaItem.field
      base = attrMap[key] or 0
      key = formulaItem.field .. CAttributeFixFlag.MUL
      mul = attrMap[key] or 0
      key = formulaItem.field .. CAttributeFixFlag.FADD
      fAdd = attrMap[key] or 0
      baseAttr = base * (1 + mul * AttributeConfig.MULTIRATIO_RATIO) + fAdd
      key = formulaItem.secField
      base = attrMap[key] or 0
      key = formulaItem.secField .. CAttributeFixFlag.MUL
      mul = attrMap[key] or 0
      key = formulaItem.secField .. CAttributeFixFlag.FADD
      fAdd = attrMap[key] or 0
      relativeAttr = base * (1 + mul * AttributeConfig.MULTIRATIO_RATIO) + fAdd
      relativeAttr = 0 < relativeAttr and relativeAttr or 1
      baseAttr = baseAttr * relativeAttr
      extraAttr = getExtraAttrMap(baseAttr, formulaItem, attrMap, true)
      if EAttributeType.agility == EAttributeType[k] then
        extraAttr.attackSpeed = baseAttr * attackSpeedGlobal[career] * GetParamMultiRatio(k) * 0.1
      end
      addExtraMap2BaseMap(baseAttrMapResult, extraAttr, {
        funcName = "parisattrMap2",
        targetEnum = k
      })
    end
  end
  for k, _ in pairs(baseAttrMapResult) do
    if EAttributeType[k] ~= nil then
      base = baseAttrMapResult[k] or 0
      key = k .. CAttributeFixFlag.MUL
      mul = baseAttrMapResult[key] or 0
      key = k .. CAttributeFixFlag.FADD
      fAdd = baseAttrMapResult[key] or 0
      local calcRes = base
      if EAttributeType[k] == EAttributeType.attackSpeedIncrease then
        local oneHandSpeed = baseAttrMapResult.oneHandedWeaponIncRate or 0
        oneHandSpeed = oneHandSpeed * AttributeConfig.MULTIRATIO_RATIO
        if oneHandSpeed then
          base = base * (1 + oneHandSpeed)
        end
        calcRes = base * (1 + mul * AttributeConfig.MULTIRATIO_RATIO) + fAdd
        calcRes = math.floor(calcRes * 10000)
        result[EAttributeType[k]] = calcRes
        result[EAttributeType.attackSpeedCalculateValue] = calcRes * 1.0E-4
        result[EAttributeType.attackSpeedUI] = calcRes * 0.01
      else
        calcRes = base * (1 + mul * AttributeConfig.MULTIRATIO_RATIO) + fAdd
        result[EAttributeType[k]] = math.floor(calcRes)
        if EAttributeType[k] == EAttributeType.extraDamage then
          result[EAttributeType.monsterAttackPlayerDamageAbsorption] = result[EAttributeType[k]] * 0.01
          result[EAttributeType.extraDamageCalculateValue] = result[EAttributeType[k]] * 1.0E-4
        end
      end
      key = ClientServersDifferenceAttributeToServerKey[k]
      if key then
        result[key] = (1 - baseAttrMapResult[key]) * 10000
      end
    end
  end
  return result
end

Init()
