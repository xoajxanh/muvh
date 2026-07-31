require("GameModel/LoginData")
LoginController = {}
local PlayerPrefs = CS.UnityEngine.PlayerPrefs
local this = LoginController

function LoginController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.EnterLogin()
  this.logingame = true
end

function LoginController.EnterLogin()
  this.RegistMessages()
end

function LoginController.LeaveLogin()
  this.messageContainer:UnRegistAll()
  EventManager.UnRegist(Event.Load_PreLoadEnd, this.OnLoadPreLoadEnd)
  EventManager.UnRegist(Event.Load_PreLoadEndOneJionGame, this.onLoad_PreLoadEndOneJionGame)
  EventManager.UnRegist(Event.Korea_SDKINITSDK, this.SDK_InitCallback)
  EventManager.UnRegist(Event.KoraeSDKKick_CALLBACK, this.KoraeSDKKick_CALLBACK)
  EventManager.UnRegist(Event.KoraeSDKMaintain_CALLBACK, this.KoraeSDKMaintain_CALLBACK)
  EventManager.UnRegist(Event.SDK_MAINTENANCE_MOCAA_MAINTENANCE, this.SDK_MAINTENANCE_MOCAA_MAINTENANCE)
  EventManager.UnRegist(Event.KoraeSDKSanction_CALLBACK, this.KoraeSDKSanction_CALLBACK)
  EventManager.Regist(Event.KoraeSDKMaintainCloseTip_CALLBACK, this.KoraeSDKMaintainCloseTip_CALLBACK)
  EventManager.UnRegist(Event.KoreaSDKClienAirbrigeAndFirebase, this.OnResFirstEvent)
end

function LoginController.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLoginUser, this.OnResLoginUser)
  this.messageContainer:Regist(UserMessage.ResEnterGame, this.OnResEnterGame)
  this.messageContainer:Regist(UserMessage.ResRandomName, this.OnResRandomName)
  this.messageContainer:Regist(UserMessage.ResLogout, this.OnResLogout)
  this.messageContainer:Regist(UserMessage.ResGetRoleList, this.OnResGetRoleList)
  this.messageContainer:Regist(UserMessage.ResDeleteRole, this.OnRefreshRole)
  this.messageContainer:Regist(UserMessage.ResCreateRole, this.OnCreateRole)
  this.messageContainer:Regist(UserMessage.ResInputInviteCode, this.ResInputInviteCode)
  this.messageContainer:Regist(CommonMessage.ResCloseServerToClientRole, this.OnResCloseServerToClientRole)
  this.messageContainer:Regist(RoleMessage.ResBanRoleLogout, this.OnBanRoleLogout)
  this.messageContainer:Regist(RoleMessage.ResRoleActive, this.OnResRoleActive)
  this.messageContainer:Regist(RoleMessage.ResFirstEvent, this.OnResFirstEvent)
  this.messageContainer:Regist(RoleMessage.ResPushEvent, this.OnResPushEvent)
  EventManager.Regist(Event.Load_PreLoadEnd, this.OnLoadPreLoadEnd)
  EventManager.Regist(Event.Load_PreLoadEndOneJionGame, this.onLoad_PreLoadEndOneJionGame)
  EventManager.Regist(Event.Korea_SDKINITSDK, this.SDK_InitCallback)
  EventManager.Regist(Event.KoraeSDKKick_CALLBACK, this.KoraeSDKKick_CALLBACK)
  EventManager.Regist(Event.KoraeSDKMaintain_CALLBACK, this.KoraeSDKMaintain_CALLBACK)
  EventManager.Regist(Event.SDK_MAINTENANCE_MOCAA_MAINTENANCE, this.SDK_MAINTENANCE_MOCAA_MAINTENANCE)
  EventManager.Regist(Event.KoraeSDKSanction_CALLBACK, this.KoraeSDKSanction_CALLBACK)
  EventManager.Regist(Event.KoraeSDKMaintainCloseTip_CALLBACK, this.KoraeSDKMaintainCloseTip_CALLBACK)
  EventManager.Regist(Event.SDK_KOREAPAY_USERCANCEL_CALLBACK, this.SDK_KOREAPAY_USERCANCEL_CALLBACK)
  EventManager.Regist(Event.KoreaSDKClienAirbrigeAndFirebase, this.OnResFirstEvent)
  EventManager.Regist(Event.HttpOutReport, this.OnHttpOutReport)
