require("GameModel/ItemData")
require("GameModel/EquipData")
require("GameModel/StoneData")
require("GameConst/EquipEnum")
RoleEquipData = class()
local this = RoleEquipData
RoleEquipData.Data = {}
RoleEquipData.StoneData = {}
RoleEquipData.RealStoneData = {}
local twoHandWeaponSubtype = {
  EItemSubtype.TwoHandedSword,
  EItemSubtype.Spear,
  EItemSubtype.TwoHandedAxe,
  EItemSubtype.TwoHandedStick
}
RoleEquipData.JewelryTotalLevel = nil
setgetters(RoleEquipData, {
  suitNum = function(self)
    local num = 0
    for k, v in pairs(self.Data) do
      if v.isSuit then
        num = num + 1
      end
    end
    return num
  end
})

function RoleEquipData:ctor(data)
  self:Init()
  self:RefreshData(data)
end

function RoleEquipData:Init()
  self.Data = {}
  self.StoneData = {}
  self.attributeMap = {}
  self.RealStoneData = {}
end

function RoleEquipData:RefreshData(data)
  self:Destroy()
  self.Data = {}
  self.StoneData = {}
  self.RealStoneData = {}
  for _, v in pairs(data) do
    if RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Equip) or RoleEquipUtility.IsVipEquipData(v.bagGridIndex) or RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.RingChange) or RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.ShouHu) or v.bagGridIndex == ERoleEquipPosition.transcript_weapon or v.bagGridIndex == ERoleEquipPosition.autoPickIndex or RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Couture) or v.bagGridIndex == ERoleEquipPosition.footPrintIndex or RoleEquipUtility.EquipTypeUtility(v.bagGridIndex, ERoleEquipCondition.Shenghun) then
      local equipData = EquipData(v)
      self.Data[v.bagGridIndex] = equipData
      self:EnableEquipStones(v.bagGridIndex, true)
    else
      local stoneData = StoneData(v)
      if stoneData then
        self.StoneData[v.bagGridIndex] = stoneData
      end
    end
  end
  for i, v in pairs(self.StoneData) do
    if self:IsRealStoneData(v) then
      self.RealStoneData[i] = v
    end
  end
end

function RoleEquipData:RefreshJewelryTotalLevel()
  if type(self.Data) ~= "table" or next(self.Data) == nil then
    self.JewelryTotalLevel = 0
  end
  for k, v in pairs(self.Data) do
    local equipPositionType = k
  end
end

function RoleEquipData:SetStoneLightData(data)
  self.stoneLight = data or {}
end

function RoleEquipData:UpdateData(equip)
  local equipe = self.Data[equip.bagGridIndex]
  if equipe == nil then
    self.Data[equip.bagGridIndex] = EquipData(equip)
    self:EnableEquipStones(equip.bagGridIndex, true)
  else
    equipe:RefreshData(equip)
  end
  for i = 1, 3 do
    local stoneIndex = equip.bagGridIndex * 100 + i
    if self.StoneData[stoneIndex] then
      self.RealStoneData[stoneIndex] = self.StoneData[stoneIndex]
    end
  end
  if equip and equip.bagGridIndex == ERoleEquipPosition.right_weapon and table.contains(twoHandWeaponSubtype, self.Data[equip.bagGridIndex].tblItem.subType) then
    for i = 1, 3 do
      local stoneIndex = ERoleEquipPosition.left_weapon * 100 + i
      if self.StoneData[stoneIndex] then
        self.RealStoneData[stoneIndex] = self.StoneData[stoneIndex]
      end
    end
  end
  return self.Data[equip.bagGridIndex]
end

function RoleEquipData:UpdateStoneData(equip)
  local stone = self.Data[equip.bagGridIndex]
  if stone == nil then
    self.Data[equip.bagGridIndex] = EquipData(equip)
  else
    stone:RefreshData(equip)
  end
  self.RealStoneData[equip.bagGridIndex] = self.Data[equip.bagGridIndex]
  return self.Data[equip.bagGridIndex]
end

function RoleEquipData:UpdateDatas(equips)
  if not equips then
    return
  end
  self:DestroyAllEquip()
  self.Data = {}
  for k, v in pairs(equips) do
    if v then
      local equipData = EquipData(v)
      self.Data[v.bagGridIndex] = equipData
      self:EnableEquipStones(v.bagGridIndex, true)
    end
  end
end

function RoleEquipData:GetEquips()
  return self.Data
end

function RoleEquipData:GetWeaponEquips()
  local normalData = {}
  for k, v in pairs(self.Data) do
    if k == ERoleEquipPosition.right_weapon or k == ERoleEquipPosition.left_weapon then
      normalData[k] = v
    end
  end
  return normalData
