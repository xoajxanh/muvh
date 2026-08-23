local HolySkeletonIntensifyHoleData = {}
HolySkeletonIntensifyHoleData.Place = nil
HolySkeletonIntensifyHoleData.Hole = nil
HolySkeletonIntensifyHoleData.HolyType = nil
HolySkeletonIntensifyHoleData.Items = nil
HolySkeletonIntensifyHoleData.IsUnlock = nil
HolySkeletonIntensifyHoleData.IsShowUI = nil
HolySkeletonIntensifyHoleData.UnlockGrade = nil

function HolySkeletonIntensifyHoleData:InitRefreshData(place, hole, curUnlockHole)
  self.Place = place
  self.Hole = hole
  self.HolyType = hole == 1 and HolySkeletonHoleType.Big or HolySkeletonHoleType.Small
  self.IsUnlock = hole <= curUnlockHole
  self.IsShowUI = curUnlockHole + 1 == hole
  self.UnlockGrade = ClientTable.cfg_Bone_castManager:GetUnlockGradeByTypeAndHole(hole)
end

function HolySkeletonIntensifyHoleData:RefreshData(items)
  self.Items = items
  self.IsUnlock = true
  self.IsShowUI = false
end

function HolySkeletonIntensifyHoleData:SetIsShowUI(isShowUI)
  self.IsShowUI = isShowUI
end

return HolySkeletonIntensifyHoleData