end

function LoginController.OnHttpOutReport(_, data)
  local state = PlatformData.GetHttpLogState()
  if 1 == tonumber(state) then
    CS.UnityEngine.Debug.Log("----http---" .. Time.time .. "----" .. data)
  end
end

function LoginController.KoraeSDKMaintain_CALLBACK(_, data)
  LoginData.LogoutAccount()
  NetManager.Send(UserMessage.ReqLogout, {
    reason = ELogoutType.LogOut
  })
  gameMgr:GetAvatarManager():RemoveAllAvatar()
end

function LoginController.SDK_MAINTENANCE_MOCAA_MAINTENANCE(_, data)
end

function LoginController.onLoad_PreLoadEndOneJionGame()
  this.logingame = true
end

function LoginController.KoraeSDKMaintainCloseTip_CALLBACK(_, data)
  if UIManager.IsVisible(UIID.PromptTipUI) then
    UIManager.Hide(UIID.PromptTipUI)
  end
end

function LoginController.KoraeSDKSanction_CALLBACK(_, data)
  local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(43)
  if data then
    UIManager.Show(UIID.PromptTipUI, {
      title = data.title,
      autoClose = false,
      textContent = data.content,
      okText = data.rightButton,
      isframe = true,
      ok = function()
        local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000002)
        if name then
          CS.MuInterface.Instance:OnWebviewClick(name)
        end
      end
    })
  end
end

function LoginController.SDK_KOREAPAY_USERCANCEL_CALLBACK(_, data)
  local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(53)
  if data then
    UIManager.Show(UIID.PromptTipUI, {
      title = data.title,
      autoClose = false,
      textContent = data.content,
      okText = data.rightButton,
      isframe = true,
      ok = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
  end
end

function LoginController.KoraeSDKKick_CALLBACK(_, data)
  local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(44)
  if data then
    UIManager.Show(UIID.PromptTipUI, {
      title = data.title,
      autoClose = false,
      textContent = data.content,
      okText = data.rightButton,
      isframe = true,
      ok = function()
        local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000002)
        if name then
          CS.MuInterface.Instance:OnWebviewClick(name)
        end
      end
    })
  end
end

function LoginController.SDK_InitCallback(_, data)
  if data then
    UIManager.Show(UIID.WaitingUI, {msg = ""})
  elseif UIManager.IsVisible(UIID.WaitingUI) then
    UIManager.Hide(UIID.WaitingUI)
  end
end

function LoginController:OnLoadPreLoadEnd()
  if PlatformData.PlatformCheck(PlatformNameEnum.UNITY_STANDALONE_WIN) then
    return
  end
  if this.logingame then
    local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000008)
    if name then
      CS.MuInterface.Instance:OnWebviewClick(name)
    end
    EventManager.Dispatch(Event.KoreaSDKClienAirbrigeAndFirebase, {
      type = KoreaSDKEnum.web_view,
      param = "",
      reason = "",
      node = KoreaSDKNodeEnum.firebase
    })
  end
  networkRequest.ReqReissue(LoginData.service_code, 1)
  this.logingame = false
end

function LoginController.OnCreateRole(_, msg)
  LoginData.roleId = msg.role.info.roleId
  LoginData.roleName = msg.role.info.name
  LoginData.roleLevel = msg.role.info.level
  LoginData.createTime = msg.role.info.createTime
  LoginData.AddRole(msg)
  EventManager.Dispatch(Event.Login_CreateRole)
  ActionStepsLogManager.SetRoleAction(ActionStepsType.CreateRoleSuccess)
end

function LoginController.OnRefreshRole(_, msg)
  LoginData.RecordRoleList(msg)
  EventManager.Dispatch(Event.Login_RefreshRoleList)
end

function LoginController.OnResGetRoleList(_, msg)
  LogManager.AddLoginLog("ReqGetRoleList_End ", "Login")
  LoginData.InitRoleList(msg)
  if not LoginData.roleList or #LoginData.roleList == 0 then
    Scene.OnEnterCreateRole()
  else
    Scene.OnEnterRole()
  end
  EventManager.Dispatch(Event.Login_ResGetRoleList)
  EventManager.Dispatch(Event.Role_EquipAppearSave, msg)
