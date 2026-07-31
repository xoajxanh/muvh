EnchantEquipUtility = {}

function EnchantEquipUtility:GetConfigAttributeDataTab(_enchantUpgradeConfig)
  if _enchantUpgradeConfig == nil then
    return nil
  end
  local attributeDesTab = {}
  if not self:CheckConfigItemAttributeIsNil(_enchantUpgradeConfig.maximumHealth) then
    local value = self:GetMainPlayerAttributeValue(_enchantUpgradeConfig.maximumHealth)
    if value ~= 0 then
      table.insert(attributeDesTab, {
        attributeName = EnchantEquipAttributeAll.maximumHealth,
        attributeValue = value
      })
    end
  end
  if not self:CheckConfigItemAttributeIsNil(_enchantUpgradeConfig.defenseBase) then
    table.insert(attributeDesTab, {
      attributeName = EnchantEquipAttributeAll.defenseBase,
      attributeValue = _enchantUpgradeConfig.defenseBase
    })
  end
  if not self:CheckConfigItemAttributeIsNil(_enchantUpgradeConfig.minimumPhysBaseDmg) then
    local min, max = self:GetMainPlayerAttributeValue(_enchantUpgradeConfig.minimumPhysBaseDmg), self:GetMainPlayerAttributeValue(_enchantUpgradeConfig.maximumPhysBaseDmg)
    if min ~= 0 and max ~= 0 then
      table.insert(attributeDesTab, {
        attributeName = EnchantEquipAttributeAll.minimumPhysBaseDmg,
        attributeValue = tostring(min .. "#" .. max)
      })
    end
  end
  if not self:CheckConfigItemAttributeIsNil(_enchantUpgradeConfig.minimumPhysAndWizDmg_mul) then
    table.insert(attributeDesTab, {
      attributeName = EnchantEquipAttributeAll.minimumPhysAndWizDmg_mul,
      attributeValue = _enchantUpgradeConfig.minimumPhysAndWizDmg_mul / 100
    })
  end
  if not self:CheckConfigItemAttributeIsNil(_enchantUpgradeConfig.defenseBase_mul) then
    table.insert(attributeDesTab, {
      attributeName = EnchantEquipAttributeAll.defenseBase_mul,
      attributeValue = _enchantUpgradeConfig.defenseBase_mul / 100
    })
  end
  if not self:CheckConfigItemAttributeIsNil(_enchantUpgradeConfig.labUnlock) then
    table.insert(attributeDesTab, {
      attributeName = EnchantEquipAttributeDotInAll.labUnlock,
      attributeValue = _enchantUpgradeConfig.labUnlock
    })
  end
  return attributeDesTab
end

function EnchantEquipUtility:GetAppointEquipIndexAllAttributeDes(_enchantEquipIndexData, _notCheckIsWearEquip)
  if _enchantEquipIndexData == nil then
    return nil
  end
  local attributeTotalValueTab, attributeDesTab = {}, {}
  for i, v in pairs(EnchantEquipAttributeAll) do
    attributeTotalValueTab[v] = 0
    if v == EnchantEquipAttributeAll.minimumPhysBaseDmg then
      attributeTotalValueTab[v] = "0#0"
    end
  end
  for i, itemEnchantEquipIndexData in pairs(_enchantEquipIndexData) do
    if itemEnchantEquipIndexData ~= nil and table.count(itemEnchantEquipIndexData.m_EnchantEquipIndexUpgradeData) ~= 0 and (_notCheckIsWearEquip or itemEnchantEquipIndexData:IsWearEquip()) then
      if itemEnchantEquipIndexData.m_ItemInfoAttributeData and table.count(itemEnchantEquipIndexData.m_ItemInfoAttributeData) ~= 0 then
        for i, itemAttributeData in pairs(itemEnchantEquipIndexData.m_ItemInfoAttributeData) do
          if itemAttributeData and not string.isNullOrEmpty(itemAttributeData.attributeName) and EnchantEquipAttributeAll[itemAttributeData.attributeName] then
            local saveValue = attributeTotalValueTab[itemAttributeData.attributeName]
            attributeTotalValueTab[itemAttributeData.attributeName] = saveValue + tonumber(itemAttributeData.attributeValue)
          end
        end
      end
      for i, itemEnchantEquipIndexUpgradeItemData in pairs(itemEnchantEquipIndexData.m_EnchantEquipIndexUpgradeData) do
        if table.count(itemEnchantEquipIndexUpgradeItemData.m_AttributeData) ~= 0 and itemEnchantEquipIndexUpgradeItemData.m_IsUnlock then
          for i, itemAttributeData in pairs(itemEnchantEquipIndexUpgradeItemData.m_AttributeData) do
            if itemAttributeData and not string.isNullOrEmpty(itemAttributeData.attributeName) and EnchantEquipAttributeAll[itemAttributeData.attributeName] then
              local saveValue = attributeTotalValueTab[itemAttributeData.attributeName]
              if itemAttributeData.attributeName == EnchantEquipAttributeAll.minimumPhysBaseDmg then
                local min, max = tonumber(string.split(itemAttributeData.attributeValue, "#")[1]), tonumber(string.split(itemAttributeData.attributeValue, "#")[2])
                local saveMin, saveMax = tonumber(string.split(saveValue, "#")[1]), tonumber(string.split(saveValue, "#")[2])
                attributeTotalValueTab[itemAttributeData.attributeName] = tostring(saveMin + min .. "#" .. saveMax + max)
              else
                attributeTotalValueTab[itemAttributeData.attributeName] = saveValue + tonumber(itemAttributeData.attributeValue)
              end
            end
          end
        end
      end
    end
  end
  for i, itemAttributeName in ipairs(EnchantEquipAttributeAllSort) do
    local itemAttributeValue, formatText = attributeTotalValueTab[itemAttributeName], self:GetAttributeFormatText(itemAttributeName)
    if itemAttributeValue and not string.isNullOrEmpty(formatText) then
      if itemAttributeName == EnchantEquipAttributeAll.minimumPhysBaseDmg then
        local min, max = tonumber(string.split(itemAttributeValue, "#")[1]), tonumber(string.split(itemAttributeValue, "#")[2])
        table.insert(attributeDesTab, string.format(formatText, min, max))
      else
        table.insert(attributeDesTab, string.format(formatText, MathUtility.FormatNum(itemAttributeValue)))
      end
    end
  end
  return attributeDesTab
