local Active_TurntableUIDataMgr = {}
Active_TurntableUIDataMgr.turntableData = {}

function Active_TurntableUIDataMgr:GetturntableData(data)
  if data then
    self.turntableData = data
  end
  EventManager.Dispatch(Event.TurntableUI)
  RedPointChecker_Ext:HolidayRedPointRefreshState({
    redId = CommerceHolidayRedTogType[CommercializeHolidayGrop.TurntableType],
    state = self:CheckIsShowRedPoint()
  })
  CommercialHolidayData.RedPointTogRefresh(CommercializeHolidayGrop.TurntableType)
end

function Active_TurntableUIDataMgr:CheckIsShowRedPoint()
  return self.turntableData and self.turntableData.hasCount and self.turntableData.hasCount > 0 or false
end

return Active_TurntableUIDataMgr
