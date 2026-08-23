local EnchantEquipIndexData = {}
EnchantEquipIndexData.m_EquipIndex = nil
EnchantEquipIndexData.m_PointId = nil
EnchantEquipIndexData.m_PointGrade = nil
EnchantEquipIndexData.m_EnchantUpgradeConfig = nil
EnchantEquipIndexData.m_ItemInfo = nil
EnchantEquipIndexData.m_EnchantEquipIndexUpgradeData = nil
EnchantEquipIndexData.m_ItemInfoAttributeData = nil

function EnchantEquipIndexData:Init(_equipIndex)
  if _equipIndex == nil then
    return
  end
  self.m_EquipIndex = _equipIndex
  self.m_PointId = 1
  self.m_PointGrade = 0
  self.m_EnchantUpgradeConfig = ClientTable.cfg_Enchant_UpgradeManager:TryGetConfigByEquipIndexPointGradePointId(_equipIndex, self.m_PointId, self.m_PointGrade)
  self:InitEnchantEquipIndexUpgradeData(_equipIndex)
end

function EnchantEquipIndexData:InitEnchantEquipIndexUpgradeData(_equipIndex)
  if _equipIndex == nil then
    return
  end
  self.m_EnchantEquipIndexUpgradeData = {}
  local enchantUpgradeConfigTab = ClientTable.cfg_Enchant_UpgradeManager:TryGetValueByEquipIndex(_equipIndex)
  if enchantUpgradeConfigTab == nil or table.count(enchantUpgradeConfigTab) == 0 then
    return
  end
  table.sort(enchantUpgradeConfigTab, function(a, b)
    return a.pointGrade < b.pointGrade
  end)
  for i, v in ipairs(enchantUpgradeConfigTab) do
    if v and v.pointGrade ~= 0 then
      self.m_EnchantEquipIndexUpgradeData[v.pointGrade] = LuaClass.EnchantEquipIndexUpgradeItemData:New(v)
    end
  end
end

function EnchantEquipIndexData:ResEnchantInfo(_msg)
  if _msg == nil or self.m_EquipIndex ~= _msg.index then
    return
  end
  self.m_PointId = ClientTable.cfg_Enchant_UpgradeManager:TryGetPointIdByEquipIndexPointGrade(_msg.index, _msg.grade)
  self.m_PointGrade = _msg.grade
  self.m_EnchantUpgradeConfig = ClientTable.cfg_Enchant_UpgradeManager:TryGetConfigByEquipIndexPointGradePointId(self.m_EquipIndex, self.m_PointId, self.m_PointGrade)
  self.m_ItemInfo = _msg.item
  self:RefreshEnchantEquipIndexUpgradeItemData()
  self:RefreshEnchantEquipAttribute()
end

function EnchantEquipIndexData:RefreshEnchantEquipIndexUpgradeItemData()
  if self.m_EnchantEquipIndexUpgradeData == nil or table.count(self.m_EnchantEquipIndexUpgradeData) == 0 then
    return
  end
  for i, v in pairs(self.m_EnchantEquipIndexUpgradeData) do
    v:ResEnchantInfo(self.m_PointId, self.m_PointGrade)
  end
end

function EnchantEquipIndexData:RefreshEnchantEquipAttribute()
  self.m_ItemInfoAttributeData = {}
  if self.m_ItemInfo == nil then
    return
  end
  self.m_ItemInfoAttributeData = EnchantEquipUtility:GetEquipDataAttributeDataTab(self.m_ItemInfo.itemId)
end

function EnchantEquipIndexData:IsMaxPointGrade()
  if self.m_EnchantEquipIndexUpgradeData == nil or table.count(self.m_EnchantEquipIndexUpgradeData) == 0 then
    return false
  end
  return self.m_PointGrade >= table.count(self.m_EnchantEquipIndexUpgradeData)
end

function EnchantEquipIndexData:IsUnlock()
  if self.m_EnchantUpgradeConfig == nil or string.isNullOrEmpty(self.m_EnchantUpgradeConfig.inlayUnlockType) then
    return false
  end
  return tonumber(self.m_EnchantUpgradeConfig.inlayUnlockType) > 0
end

function EnchantEquipIndexData:IsWearEquip()
  if self.m_EquipIndex == nil or RoleManager.me == nil then
    return false
  end
  for k, v in pairs(RoleManager.me.data.equipsData.Data) do
    if v and v.bagGridIndex == self.m_EquipIndex and RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.HongZhuang) then
      return true
    end
  end
  return false
end

