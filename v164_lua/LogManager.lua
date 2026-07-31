LogManager = {}
local this = LogManager
LogEnumType = {
  Error = enum(0),
  Assert = enum(),
  Warning = enum(),
  Log = enum(),
  Exception = enum()
}
this.MB = 1048576
this.STACK_TRACEBACK = [[

stack traceback:]]
this.errorSwitch = true
this.warningSwitch = false
this.logSwitch = false
this.exceptionSwitch = true
this.intranet = false
this.outernet = true
this.writeLog = false
this.shieldList = {
  "Object reference not set to an instance of an object",
  "\196\144\195\162y ch\225\187\137 l\195\160 nh\225\186\175c nh\225\187\159, h\195\163y ch\225\187\165p m\195\160n h\195\172nh b\195\161o cho client r\225\186\177ng bi\225\186\191n target c\225\187\167a v\225\186\173t th\225\187\131 n\195\160y b\225\187\139 m\225\186\165t",
  "DrawMeshInstanced is not supported",
  "ArgumentNullException: Value cannot be null",
  "\232\136\141\229\188\131",
  "m_IsDownloadPausedTrue",
  "m_IsDownloadPausedFalse"
}

function LogManager.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
  this.Clean()
  this.InitDeviceInformation()
  this.AddEventListener()
end

function LogManager.RegistMessages()
end

function LogManager.InitGetLogForWrite(_, data)
  local configJson = ""
  local istocheck = ""
  if CS.MuInterface.Instance.GetVersionConfig then
    configJson = CS.MuInterface.Instance:GetVersionConfig()
  end
  if not string.isNullOrEmpty(configJson) then
    local config = json.decode(configJson)
    if not string.isNullOrEmpty(config.LogWrite) then
      istocheck = config.LogWrite
      for i, v in pairs(istocheck) do
        if data == v then
          this.writeLog = true
          this.userloginname = data
        end
      end
    end
  end
end

function LogManager.RegistEvent()
  this.eventContainer:Regist(Event.Game_ApplicationQuit, this.RemoveEventListener)
  this.eventContainer:Regist(Event.Login_ConnectSuccess, this.GetLoginServerTime)
  this.eventContainer:Regist(Event.Game_Restart, this.RemoveEventListener)
  this.eventContainer:Regist(Event.KoreLogForWrite, this.InitGetLogForWrite)
end

function LogManager.OnLeaveGame()
  this.RemoveEventListener()
end

function LogManager.Clean()
  this.errorList = {}
  this.warningList = {}
  this.logList = {}
  this.loginServerTime = 0
end

function LogManager.AddEventListener()
  CS.Framework.LogManager.BindLogListener(this.LoadLog)
end

function LogManager.RemoveEventListener()
  this.Clean()
  CS.Framework.LogManager.RemoveLogListener(this.LoadLog)
end

function LogManager.LoadLog(condition, stackTrace, type)
  local typeList = string.split(tostring(type), ":")
  if typeList[1] == "Error" and tonumber(typeList[2]) == LogEnumType.Error then
    if LuaClass.GMSocket and gameMgr:GetGMDataMgr() then
      local logMessage = {
        type = GM_DataEnum.Log,
        typeName = string.GetColorText("L\225\187\151i Unity", ItemQuality2ColorDic[7]),
        id = typeList[1],
        messageIdToName = string.GetColorText(string.split(condition, "\n")[1], ItemQuality2ColorDic[7]),
        tableContent = table.DeepCopy(condition),
        time = string.format("%s:%s", os.date("%Y-%m-%d %H:%M:%S", math.floor(LuaClass.GMSocket.gettime())), string.sub(string.split(tostring(LuaClass.GMSocket.gettime()), ".")[2], 1, 3)),
        index = 0
      }
      gameMgr:GetGMDataMgr():UpdateMessageData(logMessage)
    end
    if this.errorSwitch then
      if this.intranet and not LoginData.externalNet then
        this.AddErrorList(condition)
      end
      if this.outernet and LoginData.externalNet then
        this.AddErrorList(condition)
      end
    end
  end
  if typeList[1] == "Warning" and tonumber(typeList[2]) == LogEnumType.Warning and this.warningSwitch then
    if this.intranet and not LoginData.externalNet then
      this.AddWarningList(condition)
    end
    if this.outernet and LoginData.externalNet then
      this.AddWarningList(condition)
    end
  end
  if typeList[1] == "Log" and tonumber(typeList[2]) == LogEnumType.Log and this.logSwitch then
    if this.intranet and not LoginData.externalNet then
      this.AddLogList(condition)
    end
    if this.outernet and LoginData.externalNet then
      this.AddLogList(condition)
    end
  end
  if typeList[1] == "Exception" and tonumber(typeList[2]) == LogEnumType.Exception and this.exceptionSwitch then
    if this.intranet and not LoginData.externalNet then
      this.AddExceptionList(condition)
    end
    if this.outernet and LoginData.externalNet then
      this.AddExceptionList(condition)
    end
  end
  if this.writeLog and this.outernet and LoginData.externalNet then
    CS.UnityEngine.Debug.Log("\229\173\152\229\156\168\229\189\147\229\137\141")
    this.SetUser()
    this.SaveLogDataPerser(condition, this.userloginname or "uerlog")
  end
end

function LogManager.AddErrorList(condition)
  this.SetUser()
  this.SaveLogData(condition)
end

