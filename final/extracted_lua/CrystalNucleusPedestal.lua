CrystalNucleusPedestal = class()
CrystalNucleusPedestal.m_CrystalNucleusPedestalPointTab = nil
CrystalNucleusPedestal.m_CrystalNucleusEquipTab = nil
CrystalNucleusPedestal.m_Level = 0

local function pairsByKeys(t)
  local keysTab = {}
  for key, _ in pairs(t) do
    keysTab[table.count(keysTab) + 1] = key
  end
  table.sort(keysTab)
  local index = 0
  return function()
    index = index + 1
    return keysTab[index], t[keysTab[index]]
  end
end

function CrystalNucleusPedestal:InitPedestalData(_pedestalStr)
  self.m_CrystalNucleusPedestalPointTab = CrystalNucleusUtility:ConstructDataStructure(_pedestalStr, CrystalNucleusPointType.FixedCrystalNucleusPoint)
  if self.m_CrystalNucleusPedestalPointTab == nil then
    return
  end
  self:RefreshLevel(0)
  self:RefreshUnlockPoint()
end

function CrystalNucleusPedestal:RefreshCrystalNucleusPedestal(_tblData)
  if _tblData == nil then
    return
  end
  self:RefreshLevel(_tblData.diskLevel)
  self:RefreshUnlockPoint()
  self:RefreshPedestalPointEquipInfo(_tblData.equipInfos)
  self:RefreshEquipInfo(_tblData.equipInfos)
end

function CrystalNucleusPedestal:RefreshCrystalNucleusEquipInfo(_tblData)
  if _tblData == nil then
    return
  end
  local equipItem = self:GetPedestalEquipDataByOnlyId(_tblData.id)
  if equipItem == nil then
    return
  end
  equipItem:RefreshData(_tblData)
  EventManager.Dispatch(Event.CrystalNucleusItemInfoChange, equipItem)
end

function CrystalNucleusPedestal:RefreshLevel(_level)
  if _level == nil then
    return
  end
  self.m_Level = _level
end

function CrystalNucleusPedestal:RefreshUnlockPoint()
  local puzzleHoleTab = ClientTable.cfg_puzzle_holeManager:GetDic()
  if puzzleHoleTab == nil or next(puzzleHoleTab) == nil or self.m_Level == nil then
    return
  end
  for i, v in pairs(puzzleHoleTab) do
    if v and v.unlockLevel and v.position and self.m_Level >= v.unlockLevel then
      for i, v in pairs(v.position) do
        local point = self:GetPedestalPointByIndex(v)
        if point then
          point:RefreshUnlockState(true)
        end
      end
    end
  end
end

function CrystalNucleusPedestal:RefreshPedestalPointEquipInfo(_equipInfoList)
  if _equipInfoList == nil then
    return
  end
  self:ResetPedestalPointEquipInfo()
  for i, itemEquip in ipairs(_equipInfoList) do
    for j, itemGrid in ipairs(itemEquip.grids) do
      local point = self:GetPoint(itemGrid.row, itemGrid.col)
      if point == nil then
        return
      end
      point:RefreshEquipData(itemEquip.itemInfos)
    end
  end
end

function CrystalNucleusPedestal:RefreshEquipInfo(_equipInfoList)
  if _equipInfoList == nil then
    return
  end
  self.m_CrystalNucleusEquipTab = {}
  for i, itemEquip in ipairs(_equipInfoList) do
    if itemEquip and itemEquip.itemInfos then
      local equipItem = self:GetPedestalEquipDataByOnlyId(itemEquip.itemInfos.id)
      if equipItem == nil then
        local crystalNucleusEquipItemData = CrystalNucleusBagItemData()
        crystalNucleusEquipItemData:RefreshData(itemEquip.itemInfos)
        table.insert(self.m_CrystalNucleusEquipTab, crystalNucleusEquipItemData)
      end
    end
  end
end

