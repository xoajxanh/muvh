Login_LoginUI = class(BaseUI)
Login_LoginUI.layer = UILayer.Panel
Login_LoginUI.orderInLayer = 0
Login_LoginUI.hideType = UIHideType.Hide
Login_LoginUI.hideFunc = UIHideFunc.MoveOutOfScreen
Login_LoginUI.escClose = UIEscClose.DontClose

function Login_LoginUI:InitControls()
  self.Img_logo_1 = self:GetControl("Img_logo/Img_logo_1")
  self.tip2 = self:GetControl("gameTip/tip2")
  self.btn_back = self:GetControl("btn_back")
  self.btn_UserDelete = self:GetControl("btn_UserDelete")
  self.btn_notice = self:GetControl("btn_notice")
  self.btn_agreement = self:GetControl("btn_agreement")
  self.btn_loginSdk = self:GetControl("btn_loginSdk")
  self.tog_PrivacyPolicy = self:GetControl("tog_PrivacyPolicy")
  self.go_selectServer = self:GetControl("go_selectServer")
  self.btn_android = self:GetControl("go_selectServer/go_serverList/btn_android")
  self.go_serverGroup = self:GetControl("go_selectServer/go_serverGroup")
  self.btn_serverGroup = self:GetControl("go_selectServer/go_serverGroup/Viewport/Content/btn_serverGroup")
  self.btn_serverInfo = self:GetControl("go_selectServer/sv_selectServers/Viewport/Content/btn_serverInfo")
  self.btn_clickWhite = self:GetControl("go_selectServer/serverStateGroup/ico_state3/btn_clickWhite")
  self.btn_closeSelectServer = self:GetControl("go_selectServer/btn_closeSelectServer")
  self.go_LoginInput = self:GetControl("go_LoginInput")
  self.btn_close = self:GetControl("go_LoginInput/btn_close")
  self.btn_ok = self:GetControl("go_LoginInput/btn_ok")
  self.lab_ok = self:GetControl("go_LoginInput/btn_ok/lab_ok")
  self.btn_phoneLogin = self:GetControl("go_LoginInput/btn_phoneLogin")
  self.lab_phoneLogin = self:GetControl("go_LoginInput/btn_phoneLogin/lab_phoneLogin")
  self.Input_Account = self:GetControl("go_LoginInput/go_Account/Input_Account")
  self.Input_Password = self:GetControl("go_LoginInput/go_Password/Input_Password")
  self.go_phoneLogin = self:GetControl("go_LoginInput/go_phoneLogin")
  self.btn_fastGame = self:GetControl("go_LoginInput/go_phoneLogin/btn_fastGame")
  self.lab_fastGame = self:GetControl("go_LoginInput/go_phoneLogin/btn_fastGame/lab_fastGame")
  self.btn_next = self:GetControl("go_LoginInput/go_phoneLogin/btn_next")
  self.go_accountLogin = self:GetControl("go_LoginInput/go_accountLogin")
  self.btn_accountLogin = self:GetControl("go_LoginInput/go_accountLogin/btn_accountLogin")
  self.lab_accountLogin = self:GetControl("go_LoginInput/go_accountLogin/btn_accountLogin/lab_accountLogin")
  self.btn_Login = self:GetControl("go_LoginInput/go_accountLogin/btn_Login")
  self.lab_Login = self:GetControl("go_LoginInput/go_accountLogin/btn_Login/lab_Login")
  self.sv_loginInfo = self:GetControl("go_LoginInput/go_accountLogin/sv_loginInfo")
  self.go_info = self:GetControl("go_LoginInput/go_accountLogin/sv_loginInfo/Viewport/Content/go_info")
  self.btn_return = self:GetControl("go_LoginInput/btn_return")
  self.go_phoneVerification = self:GetControl("go_phoneVerification")
  self.btn_closePhone = self:GetControl("go_phoneVerification/btn_closePhone")
  self.lab_phoneNumber = self:GetControl("go_phoneVerification/lab_verification/lab_phoneNumber")
  self.Input_number = self:GetControl("go_phoneVerification/Input_number")
  self.Panel_Text = self:GetControl("Panel_Text")
  self.Button_Text = self:GetControl("Panel_Text/Button_Text")
  self.Text = self:GetControl("Panel_Text/Button_Text/Text")
  self.go_ConnectServer = self:GetControl("go_ConnectServer")
  self.btn_select = self:GetControl("go_ConnectServer/btn_select")
  self.lab_select = self:GetControl("go_ConnectServer/btn_select/lab_select")
  self.lab_connectServerName = self:GetControl("go_ConnectServer/go_serverInfo/lab_connectServerName")
  self.img_connectServerState = self:GetControl("go_ConnectServer/go_serverInfo/img_connectServerState")
  self.btn_enter = self:GetControl("go_ConnectServer/btn_enter")
  self.lab_enter = self:GetControl("go_ConnectServer/btn_enter/lab_enter")
  self.go_notice = self:GetControl("go_notice")
  self.btn_CloseNotice1 = self:GetControl("go_notice/btn_CloseNotice1")
  self.img_shang = self:GetControl("go_notice/img_shang")
  self.btn_closeNotice = self:GetControl("go_notice/btn_closeNotice")
  self.go_noticeGroup = self:GetControl("go_notice/go_noticeGroup")
  self.btn_noticeTab = self:GetControl("go_notice/go_noticeGroup/Viewport/Content/btn_noticeTab")
  self.lab_content = self:GetControl("go_notice/sv_noticeContent/Viewport/Content/lab_content")
  self.go_privacyPolicy = self:GetControl("go_privacyPolicy")
  self.btn_closePolicy = self:GetControl("go_privacyPolicy/btn_closePolicy")
  self.lab_PolicyContent = self:GetControl("go_privacyPolicy/sv_PolicyContent/Viewport/Content/lab_PolicyContent")
  self.Img_pointOut = self:GetControl("Img_pointOut")
  self.lab_pointOut = self:GetControl("Img_pointOut/lab_pointOut")
  self.lab_version = self:GetControl("lab_version")
  self.btn_copyID = self:GetControl("btn_copyID")
  self.btn_sp1 = self:GetControl("btn_sp1")
  self.btn_sp2 = self:GetControl("btn_sp2")
  self.btn_AgeTip = self:GetControl("btn_AgeTip")
  self.go_AgeNotice = self:GetControl("go_AgeNotice")
  self.btn_AgeClosePanel = self:GetControl("go_AgeNotice/btn_AgeClosePanel")
  self.btn_closeAge = self:GetControl("go_AgeNotice/btn_closeAge")
  self.lab_Label = self:GetControl("Label")
  self.lab_PrivacyPolicy = self:GetControl("Label/lab_PrivacyPolicy")
  self.videoplayer = self:GetControl("RawImage")
  self.img_LoginBg = self:GetControl("img_LoginBg")
  self.btn_bindAccount = self:GetControl("btn_bindAccount")
  self.btn_changeChannel_apple = self:GetControl("btn_changeChannel")
  self.go_KoreaSignIn3rd = self:GetControl("go_KoreaSignIn3rd")
  self.btn_go_Apple = self:GetControl("go_KoreaSignIn3rd/SignInWith3rd/go_Apple")
  self.btn_go_Google = self:GetControl("go_KoreaSignIn3rd/SignInWith3rd/go_Google")
  self.btn_go_Webzen = self:GetControl("go_KoreaSignIn3rd/SignInWith3rd/go_Webzen")
  self.btn_go_Guest = self:GetControl("go_KoreaSignIn3rd/SignInWith3rd/go_Guest")
  self.btn_information = self:GetControl("btn_information")
  self.btn_customer = self:GetControl("btn_customer")
  self.btn_newPackDownload = self:GetControl("btn_newPackDownload")
end

local PanelStateEnum = {
  InputLogin = enum(1),
  SelectServer = enum(),
  ConnectServer = enum()
}
local sp1_count = 0
local sp2_count = 0
local clickWhiteCount = 0

function Login_LoginUI:Init()
  self.serverContainer = {}
  self.groupContainer = {}
  self.serverListContainer = {}
  self.curGroup = nil
  LoginData.panelState = PanelStateEnum.InputLogin
  self.tickCount = 120
  self.needWaitAmountInfo = false
  self.waitMaxTime = 3
end

function Login_LoginUI:OnCreate()
  self:InitControls()
  self:InitUI()
  self:RegistUIEvents()
end

