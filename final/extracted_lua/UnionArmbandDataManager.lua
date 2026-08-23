local UnionArmbandDataManager = {}

function UnionArmbandDataManager:AllArmbandDic()
  if self.mAllArmbandDic == nil then
    self.mAllArmbandDic = {}
  end
  return self.mAllArmbandDic
end

function UnionArmbandDataManager:AllUpgradeStateDic()
  if self.mAllUpgradeStateDic == nil then
    self.mAllUpgradeStateDic = {}
  end
  return self.mAllUpgradeStateDic
end

function UnionArmbandDataManager:GetAllArmbandData()
  return self.mAllArmbandDic
end

function UnionArmbandDataManager:GetUnionLevel()
  return self.mUnionLevel
end

function UnionArmbandDataManager:GetContributItemId()
  return 1000070
end

function UnionArmbandDataManager:GetArmbandDataByType(type)
  return self:AllArmbandDic()[type]
end

function UnionArmbandDataManager:GetArmbandLogoInfo()
  return self.mArmbandLogoInfo
end

function UnionArmbandDataManager:GetArmbandStateByType(type)
  return self:AllUpgradeStateDic()[type] or false
end

function UnionArmbandDataManager:Init()
  self:InitParam()
  self:BindNetMsg()
end

function UnionArmbandDataManager:InitParam()
  self.messageContainer = EventContainer(NetManager)
  self.eventContainer = EventContainer(EventManager)
end

function UnionArmbandDataManager:BindNetMsg()
  self.eventContainer:Regist(Event.Bag_ResBagChange, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Bag_ResBagInfo, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.WarAlliance_Leave, self.WarAllianceLeaveCallBack, self)
end

function UnionArmbandDataManager:BagChangedCallBack()
  self:RefreshUpgradeState()
end

function UnionArmbandDataManager:WarAllianceLeaveCallBack()
  self.mUnionLevel = 0
  self:RefreshUpgradeState()
end

function UnionArmbandDataManager:RefreshAllData(data)
  self.mArmbandLogoInfo = data.logo
  self.mUnionLevel = data.unionLevel
  self:RefreshArmbandTbl(data.badgeInfo)
  self:RefreshUpgradeState()
  EventManager.Dispatch(Event.Mu2_WarAlliance_MyArmbandData)
end

function UnionArmbandDataManager:RefreshArmbandData(data)
  if data == nil and data.id <= data.maxId then
    return
  end
  self:RefreshDicByData(data)
  self:RefreshUpgradeState(data)
  EventManager.Dispatch(Event.Mu2_WarAlliance_MyArmbandData)
end

function UnionArmbandDataManager:RefreshArmbandTbl(tbl)
  if tbl == nil and table.count(tbl) == 0 then
    self.mAllArmbandDic = {}
  end
  local count = table.count(tbl)
  for i = 1, count do
    self:RefreshDicByData(tbl[i])
  end
end

function UnionArmbandDataManager:RefreshDicByData(data)
  local temp = self:AllArmbandDic()[data.type]
  temp = self:SetArmbandData(data.id, temp)
  if temp then
    temp.maxId = data.maxId
  end
  if self:AllArmbandDic()[data.type] == nil then
    self:AllArmbandDic()[data.type] = temp
  end
end

function UnionArmbandDataManager:RefreshUpgradeState(data)
  local isNeedRefrsh, curState, lastState = false
  if data ~= nil then
    if data.type == nil then
      return
    end
    local temp = self:AllArmbandDic()[data.type]
    curState = self:CheckUpgrades(temp)
    lastState = self:AllUpgradeStateDic()[data.type]
    if lastState == nil or lastState ~= curState then
      self:AllUpgradeStateDic()[data.type] = curState
      isNeedRefrsh = true
    end
  else
    for i, v in pairs(self:AllArmbandDic()) do
      if v and v.type then
        curState = self:CheckUpgrades(v)
        lastState = self:AllUpgradeStateDic()[v.type]
        if lastState == nil or lastState ~= curState then
          self:AllUpgradeStateDic()[v.type] = curState
          isNeedRefrsh = true
        end
      end
    end
  end
  if isNeedRefrsh then
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      type = ERedPointType.waralliance_armband
    })
  end
end

function UnionArmbandDataManager:CheckUpgrades(data)
  if self:GetUnionLevel() == nil or self:GetUnionLevel() == 0 then
    return false
  end
  if data == nil or data.id >= data.maxId then
    return false
  end
  if data.consumable == nil or table.count(data.consumable) == 0 then
    return true
  end
  local bagCount, targetCount = 0
  for i, v in pairs(data.consumable) do
    bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
    targetCount = v.count
    if bagCount < targetCount then
      data.notMeetconsum = v
      return false
    end
  end
  data.notMeetconsum = nil
  return true
end

function UnionArmbandDataManager:SetArmbandData(id, temp)
  local tbl = ClientTable.cfg_union_badgeManager:TryGetValue(id)
  if tbl == nil then
    return nil
  end
  local countData = self:GetItemDataTblById(tbl)
  if temp == nil then
    temp = {}
  end
  temp.id = id
  temp.nextId = tbl.badgeNextLevel
  temp.name = tbl.badgeLord
  temp.level = tbl.badgeLevel
  temp.startNum = tbl.badgeStar
  temp.consumable = countData
  temp.limit = tbl.limitLevel
  temp.type = tbl.tab
  return temp
end

function UnionArmbandDataManager:GetItemDataTblById(tbl)
  if tbl == nil then
    return nil
  end
  local countData = {}
  local tbl = ClientTable.cfg_union_badgeManager:TryGetValue(tbl.badgeNextLevel)
  if tbl then
    countData = TableParse:SpliteStringToItemCountList(tbl.badgeExp)
  end
  return countData, tbl and tbl.limitLevel or 0, tbl and tbl.badgeLord or ""
end

function UnionArmbandDataManager:IsShowRedPoint(id)
  if id == ERedPointId.waralliance_armband_HP then
    return self:AllUpgradeStateDic()[WarAllianceBadgeTag.HP] or false
  elseif id == ERedPointId.waralliance_armband_Atk then
    return self:AllUpgradeStateDic()[WarAllianceBadgeTag.Attack] or false
  elseif id == ERedPointId.waralliance_armband_Def then
    return self:AllUpgradeStateDic()[WarAllianceBadgeTag.Defense] or false
  end
end

function UnionArmbandDataManager:OnDestruct()
  self.messageContainer:UnRegistAll()
  self:RunBaseFunction("OnDestruct")
end

return UnionArmbandDataManager
