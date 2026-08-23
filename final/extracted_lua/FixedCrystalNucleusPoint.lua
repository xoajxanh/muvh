FixedCrystalNucleusPoint = class(CrystalNucleusPointBase)
FixedCrystalNucleusPoint.m_Index = nil
FixedCrystalNucleusPoint.m_Unlock = nil
FixedCrystalNucleusPoint.m_ServerInfo = nil
FixedCrystalNucleusPoint.m_ItemConfig = nil

function FixedCrystalNucleusPoint:InitBasicData(_row, _column, _pointType)
  CrystalNucleusPointBase.InitBasicData(self, _row, _column, _pointType)
  self.m_Unlock = false
end

function FixedCrystalNucleusPoint:RefreshEquipData(_itemInfo)
  if _itemInfo == nil then
    return
  end
  self.m_ServerInfo = _itemInfo
  self.m_Occupy = true
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(_itemInfo.itemId)
  if itemConfig == nil then
    return
  end
  self.m_ItemConfig = itemConfig
end

function FixedCrystalNucleusPoint:CheckPutInCondition()
  return not self.m_Occupy and self.m_Unlock
end

function FixedCrystalNucleusPoint:RefreshUnlockState(_unlock)
  if _unlock == nil then
    return
  end
  self.m_Unlock = _unlock
end

function FixedCrystalNucleusPoint:RemoveEquipData()
  self.m_Occupy = false
  self.m_ServerInfo = nil
  self.m_ItemConfig = nil
end
