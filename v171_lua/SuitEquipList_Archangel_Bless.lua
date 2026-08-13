local SuitEquipList_Archangel_Bless = {}
setmetatable(SuitEquipList_Archangel_Bless, LuaClass.SuitEquipList_Base)

function SuitEquipList_Archangel_Bless:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.ARCHANGEL_BLESS
end

function SuitEquipList_Archangel_Bless:NewSuitItem(data)
  return LuaClass.SuitEquipItem_Archangel_Bless:New()
end

function SuitEquipList_Archangel_Bless:GetSuitType()
  return EquipCellType.ARCHANGEL_BLESS
end

return SuitEquipList_Archangel_Bless
