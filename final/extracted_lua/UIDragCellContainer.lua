UIDragCellContainer = class(UIBaseCellContainer)

function UIDragCellContainer:ctor(ui, OnPutIn, OnClick, CellDataTbl, needCalc, OnSetDataState)
  self.OnClick = OnClick
  self.curCellCount = CellDataTbl.curCellCount
  self.totalCellCount = CellDataTbl.totalCellCount
  self.colCount = CellDataTbl.colCount
  self.rowCount = Mathf.Floor(self.totalCellCount / self.colCount)
  self.needCalc = needCalc
  self.cantDrag = false
  self.OnSetDataState = OnSetDataState
  self.freeList = nil
  self.useList = nil
  self.topScrollCell = nil
  self.bottomScrollCell = nil
  self.autoScrollState = false
  self.autoScrollCol = nil
  self.oldDragTbl = nil
  self.oldLocalPointPos = nil
  self.cellSize = -1
  self.preScrollDir = -1
  self.unusedItems = {}
  self.items = {}
  self.itemsPool = nil
  self.UIBagTile = ui.tile_bg.gameObject:GetComponent(typeof(CS.UIBagTile))
  UIBaseCellContainer.ctor(self, ui, OnPutIn)
end

local function OnNewScrollItemRefresh(itemCellData, dragUI)
  if itemCellData.itemData then
    dragUI.UIBagTile:AddFilled(itemCellData.index, itemCellData.itemData.tblItem.xTranslate, itemCellData.itemData.tblItem.yTranslate)
  end
  if itemCellData.itemData then
    local item
    item = dragUI:GetShowItem(itemCellData.index)
    item.gameObject.name = itemCellData.index
    item:SetAnchoredPosition(itemCellData.x, itemCellData.y)
    item:SetSizeDelta(itemCellData.itemSize.x, itemCellData.itemSize.y)
    if not itemCellData.model or not itemCellData.model.modelObject then
      ItemUtility.ShowItemCell(item, itemCellData, dragUI.ui)
    end
    if dragUI.OnSetDataState then
      dragUI.OnSetDataState(dragUI.ui, itemCellData)
    end
    item.data = itemCellData
    item.uiName = dragUI.ui.name
    item:SetOnDrag(dragUI, dragUI.OnDrag)
    item:SetOnLongPress(dragUI.ui, DragItemManager.OnDragStart, DragItemManager.OnUpdateDrag, DragItemManager.OnDragEnd)
    item:SetLongPressDelay(0.5)
    if dragUI.OnClick then
      item.SetOnLongClick(item, dragUI.ui, dragUI.OnClick)
      item.SetOnLongDoubleClick(item, dragUI.ui, dragUI.OnClick)
    end
  else
    local item = dragUI.items[itemCellData.index]
    if item then
      ItemUtility.ShowItemCell(item, itemCellData, dragUI.ui)
      dragUI:RecycleShowItem(itemCellData.index)
    end
  end
end

local function FillBagTile(itemCellData, dragUI)
  if itemCellData.itemData then
    dragUI.UIBagTile:AddFilled(itemCellData.index, itemCellData.itemData.tblItem.xTranslate, itemCellData.itemData.tblItem.yTranslate)
  end
end

local function OnNewItemRefresh(itemCellData, dragUI, ignoreAddFilled)
  if itemCellData.itemData and not ignoreAddFilled then
    dragUI.UIBagTile:AddFilled(itemCellData.index, itemCellData.itemData.tblItem.xTranslate, itemCellData.itemData.tblItem.yTranslate)
  end
  if itemCellData.itemData then
    local item
    item = dragUI:GetShowItem(itemCellData.index)
    item.gameObject.name = itemCellData.index
    item:SetAnchoredPosition(itemCellData.x, itemCellData.y)
    item:SetSizeDelta(itemCellData.itemSize.x, itemCellData.itemSize.y)
    ItemUtility.ShowItemCell(item, itemCellData, dragUI.ui)
    if dragUI.OnSetDataState then
      dragUI.OnSetDataState(dragUI.ui, itemCellData)
    end
    item.data = itemCellData
    item.uiName = dragUI.ui.name
    item:SetOnDrag(dragUI, dragUI.OnDrag)
    item:SetOnLongPress(dragUI.ui, DragItemManager.OnDragStart, DragItemManager.OnUpdateDrag, DragItemManager.OnDragEnd)
    item:SetLongPressDelay(0.5)
    if dragUI.OnClick then
      item.SetOnLongClick(item, dragUI.ui, dragUI.OnClick)
      item.SetOnLongDoubleClick(item, dragUI.ui, dragUI.OnClick)
    end
  else
    local item = dragUI.items[itemCellData.index]
    if item then
      ItemUtility.ShowItemCell(item, itemCellData, dragUI.ui)
      dragUI:RecycleShowItem(itemCellData.index)
    end
  end
