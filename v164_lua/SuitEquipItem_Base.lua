local SuitEquipItem_Base = {}
SuitEquipItem_Base.serverData = nil
SuitEquipItem_Base.analysisState = nil
SuitEquipItem_Base.itemTbl = nil
SuitEquipItem_Base.equipTbl = nil
SuitEquipItem_Base.IsDirty = nil

function SuitEquipItem_Base:RefreshData(serverData)
  self.serverData = serverData
  self.IsDirty = true
  self.analysisState = false
  self:ResetData()
  if self.serverData == nil or type(self.serverData.itemId) ~= "number" or type(self.serverData.id) ~= "number" then
    return
  end
  self.analysisState = true
end

function SuitEquipItem_Base:ResetData()
  self:GetEquipData()
  self.equipCellTbl = nil
  self.equipSpecialTblList = nil
  self.IsDirty = false
end

function SuitEquipItem_Base:IsSameType(id)
  if type(id) ~= "number" or self:GetItemTbl() == nil then
    return false
  end
  local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(id)
  if itemTbl == nil then
    return false
  end
  return itemTbl.type == self:GetItemTbl().type and itemTbl.subType == self:GetItemTbl().subType
end

function SuitEquipItem_Base:IsBetterEquipClass(equipClass)
  if type(equipClass) ~= "number" or self:GetEquipTbl() == nil then
    return false
  end
  return equipClass > self:GetEquipTbl().equipClass
end

function SuitEquipItem_Base:CheckEquipCanUpIntensify()
  if self:GetEquipCellTbl() == nil then
    return false
  end
  return self:GetEquipCellTbl().intensifyLimit > 0 and gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():EquipPositionCanIntensify(self:GetEquipIndex())
end

function SuitEquipItem_Base:GetItemTbl()
  if self.serverData == nil or type(self.serverData.itemId) ~= "number" then
    return
  end
  if self.itemTbl == nil or self.itemTbl.id ~= self.serverData.itemId then
    self.itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(self.serverData.itemId)
  end
  return self.itemTbl
end

function SuitEquipItem_Base:GetEquipTbl()
  if self.serverData == nil or type(self.serverData.itemId) ~= "number" then
    return
  end
  if self.equipTbl == nil or self.equipTbl.id ~= self.serverData.itemId then
    self.equipTbl = ClientTable.cfg_Item_equipManager:TryGetValue(self.serverData.itemId)
  end
  return self.equipTbl
end

function SuitEquipItem_Base:GetEquipCellTbl()
  if self.equipCellTbl == nil then
    self.equipCellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(self:GetEquipIndex())
  end
  return self.equipCellTbl
end

function SuitEquipItem_Base:GetEquipIndex()
  if self.serverData == nil then
    return
  end
  return self.serverData.bagGridIndex
end

function SuitEquipItem_Base:GetEquipSpecialTblList()
  if self.serverData == nil or type(self.serverData.specialEffectIds) ~= "table" then
    return
  end
  if self.equipSpecialTblList == nil then
    self.equipSpecialTblList = {}
    local equipSpecialTbl
    for k, v in pairs(self.serverData.specialEffectIds) do
      equipSpecialTbl = ClientTable.cfg_Item_equip_specialManager:TryGetValue(v)
      if equipSpecialTbl ~= nil then
        table.insert(self.equipSpecialTblList, equipSpecialTbl)
      end
    end
  end
  return self.equipSpecialTblList
end

function SuitEquipItem_Base:GetEquipData()
  if self.equipData ~= nil and self.IsDirty == true then
    self.equipData:RefreshData(self.serverData)
  end
  if self.equipData == nil and self.serverData ~= nil then
    self.equipData = EquipData(self.serverData)
  end
  return self.equipData
end

function SuitEquipItem_Base:GetIntensify()
  if self:GetEquipData() ~= nil then
    return self:GetEquipData().intensify
  end
end

function SuitEquipItem_Base:GetIntensifyChooseOrder()
  if self:GetEquipCellTbl() == nil then
    return 0
  end
  return self:GetEquipCellTbl().intensifyIndex
end

return SuitEquipItem_Base
