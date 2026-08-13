ItemCellTblData = {}
ItemDragType = {
  None = enum(1),
  Discard = enum(),
  GetOut = enum(),
  PutIn = enum()
}
local this = ItemCellTblData
ItemCellTblData.curCellTbls = {}

function ItemCellTblData.Init()
end

function ItemCellTblData.AddCellContainer(cellContainer, uiName)
  this.curCellTbls[uiName] = cellContainer
  cellContainer:SetContainerState(true)
end

function ItemCellTblData.RemoveCellContainer(uiName)
  local container = this.curCellTbls[uiName]
  if container then
    this.curCellTbls[uiName] = nil
    container:SetContainerState(false)
  end
end

ItemCellTblData.Init()