function Login_LoginUI:InitUI()
  self.Input_Account:SetInputText(LoginData.userName)
  self:ServerInit()
  self:InitContent()
  self:OnInitGetip()
  self.announcementInfo = {}
  local apkVersion = MuInterfaceLua.Instance:GetInstallResVersion()
  local curVersion = CS.Framework.HotUpdatePorcessMgr.localVersion:ToString()
  local versionStr = "V." .. apkVersion .. "_" .. curVersion
  self.lab_version:SetText(versionStr)
  self.tmeploginType = {}
  self:ShowDownload()
end

function Login_LoginUI:ShowDownload()
  if not string.isNullOrEmpty(PlatformData.GetCanForceUpdateULR()) then
    self.btn_newPackDownload:SetActive(true)
  else
    self.btn_newPackDownload:SetActive(false)
  end
end

function Login_LoginUI:PlayerViewInit()
  local isopenvideo = ""
  local configJson = ""
  local pid = ""
  if CS.MuInterface.Instance.GetVersionConfig then
    configJson = CS.MuInterface.Instance:GetVersionConfig()
  end
  if not string.isNullOrEmpty(configJson) then
    local config = json.decode(configJson)
    if not string.isNullOrEmpty(config.isopenvideo) then
      isopenvideo = config.isopenvideo
    end
    if not string.isNullOrEmpty(config.pid) then
      pid = config.pid
    end
  end
  Coroutine.Start(self.InitLoginBgImage, self)
end

function Login_LoginUI:InitLoginBgImage()
end

local function InitAnnouncementBtnItemControls(ctr)
  ctr.lab_serverGroup = UIControl(ctr.transform, "lab_serverGroup")
  ctr.toggle.isOn = false
  ctr:SetOnToggleChanged(ctr, Login_LoginUI.ClickAnnouncement)
end

local function AnnouncementBtnItemRefresh(ctr, _, content, ui)
  ctr.lab_serverGroup:SetText(content.call)
  ctr.content = content
end

function Login_LoginUI:ClickAnnouncement(ctr, isOn)
  if isOn then
    Login_LoginUI.lab_content:SetText(ctr.content.content)
  end
end

function Login_LoginUI:InitContent()
  self.announcementBtnItemTemp = UIContainer(self.btn_noticeTab, self, InitAnnouncementBtnItemControls, AnnouncementBtnItemRefresh)
end

local function SdkLoginSuc(data)
  LogManager.AddLoginLog("SDK_Login_End", "Login")
  CS.MuInterface.Instance:RemoveLoginSucListener()
  LoginData.sdkUserId = data.userId
  LoginData.neckName = data.name
  LoginData.token = data.token
  local sdkTime = data.time
  LoginData.gid = data.gid
  LoginData.pId = data.pid
  LoginData.loginExt = data.ext
  LoginData.isSdkLogging = true
  LoginData.opName = data.opName
  LoginData.loginType = data.loginType or ""
  LoginData.service_code = data.serviceCode
  LoginData.sdk_pid = data.userId
  LoginData.roleName = ""
  LoginData.roleLevel = 1
  LoginData.createTime = 1
  RoleDeclareManager.GetAmountState = false
  local form = CS.UnityEngine.WWWForm()
  form:AddField("gid", tostring(LoginData.gid))
  form:AddField("time", tostring(sdkTime))
  form:AddField("token", tostring(LoginData.token))
  form:AddField("uid", tostring(LoginData.sdkUserId))
  form:AddField("pid", tostring(LoginData.pId))
  form:AddField("login_token", tostring(LoginData.token))
  form:AddField("game_account_no", tostring(LoginData.sdkUserId))
  form:AddField("username", tostring(LoginData.neckName))
  form:AddField("login_verify_sign", tostring(LoginData.loginExt))
  if string.isNullOrEmpty(LoginData.opName) then
    LoginData.opName = "mg"
  end
  EventManager.Dispatch(Event.Login_SDKLogin)
  LogManager.AddLoginLog("\231\153\187\229\133\165\233\170\140\232\175\129_Begin", "Login")
  local url = string.format(PlatformData.GetCKUrl(), LoginData.opName)
  if LoginData.isSdk then
    UIManager.Show(UIID.WaitingUI, {
      msg = "\196\144ang \196\145\196\131ng nh\225\186\173p"
    })
    Http.RequestHaveArg(url, form, function(text)
      if UIManager.IsVisible(UIID.WaitingUI) then
        UIManager.Hide(UIID.WaitingUI)
      end
      if string.isNullOrEmpty(text) then
        EventManager.Dispatch(Event.SDK_KOREA_LOGINFAILCallback, "token Type II Error")
        EventManager.Dispatch(Event.KoreaSDKLog_CALLBACK, "token Type II Error")
        return
      end
      local backData = json.decode(text)
      if not backData.errno then
        LogManager.AddLoginLog("\231\153\187\229\133\165\233\170\140\232\175\129_End Sucess", "Login")
        LoginData.sign = backData.sign
        LoginData.userName = backData.loginName
        LoginData.time = backData.time
        LoginData.accessToken = backData.token
        if not string.isNullOrEmpty(LoginData.accessToken) then
          CS.MuInterface.Instance:SendToken(LoginData.accessToken)
        end
        local infos = string.split(backData.loginName, ":")
        LoginData.operId = tonumber(infos[1])
        LoginData.pId = tonumber(infos[2])
        EventManager.Dispatch(Event.Login_LoginSuccess)
        EventManager.Dispatch(Event.KoreLogForWrite, tostring(LoginData.userName))
      else
        LogManager.AddLoginLog("\231\153\187\229\133\165\233\170\140\232\175\129_End Fail", "Login")
        if backData.errno == "103" then
          EventManager.Dispatch(Event.Login_LoginFail)
        elseif backData.errno == "104" and not string.isNullOrEmpty(backData.msg) then
          UIManager.Show(UIID.PromptTipUI, {
            title = "Nh\225\186\175c nh\225\187\159",
            textContent = backData.msg,
            isBan = true
          })
        end
        CS.LauncherUI.Close()
      end
    end)
  else
    Http.RequestHaveArg(url, form, function(text)
      if string.isNullOrEmpty(text) then
        return
      end
      local backData = json.decode(text)
      if not backData.errno then
        LogManager.AddLoginLog("\231\153\187\229\133\165\233\170\140\232\175\129_End Sucess", "Login")
        LoginData.sign = backData.sign
        LoginData.userName = backData.loginName
        LoginData.time = backData.time
        LoginData.accessToken = backData.token
        if not string.isNullOrEmpty(LoginData.accessToken) then
          CS.MuInterface.Instance:SendToken(LoginData.accessToken)
        end
        local infos = string.split(backData.loginName, ":")
        LoginData.operId = tonumber(infos[1])
        LoginData.pId = tonumber(infos[2])
        EventManager.Dispatch(Event.Login_LoginSuccess)
      else
        LogManager.AddLoginLog("\231\153\187\229\133\165\233\170\140\232\175\129_End Fail", "Login")
        if backData.errno == "103" then
          EventManager.Dispatch(Event.Login_LoginFail)
        elseif backData.errno == "104" and not string.isNullOrEmpty(backData.msg) then
          UIManager.Show(UIID.PromptTipUI, {
            title = "Nh\225\186\175c nh\225\187\159",
            textContent = backData.msg,
            isBan = true
          })
        end
        CS.LauncherUI.Close()
      end
    end)
  end
end

local function ServerStateMap(state)
  local str = ""
  if state == EServerState.NewServer then
    str = LocalizationUtility.GetContentByKey("ServerState_1")
  elseif state == EServerState.Fluent then
    str = LocalizationUtility.GetContentByKey("ServerState_2")
  elseif state == EServerState.Crowd then
    str = LocalizationUtility.GetContentByKey("ServerState_3")
  elseif state == EServerState.Defend then
    str = LocalizationUtility.GetContentByKey("ServerState_4")
  end
  return str
end

local function GetImageName(state)
  local spriteName = "img_server2"
  if state == EServerState.NewServer then
    spriteName = "img_server2"
  elseif state == EServerState.Fluent then
    spriteName = "img_server2"
  elseif state == EServerState.Crowd then
    spriteName = "img_server3"
  elseif state == EServerState.Defend then
    spriteName = "img_server1"
  end
  return spriteName
end

local function ServerListOnCreate(ctr)
  ctr.Checkmark = UIControl(ctr.transform, "Background/Checkmark")
  ctr.Text = UIControl(ctr.transform, "Text")
  ctr.Checkmark:SetActive(false)
end

