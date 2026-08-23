local CoalitionInfo = {}
CoalitionInfo.id = nil
CoalitionInfo.serverData = nil
CoalitionInfo.analysisState = nil
CoalitionInfo.unionInfoList = nil
CoalitionInfo.onLinePeopleNum = nil
CoalitionInfo.IsDirty_MainPlayerStatus = nil
CoalitionInfo.camp_DetailTbl = nil

function CoalitionInfo:RefreshData(data)
  if self:AnalysisParams(data) == false then
    return
  end
end

function CoalitionInfo:AnalysisParams(data)
  if data == nil or data.camp == nil then
    self.analysisState = false
    return self.analysisState
  end
  self.analysisState = true
  self.serverData = data
  self.IsDirty_MainPlayerStatus = true
  self.camp_DetailTbl = ClientTable.cfg_Camp_detailManager:TryGetValue(data.camp)
  self.id = data.camp
  self:RefreshOnLinePeopleNum(data.onlineNum)
  return self.analysisState
end

function CoalitionInfo:RefreshOnLinePeopleNum(num)
  self.onLinePeopleNum = num
end

function CoalitionInfo:GetCoalitionName()
  if self.serverData ~= nil then
    return self.serverData.leaderUnionName
  end
  return ""
end

function CoalitionInfo:GetAnnouncement()
  if self.serverData ~= nil then
    return self.serverData.announcement
  end
  return ""
end

function CoalitionInfo:GetName()
  if self.camp_DetailTbl == nil then
    return ""
  end
  return self.camp_DetailTbl.name
end

function CoalitionInfo:GetIconName()
  if self.camp_DetailTbl == nil then
    return ""
  end
  return self.camp_DetailTbl.icon
end

function CoalitionInfo:GetOnLinePeopleNum()
  return self.onLinePeopleNum
end

function CoalitionInfo:GetPeopleNum()
  local mPeopleNum = 0
  if type(self.serverData.members) == "table" then
    mPeopleNum = #self.serverData.members
  end
  return mPeopleNum
end

function CoalitionInfo:GetPeopleNumDes()
  if self.peopleNumDesFormat == nil then
    self.peopleNumDesFormat = "S\225\187\145 ng\198\176\225\187\157i: %d/%d"
  end
  local peopleNumDes = string.format(self.peopleNumDesFormat, self:GetOnLinePeopleNum(), self:GetPeopleNum())
  return peopleNumDes
end

function CoalitionInfo:GetLeaderName()
  if self.serverData == nil or string.isNullOrEmpty(self.serverData.leaderUnionName) then
    return ClientTable.cfg_Ui_wordManager:GetUi_wordCount("LeagueSiege_part")
  end
  return self.serverData.leaderUnionName
end

function CoalitionInfo:GetUnionList()
  if type(self.serverData.members) ~= "table" or #self.serverData.members <= 0 then
    if self.defaultMembers == nil then
      self.defaultMembers = {}
      local defaultDes = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("LeagueSiege_part")
      table.insert(self.defaultMembers, {unionName = defaultDes, unionLeaderName = defaultDes})
    end
    return self.defaultMembers
  end
  return self.serverData.members
end

function CoalitionInfo:GetMainPlayerStatus()
  if gameMgr:GetAvatarManager():GetMainPlayer():GetCoalitionInfo() == nil and self.mMainPlayerStatus ~= nil and self.mMainPlayerStatus > CoalitionStatus.NONE then
    self.IsDirty_MainPlayerStatus = true
  end
  if self.IsDirty_MainPlayerStatus == false then
    return self.mMainPlayerStatus
  end
  self.IsDirty_MainPlayerStatus = false
  self.mMainPlayerStatus = self:CalcMainPlayerStatus()
  return self.mMainPlayerStatus
end

function CoalitionInfo:CalcMainPlayerStatus()
  local haveUnion = gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData().IsHaveUnion
  local mainPlayerCoalitionInfo = gameMgr:GetAvatarManager():GetMainPlayer():GetCoalitionInfo()
  if haveUnion == false or mainPlayerCoalitionInfo == nil or haveUnion == true and mainPlayerCoalitionInfo.serverData.camp ~= self.serverData.camp then
    return CoalitionStatus.NONE
  end
  local isUnionLeader = gameMgr:GetAvatarManager():GetMainPlayer():GetWarAllianceData().IsLeader()
  if isUnionLeader == false then
    return CoalitionStatus.MEMBER
  elseif self.serverData.leaderUnionName == gameMgr:GetAvatarManager():GetMainPlayer():GetMe().name then
    return CoalitionStatus.LEADER
  else
    return CoalitionStatus.DEPUTY_LEADER
  end
end

function CoalitionInfo:GetWarAllianceNum()
  if self.serverData == nil or type(self.serverData.members) ~= "table" then
    return 0
  end
  return #self.serverData.members
end

function CoalitionInfo:IsLeader(name)
  if self.serverData == nil then
    return false
  end
  return name == self.serverData.leaderUnionName
end

return CoalitionInfo
