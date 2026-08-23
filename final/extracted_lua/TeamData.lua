TeamData = {}
local this = TeamData
TeamData.teamId = 0
TeamData.isInTeam = false
TeamData.isReachLevel = false
TeamData.autoInTeamOption = AutoAcceptTypeInTeamEnum.All
TeamData.activityOption = TeamActivityType.None
TeamData.activityLevelOption = 0
TeamData.inTeamLevelLimit = 1
TeamData.isAutoInTeam = false
TeamData.isApplyAutoTeam = true
TeamData.isAllCareerTeam = false
TeamData.isLeader = false
TeamData.membersList = {}
TeamData.askInList = {}
TeamData.myInvitesList = {}
TeamData.nearbyTeams = {}
TeamData.inviteMeList = {}
TeamData.inviteMembership = {}

function TeamData.Init(data)
  this.Reset()
  this.isReachLevel = this.CheckLevelCondition()
end

function TeamData.SetData(msg)
  this.oldMembersList = this.membersList
  this.membersList = {}
  this.askInList = {}
  this.myInvitesList = {}
  this.inviteMembership = {}
  this.teamId = msg.teamId
  this.leaderId = msg.leaderId
  for _, v in pairs(msg.members) do
    local member = this.GetMemberDataByMsg(v)
    table.insert(this.membersList, member)
    RoleManager.RefreshHeadColorById(member.rid)
  end
  for _, v in pairs(msg.asks) do
    local member = this.GetMemberDataByMsg(v)
    if member.online then
      table.insert(this.askInList, member)
    end
  end
  for _, v in pairs(msg.invites) do
    local member = this.GetMemberDataByMsg(v)
    table.insert(this.myInvitesList, member)
  end
  for _, v in pairs(msg.invites) do
    local member = this.GetMemberDataByMsg(v)
    table.insert(this.inviteMembership, member)
  end
  this.isInTeam = true
  this.isReachLevel = true
  this.isAllCareerTeam = this.CalIsAllCareerInTeam()
  this.isLeader = this.leaderId == ViewData.meData.id
  if this.inTeamLevelLimit ~= msg.enterLevel or tonumber(this.autoInTeamOption) ~= msg.enterMode or this.activityOption ~= msg.activity or this.lowLevel ~= msg.minLevel or this.hightLevel ~= msg.maxLevel then
    this.SetInTeamOptionIndex(msg.enterMode)
    this.SetEnterTeamLimitLevel(msg.enterLevel)
    this.activityOption = msg.activity ~= nil and msg.activity or TeamActivityType.None
    this.lowLevel = msg.minLevel and msg.minLevel or 0
    this.hightLevel = msg.maxLevel and msg.maxLevel or 0
    EventManager.Dispatch(Event.Team_RefreshLimitInfo)
  end
  this.SortMemberData()
  this.InfoChangeCallback()
  this.oldMembersList = {}
  EventManager.Dispatch(Event.Team_RefreshTeamInfo)
  TeamData.AutoInvitateRole()
end

function TeamData.AutoInvitateRole()
  if this.roleId then
    EventManager.Dispatch(Event.Team_InviteInTeam, {
      this.roleId
    })
    this.CleanInvitateRole()
  end
end

function TeamData.AddInvitateRole(roleId)
  this.roleId = roleId
end

function TeamData.CleanInvitateRole()
  this.roleId = nil
end

function TeamData.OnRetLimitType(msg)
  if this.activityOption ~= msg.activity or this.lowLevel ~= msg.minLevel or this.hightLevel ~= msg.maxLevel then
    this.activityOption = msg.activity ~= nil and msg.activity or TeamActivityType.None
    this.lowLevel = msg.minLevel and msg.minLevel or 0
    this.hightLevel = msg.maxLevel and msg.maxLevel or 0
    EventManager.Dispatch(Event.Team_RefreshLimitInfo)
  end
end

function TeamData.SortMemberData()
  table.sort(this.membersList, function(a, b)
    return a.time < b.time
  end)
  local leaderData
  for i, v in pairs(this.membersList) do
    if v.rid == this.leaderId then
      if i == 1 then
        return
      end
      leaderData = v
      table.remove(this.membersList, i)
      table.insert(this.membersList, 1, leaderData)
      return
    end
  end
