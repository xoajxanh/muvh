local SuitEquipList_BingJian = {}
setmetatable(SuitEquipList_BingJian, LuaClass.SuitEquipList_Base)
SuitEquipList_BingJian.type = nil

function SuitEquipList_BingJian:Init(param)
  self.type = param
end

function SuitEquipList_BingJian:IsSuitItem(data)
  local cellTbl = self:GetEquipCellTblByBagInfo(data)
  if cellTbl == nil or cellTbl.cellType == nil then
    return false
  end
  return self.type and cellTbl.cellType == self.type
end

function SuitEquipList_BingJian:NewSuitItem(data)
  return LuaClass.SuitEquipItem_BingJian:New()
end

function SuitEquipList_BingJian:GetSuitType()
  return self.type or EquipCellType.NORMAL
end

return SuitEquipList_BingJian
