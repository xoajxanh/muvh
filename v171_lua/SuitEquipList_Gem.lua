local SuitEquipList_Gem = {}
setmetatable(SuitEquipList_Gem, LuaClass.SuitEquipList_Base)

function SuitEquipList_Gem:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.GEM
end

function SuitEquipList_Gem:NewSuitItem(data)
  return LuaClass.SuitEquipItem_Gem:New()
end

function SuitEquipList_Gem:GetSuitType()
  return EquipCellType.GEM
end

return SuitEquipList_Gem
