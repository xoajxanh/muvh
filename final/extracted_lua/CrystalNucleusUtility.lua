CrystalNucleusUtility = {}

function CrystalNucleusUtility:ConstructDataStructure(_pedestalString, _crystalNucleusPointType)
  if string.isNullOrEmpty(_pedestalString) or _crystalNucleusPointType == nil then
    return
  end
  local pedestalTab = self:StringToNestedTable(_pedestalString)
  if pedestalTab == nil or table.count(pedestalTab) == 0 then
    return
  end
  local crystalNucleusPointTab, pointType, index = {}, nil, 0
  for i = 1, #pedestalTab do
    for j = 1, #pedestalTab[i] do
      if crystalNucleusPointTab[i] == nil then
        crystalNucleusPointTab[i] = {}
      end
      index = index + 1
      pointType = pedestalTab[i][j]
      if pointType ~= CrystalNucleusPedestalPointType.Invalid then
        local point
        if _crystalNucleusPointType == CrystalNucleusPointType.FixedCrystalNucleusPoint then
          point = FixedCrystalNucleusPoint()
          point.m_Index = index
        elseif _crystalNucleusPointType == CrystalNucleusPointType.TempCrystalNucleusPoint then
          point = CrystalNucleusPointBase()
        else
          return
        end
        point:InitBasicData(i, j, pointType)
        crystalNucleusPointTab[i][j] = point
      end
    end
  end
  local mid = math.ceil(CrystalNucleusPedestalData.Row / 2)
  for i = 1, #pedestalTab do
    local currentPoint
    for j = 1, #pedestalTab[i] do
      currentPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i, j)
      if currentPoint then
        currentPoint.m_LeftTopPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i - 1, i <= mid and j - 1 or j)
        currentPoint.m_RightTopPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i - 1, i <= mid and j or j + 1)
        currentPoint.m_LeftPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i, j - 1)
        currentPoint.m_RightPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i, j + 1)
        currentPoint.m_LeftBottomPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i + 1, i < mid and j or j - 1)
        currentPoint.m_RightBottomPoint = self:GetCrystalNucleusPoint(crystalNucleusPointTab, i + 1, i < mid and j + 1 or j)
        currentPoint:InitStructureList()
      end
    end
  end
  return crystalNucleusPointTab
end

function CrystalNucleusUtility:StringToNestedTable(_pedestalStr)
  local result = {}
  for rowStr in string.gmatch(_pedestalStr, "([^&]+)") do
    local innerArray = {}
    for element in string.gmatch(rowStr, "([^#]+)") do
      table.insert(innerArray, tonumber(element))
    end
    table.insert(result, innerArray)
  end
  return result
end

function CrystalNucleusUtility:GetCrystalNucleusPoint(_crystalNucleusPedestalPointTab, _row, _column)
  if _crystalNucleusPedestalPointTab == nil or _row == nil or _column == nil or _crystalNucleusPedestalPointTab[_row] == nil then
    return
  end
  return _crystalNucleusPedestalPointTab[_row][_column] or nil
end

function CrystalNucleusUtility:GetCrystalNucleusOccupyPointByIndex(_crystalNucleusPointTab, _index)
  if _crystalNucleusPointTab == nil or _index == nil then
    return
  end
  local index = 0
  for i, v in ipairs(_crystalNucleusPointTab) do
    if i and v then
      for j, k in ipairs(v) do
        if k.m_Occupy then
          index = index + 1
          if index == _index then
            return k
          end
        end
      end
    end
  end
end

function CrystalNucleusUtility:CheckTableHaveValue(_tableList, _point)
  if _tableList == nil or _point == nil then
    return false
  end
  for i, v in pairs(_tableList) do
    if v.m_Row == _point.m_Row and v.m_Column == _point.m_Column then
      return true
    end
  end
  return false
end

function CrystalNucleusUtility:CheckEntryTableHaveValue(puzzle)
  local puzzleType, puzzleValue = "", ""
  local minValue, maxValue, name
  if puzzle and puzzle.uiWordAttribute then
    if string.find(puzzle.uiWordAttribute, "&") then
      local str = string.split(puzzle.uiWordAttribute, "&")
      local table = string.split(str[1], "#")
      if table[1] == "minimumPhysBaseDmg" then
        local careerId = QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer()
        if careerId == 12 then
          minValue = math.floor(string.split(str[3], "#")[2])
          maxValue = math.floor(string.split(str[4], "#")[2])
          name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("minimumWizBaseDmg").puzzleIntensifyUI
        elseif careerId == 16 then
          minValue = math.floor(string.split(str[5], "#")[2])
          maxValue = math.floor(string.split(str[6], "#")[2])
          name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("minimumCurseBaseDmg").puzzleIntensifyUI
        else
          minValue = math.floor(string.split(str[1], "#")[2])
          maxValue = math.floor(string.split(str[2], "#")[2])
          name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("minimumPhysBaseDmg").puzzleIntensifyUI
        end
      elseif table[1] == "minimumPhysAndWizDmg_mul" then
        minValue = math.floor(tonumber(string.split(str[1], "#")[2])) / 100
        puzzleType = "%"
        name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("minimumPhysAndWizDmg_mul").puzzleIntensifyUI
      elseif table[1] == "attackRatePvm" or table[1] == "defenseRatePvm" then
        minValue = math.floor(tonumber(string.split(str[1], "#")[2]))
        name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(table[1]).puzzleIntensifyUI
      elseif table[1] == "career_maximumHealth" then
        for i = 2, #str do
          local careerStr = string.split(str[i], "#")
          if tonumber(careerStr[1]) == QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() then
            minValue = math.floor(tonumber(careerStr[2]))
            break
          end
        end
        name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue("career_maximumHealth").puzzleIntensifyUI
      end
    else
      local table = string.split(puzzle.uiWordAttribute, "#")
      if table[1] == "defenseBase" or table[1] == "maximumHealth" then
        minValue = tonumber(table[2])
      elseif table[1] == "baseDefenseByLevel" or table[1] == "physAndWizDmgLevel" or table[1] == "baseLifeByLevel" then
        minValue = tonumber(table[2]) / 10000
        puzzleValue = ClientTable.cfg_Global_globalManager:TryGetValue(64000005).effect
      else
        minValue = math.floor(tonumber(table[2])) / 100
        puzzleType = "%"
      end
      name = ClientTable.cfg_Ui_word_attributeManager:TryGetValue(table[1]).puzzleIntensifyUI
    end
  end
  return minValue, maxValue, name, puzzleType, puzzleValue
end
