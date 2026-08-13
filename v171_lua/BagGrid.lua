local BagGrid = {}
BagGrid.GridIndex = nil
BagGrid.x = nil
BagGrid.y = nil
BagGrid.IsOccupy = nil
BagGrid.ItemCellData = nil

function BagGrid:GetVector2()
  if self.x == nil or self.y == nil then
    return
  end
  if self.vector2 == nil then
    self.vector2 = Vector2.New(self.x, self.y)
  end
  return self.vector2
end

function BagGrid:RefreshData(x, y)
  self.x = x
  self.y = y
  self.BagGrid = x * BagInfoData.colCount + y
end

function BagGrid:OccupyGrid(itemCellData)
  self.ItemCellData = itemCellData
  self.IsOccupy = true
end

function BagGrid:ResetData()
  self.ItemCellData = nil
  self.IsOccupy = false
end

return BagGrid
