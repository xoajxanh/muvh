local RechargeActivity = {}
setmetatable(RechargeActivity, LuaClass.ActivityDataBase)

function RechargeActivity:GetCommerce_RechargeoverviewTbl()
  return self.activityTbl
end

function RechargeActivity:GetCommerce_RechargeActivityConfigList()
  if self.Commerce_RechargeActivityConfigList == nil then
    self.Commerce_RechargeActivityConfigList = {}
    if self:GetCommerce_RechargeoverviewTbl() == nil then
      return self.Commerce_RechargeActivityConfigList
    end
    local rechargeIdType = type(self:GetCommerce_RechargeoverviewTbl().rechargeId)
    if rechargeIdType == "number" then
      self.Commerce_RechargeActivityConfigList[self:GetCommerce_RechargeoverviewTbl().rechargeId] = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(self:GetCommerce_RechargeoverviewTbl().rechargeId)
    elseif rechargeIdType == "table" then
      for k, v in pairs(self:GetCommerce_RechargeoverviewTbl().rechargeId) do
        self.Commerce_RechargeActivityConfigList[v] = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(v)
      end
    end
  end
  return self.Commerce_RechargeActivityConfigList
end

function RechargeActivity:GetFirstCommerce_RechargeActivityConfig()
  local activityOverViewTblList = self:GetCommerce_RechargeActivityConfigList()
  if type(activityOverViewTblList) ~= "table" then
    return
  end
  return activityOverViewTblList[next(activityOverViewTblList)]
end

function RechargeActivity:GetRedPointTbl()
  if self.redPointTbl == nil and self:GetCommerce_RechargeoverviewTbl().redpointid > 0 then
    self.redPointTbl = ClientTable.cfg_Red_pointManager:TryGetValue(self:GetCommerce_RechargeoverviewTbl().redpointid)
  end
  return self.redPointTbl
end

function RechargeActivity:GetRemainTimeDes(isIcon)
  if self:GetActivityState() ~= ActivityStatusEnum.RUNNING then
    return isIcon and "" or "S\225\187\177 ki\225\187\135n \196\145\195\163 k\225\186\191t th\195\186c"
  end
  local serverTime, endTime = Time.GetServerTime(), self:GetEndTimeStamp()
  if serverTime >= endTime or self:GetCommerce_RechargeoverviewTbl() == nil or string.isNullOrEmpty(self:GetCommerce_RechargeoverviewTbl().countdownText) then
    return ""
  end
  local des = TimeUtility.ShowTime((endTime - serverTime) * 0.001)
  return isIcon and des or string.format(self:GetCommerce_RechargeoverviewTbl().countdownText, des)
end

function RechargeActivity:GetActivityId()
  return self:GetCommerce_RechargeoverviewTbl().activityId
end

function RechargeActivity:GetOpenTimeConfig()
  if self:GetFirstCommerce_RechargeActivityConfig() == nil then
    return
  end
  return self:GetFirstCommerce_RechargeActivityConfig().showCondition
end

function RechargeActivity:GetOpenTimeDesFormat()
  return "Th\225\187\157i gian m\225\187\159: %H: %M: %S"
end

function RechargeActivity:GetActivityName()
  return self:GetCommerce_RechargeoverviewTbl().ActivityName
end

return RechargeActivity
