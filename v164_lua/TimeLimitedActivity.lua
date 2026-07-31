local TimeLimitedActivity = {}
setmetatable(TimeLimitedActivity, LuaClass.ActivityDataBase)

function TimeLimitedActivity:GetCommerce_TimeLimitedoverviewTbl()
  return self.activityTbl
end

function TimeLimitedActivity:GetCommerce_TimeLimitedActivityConfigList()
  if self.Commerce_CombineActivityConfigList == nil then
    self.Commerce_CombineActivityConfigList = {}
    if self:GetCommerce_TimeLimitedoverviewTbl() == nil then
      return self.Commerce_CombineActivityConfigList
    end
    local commerceIdType = type(self:GetCommerce_TimeLimitedoverviewTbl().commerceId)
    if commerceIdType == "number" then
      self.Commerce_CombineActivityConfigList[self:GetCommerce_TimeLimitedoverviewTbl().commerceId] = ClientTable.cfg_Commerce_overviewManager:TryGetValue(self:GetCommerce_TimeLimitedoverviewTbl().commerceId)
    elseif commerceIdType == "table" then
      for k, v in pairs(self:GetCommerce_TimeLimitedoverviewTbl().commerceId) do
        self.Commerce_CombineActivityConfigList[v] = ClientTable.cfg_Commerce_overviewManager:TryGetValue(v)
      end
    end
  end
  return self.Commerce_CombineActivityConfigList
end

function TimeLimitedActivity:GetFirstCommerce_TimeLimitedActivityConfig()
  local activityOverViewTblList = self:GetCommerce_TimeLimitedActivityConfigList()
  if type(activityOverViewTblList) ~= "table" then
    return
  end
  return activityOverViewTblList[next(activityOverViewTblList)]
end

function TimeLimitedActivity:GetRedPointTbl()
  if self.redPointTbl == nil and self:GetCommerce_TimeLimitedoverviewTbl().redpointid > 0 then
    self.redPointTbl = ClientTable.cfg_Red_pointManager:TryGetValue(self:GetCommerce_TimeLimitedoverviewTbl().redpointid)
  end
  return self.redPointTbl
end

function TimeLimitedActivity:GetRemainTimeDes()
  local text = type(self.activityTbl.Text) == "string" and self.activityTbl.Text or "S\225\187\177 ki\225\187\135n ch\198\176a m\225\187\159"
  if self:GetActivityState() ~= ActivityStatusEnum.RUNNING then
    return text
  end
  local serverTime, endTime = Time.GetServerTime(), self:GetEndTimeStamp()
  if serverTime >= endTime or self:GetCommerce_TimeLimitedoverviewTbl() == nil or string.isNullOrEmpty(self:GetCommerce_TimeLimitedoverviewTbl().countdownText) then
    return ""
  end
  return string.format(self:GetCommerce_TimeLimitedoverviewTbl().countdownText, TimeUtility.ShowDayHourMin((endTime - serverTime) * 0.001))
end

function TimeLimitedActivity:GetOpenDay()
  if self:GetActivityState() ~= ActivityStatusEnum.RUNNING then
    return 0
  end
  local condition = self:GetSingleOpenTimeConfig()
  local timeStrArray
  for i, config in ipairs(condition) do
    if config[1] == EConditionEnum.timeActivityBetween then
      timeStrArray = string.split(config[2], "-")
      break
    end
  end
  local openTime = TimeUtility.AnalyseActivityYearMonthDayTime(timeStrArray and timeStrArray[1])
  local serverTime = Time.GetServerTime()
  if openTime > serverTime then
    return 0
  end
  return math.floor((serverTime - openTime) / TimeUtility.DayStamp) + 1
end

function TimeLimitedActivity:GetCommerceType()
  if self:GetFirstCommerce_TimeLimitedActivityConfig() == nil then
    return
  end
  return self:GetFirstCommerce_TimeLimitedActivityConfig().commerceType
end

function TimeLimitedActivity:GetRechargeCondition()
  if self:GetCommerce_TimeLimitedoverviewTbl() and self:GetCommerce_TimeLimitedoverviewTbl().rechargeId then
    local rechargeId
    if type(self:GetCommerce_TimeLimitedoverviewTbl().rechargeId) == "number" then
      rechargeId = self:GetCommerce_TimeLimitedoverviewTbl().rechargeId
    elseif type(self:GetCommerce_TimeLimitedoverviewTbl().rechargeId) == "table" then
      for i, v in pairs(self:GetCommerce_TimeLimitedoverviewTbl().rechargeId) do
        rechargeId = v
        break
      end
    end
    local rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(rechargeId)
    if rechargeCfg and rechargeCfg.showCondition then
      return rechargeCfg.showCondition
    end
  end
end

function TimeLimitedActivity:GetActivityId()
  return self:GetCommerce_TimeLimitedoverviewTbl().activityId
end

function TimeLimitedActivity:GetOpenTimeConfig()
  local condition = self:GetRechargeCondition()
  if condition then
    return condition
  end
  if self.condition4D == nil then
    self.condition4D = {}
    local activityOverViewTblList = self:GetCommerce_TimeLimitedActivityConfigList()
    if type(activityOverViewTblList) ~= "table" then
      return {
        {
          {}
        }
      }
    end
    for k, overViewTbl in pairs(activityOverViewTblList) do
      table.insert(self.condition4D, overViewTbl.condition)
    end
  end
  return self.condition4D
end

function TimeLimitedActivity:GetOpenTimeDesFormat()
  return "Th\225\187\157i gian m\225\187\159: %H: %M: %S"
end

function TimeLimitedActivity:GetActivityName()
  return self:GetCommerce_TimeLimitedoverviewTbl().combineActivityName
end

return TimeLimitedActivity
