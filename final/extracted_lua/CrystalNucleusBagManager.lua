CrystalNucleusBagManager = {}
CrystalNucleusBagManager.m_CrystalNucleusBagData = nil

function CrystalNucleusBagManager:OnResBagInfo(_msg)
  if _msg == nil then
    return
  end
  self.m_CrystalNucleusBagData = {}
  for i, item in pairs(_msg.items) do
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(item.itemId)
    if itemConfig and itemConfig.type == CrystalNucleusPedestalData.CrystalNucleusType then
      local itemBagData = self:GetBagDataByOnlyId(item.id)
      if itemBagData == nil then
        local crystalNucleusBagItemData = CrystalNucleusBagItemData()
        crystalNucleusBagItemData:RefreshData(item)
        table.insert(self.m_CrystalNucleusBagData, crystalNucleusBagItemData)
      end
    end
  end
end

function CrystalNucleusBagManager:OnResBagChange(_msg)
  if _msg == nil or _msg.storageType ~= StorageTypeEnum.CrystalNucleus then
    return
  end
  local removeTab = self:RemoveBagItemData(_msg.removeItem)
  local addTab = self:UpdateBagItemData(_msg.items)
  local bagChangeData = {removeItems = removeTab, addItems = addTab}
  EventManager.Dispatch(Event.CrystalNucleusBagChange, bagChangeData)
end

function CrystalNucleusBagManager:OnResBagItemChange(_itemInfo)
  if _itemInfo == nil then
    return
  end
  local itemBagData = self:GetBagDataByOnlyId(_itemInfo.id)
  if itemBagData == nil then
    return
  end
  itemBagData:RefreshData(_itemInfo)
  EventManager.Dispatch(Event.CrystalNucleusItemInfoChange, itemBagData)
end

function CrystalNucleusBagManager:RemoveBagItemData(_removeItems)
  if _removeItems == nil or table.count(_removeItems) == 0 then
    return
  end
  local removeTab = {}
  for _, id in pairs(_removeItems) do
    local index = self:GetBagDataIndexById(id)
    if index and self.m_CrystalNucleusBagData and self.m_CrystalNucleusBagData[index] then
      table.insert(removeTab, table.remove(self.m_CrystalNucleusBagData, index))
    end
  end
  return removeTab
end

function CrystalNucleusBagManager:UpdateBagItemData(_changeItems)
  if _changeItems == nil or table.count(_changeItems) == 0 then
    return
  end
  local addTab = {}
  for i, changeItem in pairs(_changeItems) do
    local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(changeItem.itemId)
    if itemConfig and itemConfig.type == CrystalNucleusPedestalData.CrystalNucleusType then
      local itemBagData = self:GetBagDataByOnlyId(changeItem.id)
      if itemBagData == nil then
        local crystalNucleusBagItemData = CrystalNucleusBagItemData()
        crystalNucleusBagItemData:RefreshData(changeItem)
        table.insert(self.m_CrystalNucleusBagData, crystalNucleusBagItemData)
        table.insert(addTab, crystalNucleusBagItemData)
      end
    end
  end
  return addTab
end

function CrystalNucleusBagManager:GetBagDataByOnlyId(_id)
  if self.m_CrystalNucleusBagData ~= nil and table.count(self.m_CrystalNucleusBagData) > 0 then
    for index, v in pairs(self.m_CrystalNucleusBagData) do
      if v.m_ServerInfo.id == _id then
        return self.m_CrystalNucleusBagData[index]
      end
    end
  end
  return nil
end

function CrystalNucleusBagManager:GetBagDataIndexById(_id)
  if self.m_CrystalNucleusBagData ~= nil and table.count(self.m_CrystalNucleusBagData) > 0 then
    for index, v in pairs(self.m_CrystalNucleusBagData) do
      if v.m_ServerInfo.id == _id then
        return index
      end
    end
  end
  return nil
end

function CrystalNucleusBagManager:GetCrystalNucleusBagData()
  return self.m_CrystalNucleusBagData
end

function CrystalNucleusBagManager:GetBagItemCount(_itemInfo)
  if _itemInfo == nil then
    return
  end
  local itemBagData = self:GetBagDataByOnlyId(_itemInfo.id)
  if itemBagData == nil then
    return _itemInfo.count
  else
    local changeCount = math.abs(itemBagData.ItemCount - _itemInfo.count)
    return changeCount
  end
end
