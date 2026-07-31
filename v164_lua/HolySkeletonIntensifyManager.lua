require("GameConst/HolySkeletonEnum")
local HolySkeletonIntensifyManager = {}
HolySkeletonIntensifyManager.HolySkeletonIntensifyPlaceDataList = {}

function HolySkeletonIntensifyManager:Init()
  self:PlaceIntensifyDataReset()
end

function HolySkeletonIntensifyManager:PlaceIntensifyDataReset()
  self.HolySkeletonIntensifyPlaceDataList = {}
  for i, v in pairs(HolySkeletonPlace) do
    if self.HolySkeletonIntensifyPlaceDataList[v] == nil then
      local holySkeletonIntensifyPlaceData = LuaClass.HolySkeletonIntensifyPlaceData:New()
      holySkeletonIntensifyPlaceData:InitRefreshData(v)
      self.HolySkeletonIntensifyPlaceDataList[v] = holySkeletonIntensifyPlaceData
    end
  end
end

function HolySkeletonIntensifyManager:InitRefreshData(tblData)
  self:PlaceIntensifyDataReset()
  for i, v in pairs(tblData.holyBoneInfo) do
    if self.HolySkeletonIntensifyPlaceDataList[v.type] ~= nil then
      self.HolySkeletonIntensifyPlaceDataList[v.type]:RefreshData(v)
    end
  end
end

function HolySkeletonIntensifyManager:ChangeRefreshData(tblData)
  if self.HolySkeletonIntensifyPlaceDataList[tblData.type] ~= nil then
    self.HolySkeletonIntensifyPlaceDataList[tblData.type]:RefreshData(tblData)
  end
  EventManager.Dispatch(Event.RefreshHolySkeletonIntensify)
end

function HolySkeletonIntensifyManager:GetHolySkeletonIntensifyPlaceDataList()
  return self.HolySkeletonIntensifyPlaceDataList
end

function HolySkeletonIntensifyManager:GetFistHolySkeletonIntensifyPlace()
  local minMaterialCount = 9999
  local minPlace = HolySkeletonPlace.Head
  for place, placeData in ipairs(self.HolySkeletonIntensifyPlaceDataList) do
    if placeData:CheckIsMax() ~= true and placeData:GetPlaceMaterialData() ~= nil and minMaterialCount > placeData:GetPlaceMaterialData()[1].count then
      minMaterialCount = placeData:GetPlaceMaterialData()[1].count
      minPlace = place
    end
  end
  return minPlace
end

function HolySkeletonIntensifyManager:CheckHolySkeletonIntensifyPlaceRedPoint(place)
  local isShow = true
  if self.HolySkeletonIntensifyPlaceDataList[place]:CheckIsMax() == true then
    isShow = false
  else
    local materialData = self.HolySkeletonIntensifyPlaceDataList[place]:GetPlaceMaterialData()
    for i, v in pairs(materialData) do
      if BagInfoData.GetItemTotalCountByItemId(v.itemId) < v.count then
        isShow = false
        break
      end
    end
  end
  return isShow
end

function HolySkeletonIntensifyManager:CheckHolySkeletonIntensifyRedPoint()
  for i, v in ipairs(self.HolySkeletonIntensifyPlaceDataList) do
    local isShow = true
    if v:CheckIsMax() == true then
      isShow = false
    else
      local materialData = v:GetPlaceMaterialData()
      for x, y in pairs(materialData) do
        if BagInfoData.GetItemTotalCountByItemId(y.itemId) < y.count then
          isShow = false
          break
        end
      end
    end
    if isShow == true then
      return isShow
    end
  end
  return false
end

return HolySkeletonIntensifyManager
