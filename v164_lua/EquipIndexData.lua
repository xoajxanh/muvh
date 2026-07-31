local EquipIndexData = {}
EquipIndexData.equipIndex = nil

function EquipIndexData:InitRefresh(equipIndex)
  self.equipIndex = equipIndex
end

function EquipIndexData:GetEquipCellTbl()
  if self.equipCellTbl ~= nil then
    return self.equipCellTbl
  end
  if self.equipIndex ~= nil then
    self.equipCellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(self.equipIndex)
  end
  return self.equipCellTbl
end

function EquipIndexData:GetEquipItemData()
  if self:GetEquipCellTbl() == nil or self.equipIndex == nil then
    return
  end
  return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleEquipByEquipIndex(self.equipIndex)
end

function EquipIndexData:GetGemListData()
  if self.mGemListData == nil then
    self.mGemListData = LuaClass.GemListData:New()
    self.mGemListData:InitRefresh(self.equipIndex)
  end
  return self.mGemListData
end

return EquipIndexData