function LogManager.SubCondition(condition, stackTrace)
  local index = string.find(condition, this.STACK_TRACEBACK)
  if index ~= nil then
    stackTrace = string.trim(string.sub(condition, index, string.len(condition) - 1))
    condition = string.trim(string.sub(condition, 1, index))
  end
  return condition, stackTrace
end

function LogManager.AddWarningList(condition)
  this.SetUser()
  this.SaveLogData(condition)
end

function LogManager.AddLogList(condition)
  this.SetUser()
  this.SaveLogData(condition)
end

function LogManager.AddExceptionList(condition)
  this.SetUser()
  this.SaveLogData(condition)
end

function LogManager.AddLoginLog(log, tag)
  if CS.Framework.ResourceManager.editorMode then
    return
  end
  if string.isNullOrEmpty(log) then
    return
  end
  tag = tag or "LOGINLOG"
  local form = CS.UnityEngine.WWWForm()
  form:AddField("action", "Mobileerror")
  form:AddField("type", "insert")
  form:AddField("deviceModel", tostring(this.deviceModel))
  form:AddField("RAM", tostring(this.RAM))
  form:AddField("CPU", tostring(this.CPU))
  form:AddField("GPU", tostring(this.GPU))
  form:AddField("user", tostring(this.user))
  form:AddField("version", tostring(this.version))
  form:AddField("serverId", tostring(this.serverId))
  form:AddField("roleId", tostring(this.roleId))
  form:AddField("msg", log)
  form:AddField("onlineTime", tostring(this.GetOnLineTime()))
  form:AddField("other", tostring(tag))
  Http.RequestHaveArg(this.addLog, form)
end

function LogManager.InitDeviceInformation()
  this.deviceModel = nil
  this.RAM = nil
  this.CPU = nil
  this.SetDevice()
end

function LogManager.SetDevice()
  this.deviceModel = tostring(CS.UnityEngine.SystemInfo.deviceModel)
  this.CPU = CSMobileInfo.CpuName
  this.GPU = tostring(CS.UnityEngine.SystemInfo.graphicsDeviceType)
  local apkVersion = MuInterfaceLua.Instance:GetInstallResVersion()
  local curVersion = CS.Framework.HotUpdatePorcessMgr.localVersion:ToString()
  this.version = "V." .. apkVersion .. "_" .. curVersion
end

function LogManager.SetUser()
  this.user = LoginData.userName
  this.serverId = LoginData.serverId
  if not string.isNullOrEmpty(LoginData.roleName) then
    this.roleId = LoginData.roleId .. "-" .. LoginData.roleName
  else
    this.roleId = LoginData.roleId
  end
  local curRAM = CS.Framework.LogManager.GetUseMemory()
  local maxRAM = CS.Framework.LogManager.GetTotalMemory()
  this.RAM = curRAM .. "M/" .. maxRAM .. "M"
end

function LogManager.GetLoginServerTime()
  this.loginServerTime = Time.GetServerSecondTime()
end

function LogManager.GetOnLineTime()
  local onLineTime = Time.GetServerSecondTime() - this.loginServerTime
  local day = math.modf(onLineTime / 86400)
  local hour = math.modf((onLineTime - day * 24 * 60 * 60) / 3600)
  local min = math.modf((onLineTime - day * 24 * 60 * 60 - hour * 60 * 60) / 60)
  local sec = onLineTime - day * 24 * 60 * 60 - hour * 60 * 60 - min * 60
  local str = string.format("%d:%d:%d:%d", day, hour, min, sec)
  return str
end

function LogManager.SaveLogData(condition)
  local form = CS.UnityEngine.WWWForm()
  form:AddField("deviceModel", tostring(this.deviceModel))
  form:AddField("RAM", tostring(this.RAM))
  form:AddField("CPU", tostring(this.CPU))
  form:AddField("GPU", tostring(this.GPU))
  form:AddField("user", tostring(this.user))
  form:AddField("version", tostring(this.version))
  form:AddField("serverId", tostring(this.serverId))
  form:AddField("roleId", tostring(this.roleId))
  form:AddField("msg", condition)
  form:AddField("onlineTime", tostring(this.GetOnLineTime()))
  form:AddField("other", tostring(this.other))
  local IsShieldSaveLogData = LogManager.IsShieldSaveLogData(condition)
  if IsShieldSaveLogData == true then
    return
  end
  Http.RequestHaveArg(LoginData.AddLog, form)
end

function LogManager.SaveLogDataPerser(condition, loginname)
  local form = CS.UnityEngine.WWWForm()
  form:AddField("deviceModel", tostring(this.deviceModel))
  form:AddField("RAM", tostring(this.RAM))
  form:AddField("CPU", tostring(this.CPU))
  form:AddField("GPU", tostring(this.GPU))
  form:AddField("user", loginname)
  form:AddField("version", tostring(this.version))
  form:AddField("serverId", tostring(this.serverId))
  form:AddField("roleId", tostring(this.roleId))
  form:AddField("msg", condition)
  form:AddField("onlineTime", tostring(this.GetOnLineTime()))
  form:AddField("other", tostring(this.other))
  local IsShieldSaveLogData = LogManager.IsShieldSaveLogData(condition)
  if IsShieldSaveLogData == true then
    return
  end
  Http.RequestHaveArg(LoginData.AddLog, form)
end

function LogManager.IsShieldSaveLogData(condition)
  if this.shieldList == nil then
    return false
  end
  for i, v in pairs(this.shieldList) do
    if string.contains(condition, v) then
      return true
    end
  end
  return false
end

LogManager.Init()