end

function TeamData.GetMemberDataByMsg(data)
  if not data then
    return {}
  end
  local member = {}
  member.rid = data.rid
  member.startName = data.startName
  member.startLevel = data.startLevel
  member.startCareer = data.startCareer
  member.time = data.time
  member.online = data.online
  member.equips = data.equips
  if not data.online then
    for k, v in pairs(this.oldMembersList) do
      if v.rid == data.rid then
        member.info = v.info
        member.mapId = v.mapId
        member.line = v.line
      end
    end
  else
    member.info = data.info
    member.mapId = data.mapId
    member.line = data.line
  end
  return member
end

function TeamData.CheckLevelCondition()
  local teamLevelConfig = ClientTable.cfg_Global_globalManager:TryGetValue(2340001)
  return true
end

function TeamData.CalIsAllCareerInTeam()
  local tempCareerTable = {}
  local careerTypeCount = 1
  for i, v in pairs(this.membersList) do
    if v then
      if not table.containsKey(tempCareerTable, v.startCareer) then
        tempCareerTable[v.startCareer] = 1
        careerTypeCount = careerTypeCount + 1
      else
        tempCareerTable[v.startCareer] = tempCareerTable[v.startCareer] + 1
      end
    end
  end
  return 3 < careerTypeCount
end

function TeamData.SetEnterTeamLimitLevel(level)
  if level ~= nil then
    level = 0 < level and level or 1
    level = 500 < level and 500 or level
    this.inTeamLevelLimit = level
  end
end

function TeamData.SetInTeamOptionIndex(index)
  if index ~= nil then
    index = 0 <= index and index or 0
    index = index < 3 and index or 2
    this.autoInTeamOption = index == 0 and AutoAcceptTypeInTeamEnum.All or index == 1 and AutoAcceptTypeInTeamEnum.FriendsOrUnion or index == 2 and AutoAcceptTypeInTeamEnum.Off
  end
end

function TeamData.SetActivityType(index)
  if not this.activityOption or this.activityOption and this.activityOption ~= index then
    this.activityOption = index
    local msg = {
      activityMode = this.activityOption
    }
    NetManager.Send(TeamMessage.ReqSetActivity, msg)
  end
  this.SetDemonSquare()
end

function TeamData.SetActivityLevel(index, option)
  this.activityLevelOption = index
  if option then
    this.SetCurLowLevel(option)
  end
end

function TeamData.SetCurLowLevel(option)
  if not (this.lowLevel and (not this.lowLevel or this.lowLevel == option[this.activityLevelOption + 1].lowLevel) and this.hightLevel) or this.hightLevel and this.hightLevel ~= option[this.activityLevelOption + 1].hightLevel then
    this.lowLevel = option[this.activityLevelOption + 1].lowLevel
    this.hightLevel = option[this.activityLevelOption + 1].hightLevel
    local msg = {
      minLevel = this.lowLevel,
      maxLevel = this.hightLevel
    }
    NetManager.Send(TeamMessage.ReqSetLimit, msg)
  end
end

function TeamData.SetCurRecruit(option)
  if option then
    this.lowLevel = option.lowLevel
    this.hightLevel = option.hightLevel
    local msg = {
      minLevel = this.lowLevel,
      maxLevel = this.hightLevel
    }
    NetManager.Send(TeamMessage.ReqSetLimit, msg)
  end
end

function TeamData.SetInTeamLevelLimit(level)
  this.inTeamLevelLimit = level
end

function TeamData.CanEnterTeamByLevel(level)
  return level >= this.inTeamLevelLimit
end

function TeamData.SetNearbyTeamsData(data)
  if not data then
    return
  end
  this.nearbyTeams = data.teams
end

function TeamData.SetAutoInTeam(value)
  this.isAutoInTeam = value
  if value then
    TeamData.SetAutoAddTeam(1)
  else
    TeamData.SetAutoAddTeam(0)
  end
end

function TeamData.SetApplyAutoInTeam(value)
  this.isApplyAutoTeam = value
  if value then
    TeamData.SetApplyAutoTeam(1)
    TeamData.InfoChangeCallback()
  else
    TeamData.SetApplyAutoTeam(0)
  end
end

function TeamData.ClearInviteMeData()
end

