CrystalNucleusPointBase = class()
CrystalNucleusPointBase.m_Row = nil
CrystalNucleusPointBase.m_Column = nil
CrystalNucleusPointBase.m_Occupy = nil
CrystalNucleusPointBase.m_LeftTopPoint = nil
CrystalNucleusPointBase.m_RightTopPoint = nil
CrystalNucleusPointBase.m_LeftPoint = nil
CrystalNucleusPointBase.m_RightPoint = nil
CrystalNucleusPointBase.m_LeftBottomPoint = nil
CrystalNucleusPointBase.m_RightBottomPoint = nil
CrystalNucleusPointBase.m_StructureList = nil

function CrystalNucleusPointBase:InitBasicData(_row, _column, _pointType)
  if _row == nil or _column == nil or _pointType == nil then
    return
  end
  self.m_Row = _row
  self.m_Column = _column
  self.m_Occupy = _pointType == CrystalNucleusPedestalPointType.Occupy
end

function CrystalNucleusPointBase:InitStructureList()
  self.m_StructureList = {
    [1] = self.m_LeftTopPoint,
    [2] = self.m_RightTopPoint,
    [3] = self.m_LeftPoint,
    [4] = self.m_RightPoint,
    [5] = self.m_LeftBottomPoint,
    [6] = self.m_RightBottomPoint
  }
end
