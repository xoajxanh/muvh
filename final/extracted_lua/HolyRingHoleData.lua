local HolyRingHoleData = {}
HolyRingHoleData.HoleIndex = nil
HolyRingHoleData.UnlockState = false
HolyRingHoleData.HolyRingHoleItemData = nil
HolyRingHoleData.HolyRingAddition = 0

function HolyRingHoleData:InitData(holeIndex)
  self.HoleIndex = holeIndex
end

function HolyRingHoleData:RefreshUnlockState(state)
  self.UnlockState = state
end

function HolyRingHoleData:RefreshHolyRingHoleItemData(data)
  if data == nil then
    return
  end
  if self.HolyRingHoleItemData == nil then
    local holyRingHoleItemData = LuaClass.HolyRingHoleItemData:New()
    self.HolyRingHoleItemData = holyRingHoleItemData
  end
  self.HolyRingHoleItemData:RefreshData(data)
end

function HolyRingHoleData:RemoveHolyRingHoleItemData()
  self.HolyRingHoleItemData = nil
end

function HolyRingHoleData:RefreshHolyRingAddition(addition)
  if addition == nil then
    return
  end
  self.HolyRingAddition = addition / 10
end

function HolyRingHoleData:GetHolyRingHoleIndex()
  if self.HoleIndex == nil then
    CS.UnityEngine.Debug.LogError("\230\156\170\229\136\157\229\167\139\229\140\150\229\173\148\228\189\141 self.HoleIndex")
    return
  end
  return self.HoleIndex
end

function HolyRingHoleData:GetHolyRingHoleItemData()
  return self.HolyRingHoleItemData
end

function HolyRingHoleData:GetHolyRingHoleUnlockState()
  return self.UnlockState
end

function HolyRingHoleData:GetHolyRingAddition()
  return self.HolyRingAddition
end

return HolyRingHoleData