end

function UIDragCellContainer:RefreshCtr(index)
  local itemCellData = self.cellInfos[index]
  if itemCellData then
    OnNewItemRefresh(itemCellData, self)
  end
end

function UIDragCellContainer:InitFreeSpace()
  self.freeList = {}
  self.useList = {}
  local row = self.curCellCount / self.colCount
  local temp = ItemCellData()
  temp.x, temp.y = self.startPosX, self.startPosY
  temp.width = self.cellSize * self.colCount
  temp.height = self.cellSize * row
  table.insert(self.freeList, temp)
end

function UIDragCellContainer:DoInitObj(go)
  local item = UIControl()
  item.transform = go.transform
  item:SetActive(false)
  table.insert(self.unusedItems, item)
end

function UIDragCellContainer:InitItemObj()
  self.ui.btn_3DItem:SetActive(false)
  for _ = 1, 70 do
    InstantiateManager.Instantiate(self.ui.btn_3DItem, self.ui.tile_bg.transform, self.DoInitObj, self)
  end
end

function UIDragCellContainer:Init()
  UIBaseCellContainer.Init(self)
  self.priority = 2
  self.cellSize = 44
  self.startPosX, self.startPosY = 0, 0
  self:InitFreeSpace()
  self.cellInfos = {}
  for i = 1, self.totalCellCount do
    self.cellInfos[i] = SizeItemCellData()
    self.cellInfos[i].index = i
  end
  self.topScrollCell = ItemCellData()
  self.topScrollCell.x, self.topScrollCell.y = self.ui.go_ScrollTop:GetAnchoredPosition()
  self.topScrollCell.width, self.topScrollCell.height = self.ui.go_ScrollTop:GetSizeDelta()
  self.bottomScrollCell = ItemCellData()
  self.bottomScrollCell.x, self.bottomScrollCell.y = self.ui.go_ScrollBottom:GetAnchoredPosition()
  self.bottomScrollCell.width, self.bottomScrollCell.height = self.ui.go_ScrollBottom:GetSizeDelta()
  self.oldLocalPointPos = Vector2.zero
  self.preScrollDir = ScrollDirType.None
  self:InitItemObj()
  self.UIBagTile:Init()
  self:SetLock()
  self.ui.Scroll_BagInfos:SetOnCustomScrollRectChanged(self, self.OnScrollValueChanged)
  self.showIndex = 0
  self.dirtyIndex = 0
  self.scrollY = 1
  self.curPageShowCountRow = 21
  self.dir = ScrollDirType.Bottom
  self.dirtyDir = ScrollDirType.Bottom
  self.scrollChangedThreshold = 6 / self.rowCount
  self.key = ""
  self.scrollRatio = 8.0E-4
  self.maxPage = self.rowCount - self.curPageShowCountRow
end

function UIDragCellContainer:GetCtrInfos()
  return self.cellInfos
end

function UIDragCellContainer:GetCtrByCellData(itemCellData)
  local cellCtr = self.items[itemCellData.index]
  return cellCtr
end

function UIDragCellContainer:GetCellDataByIndex(index)
  local cellData = self.cellInfos[index]
  return cellData
end

function UIDragCellContainer:GetShowItem(k)
  local item = self.items[k]
  if item then
    return item
  end
  local item = self:CreateItem()
  if item then
    self.items[k] = item
    return item
  else
    return nil
  end
end

function UIDragCellContainer:GetItem(k)
  if self.items ~= nil then
    return self.items[k]
  end
