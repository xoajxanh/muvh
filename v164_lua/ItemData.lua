ItemData = class()

function ItemData:ctor(itemInfo)
  self:Init()
  if itemInfo then
    self:RefreshData(itemInfo)
  end
end

function ItemData:Init()
  self.itemId = 0
  self.id = 0
  self.count = 0
  self.time = 0
  self.bagGridIndex = 0
  self.bind = 0
  self.level = 0
  self.tblItem = nil
  self.wingAttr = {}
end

function ItemData:RefreshData(itemInfo)
  self.serverInfo = itemInfo
  self.itemId = itemInfo.itemId
  self.id = itemInfo.id
  self.count = itemInfo.count
  self.time = itemInfo.time
  self.bagGridIndex = itemInfo.bagGridIndex
  self.bind = itemInfo.bind
  self.level = itemInfo.level
  self.tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemId)
  if self.tblItem.type == 6 and self.tblItem.subType == 620 then
    self.wingAttr = itemInfo.wingAttr
  end
end

function ItemData:GetAllAttributes()
  return {}
end

function ItemData:isEquiped()
  return false
end

function ItemData:GetExcellenceCount()
  return 0
end

function ItemData:Destroy()
end
