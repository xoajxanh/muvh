local EnchantEquipIndexUpgradeItemData = {}
EnchantEquipIndexUpgradeItemData.m_EnchantUpgradeConfig = nil
EnchantEquipIndexUpgradeItemData.m_AttributeData = nil
EnchantEquipIndexUpgradeItemData.m_MaterialData = nil
EnchantEquipIndexUpgradeItemData.m_IsUnlock = nil

function EnchantEquipIndexUpgradeItemData:Init(_enchantUpgradeConfig)
  if _enchantUpgradeConfig == nil then
    return
  end
  self.m_EnchantUpgradeConfig = _enchantUpgradeConfig
  self.m_IsUnlock = false
  self:RefreshAttribute()
  self:RefreshMaterial()
end

function EnchantEquipIndexUpgradeItemData:RefreshAttribute()
  local attributeData = EnchantEquipUtility:GetConfigAttributeDataTab(self.m_EnchantUpgradeConfig)
  if attributeData == nil or table.count(attributeData) == 0 then
    return
  end
  self.m_AttributeData = attributeData
end

function EnchantEquipIndexUpgradeItemData:RefreshMaterial()
  local upgradeCons = self.m_EnchantUpgradeConfig.upgradeCons
  if string.isNullOrEmpty(upgradeCons) then
    return
  end
  self.m_MaterialData = {}
  local upgradeConsTab = string.split(upgradeCons, "&")
  for i, v in ipairs(upgradeConsTab) do
    local itemUpgradeConsTab = string.split(v, "#")
    local itemId, count = tonumber(itemUpgradeConsTab[1]), tonumber(itemUpgradeConsTab[2])
    table.insert(self.m_MaterialData, {itemId = itemId, count = count})
  end
end

function EnchantEquipIndexUpgradeItemData:ResEnchantInfo(_pointId, _pointGrade)
  if _pointId == nil or _pointGrade == nil or self.m_EnchantUpgradeConfig == nil then
    return
  end
  self:RefreshUnlockState(_pointId, _pointGrade)
end

function EnchantEquipIndexUpgradeItemData:RefreshUnlockState(_pointId, _pointGrade)
  self.m_IsUnlock = _pointId >= self.m_EnchantUpgradeConfig.pointId and _pointGrade >= self.m_EnchantUpgradeConfig.pointGrade
end

return EnchantEquipIndexUpgradeItemData
