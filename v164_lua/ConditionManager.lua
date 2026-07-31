require("GamePlay/Condition/ConditionBase")
require("GamePlay/Condition/LevelCondition")
require("GamePlay/Condition/CareerCondition")
require("GamePlay/Condition/StrengthCondition")
require("GamePlay/Condition/AgilityCondition")
require("GamePlay/Condition/EnergyCondition")
require("GamePlay/Condition/VitalityCondition")
require("GamePlay/Condition/LeaderShipCondition")
require("GamePlay/Condition/LegionCondition")
require("GamePlay/Condition/TimeCondition")
require("GamePlay/Condition/ItemCondition")
require("GamePlay/Condition/ItemIntensifyCondition")
require("GamePlay/Condition/ItemAdditionCondition")
require("GamePlay/Condition/TaskCondition")
require("GamePlay/Condition/CellCondition")
require("GamePlay/Condition/StoneCondition")
require("GamePlay/Condition/SkillCondition")
require("GamePlay/Condition/CountCondition")
require("GamePlay/Condition/SkillLimitCondition")
require("GamePlay/Condition/ActivityCondition")
require("GamePlay/Condition/TaskGoalCondition")
require("GamePlay/Condition/FalseCondition")
require("GamePlay/Condition/ItemUseCondition")
require("GamePlay/Condition/CombatPowerCondition")
require("GamePlay/Condition/RechargePointCondition")
require("GamePlay/Condition/ChannelCondition")
require("GamePlay/Condition/MemberCondition")
require("GamePlay/Condition/JewelryCondition")
require("GamePlay/Condition/RechargeCondition")
require("GamePlay/Condition/AttributeCondition")
require("GamePlay/Condition/IntensifyCondition")
require("GamePlay/Condition/GemCondition")
require("GamePlay/Condition/WingQualityCondition")
require("GamePlay/Condition/GuardCondition")
require("GamePlay/Condition/HolySpiritCondition")
require("GamePlay/Condition/ReincarnationLevelCondition")
ConditionManager = {}
local ConditionInstances = {}
local this = ConditionManager
local excuterMap = {}

function ConditionManager.GenerateSingleCondition(singleCondition)
  if type(singleCondition) == "table" then
    local stype = tonumber(singleCondition[1])
    local param = singleCondition[2]
    local classNum = math.floor(stype / 100)
    local comparatorNum = stype % 100
    if ConditionManager.IsServerConditionType(classNum) then
      return
    end
    local instance = ConditionManager.SearchConditionInistance(classNum)
    if instance ~= nil then
      instance:ReSet(comparatorNum, param)
    else
      local excuter = excuterMap[classNum]
      if excuter then
        instance = excuter(comparatorNum, param)
      else
        logError(string.format("\196\144i\225\187\129u ki\225\187\135n ki\225\187\131u %s kh\195\180ng t\225\187\147n t\225\186\161i..tham s\225\187\145..%s", classNum, tostring(param)))
      end
      ConditionInstances[classNum] = instance
    end
    return instance
  else
    local strs = string.split(singleCondition, "#")
    local stype = tonumber(strs[1])
    local param = string.replace(singleCondition, strs[1] .. "#", "")
    local classNum = math.floor(stype / 100)
    local comparatorNum = stype % 100
    if ConditionManager.IsServerConditionType(classNum) then
      return
    end
    local instance = ConditionManager.SearchConditionInistance(classNum)
    if instance ~= nil then
      instance:ReSet(comparatorNum, param)
    else
      local excuter = excuterMap[classNum]
      instance = excuter(comparatorNum, param)
      ConditionInstances[classNum] = instance
    end
    return instance
  end
end

function ConditionManager.Init()
  this.RegistExcuters()
end

