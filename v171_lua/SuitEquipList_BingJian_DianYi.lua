local SuitEquipList_BingJian_DianYi = {}
setmetatable(SuitEquipList_BingJian_DianYi, LuaClass.SuitEquipList_Base)

function SuitEquipList_BingJian_DianYi:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.BINGJIAN_DianYi
end

function SuitEquipList_BingJian_DianYi:NewSuitItem(data)
  return LuaClass.SuitEquipItem_BingJian_DianYi:New()
end

function SuitEquipList_BingJian_DianYi:GetSuitType()
  return EquipCellType.BINGJIAN_DianYi
end

return SuitEquipList_BingJian_DianYi
