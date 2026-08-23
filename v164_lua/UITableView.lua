require("GameConst/ViewDirectionConst")
UITableView = class()
local this = UITableView
local math = _ENV.math

function UITableView:ctor()
  self:Init()
end

function UITableView:Init()
  self.numberOfCellsAtRowOrColumn = 1
  self.upperMargin = 0
  self.lowerMargin = 100
  self.scrollView = nil
  self.scrollRect = nil
  self.checkView = nil
  self.content = nil
  self.direction = nil
  self.alignment = UIGridViewAlignmentEnum.RightOrTop
  self.isReloaded = nil
  self.normalizedPositionWhenReloaded = nil
  self.isReachingTopmostOrRightmost = false
  self.isReachingBottommostOrLeftmost = false
  self.holders = {}
  self.loadedHolders = {}
  self.swapper = {}
  self.reusableCellQueues = {}
  self.extendCheckRange = 0
  self.scrollViewChangeCallBack = nil
end

function UITableView:CreateTableView(scrollView, tempClone, dataList, tableViewArrangeType, updateCellCallBack, ui)
  if scrollView == nil or tempClone == nil or type(dataList) ~= "table" or tableViewArrangeType == nil or updateCellCallBack == nil then
    return
  end
  local tableView, x, y = UITableView(), tempClone:GetSizeDelta()
  local curCellInfoSize = tableViewArrangeType == EScrollViewDireEnum.Horizontal and x or y
  tableView:SetScrollView(scrollView)
  tableView:SetLowerMargin(0)
  tableView:SetCurScalarForCellInTableView(curCellInfoSize)
  tableView:SetCurDataList(dataList)
  tableView:SetCurClonePrefab(tempClone)
  tableView:SetCellAtIndexInTableViewWillAppear(ui, updateCellCallBack)
  return tableView
end

function UITableView:SetScrollView(scrollView)
  self.scrollView = scrollView
  self.scrollRect = scrollView.scrollRect
  self.viewPort = self.scrollView:GetChild("Viewport")
  self.content = self.scrollView:GetChild("Viewport/Content")
  if self.scrollRect.horizontal then
    self.direction = EScrollViewDireEnum.Horizontal
  end
  if self.scrollRect.vertical then
    self.direction = EScrollViewDireEnum.Vertical
  end
  self:InitializeCellsPool()
  self:AddListenerScrollView()
end

function UITableView:SetTotalCellCount(ui, callback)
  function self.GetTotalCellCount()
    return callback(ui)
  end
end

function UITableView:SetCurDataList(dataList)
  self.curDataList = dataList
  
  function self.GetTotalCellCount()
    if self.curDataList ~= nil then
      return #self.curDataList
    end
  end
end

function UITableView:SetCellAtIndexInTableView(ui, callback)
  function self.CellAtIndexInTableView(index)
    return callback(ui, index)
  end
end

function UITableView:SetCurClonePrefab(prefab)
  self.CurClonePrefab = prefab
  
  function self.CellAtIndexInTableView()
    if self.CurClonePrefab ~= nil then
      return self:ReuseOrCreateCell(self.CurClonePrefab)
    end
  end
end

function UITableView:SetCellAtIndexInTableViewWillAppear(ui, callback)
  function self.CellAtIndexInTableViewWillAppear(index)
    return callback(ui, index)
  end
end

function UITableView:SetReachable(callbackTab)
  self.Reachable = callbackTab
end

function UITableView:SetScalarForCellInTableView(ui, callback)
  function self.ScalarForCellInTableView(index)
    return callback(ui, index)
  end
end

function UITableView:SetCurScalarForCellInTableView(value)
  self.curCurScalarForCellInTableView = value
  
  function self.ScalarForCellInTableView()
    if self.curCurScalarForCellInTableView ~= nil then
      return self.curCurScalarForCellInTableView
    end
  end
end

function UITableView:SetResetCellCallback(ui, callback)
  function self.ResetCell(cell)
    return callback(ui, cell)
  end
end

function UITableView:SetNumberOfCellsAtRowOrColumn(num)
  self.numberOfCellsAtRowOrColumn = num
end

function UITableView:SetAlignment(alignment)
  self.alignment = alignment
end

function UITableView:ReloadData(index)
  self:ReloadDataInternal(index)
end

