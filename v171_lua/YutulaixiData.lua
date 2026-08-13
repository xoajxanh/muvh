local YutulaixiData = {}
setmetatable(YutulaixiData, LuaClass.HolidayActivity)

function YutulaixiData:Init()
  self:InitData()
end

function YutulaixiData:InitData()
  self.data = nil
  local recharge = ClientTable.cfg_Commerce_globalManager:TryGetValue(314001)
  self.rechargeCfg = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(tonumber(recharge.effect))
end

function YutulaixiData:RefreshServerData(data)
  self.data = data
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.holidayActivity_Yutulaixi
  })
  EventManager.Dispatch(Event.PetInvestRefresh)
end

function YutulaixiData:GetData()
  return self.data
end

function YutulaixiData:CheckIsShowRedPoint()
  if self.data == nil or self.rechargeCfg == nil then
    return false
  end
  return RefreshData.GetLimitCount(self.rechargeCfg.countKey) < 1 and not self.data.isReceive
end

function YutulaixiData:ResetActivityData()
end

return YutulaixiData
