local SuitEquipList_BingJian_YuanTianYueBai = {}
setmetatable(SuitEquipList_BingJian_YuanTianYueBai, LuaClass.SuitEquipList_Base)

function SuitEquipList_BingJian_YuanTianYueBai:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return cellTbl.cellType == EquipCellType.BINGJIAN_YuanTianYueBai
end

function SuitEquipList_BingJian_YuanTianYueBai:NewSuitItem(data)
  return LuaClass.SuitEquipItem_BingJian_YuanTianYueBai:New()
end

function SuitEquipList_BingJian_YuanTianYueBai:GetSuitType()
  return EquipCellType.BINGJIAN_YuanTianYueBai
end

return SuitEquipList_BingJian_YuanTianYueBai
