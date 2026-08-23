CrystalNucleusBagCellContainer = class()

function CrystalNucleusBagCellContainer:ctor(_ui)
  self.ui = _ui
  self.bagInfoList = {}
  self.items = {}
  self.unusedItems = {}
  self.canDrag = false
  self.isDrag = false
  self.onClickCallBack = nil
  self.onFilterCallBack = nil
  self.onSortCallBack = nil
  self.UIBagTile = _ui.tile_bg.gameObject:GetComponent(typeof(CS.UIBagTile))
  self.UIBagTile:Init()
  self.UIBagTile:SetLockedIndex(92)
  self:Init()
end

function CrystalNucleusBagCellContainer:Init()
  self.ui.btn_3DItem:SetActive(false)
  self:InitItemObject()
end

function CrystalNucleusBagCellContainer:InitItemObject()
  for _ = 1, 50 do
    InstantiateManager.Instantiate(self.ui.btn_3DItem, self.ui.tile_bg.transform, self.DoInitObject, self)
  end
end

function CrystalNucleusBagCellContainer:DoInitObject(_go)
  local item = UIControl()
  item.transform = _go.transform
  item:SetActive(false)
  table.insert(self.unusedItems, item)
end

function CrystalNucleusBagCellContainer:SetData(_data)
  self:ResetBagData()
  if _data == nil then
    return
  end
  local data = self:SortBagData(_data)
  for _, itemBagData in ipairs(data) do
    self:AddData(itemBagData)
  end
end

function CrystalNucleusBagCellContainer:ResetBagData()
  self.isDrag = false
  local bagList = table.clone(self.bagInfoList)
  for i, v in pairs(bagList) do
    self:RemoveRecycle(v.m_ServerInfo.id)
  end
  self.bagInfoList = {}
  self.items = {}
end

function CrystalNucleusBagCellContainer:RemoveRecycle(_id)
  if _id == nil then
    return
  end
  local info = self:GetItemBagInfoData(_id)
  if info == nil then
    return
  end
  self.bagInfoList[_id] = nil
  local item = self:GetShowItem(_id)
  if item == nil or item.template == nil then
    return
  end
  self.items[_id] = nil
  item.template:Recycle()
  table.insert(self.unusedItems, item)
end

function CrystalNucleusBagCellContainer:FilterBagData(_data)
  if self.onFilterCallBack then
    return self.onFilterCallBack(_data, self.ui)
  end
  return true
end

function CrystalNucleusBagCellContainer:SortBagData(_data)
  if self.onSortCallBack then
    self.onSortCallBack(_data, self.ui)
  end
  return _data
end

function CrystalNucleusBagCellContainer:AddData(_itemBagData)
  if _itemBagData == nil then
    return
  end
  if self:FilterBagData(_itemBagData) == false then
    return
  end
  local info = self:GetItemBagInfoData(_itemBagData.m_ServerInfo.id)
  if info then
    return
  end
  self.bagInfoList[_itemBagData.m_ServerInfo.id] = _itemBagData
  local item = self:GetShowItem(_itemBagData.m_ServerInfo.id)
  if item.template == nil then
    item.template = luaTemplateManager.GetNewTemplate(item, LuaComponentTemplates.CrystalNucleusBagItemTemplate, self.ui)
  end
  item:SetOnDrag(self, self.OnDrag)
  item:SetOnLongPress(self, self.OnDragStart, self.OnUpdateDrag, self.OnDragEnd)
  item:SetLongPressDelay(0.5)
  item:SetOnLongClick(self, self.OnClickCallBack)
  item.template:Refresh(_itemBagData, self.ui, self)
end

function CrystalNucleusBagCellContainer:RemoveData(_itemBagData)
  if _itemBagData == nil then
    return
  end
  self:RemoveRecycle(_itemBagData.m_ServerInfo.id)
end