local function ServerListOnRefresh(ctr, index, data, ui)
  ctr.Text:SetText(data.name)
  ctr.Checkmark:SetActive(false)
  ctr.serverList = data.serverList
  ctr.serverListIndex = index
  ctr:SetOnClick(ui, ui.btn_selectServerListOnClick)
  if ctr.serverListIndex == LoginData.xyServerListIndex then
    LoginData.xyServerListIndex = -1
    ui.btn_selectServerListOnClick(ui, ctr)
  end
end

local function ServerOnCreate(ctr)
  ctr.lab_serverName = UIControl(ctr.transform, "lab_serverName")
  ctr.img_serverState = UIControl(ctr.transform, "img_serverState")
  ctr.img_newServer = UIControl(ctr.transform, "img_newServer")
  ctr.lab_serverState = UIControl(ctr.transform, "lab_serverState")
  ctr.img_head_bg = UIControl(ctr.transform, "img_head_bg")
  ctr.img_head = UIControl(ctr.transform, "img_head_bg/img_head")
  ctr.txt_level = UIControl(ctr.transform, "img_head_bg/img_level_bg/txt_level")
end

local function ServerOnRefresh(ctr, _, data, ui)
  ctr.lab_serverName:SetText(data[1])
  ctr.lab_serverState.gameObject:SetActive(false)
  local spriteName = GetImageName(data[3])
  ctr.img_newServer.gameObject:SetActive(data[3] == EServerState.NewServer)
  ui:SetSprite("Atlas_Common", spriteName, ctr.img_serverState)
  ctr.img_head_bg.gameObject:SetActive(false)
  local roleInfo = RoleDeclareManager.GetRoleForServerId(data[5])
  if not string.isNullOrEmpty(roleInfo) and roleInfo.careerid ~= nil and tonumber(roleInfo.careerid) ~= 0 then
    ctr.img_head_bg.gameObject:SetActive(true)
    local spriteName = ClientTable.cfg_Character_attributeManager:TryGetValue(roleInfo.careerid, "id").headPortrait
    ui:SetSprite("Atlas_headPortrait", spriteName, ctr.img_head)
    ctr.txt_level:SetText(roleInfo.level)
  end
  ctr.id = data[5]
  if ctr.button then
    ctr:SetOnClick(ui, ui.btn_selectServerOnClick)
  end
end

local function GroupOnCreate(ctr)
  ctr.lab_serverGroup = UIControl(ctr.transform, "lab_serverGroup")
  ctr.Checkmark = UIControl(ctr.transform, "Background/Checkmark")
  ctr.Checkmark:SetActive(false)
end

local function GroupOnRefresh(ctr, index, data, ui)
  if data.index == -1 then
    ctr.lab_serverGroup:SetText(LocalizationUtility.GetContentByKey("ServerGroup_1"))
  else
    ctr.lab_serverGroup:SetText(LoginData.GetServerGroupName(data.index))
  end
  ctr.Checkmark:SetActive(false)
  ctr.servers = data.servers
  ctr.groupIndex = index
  ctr:SetOnClick(ui, ui.SetOnClcikServerGroup)
  if index == LoginData.serverGroupIndex then
    LoginData.serverGroupIndex = -1
    ui.SetOnClcikServerGroup(ui, ctr)
  end
end

function Login_LoginUI:SetOnClcikServerGroup(ctr)
  if ctr.groupIndex == LoginData.serverGroupIndex then
    return
  end
  ctr.Checkmark:SetActive(true)
  local preCtr = self.groupContainer.items[LoginData.serverGroupIndex]
  if preCtr then
    preCtr.Checkmark:SetActive(false)
  end
  LoginData.serverGroupIndex = ctr.groupIndex
  self.curGroup = ctr
  self.serverContainer:SetData(ctr.servers)
end

function Login_LoginUI:ServerInit()
  self.serverContainer = UIContainer(self.btn_serverInfo, self, ServerOnCreate, ServerOnRefresh)
  self.groupContainer = UIContainer(self.btn_serverGroup, self, GroupOnCreate, GroupOnRefresh)
  self.serverListContainer = UIContainer(self.btn_android, self, ServerListOnCreate, ServerListOnRefresh)
end

function Login_LoginUI:OnInitGetip()
  CS.UnityEngine.Debug.Log("w \226\145\160" .. tostring(LoginData.IP_CALLBACK_URL))
  Http.Request(LoginData.IP_CALLBACK_URL, function(text)
    if text then
      LoginData.selfIp = text
      CS.UnityEngine.Debug.Log("w \226\145\161" .. text)
    else
      CS.UnityEngine.Debug.Log("w \226\145\162 fail")
      LogManager.AddLoginLog("\231\153\189\229\144\141\229\141\149 text is Fail", "Login")
    end
  end)
end

function Login_LoginUI:OnShow()
  self:LocalInit()
  self:RegistEvents()
  self:Refresh()
  self:OnSDK_ShowInfow()
end

function Login_LoginUI:RefreshLogo()
  if LoginData.isSdk then
    if CS.MuInterface.Instance:GetIsSpecialLoad() == 1 then
      local a = CS.Framework.StreamingAssetsFile.Load("cLogo.png")
      if a ~= nil and 0 < #a then
        local texture = CS.UnityEngine.Texture2D(20, 10)
        CS.UnityEngine.ImageConversion.LoadImage(texture, a)
        local aSprite = CS.UnityEngine.Sprite.Create(texture, CS.UnityEngine.Rect(0, 0, texture.width, texture.height), Vector2(0.5, 0.5))
        if aSprite then
          self.Img_logo_1:SetSprite(aSprite)
          self.Img_logo_1:SetNativeSize()
          self.Img_logo_1:SetActive(true)
        end
      end
    else
      self.Img_logo_1:SetActive(true)
    end
    MuCallBackUtility.isNeedJumpScene = false
    if not string.isNullOrEmpty(PlatformData.GetCopyright()) then
      self.tip2:SetText(PlatformData.GetCopyright())
    end
    self.tog_PrivacyPolicy.toggle.isOn = LoginController.GetIsAgreePrivacyPolicy()
  else
    self.Img_logo_1:SetActive(true)
  end
  self.tip2:SetActive(true)
end

function Login_LoginUI:ShowPrivacyPolicy()
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Preference, true) then
    self.tog_PrivacyPolicy:SetActive(true)
    self.lab_Label:SetActive(true)
  else
    self.tog_PrivacyPolicy:SetActive(false)
    self.lab_Label:SetActive(false)
  end
end

function Login_LoginUI:OnHide()
  LoginData.panelState = PanelStateEnum.InputLogin
  if LoginData.isSdk then
    CS.MuInterface.Instance:RemoveLoginSucListener()
    MuCallBackUtility.isNeedJumpScene = true
  end
end

function Login_LoginUI:OnDestroy()
  self.serverContainer = {}
  self.groupContainer = {}
  self.curGroup = nil
end

local Input = CS.UnityEngine.Input
local KeyCode = CS.UnityEngine.KeyCode

function Login_LoginUI:Update()
  if self.needWaitAmountInfo then
    self.waitMaxTime = self.waitMaxTime - Time.deltaTime
    if RoleDeclareManager.GetAmountState or self.waitMaxTime < 0 then
      if self.waitMaxTime < 0 then
        LoginData.roleInfoConnectTimeOut = true
      end
      self.needWaitAmountInfo = false
      self.waitMaxTime = 5
      UIManager.Hide(UIID.WaitingUI)
      self:btn_selectOnClick()
    end
  end
  if Input.GetKeyDown(KeyCode.Tab) and LoginData.isWhite then
    UIManager.Show(UIID.GM_ToolUI)
  end
end

