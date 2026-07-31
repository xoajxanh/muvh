local SuitEquipList_Archangel = {}
setmetatable(SuitEquipList_Archangel, LuaClass.SuitEquipList_Base)

function SuitEquipList_Archangel:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.ARCHANGEL
end

function SuitEquipList_Archangel:NewSuitItem(data)
  return LuaClass.SuitEquipItem_Archangel:New()
end

function SuitEquipList_Archangel:GetSuitType()
  return EquipCellType.ARCHANGEL
end

return SuitEquipList_Archangel
