local InlayDataManager = {}

function InlayDataManager:Init()
  self.mLightStoneCellInfo = {}
  self:GetRedPointMgr():Initialize()
end

function InlayDataManager:GetRedPointMgr()
  if self.mRedPointMgr == nil then
    self.mRedPointMgr = LuaClass.InlayRedPointDataManager:New({inlayDataMgr = self})
  end
  return self.mRedPointMgr
end

function InlayDataManager:SetLightStoneCellInfo(_tblData)
  if _tblData == nil or _tblData.cellInfo == nil then
    return
  end
  self.mLightStoneCellInfo = {}
  for key, value in pairs(_tblData.cellInfo) do
    self.mLightStoneCellInfo[value.index] = value
  end
  EventManager.Dispatch(Event.Equip_StonePosChange)
end

function InlayDataManager:GetCellInfoByStoneIndex(_stoneIndex)
  if self.mLightStoneCellInfo == nil or table.count(self.mLightStoneCellInfo) == 0 then
    return
  end
  return self.mLightStoneCellInfo[_stoneIndex]
end

return InlayDataManager
