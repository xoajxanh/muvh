require("GameModel/Role/RoleData")
PlayerData = class(RoleData)
PlayerData.modelType = EModelType.Charactor
PlayerData.model = 1003

function PlayerData:Init(data)
  self.base.Init(self, data)
  self.id = data.info.roleId
  self.name = data.info.name
  self.career = data.info.career
  self.sex = data.info.sex
  self.level = data.info.level
  self.x = data.x
  self.y = data.y
  self.maxHp = data.maxHp
  self.hp = data.hp
  self.maxMp = data.maxMp
  self.mp = data.mp
  self.unionId = data.info.unionId
  self.unionName = data.info.unionName
  self.unionPosition = data.info.unionPosition
  self.unionCamp = data.info.unionCamp
  self.PKMode = data.PKmode
  self.evilLevel = data.info.redLevel
  self.moveSpeed = data.moveSpeed
  self.notoriety = data.info.notoriety
  self.notoriety = data.info.notoriety
  self.hangUpProtectionTime = data.hangUpProtectionTime
  self.crossServerHangUpTime = data.crossServerHangUpTime
  self.maxShield = data.maxShield
  self.shield = data.shield
  self.serverId = data.info.serverId
  self.hasShield = data.info.hasShield
  self.hostId = data.info.hostId
  self.teamId = data.teamId
  self:InitEquip(data.equips)
  if self.interactionState ~= data.interactionState then
    self.interactionStateChange = true
  end
  self.interactionState = data.interactionState
  self.roleType = ERoleType.Player
  self.realPlayer = true
end

function PlayerData:InitEquip(equips, stoneLight)
  if self.equipsData then
    self.equipsData:RefreshData(equips)
  else
    self.equipsData = RoleEquipData(equips)
  end
  self.equipsData:SetStoneLightData(stoneLight)
  self.mountData = MountData(self.id, equips)
  self.titleData = RoleTitleData(equips)
  self:InitRideMount(self.mountData)
end

function PlayerData:SetName(name)
  if self.name ~= name then
    self.name = name
    EventManager.Dispatch(Event.Role_RefreshName, {
      roleId = self.id,
      name = name
    })
  end
end

function PlayerData:SetCamp(unionCamp)
  if self.unionCamp ~= unionCamp then
    self.unionCamp = unionCamp
    EventManager.Dispatch(Event.Role_RefreshName, {
      roleId = self.id
    })
    CampController:UnionCamp(IndexerEnum.dis, self.unionCamp)
  end
end

function PlayerData:SetShieldState(roleData)
  self.hasShield = roleData.info.hasShield
  self.maxShield = roleData.maxShield
  self.shield = roleData.shield
  EventManager.Dispatch(Event.Role_RefreshMyShield, {
    roleId = self.id,
    boolValue = self.hasShield
  })
end

function PlayerData:InitRideMount(data)
  if data == nil then
    return
  end
  local mount
  for i = 1, #data.Mounts do
    if data.Mounts[i] ~= nil and data.Mounts[i].valid then
      mount = data.Mounts[i]
    end
  end
  self:SetRideMount(mount)
end

function PlayerData:UpdateRideMount(data)
  if data ~= nil and self.rideMount ~= nil and data.id == self.rideMount.id then
    return
  end
  self:SetRideMount(data)
  EventManager.Dispatch(Event.Mount_RideChange)
end

function PlayerData:SetRideMount(data)
  self.rideMount = data
end

function PlayerData:UpdateRideStatus(data)
  if data == nil then
    return
  end
  if self.rideMount and self.rideMount.id == data.id and not data.valid then
    self:UpdateRideMount(nil)
  end
  if data.valid then
    self:UpdateRideMount(data)
  end
end

function PlayerData:Refresh(data)
  self:UpdateUnionInfoData(data)
  self:UpdateMountData(data)
  self:SetName(data.info.name)
  self.base.Refresh(self, data)
end

function PlayerData:UpdateUnionInfoData(data)
  self.unionLogo = data.info.unionLogo
  self.unionName = data.info.unionName
  self.unionId = data.info.unionId
end

function PlayerData:UpdateMountData(data)
  local tbl_item
  for i = 1, #data.equips do
    tbl_item = ClientTable.cfg_Item_itemManager:TryGetValue(data.equips[i].itemId)
    if tbl_item ~= nil and tbl_item.type == 2 and tbl_item.subType == 22 then
      local m_Data = self.mountData:UpdateData(data.equips[i], tbl_item)
      self:UpdateRideStatus(m_Data)
    end
  end
end

function PlayerData:CheckMember(arg)
  if arg == 1 then
    return self.equipsData:CheckMemberInfor(19000010)
  else
    return self.equipsData:CheckMemberInfor(19000020)
  end
end

function PlayerData:GetAttribute(attrType)
  for i, v in pairs(BuffAttributeCalculator.CollectBuffAttribute(self.id)) do
    if i == attrType then
      return self.moveSpeed + v
    end
  end
  return self.moveSpeed
end

function PlayerData:Destroy()
  if self.equipsData then
    self.equipsData:Destroy()
  end
  local buffs = BuffData.GetBuffs(self.id)
  for k, buff_struct in pairs(buffs) do
    BuffData.RemoveBuff(buff_struct)
  end
end

setgetters(PlayerData, {
  PetData = function(self)
    return RoleEquipUtility.GetCurEquipShowData(ForgeData.appearData[self.id], self.equipsData.Data, ERoleEquipPosition.pet)
  end,
  WingData = function(self)
    return self.equipsData.Data[ERoleEquipPosition.wing]
  end
})