function EnchantEquipIndexData:IsCanInlayAppointQuality(_quality)
  if _quality == nil or self.m_EnchantUpgradeConfig == nil or string.isNullOrEmpty(self.m_EnchantUpgradeConfig.inlayUnlockType) then
    return false
  end
  return _quality <= tonumber(self.m_EnchantUpgradeConfig.inlayUnlockType)
end

function EnchantEquipIndexData:IsCanInlayAppointPosition(_equipPosition)
  if string.isNullOrEmpty(_equipPosition) or self.m_EquipIndex == nil then
    return false
  end
  local equipPositionList = string.split(_equipPosition, "#")
  for i, v in pairs(equipPositionList) do
    if tonumber(v) == self.m_EquipIndex then
      return true
    end
  end
  return false
end

function EnchantEquipIndexData:GetNextPointGradeUpgradeData()
  if self.m_EnchantEquipIndexUpgradeData == nil or table.count(self.m_EnchantEquipIndexUpgradeData) == 0 then
    return nil
  end
  if self:IsMaxPointGrade() then
    return nil
  end
  return self.m_EnchantEquipIndexUpgradeData[self.m_PointGrade + 1]
end

function EnchantEquipIndexData:GetCurrentPageShowAttribute()
  local currentPointIdUpgradeData, unlockCount = self:GetPointIdEqualDataByPointId(self.m_PointId), 0
  if not self:IsMaxPointGrade() then
    for i, v in pairs(currentPointIdUpgradeData) do
      if v.m_IsUnlock then
        unlockCount = unlockCount + 1
      end
    end
    if unlockCount == table.count(currentPointIdUpgradeData) then
      currentPointIdUpgradeData = self:GetPointIdEqualDataByPointId(self.m_PointId + 1)
    end
  end
  return currentPointIdUpgradeData
end

function EnchantEquipIndexData:IsInThroughState()
  local currentPointIdUpgradeData = self:GetPointIdEqualDataByPointId(self.m_PointId)
  if currentPointIdUpgradeData == nil or table.count(currentPointIdUpgradeData) == 0 then
    return false
  end
  local unlockCount = 0
  for i, v in pairs(currentPointIdUpgradeData) do
    if v.m_IsUnlock then
      unlockCount = unlockCount + 1
    end
  end
  return unlockCount == table.count(currentPointIdUpgradeData) - 1
end

function EnchantEquipIndexData:GetPointIdEqualDataByPointId(_pointId)
  if _pointId == nil or self.m_EnchantEquipIndexUpgradeData == nil or table.count(self.m_EnchantEquipIndexUpgradeData) == 0 then
    return nil
  end
  local pointIdEqualData = {}
  for i, v in pairs(self.m_EnchantEquipIndexUpgradeData) do
    if v and v.m_EnchantUpgradeConfig and v.m_EnchantUpgradeConfig.pointId == _pointId then
      table.insert(pointIdEqualData, v)
    end
  end
  return pointIdEqualData
end

function EnchantEquipIndexData:CheckEnchantEquipIndexCanUpgrade()
  if self:IsMaxPointGrade() or not self:IsWearEquip() then
    return false
  end
  local nextEnchantEquipIndexUpgradeItemData = self:GetNextPointGradeUpgradeData()
  if nextEnchantEquipIndexUpgradeItemData == nil then
    return false
  end
  local isCanUpgrade = true
  if nextEnchantEquipIndexUpgradeItemData.m_MaterialData then
    for i, v in pairs(nextEnchantEquipIndexUpgradeItemData.m_MaterialData) do
      if v and v.count and v.itemId and v.count > BagInfoData.GetItemTotalCountByItemId(v.itemId) then
        isCanUpgrade = false
        break
      end
    end
  end
  return isCanUpgrade
end

function EnchantEquipIndexData:CheckEnchantEquipIndexBagHaveBetter(_enchantEquipBagData)
  if not (_enchantEquipBagData ~= nil and table.count(_enchantEquipBagData) ~= 0 and self:IsUnlock()) or not self:IsWearEquip() then
    return false
  end
  local enchantEquipBagData = EnchantEquipUtility:GetFilterEnchantEquipBagData(self, _enchantEquipBagData)
  if enchantEquipBagData == nil or table.count(enchantEquipBagData) == 0 then
    return false
  end
  if self.m_ItemInfo == nil then
    return true
  else
    local itemData = ItemUtility.GenerateItemDataByServerData(self.m_ItemInfo)
    for i, item in pairs(enchantEquipBagData) do
      if item and item.m_ItemConfig.quality > itemData.tblItem.quality and self:IsCanInlayAppointQuality(item.m_ItemConfig.quality) then
        return true
      end
    end
  end
  return false
end

return EnchantEquipIndexData