function TeamData.RemoveInviteMeData(teamId)
  for i, v in pairs(this.inviteMeList) do
    if v.teamId == teamId then
      table.remove(this.inviteMeList, i)
      return
    end
  end
end

function TeamData.InfoChangeCallback()
  if this.isLeader then
    if this.activityOption == TeamActivityType.None then
    end
    if (this.activityOption == TeamActivityType.ColorCastle or this.activityOption == TeamActivityType.DemonSquare) and table.count(this.askInList) > 0 then
      for i, role in pairs(this.askInList) do
        if role.online then
          local rid = role.rid
          if role.info and this.lowLevel and this.hightLevel then
            local roleLevel = role.info.level
            if roleLevel >= this.lowLevel and roleLevel <= this.hightLevel then
              local data = {rid}
              EventManager.Dispatch(Event.Team_AgreeInMyTeam, data)
              return
            end
          end
        end
      end
    end
    EventManager.Dispatch(Event.Team_AskListUpdate, table.count(this.askInList))
  end
end

function TeamData.HasMemberByIndex(index)
  return this.membersList and index <= table.count(this.membersList)
end

function TeamData.HasInviteMembership(index)
  return this.inviteMembership and index <= table.count(this.inviteMembership)
end

function TeamData.GetMemberByIndex(index)
  return this.membersList and this.membersList[index]
end

function TeamData.ClearTeamData()
  this.Reset()
end

function TeamData.DisAgreeInviteData(teamId)
  this.RemoveInviteMeData(teamId)
end

function TeamData.Reset()
  this.teamId = 0
  this.isInTeam = false
  this.isReachLevel = false
  this.isAllCareerTeam = false
  this.isLeader = false
  this.membersList = {}
  this.askInList = {}
  this.myInvitesList = {}
  this.nearbyTeams = {}
  this.inviteMeList = {}
  this.inviteMembership = {}
  this.levelTab = {}
  this.lowLevel = 1
  this.hightLevel = 1
  this.activityOption = TeamActivityType.None
  this.activityLevelOption = 0
  EventManager.Dispatch(Event.Team_RefreshTeamInfo, nil)
  EventManager.Dispatch(Event.Team_AskListUpdate, table.count(this.askInList))
end

function TeamData.GetMyInviteListCount()
  return table.count(this.myInvitesList)
end

function TeamData.GetAskInListCount()
  return table.count(this.askInList)
end

function TeamData.GetInviteMeListCount()
  return table.count(this.inviteMeList)
end

function TeamData.GetInviteMembership()
  return table.count(this.inviteMembership)
end

function TeamData.GetMyInviteList()
  return this.myInvitesList
end

function TeamData.GetAskInList()
  return this.askInList
end

function TeamData.GetInviteMeList()
  return this.inviteMeList
end

function TeamData.GetInvteMembership()
  return this.inviteMembership
end

function TeamData.HasInvitedId(id)
  for i, v in pairs(this.myInvitesList) do
    if v.rid == id then
      return true
    end
  end
  return false
end

function TeamData.GetTeamLeaderInfoByTeamInfo(teamInfo)
  local leaderId = teamInfo.leaderId
  if teamInfo.members then
    for _, member in pairs(teamInfo.members) do
      if member.rid == leaderId then
        return member
      end
    end
  end
  return nil
end

function TeamData.GetTeamMemberCountByTeamInfo(teamInfo)
  return teamInfo.members and table.count(teamInfo.members) or 0
end

function TeamData.IsTeammate(id)
  for _, member in pairs(this.membersList) do
    if member.rid == id then
      return true
    end
  end
  if ViewData.meData ~= nil and ViewData.meData.id == id then
    return true
  end
  return false
end

function TeamData.IsInTeamState()
  return this.membersList and table.count(this.membersList) >= 1
end

function TeamData.GetTeamId()
  return this.teamId
end

function TeamData.GetCreateTeamCondition()
  local createLevel = tonumber(GlobalConfig.GetGlobalConfig(2450010))
  return createLevel <= ViewData.meData.level
end

function TeamData.GetAskTeamCondition()
  local askLevel = tonumber(GlobalConfig.GetGlobalConfig(2450011))
  return askLevel <= ViewData.meData.level
