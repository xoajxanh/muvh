RoleTitleData = class()

function RoleTitleData:ctor(equips)
  self.TitleInfo = {}
  for i = 1, #equips do
    local tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(equips[i].itemId)
    if tblItem.type == EItemType.Equipe and tblItem.subType == EItemSubtype.title or tblItem.subType == EItemSubtype.EffectTitle then
      local itemEquip = ClientTable.cfg_Item_equipManager:TryGetValue(equips[i].itemId)
      equips[i].tblItem = tblItem
      equips[i].tblEquip = itemEquip
      self:AddTitleData(equips[i])
    end
  end
end

function RoleTitleData:AddTitleData(equip)
  local data = {}
  data.itemId = equip.itemId
  data.id = equip.id
  data.count = equip.count
  data.time = equip.time
  data.bagGridIndex = equip.bagGridIndex
  data.bind = equip.bind
  data.level = equip.level
  data.valid = equip.valid
  data.tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(equip.itemId)
  data.tblEquip = ClientTable.cfg_Item_equipManager:TryGetValue(equip.itemId)
  table.insert(self.TitleInfo, data)
  return data
end

function RoleTitleData:UpdateTitleData(itemInfo, isValid)
  for i = 1, table.count(self.TitleInfo) do
    if self.TitleInfo[i].bagGridIndex == itemInfo.bagGridIndex then
      self.TitleInfo[i].valid = isValid
      self.TitleInfo[i].time = itemInfo.time
    end
  end
end

function RoleTitleData:RemoveTitleData(bagGridIndex)
  for i = 1, table.count(self.TitleInfo) do
    if self.TitleInfo[i] ~= nil and self.TitleInfo[i].bagGridIndex == bagGridIndex then
      table.remove(self.TitleInfo, i)
      break
    end
  end
end

function RoleTitleData:IsHaveTitleData(equip)
  for i = 1, table.count(self.TitleInfo) do
    if self.TitleInfo[i].bagGridIndex == equip.bagGridIndex then
      return true
    end
  end
  return false
end

function RoleTitleData:GetShowTitleData()
  for i = 1, table.count(self.TitleInfo) do
    if self.TitleInfo[i] ~= nil and self.TitleInfo[i].valid then
      return self.TitleInfo[i]
    end
  end
  return false
end

function RoleTitleData:GetHudResName(id)
  local name
  if id then
    local nowTable = ClientTable.cfg_Equip_TitleManager:TryGetValue(id, "itemId")
    if nowTable ~= nil then
      name = nowTable.typeName
    end
  else
    for i = 1, table.count(self.TitleInfo) do
      if self.TitleInfo[i] ~= nil and self.TitleInfo[i].valid then
        local nowTable = ClientTable.cfg_Equip_TitleManager:TryGetValue(self.TitleInfo[i].tblItem.id, "itemId")
        if nowTable ~= nil then
          name = nowTable.typeName
        end
      end
    end
  end
  return name
end
