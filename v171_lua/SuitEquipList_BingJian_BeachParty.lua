local SuitEquipList_BingJian_BeachParty = {}
setmetatable(SuitEquipList_BingJian_BeachParty, LuaClass.SuitEquipList_Base)

function SuitEquipList_BingJian_BeachParty:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.BINGJIAN_BeachParty
end

function SuitEquipList_BingJian_BeachParty:NewSuitItem(data)
  return LuaClass.SuitEquipItem_BingJian_BeachParty:New()
end

function SuitEquipList_BingJian_BeachParty:GetSuitType()
  return EquipCellType.BINGJIAN_BeachParty
end

return SuitEquipList_BingJian_BeachParty
