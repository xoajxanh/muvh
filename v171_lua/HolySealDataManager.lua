local HolySealDataManager = {}

function HolySealDataManager:AllSealInfoDic()
  if self.mAllSealInfoDic == nil then
    self.mAllSealInfoDic = {}
  end
  return self.mAllSealInfoDic
end

function HolySealDataManager:CurUpgradeStateCodeDic()
  if self.mCurUpgradeStateCodeDic == nil then
    self.mCurUpgradeStateCodeDic = {}
  end
  return self.mCurUpgradeStateCodeDic
end

function HolySealDataManager:CurSealIDDic()
  if self.mCurSealIdAndTypeDic == nil then
    self.mCurSealIdAndTypeDic = {}
  end
  return self.mCurSealIdAndTypeDic
end

function HolySealDataManager:AllSealLevelListAndTypeDic()
  if self.mAllSealLevelListAndTypeDic == nil then
    self.mAllSealLevelListAndTypeDic = {}
  end
  return self.mAllSealLevelListAndTypeDic
end

function HolySealDataManager:Init()
  self:InitParam()
  self:BindNetMsg()
end

function HolySealDataManager:InitParam()
  self.eventContainer = EventContainer(EventManager)
  ClientTable.cfg_Seal_SealManager:ResetBaseCarrer()
end

function HolySealDataManager:BindNetMsg()
  self.eventContainer:Regist(Event.Bag_ResBagChange, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Bag_ResBagInfo, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Role_MyLvChanged, self.LvChangedCallBack, self)
end

function HolySealDataManager:BagChangedCallBack()
  for i, v in pairs(self:CurUpgradeStateCodeDic()) do
    if v == EHolySealUpgradeCode.NotMeetConsumable or v == EHolySealUpgradeCode.MeetAll then
      self:RefreshUpgradeStateCodeByType(i)
    end
  end
end

function HolySealDataManager:LvChangedCallBack()
  for i, v in pairs(self:CurUpgradeStateCodeDic()) do
    if v == EHolySealUpgradeCode.NotMeetCondition then
      self:RefreshUpgradeStateCodeByType(i)
    end
  end
end

function HolySealDataManager:HolySealInfoMessageCallBack(data)
  if data.holySealInfo == nil then
    return
  end
  self.mCurSealIdAndTypeDic = {}
  for i, v in pairs(data.holySealInfo) do
    self:RefreshCurSealInfo(v)
  end
  self:RefreshUpgradeStateCode()
end

function HolySealDataManager:HolySealChangeMessageCallBack(data)
  self:RefreshCurSealInfo(data)
  self:RefreshUpgradeStateCode(data)
  EventManager.Dispatch(Event.HolySealIdChanged, {
    type = data.type
  })
end

function HolySealDataManager:RefreshCurSealInfo(data)
  if data == nil or data.type == nil then
    return
  end
  self:CurSealIDDic()[data.type] = data.id
end

function HolySealDataManager:RefreshUpgradeStateCode(data)
  if data ~= nil then
    self:RefreshUpgradeStateCodeByType(data.type)
  else
    for i, v in pairs(EHolySealType) do
      self:RefreshUpgradeStateCodeByType(v)
    end
  end
end

function HolySealDataManager:RefreshUpgradeStateCodeByType(_type)
  local sealInfo, curStateCode, lastStateCode = false
  if self:CurSealIDDic()[_type] ~= nil then
    sealInfo = self:TryGetSealInfoById(self:CurSealIDDic()[_type])
  else
    sealInfo = _type
  end
  if sealInfo == nil then
    return
  end
  curStateCode = self:CheckUpgrades(sealInfo)
  lastStateCode = self:CurUpgradeStateCodeDic()[_type]
  if lastStateCode == nil or lastStateCode ~= curStateCode then
    self:CurUpgradeStateCodeDic()[_type] = curStateCode
    EventManager.Dispatch(Event.HolySealStateCodeChanged, {type = _type})
    if lastStateCode == EHolySealUpgradeCode.MeetAll or curStateCode == EHolySealUpgradeCode.MeetAll then
      EventManager.Dispatch(Event.CallRefreshRedPoint, {
        id = 80 + tonumber(_type)
      })
    end
  end
end

function HolySealDataManager:GetNeedShowSealLevelListByType(_type)
  if self:AllSealLevelListAndTypeDic()[_type] == nil then
    self:AllSealLevelListAndTypeDic()[_type] = self:NewSealLevelList(_type)
  end
  return self:AllSealLevelListAndTypeDic()[_type]
end

