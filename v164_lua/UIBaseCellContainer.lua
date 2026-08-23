UIBaseCellContainer = class(UIControl)

function UIBaseCellContainer:ctor(ui, OnPutIn)
  self.ui = ui
  self.OnPutIn = OnPutIn
  self.priority = -1
  self.enabled = false
  self.dragRangeCell = nil
  self.spriteAtlas = nil
  self:Init()
end

function UIBaseCellContainer:Init()
  self.priority = 1
  self.dragRangeCell = ItemCellData()
  self.dragRangeCell.x, self.dragRangeCell.y = self.ui.go_DragEdge:GetAnchoredPosition()
  self.dragRangeCell.width, self.dragRangeCell.height = self.ui.go_DragEdge:GetSizeDelta()
  self.spriteCol = Coroutine.Start(self.DoSetSprite, self)
  self.eventContainer = EventContainer(EventManager)
  self:RegistEvent()
end

function UIBaseCellContainer:RegistEvent()
  self.eventContainer:Regist(Event.Drag_PutIn, self.Drag_PutIn, self)
  self.eventContainer:Regist(Event.UI_Show, self.UI_Show, self, 2)
  self.eventContainer:Regist(Event.UI_Hide, self.UI_Hide, self, 2)
  self.eventContainer:Regist(Event.Drag_Cancel, self.Drag_Cancel, self)
end

function UIBaseCellContainer:UnRegistEvent()
  self.eventContainer:UnRegistAll()
end

function UIBaseCellContainer:Drag_Cancel()
end

function UIBaseCellContainer:UI_Show(_, ui)
  if ui.name == self.ui.name then
    ItemCellTblData.AddCellContainer(self, self.ui.name)
  end
end

function UIBaseCellContainer:UI_Hide(_, ui)
  if ui.name == self.ui.name then
    ItemCellTblData.RemoveCellContainer(self.ui.name)
  end
end

function UIBaseCellContainer:DoPutIn(putInData)
  if putInData.toUiName == self.ui.name and self.OnPutIn then
    self.OnPutIn(self.ui, putInData)
  end
end

function UIBaseCellContainer:Drag_PutIn(_, putInData)
  self:DoPutIn(putInData)
end

function UIBaseCellContainer:ResetCheckRange()
  self.dragRangeCell = ItemCellData()
  self.dragRangeCell.x, self.dragRangeCell.y = self.ui.go_DragEdge:GetAnchoredPosition()
  self.dragRangeCell.width, self.dragRangeCell.height = self.ui.go_DragEdge:GetSizeDelta()
end

function UIBaseCellContainer:IsDragInRange(eventData)
  local _, localPos = RectTransformUtility.ScreenPointToLocalPointInRectangle(self.ui.go_DragCheck.transform, eventData.position, UIManager.uiCamera)
  if self.dragRangeCell:Contains(localPos) then
    return true
  end
  return false
end

function UIBaseCellContainer:Drag_DragEnd(data, eventData)
  return self:IsDragInRange(eventData)
end

function UIBaseCellContainer:DragReset(data)
end

function UIBaseCellContainer:PutIn(itemData)
  if self.OnPutIn then
    self.OnPutIn(self.ui, itemData)
  end
end

function UIBaseCellContainer:SetContainerState(flag)
  self.enabled = flag
end

function UIBaseCellContainer:DoSetSprite()
  local atlasPath = string.format("Texture/%s.spriteatlas", "Atlas_Bag")
  local request = self.ui:LoadAssetAsync(atlasPath, typeof(CS.UnityEngine.U2D.SpriteAtlas))
  if request ~= nil then
    Coroutine.Yield(request)
    if request.isError then
      Coroutine.Break()
    end
    self.spriteAtlas = request.res
  end
  self.spriteCol = nil
end

function UIBaseCellContainer:RecycleRes()
end

function UIBaseCellContainer:Destroy()
  self.ui = nil
  self.OnPutIn = nil
  self.priority = -1
  self.enabled = false
  self.dragRangeCell = nil
  self.spriteAtlas = nil
  if self.spriteCol then
    Coroutine.Stop(self.spriteCol)
    self.spriteCol = nil
  end
  self:UnRegistEvent()
end
