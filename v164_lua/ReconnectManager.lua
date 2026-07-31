ReconnectManager = {}
local this = ReconnectManager
this.autoClose = nil
this.autoReconnect = nil

function ReconnectManager.Init()
  this.InitEvents()
end

function ReconnectManager.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Net_Disconnect, this.OnDisconnect)
  this.eventContainer:Regist(Event.Net_ConnectSuccess, this.OnConnected)
  this.eventContainer:Regist(Event.Login_ConnectSuccess, this.OnResLoginMessage)
end

function ReconnectManager.OnConnect()
  if LoginData.server[3] == EServerState.Defend and (not LoginData.isWhite or not LoginData.isClickComplete) then
    TipUtility.ShowPP("Server \196\145ang b\225\186\163o tr\195\172")
    UIManager.Hide(UIID.WaitingUI)
    CS.LauncherUI.Close()
    return
  end
  local host = LoginData.server[2]
  local port = LoginData.server[4] + LoginData.addValue
  print("host:", host, "port:", port)
  NetManager.Connect(host, port)
end

function ReconnectManager.Connect()
  this.OnConnect()
  UIManager.Show(UIID.WaitingUI, {
    msg = "\196\144ang k\225\186\191t n\225\187\145i l\225\186\161i do m\225\186\165t m\225\186\161ng"
  })
end

function ReconnectManager.OnConnected()
  if LoginData.userName == nil then
    CS.LauncherUI.Close()
    logOrange("LoginData.userName is nil....")
    return
  end
  if LoginData.equipmentList ~= nil and not table.contains(LoginData.equipmentList, CS.UnityEngine.SystemInfo.deviceUniqueIdentifier) then
    CS.LauncherUI.Close()
    logError("can't enter game.")
    return
  end
  local loginName = LoginData.userName:gsub(CS.System.Environment.NewLine, "")
  LogManager.AddLoginLog("ReqLogin_Begin ", "Login")
  networkRequest.ReqLogin(loginName, LoginData.version, LoginData.time, LoginData.sign, LoginData.reconnectState and 1 or 0, LoginData.serverId, CS.UnityEngine.SystemInfo.deviceUniqueIdentifier)
  if this.autoClose then
    Timer.Stop(this.autoClose)
    this.autoClose = nil
  end
  if this.autoReconnect then
    Timer.Stop(this.autoReconnect)
    this.autoReconnect = nil
  end
end

function ReconnectManager.OnResLoginMessage()
  if not LoginData.reconnectState then
    return
  end
  if LoginData.roleId == 0 then
    return
  end
  this.HandleOthersManagerInReconnectState()
  NetManager.Send(UserMessage.ReqChooseRole, {
    roleId = LoginData.roleId
  })
end

function ReconnectManager.StartCloseReconnectTimer()
  if this.autoClose then
    return
  end
  local autoTime = 5000
  autoTime = autoTime / 1000 * 5
  this.autoClose = Timer.Start(autoTime, function()
    logPurple("M\225\186\165t k\225\186\191t n\225\187\145i")
    this.autoClose = nil
    this.autoReconnect = nil
    UIManager.Hide(UIID.WaitingUI)
    LoginData.reconnectState = false
    if LoginData.isSdk then
      LoginData.LogoutAccount()
    else
      NetManager.Close()
      EventManager.Dispatch(Event.GamePlay_Leave)
      gameMgr:Logout()
    end
  end)
end

function ReconnectManager.StartTimesReconnectTimer()
  if this.autoReconnect then
    return
  end
  local autoTime = 5000
  autoTime = autoTime / 1000
  this.autoReconnect = Timer.StartLoop(autoTime, 4, function()
    logPurple("K\225\186\191t n\225\187\145i l\225\186\161i")
    this.Connect()
  end)
end

function ReconnectManager.OnDisconnect()
  if not LoginData.needReconnect then
    LoginData.needReconnect = true
    return
  end
  if LoginData.InGame then
    LoginData.reconnectState = true
    EventManager.Dispatch(Event.GamePlay_Reconnect)
    this.Connect()
    logPurple("K\225\186\191t n\225\187\145i l\225\186\161i")
    this.StartTimesReconnectTimer()
    this.StartCloseReconnectTimer()
  else
    EventManager.Dispatch(Event.GamePlay_Leave)
  end
end

function ReconnectManager.ShowReconnectTips()
  UIManager.Show(UIID.PromptTipUI, {
    title = "",
    textContent = string.format("K\225\186\191t n\225\187\145i l\225\186\161i qu\195\161 gi\225\187\157, k\225\186\191t n\225\187\145i l\225\186\161i?"),
    cancelText = "Kh\195\180ng",
    okText = "C\195\179",
    cancel = function()
      LoginData.reconnectState = false
      EventManager.Dispatch(Event.GamePlay_Leave)
    end,
    ok = function()
      this.OnDisconnect()
    end
  })
end

function ReconnectManager.HandleOthersManagerInReconnectState()
  ViewData.Clear()
  TeamData.Reset()
  BuffMgr.RemoveAllBuff()
  RoleManager.DestroyRolesInReconnectState()
  ActivityManager.UnRegistAll()
  RedNameManager.UnRegistAll()
  SceneController.OnLeaveGame()
  DropItemManager.OnLeaveGame()
  BlockBuildManager.OnLeaveGame()
  TrapManager.OnLeaveGame()
  TransManager.OnLeaveGame()
  GraveManager.OnLeaveGame()
  PickupManager.OnLeaveGame()
  MapEffectManager.UnRegistAll()
  DynamicTerrainController.ResetReconnect()
  SceneGrassEffectManager.OnLeaveGame()
  VipManager.OnLeaveGame()
  DataToCSharpMgr.UnRegistMessages()
  AutoPopUIManager.UnRegistAll()
end

this.Init()