end

function UIDragCellContainer:CreateItem()
  local item
  if #self.unusedItems > 0 then
    item = table.remove(self.unusedItems)
  else
    local go = self.ui.btn_3DItem:Instantiate()
    item = UIControl()
    item.transform = go.transform
    item:SetParent(self.ui.tile_bg.transform)
  end
  item.gameObject:SetActive(true)
  return item
end

function UIDragCellContainer:GetCellInfo(index)
  local cellInfo = self.cellInfos[index]
  if not cellInfo then
    self.cellInfos[index] = SizeItemCellData()
    self.cellInfos[index].index = index
    cellInfo = self.cellInfos[index]
  end
  return cellInfo
end

function UIDragCellContainer:RefreshBg()
  self.UIBagTile:ClearCrossed()
  local index = self:GetCurShowIndex()
  self.UIBagTile:SetStartY(index)
end

function UIDragCellContainer:GetCurShowIndex()
  local n = self.dir == ScrollDirType.Top and 6 or 2
  local index = math.floor(self.showIndex * self.rowCount) - n
  index = index < 0 and 0 or index
  index = index > self.rowCount - self.curPageShowCountRow and self.rowCount - self.curPageShowCountRow or index
  return index
end

function UIDragCellContainer:GetTopAndBottomIndex(index)
  local topIndex = index * self.colCount
  local bottomIndex = (index + self.curPageShowCountRow) * self.colCount
  return topIndex, bottomIndex
end

function UIDragCellContainer:OnRefresh()
  local x, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  if math.abs(y - self.scrollY) > 0.1 then
    self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, self.scrollY)
  else
    self.UIBagTile:Clear()
    local showItemCellData = self:GetShowItemCellData(self:GetCurShowIndex())
    for _, itemCellData in pairs(showItemCellData) do
      OnNewItemRefresh(itemCellData, self)
    end
    self:RefreshBg()
  end
end

function UIDragCellContainer:OnRefreshAsync()
  local x, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  if math.abs(y - self.scrollY) > 0.1 then
    self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, self.scrollY)
  else
    self.UIBagTile:Clear()
    local showItemCellData = self:GetShowItemCellData(self:GetCurShowIndex())
    for _, itemCellData in pairs(showItemCellData) do
      FillBagTile(itemCellData, self)
    end
    self:RefreshBg()
    for _, itemCellData in pairs(showItemCellData) do
      if itemCellData.itemData then
        if self:CheckNormalRefresh() == false then
          Coroutine.Wait(0)
        end
        OnNewItemRefresh(itemCellData, self, true)
      end
    end
  end
end

function UIDragCellContainer:RefreshShowGrrowUI()
  local showItemCellData = self:GetShowItemCellData(self:GetCurShowIndex())
  for _, itemCellData in pairs(showItemCellData) do
    local itemCtr = self:GetCtrByCellData(itemCellData)
    if itemCtr then
      ItemUtility.RefreshShowGrrow(itemCtr, itemCellData)
    end
  end
end

function UIDragCellContainer:RefreshCurDataShow()
  self.tableViewFriendChat:ReloadData()
end

function UIDragCellContainer:ResetGetOutCell(itemCellData)
  self.UIBagTile:RemoveFilled(itemCellData.index, itemCellData.itemData.tblItem.xTranslate, itemCellData.itemData.tblItem.yTranslate)
  itemCellData:Reset()
  OnNewItemRefresh(itemCellData, self)
end

function UIDragCellContainer:SetLock(count)
  self.curCellCount = count or self.curCellCount
  local LockedIndex = self.curCellCount / self.colCount
  local v2 = self.UIBagTile:SetLockedIndex(LockedIndex)
  local width, height = self.ui.Scroll_BagInfos:GetCustomScrollRectContent()
  self.scrollRatio = 1 / height
  if self.ui.img_lock and 1 < v2.y then
    local w, h = self.ui.img_lock:GetSizeDelta()
    self.ui.img_lock:SetSizeDelta(w, v2.x * 44.055)
    local x, y = self.ui.img_lock:GetAnchoredPosition()
    self.ui.img_lock:SetAnchoredPosition(x, -(v2.y - v2.x * 44.055))
    self.ui.img_lock:SetActive(v2.x ~= 0)
  end