function UITableView:AddListenerScrollView()
  self.scrollView:RemoveAllOnScrollRectChanged()
  self.scrollView:SetOnScrollRectChanged(self, self.OnScrollPositionChanged)
end

function UITableView:ReuseOrCreateCell(prefab, lifeCycle, isAutoResize)
  lifeCycle = lifeCycle or UITableViewCellLifeCycleEnum.RecycleWhenDisappeared
  if isAutoResize == nil then
    isAutoResize = true
  end
  local cell
  local reuseIdentifier = prefab:GetName()
  if lifeCycle ~= UITableViewCellLifeCycleEnum.DestroyWhenDisappeared then
    local cellsQueue = self.reusableCellQueues[reuseIdentifier]
    if not cellsQueue then
      cellsQueue = {}
      self.reusableCellQueues[reuseIdentifier] = cellsQueue
    elseif 0 < #cellsQueue then
      cell = table.remove(cellsQueue, 1)
      return cell
    end
  end
  cell = prefab:InstantiateWarp()
  cell.reuseIdentifier = reuseIdentifier
  cell.isAutoResize = isAutoResize
  cell.lifeCycle = lifeCycle
  return cell
end

function UITableView:AppendData()
  local oldCount = #self.holders
  local newCount = self:NumberOfCellsInTableView()
  for i = 1, newCount - oldCount do
    local tableViewCellHolder = {
      loadedCell = nil,
      scalar = nil,
      upperMargin = nil,
      lowerMargin = nil,
      position = nil
    }
    table.insert(self.holders, tableViewCellHolder)
  end
  local oldContentSize = Vector2(self.content:GetRectSize())
  local oldAnchoredPosition = Vector2(self.content:GetAnchoredPosition())
  self:ResizeContent(newCount)
  local anPos = oldAnchoredPosition - (Vector2(self.content:GetRectSize()) - oldContentSize) * (Vector2.one - Vector2(self.content:GetPivot()))
  self.content:SetAnchoredPosition(anPos.x, anPos.y)
  self:ReloadCells(Vector2(self.scrollRect:GetNormalizedPosition()), true)
end

function UITableView:RemovedData()
  local oldCount = #self.holders
  local newCount = self:NumberOfCellsInTableView()
  local rangeindex = {}
  if newCount ~= 0 then
    rangeindex.from = 1
    rangeindex.to = newCount
    self:UnloadUnusedCells(rangeindex)
    for i = 1, oldCount - newCount do
      table.remove(self.holders)
    end
  end
end

function UITableView:ScrollToCellAtIndexWithTime(index, time, withUpperMargin, onScrollingFinished)
  if Mathf.Approximately(time, 0) then
    self:ScrollToCell(index, withUpperMargin)
  else
    self:StartAutoScroll(index, time, withUpperMargin, onScrollingFinished)
  end
end

function UITableView:ScrollToCellAtIndex(index)
  self:ScrollToCell(index, false)
end

function UITableView:ScrollToCell(index, withUpperMargin)
  if index > #self.holders or index < 1 then
    return
  end
  local x, y = self:GetNormalizedPositionOfCellAtIndex(index, withUpperMargin)
  self.scrollView:SetNormalizedPosition(x, y)
  x, y = self.scrollView:GetNormalizedPosition()
  local normalizedPosition = Vector2(x, y)
  self:ReloadCells(normalizedPosition, false)
end

function UITableView:SetUpperMargin(upperMargin)
  self.upperMargin = upperMargin
end

function UITableView:SetLowerMargin(lowerMargin)
  self.lowerMargin = lowerMargin
end

function UITableView:GetAllLoadCell()
  return self.loadedHolders
end

function UITableView:NumberOfCellsInTableView()
  return self.GetTotalCellCount()
end

function UITableView:ScalarForUpperMarginInTableView(index)
  return index == 1 and self.upperMargin or 0
end

function UITableView:ScalarForLowerMarginInTableView(index)
  return index == self.GetTotalCellCount() and self.lowerMargin or 0
end

function UITableView:OnScrollPositionChanged(content, offset)
  if self.scrollViewChangeCallBack then
    self.scrollViewChangeCallBack()
  end
  if not self.holders or #self.holders <= 0 then
    return
  end
  local offsetV = Vector2(offset.x, offset.y)
  self:ReloadCells(offsetV, false)
  self:DetectAndNotifyReachableStatus(offsetV)
end

