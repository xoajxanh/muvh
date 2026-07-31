local cfg_Item_reExcellManager = {}

function cfg_Item_reExcellManager:GetName()
  return "cfg_Item_reExcellManager"
end

function cfg_Item_reExcellManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_reExcell")
  end
  return self.dic
end

setmetatable(cfg_Item_reExcellManager, TableManagerBase)

function cfg_Item_reExcellManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_reExcellManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_reExcellManager:GetXiLianCostList(itemId)
  if type(itemId) ~= "number" then
    return
  end
  local equipTbl = ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
  if equipTbl == nil then
    return
  end
  local reExcellId = equipTbl.equipClass * 10000 + equipTbl.subType
  return self:GetCostList(reExcellId)
end

cfg_Item_reExcellManager.costDic = nil

function cfg_Item_reExcellManager:GetCostList(id)
  if type(id) ~= "number" then
    return
  end
  if self.costDic == nil then
    self.costDic = {}
  end
  if self.costDic[id] ~= nil then
    return self.costDic[id]
  end
  local reExcellTbl = self:TryGetValue(id)
  if reExcellTbl == nil then
    return
  end
  local costList = TableParse:SpliteStringToItemCountList(reExcellTbl.classCose)
  if costList ~= nil then
    self.costDic[id] = costList
  end
  return costList
end

return cfg_Item_reExcellManager