function Login_LoginUI:RegistUIEvents()
  self.Button_Text:SetOnClick(self, self.OnTest)
  self.btn_ok:SetOnClick(self, self.btn_okOnClick)
  self.btn_enter:SetOnClick(self, self.btn_connectOnClick)
  self.btn_select:SetOnClick(self, self.btn_selectOnClick)
  self.btn_back:SetOnClick(self, self.btn_backOnClick)
  self.btn_UserDelete:SetOnClick(self, self.btn_UserDeleteOnClick)
  self.btn_closeSelectServer:SetOnClick(self, self.btn_closeSelectServerOnClick)
  self.btn_notice:SetOnClick(self, self.btn_noticeOnClick)
  self.btn_closeNotice:SetOnClick(self, self.btn_closeNoticeOnClick)
  self.btn_CloseNotice1:SetOnClick(self, self.btn_closeNoticeOnClick)
  self.btn_copyID:SetOnClick(self, self.btn_copyIDOnClick)
  self.btn_sp1:SetOnClick(self, self.btn_sp1OnClick)
  self.btn_sp2:SetOnClick(self, self.btn_sp2OnClick)
  self.btn_AgeTip:SetOnClick(self, self.btn_AgeTipOnClick)
  self.btn_AgeClosePanel:SetOnClick(self, self.closeAgeOnClick)
  self.btn_closeAge:SetOnClick(self, self.closeAgeOnClick)
  self.btn_clickWhite:SetOnClick(self, self.btn_clickWhiteOnClick)
  self.btn_loginSdk:SetOnClick(self, self.btn_loginSdkOnClick)
  self.btn_agreement:SetOnClick(self, self.btn_agreementOnClick)
  self.lab_PrivacyPolicy:SetOnTextPointerClick(self, self.ExecuteTextOrder)
  self.btn_go_Apple:SetOnClick(self, self.btn_go_AppleOnClick)
  self.btn_go_Google:SetOnClick(self, self.btn_go_GoogleOnClick)
  self.btn_go_Webzen:SetOnClick(self, self.btn_go_WebzenOnClick)
  self.btn_go_Guest:SetOnClick(self, self.btn_go_GuestOnClick)
  self.btn_bindAccount:SetOnClick(self, self.btn_bindAccountOnClick)
  self.btn_changeChannel_apple:SetOnClick(self, self.btn_changeChannel_appleOnClick)
  self:ShowLoginBntActive()
  self.btn_information:SetOnClick(self, self.btn_informationOnClick)
  self.btn_customer:SetOnClick(self, self.btn_customerOnClick)
  self.btn_newPackDownload:SetOnClick(self, self.btn_newPackDownloadOnClick)
end

function Login_LoginUI:btn_newPackDownloadOnClick()
  if not string.isNullOrEmpty(PlatformData.GetCanForceUpdateULR()) then
    Application.OpenURL(PlatformData.GetCanForceUpdateULR())
  end
end

function Login_LoginUI:btn_customerOnClick()
  local global = ClientTable.cfg_Global_globalManager:TryGetValue(70000001).effect
  if not string.isNullOrEmpty(global) then
    Application.OpenURL(global)
  end
end

function Login_LoginUI:btn_informationOnClick()
  CS.MuInterface.Instance:OnShowUserinfo()
end

function Login_LoginUI:btn_bindAccountOnClick()
  local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(27)
  if data then
    UIManager.Show(UIID.PromptTipUI, {
      title = data.title,
      autoClose = false,
      textContent = data.content,
      okText = data.rightButton,
      cancelText = data.leftButton,
      cancel = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      ok = function()
        self.go_KoreaSignIn3rd:SetActive(true)
        self.go_ConnectServer:SetActive(false)
        self.btn_changeChannel_apple:SetActive(false)
        self.btn_bindAccount:SetActive(false)
      end
    })
  end
end

function Login_LoginUI:btn_changeChannel_appleOnClick()
  self:btn_backOnClick()
end

function Login_LoginUI:ShowLoginBntActive()
  local ibt = false
  local configJson = ""
  if CS.MuInterface.Instance.GetVersionConfig then
    configJson = CS.MuInterface.Instance:GetVersionConfig()
  end
  if not string.isNullOrEmpty(configJson) then
    local config = json.decode(configJson)
    if not string.isNullOrEmpty(config.ibt) then
      ibt = true
    end
  end
  if ibt then
    self.btn_go_Webzen:SetActive(ibt)
    self.btn_go_Apple:SetActive(false)
    self.btn_go_Google:SetActive(false)
    self.btn_go_Guest:SetActive(false)
  else
    local ishshow = PlatformData.PlatformCheck(PlatformNameEnum.UNITY_IOS)
    self.btn_go_Guest:SetActive(ishshow)
    local isshowAndriod = PlatformData.PlatformCheck(PlatformNameEnum.UNITY_ANDROID)
    self.btn_go_Webzen:SetActive(ibt)
  end
end

function Login_LoginUI:btn_go_WebzenOnClick()
  if LoginData.loginType and LoginData.loginType == "guest" then
    CS.MuInterface.Instance:OnChangePartner("webzenad")
  else
    self.tmeploginType = "999"
    CS.MuInterface.Instance:RemoveLoginSucListener()
    CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
    CS.MuInterface.Instance:Login("999")
  end
end

function Login_LoginUI:btn_go_AppleOnClick(control)
  if LoginData.loginType and LoginData.loginType == "guest" then
    CS.MuInterface.Instance:OnChangePartner("APPLE")
  else
    self.tmeploginType = "16"
    CS.MuInterface.Instance:RemoveLoginSucListener()
    CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
    CS.MuInterface.Instance:Login("16")
  end
end

function Login_LoginUI:btn_btn_customerClick(control)
  local name = ClientTable.cfg_Function_functionManager:GetKoreaWebView(4000002)
  if name then
    PlatformData.OpenURL(name)
  end
end

function Login_LoginUI:btn_go_GoogleOnClick(control)
  if LoginData.loginType and LoginData.loginType == "guest" then
    CS.MuInterface.Instance:OnChangePartner("Google")
  else
    self.tmeploginType = "4"
    CS.MuInterface.Instance:RemoveLoginSucListener()
    CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
    CS.MuInterface.Instance:Login("4")
  end
end

function Login_LoginUI:btn_go_GuestOnClick(control)
  if LoginData.loginType and LoginData.loginType == "guest" then
    self.go_KoreaSignIn3rd:SetActive(false)
    self.go_ConnectServer:SetActive(true)
    self.btn_changeChannel_apple:SetActive(false)
    self.btn_bindAccount:SetActive(false)
  else
    TipUtility.QuickShowPrompt({
      id = 26,
      cancelAction = function()
        self:OpenSDKCancelLoginTip()
      end,
      okAction = function()
        self.go_KoreaSignIn3rd:SetActive(true)
        self.go_ConnectServer:SetActive(false)
        self.btn_changeChannel_apple:SetActive(false)
        self.btn_bindAccount:SetActive(false)
        self.tmeploginType = "7"
        CS.MuInterface.Instance:RemoveLoginSucListener()
        CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
        CS.MuInterface.Instance:Login("7")
      end
    })
  end
end

function Login_LoginUI:onGuestLogin(platform)
  CS.MuInterface.Instance:OnChangePartner(platform)
  self.go_KoreaSignIn3rd:SetActive(false)
  self.go_ConnectServer:SetActive(true)
  self.btn_changeChannel_apple:SetActive(false)
  self.btn_bindAccount:SetActive(false)
end

