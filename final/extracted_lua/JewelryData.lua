local JewelryData = {}
JewelryData.equipIndexMin = 1000000
JewelryData.equipIndexMax = 2000000
JewelryData.dataChange = nil
JewelryData.totalLevel = nil

function JewelryData:Init()
  self.JewelryDataInfoDic = {}
end

function JewelryData:RefreshData(id, EquipDataItem)
  if self.JewelryDataInfoDic == nil then
    self.JewelryDataInfoDic = {}
  end
  if EquipDataItem == nil then
    for i, v in pairs(self.JewelryDataInfoDic) do
      if v ~= nil and v:GetLid() == id then
        self.JewelryDataInfoDic[i] = nil
        self.dataChange = true
      end
    end
    return
  end
  local equipTypeTable = EquipDataItem:GetEquipIndexTable()
  if equipTypeTable == nil or #equipTypeTable ~= 1 then
    return
  end
  local equipType = tonumber(equipTypeTable[1])
  if equipType == nil then
    return
  end
  if self:IsIncludeJewelryIndex(equipType) then
    self.JewelryDataInfoDic[equipType] = EquipDataItem
    self.dataChange = true
  end
end

function JewelryData:GetEquipIndex(jewelryType, index)
  if type(jewelryType) ~= "number" or type(index) ~= "number" then
    return 0
  end
  local equipIndex = index + jewelryType * 1000
  return equipIndex
end

function JewelryData:GetJewelryDataInfoDic(index)
  return self.JewelryDataInfoDic[index]
end

function JewelryData:GetIndexList(mainType)
  local indexList = {}
  for i = 1, 6 do
    table.insert(indexList, self:GetEquipIndex(mainType, i))
  end
  return indexList
end

function JewelryData:GetTotalLevel()
  if self.totalLevel == nil then
    self.totalLevel = 0
  end
  if self.dataChange == false or self.dataChange == nil then
    return self.totalLevel
  end
  self.dataChange = true
  self.totalLevel = 0
  if type(self.JewelryDataInfoDic) == "table" then
    for k, v in pairs(self.JewelryDataInfoDic) do
      local equipDataItem = v
      self.totalLevel = self.totalLevel + equipDataItem:GetItemLevel()
    end
  end
  return self.totalLevel
end

function JewelryData:GetJewelryTotalLvByType(_type)
  local totalLevel = 0
  for i, v in pairs(self.JewelryDataInfoDic) do
    local equipDataItem = v
    if equipDataItem.equipData:isEquiped() and equipDataItem.equipData.tblEquip.subType == _type then
      totalLevel = totalLevel + equipDataItem:GetItemLevel()
    end
  end
  return totalLevel
end

function JewelryData:TryGetStartEquipDataItem(mainType)
  local indexList = JewelryData:GetIndexList(mainType)
  local count = 0
  local Item
  for i, v in pairs(indexList) do
    if self.JewelryDataInfoDic[v] ~= nil then
      count = count + 1
      if Item == nil then
        Item = self.JewelryDataInfoDic[v]
      end
    end
  end
  return Item, count
end

function JewelryData:IsIncludeJewelryIndex(index)
  if index == nil then
    return false
  end
  index = tonumber(index)
  if index == nil then
    return false
  end
  return index >= JewelryData.equipIndexMin and index < JewelryData.equipIndexMax
end

function JewelryData:GetExhibitIndex(index)
  if tonumber(index) then
    local num = math.modf(index / 1000)
    return num * 1000 + 1
  end
  return index
end

function JewelryData:IsJewelry_ItemData(itemData)
  if itemData == nil or itemData.tblEquip == nil then
    return false
  end
  local index = itemData.tblEquip.equipPosition
  return self:IsIncludeJewelryIndex(index)
end

function JewelryData:IsBetter(itemData)
  if itemData == nil or itemData.tblEquip == nil then
    return false
  end
  local index = tonumber(itemData.tblEquip.equipPosition)
  local wearDataInfo = self.JewelryDataInfoDic[index]
  if wearDataInfo == nil then
    return true
  end
  if wearDataInfo:GetItemTable() == nil or itemData.tblItem == nil then
    return false
  end
  if tonumber(wearDataInfo:GetItemTable().quality) < tonumber(itemData.tblItem.quality) then
    return true
  elseif tonumber(wearDataInfo:GetItemTable().quality) == tonumber(itemData.tblItem.quality) and wearDataInfo:GetEquipData() ~= nil and wearDataInfo:GetEquipData().excellentInfoTbl ~= nil and itemData.excellentInfoTbl ~= nil then
    if #wearDataInfo:GetEquipData().excellentInfoTbl == #itemData.excellentInfoTbl then
      return self:GetJewelryEquipRating(wearDataInfo:GetEquipData().excellentInfoTbl) < self:GetJewelryEquipRating(itemData.excellentInfoTbl)
    else
      return #wearDataInfo:GetEquipData().excellentInfoTbl < #itemData.excellentInfoTbl
    end
  end
  return false
end

function JewelryData:GetJewelryEquipRating(excellentInfoTbl)
  if excellentInfoTbl == nil then
    return 0
  end
  local equipRatingNumber = 0
  for index, itemData in pairs(excellentInfoTbl) do
    local cfgTab = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(itemData.configId)
    if cfgTab ~= nil then
      equipRatingNumber = equipRatingNumber + cfgTab.equipRating
    end
  end
  return equipRatingNumber
end

function JewelryData:IsJewelryBySubtype(_subType)
  if _subType == EItemSubtype.Necklace or _subType == EItemSubtype.Ring or _subType == EItemSubtype.Earrings then
    return true
  else
    return false
  end
end

return JewelryData
