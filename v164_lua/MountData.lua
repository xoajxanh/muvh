require("GameModel/MountItemData")
require("GameConst/MountEnum")
MountData = class()
MountData.Mounts = {}
MountData.curItemInfo = nil
MountData.DefaultMount = 0

function MountData:ctor(id, equips)
  self.Mounts = {}
  self.roleId = id
  for i = 1, #equips do
    local tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(equips[i].itemId)
    if tblItem and tblItem.type == EItemType.Equipe and tblItem.subType == EItemSubtype.Mount then
      local itemEquip = ClientTable.cfg_Item_equipManager:TryGetValue(equips[i].itemId)
      self:AddMountData(equips[i], tblItem, itemEquip)
    end
  end
end

function MountData:GetMountData(itemId)
  for i = 1, #self.Mounts do
    if self.Mounts[i].itemId == itemId then
      return self.Mounts[i]
    end
  end
  return nil
end

function MountData:GetidMountData(Id)
  for i = 1, #self.Mounts do
    if self.Mounts[i].id == Id then
      return self.Mounts[i]
    end
  end
  return nil
end

function MountData:GetMountDataByType(type)
  for i = 1, #self.Mounts do
    if self.Mounts[i].bagGridIndex == type then
      return self.Mounts[i]
    end
  end
  return nil
end

function MountData:UpdateData(itemInfo, tbl_item)
  local itemEquip = ClientTable.cfg_Item_equipManager:TryGetValue(tbl_item.id)
  local mountData = MountItemData(itemInfo, tbl_item, itemEquip)
  local isContains = false
  for i = 1, #self.Mounts do
    if self.Mounts[i].itemId == itemInfo.itemId then
      self.Mounts[i] = mountData
      isContains = true
      return mountData
    end
  end
  if not isContains and mountData then
    table.insert(self.Mounts, mountData)
    return mountData
  end
  return nil
end

function MountData:DisboardData(position)
  for i = 1, #self.Mounts do
    if self.Mounts[i].bagGridIndex == position then
      local dismount = self.Mounts[i]
      table.remove(self.Mounts, i)
      dismount.valid = false
      return dismount
    end
  end
  return nil
end

function MountData:UpdateRideStatus(mountData)
  if mountData == nil then
    return
  end
  local roleData = ViewData.GetGameObjectInViewById(self.roleId)
  if roleData.rideMount and roleData.rideMount.id == mountData.id and not mountData.valid then
    roleData:UpdateRideMount(nil)
    local role = RoleManager.GetRoleById(roleData.id)
    role:SetMount(nil)
  end
  if mountData.valid then
    roleData:UpdateRideMount(mountData)
    local role = RoleManager.GetRoleById(roleData.id)
    role:RefreshMount()
  end
end

function MountData:AddMountData(equip, item, itemEquip)
  local mountData = MountItemData(equip, item, itemEquip)
  table.insert(self.Mounts, mountData)
end

function MountData:AddItemAttribute(curItemInfo)
  local Attinfo = {}
  if curItemInfo.disable_fight ~= 0 then
    table.insert(Attinfo, {
      name = MountAttribute.fight,
      value = curItemInfo.disable_fight
    })
  end
  if curItemInfo.disable_minimumPhysBaseDmg ~= 0 then
    table.insert(Attinfo, {
      name = MountAttribute.Minattack,
      value = curItemInfo.disable_minimumPhysBaseDmg
    })
  end
  if curItemInfo.disable_maximumPhysBaseDmg ~= 0 then
    table.insert(Attinfo, {
      name = MountAttribute.Maxattack,
      value = curItemInfo.disable_maximumPhysBaseDmg
    })
  end
  if curItemInfo.disable_defenseBase ~= 0 then
    table.insert(Attinfo, {
      name = MountAttribute.Defense,
      value = curItemInfo.disable_defenseBase
    })
  end
  if curItemInfo.disable_damageBonus ~= 0 then
    local mun = math.floor(curItemInfo.disable_damageBonus / 100)
    table.insert(Attinfo, {
      name = MountAttribute.Damagebonus,
      value = mun .. "%"
    })
  end
  if curItemInfo.display_disable_damageAbsorption ~= 0 then
    local mun = math.floor(curItemInfo.display_disable_damageAbsorption / 100)
    table.insert(Attinfo, {
      name = MountAttribute.Damageabsorb,
      value = mun .. "%"
    })
  end
  if curItemInfo.moveSpeed_mul ~= 0 then
    local mun = math.floor(curItemInfo.moveSpeed_mul / 100)
    table.insert(Attinfo, {
      name = MountAttribute.MoveSpeedmul,
      value = mun .. "%"
    })
  end
  if curItemInfo.disable_resistDamageReflection and curItemInfo.disable_resistDamageReflection ~= 0 then
    local attr = math.floor(curItemInfo.disable_resistDamageReflection / 100)
    table.insert(Attinfo, {
      name = MountAttribute.ResistDamageReflection,
      value = attr .. "%"
    })
  end
  if curItemInfo.disable_monsterDropRate and curItemInfo.disable_monsterDropRate ~= 0 then
    local attr = math.floor(curItemInfo.disable_monsterDropRate / 100)
    table.insert(Attinfo, {
      name = ClientTable.cfg_Ui_word_attributeManager:GetKeyWord("monsterDropRate", "attributeUI"),
      value = attr .. "%"
    })
  end
  return Attinfo
end
