local GoodFiftsEveryDayData = {}
setmetatable(GoodFiftsEveryDayData, LuaClass.CommerceActivity)
GoodFiftsEveryDayData.Commerce_goodgift = nil

function GoodFiftsEveryDayData:InitData()
end

function GoodFiftsEveryDayData:RefreshDataByServerData()
  EventManager.Dispatch(Event.GoodFiftsEveryDayRefesh)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.combineActivity_GoodFiftsEveryDay
  })
end

function GoodFiftsEveryDayData:GetBoxDatas(enough)
  if table.isNullOrEmpty(enough) then
    return {}
  end
  local giftTbl = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(enough.reward))
  if table.isNullOrEmpty(giftTbl) then
    return {}
  end
  return ClientTable.cfg_Box_boxManager:TryGetTabListByType(giftTbl.reward, "boxId")
end

function GoodFiftsEveryDayData:GetDataOnTheDay()
  local enough
  for i, v in pairs(ClientTable.cfg_Commerce_goodgiftManager:GetDic()) do
    if self:CheckActivityData(v.day) and self:CheckCommerceId(v.commerceId) then
      enough = v
      break
    end
  end
  return enough
end

function GoodFiftsEveryDayData:CheckCommerceId(commerceId)
  local overviewTbl = ClientTable.cfg_Commerce_overviewManager:GetTabListByType(322, "group")
  local overview
  for i, v in pairs(overviewTbl) do
    if ConditionManager.Check(v.condition) then
      overview = v
      break
    end
  end
  if overview then
    return tonumber(overview.commerceId) == tonumber(commerceId)
  end
end

function GoodFiftsEveryDayData:IsBeenGet(enough)
  if table.isNullOrEmpty(enough) then
    return true
  end
  local giftTbl = ClientTable.cfg_Gift_giftManager:TryGetValue(tonumber(enough.reward))
  if table.isNullOrEmpty(giftTbl) then
    return {}
  end
  local countData = RefreshData.GetRefreshByKey(giftTbl.countKey)
  return countData ~= nil and countData.count >= 1
end

function GoodFiftsEveryDayData:GetFiftsEveryData(enough)
  if table.isNullOrEmpty(enough) then
    return true
  end
  NetManager.Send(RechargeMessage.ReqGetGift, {
    id = {
      tonumber(enough.reward)
    }
  })
end

function GoodFiftsEveryDayData:CheckActivityData(day)
  return tonumber(day) == TimeUtility.GetCommerceDay()
end

function GoodFiftsEveryDayData:RedPointCheck()
  return not self:IsBeenGet(self:GetDataOnTheDay())
end

return GoodFiftsEveryDayData
