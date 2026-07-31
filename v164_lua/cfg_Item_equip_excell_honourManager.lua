local cfg_Item_equip_excell_honourManager = {}

function cfg_Item_equip_excell_honourManager:GetName()
  return "cfg_Item_equip_excell_honourManager"
end

function cfg_Item_equip_excell_honourManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_excell_honour")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_excell_honourManager, TableManagerBase)

function cfg_Item_equip_excell_honourManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_excell_honourManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_excell_honourManager:GetHonourAttributeData()
  if self.honourAttributeTab == nil then
    self.honourAttributeTab = {}
    local groupTab = {}
    for i, v in pairs(self:GetDic()) do
      groupTab[v.excellType] = groupTab[v.excellType] == nil and {} or groupTab[v.excellType]
      table.insert(groupTab[v.excellType], v)
    end
    for groupIndex, itemGroup in ipairs(groupTab) do
      local minValue, attributeDescription = self:GetAttributeDescription(itemGroup[1])
      local maxValue = minValue
      for i, v in pairs(itemGroup) do
        minValue = minValue > v[attributeDescription] and v[attributeDescription] or minValue
        maxValue = maxValue < v[attributeDescription] and v[attributeDescription] or maxValue
      end
      table.insert(self.honourAttributeTab, {
        minValue = minValue,
        maxValue = maxValue,
        attributeDescription = attributeDescription
      })
    end
  end
  return self.honourAttributeTab
end

function cfg_Item_equip_excell_honourManager:GetAttributeDescription(config)
  for i, v in pairs(EHonourAttributeClient) do
    if not string.isNullOrEmpty(config[v]) and config[v] ~= 0 then
      return config[v], v
    end
  end
end

return cfg_Item_equip_excell_honourManager
