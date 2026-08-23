local SuitEquipList_Normal = {}
setmetatable(SuitEquipList_Normal, LuaClass.SuitEquipList_Base)

function SuitEquipList_Normal:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.NORMAL
end

function SuitEquipList_Normal:NewSuitItem(data)
  return LuaClass.SuitEquipItem_Normal:New()
end

function SuitEquipList_Normal:GetSuitType()
  return EquipCellType.NORMAL
end

return SuitEquipList_Normal
