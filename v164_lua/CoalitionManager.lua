local CoalitionManager = {}
CoalitionManager.coalitionInfoList = nil
CoalitionManager.leaderCoalitionId = nil
CoalitionManager.isDirty_recommendCoalitionId = nil
CoalitionManager.recommendCoalitionId = nil
CoalitionManager.MainPlayerLookCoalitionId = nil

function CoalitionManager:RefreshAllCoalitionInfo(allCoalitionInfo)
  if allCoalitionInfo == nil then
    return
  end
  self.leaderCoalitionId = allCoalitionInfo.castellanCamp
  if type(allCoalitionInfo.allUnionKuaFuInfo) == "table" and #allCoalitionInfo.allUnionKuaFuInfo > 0 then
    for k, v in pairs(allCoalitionInfo.allUnionKuaFuInfo) do
      self:RefreshSingleCoalitionInfo(v, true)
    end
  end
  self.isDirty_recommendCoalitionId = true
  EventManager.Dispatch(Event.CoalitionDataChange)
end

function CoalitionManager:RefreshSingleCoalitionInfo(singleServerInfo, isAllChange)
  if singleServerInfo == nil or type(singleServerInfo.camp) ~= "number" then
    return
  end
  if self.coalitionInfoList == nil then
    self.coalitionInfoList = {}
  end
  local coalitionInfo = self.coalitionInfoList[singleServerInfo.camp]
  if coalitionInfo == nil then
    coalitionInfo = LuaClass.CoalitionInfo:New()
    self.coalitionInfoList[singleServerInfo.camp] = coalitionInfo
  end
  self.isDirty_recommendCoalitionId = true
  coalitionInfo:RefreshData(singleServerInfo)
  if not isAllChange then
    EventManager.Dispatch(Event.CoalitionDataChange, singleServerInfo.camp)
  end
end

function CoalitionManager:RefreshOnLineNum(serverData)
  if serverData == nil or serverData.camp == nil or serverData.onlineNum == nil then
    return
  end
  local coalitionInfo = self:GetCoalitionInfo(serverData.camp)
  if coalitionInfo == nil then
    return
  end
  coalitionInfo:RefreshOnLinePeopleNum(serverData.onlineNum)
  EventManager.Dispatch(Event.CoalitionOnLienPeopleNumChange, serverData.camp)
end

function CoalitionManager:CreateDefaultCoalition(coalitionId)
  local campTbl = ClientTable.cfg_Camp_detailManager:TryGetValue(coalitionId)
  if campTbl == nil then
    return
  end
  local defaultServerData = {}
  defaultServerData.camp = coalitionId
  defaultServerData.leaderUnionName = ""
  defaultServerData.members = {}
  defaultServerData.announcement = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("LeagueSiege_normal")
  defaultServerData.onlineNum = 0
  self:RefreshSingleCoalitionInfo(defaultServerData)
end

function CoalitionManager:GetCoalitionInfo(id)
  if self.coalitionInfoList == nil then
    self.coalitionInfoList = {}
  end
  if self.coalitionInfoList[id] == nil then
    self:CreateDefaultCoalition(id)
  end
  return self.coalitionInfoList[id]
end

function CoalitionManager:IsRecommendCoalitionId(coalitionId)
  if self.isDirty_recommendCoalitionId then
    self.isDirty_recommendCoalitionId = false
    self:CalcRecommendCoalitionId()
  end
  return self.recommendCoalitionId == coalitionId
end

function CoalitionManager:CalcRecommendCoalitionId()
  if self.coalitionInfoList == nil then
    return
  end
  local minPeopleNum = 9999999
  local minCoalitionId = -1
  for k, v in pairs(self.coalitionInfoList) do
    if minPeopleNum > v:GetPeopleNum() then
      minCoalitionId = k
      minPeopleNum = v:GetPeopleNum()
    end
  end
  self.recommendCoalitionId = minCoalitionId
end

function CoalitionManager:SetLookCoalition(coalitionId)
  self.MainPlayerLookCoalitionId = coalitionId
  self.lookIsDirty = true
end

function CoalitionManager:RemoveLookCoalition()
  self.MainPlayerLookCoalitionId = nil
  self.lookIsDirty = true
end

function CoalitionManager:CheckMainPlayerIsLookLeader()
  if self.lookIsDirty == false then
    return self.isLookCoalitionLeader or false
  end
  self.lookIsDirty = false
  local coalitionInfo = self:GetCoalitionInfo(self.MainPlayerLookCoalitionId)
  if coalitionInfo ~= nil then
    self.isLookCoalitionLeader = coalitionInfo:IsLeader(gameMgr:GetAvatarManager():GetMainPlayer():GetMe().name)
  end
  return self.isLookCoalitionLeader
end

function CoalitionManager:CoalitionCanKickPlayer(coalitionId)
  local coalitionInfo = self:GetCoalitionInfo(coalitionId)
  if coalitionInfo == nil then
    return false
  end
  local coalitionWarAllianceNum = coalitionInfo:GetWarAllianceNum()
  if coalitionWarAllianceNum <= 0 then
    return false
  end
  return coalitionWarAllianceNum >= ClientTable.cfg_Global_globalManager:GetCoalitionKickPlayerConfigNum() and self:CoalitionIsMinNumPlayer(coalitionId) == false
end

function CoalitionManager:CoalitionIsMinNumPlayer(coalitionId)
  if self.coalitionInfoList == nil then
    return false
  end
  local coalitionInfo = self:GetCoalitionInfo(coalitionId)
  if coalitionInfo == nil then
    return false
  end
  local coalitionPlayerNum = coalitionInfo:GetWarAllianceNum()
  local isMinPlayerCoalition = true
  for k, v in pairs(self.coalitionInfoList) do
    if v.id ~= coalitionInfo.id and coalitionPlayerNum > v:GetWarAllianceNum() then
      isMinPlayerCoalition = false
    end
  end
  return isMinPlayerCoalition
end

return CoalitionManager
