require("GameConst/ViewDirectionConst")
TableView = class()
local this = TableView
this.m_math = math
this.m_cell = nil
this.m_scrollView = nil
this.m_totalViewSize = nil
this.m_visibleViewSize = nil
this.m_cellSize = nil
this.m_cellInterval = 0
this.m_totalScrollDistance = nil
this.m_totalCellCount = nil
this.m_isSizeEnough = true
this.m_startIndex = nil
this.m_endIndex = nil
this.m_contentOffset = nil
this.m_cells = {}
this.m_reUseCellList = nil
this.m_currentDir = nil
this.m_lastScrollFactor = nil
this.m_scrollRect = nil
this.m_updateCellCallback = nil
this.m_data = nil
this.m_content = nil

function TableView:SetTotalCellCount(cellCount)
  this.m_totalCellCount = cellCount
  self:InitTotalViewSize()
end

function TableView:SetCellInterval(interval)
  this.m_cellInterval = interval
end

function TableView:SetCell(cell)
  this.m_cell = cell
end

function TableView:SetScrollView(scrollView)
  this.m_scrollView = scrollView
end

function TableView:SetUpdateCallback(callback)
  this.m_updateCellCallback = callback
end

function TableView:SetData(data)
  this.m_data = data
end

function TableView:ctor()
end

function TableView:CreateTableView()
  self:InitComponent()
  self:InitFields()
  self:InitView()
end

function TableView:ReloadTableView()
  self:DestroyAllCell()
  self:UpdateContentSize()
  self:InitCell()
  self:SetScrollViewValueChanged()
end

function TableView:DestroyAllCell()
  for i, v in pairs(this.m_cells) do
    v:Destroy()
  end
  
  local function Destroy(cell)
    cell:Destroy()
  end
  
  this.m_reUseCellList:ForEach(Destroy)
  this.m_cells = {}
  this.m_reUseCellList:Clear()
end

function TableView:InitComponent()
  this.m_scrollRect = this.m_scrollView.scrollRect
  this.m_content = this.m_scrollView:GetChild("Viewport/Content")
end

function TableView:InitFields()
  this.m_reUseCellList = List:New()
  this.m_lastScrollFactor = Vector2.one
  this.m_contentOffset = Vector2.zero
  if this.m_scrollRect.horizontal then
    this.m_currentDir = EScrollViewDireEnum.Horizontal
  end
  if this.m_scrollRect.vertical then
    this.m_currentDir = EScrollViewDireEnum.Vertical
  end
  if this.m_currentDir == EScrollViewDireEnum.Vertical then
    _, this.m_visibleViewSize = this.m_scrollView:GetSizeDelta()
    _, this.m_cellSize = this.m_cell:GetSizeDelta()
  else
    this.m_visibleViewSize, _ = this.m_scrollView:GetSizeDelta()
    this.m_cellSize, _ = this.m_cell:GetSizeDelta()
  end
end

function TableView:InitTotalViewSize()
  this.m_totalViewSize = (this.m_cellSize + this.m_cellInterval) * this.m_totalCellCount
  this.m_totalScrollDistance = this.m_totalViewSize - this.m_visibleViewSize
end

function TableView:InitView()
  if this.m_currentDir == EScrollViewDireEnum.Vertical then
    this.m_content:SetAnchorMin(0.5, 1)
    this.m_content:SetAnchorMax(0.5, 1)
    this.m_content:SetPivot(0.5, 1)
  else
    this.m_content:SetAnchorMin(0, 0.5)
    this.m_content:SetAnchorMax(0, 0.5)
    this.m_content:SetPivot(0, 0.5)
  end
  this.m_content:SetAnchoredPosition(0, 0)
end

function TableView:UpdateContentSize()
  local contentSizeX, contentSizeY = this.m_content:GetSizeDelta()
  if this.m_currentDir == EScrollViewDireEnum.Vertical then
    contentSizeY = this.m_totalViewSize
  else
    contentSizeX = this.m_totalViewSize
  end
  this.m_content:SetSizeDelta(contentSizeX, contentSizeY)
  this.m_content:SetAnchoredPosition(0, 0)
end

function TableView:InitCell()
  local count = 0
  local usefulSize = 0
  if this.m_visibleViewSize > this.m_totalViewSize then
    usefulSize = this.m_totalViewSize
    count = this.m_math.floor(usefulSize / (this.m_cellSize + this.m_cellInterval))
    this.m_isSizeEnough = false
  else
    usefulSize = this.m_visibleViewSize
    count = this.m_math.floor(usefulSize / (this.m_cellSize + this.m_cellInterval)) + 1
    local tempSize = this.m_visibleViewSize + (this.m_cellSize + this.m_cellInterval)
    local allCellSize = (this.m_cellSize + this.m_cellInterval) * count
    if tempSize > allCellSize then
      count = count + 1
    end
    this.m_isSizeEnough = true
  end
  for i = 1, count do
    self:OnCellCreateAtIndex(i)
  end
end

