SpaceCalcUtility = {}
local this = SpaceCalcUtility
local freeList = {}
local useList = {}

function SpaceCalcUtility.Find(width, height, fL, uL)
  freeList = fL
  useList = uL
  local newNode = this.FindPosition(width, height)
  return newNode
end

function SpaceCalcUtility.Insert(width, height, fL, uL)
  freeList = fL
  useList = uL
  local newNode = this.FindPosition(width, height)
  this.InsertNode(newNode)
  return newNode
end

function SpaceCalcUtility.InsertUseNode(newNode, fL, uL)
  freeList = fL
  useList = uL
  this.InsertNode(newNode)
  return newNode
end

function SpaceCalcUtility.RecycleFreeNode(freeNode, fL, uL)
  freeList = fL
  useList = uL
  for i = #useList, 1, -1 do
    if useList[i]:Equal(freeNode) then
      table.remove(useList, i)
      break
    end
  end
  this.SpliteRecycleNode(freeNode)
  for i = 1, #freeList do
    this.ExtendFreeNode(freeList[i])
  end
  this.PruneFreeList()
  this.MergeFreeList()
end

function SpaceCalcUtility.CalcXy(index, col)
  local y = Mathf.Floor((index - 1) / col)
  local x = Mathf.Floor(index % col)
  x = x == 0 and col or x
  x = x - 1
  return x, y
end

function SpaceCalcUtility.FindPosition(width, height)
  local bestNode = ItemCellData()
  for i = 1, #freeList do
    if width <= freeList[i].width and height <= freeList[i].height then
      bestNode.x = freeList[i].x
      bestNode.y = freeList[i].y
      bestNode.width = width
      bestNode.height = height
      break
    end
  end
  return bestNode
end

function SpaceCalcUtility.InsertNode(newNode)
  if newNode.height == 0 then
    return
  end
  local numRectanglesToProcess = #freeList
  local removeList = {}
  for i = 1, numRectanglesToProcess do
    if this.SplitFreeNode(freeList[i], newNode) then
      table.insert(removeList, freeList[i])
    end
  end
  for _, freeNode in ipairs(removeList) do
    local index = table.getKey(freeList, freeNode)
    if index then
      table.remove(freeList, index)
    end
  end
  for i = 1, #freeList do
    this.ExtendFreeNode(freeList[i])
  end
  this.PruneFreeList()
  this.MergeFreeList()
  table.insert(useList, newNode)
  return
end

local function CheckNode(tbl, node)
  table.insert(tbl, node)
end

function SpaceCalcUtility.SplitFreeNode(freeNode, usedNode)
  local isSplit = false
  if usedNode.y == freeNode.y and usedNode.x == freeNode.x and usedNode.y - usedNode.height == freeNode.y - freeNode.height and usedNode.x + usedNode.width == freeNode.x + freeNode.width then
    isSplit = true
  end
  if usedNode.y > freeNode.y - freeNode.height and usedNode.y - usedNode.height < freeNode.y then
    if usedNode.x > freeNode.x and usedNode.x < freeNode.x + freeNode.width then
      local newNode = ItemCellData()
      newNode:RefreshRect(freeNode)
      newNode.width = usedNode.x - newNode.x
      isSplit = true
      CheckNode(freeList, newNode)
    end
    if usedNode.x + usedNode.width > freeNode.x and usedNode.x + usedNode.width < freeNode.x + freeNode.width then
      local newNode = ItemCellData()
      newNode:RefreshRect(freeNode)
      newNode.width = freeNode.x + freeNode.width - (usedNode.x + usedNode.width)
      newNode.x = usedNode.x + usedNode.width
      isSplit = true
      CheckNode(freeList, newNode)
    end
  end
  if usedNode.x < freeNode.x + freeNode.width and usedNode.x + usedNode.width > freeNode.x then
    if usedNode.y < freeNode.y and usedNode.y >= freeNode.y - freeNode.height then
      local newNode = ItemCellData()
      newNode:RefreshRect(freeNode)
      newNode.height = Mathf.Abs(usedNode.y - newNode.y)
      isSplit = true
      CheckNode(freeList, newNode)
    end
    if usedNode.y - usedNode.height < freeNode.y and usedNode.y - usedNode.height > freeNode.y - freeNode.height then
      local newNode = ItemCellData()
      newNode:RefreshRect(freeNode)
      newNode.y = usedNode.y - usedNode.height
      newNode.height = Mathf.Abs(freeNode.y - freeNode.height - (usedNode.y - usedNode.height))
      isSplit = true
      CheckNode(freeList, newNode)
    end
  end
  return isSplit