function HolySealDataManager:GetCurSealDataByType(_type)
  local id = self:CurSealIDDic()[_type]
  return self:TryGetSealInfoById(id)
end

function HolySealDataManager:TryGetSealInfoById(id)
  if id == nil then
    return nil
  end
  if self:AllSealInfoDic()[id] == nil then
    self:AllSealInfoDic()[id] = self:NewSealInfo(id)
  end
  return self:AllSealInfoDic()[id]
end

function HolySealDataManager:GetCanUpgradeType()
  for i, v in pairs(self:CurUpgradeStateCodeDic()) do
    if v then
      return i
    end
  end
  return nil
end

function HolySealDataManager:GetCurUpgradeStateCodeByType(_type)
  return self:CurUpgradeStateCodeDic()[_type]
end

function HolySealDataManager:NewSealLevelList(_type)
  local result = {}
  local idList = ClientTable.cfg_Seal_SealManager:TryGetSealListByType(_type)
  if idList ~= nil then
    for i, v in pairs(idList) do
      table.insert(result, self:NewSealLevelUnitInfo(v))
    end
    table.sort(result, function(l, r)
      return l and r and l.level < r.level
    end)
  end
  return result
end

function HolySealDataManager:NewSealInfo(_id)
  local tbl = ClientTable.cfg_Seal_SealManager:TryGetValue(_id)
  if tbl == nil then
    return nil
  end
  local temp = {}
  temp.id = tbl.id
  temp.name = tbl.mark
  temp.type = tbl.tab
  temp.level = tbl.sealLevel
  temp.consumable = TableParse:SpliteStringToItemCountList(tbl.item)
  temp.coinItem = TableParse:SpliteStringToItemCountList(tbl.resource)
  temp.condition = tbl.condition
  return temp
end

function HolySealDataManager:NewSealLevelUnitInfo(_id)
  local tbl = ClientTable.cfg_Seal_SealManager:TryGetValue(_id)
  if tbl == nil or tbl.buffShow ~= "1" or tbl.buff == nil then
    return nil
  end
  local buffTbl = ClientTable.cfg_Buff_buffManager:TryGetValue(tbl.buff)
  if buffTbl == nil then
    return nil
  end
  local temp = {}
  temp.id = tbl.id
  temp.level = tbl.sealLevel
  temp.buffDes = buffTbl.desc
  return temp
end

function HolySealDataManager:CheckUpgrades(data)
  if data == nil then
    return EHolySealUpgradeCode.None
  end
  local nextSealInfo
  if type(data) == "number" then
    local minId = ClientTable.cfg_Seal_SealManager:TryGetMinIdByType(data)
    nextSealInfo = self:TryGetSealInfoById(minId)
  else
    local maxId = ClientTable.cfg_Seal_SealManager:TryGetMaxIdByType(data.type)
    if maxId and data.id == maxId then
      return EHolySealUpgradeCode.MeetMax
    end
    nextSealInfo = self:TryGetSealInfoById(data.id + 1)
  end
  if nextSealInfo == nil then
    return EHolySealUpgradeCode.None
  end
  if not ConditionManager.Check4D(nextSealInfo.condition) then
    return EHolySealUpgradeCode.NotMeetCondition
  end
  if nextSealInfo.coinItem ~= nil and table.count(nextSealInfo.coinItem) > 0 then
    local bagCount
    for i, v in pairs(nextSealInfo.coinItem) do
      bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
      if bagCount < v.count then
        return EHolySealUpgradeCode.NotMeetConsumable
      end
    end
  end
  if nextSealInfo.consumable ~= nil and 0 < table.count(nextSealInfo.consumable) then
    local bagCount
    for i, v in pairs(nextSealInfo.consumable) do
      bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
      if bagCount < v.count then
        return EHolySealUpgradeCode.NotMeetConsumable
      end
    end
  end
  return EHolySealUpgradeCode.MeetAll
end

function HolySealDataManager:IsShowRedPoint(id)
  if id == ERedPointId.Equip_SignetUI_sword then
    return self:GetCurUpgradeStateCodeByType(EHolySealType.HolySword) == EHolySealUpgradeCode.MeetAll
  elseif id == ERedPointId.Equip_SignetUI_shield then
    return self:GetCurUpgradeStateCodeByType(EHolySealType.HolyShield) == EHolySealUpgradeCode.MeetAll
  elseif id == ERedPointId.Equip_SignetUI_cross then
    return self:GetCurUpgradeStateCodeByType(EHolySealType.HolyCross) == EHolySealUpgradeCode.MeetAll
  end
end

function HolySealDataManager:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return HolySealDataManager
