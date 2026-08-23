ActionStepsLogManager = {}
local this = ActionStepsLogManager
ActionStepsType = {
  None = enum(0),
  ActivateGame = enum(),
  LoadConfig = enum(),
  ResourceLoadStart = enum(),
  ResourceLoadSuccess = enum(),
  LoginUI = enum(),
  LoginGame = enum(),
  LogOut = enum(),
  SelectServer = enum(),
  EnterCreateRoleUI = enum(),
  CreateRole = enum(),
  CreateRoleSuccess = enum(),
  SelectRole = enum(),
  EnterGame = enum(),
  QuitGame = enum()
}

function ActionStepsLogManager.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.CleanLogData()
  this.InitModerData()
end

function ActionStepsLogManager.InitModerData()
  this.actionType = ActionStepsType.None
  this.mobile = tostring(CS.UnityEngine.SystemInfo.deviceModel)
  this.model = tostring(CS.UnityEngine.SystemInfo.deviceType)
  this.imei = CS.UnityEngine.SystemInfo.deviceUniqueIdentifier
  local apkVersion = MuInterfaceLua.Instance:GetInstallResVersion()
  local curVersion = CS.Framework.HotUpdatePorcessMgr.localVersion:ToString()
  this.version = "V." .. apkVersion .. "_" .. curVersion
end

function ActionStepsLogManager.RegistMessages()
end

function ActionStepsLogManager.RegistEvent()
  this.eventContainer:Regist(Event.GamePlay_Enter, this.EnterGame)
  this.eventContainer:Regist(Event.Game_ApplicationQuit, this.QuitGame)
end

function ActionStepsLogManager.ActivateGame()
  this.SetRoleAction(ActionStepsType.ActivateGame)
end

function ActionStepsLogManager.QuitGame()
  this.SetRoleAction(ActionStepsType.QuitGame)
end

function ActionStepsLogManager.EnterGame()
  this.SetRoleAction(ActionStepsType.EnterGame)
end

function ActionStepsLogManager.SetRoleAction(actionStep)
  if actionStep ~= nil then
    this.SaveRoleAction(actionStep)
  end
end

function ActionStepsLogManager.CleanLogData()
  this.actionType = ActionStepsType.None
end

function ActionStepsLogManager.GetPid()
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

function ActionStepsLogManager.SaveRoleAction(actionStep)
  local form = CS.UnityEngine.WWWForm()
  form:AddField("platform", this.GetPid())
  form:AddField("type", actionStep)
  form:AddField("mobile", this.mobile)
  form:AddField("uname", LoginData.userName)
  form:AddField("version", this.version)
  form:AddField("imei", this.imei)
  form:AddField("model", this.model)
  LoginData.DataReportingLog({
    "\230\149\176\230\141\174\228\184\138\230\138\165",
    LoginData.SaveRoleUrl,
    "platform",
    this.GetPid(),
    "type",
    actionStep,
    "mobile",
    this.mobile,
    "uname",
    LoginData.userName,
    "version",
    this.version,
    "imei",
    this.imei,
    "model",
    this.model
  })
  Http.RequestHaveArg(LoginData.SaveRoleUrl, form, function(text)
    if not string.isNullOrEmpty(text) then
    else
    end
  end)
end

function ActionStepsLogManager.GetRoleActionStep(actionStep)
  Http.Request(this.postUrl, function(text)
    if not string.isNullOrEmpty(text) then
    else
    end
  end)
end

function ActionStepsLogManager.GetRoleAction(actionStep)
  local form = CS.UnityEngine.WWWForm()
  form:AddField("platform", this.GetPid())
  form:AddField("mobile", this.mobile)
  LoginData.DataReportingLog({
    "\230\149\176\230\141\174\228\184\138\230\138\165ActionStep",
    tostring(LoginData.ActionStep),
    "platform",
    this.GetPid(),
    "mobile",
    this.mobile
  })
  Http.RequestHaveArg(LoginData.ActionStep, form, function(text)
    if not string.isNullOrEmpty(text) then
    else
    end
  end)
end

ActionStepsLogManager.Init()
