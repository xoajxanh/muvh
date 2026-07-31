local SuitEquipList_Archangel_Christmas = {}
setmetatable(SuitEquipList_Archangel_Christmas, LuaClass.SuitEquipList_Base)

function SuitEquipList_Archangel_Christmas:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.ARCHANGEL_CHRISTMAS
end

function SuitEquipList_Archangel_Christmas:NewSuitItem(data)
  return LuaClass.SuitEquipItem_Archangel_Christmas:New()
end

function SuitEquipList_Archangel_Christmas:GetSuitType()
  return EquipCellType.ARCHANGEL_CHRISTMAS
end

return SuitEquipList_Archangel_Christmas
