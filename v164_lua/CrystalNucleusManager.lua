CrystalNucleusManager = {}
CrystalNucleusManager.m_FixedCrystalNucleusPedestal = nil

function CrystalNucleusManager:OnEnterGame()
  local pedestalStr = GlobalConfig.GetGlobalConfig(64000003)
  if string.isNullOrEmpty(pedestalStr) then
    return
  end
  self.m_FixedCrystalNucleusPedestal = CrystalNucleusPedestal()
  self.m_FixedCrystalNucleusPedestal:InitPedestalData(pedestalStr)
end

function CrystalNucleusManager:RefreshCrystalNucleusInfo(_tblData)
  if self.m_FixedCrystalNucleusPedestal == nil then
    return
  end
  self.m_FixedCrystalNucleusPedestal:RefreshCrystalNucleusPedestal(_tblData)
  EventManager.Dispatch(Event.CrystalNucleusPedestalChange)
end

function CrystalNucleusManager:RefreshCrystalNucleusEquipInfo(_tblData)
  if _tblData == nil or self.m_FixedCrystalNucleusPedestal == nil then
    return
  end
  self.m_FixedCrystalNucleusPedestal:RefreshCrystalNucleusEquipInfo(_tblData)
end

function CrystalNucleusManager:GetPoint(_row, _column)
  if self.m_FixedCrystalNucleusPedestal == nil then
    return nil
  end
  return self.m_FixedCrystalNucleusPedestal:GetPoint(_row, _column)
end

function CrystalNucleusManager:GetPedestalPointTab()
  if self.m_FixedCrystalNucleusPedestal == nil then
    return nil
  end
  return self.m_FixedCrystalNucleusPedestal:GetPedestalPointTab()
end

function CrystalNucleusManager:GetPedestalPointByIndex(_index)
  if _index == nil or self.m_FixedCrystalNucleusPedestal == nil then
    return nil
  end
  return self.m_FixedCrystalNucleusPedestal:GetPedestalPointByIndex(_index)
end

function CrystalNucleusManager:GetCrystalNucleusEquipTab()
  if self.m_FixedCrystalNucleusPedestal == nil then
    return nil
  end
  return self.m_FixedCrystalNucleusPedestal:GetCrystalNucleusEquipTab()
end

function CrystalNucleusManager:GetPedestalLevel()
  if self.m_FixedCrystalNucleusPedestal == nil then
    return nil
  end
  return self.m_FixedCrystalNucleusPedestal:GetPedestalLevel()
end

function CrystalNucleusManager:CheckIsPutOnEquipById(_id)
  if _id == nil or self.m_FixedCrystalNucleusPedestal == nil then
    return false
  end
  return self.m_FixedCrystalNucleusPedestal:CheckIsPutOnEquipById(_id)
end

function CrystalNucleusManager:CheckPutIn(_hitPoint, _pedestalStr)
  if self.m_FixedCrystalNucleusPedestal == nil or _hitPoint == nil or string.isNullOrEmpty(_pedestalStr) == nil then
    return nil
  end
  local tempPointTab = CrystalNucleusUtility:ConstructDataStructure(_pedestalStr, CrystalNucleusPointType.TempCrystalNucleusPoint)
  return self.m_FixedCrystalNucleusPedestal:CheckPutIn(_hitPoint, tempPointTab)
end