end

function TeamData.SetInviteMeData(data)
  this.SetAutoTeamFlag()
  if this.isAutoInTeam and data ~= nil and data.teamId ~= nil then
    EventManager.Dispatch(Event.Team_AgreeInOtherTeam, data.teamId)
    return
  end
  EventManager.Dispatch(Event.Team_InviteListUpdate, table.count(InvitationData.GetInvitedToTeamData()))
end

function TeamData.SetAutoTeamFlag()
  if tonumber(TeamData.GetAutoAddTeam()) > 0 then
    this.isAutoInTeam = true
  else
    this.isAutoInTeam = false
  end
end

function TeamData.SetAutoApplyTeamFlag()
  if tonumber(TeamData.GetApplyAutoTeam()) > 0 then
    this.isApplyAutoTeam = true
  else
    this.isApplyAutoTeam = false
  end
end

function TeamData.SetAutoAddTeam(auto)
  PlayerPrefs.SetString("Team" .. tostring(LoginData.roleId), auto)
end

function TeamData.GetAutoAddTeam()
  return PlayerPrefs.GetString("Team" .. tostring(LoginData.roleId), "0")
end

function TeamData.SetApplyAutoTeam(auto)
  PlayerPrefs.SetString("TeamApply" .. tostring(LoginData.roleId), auto)
end

function TeamData.GetApplyAutoTeam()
  return PlayerPrefs.GetString("TeamApply" .. tostring(LoginData.roleId), "1")
end

local optionList = {}
local str = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_17")
local str1 = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_18")

function TeamData.SetDemonSquare()
  optionList = {}
  if this.activityOption == TeamActivityType.None then
    local option = {}
    option.optionName = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_16")
    option.optionFlag = true
    option.number = 0
    option.lowLevel = 0
    option.hightLevel = 0
    optionList[1] = option
    return
  end
  local num = 0
  this.levelTab = TranScriptData.GetLevelTblData(100408)
  for i = 1, table.count(this.levelTab) do
    num = this:DealActivityIndo(i, this.levelTab, num)
  end
  this.levelTab = TranScriptData.GetLevelTblData(100414)
  for i = 1, table.count(this.levelTab) do
    num = this:DealActivityIndo(i, this.levelTab, num)
  end
end

function TeamData:DealActivityIndo(index, levelTab, num)
  local strLevel = string.split(levelTab[index], "#")
  local level = strLevel[3]
  local levelNum = string.split(level, "_")
  local transTable = ClientTable.cfg_Map_instanceManager:TryGetValue(tonumber(strLevel[1]), "mapId")
  local optionName = ""
  if transTable.type == TranScriptData.TranScriptSubType.DemonPlaza and this.activityOption == TeamActivityType.DemonSquare or transTable.type == TranScriptData.TranScriptSubType.BloodCastle and this.activityOption == TeamActivityType.ColorCastle then
    num = num + 1
    local tempstr = transTable.type == TranScriptData.TranScriptSubType.DemonPlaza and str1 or str
    optionName = string.format(tempstr, num, levelNum[1] .. "~" .. levelNum[2])
    local option = {}
    option.optionName = optionName
    option.number = num
    option.optionFlag = true
    option.lowLevel = tonumber(levelNum[1])
    option.hightLevel = tonumber(levelNum[2])
    optionList[num] = option
    if ViewData.meData.level >= tonumber(levelNum[1]) and ViewData.meData.level <= tonumber(levelNum[2]) then
      optionList[num].optionFlag = true
      if optionList[num - 1] then
        optionList[num - 1].optionFlag = true
      end
    else
      optionList[num].optionFlag = false
    end
  end
  return num
end

function TeamData.GetOptionList()
  return optionList
end

function TeamData.GetCurLevelTable()
  optionList = {}
  if this.activityOption == TeamActivityType.None then
    optionList.optionName = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("TeamDesc_16")
    optionList.number = 0
    optionList.optionFlag = true
    optionList.lowLevel = 0
    optionList.hightLevel = 0
    return optionList
  end
  this.SetDemonSquare()
  for k, v in pairs(optionList) do
    if v.lowLevel == this.lowLevel and v.hightLevel == this.hightLevel then
      optionList = v
    end
  end
  return optionList
end