end

function UIDragCellContainer:RecycleShowItem(k)
  local item = self.items[k]
  if not item then
    return
  end
  self.items[k] = nil
  self:RecycleItem(item)
  return item
end

function UIDragCellContainer:RecycleItem(item)
  item:SetActive(false)
  table.insert(self.unusedItems, item)
end

function UIDragCellContainer:SetDataState(OnSetDataState)
  self.OnSetDataState = OnSetDataState
end

function UIDragCellContainer:ResetCellData()
  self.useList = {}
  self.freeList = {}
  local row = self.curCellCount / self.colCount
  local temp = ItemCellData()
  temp.x, temp.y = self.startPosX, self.startPosY
  temp.width = self.cellSize * self.colCount
  temp.height = self.cellSize * row
  table.insert(self.freeList, temp)
  for _, itemCellData in pairs(self.cellInfos) do
    local item = self:GetItem(itemCellData.index)
    if item then
      itemCellData:Reset(item)
    else
      itemCellData:ResetData()
    end
  end
  self:GetBagGridCalc():SetBagGridDic(row, self.colCount)
end

function UIDragCellContainer:SetParam(OnPutIn, OnClick, needCalc, cantDrag)
  if OnPutIn then
    self.OnPutIn = OnPutIn
  end
  if OnClick then
    self.OnClick = OnClick
  end
  self.cantDrag = cantDrag
  self.needCalc = needCalc
end

function UIDragCellContainer:SetData(data, key, isAsyncRefresh)
  self.key = key
  self.isAsyncRefresh = isAsyncRefresh
  self:ResetCellData()
  for _, itemData in pairs(data) do
    self:AddData(itemData)
  end
  self.showIndex = 0
  self.dirtyIndex = 0
  self.scrollY = 1
  self.dir = ScrollDirType.Bottom
  self.dirtyDir = ScrollDirType.Bottom
  local x, _ = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, self.scrollY)
  self:CleanUpCellData()
  if isAsyncRefresh then
    if self.InitCoroutine then
      Coroutine.Stop(self.InitCoroutine)
    end
    self.InitCoroutine = Coroutine.Start(self.OnRefreshAsync, self)
  else
    self:OnRefresh()
  end
end

function UIDragCellContainer:IsCantDrag()
  return self.cantDrag
end

function UIDragCellContainer:AddData(itemData)
  local itemCellData
  if self.needCalc then
    local w, h = itemData.tblItem.xTranslate * self.cellSize, itemData.tblItem.yTranslate * self.cellSize
    local newNode = self:GetBagGridCalc():TryInsertItem(w, h)
    if newNode == nil then
      return
    end
    self.freeList, self.useList = self:GetBagGridCalc():GetFreeAndUseList()
    if newNode.height < self.cellSize then
      logWarning("Kh\195\180ng gian \196\145\195\163 \196\145\225\186\167y")
      return
    end
    itemCellData = self:AnalysisUseNode(newNode, itemData)
  else
    itemCellData = self:AnalysisItemData(itemData)
  end
  return itemCellData
end

function UIDragCellContainer:FindAndRefreshData(itemData)
  local cellItemData
  for _, itemCellData in pairs(self.cellInfos) do
    if itemCellData.itemData and itemCellData.itemData.id == itemData.id then
      itemCellData:RefreshData(itemData, nil, true)
      cellItemData = itemCellData
      break
    end
  end
  return cellItemData
end

function UIDragCellContainer:RefreshData(itemData)
  local cellItemData
  if self.needCalc then
    cellItemData = self:FindAndRefreshData(itemData)
  else
    local itemCellData = self:GetCellDataByIndex(itemData.bagGridIndex)
    if itemCellData then
      itemCellData:RefreshData(itemData)
      cellItemData = itemCellData
    end
  end
  return cellItemData
end

function UIDragCellContainer:RefreshDataTbl(itemDatas)
  for _, itemData in pairs(itemDatas) do
    if not self:RefreshData(itemData) then
      self:AddData(itemData)
    end
  end
end

