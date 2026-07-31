local HolidayInvestData = {}
setmetatable(HolidayInvestData, LuaClass.HolidayActivity)
HolidayInvestData.HolidayInvestDataList = nil

function HolidayInvestData:RefreshDataByServerData(serverData)
  self.HolidayInvestDataList = {}
  if serverData ~= nil and serverData.investInfo ~= nil then
    self.HolidayInvestDataList = serverData.investInfo
  end
  EventManager.Dispatch(Event.ResHolidayInvest)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_HolidayInvest
  })
end

function HolidayInvestData:GetHolidayInvestDataList()
  return self.HolidayInvestDataList
end

function HolidayInvestData:GetFirstPositionData()
  local minPositionData = self.HolidayInvestDataList[1]
  for index, itemPositionData in pairs(self.HolidayInvestDataList) do
    if itemPositionData.position < minPositionData.position then
      minPositionData = itemPositionData
    end
  end
  return minPositionData
end

function HolidayInvestData:GetPositionHolidayInvestData(position)
  for index, itemPositionData in pairs(self.HolidayInvestDataList) do
    if itemPositionData.position == position then
      return itemPositionData
    end
  end
end

function HolidayInvestData:PositionRedPointCheck(position)
  local holidayInvestData = self:GetPositionHolidayInvestData(position)
  for index, itemTaskData in pairs(holidayInvestData.reward) do
    local taskId = ClientTable.cfg_Commerce_holidayinvestManager:TryGetValue(itemTaskData.id).mission
    local targetCount = ClientTable.cfg_Task_goalManager:TryGetValue(taskId).goalCount
    if itemTaskData.hasReward == false and targetCount <= itemTaskData.finishCount then
      return true
    end
  end
  return false
end

function HolidayInvestData:AllRedPointCheck()
  if self.HolidayInvestDataList and table.count(self.HolidayInvestDataList) > 0 then
    for index, itemPositionData in pairs(self.HolidayInvestDataList) do
      if itemPositionData and 0 < table.count(itemPositionData.reward) then
        for index, itemTaskData in pairs(itemPositionData.reward) do
          local taskId = ClientTable.cfg_Commerce_holidayinvestManager:TryGetValue(itemTaskData.id).mission
          local targetCount = ClientTable.cfg_Task_goalManager:TryGetValue(taskId).goalCount
          if itemTaskData.hasReward == false and targetCount <= itemTaskData.finishCount then
            return true
          end
        end
      end
    end
  end
  return false
end

return HolidayInvestData
