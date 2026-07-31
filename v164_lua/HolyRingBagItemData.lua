local HolyRingBagItemData = {}
HolyRingBagItemData.ItemInfo = nil
HolyRingBagItemData.ItemId = nil
HolyRingBagItemData.Count = nil
HolyRingBagItemData.Name = nil
HolyRingBagItemData.HolyRingType = nil
HolyRingBagItemData.Quality = nil
HolyRingBagItemData.RingType = nil
HolyRingBagItemData.RingTypeName = nil
HolyRingBagItemData.RingYear = nil

function HolyRingBagItemData:RefreshData(data)
  if data == nil then
    return
  end
  self:InitData(data)
end

function HolyRingBagItemData:UpdateCount(count)
  if count == nil then
    return
  end
  self.Count = count
end

function HolyRingBagItemData:InitData(data)
  local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(data.itemId)
  self.ItemInfo = data
  self.ItemId = data.itemId or 0
  self.Count = data.count or 0
  self.Name = itemCfg and itemCfg.name or ""
  self.HolyRingType = itemCfg and itemCfg.subType or 0
  self.Quality = itemCfg and itemCfg.quality or 0
  self.RingType = itemCfg and itemCfg.ringType or 0
  self.RingYear = itemCfg and itemCfg.ringYear or ""
  self.RingTypeName = ClientTable.cfg_Item_class_settingManager:GetRingTypeNameByRingType(self.RingType)
  self.IsMaxYear = ClientTable.cfg_Ring_combineManager:GetIsMaxLevel(self.ItemId)
end

function HolyRingBagItemData:GetItemInfo()
  return self.ItemInfo
end

function HolyRingBagItemData:GetItemId()
  return self.ItemId or 0
end

function HolyRingBagItemData:GetCount()
  return self.Count or 0
end

function HolyRingBagItemData:GetName()
  return self.Name or ""
end

function HolyRingBagItemData:GetHolyRingType()
  return self.HolyRingType or 0
end

function HolyRingBagItemData:GetQuality()
  return self.Quality or 0
end

function HolyRingBagItemData:GetRingType()
  return self.RingType or 0
end

function HolyRingBagItemData:GetRingTypeName()
  return self.RingTypeName or ""
end

function HolyRingBagItemData:GetQuality()
  return self.RingYear or 0
end

return HolyRingBagItemData
