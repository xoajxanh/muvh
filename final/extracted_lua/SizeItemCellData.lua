SizeItemCellData = class(ItemCellData)

function SizeItemCellData:ctor()
  ItemCellData.Init(self)
end

function SizeItemCellData:Init()
  ItemCellData.Init(self)
  self.isShow = false
  self.parent = nil
  self.indexList = {}
  self.isDrag = false
  self.itemSize = Vector2.zero
  self.UIOrModelPos = {}
end

function ItemCellData:GetData()
  if self.parent then
    return self.parent
  else
    return self
  end
end

function SizeItemCellData:OnReset()
  ItemCellData.OnReset(self)
  self.isShow = false
  self.parent = nil
  self.indexList = {}
  self.isDrag = false
  self.UIOrModelPos = {}
end

function SizeItemCellData:Reset(item)
  ItemCellData.Reset(self, item)
end

function SizeItemCellData:ResetData()
  ItemCellData.OnReset(self)
end

function SizeItemCellData:GetBgSpriteName()
  local name = ""
  if self.dragState == ItemCellDragStateEnum.None then
    if self.lock then
      name = "bg_tips2"
    elseif self.state == ItemCellStateEnum.Use then
      name = "item_frameSelect"
    end
  elseif self.dragState == ItemCellDragStateEnum.cantDrag then
    name = "item_frameNotSelect"
  elseif self.dragState == ItemCellDragStateEnum.canDrag then
    name = "item_frameSelect"
  end
  return name
end