function UITableView:InitializeCellsPool()
  if self.cellsPool then
    return
  end
  local cellsPool = self.scrollRect.transform:Find("ReusableCells")
  if cellsPool then
    self.cellsPool = UIControl(cellsPool.transform)
  else
    local poolObject = CS.UnityEngine.GameObject("ReusableCells")
    self.cellsPool = UIControl(poolObject.transform)
    self.cellsPool:SetParent(self.scrollRect)
  end
end

function UITableView:ReloadDataInternal(startIndex)
  self:UnloadAllCells()
  local oldCount = #self.holders
  local newCount = self:NumberOfCellsInTableView()
  local deltaCount = math.abs(oldCount - newCount)
  for i = 1, deltaCount do
    if oldCount > newCount then
      table.remove(self.holders, 1)
    elseif oldCount < newCount then
      local tableViewCellHolder = {
        loadedCell = nil,
        scalar = nil,
        upperMargin = nil,
        lowerMargin = nil,
        position = nil
      }
      table.insert(self.holders, tableViewCellHolder)
    end
  end
  self:ResizeContent(newCount)
  if newCount == 0 then
    self:SetUnusedCellActive()
    return
  end
  if startIndex then
    self:ScrollToCellAtIndex(startIndex)
  else
    self.isReloaded = true
    local x, y = self.scrollView:GetNormalizedPosition()
    self.normalizedPositionWhenReloaded = Vector2(x, y)
    self:ReloadCells(self.normalizedPositionWhenReloaded, false)
  end
  local x, y = self.scrollView:GetNormalizedPosition()
  local normalizedPos = Vector2(x, y)
  self.isReachingTopmostOrRightmost, self.isReachingBottommostOrLeftmost = self:CalculateReachableStatus(normalizedPos)
end

