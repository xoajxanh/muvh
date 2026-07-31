local HolySkeletonIntensifyPlaceData = {}
HolySkeletonIntensifyPlaceData.Place = nil
HolySkeletonIntensifyPlaceData.PlaceGrade = nil
HolySkeletonIntensifyPlaceData.CurUnlockHole = nil
HolySkeletonIntensifyPlaceData.HolySkeletonIntensifyHoleDataList = nil

function HolySkeletonIntensifyPlaceData:InitRefreshData(type)
  self.Place = type
  self.PlaceGrade = 0
  self.CurUnlockHole = 1
  self.IsMax = false
  self.HolySkeletonIntensifyHoleDataList = {}
  for holeIndex = 1, 7 do
    if self.HolySkeletonIntensifyHoleDataList[holeIndex] == nil then
      local holySkeletonIntensifyHoleData = LuaClass.HolySkeletonIntensifyHoleData:New()
      holySkeletonIntensifyHoleData:InitRefreshData(self.Place, holeIndex, self.CurUnlockHole)
      self.HolySkeletonIntensifyHoleDataList[holeIndex] = holySkeletonIntensifyHoleData
    end
  end
end

function HolySkeletonIntensifyPlaceData:RefreshData(tblData)
  self.PlaceGrade = tblData.grade
  for i, v in pairs(tblData.holyBoneGap) do
    if self.HolySkeletonIntensifyHoleDataList[v.id] ~= nil then
      self.HolySkeletonIntensifyHoleDataList[v.id]:RefreshData(v.items)
    end
    self.CurUnlockHole = math.max(self.CurUnlockHole, v.id)
  end
  if self.HolySkeletonIntensifyHoleDataList[self.CurUnlockHole + 1] ~= nil then
    self.HolySkeletonIntensifyHoleDataList[self.CurUnlockHole + 1]:SetIsShowUI(true)
  end
end

function HolySkeletonIntensifyPlaceData:GetPlaceAttributeList()
  local allAttributeInfo = {}
  local itemAttributeInfo
  local cfgTab, nextCfgTab = ClientTable.cfg_Bone_castManager:GetConfigByTypeAndId(self.Place, self.PlaceGrade), ClientTable.cfg_Bone_castManager:GetConfigByTypeAndId(self.Place, self.PlaceGrade + 1)
  for k, v in pairs(HolySkeletonIntensifyAttribute) do
    local curValue = TableParse:GetAttributeValueDes(cfgTab, v.attributeConfigName)
    if not string.isNullOrEmpty(curValue) then
      itemAttributeInfo = {}
      itemAttributeInfo.name = v.attributeName
      itemAttributeInfo.curValue = curValue
      itemAttributeInfo.nextIsNil = nextCfgTab == nil
      if nextCfgTab ~= nil then
        itemAttributeInfo.nextValue = TableParse:GetAttributeValueDes(nextCfgTab, v.attributeConfigName)
      end
      table.insert(allAttributeInfo, itemAttributeInfo)
    end
  end
  return allAttributeInfo
end

function HolySkeletonIntensifyPlaceData:GetPlaceGrade()
  return tonumber(self.PlaceGrade)
end

function HolySkeletonIntensifyPlaceData:GetHolySkeletonIntensifyHoleDataList()
  return self.HolySkeletonIntensifyHoleDataList
end

function HolySkeletonIntensifyPlaceData:CheckIsMax()
  return ClientTable.cfg_Bone_castManager:GetConfigByTypeAndId(self.Place, self.PlaceGrade + 1) == nil
end

function HolySkeletonIntensifyPlaceData:GetPlaceMaterialData()
  local cfgTab = ClientTable.cfg_Bone_castManager:GetConfigByTypeAndId(self.Place, self.PlaceGrade + 1)
  if cfgTab ~= nil then
    return TableParse:SpliteStringToItemCountList(cfgTab.propNumber)
  end
end

return HolySkeletonIntensifyPlaceData