function ConditionManager.RegistExcuters()
  this.RegistExcuter(1, LevelCondition)
  this.RegistExcuter(2, CareerCondition)
  this.RegistExcuter(3, StrengthCondition)
  this.RegistExcuter(4, AgilityCondition)
  this.RegistExcuter(5, EnergyCondition)
  this.RegistExcuter(6, VitalityCondition)
  this.RegistExcuter(7, LeaderShipCondition)
  this.RegistExcuter(8, LegionCondition)
  this.RegistExcuter(9, TimeCondition)
  this.RegistExcuter(10, ItemConditon)
  this.RegistExcuter(11, CellCondition)
  this.RegistExcuter(12, StoneCondition)
  this.RegistExcuter(13, SkillCondition)
  this.RegistExcuter(15, TaskCondition)
  this.RegistExcuter(16, TaskGoalCondition)
  this.RegistExcuter(17, SkillLimitCondition)
  this.RegistExcuter(18, ActivityCondition)
  this.RegistExcuter(20, ItemIntensifyConditon)
  this.RegistExcuter(21, ItemAdditionConditon)
  this.RegistExcuter(22, ItemUseCondition)
  this.RegistExcuter(23, RechargePointCondition)
  this.RegistExcuter(24, CountCondition)
  this.RegistExcuter(26, JewelryCondition)
  this.RegistExcuter(27, CombatPowerCondition)
  this.RegistExcuter(30, ChannelCondition)
  this.RegistExcuter(31, MemberCondition)
  this.RegistExcuter(32, WingQualityCondition)
  this.RegistExcuter(33, AttributeCondition)
  this.RegistExcuter(34, IntensifyCondition)
  this.RegistExcuter(35, GemCondition)
  this.RegistExcuter(40, RechargeCondition)
  this.RegistExcuter(60, GuardCondition)
  this.RegistExcuter(70, ReincarnationLevelCondition)
  this.RegistExcuter(80, HolySpiritCondition)
  this.RegistExcuter(99, FalseCondition)
end

function ConditionManager.RegistExcuter(head, class)
  excuterMap[head] = class
  class.type = head
end

function ConditionManager.Check(conditionCfg, otherParams)
  if type(conditionCfg) == "table" then
    local singleStrs = conditionCfg
    local andResult = true
    local conditonInstance
    for j = 1, #singleStrs do
      conditonInstance = this.GenerateSingleCondition(singleStrs[j])
      andResult = andResult and conditonInstance:Check(otherParams)
      if andResult == false then
        return andResult
      end
    end
    return andResult
  else
    local groupStr = string.split(conditionCfg, "/")
    local result = false
    local conditonInstance
    for i = 1, #groupStr do
      local singleStrs = string.split(groupStr[i], "&")
      local andResult = true
      for j = 1, #singleStrs do
        conditonInstance = this.GenerateSingleCondition(singleStrs[j])
        andResult = andResult and conditonInstance:Check(otherParams)
      end
      result = result or andResult
      if result then
        break
      end
    end
    return result
  end
end

function ConditionManager.Check4D(conditionCfg, otherParams)
  if type(conditionCfg) == "table" then
    local groupStr = conditionCfg
    local result = false
    local conditonInstance
    for i = 1, #groupStr do
      local singleStrs = groupStr[i]
      local andResult = true
      for j = 1, #singleStrs do
        conditonInstance = this.GenerateSingleCondition(singleStrs[j])
        if conditonInstance and andResult then
          andResult = conditonInstance:Check(otherParams)
        end
      end
      result = result or andResult
      if result then
        break
      end
    end
    return result
  else
    local groupStr = string.split(conditionCfg, "/")
    local result = false
    local conditonInstance
    for i = 1, #groupStr do
      local singleStrs = string.split(groupStr[i], "&")
      local andResult = true
      for j = 1, #singleStrs do
        conditonInstance = this.GenerateSingleCondition(singleStrs[j])
        andResult = andResult and conditonInstance:Check(otherParams)
      end
      result = result or andResult
      if result then
        break
      end
    end
    return result
  end
end

function ConditionManager.SearchConditionInistance(clasenum)
  if ConditionInstances[clasenum] ~= nil then
    return ConditionInstances[clasenum]
  end
  return nil
end

function ConditionManager.SearchCondition(conditions, cType)
  if not table.isArray(conditions) then
    logError("SearchCondition requires an array as collection")
    return
  end
  for i = 1, #conditions do
    if conditions[i].ConditionType == cType then
      return conditions[i]
    end
  end
end

function ConditionManager.IsServerConditionType(type)
  return type == 19
end

this.Init()