end

function LoginController.OnResLoginUser(_, msg)
  LogManager.AddLoginLog("ResLogin_End ", "Login")
  LoginData.openServerTime = msg.openServerTime
  LoginData.combineServerTime = msg.combineServerTime
  LoginData.needInviteCode = msg.needInviteCode
  LoginData.openServerDay = TimeUtility.DayApartFromTwoTime(msg.serverCurTime, msg.openServerTime) + 1
  Time.SetServerTime(msg.serverCurTime)
  TimeUtility.SetTimeZones(msg.zoneOffset)
  EventManager.Dispatch(Event.Login_ConnectSuccess)
end

function LoginController.ResInputInviteCode(_, msg)
  LoginData.needInviteCode = msg.needInviteCode
  EventManager.Dispatch(Event.UpdateInviteCodeState)
end

local function ResetRoleInfo()
  BagInfoData.BagReSet()
  BagInfoData.StorageReSet()
  BagInfoData.PandoraReSet()
  AuctionData.AuctionDataReSet()
  SceneData.ResetData()
  ExpAddData.ResetData()
end

function LoginController.OnResCloseServerToClientRole(_, msg)
  logPurple("M\195\161y ch\225\187\167 b\225\186\175t \196\145\225\186\167u b\225\186\163o tr\195\172")
  LoginData.InGame = false
  LoginData.needReconnect = false
  EventManager.Dispatch(Event.GamePlay_Leave)
  NetManager.Close()
end

function LoginController.OnResLogout(_, msg)
  LoginData.InGame = false
  ResetRoleInfo()
  if msg.reason == ELogoutType.LogOut then
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
  elseif msg.reason == ELogoutType.BackToChoose then
    EventManager.Dispatch(Event.GamePlay_Back2Choose)
  elseif msg.reason == ELogoutType.Maintain then
    logPurple("M\195\161y ch\225\187\167 b\225\186\175t \196\145\225\186\167u b\225\186\163o tr\195\172")
    LoginData.needReconnect = false
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
  elseif msg.reason == ELogoutType.AnotherSession then
    LoginData.LogoutAccount()
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(49)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = data.content,
        okText = data.rightButton,
        isframe = true,
        ok = function()
          UIManager.Hide(UIID.PromptTipUI)
        end
      })
    end
    if LoginData.pId == 35 then
      LoginData.LogoutAccount()
      ActionStepsLogManager.SetRoleAction(ActionStepsType.LogOut)
      LoginData.panelState = 1
    end
  else
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
  end
end

function LoginController.OnBanRoleLogout(_, msg)
  LoginData.BanState = true
  if msg.reason == ELogoutType.Block then
    LoginData.LogoutAccount()
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(43)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = data.content,
        okText = data.rightButton,
        isframe = true,
        ok = function()
          local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000002)
          if name then
            CS.MuInterface.Instance:OnWebviewClick(name)
          end
        end
      })
    end
  else
    EventManager.Dispatch(Event.GamePlay_Leave)
    NetManager.Close()
  end
  LoginData.InGame = false
end

function LoginController.OnResRandomName(id, msg)
  LoginData.resRandomName = msg.roleName
  EventManager.Dispatch(Event.Login_CreateRandomName)
end

function LoginController.OnResEnterGame(id, msg)
  LogManager.AddLoginLog("ResChooseRole End", "Login")
  DataToCSharpMgr.SubmitGameData(ESubmitDataType.TYPE_ENTER_GAME)
  LoginData.InGame = true
  LoginData.roleId = msg.uid
  EventManager.Dispatch(Event.GamePlay_Enter)
  Time.SetServerTime(msg.serverTime)
  ForgeData.isFirstEnterGame = true
  LockScreenState = false
  local resolution = Screen.width .. "x" .. Screen.height
  NetManager.Send(CommonMessage.ReqResolution, {resolution = resolution})
end

function LoginController.OnResRoleActive(id, msg)
  if msg ~= nil and ViewData.meData and ViewData.meData.id == msg.roleId then
    UIManager.Show(UIID.Zhuanzhi_TIpsUI, {
      type = msg.type
    })
  end
end

