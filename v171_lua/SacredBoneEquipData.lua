local SacredBoneEquipData = {}
SacredBoneEquipData.SacredBoneIndex = nil
SacredBoneEquipData.SacredBoneData = nil
SacredBoneEquipData.SacredBoneName = nil

function SacredBoneEquipData:InitData(holeIndex)
  self.SacredBoneIndex = holeIndex
  self.SacredBoneName = HolySkeletonPlaceName[holeIndex]
  self:SacredBoneReset()
end

function SacredBoneEquipData:SacredBoneReset()
  self.SacredBoneData = {}
  for hole = 1, self:EquipSacredBoneCount() do
    if self.SacredBoneData[hole] == nil then
      local sacredBoneData = LuaClass.SacredBoneData:New()
      sacredBoneData:InitData(hole)
      self.SacredBoneData[hole] = sacredBoneData
    end
  end
end

function SacredBoneEquipData:RemoveSacredBoneItemData()
  self.SacredBoneEquip = nil
end

function SacredBoneEquipData:EquipSacredBoneCount()
  return 7
end

return SacredBoneEquipData