function UITableView:UnloadAllCells()
  local pos = 1
  for k, v in pairs(self.loadedHolders) do
    self:UnloadCell(k, pos)
    self.swapper[#self.swapper + 1] = k
    pos = pos + 1
  end
  for i, v in ipairs(self.swapper) do
    self.loadedHolders[v] = nil
  end
  self.swapper = {}
end

function UITableView:UnloadUnusedCells(visibleRange)
  for k, v in pairs(self.loadedHolders) do
    if (k < visibleRange.from or k > visibleRange.to) and v.loadedCell.lifeCycle ~= UITableViewCellLifeCycleEnum.RecycleWhenReloaded then
      self:UnloadCell(k)
      self.swapper[#self.swapper + 1] = k
    end
  end
  for i, v in ipairs(self.swapper) do
    self.loadedHolders[v] = nil
  end
  self.swapper = {}
end

function UITableView:UnloadCell(index, quePos)
  local holder = self.holders[index]
  local cell = holder.loadedCell
  if cell.lifeCycle == UITableViewCellLifeCycleEnum.RecycleWhenDisappeared then
  end
  if cell.lifeCycle == UITableViewCellLifeCycleEnum.RecycleWhenReloaded or cell.lifeCycle == UITableViewCellLifeCycleEnum.RecycleWhenDisappeared then
    local cellsQueue = self.reusableCellQueues[cell.reuseIdentifier]
    if quePos then
      if quePos > #cellsQueue then
        table.insert(cellsQueue, cell)
      else
        table.insert(cellsQueue, quePos, cell)
      end
    else
      table.insert(cellsQueue, cell)
    end
    if self.ResetCell then
      self.ResetCell(cell)
    end
    cell:SetParent(self.cellsPool)
    cell:SetActive(false)
  elseif cell.lifeCycle == UITableViewCellLifeCycleEnum.DestroyWhenDisappeared then
    cell:Destroy()
  end
  holder.loadedCell = nil
end

function UITableView:LoadCells(range, alwaysRearrangeCell)
  for k, v in pairs(self.loadedHolders) do
    if k < range.from or k > range.to then
      self:RearrangeCell(k)
    end
  end
  for i = range.from, range.to do
    self.loadedHolders[i] = self.holders[i]
    self:LoadCell(i, alwaysRearrangeCell)
  end
  self:SetUnusedCellActive()
end

function UITableView:SetUnusedCellActive()
  local cellChildCount = self.cellsPool.transform.childCount
  if cellChildCount == 0 then
    return
  end
  for i = 0, cellChildCount - 1 do
    local cell = self.cellsPool.transform:GetChild(i)
    cell = UIControl(cell.transform)
    cell:SetActive(false)
    if cell.selectable then
      cell:SetInteractable(true)
    end
  end
end

function UITableView:LoadCell(index, alwaysRearrangeCell)
  local holder = self.holders[index]
  if holder.loadedCell then
    if alwaysRearrangeCell then
      self:RearrangeCell(index)
    end
    return
  end
  holder.loadedCell = self.CellAtIndexInTableView(index)
  holder.loadedCell:SetParent(self.content)
  holder.loadedCell:SetLocalScale(1)
  self:RearrangeCell(index)
  holder.loadedCell:SetActive(true)
  self.CellAtIndexInTableViewWillAppear(index)
end

function UITableView:RearrangeCell(index)
  local holder = self.holders[index]
  local cellRectTransform = holder.loadedCell
  local anchoredPosition
  local cellSize = Vector2(0, 0)
  local contentSizeX, contentSizeY = self.content:GetRectSize()
  local contentSize = Vector2(contentSizeX, contentSizeY)
  local otherIndex = (index - 1) % self.numberOfCellsAtRowOrColumn
  local otherScalar
  local anchorMaxX, anchorMaxY = cellRectTransform:GetAnchorMax()
  local anchorMax = Vector2(anchorMaxX, anchorMaxY)
  local pivotX, pivotY = cellRectTransform:GetPivot()
  local pivot = Vector2(pivotX, pivotY)
  local numberOfCellAtLastRowOrColumn = #self.holders % self.numberOfCellsAtRowOrColumn
  local emptyNumberAtLastRowOrColumn = 0
  local maxRowOrColumn = Mathf.Ceil(#self.holders / self.numberOfCellsAtRowOrColumn)
  if numberOfCellAtLastRowOrColumn ~= 0 and index >= maxRowOrColumn * self.numberOfCellsAtRowOrColumn and index <= #self.holders then
    if self.alignment == UIGridViewAlignmentEnum.RightOrTop then
      otherIndex = self.numberOfCellsAtRowOrColumn - numberOfCellAtLastRowOrColumn + otherIndex
    elseif self.alignment == UIGridViewAlignmentEnum.LeftOrBottom then
    else
      emptyNumberAtLastRowOrColumn = self.numberOfCellsAtRowOrColumn - numberOfCellAtLastRowOrColumn
    end
  end
  if self.direction == EScrollViewDireEnum.Vertical then
    otherScalar = contentSize.x / self.numberOfCellsAtRowOrColumn
    anchoredPosition = Vector2(-(contentSize.x - emptyNumberAtLastRowOrColumn * otherScalar) * anchorMax.x + otherIndex * otherScalar + (1 - pivot.x) * otherScalar, contentSize.y * anchorMax.y - holder.position - (1 - pivot.y) * holder.scalar)
    cellSize.x = otherScalar
    cellSize.y = holder.scalar
  else
    otherScalar = contentSize.y / self.numberOfCellsAtRowOrColumn
    anchoredPosition = Vector2(-(contentSize.x * anchorMax.x - holder.position - (1 - pivot.x) * holder.scalar), (contentSize.y - emptyNumberAtLastRowOrColumn * otherScalar) * anchorMax.y - otherIndex * otherScalar - (1 - pivot.y) * otherScalar)
    cellSize.x = holder.scalar
    cellSize.y = otherScalar
  end
  holder.loadedCell:SetAnchoredPosition(anchoredPosition.x, anchoredPosition.y)
  if holder.loadedCell.isAutoResize then
    holder.loadedCell:SetSizeDelta(cellSize.x, cellSize.y)
  end
end

function UITableView:ResizeContent(numberOfCells)
  local lastMaxLowerMargin = 0
  local cumulativeScalar = 0
  local numOfRowOrColumn = Mathf.Ceil(numberOfCells / self.numberOfCellsAtRowOrColumn)
  for i = 1, numOfRowOrColumn do
    local maxUpperMargin = 0
    local maxLowerMargin = 0
    local maxScalar = 0
    for j = 1, self.numberOfCellsAtRowOrColumn do
      local upperMargin = self:ScalarForUpperMarginInTableView(i)
      maxUpperMargin = Mathf.Max(maxUpperMargin, upperMargin)
      local lowerMargin = self:ScalarForLowerMarginInTableView(i)
      maxLowerMargin = Mathf.Max(maxLowerMargin, lowerMargin)
      local scalar = self.ScalarForCellInTableView(i)
      maxScalar = Mathf.Max(maxScalar, scalar)
    end
    for j = 1, self.numberOfCellsAtRowOrColumn do
      local index = Mathf.Min((i - 1) * self.numberOfCellsAtRowOrColumn + j, numberOfCells)
      local holder = self.holders[index]
      holder.upperMargin = maxUpperMargin
      holder.position = cumulativeScalar + lastMaxLowerMargin + maxUpperMargin
      holder.scalar = maxScalar
      holder.lowerMargin = maxLowerMargin
    end
    cumulativeScalar = cumulativeScalar + (lastMaxLowerMargin + maxUpperMargin + maxScalar)
    lastMaxLowerMargin = maxLowerMargin
  end
  cumulativeScalar = cumulativeScalar + lastMaxLowerMargin
  local sizeX, sizeY = self.content:GetSizeDelta()
  if self.direction == EScrollViewDireEnum.Horizontal then
    sizeX = cumulativeScalar
  else
    sizeY = cumulativeScalar
  end
  self.content:SetSizeDelta(sizeX, sizeY)
end

function UITableView:StartAutoScroll(index, time, withUpperMargin, onScrollingFinished)
  self:StopAutoScroll(onScrollingFinished)
  self.autoScroll = Coroutine.Start(self.AutoScroll, self, index, time, withUpperMargin, onScrollingFinished)
end

function UITableView:StopAutoScroll(onScrollingFinished)
  if not self.autoScroll then
    return
  end
  Coroutine.Stop(self.autoScroll)
  self.autoScroll = nil
  if onScrollingFinished then
    onScrollingFinished()
  end
end

function UITableView:AutoScroll(index, time, withUpperMargin, onScrollingFinished)
  local from = Vector2(self.scrollView:GetNormalizedPosition())
  local to = Vector2(self:GetNormalizedPositionOfCellAtIndex(index, withUpperMargin))
  local progress = 0
  local startAt = Time.time
  while Mathf.Approximately(progress, 1) == false do
    Coroutine.WaitForEndOfFrame()
    progress = Mathf.Min((Time.time - startAt) / time, 1)
    local x = Mathf.Lerp(from.x, to.x, progress)
    local y = Mathf.Lerp(from.y, to.y, progress)
    self.scrollView:SetNormalizedPosition(x, y)
  end
  Coroutine.Stop(self.autoScroll)
  if onScrollingFinished then
    onScrollingFinished()
  end
end

function UITableView:ReloadCells(normalizedPosition, alwaysRearrangeCell)
  local range = self:RecalculateVisibleRange(normalizedPosition)
  self:UnloadUnusedCells(range)
  self:LoadCells(range, alwaysRearrangeCell)
end

function UITableView:RecalculateVisibleRange(normalizedPosition)
  local contentSize = Vector2(self.content:GetRectSize())
  local viewportSize = self:GetCheckSize()
  local intervalPos = contentSize - viewportSize
  local startPosition
  if self.direction == EScrollViewDireEnum.Horizontal then
    startPosition = normalizedPosition * intervalPos
  else
    startPosition = (Vector2.one - normalizedPosition) * intervalPos
  end
  local endPosition = startPosition + viewportSize
  local startIndex, endIndex, tempEndIndex
  if self.direction == EScrollViewDireEnum.Horizontal then
    startIndex = self:FindStartIndexOfCellAtPosition(startPosition.x)
    endIndex = self:FindStartIndexOfCellAtPosition(endPosition.x)
  else
    startIndex = self:FindStartIndexOfCellAtPosition(startPosition.y)
    endIndex = self:FindStartIndexOfCellAtPosition(endPosition.y)
    tempEndIndex = endIndex
  end
  if self.numberOfCellsAtRowOrColumn > 1 then
    local index = Mathf.Ceil(startIndex / self.numberOfCellsAtRowOrColumn)
    startIndex = index == 1 and index or (index - 1) * self.numberOfCellsAtRowOrColumn + 1
    endIndex = Mathf.Ceil((endIndex + 1) / self.numberOfCellsAtRowOrColumn) * self.numberOfCellsAtRowOrColumn
    endIndex = Mathf.Min(endIndex, #self.holders)
  end
  return Range(startIndex, endIndex)
end

function UITableView:FindStartIndexOfCellAtPosition(position)
  return self:FindIndexOfCellAtPosition(position, 1, #self.holders + 1)
end

function UITableView:FindIndexOfCellAtPosition(position, startIndex, length)
  if Mathf.Abs(position) < 0.1 then
    position = 0
  end
  while startIndex < length do
    local midIndex = Mathf.Floor((startIndex + length) / 2)
    if position <= self.holders[midIndex].position then
      length = midIndex
    else
      startIndex = midIndex + 1
    end
  end
  return Mathf.Max(1, startIndex - 1)
end

function UITableView:GetLoadedCell(index)
  local holder = self.loadedHolders[index]
  local cell = holder and holder.loadedCell or nil
  if cell then
    cell:SetActive(true)
  end
  return cell
end

function UITableView:SetCheckRange(value)
  self.extendCheckRange = value
end

function UITableView:GetCheckSize()
  local w, h = self.viewPort:GetRectSize()
  if self.direction == EScrollViewDireEnum.Horizontal then
    w = w + self.extendCheckRange
  else
    h = h + self.extendCheckRange
  end
  return Vector2(w, h)
end

function UITableView:GetNormalizedPosition()
  local x, y = self.scrollView:GetNormalizedPosition()
  x = Mathf.Clamp(x, 0, 1)
  y = Mathf.Clamp(y, 0, 1)
  return x, y
end

function UITableView:GetNormalizedPositionOfCellAtIndex(index, withUpperMargin)
  local x, y = self.scrollView:GetNormalizedPosition()
  local contentSize = Vector2(self.content:GetRectSize())
  local viewPostSize = self:GetCheckSize()
  local deltaSize = contentSize - viewPostSize
  local position = self.holders[index].position - (withUpperMargin and self.holders[index].upperMargin or 0)
  if self.direction == EScrollViewDireEnum.Horizontal then
    x = position / deltaSize.x
  else
    y = 1 - position / deltaSize.y
  end
  x = Mathf.Clamp(x, 0, 1)
  y = Mathf.Clamp(y, 0, 1)
  return x, y
end

function UITableView:CalculateReachableStatus(normalizedPosition)
  local isReachingTopmostOrRightmost = false
  local isReachingBottommostOrLeftmost = false
  if self.Reachable == nil then
    return isReachingTopmostOrRightmost, isReachingBottommostOrLeftmost
  end
  local upperTolerance = self.Reachable.TableViewReachableEdgeTolerance()
  local curPosition, lowerTolerance
  local deltaSize = Vector2(self.content:GetRectSize()) - self:GetCheckSize()
  if self.direction == EScrollViewDireEnum.Horizontal then
    lowerTolerance = deltaSize.x - upperTolerance
    curPosition = normalizedPosition.x * deltaSize.x
  else
    lowerTolerance = deltaSize.y - upperTolerance
    curPosition = (1 - normalizedPosition.y) * deltaSize.y
  end
  isReachingTopmostOrRightmost = upperTolerance > curPosition
  isReachingBottommostOrLeftmost = lowerTolerance < curPosition
  return isReachingTopmostOrRightmost, isReachingBottommostOrLeftmost
end

function UITableView:DetectAndNotifyReachableStatus(normalizedPos)
  if self.Reachable == nil then
    return
  end
  local curIsReachingTopmostOrRightmost, curIsReachingBottommostOrLeftmost = self:CalculateReachableStatus(normalizedPos)
  if self.isReachingTopmostOrRightmost == false and curIsReachingTopmostOrRightmost then
    self.Reachable.TableViewReachedTopmostOrRightmost()
    self.isReachingTopmostOrRightmost = true
  elseif self.isReachingTopmostOrRightmost and curIsReachingTopmostOrRightmost == false then
    self.Reachable.TableViewLeftTopmostOrRightmost()
    self.isReachingTopmostOrRightmost = false
  end
  if self.isReachingBottommostOrLeftmost == false and curIsReachingBottommostOrLeftmost then
    self.Reachable.TableViewReachedBottommostOrLeftmost()
    self.isReachingBottommostOrLeftmost = true
  elseif self.isReachingBottommostOrLeftmost and curIsReachingBottommostOrLeftmost == false then
    self.Reachable.TableViewLeftBottommostOrLeftmost()
    self.isReachingBottommostOrLeftmost = false
  end
end

Range = class()

function Range:ctor(from, to)
  self.from = from
  self.to = to
end
