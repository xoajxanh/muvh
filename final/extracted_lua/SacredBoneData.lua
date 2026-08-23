local SacredBoneData = {}
SacredBoneData.SacredBoneIndex = nil
SacredBoneData.SacredBoneEquip = nil
SacredBoneData.Name = nil
SacredBoneData.Quality = nil
SacredBoneData.ItemId = nil
SacredBoneData.Type = nil
SacredBoneData.SubType = nil
SacredBoneData.SacredBoneType = nil
SacredBoneData.SacredBoneAttribute = nil
SacredBoneData.SacredBoneAttributeType = false
SacredBoneData.SacredBoneLockType = true
SacredBoneData.SacredBoneSetType = false

function SacredBoneData:InitData(sacredBoneIndex)
  self.SacredBoneIndex = sacredBoneIndex
end

function SacredBoneData:RefreshLockState(state)
  self.SacredBoneLockType = state
end

function SacredBoneData:RefreshSetState(state)
  self.SacredBoneSetType = state
end

function SacredBoneData:RefreshData(data)
  if data == nil then
    return
  end
  self:InitBoneData(data)
end

function SacredBoneData:InitBoneData(data)
  local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(data.itemId)
  self.ItemInfo = data
  self.ItemId = data.itemId or 0
  self.Name = itemCfg and itemCfg.name or ""
  self.Type = itemCfg and itemCfg.type or 0
  self.SubType = itemCfg and itemCfg.subType or 0
  self.Quality = itemCfg and itemCfg.quality % 100 or 0
  self.SacredBoneAttribute = itemCfg and ClientTable.cfg_Bone_attributeManager:GetAttrDesByServerData(data) or ""
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

function SacredBoneData:RemoveSacredBoneItemData()
  self.SacredBoneEquip = nil
  self:RefreshSetState(false)
end

function SacredBoneData:RefreshSacredBoneItemData(data)
  if data == nil then
    return
  end
  if self.SacredBoneEquip == nil then
    local sacredBoneData = LuaClass.SacredBoneData:New()
    self.SacredBoneEquip = sacredBoneData
  end
  self.SacredBoneEquip:RefreshData(data)
end

function SacredBoneData:GetSacredBoneDataType(equipDataType)
  self.SacredBoneAttributeType = equipDataType
end

function SacredBoneData:GetSacredBoneLockType(equipDataType)
  self.SacredBoneLockType = equipDataType
end

function SacredBoneData:GetSacredBoneSetType(equipDataType)
  self.SacredBoneSetType = equipDataType
end

function SacredBoneData:SetSacredBoneBagEquipType()
  return self.SacredBoneAttributeType
end

function SacredBoneData:SetSacredBoneLockType()
  return self.SacredBoneLockType
end

function SacredBoneData:SetSacredBoneSetType()
  return self.SacredBoneSetType
end

return SacredBoneData
