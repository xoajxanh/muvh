ServerViewFixer = {}
local this = ServerViewFixer
local MaxViewSizePow2 = 64
local Req_Move_MissingRole_Interval = 3
local Req_Skill_MissingRole_Interval = 3
this.missingRoles = {}
local FixType = {other = 0, player = 1}
local tempVec2Int = Vector2(0, 0)

function ServerViewFixer.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvents()
end

function ServerViewFixer.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResFixViewResponse, this.ResFixViewResponse)
end

function ServerViewFixer.RegistEvents()
  this.eventContainer:Regist(Event.Role_OnRoleEnterView, this.OnRoleEnterView)
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.OnChangeMap)
end

function ServerViewFixer.ResFixViewResponse(_, msg)
  if this.missingRoles[msg.rid] then
    this.missingRoles[msg.rid].fixType = msg.type
  end
end

function ServerViewFixer.OnRoleEnterView(_, roleData)
  if this.missingRoles[roleData.id] then
    this.missingRoles[roleData.id] = nil
  end
end

function ServerViewFixer.OnChangeMap(_)
  this.missingRoles = {}
end

function ServerViewFixer.AddUsingSkillMissingRole(roleId, roleX, roleY)
  if ViewData.meData == nil then
    return
  end
  local missingRole = this.missingRoles[roleId]
  if missingRole and missingRole.fixType == FixType.other then
    return
  end
  tempVec2Int:Set(roleX, roleY)
  if Vector2Int.DistancePow(ViewData.meData.serverCoord, tempVec2Int) > MaxViewSizePow2 then
    if missingRole then
      missingRole.missTimes = 0
    end
    return
  end
  if missingRole == nil then
    this.missingRoles[roleId] = {
      id = roleId,
      x = roleX,
      y = roleY,
      missTimes = 1
    }
    missingRole = this.missingRoles[roleId]
  end
  if missingRole.missTimes % Req_Skill_MissingRole_Interval == 1 then
    this.ReqSingleRoleView(roleId)
  end
  missingRole.missTimes = missingRole.missTimes + 1
end

function ServerViewFixer.AddMovingMissingRole(roleId, roleX, roleY)
  if ViewData.meData == nil then
    return
  end
  local missingRole = this.missingRoles[roleId]
  if missingRole and missingRole.fixType == FixType.other then
    return
  end
  tempVec2Int:Set(roleX, roleY)
  if Vector2Int.DistancePow(ViewData.meData.serverCoord, tempVec2Int) > MaxViewSizePow2 then
    if missingRole then
      missingRole.missTimes = 0
    end
    return
  end
  if missingRole == nil then
    this.missingRoles[roleId] = {
      id = roleId,
      x = roleX,
      y = roleY,
      missTimes = 1
    }
    missingRole = this.missingRoles[roleId]
  end
  if missingRole.missTimes % Req_Move_MissingRole_Interval == 1 then
    ServerViewFixer.ReqSingleRoleView(roleId)
  end
  missingRole.missTimes = missingRole.missTimes + 1
end

function ServerViewFixer.ReqSingleRoleView(roleid)
  NetManager.Send(MapMessage.ReqFixView, {rid = roleid})
end
