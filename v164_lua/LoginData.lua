LoginData = {
  addValue = 0,
  sign = "",
  userName = "",
  UserId = "",
  version = 1,
  sdkUserId = "",
  neckName = "",
  token = "0",
  accessToken = "",
  time = "0",
  gid = "0",
  opName = "",
  operId = 0,
  pId = 0,
  loginExt = "",
  isSdkLogging = false
}
local this = LoginData
LoginData.externalNet = CS.MuInterface.Instance:IsExternalNet()
LoginData.isSdk = CS.MuInterface.Instance:IsSdk()
LoginData.pId = tonumber(CS.MuInterface.Instance:GetPid())
LoginData.systemVersion = CS.MuInterface.Instance:getSystemVersion()
LoginData.sdk_pid = ""
LoginData.createPlayerDay = 0
LoginData.roleList = {}
LoginData.ServerTimeAdvance = 0
LoginData.roleCount = 0
LoginData.userId = 0
LoginData.roleId = 0
LoginData.roleName = ""
LoginData.data = {}
LoginData.serverList = {}
LoginData.equipmentList = {}
LoginData.oftenServers = {}
LoginData.oftenCount = 10
LoginData.serverGroup = {}
LoginData.serverGroupNameList = ""
LoginData.groupRuler = 9999
LoginData.server = {}
LoginData.serverId = 0
LoginData.openServerTime = 0
LoginData.combineServerTime = 0
LoginData.openServerDay = 0
LoginData.InGame = false
LoginData.resRandomName = ""
LoginData.resCreateRole = {}
LoginData.reconnectState = false
LoginData.animationTime = 0.4
LoginData.createRoleTbl = {}
LoginData.announcementData = {}
LoginData.playerCreateName = ""
LoginData.BanState = false
LoginData.isWhite = false
LoginData.isClickComplete = false
LoginData.selfIp = ""
LoginData.needReconnect = true
LoginData.needInviteCode = false
LoginData.roleLevel = 1
LoginData.createTime = 0
LoginData.OperEnum = {
  [3] = "xy",
  [102] = "tanwan",
  [116] = "tanwan",
  [105] = "wanxin",
  [109] = "jiuzhou",
  [112] = "yinghe",
  [115] = "yinghe"
}
LoginData.panelState = 0
LoginData.testSerVerListLimit = 16001
LoginData.serverGroupIndex = 1
LoginData.AndroidServerList = {}
LoginData.BlendServerList = {}
LoginData.isXyBlendApk = false
LoginData.showServerListCount = 1
LoginData.haveAndroidServerListRole = false
LoginData.androidServerLimit = 5000
LoginData.joined = false
LoginData.xyServerList = {}
LoginData.xyServerListIndex = 1
LoginData.roleInfoConnectTimeOut = false
LoginData.Server_old_user = ""
LoginData.Isold_user = false
LoginData.spellSwordRechargeData = {}
LoginData.careerCreateLevel = {}
LoginData.loginType = ""
LoginData.service_code = "SVC058"
LoginData.USER_FIRST_LOGIN = "userFirstLogin"
LoginData.USER_LAST_ACCOUNT = "uerLastAccount"
LoginData.USER_OFTEN_SERVER = "userOftenServer1"
LoginData.SERVER_URL_INNER = "http://client.fgqj.db9k.com/mu2/config/sList/mu2.txt"
LoginData.SERVER_URL_OUT = PlatformData.GetServerlistUrl() .. "/serverlist/android/serverlist_%s.txt"
LoginData.SERVER_CHECK_LOGIN = "http://api.fgqj.app.xy.com:3000/%s/login"
LoginData.Announcement_URL = PlatformData.GetDnsUrl() .. "/kingapi?action=Loginnote&platform=%s"
LoginData.IP_CALLBACK_URL = PlatformData.GetDnsUrl() .. "/kingapi?action=checkblack"
LoginData.CHECK_ROLE_COUNT_URL_check = "/kingapi&action=register_num_limit"
LoginData.CHECK_ROLE_COUNT_URL = "/http/transmit?"
LoginData.AddLog = PlatformData.GetClientLogdnsl() .. "/saveFileLog"
LoginData.ActionStep = PlatformData.GetDnsUrl() .. "/kingapi?action=forgetLoginname"
LoginData.SaveRoleUrl = PlatformData.GetDnsUrl() .. "/kingapi?action=MobileData"
LoginData.RecentRole_URL = PlatformData.GetDnsUrl() .. "/kingapi?action=queryLoginname"
LoginData.GetUserIsOld_URL = PlatformData.GetDnsUrl() .. "/kingapi?action=old_user_query&loginname="
LoginData.isNeedDeEncrypConfig = true
LoginData.isEditor = true
LoginData.isShowDataReporting = false
LoginData.isShowLoginLog = true
local PlayerPrefs = CS.UnityEngine.PlayerPrefs