end

function RoleEquipData:RemoveEquip(strIndex)
  if strIndex == ERoleEquipPosition.right_weapon and table.contains(twoHandWeaponSubtype, self.Data[strIndex].tblItem.subType) then
    for i = 1, 3 do
      local stoneIndex = ERoleEquipPosition.left_weapon * 100 + i
      if self.RealStoneData[stoneIndex] then
        self.RealStoneData[stoneIndex] = nil
      end
    end
  end
  if self.Data[strIndex] then
    self.Data[strIndex]:Destroy()
  end
  self.Data[strIndex] = nil
  self:EnableEquipStones(strIndex, false)
  for i = 1, 3 do
    local stoneIndex = strIndex * 100 + i
    if self.RealStoneData[stoneIndex] then
      self.RealStoneData[stoneIndex] = nil
    end
  end
end

function RoleEquipData:RemoveStoneEquip(strIndex)
  if self.Data[strIndex] then
    self.Data[strIndex]:Destroy()
  end
  self.Data[strIndex] = nil
  self.RealStoneData[strIndex] = nil
end

function RoleEquipData:EnableEquipStones(equipPos, enabled)
  local stonePos
  for _, v in pairs(EStonePosition) do
    stonePos = RoleEquipUtility.GetStoneEquipPos(equipPos, v)
    if self.StoneData[stonePos] then
      self.StoneData[stonePos]:SetValid(enabled)
    end
  end
end

function RoleEquipData:GetEquipByIndex(index)
  local equip = self.Data[index]
  equip = equip or self.StoneData[index]
  return equip
end

function RoleEquipData:GetStoneByIndex(index)
  local Stoneequip = self.StoneData[index]
  return Stoneequip
end

function RoleEquipData:GetEquipById(id)
  for _, equip in pairs(self.Data) do
    if equip.id == id then
      return equip
    end
  end
  return nil
end

function RoleEquipData:GetSuitBySuitId(suitId)
  local suitInfoTbl = {}
  for k, v in pairs(self.Data) do
    local suitSpilt = string.split(v.tblEquip.suitId, "#")
    if v.isSuit and tonumber(suitSpilt[1]) == suitId then
      table.insert(suitInfoTbl, v)
    end
  end
  return suitInfoTbl
end

function RoleEquipData:GetAllSuitNum(suitId)
  local normalTable = {}
  for k, v in pairs(self.Data) do
    if v.isSuit then
      local suitId = v.tblEquip.suitId
      local suitSpilt = string.split(suitId, "#")
      if table.count(suitSpilt) > 0 then
        local suitId = tonumber(suitSpilt[1])
        if not normalTable[suitId] then
          normalTable[suitId] = {}
        end
        table.insert(normalTable[suitId], v)
      end
    end
  end
  return suitId and normalTable[suitId] or normalTable
end

function RoleEquipData:CheckMemberInfor(memberId)
  for k, v in pairs(self.StoneData) do
    if v.itemId == memberId then
      return math.ceil((v.time - Time.GetServerTime() - 1000) / 86400000) > 0
    end
  end
end

function RoleEquipData:CheckPrivilegeInfor(itemId)
  local v = self:GetEquipByIndex(CommercializeEquipCell.Vvip)
  if v and v.itemId == itemId then
    return true
  end
  return false
end

function RoleEquipData:IsRealStoneData(data)
  if data and (data.tblItem.type == EItemType.FireGem or data.tblItem.type == EItemType.WaterGem or data.tblItem.type == EItemType.IceGem or data.tblItem.type == EItemType.WindGem) then
    local index = Mathf.Floor(data.bagGridIndex / 100)
    if self.Data[index] then
      return true
    end
    if index == ERoleEquipPosition.left_weapon and not self.Data[index] and self.Data[ERoleEquipPosition.right_weapon] and table.contains(twoHandWeaponSubtype, self.Data[ERoleEquipPosition.right_weapon].tblItem.subType) then
      return true
    end
  end
  return false
end

function RoleEquipData:GetRingChangeData()
  local data = {}
  for k, v in pairs(self.Data) do
    if RoleEquipUtility.EquipTypeUtility(k, ERoleEquipCondition.RingChange) then
      data[k] = v
    end
  end
  return data
end

function RoleEquipData:Destroy()
  self:DestroyAllEquip()
  self:DestroyAllStone()
end

function RoleEquipData:DestroyAllEquip()
  for k, v in pairs(self.Data) do
    if v then
      v:Destroy()
    end
  end
end

function RoleEquipData:DestroyAllStone()
  for k, v in pairs(self.StoneData) do
    if v then
      v:Destroy()
    end
  end
end
