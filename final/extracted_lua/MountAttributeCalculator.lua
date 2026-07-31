MountAttributeCalculator = {}
local this = MountAttributeCalculator
local ACTIVE_FLAG = "disable_"

function MountAttributeCalculator.CalcMountAttributes(mountData)
  local mountCount = table.count(mountData.Mounts)
  local result
  for i = 1, mountCount do
    result = AttributeConfig.MergeAttributeMap(result, this.CalcSingleMountAttribute(mountData.Mounts[i]))
  end
  return result
end

local mountDataAttr = {}

function MountAttributeCalculator.CalcSingleMountAttribute(mountData)
  local attrMap = this.CalcActivedAttribute(mountData)
  if mountData.valid then
    attrMap = AttributeConfig.MergeAttributeMap(attrMap, this.CalcMountedSingleAttribute(mountData, mountDataAttr))
  end
  return attrMap
end

function MountAttributeCalculator.CalcMountedSingleAttribute(mountData, resultTable)
  return AttributeConfig.GetTableAttributes(mountData.tblEquip, resultTable)
end

function MountAttributeCalculator.CalcActivedAttribute(mountData)
  local attrMap = {}
  local isAttr, attrName
  local metaTbl = getmetatable(mountData.tblEquip)
  for k, v in pairs(metaTbl.__index) do
    isAttr, attrName = this.IsActivedAttribute(k)
    if isAttr then
      attrMap[attrName] = v
    end
  end
  for k, v in pairs(mountData.tblEquip) do
    isAttr, attrName = this.IsActivedAttribute(k)
    if isAttr then
      attrMap[attrName] = v
    end
  end
  return attrMap
end

function MountAttributeCalculator.IsActivedAttribute(attrName)
  if string.startsWith(attrName, ACTIVE_FLAG) then
    attrName = string.replace(attrName, ACTIVE_FLAG, "")
    return AttributeConfig.IsAttribute(attrName), attrName
  end
end