function LoginData.SetVariant(variantTable)
  variantTable:SetInt("addValue", this.addValue)
  variantTable:SetString("sign", this.sign)
  variantTable:SetString("userName", this.userName)
  variantTable:SetString("UserId", this.UserId)
  variantTable:SetInt("version", this.version)
  variantTable:SetString("sdkUserId", this.sdkUserId)
  variantTable:SetString("neckName", this.neckName)
  variantTable:SetString("token", this.token)
  variantTable:SetString("time", this.time)
  variantTable:SetInt("gid", this.gid)
  variantTable:SetInt("operId", this.operId)
  variantTable:SetInt("pId", this.pId)
  variantTable:SetString("loginExt", this.loginExt)
  variantTable:SetInt("isSdkLogging", this.isSdkLogging and 1 or 0)
  variantTable:SetInt("BanState", this.BanState and 1 or 0)
  variantTable:SetInt("isWhite", this.isWhite and 1 or 0)
  variantTable:SetInt("isClickComplete", this.isClickComplete and 1 or 0)
  variantTable:SetString("selfIp", this.selfIp)
  variantTable:SetInt("needReconnect", this.needReconnect and 1 or 0)
  variantTable:SetInt("needInviteCode", this.needInviteCode and 1 or 0)
  variantTable:SetString("sdk_pid", this.sdk_pid)
end

function LoginData.GetVariant(variantTable)
  this.addValue = variantTable:GetInt("addValue")
  this.sign = variantTable:GetString("sign")
  this.userName = variantTable:GetString("userName")
  this.UserId = variantTable:GetString("UserId")
  this.version = variantTable:GetInt("version")
  this.sdkUserId = variantTable:GetString("sdkUserId")
  this.neckName = variantTable:GetString("neckName")
  this.token = variantTable:GetString("token")
  this.time = variantTable:GetString("time")
  this.gid = variantTable:GetInt("gid")
  this.operId = variantTable:GetInt("operId")
  this.pId = variantTable:GetInt("pId")
  this.loginExt = variantTable:GetString("loginExt")
  this.isSdkLogging = variantTable:GetInt("isSdkLogging") == 1
  this.BanState = variantTable:GetInt("BanState") == 1
  this.isWhite = variantTable:GetInt("isWhite") == 1
  this.isClickComplete = variantTable:GetInt("isClickComplete") == 1
  this.selfIp = variantTable:GetString("selfIp")
  this.needReconnect = variantTable:GetInt("needReconnect") == 1
  this.needInviteCode = variantTable:GetInt("needInviteCode") == 1
  this.sdk_pid = variantTable:GetString("sdk_pid")
end

function LoginData.Init()
  this.roleList = {}
  this.userName = PlayerPrefs.GetString(this.USER_LAST_ACCOUNT, "")
  this.GetCreateTbl()
  LoginData.internalPId = CS.Main.instance.serverConfigId
end

