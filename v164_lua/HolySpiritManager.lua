require("GameModel/Mu2_HolySpirit/HolySpiritPointData")
require("GameModel/Mu2_HolySpirit/HolySpiritAttributeData")
local HolySpiritManager = {}
local this = HolySpiritManager
this.CurHolySpiritType = 1
this.CurHolySpiritPointId = 1
this.CurShowHolySpiritPointId = 1
this.CurHolySpiritSuitType = 1
this.CurHolySpiritSubType = 1

function HolySpiritManager:GetCurHolySpiritType()
  if self.CurHolySpiritType == nil then
    self.CurHolySpiritType = 1
  end
  return self.CurHolySpiritType
end

function HolySpiritManager:GetCurHolySpiritPointId()
  if self.CurHolySpiritPointId == nil then
    self.CurHolySpiritPointId = 1
  end
  return self.CurHolySpiritPointId
end

function HolySpiritManager:GetCurShowHolySpiritPointId()
  if self.CurShowHolySpiritPointId == nil then
    self.CurShowHolySpiritPointId = 1
  end
  return self.CurShowHolySpiritPointId
end

function HolySpiritManager:GetCurHolySpiritSuitType()
  if self.CurHolySpiritSuitType == nil then
    self.CurHolySpiritSuitType = 1
  end
  return self.CurHolySpiritSuitType
end

function HolySpiritManager:GetCurHolySpiritSubType()
  if self.CurHolySpiritSubType == nil then
    self.CurHolySpiritSubType = 1
  end
  return self.CurHolySpiritSubType
end

function HolySpiritManager:Init()
  HolySpiritPointData.Init()
  HolySpiritAttributeData.Init()
end

function HolySpiritManager:ResHolySpiritData(tblData)
  self:UpdateHolySpiritGeneralData(tblData)
  HolySpiritPointData.UpdateHolySpiritPointData(tblData.typeHolySpirits)
  HolySpiritAttributeData.UpdateHolySpiritAttributeData(tblData.typeHolySpirits)
  HolySpiritAttributeData.SetOneTypeAllAttribute()
  EventManager.Dispatch(Event.RefreshHolySpiritPage, {
    CurHolySpiritType = self.CurHolySpiritType,
    CurHolySpiritPointId = self.CurHolySpiritPointId
  })
end

function HolySpiritManager:UpdateHolySpiritGeneralData(tblData)
  self.CurHolySpiritType = ClientTable.cfg_Holyspirit_panelManager:GetTypeById(tblData.recommmendId)
  self.CurHolySpiritPointId = tblData.recommmendId
  self.CurShowHolySpiritPointId = tblData.recommmendId
  self.CurHolySpiritSubType = ClientTable.cfg_Holyspirit_panelManager:GetSubTypeById(tblData.recommmendId)
end

function HolySpiritManager:SetOffsetCurShowHolySpiritType(number)
  if number then
    local type = self.CurHolySpiritType + number
    self:SetCurShowHolySpiritType(type)
  end
end

function HolySpiritManager:SetCurShowHolySpiritType(type)
  local totalPage = HolySpiritPointData.GetHolySpiritTotalPage()
  type = type < 1 and 1 or type > totalPage and totalPage or type
  networkRequest.ReqPageChange(type)
end

function HolySpiritManager:SetCurShowHolySpiritPoint(id)
  if id then
    self.CurShowHolySpiritPointId = id
    EventManager.Dispatch(Event.RefreshHolySpiritPage, {
      CurHolySpiritType = self.CurHolySpiritType,
      CurHolySpiritPointId = self.CurShowHolySpiritPointId
    })
  end
end

function HolySpiritManager:CurShowHolySpiritEquitUnlock(suitType)
  local unLockLevelStr = HolySpiritPointData.unLockPointArray[suitType][self.CurHolySpiritType]
  local unLockLevel = tonumber(unLockLevelStr or 0)
  return unLockLevel <= HolySpiritPointData.GetNowTypeActivePointCount(self.CurHolySpiritType)
end

function HolySpiritManager:GetCurShowHolySpiritEquip()
  local equipTab = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSingleSuit(EquipCellType.SHENGHUN)
  local suitEquip = {}
  if equipTab ~= nil and equipTab.EquipList ~= nil then
    for i, v in pairs(equipTab.EquipList) do
      if v.equipData.tblEquip.subType == HolySpiritPointData.equipTab[self.CurHolySpiritType][1] then
        suitEquip[1] = v
      end
      if v.equipData.tblEquip.subType == HolySpiritPointData.equipTab[self.CurHolySpiritType][2] then
        suitEquip[2] = v
      end
    end
  end
  return suitEquip
end

function HolySpiritManager:CheckExpendCanUpgrade()
  local allTypeActive = HolySpiritPointData.CheckAllTypeIsActive()
  if allTypeActive then
    return false
  end
  if self.CurShowHolySpiritPointId ~= nil and self.CurShowHolySpiritPointId ~= 0 then
    local expendTab = HolySpiritPointData.GetPointExpendById(self.CurShowHolySpiritPointId)
    for index, itemExpend in pairs(expendTab) do
      local bagCount = BagInfoData.GetItemTotalCountByItemId(itemExpend.itemId)
      if bagCount < itemExpend.count then
        return false
      end
    end
    return true
  end
  return false
end

function HolySpiritManager:CheckEquipUp(suitType)
  local itemDate = BagInfoData.GetTotalBag()
  for i, v in pairs(itemDate) do
    if v.tblEquip and v.tblEquip.subType == HolySpiritPointData.equipTab[self.CurHolySpiritType][suitType] then
      local state = RoleEquipUtility.CanUpFight(v)
      if state == EquipUpState.CanWearUpFight then
        return true
      end
    end
  end
  return false
end

function HolySpiritManager:GetResetExpendItemIdAndCount()
  local expendGlobal = ClientTable.cfg_Global_globalManager:TryGetValue(4100004).effect
  if not string.isNullOrEmpty(expendGlobal) then
    local expendGlobalTab = string.split(expendGlobal, "#")
    local expendItemId = expendGlobalTab[1]
    local expendCount = expendGlobalTab[2]
    return tonumber(expendItemId), tonumber(expendCount)
  end
  return nil
end

function HolySpiritManager:SetCurHolySpiritSuitType(suitType, isRefreshBag)
  self.CurHolySpiritSuitType = suitType
  if isRefreshBag then
    EventManager.Dispatch(Event.Bag_RefreshShowHolySpirit)
  end
end

function HolySpiritManager:ResetHolySpiritData()
  HolySpiritPointData.InitHolySpiritPointData()
  HolySpiritAttributeData.InitHolySpiritData()
  HolySpiritAttributeData.SetOneTypeAllAttribute()
end

return HolySpiritManager