function LoginController.OnResPushEvent(id, msg)
  if msg then
    if msg.appsflyer ~= "" then
      CS.MuInterface.Instance:OnAppsFlyerEvent(msg.appsflyer)
    end
    if msg.firebase ~= "" then
      CS.MuInterface.Instance:OnFireBaseSDKLogEventReportedData(msg.firebase)
    end
    if msg.facebook ~= "" then
      CS.MuInterface.Instance:OnFaceBookEvent(msg.facebook)
    end
  end
end

function LoginController.OnResFirstEvent(id, msg)
  if msg ~= nil then
    local str = ""
    if msg.node == 1 then
      if msg.type == 1 then
        str = "first_purchase"
      elseif msg.type == 2 then
        str = "first_main_quest_clear"
      elseif msg.type == 3 then
        str = "first_skill_acquisition"
      elseif msg.type == 4 then
        str = "use_selling_function"
      elseif msg.type == 5 then
        str = "use_benefits_card"
      elseif msg.type == 6 then
        str = "first_equipment_engancement"
      elseif msg.type == 7 then
        str = "equip_a_fluorescent stone"
      elseif msg.type == 8 then
        str = "first_field_boss_battle"
      elseif msg.type == 9 then
        str = "first_devil_square_clear"
      elseif msg.type == 10 then
        str = "first_blood_castle_clear"
      elseif msg.type == 11 then
        str = "get_hero_quest"
      elseif msg.type == 12 then
        str = "level_" .. tostring(msg.param)
        if tonumber(msg.param) >= 4400 then
          str = "over_level"
        end
        if tonumber(msg.param) == 30 then
          str = "level_120"
        end
        if tonumber(msg.param) == 120 then
          str = "level_30"
        end
      elseif msg.type == 13 then
        str = "login_game_unique"
      elseif msg.type == 14 then
        str = "daily_quest_20_point"
      elseif msg.type == 15 then
        str = "daily_free_sales"
      elseif msg.type == 16 then
        str = "get_1_star_bosses_reward"
      elseif msg.type == 17 then
        str = "over_diamond"
      elseif msg.type == KoreaSDKEnum.airbridgeachieveLevel then
        str = "airbridge.achieveLevel"
      elseif msg.type == KoreaSDKEnum.additional_download_complete then
        str = "additional_download_complete"
      elseif msg.type == KoreaSDKEnum.login_game then
        str = "login_game"
      elseif msg.type == KoreaSDKEnum.character_creation then
        str = "character_creation"
      elseif msg.type == KoreaSDKEnum.entering_in_game then
        str = "entering_in_game"
      elseif msg.type == KoreaSDKEnum.server_choice then
        str = "server_choice"
      end
    elseif msg.node == 2 and not PlatformData.PlatformCheck(PlatformNameEnum.UNITY_STANDALONE_WIN) then
      if msg.type == 12 then
        str = "level_" .. tostring(msg.param)
      elseif msg.type == KoreaSDKEnum.web_view then
        str = "web_view"
      elseif msg.type == KoreaSDKEnum.store_click then
        str = "store_click"
      elseif msg.type == KoreaSDKEnum.redstore_click then
        str = "redstore_click"
      end
    end
    EventManager.Dispatch(Event.KoreaSDKLog_CALLBACK, "D\225\187\175 li\225\187\135u tracking" .. tostring(msg.node) .. ":" .. str)
  end
end

function LoginController.GetIsAgreePrivacyPolicy()
  return PlayerPrefs.GetInt("IsAgreePrivacyPolicy", 0) >= 1
end

function LoginController.SetIsAgreePrivacyPolicy(agree)
  if agree then
    PlayerPrefs.SetInt("IsAgreePrivacyPolicy", 1)
  else
    PlayerPrefs.SetInt("IsAgreePrivacyPolicy", 0)
  end
end

function LoginController.AccountCancellation()
  DataToCSharpMgr.AccountCancellation(ESubmitDataType.TYPE_AccountCancellation)
end

function LoginController.CallSDKUserAgreement()
  CS.MuInterface.Instance:CallSDKUserAgreement()
end

function LoginController.PlatformDataJudge(pName)
  if string.isNullOrEmpty(pName) then
    return false
  end
  if LoginData.opName == pName then
    return true
  end
  return false
end

LoginController.Init()
