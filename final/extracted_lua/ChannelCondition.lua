ChannelCondition = class(ConditionBase)
setgetters(ChannelCondition, {
  externalNet = function(self)
    return LoginData.externalNet
  end,
  operId = function()
    return LoginData.operId
  end,
  pId = function()
    return LoginData.pId
  end,
  internalPId = function()
    return LoginData.internalPId
  end
})
ChannelCondition.comparatorMap = {
  [1] = function(self)
    if self.externalNet then
      return self.param == self.operId
    else
      return true
    end
  end,
  [2] = function(self)
    if self.externalNet then
      return self.param == self.pId
    else
      return self.param == self.internalPId
    end
  end
}

function ChannelCondition:InitParam(param)
  self.param = tonumber(param)
end
