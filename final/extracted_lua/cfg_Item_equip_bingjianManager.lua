local cfg_Item_equip_bingjianManager = {}

function cfg_Item_equip_bingjianManager:GetName()
  return "cfg_Item_equip_bingjianManager"
end

function cfg_Item_equip_bingjianManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_bingjian")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_bingjianManager, TableManagerBase)

function cfg_Item_equip_bingjianManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_bingjianManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_bingjianManager:GetAllCellTypeList()
  if self.mAllCellTypeList == nil then
    self.mAllCellTypeList = {}
    for i, tbl in pairs(self:GetDic()) do
      if type(tbl.cellType) == "number" then
        table.insert(self.mAllCellTypeList, tbl.cellType)
      end
    end
  end
  return self.mAllCellTypeList
end

function cfg_Item_equip_bingjianManager:GetCellBasicIdByCellType(cellType)
  for i, tbl in pairs(self:GetDic()) do
    if tbl.cellType == cellType then
      return tbl.cellBasicId
    end
  end
  return 0
end

function cfg_Item_equip_bingjianManager:ExcellenceShowTypeJudge(bagIndex, showType)
  if type(bagIndex) ~= "number" or showType == nil then
    return false
  end
  local equipCellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(bagIndex)
  if type(equipCellTbl) ~= "table" then
    return false
  end
  for i, tbl in pairs(self:GetDic()) do
    if tbl.cellType == equipCellTbl.cellType then
      if tbl.isExcellence == showType then
        return true
      else
        return false
      end
    end
  end
  return false
end

function cfg_Item_equip_bingjianManager:IsShowSuitSpecialEAtrByItemInfo(itemInfo)
  if itemInfo.tblEquip == nil then
    return false
  end
  local bagIndex = string.split(itemInfo.tblEquip.equipPosition, "#")[1]
  return self:ExcellenceShowTypeJudge(tonumber(bagIndex), BingJianExcellenceShowType.SpecialShow)
end

return cfg_Item_equip_bingjianManager
