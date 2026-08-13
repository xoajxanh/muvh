MemberCondition = class(ConditionBase)
setgetters(MemberCondition, {
  memberLevel = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetMemberLevle()
  end,
  temporaryMemberLevel = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetMemberDataMgr():GetTemporaryMemberLevle()
  end
})
MemberCondition.comparatorMap = {
  [0] = function(self)
    return self.memberLevel > self.param
  end,
  [1] = function(self)
    return self.memberLevel >= self.param
  end,
  [2] = function(self)
    return self.memberLevel == self.param
  end,
  [3] = function(self)
    return self.memberLevel <= self.param
  end,
  [4] = function(self)
    return self.memberLevel < self.param
  end,
  [10] = function(self)
    return self.temporaryMemberLevel > self.param
  end,
  [11] = function(self)
    return self.temporaryMemberLevel >= self.param
  end,
  [12] = function(self)
    return self.temporaryMemberLevel == self.param
  end,
  [13] = function(self)
    return self.temporaryMemberLevel <= self.param
  end,
  [14] = function(self)
    return self.temporaryMemberLevel < self.param
  end
}

function MemberCondition:InitParam(param)
  self.param = tonumber(param)
end
