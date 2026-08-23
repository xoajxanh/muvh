local BagGridCalcManager = {}
BagGridCalcManager.BagGridDic = nil
BagGridCalcManager.Line = nil
BagGridCalcManager.Row = nil
BagGridCalcManager.SpaceDataIsDirty = nil
BagGridCalcManager.usedList = nil
BagGridCalcManager.freeList = nil

function BagGridCalcManager:SetBagGridDic(line, row, itemCellDataList)
  if line == nil or row == nil then
    return
  end
  self:ResetData()
  if self.BagGridDic == nil then
    self:InitBagGridDic(line, row)
  else
    self:ExpansionBagGirdDic(line, row)
  end
  if itemCellDataList ~= nil then
    self:InsertItemList(itemCellDataList)
  end
end

function BagGridCalcManager:InitBagGridDic(line, row)
  self.BagGridDic = {}
  self.Line = line
  self.Row = row
  for lineIndex = 0, line - 1 do
    for rowIndex = 0, row - 1 do
      self:InsertBagGrid(lineIndex, rowIndex)
    end
  end
end

function BagGridCalcManager:ExpansionBagGirdDic(line, row)
  if line < self.Line then
    for lineIndex = line, self.Line - 1 do
      self.BagGridDic[lineIndex] = nil
    end
  elseif line > self.Line then
    for lineIndex = self.Line, line - 1 do
      for rowIndex = 0, row - 1 do
        self:InsertBagGrid(lineIndex, rowIndex)
      end
    end
  end
  self.Line = line
  self.Row = row
end

function BagGridCalcManager:InsertBagGrid(line, row)
  if self.BagGridDic[line] == nil then
    self.BagGridDic[line] = {}
  end
  local bagGrid = LuaClass.BagGrid:New()
  bagGrid:RefreshData(line, row)
  self.BagGridDic[line][row] = bagGrid
end

function BagGridCalcManager:ResetData()
  self.SpaceDataIsDirty = true
  self.usedList = {}
  self.freeList = {}
  if self.BagGridDic ~= nil then
    for k, v in pairs(self.BagGridDic) do
      for index, bagGrid in pairs(v) do
        bagGrid:ResetData()
      end
    end
  end
end

function BagGridCalcManager:TryInsertItem(width, height)
  local freeCellData, itemCellData = self:FindFreeCell(width, height)
  if freeCellData ~= nil then
    local divisor = 1 / BagInfoData.cellSize
    itemCellData = ItemCellData()
    itemCellData:RefreshRect({
      x = freeCellData.x,
      y = freeCellData.y,
      width = width,
      height = height
    })
    itemCellData:SetCellConfigSize(width * divisor, height * divisor)
    self:InsertItemCellData(itemCellData)
  end
  return itemCellData
end

function BagGridCalcManager:InsertItemCellData(itemCellData)
  if itemCellData == nil then
    return
  end
  local configWidth, configHeight = itemCellData:GetCellConfigSize()
  if itemCellData:CheckHaveBaseData() == false or self:CheckCanInsertGrid(itemCellData.UnitX, itemCellData.UnitY, configWidth, configHeight) == false then
    return
  end
  self.SpaceDataIsDirty = true
  table.insert(self.usedList, itemCellData)
  for curY = itemCellData.UnitY, itemCellData.UnitY + configHeight - 1 do
    for curX = itemCellData.UnitX, itemCellData.UnitX + configWidth - 1 do
      self.BagGridDic[curY][curX]:OccupyGrid()
    end
  end
end

function BagGridCalcManager:InsertItem(itemData)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  local itemCellData = ItemCellData()
  itemCellData:RefreshData(itemData)
  itemCellData:SetCellUnitPosition(itemData.bagGridIndex + 1)
  self:InsertItemCellData(itemCellData)
end

function BagGridCalcManager:InsertItemList(itemDataList)
  for k, v in pairs(itemDataList) do
    self:InsertItem(v)
  end
end