function UIDragCellContainer:MoveItemInfo(itemInfo)
  for _, itemCellData in pairs(self.cellInfos) do
    if itemCellData.itemData and itemCellData.itemData.id == itemInfo.id then
      self:GetOut(itemCellData)
      break
    end
  end
  self:AddItemInfo(itemInfo)
  self:RefreshBg()
end

function UIDragCellContainer:AddItemInfo(itemInfo, needShake)
  local cellItemData
  local itemData = ItemUtility.GenerateItemDataByServerData(itemInfo)
  cellItemData = self:FindAndRefreshData(itemData)
  if cellItemData then
    if needShake then
      cellItemData.isNewGet = needShake
      cellItemData.isClicked = not needShake
    end
    cellItemData.isNeedShake = needShake
    self:DragReset(cellItemData)
  else
    local itemCellData = self:AddData(itemData)
    if itemCellData then
      if needShake then
        itemCellData.isNewGet = needShake
        itemCellData.isClicked = not needShake
      end
      OnNewItemRefresh(itemCellData, self)
    end
  end
  self:RefreshBg()
end

function UIDragCellContainer:RemoveData(itemData)
  for _, itemCellData in pairs(self.cellInfos) do
    if itemCellData.itemData and itemCellData.itemData.id == itemData.id then
      self:GetOut(itemCellData)
      self:RefreshBg()
      return
    end
  end
end

function UIDragCellContainer:GetOut(itemCellData)
  local itemData = itemCellData.itemData
  self:RecycleGetOutCellSpace(itemCellData)
  self:ResetGetOutCell(itemCellData)
  return itemData
end

function UIDragCellContainer:DoPutIn(putInData)
  if putInData.toUiName == self.ui.name and self.OnPutIn and self.oldDragTbl.index ~= self.totalCellCount then
    self.OnPutIn(self.ui, putInData.itemData, putInData.fromUiName, self.oldDragTbl.index)
  end
end

function UIDragCellContainer:DragReset(itemCellData)
  OnNewItemRefresh(itemCellData, self)
  self:RefreshBg()
end

function UIDragCellContainer:OnScrollValueChanged(_, offset)
  self.scrollY = offset.y
  local y = self.ui.go_BagContent.transform.localPosition.y / 3965
  self.dir = y - self.showIndex < 0 and ScrollDirType.Top or ScrollDirType.Bottom
  local changeDir = self.dir ~= self.dirtyDir
  self.dirtyDir = self.dir
  self.showIndex = y
  if changeDir or math.abs(self.dirtyIndex - self.showIndex) >= self.scrollChangedThreshold then
    self.dirtyIndex = self.showIndex
    if self.isAsyncRefresh then
      if self.scrollViewChangeCoroutine then
        Coroutine.Stop(self.scrollViewChangeCoroutine)
      end
      self.scrollViewChangeCoroutine = Coroutine.Start(self.OnScrollRefreshAsync, self)
    else
      self:OnScrollRefresh()
    end
  end
end

function UIDragCellContainer:OnScrollRefresh()
  local x, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  if math.abs(y - self.scrollY) > 0.1 then
    self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, self.scrollY)
  else
    self.UIBagTile:Clear()
    local showItemCellData = self:GetShowItemCellData(self:GetCurShowIndex())
    for _, itemCellData in pairs(showItemCellData) do
      OnNewItemRefresh(itemCellData, self)
    end
    self:RefreshBg()
  end
end

function UIDragCellContainer:OnScrollRefreshAsync()
  local x, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  if math.abs(y - self.scrollY) > 0.1 then
    self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, self.scrollY)
  else
    self.UIBagTile:Clear()
    local showItemCellData = self:GetShowItemCellData(self:GetCurShowIndex())
    for _, itemCellData in pairs(showItemCellData) do
      FillBagTile(itemCellData, self)
    end
    self:RefreshBg()
    for _, itemCellData in pairs(showItemCellData) do
      if self:CheckScrollViewChangeRefresh() == false then
        Coroutine.Wait(0)
      end
      OnNewItemRefresh(itemCellData, self, true)
    end
  end
end

