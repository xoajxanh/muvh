local SuitEquipList_HongZhuang = {}
setmetatable(SuitEquipList_HongZhuang, LuaClass.SuitEquipList_Base)

function SuitEquipList_HongZhuang:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.HONGZHUANG
end

function SuitEquipList_HongZhuang:NewSuitItem(data)
  return LuaClass.SuitEquipItem_HongZhuang:New()
end

function SuitEquipList_HongZhuang:GetSuitType()
  return EquipCellType.HONGZHUANG
end

return SuitEquipList_HongZhuang