function BagGridCalcManager:RemoveItem(itemData)
  if itemData == nil or itemData.tblItem == nil then
    return
  end
  local isUsedCell, useCellIndex = self:CheckIsUsedGrid(itemData.bagGridIndex, itemData.tblItem.xTranslate, itemData.tblItem.yTranslate)
  if isUsedCell == false then
    return
  end
  self.SpaceDataIsDirty = true
  local x, y = self:GetGridPosition(itemData.bagGridIndex)
  local maxX, maxY = x + itemData.tblItem.xTranslate - 1, y + itemData.tblItem.yTranslate - 1
  table.remove(self.usedList, useCellIndex)
  for curY = y, maxY do
    for curX = x, maxX do
      self.BagGridDic[curY][curX]:ResetData()
    end
  end
end

function BagGridCalcManager:RemoveItemList(itemDataList)
  for k, v in pairs(itemDataList) do
    self:RemoveItem(v)
  end
end

function BagGridCalcManager:GetFreeAndUseList()
  if self.SpaceDataIsDirty then
    self.SpaceDataIsDirty = false
    self:CalcFreePointList()
    self:CalcFreeSpaceList()
  end
  return self.freeList, self.usedList
end

function BagGridCalcManager:CalcFreePointList()
  self.FreePointDic = nil
  self.freePointList = nil
  if self.usedList == nil then
    return
  end
  if not self.BagGridDic[0][0].IsOccupy then
    self:AddCalcFreePoint(0, 0)
  end
  local configX, configY
  for k, v in pairs(self.usedList) do
    configX, configY = v:GetCellConfigSize()
    if configX ~= nil and configY ~= nil then
      local xLeftEnd, yUpEnd = self:GetCalcPoint(v.UnitX, v.UnitY, configX, configY)
      if yUpEnd ~= nil then
        self:AddCalcFreePoint(yUpEnd.x, yUpEnd.y)
      end
      if xLeftEnd ~= nil then
        self:AddCalcFreePoint(xLeftEnd.x, xLeftEnd.y)
      end
    end
  end
  if self.freePointList == nil then
    return
  end
  table.sort(self.freePointList, self.SortFreePointList)
end

function BagGridCalcManager:CheckHaveFreePoint(x, y)
  return self.FreePointDic ~= nil and self.FreePointDic[x] ~= nil and self.FreePointDic[x][y] ~= nil
end

function BagGridCalcManager:AddCalcFreePoint(x, y)
  if self:CheckHaveFreePoint(x, y) then
    return
  end
  if self.FreePointDic == nil then
    self.FreePointDic = {}
  end
  if self.FreePointDic[x] == nil then
    self.FreePointDic[x] = {}
  end
  self.FreePointDic[x][y] = true
  if self.freePointList == nil then
    self.freePointList = {}
  end
  table.insert(self.freePointList, {x = x, y = y})
end

function BagGridCalcManager.SortFreePointList(freePoint1, freePoint2)
  return freePoint1.y < freePoint2.y or freePoint1.y == freePoint2.y and freePoint1.x < freePoint2.x
end

function BagGridCalcManager:GetCalcPoint(x, y, width, height)
  local gridInfo = self.BagGridDic[y][x]
  if gridInfo == nil then
    return
  end
  local rightDownX, rightDownY, xLeftEnd, yUpEnd = x + width, y + height
  for curX = rightDownX - 1, 0, -1 do
    if rightDownY >= self.Line then
      break
    end
    if self.BagGridDic[rightDownY][curX].IsOccupy then
      if curX + 1 ~= rightDownX then
        xLeftEnd = Vector2.New(curX + 1, rightDownY)
      end
      break
    end
    if curX == 0 then
      xLeftEnd = Vector2.New(curX, rightDownY)
    end
  end
  for curY = rightDownY - 1, 0, -1 do
    if rightDownX >= self.Row then
      break
    end
    if self.BagGridDic[curY][rightDownX].IsOccupy then
      if curY + 1 ~= rightDownY then
        yUpEnd = Vector2.New(rightDownX, curY + 1)
      end
      break
    end
    if curY == 0 then
      yUpEnd = Vector2.New(rightDownX, curY)
    end
  end
  if xLeftEnd == nil and yUpEnd == nil and self.BagGridDic[rightDownY] ~= nil and self.BagGridDic[rightDownY][rightDownX] ~= nil and self.BagGridDic[rightDownY][rightDownX].IsOccupy == false then
    return Vector2.New(rightDownX, rightDownY)
  end
  return xLeftEnd, yUpEnd