function UIDragCellContainer:CheckScrollEdge(data, eventData)
  local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ui.go_DragCheck.transform, eventData.position, UIManager.uiCamera)
  self.autoScrollState = false
  local _, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  local scrollRatio = self.cellSize
  local dir = ScrollDirType.None
  if self.topScrollCell:Contains(localPos) and y < 0.99 then
    scrollRatio = -self.cellSize
    self.autoScrollState = true
    dir = ScrollDirType.Top
  end
  if self.bottomScrollCell:Contains(localPos) and 0.01 < y then
    self.autoScrollState = true
    dir = ScrollDirType.Bottom
  end
  if self.autoScrollState then
    if self.autoScrollCol and self.preScrollDir ~= dir then
      Timer.Stop(self.autoScrollCol)
      self.autoScrollCol = nil
    end
    if not self.autoScrollCol then
      self.preScrollDir = dir
      self.autoScrollCol = Timer.StartLoopForever(0.02, self.SetScrollShow, self, scrollRatio * 0.3, dir, data)
    end
  else
    Timer.Stop(self.autoScrollCol)
    self.autoScrollCol = nil
  end
end

function UIDragCellContainer:SetScrollShow(value, dir, data)
  local _, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  self:SetScrollValue(value)
  if dir == ScrollDirType.Top and 0.99 < y or dir == ScrollDirType.Bottom and y < 0.01 then
    return
  end
  local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ui.go_BagContent.transform, self.oldLocalPointPos, UIManager.uiCamera)
  self:SetDragShow(data, localPos)
end

function UIDragCellContainer:OnDrag(ctr, eventData)
  if DragItemManager.isDrag then
    return
  end
  self:SetScrollValue(eventData.delta.y)
end

function UIDragCellContainer:SetScrollValue(scrollValue)
  local ratio = self.scrollRatio
  local x, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  if 0 < scrollValue then
    ratio = -ratio
  end
  y = y + ratio * Mathf.Abs(scrollValue)
  self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, y)
end

function UIDragCellContainer:SetDragShow(data, localPos)
  local addX, addY = data.itemData.tblItem.xTranslate, data.itemData.tblItem.yTranslate
  local tempPosX = localPos.x
  local tempPosY = -localPos.y
  local startX, startY = 0, 0
  if addX % 2 ~= 0 then
    startX = -Mathf.Floor(addX / 2)
    addX = Mathf.Floor(addX / 2)
  else
    if 1 < addX then
      tempPosX = tempPosX + self.cellSize / 2
    end
    startX = -Mathf.Floor(addX / 2)
    addX = Mathf.Floor(addX / 2) - 1
  end
  if addY % 2 ~= 0 then
    startY = -Mathf.Floor(addY / 2)
    addY = Mathf.Floor(addY / 2)
  else
    if 1 < addY then
      tempPosY = tempPosY + self.cellSize / 2
    end
    startY = -Mathf.Floor(addY / 2)
    addY = Mathf.Floor(addY / 2) - 1
  end
  local y = Mathf.Floor(tempPosY / self.cellSize)
  local x = Mathf.Floor(tempPosX / self.cellSize)
  local firstIndex = self.totalCellCount
  local offsetX = 0
  local offsetY = 0
  for i = startX, addX do
    for j = startY, addY do
      local curX = x + i
      local curY = y + j
      if curX > self.colCount - 1 or curY > self.rowCount - 1 then
        break
      end
      if curX < 0 then
        offsetX = math.max(offsetX, math.abs(curX))
        break
      end
      if curY < 0 then
        offsetY = math.max(offsetY, math.abs(curY))
        break
      end
      local index = curY * 8 + curX
      firstIndex = math.min(index, firstIndex)
    end
  end
  self.oldDragTbl = {
    index = firstIndex,
    XCount = data.itemData.tblItem.xTranslate,
    yCount = data.itemData.tblItem.yTranslate,
    OffsetX = offsetX,
    offsetY = offsetY
  }
  self.UIBagTile:ClearCrossed()
  if self.oldDragTbl.index ~= self.totalCellCount then
    self.UIBagTile:SetCrossedIndex(self.oldDragTbl.index, self.oldDragTbl.XCount, self.oldDragTbl.yCount, self.oldDragTbl.OffsetX, self.oldDragTbl.offsetY)
  end
