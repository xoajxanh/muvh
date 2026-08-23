local SacredBoneBagData = {}
SacredBoneBagData.ItemInfo = nil
SacredBoneBagData.Name = nil
SacredBoneBagData.ItemCount = nil
SacredBoneBagData.Quality = nil
SacredBoneBagData.ModQuality = nil
SacredBoneBagData.ItemId = nil
SacredBoneBagData.Type = nil
SacredBoneBagData.SubType = nil
SacredBoneBagData.SoulType = nil
SacredBoneBagData.SacredBoneType = nil
SacredBoneBagData.SacredBoneAttribute = nil
SacredBoneBagData.SacredBoneAttributeValue = nil
SacredBoneBagData.SacredBoneAttributeType = false

function SacredBoneBagData:RefreshData(data)
  if data == nil then
    return
  end
  self:InitData(data)
end

function SacredBoneBagData:UpdateCount(count)
  if count == nil then
    return
  end
  self.ItemCount = count
end

function SacredBoneBagData:InitData(data)
  local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(data.itemId)
  self.ItemInfo = data
  self.ItemId = data.itemId or 0
  self.ItemCount = data.count or 0
  self.Name = itemCfg and itemCfg.name or ""
  self.ColorShow = itemCfg and itemCfg.colorShow or 0
  self.Type = itemCfg and itemCfg.type or 0
  self.SubType = itemCfg and itemCfg.subType or 0
  self.Quality = itemCfg and itemCfg.quality % 100 or 0
  self.SacredBoneAttribute = ClientTable.cfg_Bone_attributeManager:GetAttrDesByServerData(data) or ""
  self.ModQuality = 0 <= math.fmod(self.Quality, 100) - 1 and math.fmod(self.Quality, 100) - 1 or 0
  if self.Type == 24 then
    if self.SubType > 2400 and self.SubType < 2450 then
      self.SoulType = 0
    elseif self.SubType == 2400 then
      self.SoulType = 1
    elseif self.SubType == 2450 then
      self.SoulType = 2
    end
  elseif self.Type == 26 then
    self.SoulType = 3
  end
  local itemData = {}
  if data.boneSoulInfo[1] then
    itemData = ClientTable.cfg_Bone_attributeManager:TryGetValue(data.boneSoulInfo[1].configId, "id")
  else
    itemData = ClientTable.cfg_Bone_attributeManager:TryGetValue(tostring(data.itemId), "relationItem")
  end
  if itemData then
    self.SacredBoneType = itemData and itemData.type or "0"
  end
end

function SacredBoneBagData:UnSacredBoneBagEquipShow(equipIndex)
  local itemStr = self.SacredBoneType
  local data = string.split(itemStr, "#")
  for i, v in ipairs(data) do
    if v == equipIndex then
      return true
    end
  end
  return false
end

function SacredBoneBagData:GetSacredBoneBagDataType(equipBagDataType)
  self.SacredBoneAttributeType = equipBagDataType
end

function SacredBoneBagData:SetSacredBoneBagEquipType()
  return self.SacredBoneAttributeType
end

return SacredBoneBagData
