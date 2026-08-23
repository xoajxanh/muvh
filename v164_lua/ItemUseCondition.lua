ItemUseCondition = class(ConditionBase)
setgetters(ItemUseCondition, {
  groupId = function(self)
    return SceneData.groupId
  end
})
ItemUseCondition.comparatorMap = {
  [1] = function(self)
    return self.param == self.groupId
  end,
  [2] = function(self)
    return self.param ~= self.groupId
  end
}

function ItemUseCondition:InitParam(param)
  self.param = tonumber(param)
end