end

function SpaceCalcUtility.IsContainedIn(a, b)
  return a.x >= b.x and a.y <= b.y and a.x + a.width <= b.x + b.width and a.y - a.height >= b.y - b.height
end

local function MergeAdjoinFreeNode(a, b)
  local canMerge = false
  if a.x == b.x and a.width == b.width then
    if a.y - a.height == b.y then
      a.height = a.height + b.height
      canMerge = true
    elseif b.y - b.height == a.y then
      a.y = b.y
      a.height = a.height + b.height
      canMerge = true
    end
  end
  if a.y == b.y and a.height == b.height then
    if a.x + a.width == b.x then
      a.width = a.width + b.width
      canMerge = true
    elseif b.x + b.width == a.x then
      a.x = b.x
      a.width = a.width + b.width
      canMerge = true
    end
  end
  return canMerge
end

function SpaceCalcUtility.MergeFreeList()
  table.sort(freeList, function(a, b)
    if a.y > b.y then
      return true
    elseif a.y == b.y then
      return a.x < b.x
    else
      return false
    end
  end)
  local i = 1
  local j = i + 1
  while i <= #freeList and j <= #freeList do
    if MergeAdjoinFreeNode(freeList[i], freeList[j]) then
      table.remove(freeList, j)
    else
      j = j + 1
    end
    if j > #freeList then
      i = i + 1
      j = i + 1
    end
  end
end

function SpaceCalcUtility.PruneFreeList()
  local i = 1
  local j = i + 1
  while i <= #freeList and j <= #freeList do
    if this.IsContainedIn(freeList[i], freeList[j]) then
      table.remove(freeList, i)
      j = i + 1
    else
      j = j + 1
    end
    if j > #freeList then
      i = i + 1
      j = i + 1
    end
  end
  i = #freeList
  j = i - 1
  while i <= #freeList and 1 <= i and j <= #freeList and 1 <= j do
    if this.IsContainedIn(freeList[i], freeList[j]) then
      table.remove(freeList, i)
      i = i - 1
      j = i - 1
    else
      j = j - 1
    end
    if j < 1 then
      i = i - 1
      j = i - 1
    end
  end
end

