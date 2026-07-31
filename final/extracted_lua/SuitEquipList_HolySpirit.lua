local SuitEquipList_HolySpirit = {}
setmetatable(SuitEquipList_HolySpirit, LuaClass.SuitEquipList_Base)

function SuitEquipList_HolySpirit:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.SHENGHUN
end

function SuitEquipList_HolySpirit:NewSuitItem(data)
  return LuaClass.SuitEquipItem_HolySpirit:New()
end

function SuitEquipList_HolySpirit:GetSuitType()
  return EquipCellType.SHENGHUN
end

return SuitEquipList_HolySpirit
