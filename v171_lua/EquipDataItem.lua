local EquipDataItem = {}

function EquipDataItem:GetItemTable()
  if self.ItemTable == nil or self.ItemTable.id ~= self.itemId then
    self.ItemTable = ClientTable.cfg_Item_itemManager:TryGetValue(self.itemId)
  end
  return self.ItemTable
end

function EquipDataItem:GetItemEquipTable()
  if self.ItemEquipTable == nil or self.ItemEquipTable.id ~= self.itemId then
    self.ItemEquipTable = ClientTable.cfg_Item_equipManager:TryGetValue(self.itemId)
  end
  return self.ItemEquipTable
end

function EquipDataItem:GetEquipIndexTable()
  if self:GetItemEquipTable() ~= nil then
    local equipPosition = self:GetItemEquipTable().equipPosition
    local table = string.split(equipPosition, "#")
    return table
  end
  return {}
end

function EquipDataItem:GetEquipType()
  local equipTypeTable = self:GetEquipIndexTable()
  if equipTypeTable ~= nil and 1 <= #equipTypeTable then
    return tonumber(equipTypeTable[1])
  end
  return 0
end

function EquipDataItem:GetEquipData()
  return self.equipData
end

function EquipDataItem:GetServerData()
  return self.s_Data
end

function EquipDataItem:GetLid()
  return self.lid
end

function EquipDataItem:GetItemId()
  return self.itemId
end

function EquipDataItem:GetItemLevel()
  if self.s_Data ~= nil then
    return self.s_Data.level
  end
  return 0
end

function EquipDataItem:RefreshData(data)
  self.s_Data = data
  if data == nil then
    return
  end
  self.lid = data.id
  self.itemId = data.itemId
  self.equipData = EquipData(data)
end

function EquipDataItem:ClearData()
  self.ItemTable = nil
  self.s_Data = nil
  self.itemId = nil
  self.self.ItemEquipTable = nil
end

return EquipDataItem
