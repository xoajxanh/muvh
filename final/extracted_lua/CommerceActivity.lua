local CommerceActivity = {}
setmetatable(CommerceActivity, LuaClass.ActivityDataBase)

function CommerceActivity:GetCommerce_CombineoverviewTbl()
  return self.activityTbl
end

function CommerceActivity:GetCommerce_CombineActivityConfigList()
  if self.Commerce_CombineActivityConfigList == nil then
    self.Commerce_CombineActivityConfigList = {}
    if self:GetCommerce_CombineoverviewTbl() == nil then
      return self.Commerce_CombineActivityConfigList
    end
    local commerceIdType = type(self:GetCommerce_CombineoverviewTbl().commerceId)
    if commerceIdType == "number" then
      self.Commerce_CombineActivityConfigList[self:GetCommerce_CombineoverviewTbl().commerceId] = ClientTable.cfg_Commerce_overviewManager:TryGetValue(self:GetCommerce_CombineoverviewTbl().commerceId)
    elseif commerceIdType == "table" then
      for k, v in pairs(self:GetCommerce_CombineoverviewTbl().commerceId) do
        self.Commerce_CombineActivityConfigList[v] = ClientTable.cfg_Commerce_overviewManager:TryGetValue(v)
      end
    end
  end
  return self.Commerce_CombineActivityConfigList
end

function CommerceActivity:GetFirstCommerce_CombineActivityConfig()
  local activityOverViewTblList = self:GetCommerce_CombineActivityConfigList()
  if type(activityOverViewTblList) ~= "table" then
    return
  end
  return activityOverViewTblList[next(activityOverViewTblList)]
end

function CommerceActivity:GetRedPointTbl()
  if self.redPointTbl == nil and self:GetCommerce_CombineoverviewTbl().redpointid > 0 then
    self.redPointTbl = ClientTable.cfg_Red_pointManager:TryGetValue(self:GetCommerce_CombineoverviewTbl().redpointid)
  end
  return self.redPointTbl
end

function CommerceActivity:GetRemainTimeDes()
  if self:GetActivityState() ~= ActivityStatusEnum.RUNNING then
    return "S\225\187\177 ki\225\187\135n ch\198\176a m\225\187\159"
  end
  local serverTime, endTime = Time.GetServerTime(), self:GetEndTimeStamp()
  if serverTime >= endTime or self:GetCommerce_CombineoverviewTbl() == nil or string.isNullOrEmpty(self:GetCommerce_CombineoverviewTbl().countdownText) then
    return ""
  end
  return string.format(self:GetCommerce_CombineoverviewTbl().countdownText, TimeUtility.ShowTime((endTime - serverTime) * 0.001))
end

function CommerceActivity:GetCommerceType()
  if self:GetFirstCommerce_CombineActivityConfig() == nil then
    return
  end
  return self:GetFirstCommerce_CombineActivityConfig().commerceType
end

function CommerceActivity:GetActivityId()
  if self:GetCommerce_CombineoverviewTbl() then
    return self:GetCommerce_CombineoverviewTbl().activityId
  end
end

function CommerceActivity:GetSingleOpenTimeConfig()
  if self:GetFirstCommerce_CombineActivityConfig() == nil then
    return
  end
  return self:GetFirstCommerce_CombineActivityConfig().condition
end

function CommerceActivity:GetOpenTimeDesFormat()
  return "Th\225\187\157i gian m\225\187\159: %H: %M: %S"
end

function CommerceActivity:GetActivityName()
  return self:GetCommerce_CombineoverviewTbl().combineActivityName
end

return CommerceActivity
