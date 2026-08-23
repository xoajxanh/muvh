local HolyRingHoleItemData = {}
HolyRingHoleItemData.Name = nil
HolyRingHoleItemData.HolyRingType = nil
HolyRingHoleItemData.Quality = nil
HolyRingHoleItemData.ItemId = nil
HolyRingHoleItemData.BasicsAttribute = nil

function HolyRingHoleItemData:RefreshData(data)
  if data == nil then
    return
  end
  self:InitData(data)
  self:InitBasicsAttribute(data)
end

function HolyRingHoleItemData:InitData(data)
  local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(data)
  self.Name = itemCfg.name
  self.HolyRingType = itemCfg.subType
  self.ItemId = itemCfg.id
  self.Quality = itemCfg.quality
  self.ItemId = itemCfg.id
end

function HolyRingHoleItemData:InitBasicsAttribute(data)
  self.BasicsAttribute = {}
  local equipCfg = ClientTable.cfg_Item_equipManager:TryGetValue(data)
  for i, v in pairs(HolyRingAttributeEnum) do
    if equipCfg[v.attributeConfigName] then
      local value = v.type == "choose" and RoleEquipUtility.GetCareerHP(equipCfg[v.attributeConfigName]) or equipCfg[v.attributeConfigName]
      if value ~= 0 then
        local itemBasicsAttribute = {}
        itemBasicsAttribute.attributeName = v.attributeConfigName
        itemBasicsAttribute.attributeValue = value
        table.insert(self.BasicsAttribute, itemBasicsAttribute)
      end
    end
  end
end

function HolyRingHoleItemData:GetName()
  return self.Name
end

function HolyRingHoleItemData:GetHolyRingType()
  return self.HolyRingType
end

function HolyRingHoleItemData:GetQuality()
  return self.Quality
end

function HolyRingHoleItemData:GetBasicsAttribute()
  return self.BasicsAttribute
end

function HolyRingHoleItemData:GetItemId()
  return self.ItemId
end

return HolyRingHoleItemData