end

function BagGridCalcManager:CalcFreeSpaceList()
  self.freeList = {}
  if self.FreePointDic == nil or next(self.FreePointDic) == nil then
    return
  end
  for k, freePoint in pairs(self.freePointList) do
    local itemCellData = self:CalcFreeSpace(freePoint.x, freePoint.y, BagInfoData.colCount - 1, freePoint.y)
    if itemCellData ~= nil then
      table.insert(self.freeList, itemCellData)
    end
  end
end

function BagGridCalcManager:CalcFreeSpace(x, y, maxX, minY)
  local gridInfo = self.BagGridDic[y][x]
  if gridInfo == nil or gridInfo.IsOccupy or minY >= self.Line or maxX < x then
    return
  end
  for curY = minY, self.Line - 1 do
    for curX = x, maxX do
      if self.BagGridDic[curY][curX].IsOccupy then
        local nextItemCellData = self:CalcFreeSpace(x, y, curX - 1, curY)
        if nextItemCellData ~= nil then
          table.insert(self.freeList, nextItemCellData)
        end
        if minY < curY then
          local itemCellData, width = ItemCellData(), maxX == x and 1 or maxX - x + 1
          itemCellData:RefreshRect({
            x = x * BagInfoData.cellSize,
            y = -y * BagInfoData.cellSize,
            width = width * BagInfoData.cellSize,
            height = (curY - y) * BagInfoData.cellSize
          })
          return itemCellData
        end
        return
      end
    end
  end
  local itemCellData = ItemCellData()
  itemCellData:RefreshRect({
    x = x * BagInfoData.cellSize,
    y = -y * BagInfoData.cellSize,
    width = (maxX - x + 1) * BagInfoData.cellSize,
    height = (self.Line - y) * BagInfoData.cellSize
  })
  return itemCellData
end

function BagGridCalcManager:FindFreeCell(width, height)
  self:GetFreeAndUseList()
  if width == nil or height == nil or self.freeList == nil or next(self.freeList) == nil then
    return
  end
  for k, v in pairs(self.freeList) do
    if width <= v.width and height <= v.height then
      return v
    end
  end
end

function BagGridCalcManager:GetGridPosition(gridIndex)
  return SpaceCalcUtility.CalcXy(gridIndex + 1, 8)
end

function BagGridCalcManager:CheckCanInsertGrid(x, y, width, height)
  if x == nil or y == nil or width == nil or height == nil then
    return false
  end
  local maxX, maxY = x + width - 1, y + height - 1
  for curY = y, maxY do
    for curX = x, maxX do
      if self.BagGridDic == nil or self.BagGridDic[curY] == nil or self.BagGridDic[curY][curX] == nil or self.BagGridDic[curY][curX].IsOccupy then
        return false
      end
    end
  end
  return true
end

function BagGridCalcManager:CheckIsUsedGrid(gridIndex, width, height)
  if gridIndex == nil or width == nil or height == nil or self.usedList == nil then
    return false
  end
  local x, y = self:GetGridPosition(gridIndex)
  if x == nil or y == nil then
    return
  end
  for k, v in pairs(self.usedList) do
    if v:EqualByParam(x, y, width, height) then
      return true, k
    end
  end
  return false
end

function BagGridCalcManager:GetCopyBagCalcManager()
  local bagCalcManagerCopy = table.DeepCopy(self)
  return bagCalcManagerCopy
end

return BagGridCalcManager