end

function UIDragCellContainer:OnDragShow(data, eventData)
  local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ui.go_BagContent.transform, eventData.position, UIManager.uiCamera)
  self.oldLocalPointPos = eventData.position
  self:SetDragShow(data, localPos)
end

function UIDragCellContainer:Drag_DragStart(itemCellData, eventData)
  self.UIBagTile:RemoveFilled(itemCellData.index, itemCellData.itemData.tblItem.xTranslate, itemCellData.itemData.tblItem.yTranslate)
  self:RefreshBg()
  local item = self:GetShowItem(itemCellData.index)
  ItemUtility.HideItemCellUI(item)
  self:OnDragShow(itemCellData, eventData)
end

function UIDragCellContainer:Drag_DragUpdate(itemCellData, eventData)
  self:OnDragShow(itemCellData, eventData)
  self:CheckScrollEdge(itemCellData, eventData)
end

function UIDragCellContainer:Drag_DragEnd(data, eventData)
  if self.autoScrollCol then
    Timer.Stop(self.autoScrollCol)
    self.autoScrollCol = nil
  end
  local result = false
  local inPanel = UIBaseCellContainer.Drag_DragEnd(self, data, eventData)
  if self.oldDragTbl ~= nil and self.oldDragTbl.OffsetX == 0 and self.oldDragTbl.offsetY == 0 then
    result = self.UIBagTile:IsCellCanFill(self.oldDragTbl.index, self.oldDragTbl.XCount, self.oldDragTbl.yCount)
  end
  if inPanel and not result then
    self.UIBagTile:ClearCrossed()
  end
  return inPanel and result
end

function UIDragCellContainer:Drag_Cancel()
  if self.autoScrollCol then
    Timer.Stop(self.autoScrollCol)
    self.autoScrollCol = nil
  end
  self.UIBagTile:ClearCrossed()
end

function UIDragCellContainer:CalculCtrSize(itemCellData)
  local addX, addY = itemCellData.itemData.tblItem.xTranslate, itemCellData.itemData.tblItem.yTranslate
  itemCellData.itemSize = Vector2(addX * self.cellSize, addY * self.cellSize)
end

function UIDragCellContainer:CalcAndInsertCellData(itemData, x, y)
  local info = self:GetCellInfo(itemData.bagGridIndex)
  info.x = x * self.cellSize
  info.y = -y * self.cellSize
  info:RefreshData(itemData)
  self:CalculCtrSize(info)
  return info
end

function UIDragCellContainer:AnalysisItemData(itemData)
  local index = itemData.bagGridIndex + 1
  local x, y = SpaceCalcUtility.CalcXy(index, self.colCount)
  return self:CalcAndInsertCellData(itemData, x, y)
end

function UIDragCellContainer:AnalysisUseNode(useNode, itemData)
  local y = Mathf.Floor(Mathf.Abs(useNode.y - self.startPosY) / self.cellSize)
  local x = Mathf.Floor((useNode.x - self.startPosX) / self.cellSize)
  local info = self:GetCellInfo(y * self.colCount + x)
  info:RefreshData(itemData)
  info.x = useNode.x
  info.y = useNode.y
  self:CalculCtrSize(info)
  return info
end

function UIDragCellContainer:RecycleGetOutCellSpace(itemCellData)
  if self.needCalc then
    local firstIndex = itemCellData.index
    local originalFreeNode = ItemCellData()
    local cellData = self.cellInfos[firstIndex]
    originalFreeNode:RefreshRect(cellData)
    local sizeX = itemCellData.itemData.tblItem.xTranslate
    local sizeY = itemCellData.itemData.tblItem.yTranslate
    originalFreeNode.width = self.cellSize * sizeX
    originalFreeNode.height = self.cellSize * sizeY
    for i = #self.useList, 1, -1 do
      if self.useList[i]:Equal(originalFreeNode) then
        table.remove(self.useList, i)
        break
      end
    end
    self:GetBagGridCalc():RemoveItem(originalFreeNode.itemData)
    self.freeList, self.useList = self:GetBagGridCalc():GetFreeAndUseList()
  end
end

