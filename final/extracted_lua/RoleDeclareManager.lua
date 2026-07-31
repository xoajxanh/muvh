RoleDeclareManager = {}
local this = RoleDeclareManager
RoleDeclareManager.GetAmountState = false
RoleDeclareManager.StartRequest = false

function RoleDeclareManager.Init()
  this.OnReset()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
end

function RoleDeclareManager.OnReset()
  this.recentRoleData = nil
  this.SetSaveFlag()
end

function RoleDeclareManager.RegistEvent()
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.RoleOnLoginedMap, nil, 3)
  this.eventContainer:Regist(Event.Game_ApplicationQuit, this.ResLogout)
end

function RoleDeclareManager.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.ResLogout)
end

function RoleDeclareManager.SetSaveFlag()
  this.needToSave = true
end

function RoleDeclareManager.RoleOnLoginedMap()
  if this.needToSave and ViewData.meData ~= nil and ViewData.meData.career ~= 0 then
    local power = ViewData.meData:GetAttribute(EAttributeType.fight)
    this.SaveRecentRole(power, ViewData.meData.level, ViewData.meData.career)
    this.needToSave = false
  end
end

function RoleDeclareManager.ResLogout()
  if ViewData.meData ~= nil and this.needToSave == false and ViewData.meData.career ~= 0 then
    local power = ViewData.meData:GetAttribute(EAttributeType.fight)
    this.SaveRecentRole(power, ViewData.meData.level, ViewData.meData.career)
    this.needToSave = true
  end
end

function RoleDeclareManager.CheckHaveAndroidServerRole()
  if this.recentRoleData ~= nil then
    for _, v in pairs(this.recentRoleData) do
      if tonumber(v.serverid) <= LoginData.androidServerLimit then
        return true
      end
    end
  end
  return false
end

function RoleDeclareManager.GetRoleForServerId(serverId)
  local role
  if this.recentRoleData ~= nil then
    for k, v in pairs(this.recentRoleData) do
      if v.serverid == serverId then
        role = v
        return role
      end
    end
  end
  return role
end

function RoleDeclareManager.GetRoleInformation()
  LogManager.AddLoginLog("\232\142\183\229\143\150\229\159\139\231\130\185\228\191\161\230\129\175_Begin", "Login")
  this.recentRoleData = nil
  this.StartRequest = true
  local form = CS.UnityEngine.WWWForm()
  form:AddField("platform", this.GetPid())
  form:AddField("type", "query")
  form:AddField("loginname", LoginData.userName)
  LoginData.DataReportingLog({
    "\230\149\176\230\141\174\228\184\138\230\138\165RecentRole_URL",
    LoginData.ActionStep,
    "platform",
    this.GetPid(),
    "type",
    "query",
    "loginname",
    LoginData.userName
  })
  Http.RequestHaveArg(LoginData.RecentRole_URL, form, function(text)
    this.GetAmountState = true
    if not string.isNullOrEmpty(text) then
      LogManager.AddLoginLog("\232\142\183\229\143\150\229\159\139\231\130\185\228\191\161\230\129\175_End Sucess", "Login")
      local data = json.decode(text)
      if data ~= nil and data.data ~= nil and not string.isNullOrEmpty(data.data) then
        this.recentRoleData = data.data
      end
    else
      LogManager.AddLoginLog("\232\142\183\229\143\150\229\159\139\231\130\185\228\191\161\230\129\175_End Fail", "Login")
    end
  end)
end

function RoleDeclareManager.GetPid()
  local a = ""
  if LoginData.externalNet then
    a = CS.MuInterface.Instance:GetPid()
  elseif CS.Main.instance.serverConfigId ~= 0 then
    a = tostring(CS.Main.instance.serverConfigId)
  else
    a = CS.MuInterface.Instance:GetPid()
  end
  if string.isNullOrEmpty(a) then
    a = "0"
  end
  return a
end

function RoleDeclareManager.SaveRecentRole(power, level, career)
  local form = CS.UnityEngine.WWWForm()
  form:AddField("platform", this.GetPid())
  form:AddField("type", "update")
  form:AddField("loginname", tostring(LoginData.userName))
  form:AddField("serverid", tostring(LoginData.serverId))
  form:AddField("rolename", LoginData.roleName)
  form:AddField("power", tostring(power))
  form:AddField("level", level)
  form:AddField("roleid", tostring(LoginData.roleId))
  form:AddField("careerid", career)
  LoginData.DataReportingLog({
    "\230\149\176\230\141\174\228\184\138\230\138\165RecentRole_URL",
    LoginData.ActionStep,
    "platform",
    this.GetPid(),
    "type",
    "update",
    "loginname",
    LoginData.userName
  })
  Http.RequestHaveArg(LoginData.RecentRole_URL, form, function(text)
    if not string.isNullOrEmpty(text) then
    else
    end
  end)
  this.GetRoleInformation()
end

function RoleDeclareManager.DeleteRecentRole(rid)
  local form = CS.UnityEngine.WWWForm()
  form:AddField("platform", this.GetPid())
  form:AddField("type", "delete")
  form:AddField("loginname", LoginData.userName)
  form:AddField("roleid", rid)
  LoginData.DataReportingLog({
    "\230\149\176\230\141\174\228\184\138\230\138\165RecentRole_URL",
    LoginData.ActionStep,
    "platform",
    this.GetPid(),
    "type",
    "delete",
    "loginname",
    LoginData.userName
  })
  Http.RequestHaveArg(LoginData.RecentRole_URL, form, function(text)
    if not string.isNullOrEmpty(text) then
    else
    end
  end)
end

RoleDeclareManager.Init()
