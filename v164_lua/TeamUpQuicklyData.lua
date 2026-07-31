TeamUpQuicklyData = {}
local this = TeamUpQuicklyData
local instanceId, enum, condition, levelAndNumber, enterConditionData, instanceName, parentInstanceUI
TeamUpQuicklyData.TeamInfor = nil
TeamUpQuicklyData.State = 0
TeamUpQuicklyData.matchResult = true
TeamUpQuicklyData.process = 1

function TeamUpQuicklyData.SetInstanceInfor(msg, instanceUI)
  local transTable = ClientTable.cfg_Map_instanceManager:TryGetValue(tonumber(msg.instanceId), "mapId")
  instanceName = transTable.name
  for k, v in pairs(TranScriptData.TranScriptGlobal) do
    if k == transTable.type then
      enum = k
      condition = v.condition
      levelAndNumber = v.LevelAndNumber
    end
  end
  if enum == nil then
    logError("Kh\195\180ng c\195\179 lo\225\186\161i PB t\198\176\198\161ng \225\187\169ng")
  end
  local meLevel = ViewData.meData.level
  for k, v in pairs(msg.members) do
    if v.rid == msg.leader then
      ViewData.meData.level = v.level
    end
  end
  enterConditionData, levelAndNumber = TranScriptData.GetEnterConditionData(enum, condition, levelAndNumber)
  ViewData.meData.level = meLevel
  instanceId = msg.instanceId
end

function TeamUpQuicklyData.SetInstanceUI(instanceUI)
  parentInstanceUI = instanceUI
end

function TeamUpQuicklyData.GetInterfaceTitleInfor()
  return {
    name = instanceName,
    instanceLevel = levelAndNumber[1],
    minLevel = levelAndNumber[2],
    maxLevel = levelAndNumber[3]
  }
end

function TeamUpQuicklyData.GetInstanceInfor()
  return instanceId, parentInstanceUI
end

function TeamUpQuicklyData.GetEnterConditionData()
  return enterConditionData
end

function TeamUpQuicklyData.GetTeamMemberInfor()
  local roleInforData = {}
  for i = 1, #this.TeamInfor.members do
    roleInforData[i] = {
      iconSprite = this.TeamInfor.members[i].career,
      roleName = this.TeamInfor.members[i].name,
      confirm = this.TeamInfor.members[i].confirm,
      reason = this.TeamInfor.members[i].reason,
      leaderSign = this.TeamInfor.members[i].rid == this.TeamInfor.leader,
      rid = this.TeamInfor.members[i].rid,
      level = this.TeamInfor.members[i].level
    }
  end
  return roleInforData
end

function TeamUpQuicklyData.HasInvited(targetId)
  for k, v in pairs(this.TeamInfor.members) do
    if v.rid == targetId then
      return true
    end
  end
  return false
end

function TeamUpQuicklyData.IsLeader()
  if not this.TeamInfor then
    return false
  end
  return this.meData.id == this.TeamInfor.leader
end
