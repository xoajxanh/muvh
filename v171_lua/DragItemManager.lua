require("GameModel/ItemCell/ItemCellData")
require("GameModel/ItemCell/SizeItemCellData")
require("GameModel/ItemCell/ItemCellTblData")
DragItemManager = {}
DragItemManager.isDrag = false
DragItemManager.curDragUIName = ""
local this = DragItemManager

function DragItemManager.Init()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
end

function DragItemManager.RegistEvent()
  this.eventContainer:Regist(Event.UI_Hide, this.UI_Hide)
end

function DragItemManager.UI_Hide(_, ui)
  if ui.name == this.curDragUIName then
    this.isDrag = false
    this.curDragUIName = nil
    EventManager.Dispatch(Event.Drag_Cancel)
  end
end

local function CanDrag(control)
  local CanDrag = true
  local data = control.data.parent and control.data.parent or control.data
  if not data.itemData then
    CanDrag = false
  end
  local dragCellTbl = ItemCellTblData.curCellTbls[control.uiName]
  if not dragCellTbl then
    return false
  end
  if dragCellTbl:IsCantDrag() then
    CanDrag = false
  end
  return CanDrag
end

function DragItemManager.OnDragStart(ui, control, eventData)
  if not CanDrag(control) then
    return
  end
  this.isDrag = true
  local data = control.data.parent and control.data.parent or control.data
  data.isDrag = true
  EventManager.Dispatch(Event.Drag_DragStart, data, eventData)
  this.curDragUIName = control.uiName
  local dragCellTbl = ItemCellTblData.curCellTbls[control.uiName]
  dragCellTbl:Drag_DragStart(data, eventData)
end

function DragItemManager.OnUpdateDrag(ui, control, eventData)
  if not CanDrag(control) or not this.isDrag then
    return
  end
  local data = control.data.parent and control.data.parent or control.data
  EventManager.Dispatch(Event.Drag_DragUpdate, data, eventData)
  for _, dragCellTbl in pairs(ItemCellTblData.curCellTbls) do
    if dragCellTbl.Drag_DragUpdate then
      dragCellTbl:Drag_DragUpdate(data, eventData)
    end
  end
end

function DragItemManager.OnDragEnd(ui, control, eventData)
  if not CanDrag(control) or not this.isDrag then
    return
  end
  this.isDrag = false
  local data = control.data.parent and control.data.parent or control.data
  if not data.itemData then
    return
  end
  data.isDrag = false
  EventManager.Dispatch(Event.Drag_DragEnd, data, eventData)
  local dragResultTbl
  local curPriority = -1
  for _, dragCellTbl in pairs(ItemCellTblData.curCellTbls) do
    local result = dragCellTbl:Drag_DragEnd(data, eventData)
    if result and curPriority < dragCellTbl.priority then
      dragResultTbl = dragCellTbl
    end
  end
  local getOutContainer = ItemCellTblData.curCellTbls[control.uiName]
  if not dragResultTbl then
    getOutContainer:DragReset(data)
  else
    local paramTbl = {
      fromUiName = getOutContainer.ui.name,
      toUiName = dragResultTbl.ui.name,
      itemData = data.itemData,
      data = data
    }
    EventManager.Dispatch(Event.Drag_PutIn, paramTbl)
  end
  this.curDragUIName = nil
end

DragItemManager.Init()
