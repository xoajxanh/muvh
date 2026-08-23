local cfg_Item_equip_regenerateEvolutionManager = {}

function cfg_Item_equip_regenerateEvolutionManager:GetName()
  return "cfg_Item_equip_regenerateEvolutionManager"
end

function cfg_Item_equip_regenerateEvolutionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_regenerateEvolution")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_regenerateEvolutionManager, TableManagerBase)

function cfg_Item_equip_regenerateEvolutionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_regenerateEvolutionManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_regenerateEvolutionManager:GetRegenerateCostList(Date)
  if Date == nil then
    return
  end
  local costTbl
  for i, v in pairs(cfg_Item_equip_regenerateEvolutionManager.dic) do
    if v.type == Date.subType and v.level == Date.serverInfo.regenerateLevel then
      costTbl = v.cost
    end
  end
  if costTbl == nil then
    return
  end
  local reCostTbl = TableParse:SpliteStringToItemCountList(costTbl)
  return reCostTbl
end

function cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(subType)
  if subType == nil then
    return
  end
  local levelTbl = 0
  for i, v in pairs(cfg_Item_equip_regenerateEvolutionManager.dic) do
    if v.type == subType and levelTbl < v.level then
      levelTbl = v.level
    end
  end
  if levelTbl == nil then
    return
  end
  return levelTbl
end

function cfg_Item_equip_regenerateEvolutionManager:GetRegeneratecostList(subType)
  if subType == nil then
    return
  end
  local costId
  for i, v in pairs(cfg_Item_equip_regenerateEvolutionManager.dic) do
    if v.type == 1 and v.cost ~= "" then
      costId = v.cost
    end
  end
  if costId == nil then
    return
  end
  local costIdTbl = TableParse:SpliteStringToItemCountList(costId)
  return costIdTbl[1].itemId
end

return cfg_Item_equip_regenerateEvolutionManager
