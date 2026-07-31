local SpringActivityManger = {}
setmetatable(SpringActivityManger, LuaClass.HolidayActivity)
SpringActivityManger.data = {}

function SpringActivityManger:RefreshSpringActivity(data)
  if not data then
    return
  end
  self.data = data
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_Denglu
  })
  EventManager.Dispatch(Event.SpringActivityItemDataChange)
end

function SpringActivityManger:RefreshSpringData()
  if not self.data then
    return
  end
  return self.data
end

function SpringActivityManger:RefreshSpringRedPoint()
  if not self.data then
    return
  end
  if not self.data.qianDaoInfos then
    return
  end
  for i, v in ipairs(self.data.qianDaoInfos) do
    if not v.hasReward and v.count <= v.current then
      return true
    end
  end
  return false
end

return SpringActivityManger