function SpaceCalcUtility.SpliteRecycleNode(freeNode)
  local needInsertNode = {}
  table.insert(needInsertNode, freeNode)
  for i = 1, #freeList do
    if freeList[i].x + freeList[i].width == freeNode.x then
      if freeList[i].y < freeNode.y and freeList[i].y > freeNode.y - freeNode.height and freeList[i].y - freeList[i].height < freeNode.y - freeNode.height then
        local a = ItemCellData()
        a.x = freeList[i].x
        a.y = freeList[i].y
        a.width = freeNode.width + freeList[i].width
        a.height = Mathf.Abs(freeNode.y - freeNode.height - freeList[i].y)
        table.insert(needInsertNode, a)
      end
      if freeList[i].y > freeNode.y and freeList[i].y - freeList[i].height < freeNode.y and freeList[i].y - freeList[i].height > freeNode.y - freeNode.height then
        local a = ItemCellData()
        a.x = freeList[i].x
        a.y = freeNode.y
        a.width = freeNode.width + freeList[i].width
        a.height = Mathf.Abs(freeList[i].y - freeList[i].height - freeNode.y)
        table.insert(needInsertNode, a)
      end
    end
    if freeList[i].x == freeNode.x + freeNode.width then
      if freeList[i].y < freeNode.y and freeList[i].y > freeNode.y - freeNode.height and freeList[i].y - freeList[i].height < freeNode.y - freeNode.height then
        local a = ItemCellData()
        a.x = freeNode.x
        a.y = freeList[i].y
        a.width = freeNode.width + freeList[i].width
        a.height = Mathf.Abs(freeNode.y - freeNode.height - freeList[i].y)
        table.insert(needInsertNode, a)
      end
      if freeList[i].y > freeNode.y and freeList[i].y - freeList[i].height < freeNode.y and freeList[i].y - freeList[i].height > freeNode.y - freeNode.height then
        local a = ItemCellData()
        a.x = freeNode.x
        a.y = freeNode.y
        a.width = freeNode.width + freeList[i].width
        a.height = Mathf.Abs(freeList[i].y - freeList[i].height - freeNode.y)
        table.insert(needInsertNode, a)
      end
    end
    if freeList[i].y - freeList[i].height == freeNode.y then
      if freeList[i].x < freeNode.x and freeList[i].x + freeList[i].width > freeNode.x and freeList[i].x + freeList[i].width < freeNode.x + freeNode.width then
        local a = ItemCellData()
        a.x = freeNode.x
        a.y = freeList[i].y
        a.width = freeList[i].x + freeList[i].width - freeNode.x
        a.height = freeNode.height + freeList[i].height
        table.insert(needInsertNode, a)
      end
      if freeList[i].x + freeList[i].width > freeNode.x + freeNode.width and freeList[i].x > freeNode.x and freeList[i].x < freeNode.x + freeNode.width then
        local a = ItemCellData()
        a.x = freeList[i].x
        a.y = freeList[i].y
        a.width = freeNode.x + freeNode.width - freeList[i].x
        a.height = freeNode.height + freeList[i].height
        table.insert(needInsertNode, a)
      end
    end
    if freeList[i].y == freeNode.y - freeNode.height then
      if freeList[i].x < freeNode.x and freeList[i].x + freeList[i].width > freeNode.x and freeList[i].x + freeList[i].width < freeNode.x + freeNode.width then
        local a = ItemCellData()
        a.x = freeNode.x
        a.y = freeNode.y
        a.width = freeList[i].x + freeList[i].width - freeNode.x
        a.height = freeNode.height + freeList[i].height
        table.insert(needInsertNode, a)
      end
      if freeList[i].x + freeList[i].width > freeNode.x + freeNode.width and freeList[i].x > freeNode.x and freeList[i].x < freeNode.x + freeNode.width then
        local a = ItemCellData()
        a.x = freeList[i].x
        a.y = freeNode.y
        a.width = freeNode.x + freeNode.width - freeList[i].x
        a.height = freeNode.height + freeList[i].height
        table.insert(needInsertNode, a)
      end
    end
  end
  for _, v in ipairs(needInsertNode) do
    table.insert(freeList, v)
  end
end

function SpaceCalcUtility.ExtendFreeNode(freeNode)
  for i = 1, #freeList do
    if freeNode ~= freeList[i] then
      local maxTop = 0
      local maxBottom = 0
      local maxLeft = 0
      local maxRight = 0
      if freeNode.x >= freeList[i].x and freeNode.x + freeNode.width <= freeList[i].x + freeList[i].width then
        if freeNode.y - freeNode.height <= freeList[i].y and freeNode.y - freeNode.height >= freeList[i].y - freeList[i].height then
          local h = Mathf.Abs(freeList[i].y - freeList[i].height - (freeNode.y - freeNode.height))
          maxBottom = Mathf.Max(maxBottom, h)
        end
        if freeNode.y <= freeList[i].y and freeNode.y >= freeList[i].y - freeList[i].height then
          local h = Mathf.Abs(freeNode.y - freeList[i].y)
          maxTop = Mathf.Max(maxTop, h)
        end
      end
      if freeNode.y <= freeList[i].y and freeNode.y - freeNode.height >= freeList[i].y - freeList[i].height then
        if freeNode.x + freeNode.width >= freeList[i].x and freeNode.x + freeNode.width <= freeList[i].x + freeList[i].width then
          local w = Mathf.Abs(freeList[i].x + freeList[i].width - (freeNode.x + freeNode.width))
          maxRight = Mathf.Max(maxRight, w)
        end
        if freeNode.x <= freeList[i].x + freeList[i].width and freeNode.x >= freeList[i].x then
          local w = Mathf.Abs(freeNode.x - freeList[i].x)
          maxLeft = Mathf.Max(maxLeft, w)
        end
      end
      freeNode.height = freeNode.height + maxBottom + maxTop
      freeNode.width = freeNode.width + maxRight + maxLeft
      freeNode.x = freeNode.x - maxLeft
      freeNode.y = freeNode.y + maxTop
    end
  end
end
