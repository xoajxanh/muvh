local SuitEquipList_BingJian_SpringFestival = {}
setmetatable(SuitEquipList_BingJian_SpringFestival, LuaClass.SuitEquipList_Base)

function SuitEquipList_BingJian_SpringFestival:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.BINGJIAN_SPRINGFESTIVAL
end

function SuitEquipList_BingJian_SpringFestival:NewSuitItem(data)
  return LuaClass.SuitEquipItem_BingJian_SpringFestival:New()
end

function SuitEquipList_BingJian_SpringFestival:GetSuitType()
  return EquipCellType.BINGJIAN_SPRINGFESTIVAL
end

return SuitEquipList_BingJian_SpringFestival
