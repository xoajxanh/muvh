UIFixedCellContainer = class(UIBaseCellContainer)

function UIFixedCellContainer:ctor(ui, OnPutIn, OnClick, CellCtrTbl)
  self.CellCtrTbl = CellCtrTbl
  self.OnClick = OnClick
  self.CellDataTbl = nil
  self.oldDragIndex = -1
  UIBaseCellContainer.ctor(self, ui, OnPutIn)
end

function UIFixedCellContainer:Init()
  UIBaseCellContainer.Init(self)
  self.priority = 2
  self.CellDataTbl = {}
  for index, ctr in ipairs(self.CellCtrTbl) do
    ItemUtility.InitItemCell(ctr)
    local itemCellData = ItemCellData()
    itemCellData.x, itemCellData.y = ctr:GetAnchoredPosition()
    itemCellData.width, itemCellData.height = ctr:GetSizeDelta()
    self.CellDataTbl[index] = itemCellData
  end
end

local function OnItemRefresh(ctr, index, data, dragUI)
  ItemUtility.ShowItemCell(ctr, data, dragUI.ui)
  ctr.data = data
  ctr.data.index = index
  ctr.uiName = dragUI.ui.name
  ctr:SetOnDrag(dragUI, dragUI.OnDrag)
  ctr:SetOnLongPress(dragUI.ui, DragItemManager.OnDragStart, DragItemManager.OnUpdateDrag, DragItemManager.OnDragEnd)
  ctr:SetLongPressDelay(0.5)
  if dragUI.OnClick then
    ctr.SetOnLongClick(ctr, dragUI.ui, dragUI.OnClick)
  end
end

function UIFixedCellContainer:OnDragShow(data, eventData)
  local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ui.go_DragCheck.transform, eventData.position, UIManager.uiCamera)
  local cellCtr = self.CellCtrTbl[self.oldDragIndex]
  if cellCtr then
    cellCtr.img_canDrop:SetActive(false)
    cellCtr.img_cantDrop:SetActive(false)
    self.oldDragIndex = -1
  end
  for index, cellData in ipairs(self.CellDataTbl) do
    if cellData:Contains(localPos) then
      local tempCtr = self.CellCtrTbl[index]
      self.oldDragIndex = index
      if tempCtr.data:CheckCantDrop() then
        tempCtr.img_cantDrop:SetActive(true)
      else
        tempCtr.img_canDrop:SetActive(true)
      end
    end
  end
end

function UIFixedCellContainer:Drag_DragStart(data, eventData)
  local itemCellCtr = self.CellCtrTbl[data.index]
  itemCellCtr.data.state = ItemCellStateEnum.Free
  itemCellCtr.img_use:SetActive(false)
  ItemUtility.HideItemCellUI(itemCellCtr)
  self:OnDragShow(data, eventData)
end

function UIFixedCellContainer:Drag_DragUpdate(data, eventData)
  self:OnDragShow(data, eventData)
end

function UIFixedCellContainer:Drag_DragEnd(data, eventData)
  local result = false
  local inPanel = UIBaseCellContainer.Drag_DragEnd(self, data, eventData)
  local cellCtr = self.CellCtrTbl[self.oldDragIndex]
  if cellCtr then
    if cellCtr.img_canDrop:GetActive() then
      result = true
    end
    cellCtr.img_canDrop:SetActive(false)
    cellCtr.img_cantDrop:SetActive(false)
  end
  return inPanel and result
end

function UIFixedCellContainer:Drag_Cancel()
  local cellCtr = self.CellCtrTbl[self.oldDragIndex]
  if cellCtr then
    if cellCtr.img_canDrop:GetActive() then
      result = true
    end
    cellCtr.img_canDrop:SetActive(false)
    cellCtr.img_cantDrop:SetActive(false)
  end
  self.oldDragIndex = -1
end

function UIFixedCellContainer:DragReset(cellData)
  local index = cellData.index
  local itemCellCtr = self.CellCtrTbl[index]
  itemCellCtr.data.state = ItemCellStateEnum.Use
  itemCellCtr.img_use:SetActive(true)
  OnItemRefresh(itemCellCtr, index, itemCellCtr.data, self)
end

function UIFixedCellContainer:ResetGetOutCell(index)
  local cellCtr = self.CellCtrTbl[index]
  if cellCtr and cellCtr.data then
    cellCtr.data:Reset()
    OnItemRefresh(cellCtr, index, cellCtr.data, self)
  end
end

function UIFixedCellContainer:GetOut(cellData)
  local itemData = cellData.itemData
  self:ResetGetOutCell(cellData.index)
  return itemData
end

function UIFixedCellContainer:PutIn(itemData)
  self:ResetGetOutCell(self.oldDragIndex)
  local cellCtr = self.CellCtrTbl[self.oldDragIndex]
  local cellData = self.CellDataTbl[self.oldDragIndex]
  cellData:RefreshData(itemData)
  OnItemRefresh(cellCtr, self.oldDragIndex, cellData, self)
  self.oldDragIndex = -1
  if self.OnPutIn then
    self.OnPutIn(self.ui, itemData)
  end
end

function UIFixedCellContainer:ResetCellData()
end

function UIFixedCellContainer:SetData(itemDatas)
  self:ResetCellData()
  for index, cellData in ipairs(self.CellDataTbl) do
    local itemData = itemDatas[index]
    cellData.itemData = itemData
  end
  self:Refresh()
end

function UIFixedCellContainer:Refresh()
  for index, cellCtr in pairs(self.CellCtrTbl) do
    local cellData = self.CellDataTbl[index]
    OnItemRefresh(cellCtr, index, cellData, self)
  end
end

function UIFixedCellContainer:SetParam(OnPutIn, OnClick)
  if OnPutIn then
    self.OnPutIn = OnPutIn
  end
  if OnClick then
    self.OnClick = OnClick
  end
end

function UIFixedCellContainer:GetCtrInfos()
  return self.CellCtrTbl
end

function UIFixedCellContainer:GetCtrByCellData(cellData)
  local cellCtr = self.CellDataTbl[cellData.index]
  return cellCtr
end