function CrystalNucleusBagCellContainer:ChangeData(_itemBagData)
  if _itemBagData == nil then
    return
  end
  local info = self:GetItemBagInfoData(_itemBagData.m_ServerInfo.id)
  if info == nil then
    return
  end
  self.bagInfoList[_itemBagData.m_ServerInfo.id] = _itemBagData
  local item = self:GetShowItem(_itemBagData.m_ServerInfo.id)
  if item == nil or item.template == nil then
    return
  end
  item.template:Refresh(_itemBagData, self.ui, self)
end

function CrystalNucleusBagCellContainer:GetItemBagInfoData(_id)
  if _id == nil or self.bagInfoList == nil then
    return nil
  end
  return self.bagInfoList[_id]
end

function CrystalNucleusBagCellContainer:GetShowItem(_id)
  if self.items and self.items[_id] then
    return self.items[_id]
  end
  local item = self:CreateItem()
  item.rectTransform:SetAsLastSibling()
  if item then
    self.items[_id] = item
    return item
  else
    return nil
  end
end

function CrystalNucleusBagCellContainer:GetItemTemplate(_id)
  if _id == nil or self.items == nil or self.items[_id] == nil then
    return
  end
  return self.items[_id].template
end

function CrystalNucleusBagCellContainer:CreateItem()
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

function CrystalNucleusBagCellContainer:SetParam(_onClickCallBack, _onFilterCallBack, _onSortCallBack, _canDrag)
  self.onClickCallBack = _onClickCallBack
  self.onFilterCallBack = _onFilterCallBack
  self.onSortCallBack = _onSortCallBack
  self.canDrag = _canDrag
end

function CrystalNucleusBagCellContainer:OnDrag(ui, eventData)
  if self.isDrag or eventData == nil then
    return
  end
  local ratio = 2.0E-4
  local x, y = self.ui.Scroll_BagInfos:GetCustomNormalizedPosition()
  if eventData.delta.y > 0 then
    ratio = -ratio
  end
  y = y + ratio * Mathf.Abs(eventData.delta.y)
  self.ui.Scroll_BagInfos:SetCustomNormalizedPosition(x, y)
end

function CrystalNucleusBagCellContainer:OnClickCallBack(ui)
  if ui == nil or ui.template == nil or self.onClickCallBack == nil then
    return
  end
  self.onClickCallBack(ui.template, self.ui)
end

function CrystalNucleusBagCellContainer:OnDragStart(ui, eventData)
  if ui == nil or ui.template == nil or eventData == nil or not self:CanDrag() then
    return
  end
  self.isDrag = true
  local _, rectTransform = RectTransformUtility.ScreenPointToWorldPointInRectangle(self.ui.DragParent.rectTransform, eventData.position, UIManager.uiCamera)
  local pos = Vector3(rectTransform.x, rectTransform.y, rectTransform.z)
  self.ui.DragParent.rectTransform.position = pos
  ui.template:OnDragStart(eventData)
end

function CrystalNucleusBagCellContainer:OnUpdateDrag(ui, eventData)
  if not (ui ~= nil and ui.template ~= nil and eventData ~= nil and self.isDrag) or not self:CanDrag() then
    return
  end
  local _, rectTransform = RectTransformUtility.ScreenPointToWorldPointInRectangle(self.ui.DragParent.rectTransform, eventData.position, UIManager.uiCamera)
  local pos = Vector3(rectTransform.x, rectTransform.y, rectTransform.z)
  self.ui.DragParent.rectTransform.position = pos
  ui.template:OnUpdateDrag(eventData)
end

function CrystalNucleusBagCellContainer:OnDragEnd(ui, eventData)
  if not (ui ~= nil and ui.template ~= nil and eventData ~= nil and self.isDrag) or not self:CanDrag() then
    return
  end
  self.isDrag = false
  ui.template:OnDragEnd(eventData)
end

function CrystalNucleusBagCellContainer:CanDrag()
  return self.canDrag
end
