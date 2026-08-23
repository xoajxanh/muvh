local EnchantEquipManager = {}
EnchantEquipManager.m_EnchantEquipIndexData = nil

function EnchantEquipManager:ResAllEnchantInfo(_msg)
  self.m_EnchantEquipIndexData = {}
  self:InitEnchantEquipIndexData()
  if _msg == nil or _msg.enchantInfo == nil or self.m_EnchantEquipIndexData == nil then
    return
  end
  for i, v in pairs(_msg.enchantInfo) do
    if v and v.index and self.m_EnchantEquipIndexData[v.index] then
      self.m_EnchantEquipIndexData[v.index]:ResEnchantInfo(v)
    end
  end
  EventManager.Dispatch(Event.RefreshEnchantEquipIndexChange)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Enchant_upgrade
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Enchant_enchant
  })
end

function EnchantEquipManager:ResEnchantInfo(_msg)
  if _msg == nil or _msg.index == nil or self.m_EnchantEquipIndexData == nil or self.m_EnchantEquipIndexData[_msg.index] == nil then
    return
  end
  self.m_EnchantEquipIndexData[_msg.index]:ResEnchantInfo(_msg)
  EventManager.Dispatch(Event.RefreshEnchantEquipIndexChange, _msg)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Enchant_upgrade
  })
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Enchant_enchant
  })
end

function EnchantEquipManager:InitEnchantEquipIndexData()
  for i, v in ipairs(EnchantEquipAllIndex) do
    self.m_EnchantEquipIndexData[v] = LuaClass.EnchantEquipIndexData:New(v)
  end
end

function EnchantEquipManager:GetEnchantEquipBagData()
  local bagData = {}
  for i, itemData in pairs(BagInfoData.TotalItems) do
    if itemData ~= nil and itemData.tblItem ~= nil and itemData.serverInfo ~= nil and itemData.tblItem.type == EnchantEquipConstant.EnchantEquipType then
      local bagItemData = LuaClass.EnchantEquipBagItemData:New(itemData.id, itemData.itemId, itemData.count)
      table.insert(bagData, bagItemData)
    end
  end
  return bagData
end

function EnchantEquipManager:GetEnchantEquipIndexDataByEquipIndex(_equipIndex)
  if _equipIndex == nil or self.m_EnchantEquipIndexData == nil then
    return
  end
  return self.m_EnchantEquipIndexData[_equipIndex]
end

function EnchantEquipManager:GetEnchantEquipIndexDataByItem(_itemInfo)
  if _itemInfo == nil or _itemInfo.bagGridIndex == nil or _itemInfo.tblEquip == nil or string.isNullOrEmpty(_itemInfo.tblEquip.equipPosition) or self.m_EnchantEquipIndexData == nil then
    return
  end
  local equipPosition = tonumber(string.split(_itemInfo.tblEquip.equipPosition, "#")[1])
  if equipPosition < EnchantEquipConstant.bagGridIndexAdd then
    return
  end
  local equipIndex = _itemInfo.bagGridIndex
  if _itemInfo.bagGridIndex > EnchantEquipConstant.bagGridIndexAdd then
    equipIndex = _itemInfo.bagGridIndex
  end
  return self.m_EnchantEquipIndexData[equipIndex]
end

function EnchantEquipManager:CheckEnchantEquipUpgradeRed()
  if self.m_EnchantEquipIndexData == nil then
    return false
  end
  for i, v in pairs(self.m_EnchantEquipIndexData) do
    if v:CheckEnchantEquipIndexCanUpgrade() then
      return true
    end
  end
  return false
end

function EnchantEquipManager:CheckEnchantEquipInlayRed()
  if self.m_EnchantEquipIndexData == nil then
    return false
  end
  for i, v in pairs(self.m_EnchantEquipIndexData) do
    if v:CheckEnchantEquipIndexBagHaveBetter(self:GetEnchantEquipBagData()) then
      return true
    end
  end
  return false
end

function EnchantEquipManager:CheckEnchantEquipIndexUpgradeRed(_equipIndex)
  local enchantEquipIndexData = self:GetEnchantEquipIndexDataByEquipIndex(_equipIndex)
  if enchantEquipIndexData == nil then
    return false
  end
  return enchantEquipIndexData:CheckEnchantEquipIndexCanUpgrade()
end

function EnchantEquipManager:CheckEnchantEquipIndexInlayRed(_equipIndex)
  local enchantEquipIndexData = self:GetEnchantEquipIndexDataByEquipIndex(_equipIndex)
  if enchantEquipIndexData == nil then
    return false
  end
  return enchantEquipIndexData:CheckEnchantEquipIndexBagHaveBetter(self:GetEnchantEquipBagData())
end

return EnchantEquipManager
