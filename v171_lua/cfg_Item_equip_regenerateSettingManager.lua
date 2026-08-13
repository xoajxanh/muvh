local cfg_Item_equip_regenerateSettingManager = {}

function cfg_Item_equip_regenerateSettingManager:GetName()
  return "cfg_Item_equip_regenerateSettingManager"
end

function cfg_Item_equip_regenerateSettingManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_regenerateSetting")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_regenerateSettingManager, TableManagerBase)

function cfg_Item_equip_regenerateSettingManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_regenerateSettingManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_regenerateSettingManager:GetRegenerateCostList(subType, isLock)
  if subType == nil and isLock == nil then
    return
  end
  local item_equip_regenerateSettingTbl = self:TryGetValue(subType, "type")
  if item_equip_regenerateSettingTbl == nil then
    return
  end
  local cost = isLock == true and item_equip_regenerateSettingTbl.lockcost or item_equip_regenerateSettingTbl.cost
  local reCostTbl = TableParse:SpliteStringToItemCountList(cost)
  return reCostTbl
end

function cfg_Item_equip_regenerateSettingManager:GetSelectCondition(subType)
  if subType == nil then
    return
  end
  local item_equip_regenerateSettingTbl = self:TryGetValue(subType, "type")
  local condition = item_equip_regenerateSettingTbl.condition
  if condition then
    return condition[2]
  end
end

return cfg_Item_equip_regenerateSettingManager
