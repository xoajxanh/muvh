AttributeCondition = class(ConditionBase)
setgetters(AttributeCondition, {})
AttributeCondition.comparatorMap = {
  [0] = function(self)
    return self.targetNum == nil or self:GetAttributeValue() > self.targetNum
  end,
  [1] = function(self)
    return self.targetNum == nil or self:GetAttributeValue() >= self.targetNum
  end,
  [2] = function(self)
    return self.targetNum == nil or self:GetAttributeValue() == self.targetNum
  end,
  [3] = function(self)
    return self.targetNum == nil or self:GetAttributeValue() <= self.targetNum
  end,
  [4] = function(self)
    return self.targetNum == nil or self:GetAttributeValue() < self.targetNum
  end
}

function AttributeCondition:InitParam(param)
  local tbl = string.split(param, "#")
  if table.count(tbl) > 1 then
    self.attributeType = tonumber(tbl[1])
    self.targetNum = tonumber(tbl[2])
  end
end

function AttributeCondition:GetAttributeValue()
  if self.attributeType == nil or gameMgr:GetAvatarManager():GetMainPlayer() == nil or gameMgr:GetAvatarManager():GetMainPlayer():GetInfo() == nil then
    return 0
  end
  return gameMgr:GetAvatarManager():GetMainPlayer():GetInfo():TryGetAttrValue(self.attributeType)
end
