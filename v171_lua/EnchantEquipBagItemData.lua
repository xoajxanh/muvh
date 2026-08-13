local EnchantEquipBagItemData = {}
EnchantEquipBagItemData.m_Id = 0
EnchantEquipBagItemData.m_ItemId = 0
EnchantEquipBagItemData.m_ItemConfig = nil
EnchantEquipBagItemData.m_EquipConfig = nil
EnchantEquipBagItemData.m_Count = 0

function EnchantEquipBagItemData:Init(_id, _itemId, _count)
  if _id == nil or _itemId == nil or _count == nil then
    return
  end
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(_itemId)
  local equipConfig = ClientTable.cfg_Item_equipManager:TryGetValue(_itemId)
  if itemConfig == nil or equipConfig == nil then
    return
  end
  self.m_Id = _id
  self.m_ItemId = _itemId
  self.m_ItemConfig = itemConfig
  self.m_EquipConfig = equipConfig
  self.m_Count = _count
end

function EnchantEquipBagItemData:CheckDataIsNil()
  return self.m_Id == nil or self.m_ItemId == nil or self.m_ItemConfig == nil or self.m_EquipConfig == nil or self.m_Count == nil or self.m_Count <= 0
end

return EnchantEquipBagItemData