function UIDragCellContainer:Destroy()
  self:RecycleRes()
  UIBaseCellContainer.Destroy(self)
end

function UIDragCellContainer:RecycleRes()
  if self.refreshCol then
    Timer.Stop(self.OnRefresh)
    self.refreshCol = nil
  end
  if self.InitCoroutine then
    Coroutine.Stop(self.InitCoroutine)
  end
  if self.scrollViewChangeCoroutine then
    Coroutine.Stop(self.scrollViewChangeCoroutine)
  end
  UIBaseCellContainer.RecycleRes(self)
  self.useList = {}
  self.freeList = {}
  self.showIndex = 0
  self.dirtyIndex = 0
  self.scrollY = 1
  self.dir = ScrollDirType.Bottom
  self.dirtyDir = ScrollDirType.Bottom
  for _, itemCellData in pairs(self.cellInfos) do
    itemCellData:Reset()
    OnNewItemRefresh(itemCellData, self)
  end
end

UIDragCellContainer.CleanUpCellDataDic = nil

function UIDragCellContainer:CleanUpCellData()
  self.CleanUpCellDataDic = {}
  local itemCellData
  for k = 0, self.maxPage do
    local topIndex, bottomIndex = self:GetTopAndBottomIndex(k)
    for index = topIndex, bottomIndex do
      if self.CleanUpCellDataDic[k] == nil then
        self.CleanUpCellDataDic[k] = {}
      end
      itemCellData = self.cellInfos[index]
      if itemCellData ~= nil and not itemCellData.isDrag then
        table.insert(self.CleanUpCellDataDic[k], itemCellData)
      end
    end
  end
  print(self.CleanUpCellDataDic)
end

function UIDragCellContainer:GetBelongArrow(index)
  local arrow = math.floor(index / self.colCount)
  local arrowInteger, arrowRemainder = math.floor(arrow / self.curPageShowCountRow), arrow % self.curPageShowCountRow
  local minArea = arrowInteger < 1 and 0 or (arrowInteger - 1) * self.curPageShowCountRow + arrowRemainder
  local maxArea = arrowInteger < 1 and arrowRemainder or arrowInteger > self.maxPage and self.rowCount or arrow
  return minArea, maxArea
end

function UIDragCellContainer:GetShowItemCellData(page)
  if type(self.CleanUpCellDataDic) ~= "table" or self.CleanUpCellDataDic[page] == nil then
    return {}
  end
  return self.CleanUpCellDataDic[page]
end

UIDragCellContainer.NormalRefreshGroupMaxCount = nil
UIDragCellContainer.ScrollViewChangeRefreshGroupMaxCount = nil

function UIDragCellContainer:CheckNormalRefresh()
  if self.NormalRefreshGroupMaxCount == nil then
    self.NormalRefreshGroupMaxCount = ClientTable.cfg_Global_globalManager:GetBagGroupRefreshCount()
  end
  if self.normalRefreshGroupCount == nil then
    self.normalRefreshGroupCount = 0
  end
  if self.normalRefreshGroupCount >= self.NormalRefreshGroupMaxCount then
    self.normalRefreshGroupCount = 0
    return false
  end
  self.normalRefreshGroupCount = self.normalRefreshGroupCount + 1
  return true
end

function UIDragCellContainer:CheckScrollViewChangeRefresh()
  if self.ScrollViewChangeRefreshGroupMaxCount == nil then
    self.ScrollViewChangeRefreshGroupMaxCount = ClientTable.cfg_Global_globalManager:GetBagGroupRefreshCount()
  end
  if self.scrollViewChangeRefreshGroupCount == nil then
    self.scrollViewChangeRefreshGroupCount = 0
  end
  if self.scrollViewChangeRefreshGroupCount >= self.ScrollViewChangeRefreshGroupMaxCount then
    self.scrollViewChangeRefreshGroupCount = 0
    return false
  end
  self.scrollViewChangeRefreshGroupCount = self.scrollViewChangeRefreshGroupCount + 1
  return true
end

function UIDragCellContainer:GetBagGridCalc()
  if self.BagGridCalc == nil then
    self.BagGridCalc = LuaClass.BagGridCalcManager:New()
  end
  return self.BagGridCalc
end