function CrystalNucleusPedestal:GetPedestalEquipDataByOnlyId(_id)
  if _id == nil or self.m_CrystalNucleusEquipTab == nil or table.count(self.m_CrystalNucleusEquipTab) == 0 then
    return nil
  end
  for i, v in pairs(self.m_CrystalNucleusEquipTab) do
    if v and v.m_ServerInfo and v.m_ServerInfo.id == _id then
      return v
    end
  end
  return nil
end

function CrystalNucleusPedestal:GetPoint(_row, _column)
  if _row == nil or _column == nil or self.m_CrystalNucleusPedestalPointTab == nil or self.m_CrystalNucleusPedestalPointTab[_row] == nil then
    return
  end
  return self.m_CrystalNucleusPedestalPointTab[_row][_column]
end

function CrystalNucleusPedestal:GetPedestalPointTab()
  return self.m_CrystalNucleusPedestalPointTab
end

function CrystalNucleusPedestal:GetCrystalNucleusEquipTab()
  return self.m_CrystalNucleusEquipTab
end

function CrystalNucleusPedestal:GetPedestalLevel()
  return self.m_Level
end

function CrystalNucleusPedestal:ResetPedestalPointEquipInfo()
  if self.m_CrystalNucleusPedestalPointTab == nil then
    return
  end
  for i, v in pairs(self.m_CrystalNucleusPedestalPointTab) do
    for j, k in pairs(v) do
      if k and k.RemoveEquipData then
        k:RemoveEquipData()
      end
    end
  end
end

function CrystalNucleusPedestal:GetPedestalPointByIndex(_index)
  if self.m_CrystalNucleusPedestalPointTab == nil then
    return nil
  end
  if self.indexPedestalPointTab == nil then
    self.indexPedestalPointTab = {}
  end
  if self.indexPedestalPointTab[_index] == nil then
    for i, v in pairs(self.m_CrystalNucleusPedestalPointTab) do
      for j, k in pairs(v) do
        if k and k.m_Index then
          self.indexPedestalPointTab[k.m_Index] = k
        end
      end
    end
  end
  return self.indexPedestalPointTab[_index]
end

function CrystalNucleusPedestal:CheckIsPutOnEquipById(_id)
  if _id == nil or self.m_CrystalNucleusEquipTab == nil then
    return false
  end
  for i, v in pairs(self.m_CrystalNucleusEquipTab) do
    if v.m_ServerInfo.id == _id then
      return true
    end
  end
  return false
end

function CrystalNucleusPedestal:CheckPutIn(_hitPoint, _preparePointTab)
  if _hitPoint == nil or _preparePointTab == nil then
    return nil
  end
  local putIn = true
  local openList, closeList, fixedList, index = {}, {}, {}, 0
  local preparePoint, fixedPoint = CrystalNucleusUtility:GetCrystalNucleusOccupyPointByIndex(_preparePointTab, 1), _hitPoint
  if preparePoint == nil then
    return nil
  end
  table.insert(fixedList, fixedPoint)
  if not _hitPoint:CheckPutInCondition() then
    putIn = false
  end
  table.insert(openList, preparePoint)
  while 0 < #openList do
    index = index + 1
    fixedPoint = fixedList[index]
    preparePoint = openList[1]
    for i, v in pairsByKeys(preparePoint.m_StructureList) do
      if v and not CrystalNucleusUtility:CheckTableHaveValue(closeList, v) and v.m_Occupy then
        if fixedPoint.m_StructureList[i] == nil or fixedPoint.m_StructureList[i] ~= nil and not fixedPoint.m_StructureList[i]:CheckPutInCondition() then
          putIn = false
        end
        if not CrystalNucleusUtility:CheckTableHaveValue(openList, v) and fixedPoint.m_StructureList[i] ~= nil then
          table.insert(openList, v)
          table.insert(fixedList, fixedPoint.m_StructureList[i])
        end
      end
    end
    table.remove(openList, 1)
    table.insert(closeList, preparePoint)
  end
  return putIn, fixedList
end
