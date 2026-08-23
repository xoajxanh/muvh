ConditionBase = class()
ConditionBase.comparatorMap = {}
setgetters(ConditionBase, {
  ConditionType = function(self)
    return self.type * 100 + self.compareType
  end
})

function ConditionBase:ctor(compareType, param)
  self.compareType = compareType
  self.comparator = self:GetComparator(compareType)
  self:InitParam(param)
end

function ConditionBase:InitParam(param)
  self.param = param
end

function ConditionBase:GetComparator(compareType)
  assert(self.comparatorMap[compareType], string.format("%d%s ch\198\176a \196\145\198\176\225\187\163c \196\145\225\187\139nh ngh\196\169a", self.type, compareType))
  return self.comparatorMap[compareType]
end

function ConditionBase:Check()
  return self:comparator()
end

function ConditionBase:ReSet(compareType, param)
  self.compareType = compareType
  self.comparator = self:GetComparator(compareType)
  self:InitParam(param)
end
