local SuitEquipList_Base = {}
SuitEquipList_Base.EquipList = nil
SuitEquipList_Base.RecommendIntensifySuitEquip = nil

function SuitEquipList_Base:TryAddItem(data)
  if not self:IsSuitItem(data) then
    return
  end
  if data == nil or type(data.bagGridIndex) ~= "number" then
    return
  end
  if self.EquipList == nil then
    self.EquipList = {}
  end
  local suiteItem = self.EquipList[data.bagGridIndex]
  if suiteItem == nil then
    suiteItem = self:NewSuitItem(data)
  end
  suiteItem:RefreshData(data)
  self.EquipList[data.bagGridIndex] = suiteItem
end

function SuitEquipList_Base:TryRemoveItem(data)
  if not self:IsSuitItem(data) then
    return
  end
  if data == nil or type(data.bagGridIndex) ~= "number" or self.EquipList == nil then
    return
  end
  self.EquipList[data.bagGridIndex] = nil
end

function SuitEquipList_Base:ItemChange()
  self:ReCalculateRecommendData()
end

function SuitEquipList_Base:GetEquipCellTblByBagInfo(data)
  if data == nil or data.bagGridIndex == nil then
    return
  end
  return ClientTable.cfg_EquipCell_cellManager:TryGetValue(data.bagGridIndex)
end

function SuitEquipList_Base:GetEquipDataByGridIndexList(equipIndexList)
  if type(equipIndexList) ~= "table" then
    return
  end
  local equipData
  local equipDataList = {}
  for k, v in pairs(equipIndexList) do
    equipData = self:GetEquipDataByGridIndex(v)
    if equipData then
      table.insert(equipDataList, equipData)
    end
  end
  return equipDataList
end

function SuitEquipList_Base:GetEquipDataByGridIndex(equipIndex)
  if type(self.EquipList) ~= "table" then
    return
  end
  return self.EquipList[equipIndex]
end

function SuitEquipList_Base:HaveEquip()
  if type(self.EquipList) ~= "table" then
    return false
  end
  for k, v in pairs(self.EquipList) do
    local equip = v
    if equip ~= nil and equip.analysisState == true then
      return true
    end
  end
  return false
end

function SuitEquipList_Base:IsSuitItem(data)
  return false
end

function SuitEquipList_Base:NewSuitItem(data)
end

function SuitEquipList_Base:GetSuitType()
end

function SuitEquipList_Base:ClearData()
  self.EquipList = {}
end

SuitEquipList_Base.IsDirty = true

function SuitEquipList_Base:RecommendIntensifyEquipCalculate()
  if self.IsDirty == false then
    return
  end
  self.RecommendIntensifySuitEquip = nil
  local calculateEquipIndex = ClientTable.cfg_EquipCell_cellManager:GetIntensifyEquipIndex(self:GetSuitType())
  if type(calculateEquipIndex) ~= "table" then
    return
  end
  local minIntensifyLevel, defaultIntensifyEquip
  for k, v in pairs(calculateEquipIndex) do
    local suitEquipData = self:GetEquipDataByGridIndex(v.index)
    if suitEquipData ~= nil then
      if defaultIntensifyEquip == nil then
        defaultIntensifyEquip = suitEquipData
      end
      if (minIntensifyLevel == nil or minIntensifyLevel > suitEquipData:GetIntensify()) and suitEquipData:CheckEquipCanUpIntensify() then
        minIntensifyLevel = suitEquipData:GetIntensify()
        self.RecommendIntensifySuitEquip = suitEquipData
      end
    end
  end
  if self.RecommendIntensifySuitEquip == nil then
    self.RecommendIntensifySuitEquip = defaultIntensifyEquip
  end
end

function SuitEquipList_Base:ReCalculateRecommendData()
  self.IsDirty = true
end

function SuitEquipList_Base:GetRecommendIntensifyEquip()
  self:RecommendIntensifyEquipCalculate()
  return self.RecommendIntensifySuitEquip
end

function SuitEquipList_Base:CheckHaveIntensifyEquip()
  self:RecommendIntensifyEquipCalculate()
  return self.RecommendIntensifySuitEquip ~= nil and self.RecommendIntensifySuitEquip:CheckEquipCanUpIntensify()
end

return SuitEquipList_Base
