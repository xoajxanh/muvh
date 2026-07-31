AttributeConfig = {}
local this = AttributeConfig
AttributeConfig.MULTIRATIO_RATIO = 1.0E-4
local key_key = {
  maximumHealth_mul = "maximumHealth",
  attackRatePvm_mul = "attackRatePvm",
  maximumMana_mul = "maximumMana",
  maximumWizBaseDmg_mul = "maximumWizBaseDmg",
  minimumWizBaseDmg_mul = "minimumWizBaseDmg",
  moveSpeed_mul = "moveSpeed"
}

function AttributeConfig.IsFakeAttribute(attrType)
  return C_Fake_Attributes[attrType] ~= nil
end

local LEVEL = "level"
local LEVEL_LENGTH = #LEVEL

function AttributeConfig.IsAttribute(attrType)
  if #attrType == LEVEL_LENGTH and string.lower(attrType) == LEVEL then
    return false
  end
  local curType = key_key[attrType]
  if curType ~= nil then
    return EAttributeType[curType] ~= nil
  end
  curType = attrType
  attrType = string.replace(attrType, CAttributeFixFlag.MUL, "")
  attrType = string.replace(attrType, CAttributeFixFlag.FADD, "")
  attrType = string.replace(attrType, CAttributeFixFlag.EXMUL, "")
  attrType = string.replace(attrType, CAttributeFixFlag.EXADD, "")
  key_key[curType] = attrType
  return EAttributeType[attrType] ~= nil
end

function AttributeConfig.IsAttributeNew(attrType)
  return EAttributeClientNew[attrType] ~= nil
end

function AttributeConfig.IsRatioAttribute(attrNameOrVal)
  return table.containsKey(CRatioAttributes, attrNameOrVal) or table.contains(CRatioAttributes, attrNameOrVal)
end

function AttributeConfig.GetAttribute_Multi(attrType)
  if this.IsAttribute(attrType) then
    return attrType .. CAttributeFixFlag.MUL
  end
  return nil
end

function AttributeConfig.GetAttribute_AbsAdd(attrType)
  if this.IsAttribute(attrType) then
    return attrType .. CAttributeFixFlag.FADD
  end
  return nil
end

function AttributeConfig.MergeAttributeMap(source, sub, career)
  source = source or {}
  if sub == nil then
    return {}
  end
  for k, v in pairs(sub) do
    if type(v) ~= "string" then
      if EAttributeType[k] == EAttributeType.staticMoveSpeed then
        source[k] = source[k] and (v < source[k] and source[k] or v) or v
      elseif not string.contains(k, "server_") then
        local nowValue = v
        if type(v) == "table" then
          nowValue = RoleEquipUtility.GetCareerHP(v)
          nowValue = 0
        end
        source[k] = source[k] and source[k] + nowValue or nowValue
      end
      local key = ClientServersDifferenceAttributeToServerKey[k]
      if key then
        sub[key] = sub[key] and sub[key] or 1
        source[key] = source[key] and source[key] * sub[key] or sub[key]
      end
    end
  end
  return source
end

function AttributeConfig.SingleAttributeMap(source, sub)
  source = source or {}
  if sub == nil then
    return {}
  end
  for k, v in pairs(sub) do
    if 0 < v then
      table.insert(source, {k = k, v = v})
    end
  end
  return source
end

function AttributeConfig.MergeMultiAttributeMap(source, subs)
  source = source or {}
  for _, v in pairs(subs) do
    AttributeConfig.MergeAttributeMap(source, v)
  end
  return source
end

function AttributeConfig.GetPreviewAttrMap(roleCareer, previewExtraSysAttrMap)
  if previewExtraSysAttrMap == nil or table.count(previewExtraSysAttrMap) <= 0 then
    return nil
  end
  local previewSumAttrMap = table.copy(nil, previewExtraSysAttrMap)
  return AttributeFormulaCalculator.CalcFinalAttribute(roleCareer, previewSumAttrMap)
end

function AttributeConfig.GetTableAttributes(tbl, resultTable)
  local attrMap = resultTable or {}
  local metaTbl = getmetatable(tbl)
  if metaTbl then
    for k, v in pairs(metaTbl.__index) do
      if this.IsAttribute(k) or this.IsAttributeNew(k) then
        attrMap[k] = v
      end
      local key = ClientServersDifferenceAttributeToServerKey[k]
      if key then
        attrMap[key] = 1 - v * 1.0E-4
      end
    end
  end
  if tbl then
    for k, v in pairs(tbl) do
      if this.IsAttribute(k) or this.IsAttributeNew(k) then
        attrMap[k] = v
      end
      local key = ClientServersDifferenceAttributeToServerKey[k]
      if key then
        attrMap[key] = 1 - v * 1.0E-4
      end
    end
  end
  return attrMap
end

function AttributeConfig.GetNamingAttributes(tbl, resultTable)
  local attrMap = resultTable or {}
  local metaTbl = getmetatable(tbl)
  if metaTbl then
    for k, v in pairs(metaTbl.__index) do
      if this.IsAttribute(k) or this.IsAttributeNew(k) then
        attrMap[k] = v
      end
      local key = ClientServersDifferenceAttributeToServerKey[k]
      if key then
        attrMap[key] = 1 - v * 1.0E-4
      end
    end
  end
  if tbl then
    for k, v in pairs(tbl) do
      if this.IsNamingAttribute(k) or this.IsAttributeNew(k) then
        attrMap[k] = v
      end
      local key = ClientServersDifferenceAttributeToServerKey[k]
      if key then
        attrMap[key] = 1 - v * 1.0E-4
      end
    end
  end
  return attrMap
end

local ACTIVE_FLAG = "disable_"

function AttributeConfig.IsNamingAttribute(attrType)
  if #attrType == LEVEL_LENGTH and string.lower(attrType) == LEVEL then
    return false
  end
  local curType = key_key[attrType]
  if curType ~= nil then
    if string.startsWith(curType, ACTIVE_FLAG) then
      curType = string.replace(curType, ACTIVE_FLAG, "")
    end
    return EAttributeType[curType] ~= nil
  end
  curType = attrType
  attrType = string.replace(attrType, CAttributeFixFlag.MUL, "")
  attrType = string.replace(attrType, CAttributeFixFlag.FADD, "")
  attrType = string.replace(attrType, CAttributeFixFlag.EXMUL, "")
  attrType = string.replace(attrType, CAttributeFixFlag.EXADD, "")
  key_key[curType] = attrType
  return EAttributeType[attrType] ~= nil
end