function Login_LoginUI:OnTest(control)
  local aa = "http://client.fgqj.app.xy.com/xyOnline/Android/Version.json"
  local txtPath = "version/debugPath.txt"
  local urlName = "/Android/Version.json"
  local localName = "http://10.40.1.53:8806/MuApk/apk/"
  local debugUrl = string.replace(aa, urlName, "")
  local splits = string.split(debugUrl, "/")
  debugUrl = localName .. splits[#splits] .. urlName
end

function Login_LoginUI:btn_okOnClick(_)
  ActionStepsLogManager.SetRoleAction(ActionStepsType.LoginGame)
  LoginData.userName = self.Input_Account:GetInputText()
  if LoginData.userName then
    PlayerPrefs.SetString(LoginData.USER_LAST_ACCOUNT, LoginData.userName:gsub(CS.System.Environment.NewLine, ""))
    PlayerPrefs.Save()
  end
  self:GetServerInfo(WaitServer.Wait)
  RoleDeclareManager.GetRoleInformation()
end

function Login_LoginUI:HideUI()
  self.Scroll_ServerIPs:SetActive(false)
  self.go_LoginInput:SetActive(false)
  self.go_KoreaSignIn3rd:SetActive(false)
end

function Login_LoginUI:GetAnnouncementByOperId()
  LogManager.AddLoginLog("\232\142\183\229\143\150\229\133\172\229\145\138_Begin ", "Login")
  Http.Request(LoginData.GetAnnouncementUrl(), function(text)
    if not string.isNullOrEmpty(text) then
      LogManager.AddLoginLog("\232\142\183\229\143\150\229\133\172\229\145\138_End Sucess ", "Login")
      local text = utf8.unicode_to_utf8(text)
      LoginData.announcementData = json.decode(text)
      self.go_notice:SetActive(true)
      if not self.img_shang:GetActive() and CS.MuInterface.Instance:GetIsSpecialLoad() == 1 then
        local a = CS.Framework.StreamingAssetsFile.Load("cNotice.png")
        if a ~= nil and 0 < #a then
          local texture = CS.UnityEngine.Texture2D(20, 10)
          CS.UnityEngine.ImageConversion.LoadImage(texture, a)
          local aSprite = CS.UnityEngine.Sprite.Create(texture, CS.UnityEngine.Rect(0, 0, texture.width, texture.height), Vector2(0.5, 0.5))
          if aSprite then
            self.img_shang:SetSprite(aSprite)
          end
        end
      end
      self.img_shang:SetActive(true)
      self.announcementBtnItemTemp:SetData(LoginData.GetAnnouncementData())
      if 0 < #self.announcementBtnItemTemp.items then
        self.announcementBtnItemTemp.items[1].toggle.isOn = true
      end
    else
      LogManager.AddLoginLog("\232\142\183\229\143\150\229\133\172\229\145\138_End Fail ", "Login")
    end
  end)
end

local function Restart()
  EventManager.Dispatch(Event.Game_Restart)
  Coroutine.StopAll()
  CS.CSOutlineLabel.Clear()
  CS.CSSpriteMesh.SpriteMaterialCache:Clear()
  local args = CS.Framework.VariantTable()
  LoginData.SetVariant(args)
  CS.Main.instance:Restart(args)
end

local function OnHotUpdateDownFinish(updata)
end

local function DoConnectClick(updated)
  if updated or Localization.isChangeLanguage then
    Restart()
    Localization.isChangeLanguage = false
    return
  end
  UIManager.Show(UIID.WaitingUI, {
    msg = string.format(LocalizationUtility.GetContentByKey("CennectServer_1"), LoginData.server[1])
  })
  ReconnectManager.OnConnect()
  ActionStepsLogManager.SetRoleAction(ActionStepsType.SelectServer)
end

function Login_LoginUI:GroupContainerSetData()
  if not LoginData.serverGroup[LoginData.serverGroupIndex] then
    LoginData.serverGroupIndex = 1
  end
  self.groupContainer:SetData(LoginData.serverGroup)
end

function Login_LoginUI:ServerListContainerSetData()
  if not LoginData.xyServerList[LoginData.xyServerListIndex] then
    LoginData.xyServerListIndex = 1
  end
  self.serverListContainer:SetData(LoginData.xyServerList)
end

function Login_LoginUI:DoGetServerInfo()
  CS.UnityEngine.Debug.Log("\226\145\160\232\175\183\230\177\130\230\156\141\229\138\161\229\153\168\229\136\151\232\161\168" .. tostring(LoginData.GetUrlByNet()))
  LogManager.AddLoginLog("\229\140\186\230\156\141\230\156\141\229\138\161\229\153\168\229\136\151\232\161\168\232\142\183\229\143\150_Begin 2", "Login")
  Http.Request(LoginData.GetUrlByNet(), function(text)
    local main = CS.Main.instance
    CS.UnityEngine.Debug.Log("\226\145\161\230\136\144\229\138\159\232\142\183\229\143\150\230\156\141\229\138\161\229\153\168\229\136\151\232\161\168\239\188\154" .. tostring(text))
    if text then
      LogManager.AddLoginLog("\229\140\186\230\156\141\230\156\141\229\138\161\229\153\168\229\136\151\232\161\168\232\142\183\229\143\150_End 2 = ", "Login")
      local server_lists_initial = text
      if LoginData.isNeedDeEncrypConfig then
        server_lists_initial = CS.Encryption.ReplaceValue(text)
        CS.UnityEngine.Debug.Log("\226\145\161\230\136\144\229\138\159\232\142\183\229\143\150\230\156\141\229\138\161\229\153\168\229\136\151\232\161\168_\232\167\163\229\175\134\229\144\142\239\188\154" .. tostring(server_lists_initial))
      end
      LoginData.data = json.decode(server_lists_initial)
      assert(LoginData.data ~= nil)
      local ips = LoginData.data.white_ips
      LoginData.Server_old_user = LoginData.data.old_user
      LoginData.SetServerGroupName(LoginData.data.group_name_new)
      LoginData.isWhite = LoginData.isWhite or table.contains(ips, LoginData.selfIp)
      if LoginData.isWhite then
        self.btn_sp1:SetActive(true)
        self.btn_sp2:SetActive(true)
        self.btn_clickWhite:SetActive(true)
      end
      LoginData.SetServerList(LoginData.data.server_lists)
      LoginData.SetServiceRecommend(LoginData.data.recommend)
      LoginData.SetEquipmentList(LoginData.data.equipment_lists)
      if LoginData.data.equipment_lists then
        self.btn_copyID:SetActive(true)
      end
      LoginData.InitOftenServer()
      local defaultServer = LoginData.oftenServers[1] and LoginData.GetServer(LoginData.oftenServers[1]) or LoginData.GetDefaultRecommend()
      LoginData.SetServer(defaultServer)
      LoginData.SortOutServerList()
      if LoginData.panelState == PanelStateEnum.InputLogin or LoginData.panelState == PanelStateEnum.ConnectServer then
        self:OnConnectServerPanel()
      elseif LoginData.OperEnum[LoginData.operId] == "xy" then
        if LoginData.showServerListCount == 2 then
          self:ServerListContainerSetData()
        else
          self:GroupContainerSetData()
        end
      else
        self:GroupContainerSetData()
      end
    else
      LogManager.AddLoginLog("\229\140\186\230\156\141\230\156\141\229\138\161\229\153\168\229\136\151\232\161\168\232\142\183\229\143\150_End 2 \229\140\186\230\156\141\229\136\151\232\161\168\232\142\183\229\143\150\233\148\153\232\175\175 ", "Login")
      logError("L\225\187\151i t\225\186\163i danh s\195\161ch m\195\161y ch\225\187\167")
      CS.LauncherUI.Close()
    end
    UIManager.Hide(UIID.WaitingUI)
    if main.restart then
      DoConnectClick(false)
      main.restart = false
    end
  end)
end

local function DoResRestLau(obj)
end

local function DoResLoadingFinsh(obj)
end

function Login_LoginUI:GetServerInfo(type)
  self.tickCount = 120
  LogManager.AddLoginLog("\232\142\183\229\143\150\229\140\186\230\156\141\229\136\151\232\161\168ip\229\156\176\229\157\128_Begin 1", "Login")
  if type == WaitServer.Wait then
    UIManager.Show(UIID.WaitingUI, {
      msg = LocalizationUtility.GetContentByKey("GetServerInfo")
    })
  end
  if LoginData.externalNet == false then
    self:DoGetServerInfo()
    LoginData.isWhite = true
    return
  end
  if LoginData.GetseverGotoState() == 1 then
    self:DoGetServerInfo()
  elseif LoginData.selfIp ~= "" then
    self:DoGetServerInfo()
  else
    Http.Request(LoginData.IP_CALLBACK_URL, function(text)
      if text then
        LogManager.AddLoginLog("\232\142\183\229\143\150\229\140\186\230\156\141\229\136\151\232\161\168ip\229\156\176\229\157\128_End 1", "Login")
        LoginData.selfIp = text
      else
        LogManager.AddLoginLog("\232\142\183\229\143\150\229\140\186\230\156\141\229\136\151\232\161\168ip\229\156\176\229\157\128_End 1 text is nil", "Login")
      end
    end)
    self:DoGetServerInfo()
  end
end

function Login_LoginUI:FetchIpWithTimeout(url, Successcallback, failCallback)
  local timeout = 5
  local request = CS.UnityEngine.Networking.UnityWebRequest.Get(LoginData.IP_CALLBACK_URL)
  local sendOperation = request:SendWebRequest()
  local startTime = Timer.GetTime()
  while not sendOperation.isDone do
    if timeout < CS.UnityEngine.Time.time - startTime then
      request:Abort()
      if failCallback then
        failCallback()
      end
      break
    end
    Coroutine.Yield(nil)
  end
  if not string.isNullOrEmpty(request.error) then
    Successcallback(1)
  else
    if Successcallback then
      Successcallback(2)
    end
    LoginData.selfIp = request.downloadHandler.text
  end
  request:Dispose()
end

function Login_LoginUI:OnConnectServerPanel()
  CS.UnityEngine.Debug.Log("\226\145\162OnConnectServerPanel" .. PanelStateEnum.ConnectServer)
  self.lab_connectServerName:SetText(LoginData.server[1])
  self.img_connectServerState.image.color = EServerStateColor[tonumber(LoginData.server[3])]
  self:SetState(PanelStateEnum.ConnectServer)
end

function Login_LoginUI:btn_connectOnClick(_)
  if not string.isNullOrEmpty(PlatformData.GetCanForceUpdate()) then
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(132)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = data.content,
        okText = data.rightButton,
        cancelText = data.leftButton,
        isframe = true,
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          Application.OpenURL(PlatformData.GetCanForceUpdateULR())
        end
      })
    end
  else
    self:connectOnClick()
  end
