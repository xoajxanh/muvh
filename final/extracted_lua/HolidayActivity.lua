local HolidayActivity = {}
setmetatable(HolidayActivity, LuaClass.ActivityDataBase)

function HolidayActivity:GetCommerce_HolidayoverviewTbl()
  return self.activityTbl
end

function HolidayActivity:GetCommerce_HolidayActivityConfigList()
  if self.Commerce_CombineActivityConfigList == nil then
    self.Commerce_CombineActivityConfigList = {}
    if self:GetCommerce_HolidayoverviewTbl() == nil then
      return self.Commerce_CombineActivityConfigList
    end
    local commerceIdType = type(self:GetCommerce_HolidayoverviewTbl().commerceId)
    if commerceIdType == "number" then
      self.Commerce_CombineActivityConfigList[self:GetCommerce_HolidayoverviewTbl().commerceId] = ClientTable.cfg_Commerce_overviewManager:TryGetValue(self:GetCommerce_HolidayoverviewTbl().commerceId)
    elseif commerceIdType == "table" then
      for k, v in pairs(self:GetCommerce_HolidayoverviewTbl().commerceId) do
        self.Commerce_CombineActivityConfigList[v] = ClientTable.cfg_Commerce_overviewManager:TryGetValue(v)
      end
    end
  end
  return self.Commerce_CombineActivityConfigList
end

function HolidayActivity:GetFirstCommerce_HolidayActivityConfig()
  local activityOverViewTblList = self:GetCommerce_HolidayActivityConfigList()
  if type(activityOverViewTblList) ~= "table" then
    return
  end
  return activityOverViewTblList[next(activityOverViewTblList)]
end

function HolidayActivity:GetFirstConditionCommerce_HolidayActivityConfig()
  local activityOverViewTblList = self:GetCommerce_HolidayActivityConfigList()
  if type(activityOverViewTblList) ~= "table" then
    return
  end
  for i, tbl in pairs(activityOverViewTblList) do
    if ConditionManager.Check(tbl.condition) then
      return tbl
    end
  end
  return activityOverViewTblList[next(activityOverViewTblList)]
end

function HolidayActivity:GetRedPointTbl()
  if self.redPointTbl == nil and self:GetCommerce_HolidayoverviewTbl().redpointid > 0 then
    self.redPointTbl = ClientTable.cfg_Red_pointManager:TryGetValue(self:GetCommerce_HolidayoverviewTbl().redpointid)
  end
  return self.redPointTbl
end

function HolidayActivity:GetRemainTimeDes()
  if self:GetActivityState() ~= ActivityStatusEnum.RUNNING then
    return "S\225\187\177 ki\225\187\135n ch\198\176a m\225\187\159"
  end
  local serverTime, endTime = Time.GetServerTime(), self:GetEndTimeStamp()
  if serverTime >= endTime or self:GetCommerce_HolidayoverviewTbl() == nil or string.isNullOrEmpty(self:GetCommerce_HolidayoverviewTbl().countdownText) then
    return ""
  end
  return string.format(self:GetCommerce_HolidayoverviewTbl().countdownText, TimeUtility.ShowDayHourMin((endTime - serverTime) * 0.001))
end

function HolidayActivity:GetOpenDay()
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

function HolidayActivity:GetActivityId()
  return self:GetCommerce_HolidayoverviewTbl().activityId
end

function HolidayActivity:GetSingleOpenTimeConfig()
  if self:GetFirstCommerce_HolidayActivityConfig() == nil then
    return
  end
  return self:GetFirstCommerce_HolidayActivityConfig().condition
end

function HolidayActivity:GetOpenTimeDesFormat()
  return "Th\225\187\157i gian m\225\187\159: %H: %M: %S"
end

function HolidayActivity:GetActivityName()
  return self:GetCommerce_HolidayoverviewTbl().combineActivityName
end

return HolidayActivity
