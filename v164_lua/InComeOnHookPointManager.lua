local InComeOnHookPointManager = {}

function InComeOnHookPointManager:GetInComePointList()
  if self.mInComePointList == nil then
    self.mInComePointList = {}
  end
  return self.mInComePointList
end

function InComeOnHookPointManager:RefreshData(data)
  if data == nil then
    return
  end
  self:ResetPointList()
  self:RefreshPointList(data.mapHangUpPoint)
end

function InComeOnHookPointManager:RefreshPointList(dataList)
  if dataList == nil then
    return
  end
  self.tblCount = table.count(self:GetInComePointList())
  local count = table.count(dataList)
  for i = 1, count do
    self:SetInComePointItem(i, dataList[i])
  end
  EventManager.Dispatch(Event.InComePointDataChanged)
end

function InComeOnHookPointManager:SetInComePointItem(index, data)
  if index > self.tblCount then
    local pointItem = self:NewInComePointItem()
    table.insert(self:GetInComePointList(), pointItem)
  end
  local pointItem = self:GetInComePointList()[index]
  pointItem.x = data.x
  pointItem.y = data.y
  pointItem.type = data.profitType
  pointItem.value = data.profitValue
  pointItem.state = true
end

function InComeOnHookPointManager:NewInComePointItem()
  return {
    x = 0,
    y = 0,
    value = 0,
    name = "",
    state = false,
    type = EInComeOnHookPointSubType.ExpInComePoint
  }
end

function InComeOnHookPointManager:ResetPointList()
  for i, v in pairs(self:GetInComePointList()) do
    if v then
      v.state = false
    end
  end
end

function InComeOnHookPointManager:GetSpriteNameByType(type)
  return "ico_onhook_" .. tostring(type)
end

function InComeOnHookPointManager:OnDestruct()
  for i, v in pairs(self:GetInComePointList()) do
    v = nil
  end
  self:RunBaseFunction("OnDestruct")
end

return InComeOnHookPointManager