end

function Login_LoginUI:connectOnClick()
  local serverVersionType = 0
  if LoginData.externalNet then
    if LoginData.server[7] then
      serverVersionType = tonumber(LoginData.server[7])
    end
  else
    local index = array.indexOf(LoginData.serverList, LoginData.server)
    serverVersionType = index - 1
  end
  Http.Request(LoginData.GetUrlByNet(), function(text)
    if text then
      local server_lists_initial = text
      if LoginData.isNeedDeEncrypConfig then
        server_lists_initial = CS.Encryption.ReplaceValue(text)
      end
      local data = json.decode(server_lists_initial)
      for i, v in pairs(data.server_lists) do
        if v[5] and tonumber(v[5]) == LoginData.serverId and tonumber(v[3]) == EServerState.Defend and (not LoginData.isWhite or not LoginData.isClickComplete) then
          TipUtility.ShowPP("M\195\161y ch\225\187\167 \196\145ang b\225\186\163o tr\195\172")
          UIManager.Hide(UIID.WaitingUI)
          CS.LauncherUI.Close()
          return
        end
      end
      self:OnLoginConnentServer(serverVersionType)
    else
      self:OnLoginConnentServer(serverVersionType)
    end
  end)
end

function Login_LoginUI:OnLoginConnentServer(serverVersionType)
  if FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.Preference, true) or LoginController.PlatformDataJudge("yinghe") then
    if self.tog_PrivacyPolicy.toggle.isOn then
      self.tog_PrivacyPolicy.toggle.isOn = LoginController.SetIsAgreePrivacyPolicy(true)
      self:OnSendConnetct(serverVersionType)
    else
      self:ShowPolicyConfrimTips()
    end
  else
    if not (LoginData.server and LoginData.server[1]) or LoginData.server[1] == "QA" then
    end
    local url = LoginData.checkRegisterRoleCount()
    if url ~= "" then
      local operationId, serverid, times, sign
      if LoginData.isSdk then
        operationId = LoginData.pId
      elseif LoginData.externalNet then
        operationId = LoginData.pId
      else
        operationId = LoginData.internalPId
      end
      serverid = LoginData.serverId
      times = os.time()
      local signdata = tostring(tostring(operationId) .. tostring(serverid) .. tostring(times) .. "697e39f7d3678d1940e4ceee2a5ce8fc")
      sign = self:GetStringmd5(signdata)
      local ulr = ""
      local loginnamecheck = ""
      if LoginData.isSdk then
        local infos = string.split(LoginData.userName, ":")
        loginnamecheck = LoginData.operId .. ":" .. tostring(infos[3])
      else
        loginnamecheck = LoginData.userName
      end
      ulr = PlatformData.GetCKUrdnsl() .. LoginData.CHECK_ROLE_COUNT_URL .. string.format("url=%s&operationId=%s&serverId=%s&time=%s&sign=%s&loginname=%s&method=%s", url .. LoginData.CHECK_ROLE_COUNT_URL_check, tostring(operationId), tostring(serverid), tostring(times), tostring(sign), loginnamecheck, "post")
      CS.UnityEngine.Debug.Log("ulr \230\163\128\230\159\165\229\136\155\232\167\146\228\186\186\230\149\176:" .. ulr)
      UIManager.Show(UIID.WaitingUI, {
        msg = LocalizationUtility.GetContentByKey("GetServerInfo")
      })
      Http.Request(ulr, function(text)
        CS.UnityEngine.Debug.Log("ulr \230\163\128\230\159\165\229\136\155\232\167\146\228\186\186\230\149\176 \230\136\144\229\138\159\232\142\183\229\143\150:" .. tostring(text))
        if UIManager.IsVisible(UIID.WaitingUI) then
          UIManager.Hide(UIID.WaitingUI)
        end
        if string.isNullOrEmpty(text) then
          EventManager.Dispatch(Event.KoreaSDKLog_CALLBACK, "token Type II Error")
          self:OnSendConnetct(serverVersionType)
          return
        end
        EventManager.Dispatch(Event.KoreaSDKLog_CALLBACK, text)
        local strdata = text:gsub("\\", "")
        strdata = string.match(strdata, "^\"(.-)\"$")
        local code = json.decode(strdata)
        if code.data ~= nil and code.data.can ~= nil and code.data.can == 0 then
          self:OnChcekRoleCountTip()
        else
          self:OnSendConnetct(serverVersionType)
        end
      end)
    else
      self:OnSendConnetct(serverVersionType)
    end
  end
end

function Login_LoginUI:OnSendConnetct(serverVersionType)
  CS.LauncherUI.Open(serverVersionType, DoConnectClick, OnHotUpdateDownFinish, DoResLoadingFinsh, DoResRestLau)
end

function Login_LoginUI:GetStringmd5(str)
  local data = CS.PCUtility.Md5(str)
  return data
end

function Login_LoginUI:OnChcekRoleCountTip()
  local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(52)
  if data then
    UIManager.Show(UIID.PromptTipUI, {
      title = data.title,
      autoClose = false,
      textContent = data.content,
      okText = data.rightButton,
      cancelText = data.leftButton,
      cancel = function()
        UIManager.Hide(UIID.PromptTipUI)
      end,
      ok = function()
        UIManager.Hide(UIID.PromptTipUI)
      end
    })
  end
end

function Login_LoginUI:ShowPolicyConfrimTips()
  if self.showPolicyConfrimTipsCoroutine ~= nil then
    return
  end
  if self.Img_pointOut ~= nil and self.lab_pointOut ~= nil then
    self.Img_pointOut:SetActive(true)
    
    local function LogoFuc()
      self.pointOutImgAnim = self.Img_pointOut.image:DOFade(1, 0)
      self.pointOutTextAnim = self.lab_pointOut.text:DOFade(1, 0)
      Coroutine.Wait(1)
      if self.Img_pointOut.image ~= nil then
        self.Img_pointOut.image:DOFade(0, 2)
        self.lab_pointOut.text:DOFade(0, 2)
      else
        logError("self.Img_pointOut.image==nil")
        return
      end
      Coroutine.Wait(2)
      self.Img_pointOut:SetActive(false)
      Coroutine.WaitForEndOfFrame()
      self.showPolicyConfrimTipsCoroutine = nil
    end
    
    self.showPolicyConfrimTipsCoroutine = Coroutine.Start(LogoFuc)
  else
    log("self.img_mapname==nil")
  end
end

function Login_LoginUI:btn_selectOnClick()
  if LoginData.OperEnum[LoginData.operId] == "xy" then
    if RoleDeclareManager.GetAmountState or LoginData.roleInfoConnectTimeOut then
      self:SetState(PanelStateEnum.SelectServer)
      self:GetServerInfo(WaitServer.NoWait)
    else
      UIManager.Show(UIID.WaitingUI, {
        msg = "\196\144ang t\225\186\163i th\195\180ng tin nh\195\162n v\225\186\173t"
      })
      if not RoleDeclareManager.StartRequest then
        RoleDeclareManager.GetRoleInformation()
      end
      self.needWaitAmountInfo = true
    end
  else
    self:SetState(PanelStateEnum.SelectServer)
    self:GetServerInfo(WaitServer.NoWait)
  end
end

function Login_LoginUI:btn_selectServerOnClick(ctr)
  LoginData.SetServer(LoginData.GetServer(ctr.id))
  self:OnConnectServerPanel()
end

function Login_LoginUI:btn_selectServerListOnClick(ctr)
  if ctr.serverListIndex == LoginData.xyServerListIndex then
    return
  end
  local preCtr = self.serverListContainer.items[LoginData.xyServerListIndex]
  if preCtr then
    preCtr.Checkmark:SetActive(false)
  end
  ctr.Checkmark:SetActive(true)
  local x, y = self.go_serverGroup:GetNormalizedPosition()
  self.go_serverGroup:SetNormalizedPosition(x, 1)
  LoginData.SwitchServerList(ctr.serverListIndex)
  self:GroupContainerSetData()
end

function Login_LoginUI:btn_selectGroupOnClick(ctr)
end