function TableView:OnScrollValueChanged(content, offset)
  self:OnCellScrolling(offset)
end

function TableView:OnCellScrolling(offset)
  if this.m_isSizeEnough == false then
    return
  end
  this.m_contentOffset.x = this.m_totalScrollDistance * offset.x
  this.m_contentOffset.y = this.m_totalScrollDistance * (1 - offset.y)
  self:CalCellIndex()
end

function TableView:CalCellIndex()
  local startOffset = 0
  local endOffset = 0
  if this.m_currentDir == EScrollViewDireEnum.Vertical then
    startOffset = this.m_contentOffset.y
    endOffset = this.m_contentOffset.y + this.m_visibleViewSize
  else
    startOffset = this.m_contentOffset.x
    endOffset = this.m_contentOffset.x + this.m_visibleViewSize
  end
  endOffset = endOffset > this.m_totalViewSize and this.m_totalViewSize or endOffset
  this.m_startIndex = this.m_math.floor(startOffset / (this.m_cellSize + this.m_cellInterval))
  this.m_startIndex = this.m_startIndex < 1 and 1 or this.m_startIndex + 1
  this.m_endIndex = this.m_math.floor(endOffset / (this.m_cellSize + this.m_cellInterval)) + 1
  this.m_endIndex = this.m_endIndex > this.m_totalCellCount - 1 and this.m_totalCellCount or this.m_endIndex
  self:UpdateCells()
end

function TableView:UpdateCells()
  local delList = {}
  for k, v in pairs(this.m_cells) do
    if k < this.m_startIndex or k > this.m_endIndex then
      delList[#delList + 1] = k
      this.m_reUseCellList:Add(v)
    end
  end
  for k, v in ipairs(delList) do
    this.m_cells[v] = nil
  end
  for i = this.m_startIndex, this.m_endIndex do
    if not this.m_cells[i] then
      self:OnCellCreateAtIndex(i)
    end
  end
end

function TableView:OnCellCreateAtIndex(index)
  local cell = null
  if this.m_reUseCellList:Count() > 0 then
    cell = this.m_reUseCellList:GetItemByIndex(1)
    this.m_reUseCellList:RemoveAt(1)
  else
    cell = this.m_cell:InstantiateWarp()
  end
  cell:SetParent(this.m_content)
  cell:SetLocalScale(1)
  if this.m_currentDir == EScrollViewDireEnum.Vertical then
    cell:SetAnchorMin(0.5, 1)
    cell:SetAnchorMax(0.5, 1)
    cell:SetPivot(0.5, 1)
  else
    cell:SetAnchorMin(0, 0.5)
    cell:SetAnchorMax(0, 0.5)
    cell:SetPivot(0, 0.5)
  end
  if this.m_currentDir == EScrollViewDireEnum.Vertical then
    local posY = (index - 1) * this.m_cellSize + index * this.m_cellInterval
    if 0 < posY then
      posY = -posY
    end
    cell:SetAnchoredPosition(0, posY)
  else
    local posX = (index - 1) * this.m_cellSize + index * this.m_cellInterval
    cell:SetAnchoredPosition(posX, 0)
  end
  if this.m_updateCellCallback then
    this.m_updateCellCallback(index, cell, this.m_data)
  end
  cell:SetAsLastSibling()
  this.m_cells[index] = cell
end

function TableView:SetScrollViewValueChanged()
  this.m_scrollView:SetOnScrollRectChanged(this, this.OnScrollValueChanged)
end

function TableView:RemoveScrollRectChanged()
  this.m_scrollView:RemoveAllOnScrollRectChanged(this, this.OnScrollValueChanged)
end

function TableView:RefreshData()
  this.m_startIndex = 1
  local count = 0
  local usefulSize = 0
  if this.m_visibleViewSize > this.m_totalViewSize then
    usefulSize = this.m_totalViewSize
    count = this.m_math.floor(usefulSize / (this.m_cellSize + this.m_cellInterval))
    this.m_isSizeEnough = false
  else
    usefulSize = this.m_visibleViewSize
    count = this.m_math.floor(usefulSize / (this.m_cellSize + this.m_cellInterval)) + 1
    local tempSize = this.m_visibleViewSize + (this.m_cellSize + this.m_cellInterval)
    local allCellSize = (this.m_cellSize + this.m_cellInterval) * count
    if tempSize > allCellSize then
      count = count + 1
    end
  end
  this.m_endIndex = count
  this.m_endIndex = this.m_endIndex > this.m_totalCellCount - 1 and this.m_totalCellCount or this.m_endIndex
  self:RefreshCells()
end

function TableView:RefreshCells()
  local delList = {}
  for k, v in pairs(this.m_cells) do
    delList[#delList + 1] = k
    this.m_reUseCellList:Add(v)
  end
  for k, v in ipairs(delList) do
    this.m_cells[v] = nil
  end
  for i = this.m_startIndex, this.m_endIndex do
    if not this.m_cells[i] then
      self:OnCellCreateAtIndex(i)
    end
  end
end
