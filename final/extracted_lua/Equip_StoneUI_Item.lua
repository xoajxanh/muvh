local Equip_StoneUI_Item = class()

function Equip_StoneUI_Item:ctor(trans, itemCallback, select, ui, itemCallbackDrag, itemCallbackDrop, itemCallbackBeginDrag)
  self.trans = trans
  self.itemCallback = itemCallback
  self.itemCallbackDrag = itemCallbackDrag
  self.itemCallbackDrop = itemCallbackDrop
  self.select = select
  self.ui = ui
  self.itemCallbackBeginDrag = itemCallbackBeginDrag
  trans:SetOnClick(self, self.btn_ItemOnClick)
  trans:SetOnBeginDrag(self, self.OnBeginDragItem)
  trans:SetOnDrag(self, self.OnDragItem)
  trans:SetOnDrop(self, self.OnDropItem)
  trans:SetOnEndDrag(self, self.OnEndDragItem)
end

function Equip_StoneUI_Item:InitUI(stoneCellIndex, excellent, stoneData, curSelectEquip)
  self.stoneCellIndex = stoneCellIndex
  self.excellentCount = excellent and #excellent or 0
  self.stoneData = stoneData
  self.curSelectEquip = curSelectEquip
  self.close = UIControl(self.trans.transform, "img_close")
  self.redPoint = UIControl(self.trans.transform, "img_redPoint")
  self.txt_name = UIControl(self.trans.transform, "lab_StoneName")
  self:SetItemInfo()
end

function Equip_StoneUI_Item:SetItemInfo()
  if self.stoneData then
    self.ui:SetSprite("Atlas_Icon", self.stoneData.tblItem.icon, self.trans)
  else
    self.ui:SetSprite("Atlas_Bag", "item_frame", self.trans)
  end
  self:SetStoneName()
  self:SetCloseImageOpen()
end

function Equip_StoneUI_Item:SetStoneName()
  local txtname
  if self.stoneData then
    txtname = string.format("Kh\225\186\163m \196\144\195\161 %d:%s", self.stoneCellIndex % 100, self.stoneData.tblItem.name)
  else
    txtname = string.format("Kh\225\186\163m \196\144\195\161 %d", self.stoneCellIndex % 100)
  end
  self.txt_name:SetText(txtname)
end

function Equip_StoneUI_Item:SetCloseImageOpen()
  local cellInfo = ClientTable.cfg_EquipCell_cellManager:TryGetValue(self.stoneCellIndex, "index")
  local useCondition = cellInfo.useCondition
  local split1 = string.split(useCondition, "&")
  if table.count(split1) <= 1 then
    return
  end
  local split2 = string.split(split1[2], "#")
  if split2[1] == "1201" then
    local tabCount = tonumber(split2[3])
    local isOpen = tabCount <= self.excellentCount
    self.close:SetActive(not isOpen)
    self.stoneCellIsOpen = isOpen
    self.tabZhuoyueCount = tabCount
  end
  if not self.curSelectEquip then
    self.close:SetActive(true)
    self.stoneCellIsOpen = false
  end
end

function Equip_StoneUI_Item:Select(isSelect)
  self.select.transform:SetParent(self.trans.transform, false)
end

function Equip_StoneUI_Item:SetRedPoint(isShowRed)
  self.redPoint:SetActive(isShowRed)
end

function Equip_StoneUI_Item:btn_ItemOnClick(control)
  if self.itemCallback then
    self:Select(true)
    self.itemCallback(self.stoneCellIndex, self.stoneCellIsOpen)
  end
end

function Equip_StoneUI_Item:OnBeginDragItem(control, eventData)
  if not self.stoneData then
    return
  end
  self.OnDragStoneItem = self.stoneData
  if self.itemCallbackBeginDrag then
    self.itemCallbackBeginDrag(self.stoneData, eventData)
  end
end

function Equip_StoneUI_Item:OnDragItem(control, eventData)
  if not self.stoneData then
    return
  end
  self.OnDragStoneItem = self.stoneData
  if self.itemCallbackDrag then
    self.itemCallbackDrag(self.stoneData, eventData)
  end
end

function Equip_StoneUI_Item:OnDropItem(control, eventData)
  if self.itemCallbackDrop then
    self.itemCallbackDrop(self.stoneCellIndex, self)
  end
end

function Equip_StoneUI_Item:OnEndDragItem(control, eventData)
  self.ui.btn_ItemEmpty:SetActive(false)
end

return Equip_StoneUI_Item