function Login_LoginUI:btn_backOnClick()
  LoginData.LogoutAccount()
  ActionStepsLogManager.SetRoleAction(ActionStepsType.LogOut)
  self:SetState(PanelStateEnum.InputLogin)
end

function Login_LoginUI:btn_UserDeleteOnClick()
  if LoginData.OperEnum[LoginData.operId] == "yinghe" then
    self:btn_backOnClick()
  else
    LoginData.LogoutAccount()
    ActionStepsLogManager.SetRoleAction(ActionStepsType.LogOut)
    self:SetState(PanelStateEnum.InputLogin)
    LoginController.AccountCancellation()
  end
end

function Login_LoginUI:btn_closeSelectServerOnClick()
  self:SetState(PanelStateEnum.ConnectServer)
end

function Login_LoginUI:btn_noticeOnClick()
  self:GetAnnouncementByOperId()
end

function Login_LoginUI:btn_closeNoticeOnClick()
  self.go_notice:SetActive(false)
  for i = 1, #self.announcementBtnItemTemp.items do
    local item = self.announcementBtnItemTemp.items[i]
    item.toggle.isOn = false
  end
  self.lab_content:SetText("")
end

function Login_LoginUI:RegistEvents()
  self:RegistEvent(Event.Net_ConnectFailed, self.OnConectFailed, self)
  self:RegistEvent(Event.Login_ConnectSuccess, self.OnResLoginMessage, self)
  self:RegistEvent(Event.Login_ResGetRoleList, self.OnResGetRoleList, self)
  self:RegistEvent(Event.Login_LoginSuccess, self.OnLoginSuccess, self)
  self:RegistEvent(Event.Login_LoginFail, self.OnLoginFail, self)
  self:RegistEvent(Event.Login_SDKLogin, self.OnSDKLogin, self)
  self:RegistEvent(Event.KoreaSDKChangePARTNER_CALLBACK, self.KoreaSDKChangePARTNER_CALLBACK, self)
  self:RegistEvent(Event.SDK_KOREA_LOGINFAILCALLBACK, self.SDK_KOREA_LOGINFAILCallback, self)
  self:RegistEvent(Event.SDK_ShowInfow, self.OnSDK_ShowInfow, self)
end

function Login_LoginUI:IsShowBtnNotice()
  local isShowBtn = FucShowOrHideController.FuncSystemIsOpen(4001002, true)
  if not isShowBtn then
    self.btn_notice:SetActive(false)
  else
    self.btn_notice:SetActive(true)
  end
end

function Login_LoginUI:OnSDK_ShowInfow(_, msg)
  local isShowBtn = FucShowOrHideController.FuncSystemIsOpen(4001001, true)
  if not isShowBtn then
    self.btn_information:SetActive(false)
    return
  end
  local num = tonumber(msg)
  if num == nil then
    return
  end
  if num == 1 then
    self.btn_information:SetActive(true)
  elseif num == 2 then
    self.btn_information:SetActive(false)
  end
end

function Login_LoginUI:OpenSDKCancelLoginTip()
  TipUtility.QuickShowPrompt({
    id = 42,
    isframe = true,
    autoClose = true,
    okAction = function()
      UIManager.Hide(UIID.PromptTipUI)
    end
  })
end

function Login_LoginUI:OpenSDKLoginFailTip()
  TipUtility.QuickShowPrompt({
    id = 41,
    cancelAction = function()
      EventManager.Dispatch(Event.Korea_SDKINITSDK)
      UIManager.Hide(UIID.PromptTipUI)
    end,
    okAction = function()
      CS.MuInterface.Instance:Login(self.tmeploginType)
    end
  })
end

function Login_LoginUI:SDK_KOREA_LOGINFAILCallback(_, code)
  EventManager.Dispatch(Event.KoreaSDKLog_CALLBACK, code)
  if type(code) ~= "number" then
    self:OpenSDKLoginFailTip()
    return
  end
  if code == 100202 or code == 100201 then
    self:OpenSDKCancelLoginTip()
  elseif code == 100211 or code == 100209 then
  else
    self:OpenSDKLoginFailTip()
  end
end

function Login_LoginUI:KoreaSDKChangePARTNER_CALLBACK(_, data)
  if not string.isNullOrEmpty(data) then
    LoginData.loginType = string.lower(data)
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(28)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = data.content,
        okText = data.rightButton,
        cancelText = data.leftButton,
        isframe = true,
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          self.go_KoreaSignIn3rd:SetActive(false)
          self.go_ConnectServer:SetActive(true)
          self.btn_changeChannel_apple:SetActive(true)
          self.btn_bindAccount:SetActive(false)
          self:OnRefresh()
        end
      })
    end
  else
    local data = ClientTable.cfg_Ui_promptwordManager:GetKoreaTipData(29)
    if data then
      UIManager.Show(UIID.PromptTipUI, {
        title = data.title,
        autoClose = false,
        textContent = data.content,
        okText = data.rightButton,
        cancelText = data.leftButton,
        isframe = true,
        cancel = function()
          UIManager.Hide(UIID.PromptTipUI)
        end,
        ok = function()
          self.go_KoreaSignIn3rd:SetActive(false)
          self.go_ConnectServer:SetActive(true)
          self.btn_changeChannel_apple:SetActive(true)
          self.btn_bindAccount:SetActive(true)
        end
      })
    end
  end
end

function Login_LoginUI:OnSDKLogin()
  self.btn_agreement:SetActive(PlatformData.GetIsShowUserAgrement())
  self.btn_loginSdk:SetActive(false)
end

function Login_LoginUI:OnLoginSuccess()
  ActionStepsLogManager.SetRoleAction(ActionStepsType.LoginGame)
  self:GetServerInfo(WaitServer.Wait)
  self:GetAnnouncementByOperId()
  RoleDeclareManager.GetRoleInformation()
  self:ShowPrivacyPolicy()
end

function Login_LoginUI:RefreshBtnGoGuest()
  if not string.isNullOrEmpty(LoginData.loginType) and LoginData.loginType == "guest" then
    self.btn_go_Guest:SetActive(false)
  else
    self.btn_go_Guest:SetActive(PlatformData.PlatformCheck(PlatformNameEnum.UNITY_IOS))
  end
end

function Login_LoginUI:OnLoginFail()
  CS.MuInterface.Instance:Login()
end

function Login_LoginUI:OnResGetRoleList(_)
  UIManager.Hide(UIID.LoginUI)
end

function Login_LoginUI:btn_copyIDOnClick(_)
  CS.MuInterface.Instance:CopyTextToDevice(CS.UnityEngine.SystemInfo.deviceUniqueIdentifier)
end

function Login_LoginUI:btn_sp1OnClick(_)
  sp1_count = sp1_count + 1
  sp2_count = 0
end