end

function EnchantEquipUtility:GetEquipDataAttributeDataTab(_itemId)
  if _itemId == nil then
    return
  end
  local itemEquipConfig = ClientTable.cfg_Item_equipManager:TryGetValue(_itemId)
  if itemEquipConfig == nil or string.isNullOrEmpty(itemEquipConfig.enchantFixedEntry) then
    return
  end
  local equipDataAttributeData = {}
  for i, attributeId in ipairs(string.split(itemEquipConfig.enchantFixedEntry, "#")) do
    local itemEquipExcellenceConfig = ClientTable.cfg_Item_equip_excellenceManager:TryGetValue(tonumber(attributeId))
    if itemEquipExcellenceConfig ~= nil then
      local attributeTab = self:GetConfigAttributeDataTab(itemEquipExcellenceConfig)
      if attributeTab ~= nil and table.count(attributeTab) ~= 0 then
        for i, v in pairs(attributeTab) do
          table.insert(equipDataAttributeData, v)
        end
      end
    end
  end
  return equipDataAttributeData
end

function EnchantEquipUtility:GetMainPlayerAttributeValue(_maximumHealth)
  if _maximumHealth == nil then
    return 0
  end
  local mainPlayerCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
  for i, v in pairs(_maximumHealth) do
    if v and v[1] == mainPlayerCareer then
      return v[2]
    end
  end
  return 0
end

function EnchantEquipUtility:CheckConfigItemAttributeIsNil(_attributeValue)
  if _attributeValue == nil then
    return true
  elseif type(_attributeValue) == "number" then
    return _attributeValue == 0
  elseif type(_attributeValue) == "string" then
    return _attributeValue == ""
  elseif type(_attributeValue) == "table" then
    return table.count(_attributeValue) == 0
  end
  return true
end

function EnchantEquipUtility:GetAttributeFormatText(_attributeName)
  if string.isNullOrEmpty(_attributeName) or EnchantEquipAttributeAll[_attributeName] == nil then
    return nil
  end
  local uiWordAttributeConfig = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(_attributeName)
  if uiWordAttributeConfig == nil then
    return nil
  end
  local text = uiWordAttributeConfig.enchantattributeUI
  if string.isNullOrEmpty(text) then
    return nil
  end
  return text
end

function EnchantEquipUtility:PlayEffect(_effectName, _effectTime)
  if string.isNullOrEmpty(_effectName) or _effectTime == nil then
    return
  end
  if UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {name = _effectName, time = _effectTime})
  else
    UIManager.Show(UIID.EffectTipUI, {name = _effectName, effectTime = _effectTime})
  end
end

function EnchantEquipUtility:GetFilterEnchantEquipBagData(_enchantEquipIndexData, _enchantEquipBagData)
  if _enchantEquipIndexData == nil or _enchantEquipBagData == nil or table.count(_enchantEquipBagData) == 0 then
    return nil
  end
  local bagData = {}
  for i, v in pairs(_enchantEquipBagData) do
    if v and not v:CheckDataIsNil() and _enchantEquipIndexData:IsCanInlayAppointPosition(v.m_EquipConfig.equipPosition) then
      table.insert(bagData, v)
    end
  end
  if bagData == nil or table.count(bagData) == 0 then
    return nil
  end
  return bagData
end