function LoginData.InitOftenServer()
  this.oftenServers = {}
  local serversStr = PlayerPrefs.GetString(this.USER_OFTEN_SERVER, "")
  if not string.isNullOrEmpty(serversStr) then
    PlayerPrefs.SetString(LoginData.USER_OFTEN_SERVER, "")
    PlayerPrefs.SetString(LoginData.USER_OFTEN_SERVER .. LoginData.sdkUserId, serversStr)
    PlayerPrefs.Save()
  end
  serversStr = PlayerPrefs.GetString(this.USER_OFTEN_SERVER .. LoginData.sdkUserId, "")
  local idTbl = string.split(serversStr, "#")
  local realOftenIndex = 1
  for _, id in pairs(idTbl) do
    id = tonumber(id)
    local serverInfo = this.GetServer(id)
    if serverInfo ~= nil then
      table.insert(this.oftenServers, realOftenIndex, serverInfo[5])
      realOftenIndex = realOftenIndex + 1
    end
  end
end

function LoginData.ChangeOftenServer()
  if this.serverId == 0 then
    return
  end
  local preRecord = this.serverId
  for i = #this.oftenServers, 1, -1 do
    if preRecord == this.oftenServers[i] then
      table.remove(this.oftenServers, i)
    end
  end
  table.insert(this.oftenServers, 1, preRecord)
  while #this.oftenServers > this.oftenCount do
    table.remove(this.oftenServers, #this.oftenServers)
  end
  local serversStr = table.concat(this.oftenServers, "#")
  PlayerPrefs.SetString(LoginData.USER_OFTEN_SERVER .. LoginData.sdkUserId, serversStr)
  PlayerPrefs.Save()
end

function LoginData.GetUrlByNet()
  if this.externalNet then
    LoginData.isNeedDeEncrypConfig = true
    if CS.MuInterface.Instance:GetPid() == "monitor_test" then
      return "http://list.fgqj.douquy.com/serverlist/serverlist_1.txt"
    end
    local pid = CS.MuInterface.Instance:GetPid()
    return string.format(this.SERVER_URL_OUT, pid)
  else
    local pid = CS.Main.instance.serverConfigId
    if pid ~= nil and pid ~= 0 and pid ~= "" then
      this.SERVER_URL_INNER = string.format(this.SERVER_URL_OUT, pid)
      LoginData.isNeedDeEncrypConfig = true
    else
      LoginData.isNeedDeEncrypConfig = false
    end
    return this.SERVER_URL_INNER
  end
end

function LoginData.checkRegisterRoleCount()
  if this.externalNet and this.isSdk then
    local configJson = ""
    local istocheck = ""
    if CS.MuInterface.Instance.GetVersionConfig then
      configJson = CS.MuInterface.Instance:GetVersionConfig()
    end
    if not string.isNullOrEmpty(configJson) then
      local config = json.decode(configJson)
      if not string.isNullOrEmpty(config.checkroleUrl) then
        istocheck = config.checkroleUrl
      end
    end
    return istocheck
  else
    local pid = CS.Main.instance.serverConfigId
    if pid ~= nil and pid ~= 0 and pid ~= "" then
      return "http://gitip-qj2yn.muvh.vn"
    end
    return ""
  end
end

function LoginData.GetAnnouncementUrl()
  if this.externalNet then
    return string.format(this.Announcement_URL, CS.MuInterface.Instance:GetPid())
  elseif CS.Main.instance.serverConfigId ~= 0 then
    return string.format(this.Announcement_URL, tostring(CS.Main.instance.serverConfigId))
  else
    return string.format(this.Announcement_URL, "3001")
  end
end

function LoginData.GetAnnouncementData()
  return this.announcementData
end

function LoginData.SetServer(serverInfo)
  this.server = serverInfo
  this.serverId = serverInfo[5]
end

function LoginData.GetServer(id)
  for _, v in pairs(this.serverList) do
    if v[5] == id then
      return v
    end
  end
  return nil
end

function LoginData.GetXyServer(id)
  local info = this.xyServerList[this.xyServerListIndex]
  if info and info.serverList then
    for _, v in pairs(info.serverList) do
      if v[5] == id then
        return v
      end
    end
  end
  return nil
end

function LoginData.GetServerName()
  for _, v in pairs(this.serverList) do
    if v[5] == this.serverId then
      return v[1]
    end
  end
  return nil
end

function LoginData.InitRoleList(data)
  this.roleList = {}
  for _, roleInfo in pairs(data.roleList) do
    table.insert(this.roleList, roleInfo)
  end
  this.userId = data.userId
end

function LoginData.RecordRoleList(data)
  data = data or {}
  data.roleList = data.roleList or {}
  this.roleList = {}
  for _, roleInfo in pairs(data.roleList) do
    table.insert(this.roleList, roleInfo)
  end
end

function LoginData.AddRole(data)
  table.insert(this.roleList, data.role)
  this.userId = data.uid
end

function LoginData.RemoveOverdueRoleInfo(delRoleList)
  if delRoleList then
    for index = #delRoleList, 1, -1 do
      local roleInfo = delRoleList[index]
      if roleInfo.isDel then
        local overdueTime = TimeUtility.RefreshSec(TimeUtility.AddMin(roleInfo.delTime, 20))
        roleInfo.refreshSec = overdueTime
        if overdueTime == 0 then
          table.remove(delRoleList, index)
        end
      end
    end
  end
  return delRoleList
end

local function sort(a, b)
  return a[5] > b[5]
end

function LoginData.NorMalSetServerList(data)
  local result = {}
  for _, v in pairs(data) do
    if (v[3] ~= EServerState.Hidden or v[3] == EServerState.Hidden and LoginData.isWhite and LoginData.isClickComplete) and (not LoginData.IsHideOldPlayerServer(v[5]) or LoginData.isClickComplete) then
      table.insert(result, v)
    end
  end
  this.serverList = result
end

function LoginData.XySpecialSetServerList(data)
  this.AndroidServerList = {}
  this.BlendServerList = {}
  this.xyServerList = {}
  local result = {}
  for _, v in pairs(data) do
    if v[3] ~= EServerState.Hidden or v[3] == EServerState.Hidden and LoginData.isWhite and LoginData.isClickComplete then
      local serverId = tonumber(v[5])
      if serverId <= this.androidServerLimit then
        table.insert(this.AndroidServerList, v)
      elseif serverId > this.androidServerLimit and serverId < this.testSerVerListLimit then
        table.insert(this.BlendServerList, v)
      else
        table.insert(this.AndroidServerList, v)
        table.insert(this.BlendServerList, v)
      end
      if not LoginData.IsHideOldPlayerServer(v[5]) or LoginData.isClickComplete then
        table.insert(result, v)
      end
    end
  end
  if PlatformData.PlatformCheck("Android") then
  else
    this.isXyBlendApk = true
  end
  local haveAndroidServerListRole = false
  if RoleDeclareManager.GetAmountState then
    haveAndroidServerListRole = RoleDeclareManager.CheckHaveAndroidServerRole()
  end
  local androidList = {
    name = ClientTable.cfg_Text_ClientManager:GetDes(205),
    serverList = this.AndroidServerList
  }
  local blendList = {
    name = ClientTable.cfg_Text_ClientManager:GetDes(206),
    serverList = this.BlendServerList
  }
  if this.isXyBlendApk then
    this.showServerListCount = 1
    if haveAndroidServerListRole then
      this.showServerListCount = 2
    end
    if #this.BlendServerList <= 0 then
      if PlatformData.PlatformCheck("Android") then
        this.showServerListCount = 1
        table.insert(this.xyServerList, androidList)
      else
        local customServerInfo = {
          ClientTable.cfg_Text_ClientManager:GetDes(207),
          "s16006-ad-test.fgqj.app.xy.com",
          2,
          1,
          16006,
          0,
          0
        }
        table.insert(this.BlendServerList, customServerInfo)
        table.insert(result, customServerInfo)
        if this.showServerListCount == 1 then
          table.insert(this.xyServerList, blendList)
        else
          table.insert(this.xyServerList, blendList)
          table.insert(this.xyServerList, androidList)
        end
      end
    elseif this.showServerListCount == 1 then
      table.insert(this.xyServerList, blendList)
    else
      table.insert(this.xyServerList, blendList)
      table.insert(this.xyServerList, androidList)
    end
  else
    if #this.BlendServerList <= 0 then
      this.showServerListCount = 1
    else
      this.showServerListCount = 2
    end
    table.insert(this.xyServerList, androidList)
    if this.showServerListCount == 2 then
      table.insert(this.xyServerList, blendList)
    end
  end
  this.serverList = result
end

function LoginData.SetServerList(data)
  if this.OperEnum[this.operId] == "xy" then
    this.XySpecialSetServerList(data)
  else
    this.NorMalSetServerList(data)
  end
end

function LoginData.SwitchServerList(index)
  if index == this.xyServerListIndex then
    return
  end
  this.xyServerListIndex = index
  LoginData.serverGroupIndex = 1
  LoginData.InitOftenServer()
  local defaultServer = LoginData.oftenServers[1] and LoginData.GetServer(LoginData.oftenServers[1]) or LoginData.GetDefaultRecommend()
  LoginData.SetServer(defaultServer)
  LoginData.SortOutServerList()
end

function LoginData.SetServiceRecommend(data)
  this.recommend = data
end

function LoginData.GetDefaultRecommend()
  if this.recommend then
    local recommendCount = table.count(this.recommend)
    if 0 < recommendCount then
      local serverId = Mathf.RandomTableValue(this.recommend)
      for _, v in pairs(LoginData.serverList) do
        if v[5] == serverId then
          return v
        end
      end
    end
  end
  return LoginData.serverList[1]
end

function LoginData.SetEquipmentList(data)
  this.equipmentList = data
end

function LoginData.SortOutServerList()
  this.serverGroup = {}
  local showServerList = this.serverList
  if this.OperEnum[this.operId] == "xy" and this.xyServerList[this.xyServerListIndex] then
    showServerList = this.xyServerList[this.xyServerListIndex].serverList
  end
  if this.CheckGroupRule() then
    local temp = string.split(LoginData.serverGroupNameList, "&")
    if temp ~= nil then
      for i, v in pairs(temp) do
        local namedic = string.split(v, "#")
        if namedic ~= nil and #namedic == 3 then
          local serverdatastr = string.split(namedic[3], "-")
          if #serverdatastr == 2 then
            local startnum = tonumber(serverdatastr[1])
            local endnum = tonumber(serverdatastr[2])
            for j = 1, #showServerList do
              local server = showServerList[j]
              if server and server[5] then
                local serverId = tonumber(server[5])
                if startnum <= serverId and endnum >= serverId then
                  this.serverGroup[i] = this.serverGroup[i] or {index = i}
                  this.serverGroup[i].servers = this.serverGroup[i].servers or {}
                  if server ~= nil then
                    table.insert(this.serverGroup[i].servers, server)
                  end
                end
              end
            end
          end
        end
      end
    end
  else
    local sc = #showServerList
    local groupCount = Mathf.Floor(sc / this.groupRuler) + (sc % this.groupRuler ~= 0 and 1 or 0)
    for gIndex = 1, groupCount do
      for i = 1, this.groupRuler do
        local sIndex = (gIndex - 1) * this.groupRuler + i
        this.serverGroup[gIndex] = this.serverGroup[gIndex] or {index = gIndex}
        this.serverGroup[gIndex].servers = this.serverGroup[gIndex].servers or {}
        local server = showServerList[sIndex]
        if server ~= nil then
          table.insert(this.serverGroup[gIndex].servers, server)
        end
      end
    end
  end
  this.serverGroup = table.ReverseTable(this.serverGroup)
  for _, groupTbl in ipairs(this.serverGroup) do
    table.sort(groupTbl.servers, sort)
  end
  local serverTbl = {}
  for _, id in pairs(this.oftenServers) do
    if this.OperEnum[this.operId] == "xy" then
      table.insert(serverTbl, this.GetXyServer(id))
    else
      table.insert(serverTbl, this.GetServer(id))
    end
  end
  local oftenServerList = {index = -1, servers = serverTbl}
  if 0 < table.count(serverTbl) then
    table.insert(this.serverGroup, 1, oftenServerList)
  end
end

function LoginData.CheckGroupRule(id)
  local isshow = true
  if not string.isNullOrEmpty(LoginData.serverGroupNameList) then
    local temp = string.split(LoginData.serverGroupNameList, "&")
    if temp ~= nil then
      for i, v in pairs(temp) do
        local namedic = string.split(v, "#")
        if namedic ~= nil and #namedic == 3 then
          local serverdatastr = string.split(namedic[3], "-")
          if #serverdatastr == 2 then
            local startnum = tonumber(serverdatastr[1])
            local endnum = tonumber(serverdatastr[2])
            if startnum == nil or endnum == nil then
              return false
            end
          else
            return false
          end
        else
          return false
        end
      end
    end
  else
    return false
  end
  return isshow
end

function LoginData.TimeAcrossDay()
  LoginData.createPlayerID = 0
end

LoginData.createPlayerID = 0

function LoginData.GetCreatePlayerDay()
  local curTime = Time.GetServerTime()
  if LoginData.createPlayerID == 0 or LoginData.createPlayerID ~= ViewData.meData.id then
    LoginData.createPlayerID = ViewData.meData.id
    this.createPlayerDay = TimeUtility.DayApartFromTwoTime(Time.GetServerTime(), this.createTime * 1000) + 1
    LoginData.createPlayerDayTime = TimeUtility.GetDayTimeStamp(curTime + 86400)
  end
  return this.createPlayerDay
end

function LoginData.GetCreateTbl()
  local configTbl = ClientTable.cfg_Character_createManager:GetDic()
  for id, info in pairs(configTbl) do
    if info.isShow == 1 then
      this.createRoleTbl[id] = info
    end
  end
end

function LoginData.GetseverGotoState()
  local data = PlatformData.GetVersionConfig()
  if data and data.Logindata then
    if data.Logindata == 1 then
      return 1
    elseif data.Logindata == 2 then
      return 2
    end
  end
  return 1
end

function LoginData.InitSpellSwordData()
  this.spellSwordRechargeData = ConfigManager.FindConfigs("cfg_Recharge_recharge", "type", 19)[1]
  local globalData = ClientTable.cfg_Global_globalManager:TryGetValue(2700001).effect
  if globalData then
    if string.contains(globalData, "&") then
      for i, v in pairs(string.split(globalData, "&")) do
        local careerStr = string.split(v, "#")
        if this.careerCreateLevel[tonumber(careerStr[1])] == nil then
          this.careerCreateLevel[tonumber(careerStr[1])] = tonumber(careerStr[2])
        end
      end
    else
      local careerStr = string.split(globalData, "#")
      if this.careerCreateLevel[tonumber(careerStr[1])] == nil then
        this.careerCreateLevel[tonumber(careerStr[1])] = tonumber(careerStr[2])
      end
    end
  end
end

function LoginData.ReSet()
  this.roleList = {}
end

function LoginData.LogoutAccount()
  if this.isSdk and this.isSdkLogging then
    this.isSdkLogging = true
    this.loginType = ""
    CS.MuInterface.Instance:LogoutAccount()
  end
end

function LoginData.GetFirstIdKey()
  return this.USER_FIRST_LOGIN .. this.userId
end

LoginData.nextCalcTime = 0

function LoginData.GetOpenServerDay()
  local curTime = Time.GetServerTime()
  if curTime > LoginData.nextCalcTime then
    this.openServerDay = TimeUtility.DayApartFromTwoTime(Time.GetServerTime(), this.openServerTime) + 1
    LoginData.nextCalcTime = TimeUtility.GetDayTimeStamp(curTime + 86400)
  end
  return this.openServerDay
end

function LoginData.GetPid()
  return LoginData.externalNet and LoginData.pId or LoginData.internalPId
end

LoginData.Init()
LoginData.roleInitPos = {
  {
    x = -3.4,
    y = -1.6,
    z = -2.8
  },
  {
    x = -1.1,
    y = -1.6,
    z = -2.8
  },
  {
    x = 1.2,
    y = -1.6,
    z = -2.8
  },
  {
    x = 3.5,
    y = -1.6,
    z = -2.8
  }
}

function LoginData.AddOutTestList()
  LoginData.serverList = {}
  local tbl = {
    [1] = ClientTable.cfg_Text_ClientManager:GetDes(208),
    [2] = "139.224.13.163",
    [3] = 2,
    [4] = 1400,
    [5] = 867,
    [6] = 1
  }
  table.insert(LoginData.serverList, tbl)
  local tbl = {
    [1] = ClientTable.cfg_Text_ClientManager:GetDes(209),
    [2] = "124.71.171.8",
    [3] = 2,
    [4] = 1200,
    [5] = 1,
    [6] = 1
  }
  table.insert(LoginData.serverList, tbl)
end

function LoginData.LoginLog(str)
  if LoginData.isShowLoginLog == false then
    return
  end
  CS.UnityEngine.Debug.Log(str)
end

function LoginData.DataReportingLog(data)
  if LoginData.isShowDataReporting == false then
    return
  end
  if data == nil then
    return
  end
  local str = ""
  for i, v in pairs(data) do
    if v ~= nil then
      str = str .. " " .. tostring(v)
    end
  end
  CS.UnityEngine.Debug.Log(str)
end

function LoginData.IsHideOldPlayerServer(serverID)
  if LoginData.Isold_user == false then
    return false
  end
  if LoginData.Server_old_user == nil then
    return false
  end
  local strs = string.split(tostring(LoginData.Server_old_user), "#")
  if #strs ~= 2 then
    return false
  end
  if strs[1] == "2" and serverID == tonumber(strs[2]) then
    return true
  end
  return false
end

function LoginData.SetServerGroupName(nameList)
  LoginData.serverGroupNameDic = {}
  if nameList == nil or nameList == "" then
    return
  end
  LoginData.serverGroupNameList = nameList
  local temp = string.split(nameList, "&")
  if temp ~= nil then
    for i, v in pairs(temp) do
      local namedic = string.split(v, "#")
      if namedic ~= nil and 2 <= #namedic then
        LoginData.serverGroupNameDic[tonumber(namedic[1])] = namedic[2]
      end
    end
  end
end

function LoginData.GetServerGroupName(groupID)
  if (groupID == nil or groupID == -1 or LoginData.serverGroupNameDic == nil or LoginData.serverGroupNameDic[groupID] == nil or this.CheckGroupRule() == false) and (LoginData.serverGroupNameDef == nil or LoginData.serverGroupNameDef == "") then
    return LocalizationUtility.GetContentByKey("ServerGroup_2") .. groupID
  end
  return LoginData.serverGroupNameDic[groupID]
end

function LoginData.GetServerGroupIndex(groupID)
  if groupID == nil then
    return ""
  end
  local nowIndex = tonumber(groupID)
  if nowIndex == nil then
    return ""
  end
  local nowShow = (nowIndex - 1) * 999 + 1
  local nextShow = nowIndex * 999
  return nowShow .. "-" .. nextShow .. ClientTable.cfg_Text_ClientManager:GetDes(210)
end

function LoginData.JudgeCanEstablishSpellSwordId()
  if table.count(this.roleList) == 0 then
    return false
  end
  for index, roleData in pairs(this.roleList) do
    if roleData.info.level >= this.careerCreateLevel[14] or roleData.info.career == ERoleCareer.SpellSword then
      return true
    end
  end
  return false
end