function Login_LoginUI:btn_sp2OnClick(_)
  sp2_count = sp2_count + 1
  if 10 < sp2_count and 5 < sp1_count then
    PlayerPrefs.SetInt("SUPER_PERMISSIONS", 1)
    if MuInterfaceLua.Instance.GetHotUpdateConfigUrl then
      TipUtility.ShowPP("\230\156\128\233\171\152\231\186\167\231\154\132\228\188\152\230\131\160")
      local txtPath = "version/debugPath.txt"
      local urlName = ""
      local localName = ""
      if PlatformData.PlatformCheck("Android") then
        urlName = "/Android/Version.json"
        localName = "http://10.40.0.106:8806/MuApk/"
      else
        urlName = "/iOS/Version.json"
        localName = "http://10.42.3.132:8807/"
      end
      local debugUrl = string.replace(MuInterfaceLua.Instance:GetHotUpdateConfigUrl(), urlName, "")
      local splits = string.split(debugUrl, "/")
      debugUrl = localName .. splits[#splits] .. urlName
      PersistantDataFile.SaveText(txtPath, debugUrl)
    end
  end
end

function Login_LoginUI:btn_loginSdkOnClick()
  LogManager.AddLoginLog("SDK_Login_Begin", "Login")
  CS.MuInterface.Instance:RemoveLoginSucListener()
  CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
  CS.MuInterface.Instance:Login()
end

function Login_LoginUI:btn_agreementOnClick()
  if CS.MuInterface.Instance.showUserAgrement then
    CS.MuInterface.Instance:showUserAgrement()
  end
  LoginController.CallSDKUserAgreement()
end

function Login_LoginUI:btn_clickWhiteOnClick()
  clickWhiteCount = clickWhiteCount + 1
  if 10 < clickWhiteCount then
    clickWhiteCount = 0
    LoginData.isClickComplete = true
    TipUtility.ShowPP("M\195\161y ch\225\187\167 whitelist \196\145\195\163 m\225\187\159")
    LoginData.SetServerList(LoginData.data.server_lists)
    LoginData.SortOutServerList()
    self:GroupContainerSetData()
  end
end

function Login_LoginUI:btn_AgeTipOnClick()
  self.go_AgeNotice:SetActive(true)
end

function Login_LoginUI:closeAgeOnClick()
  self.go_AgeNotice:SetActive(false)
end

function Login_LoginUI:OnResLoginMessage(_)
  if LoginData.reconnectState then
    return
  end
  UIManager.Hide(UIID.WaitingUI)
  LogManager.AddLoginLog("ReqGetRoleList_Begin ", "Login")
  NetManager.Send(UserMessage.ReqGetRoleList)
end

function Login_LoginUI:OnConectFailed()
  CS.LauncherUI.Close()
  UIManager.Hide(UIID.WaitingUI)
  TipUtility.ShowPrompt("tishi", "CennectServer_2")
end

function Login_LoginUI:Refresh()
  self:RefreshLogo()
  if CS.Main.instance.restart and CS.Main.instance.restartArgs then
    LoginData.GetVariant(CS.Main.instance.restartArgs)
  end
  local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(6206, "id")
  if audios then
    AudioManager.PlayBGM(audios.resourceName, audios.volume)
  end
  if LoginData.isSdk and LoginData.isSdkLogging then
    LoginData.panelState = PanelStateEnum.ConnectServer
  end
  self:RefreshSignInWith3rdShowSort()
  self:OnRefresh()
  self:ShowPrivacyPolicy()
  MainCamera.LoginAnimal()
  ActionStepsLogManager.SetRoleAction(ActionStepsType.LoginUI)
  if CS.Main.instance.restart then
    self:GetServerInfo(WaitServer.NoWait)
  end
  self.tog_PrivacyPolicy.toggle.isOn = LoginController.GetIsAgreePrivacyPolicy()
  self:ShowPrivacyPolicy()
end

function Login_LoginUI:RefreshSignInWith3rdShowSort()
  if PlatformData.PlatformCheck("iOS") then
    self.btn_go_Apple:SetAsFirstSibling()
  end
end

function Login_LoginUI:SetState(state)
  if LoginData.panelState ~= state then
    LoginData.panelState = state
    self:OnRefresh()
  end
end

function Login_LoginUI:OnRefresh()
  if LoginData.panelState == PanelStateEnum.InputLogin then
    self.go_selectServer:SetActive(false)
    self.go_LoginInput:SetActive(not LoginData.isSdk)
    self.go_ConnectServer:SetActive(false)
    self.btn_bindAccount:SetActive(false)
    self.btn_changeChannel_apple:SetActive(false)
    self.btn_loginSdk:SetActive(LoginData.isSdk)
    if LoginData.isSdk then
      LogManager.AddLoginLog("SDK_Login_Begin", "Login")
      CS.MuInterface.Instance:RemoveLoginSucListener()
      CS.MuInterface.Instance:BindLoginSucListener(SdkLoginSuc)
      CS.MuInterface.Instance:Login()
    end
  elseif LoginData.panelState == PanelStateEnum.SelectServer then
    self.go_selectServer:SetActive(true)
    self.go_LoginInput:SetActive(false)
    self.go_KoreaSignIn3rd:SetActive(false)
    self.go_ConnectServer:SetActive(false)
    self.btn_changeChannel_apple:SetActive(false)
    self.btn_bindAccount:SetActive(false)
    self.btn_loginSdk:SetActive(false)
  elseif LoginData.panelState == PanelStateEnum.ConnectServer then
    self.go_selectServer:SetActive(false)
    self.go_LoginInput:SetActive(false)
    self.go_KoreaSignIn3rd:SetActive(false)
    self.go_ConnectServer:SetActive(true)
    self.btn_changeChannel_apple:SetActive(true)
    if LoginData.loginType then
      self:SetSprite("Atlas_Language", self.btn_changeChannel_apple.gameObject.name .. "_" .. LoginData.loginType, self.btn_changeChannel_apple)
    end
    if LoginData.loginType == "guest" then
      self.btn_bindAccount:SetActive(false)
    else
      self.btn_bindAccount:SetActive(false)
    end
    self.btn_loginSdk:SetActive(false)
    LoginData.ChangeOftenServer()
  end
  self:RefreshBtnBack()
  self:RefreshAgreement()
  self:RefreshBtnGoGuest()
  if not LoginData.needReconnect then
    logError("\233\135\141\230\150\176\232\191\158\230\142\165\229\144\142\229\176\177\229\143\175\228\187\165\229\164\141\229\142\159\228\186\134.")
    LoginData.needReconnect = true
  end
end

function Login_LoginUI:RefreshBtnBack()
  local isHideBtnBack = false
  local isHideBtnUserDelete = false
  if LoginData.OperEnum[LoginData.operId] == "yinghe" then
    isHideBtnBack = true
  else
    isHideBtnUserDelete = true
  end
  if LoginData.OperEnum[LoginData.operId] == "tanwan" then
    isHideBtnBack = false
    isHideBtnUserDelete = false
  end
  if isHideBtnBack then
    self.btn_back:SetActive(false)
  else
    self.btn_back:SetActive(LoginData.panelState ~= PanelStateEnum.InputLogin)
  end
  if isHideBtnUserDelete then
    self.btn_UserDelete:SetActive(false)
  else
    self.btn_UserDelete:SetActive(LoginData.panelState ~= PanelStateEnum.InputLogin)
  end
end

function Login_LoginUI:RefreshAgreement()
  self.btn_agreement:SetActive(LoginData.OperEnum[LoginData.operId] == "tanwan")
end

function Login_LoginUI:LocalInit()
end

function Login_LoginUI:ExecuteTextOrder(control, eventData, key)
  if key == "[link:1]" then
    UIManager.Show(UIID.Login_UserRegistrationUI)
    return
  end
  if key == "[link:2]" then
    UIManager.Show(UIID.Login_UserPrivacyUI)
    return
  end
  if key == "[link:3]" then
    UIManager.Show(UIID.Login_ChildProtectionUI)
    return
  end
  if key == "[link:4]" then
    UIManager.Show(UIID.Login_ThirdInformationUI)
    return
  end
end

function Login_LoginUI:InitLanguageOptions()
  self.btn_dropdown_language:ClearOptions()
  self.btn_dropdown_language:AddOptions(ClientTable.cfg_Language_languageManager:GetOptionDataList())
end

function Login_LoginUI:RefreshLanguage()
  self.btn_dropdown_language:SetActive(table.count(ClientTable.cfg_Language_languageManager:GetLanguageSortList()) > 1)
  self.btn_dropdown_language:SetSelectValue(Localization:GetCurSelectIndex())
  local spriteName = ClientTable.cfg_Language_languageManager:GetDisplayedLanguageSprite()
  if spriteName then
    self:SetSprite("Atlas_Login", spriteName, self.btn_dropdown_language)
  end
end

function Login_LoginUI:OnDropDownValueChangedCallback(ui, index)
  if Localization:GetCurSelectIndex() == index then
    return
  end
  local newLanguageCfg = ClientTable.cfg_Language_languageManager:GetLanguageSortList()[index + 1]
  local uiword = ""
  local langaugeStr = ""
  local newLang = newLanguageCfg.languageAcronym
  if newLanguageCfg.languageAcronym ~= "CN" then
    uiword = ClientTable.cfg_Ui_promptwordManager:TryGetValue(83)
    langaugeStr = uiword["content_" .. newLanguageCfg.languageAcronym]
  else
    langaugeStr = string.split(ClientTable.cfg_Global_globalManager:TryGetValue(2430022).effect, "&")[2]
  end
  local tipData = {
    id = 83,
    newLang = newLang,
    contentFormatArgs = string.format(langaugeStr, newLanguageCfg.showText),
    closeCallBack = function()
      self:RefreshLanguage()
    end,
    cancelAction = function()
      self:RefreshLanguage()
    end,
    okAction = function()
      if newLanguageCfg then
        Localization:SetLanguage(newLanguageCfg.languageAcronym)
      end
    end
  }
  TipUtility.QuickShowPrompt(tipData)
end

function Login_LoginUI:OnLanguageChanged()
  self.root:SetActive(false)
  self.root:SetActive(true)
  self:RefreshByLanguage()
  self:Refresh()
end
