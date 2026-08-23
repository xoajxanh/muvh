require("GameModel/VoiceData")
require("GameConst/TxVoiceEnum")
require("GamePlay/Voice/TXVoiceInterfaceClient")
require("GamePlay/Voice/YvVoiceListener")
VoiceManager = {}
local this = VoiceManager
local voiceSDKInstance
local MuInterface = CS.MuInterface.Instance

function VoiceManager.Init()
  local configJson = ""
  if CS.MuInterface.Instance.GetVersionConfig then
    configJson = CS.MuInterface.Instance:GetVersionConfig()
  end
  if not string.isNullOrEmpty(configJson) then
    local config = json.decode(configJson)
    if not string.isNullOrEmpty(config.voiceOpen) then
      VoiceUtility.isOpenVoice = tonumber(config.voiceOpen) == 1
    end
  end
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  VoiceData.VoiceVersion = VoiceUtility.GetVoiceVersion()
  this.InitEvents()
end

function VoiceManager.VoiceSDKInstance()
  if voiceSDKInstance == nil then
    voiceSDKInstance = TXVoiceInterfaceClient
  end
  return voiceSDKInstance
end

function VoiceManager.RequestVoicePermission()
  if not VoiceData.HasVoicePermission then
    VoiceData.HasVoicePermission = MuInterface:CheckVoicePermission(true)
  end
end

function VoiceManager.OnEnterGame()
  if VoiceData.isResetVoice then
    VoiceData.isResetVoice = false
    this.InitVoiceDrive()
  end
  this.InitVoiceSDK()
end

function VoiceManager.InitVoiceSDK()
  this.VoiceSDKInstance():ChatLength(IndexerEnum.set, 60000)
  this.VoiceSDKInstance():str_userId(IndexerEnum.set, tostring(LoginData.userId))
  this.VoiceSDKInstance():InitVoiceSDK()
end

function VoiceManager.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.ResetVoice)
  this.eventContainer:Regist(Event.GamePlay_Leave, this.ResetVoice)
  this.eventContainer:Regist(Event.Game_ApplicationQuit, this.LogoutGame)
  YvVoiceListener.ResetListener()
  YvVoiceListener.BindLoginListener(this.OnVoiceLoginStateUpdate)
  YvVoiceListener.BindChatMicListener(this.OnVoiceSpeakStateUpdate)
  YvVoiceListener.BindPausePlayRealAudioListener(this.OnVoiceListerStateUpdate)
  YvVoiceListener.BindVoiceOnlineRecognizeReqing(this.OnVoiceOnlineRecognizeReqingDeal)
  YvVoiceListener.BindSendMsgToServer(this.OnSendMsgToServer)
end

function VoiceManager.UnRegistEvent()
  this.eventContainer:UnRegistAll()
end

function VoiceManager.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

local function UnInit()
  YvVoiceListener.RemoveLoginListener(this.OnVoiceLoginStateUpdate)
  YvVoiceListener.RemoveChatMicListener(this.OnVoiceSpeakStateUpdate)
  YvVoiceListener.RemovePausePlayRealAudioListener(this.OnVoiceListerStateUpdate)
  YvVoiceListener.RemoveVoiceOnlineRecognizeReqing(this.OnVoiceOnlineRecognizeReqingDeal)
  YvVoiceListener.RemoveSendMsgToServer(this.OnSendMsgToServer)
  this.UnRegistMessages()
  this.UnRegistEvent()
end

local function JudgeFunctionOpen()
  VoiceUtility.InitSpChar()
end

function VoiceManager.LoginSuccessful()
end

function VoiceManager.EnterRoom()
  if VoiceManager.VoiceSDKInstance() ~= nil and not VoiceData.isLoginRes and LoginData.InGame and VoiceUtility.isAllowYvVoice() then
    VoiceData.isLoginRes = true
    this.Login(VoiceLoginType.common, this.LoginSuccessful)
  end
end

function VoiceManager.Reconnect(msgId, data)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  if VoiceData.isLogin then
    this.Login(VoiceData.mLoginType, this.LoginSuccessful)
  end
  JudgeFunctionOpen()
end

function VoiceManager.OnVoiceLoginStateUpdate(state)
  logPurple("\196\144\196\131ng nh\225\186\173p:", state)
  VoiceData.isLogin = state
  if not VoiceData.isLogin then
    VoiceData.isOpenVoiceListener = false
    VoiceData.isOpenVoiceSpeak = false
  else
    if VoiceData.VoiceRoomID == VoiceData.serverRoom then
      this.SwitchVoiceListerState(nil, true, true)
    else
      this.SwitchVoiceListerState(nil, true, false)
      this.SwitchVoiceSpeakState(nil, true, false)
    end
    VoiceData.isOpenVoiceListener = true
    VoiceData.isOpenVoiceSpeak = true
  end
  VoiceData.AutoPlayAudioList = List:New()
  VoiceData.isAutoPlayingAudio = false
end

function VoiceManager.OnVoiceSpeakStateUpdate(state)
  logPurple("Micro:", state)
  VoiceData.isOpenVoiceSpeak = state
  AudioManager.SetEnable(not VoiceData.isOpenVoiceSpeak)
end

function VoiceManager.OnVoiceListerStateUpdate(state)
  logPurple("Nghe gi\225\187\141ng n\195\179i:", state)
  VoiceData.isOpenVoiceListener = state
end

function VoiceManager.OnVoiceOnlineRecognizeReqingDeal(msg)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  local strs = string.split(msg, "#")
  local chatMsg = strs[1]
  local text = strs[2]
  local translate = strs[3]
  local OlineTranslateText = VoiceUtility.ReplaceSpChar(strs[4])
  chatMsg = string.replace(chatMsg, text, OlineTranslateText)
  chatMsg = string.replace(chatMsg, translate, OlineTranslateText)
end

function VoiceManager.OnSendMsgToServer(voiceMsg)
  local voiceStr = string.split(voiceMsg, "#")
  local code = tonumber(voiceStr[1])
  if code == 0 or code == 32777 then
    local fileId = string.split(voiceStr[2], ":")
    local inputData = {
      type = ChatInfoEnum.Voice,
      fileId = fileId[2],
      voiceTime = tonumber(voiceStr[4])
    }
    local data = {
      inputData = inputData,
      message = voiceStr[3]
    }
    EventManager.Dispatch(Event.Chat_SendMessage, data)
  elseif code == VoiceErrorEnum.VoiceLengthShort then
    FloatingTipUtility.QuickMsg("Th\225\187\157i gian ghi \195\162m qu\195\161 ng\225\186\175n")
  else
    FloatingTipUtility.QuickMsg("Ghi \195\162m th\225\186\165t b\225\186\161i")
  end
end

function VoiceManager.Update()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.VoiceSDKInstance():Update()
  this.UpdateAutoPlayAudio()
  this.UpdateVoiceOnlineRecognizeReqing()
end

local function VoiceOnlineRecongnizeCall(str)
  VoiceData.ChatMessageList:RemoveAt(1)
  VoiceData.isVoiceOnlineRecognizeReqing = false
end

function VoiceManager.UpdateVoiceOnlineRecognizeReqing()
  if VoiceData.ChatMessageList:Count() > 0 and not VoiceData.isVoiceOnlineRecognizeReqing then
    VoiceData.isVoiceOnlineRecognizeReqing = true
    local msg = VoiceData.ChatMessageList:GetItemByIndex(1)
    this.VoiceSDKInstance():SpeechDiscernByUrl(msg, VoiceOnlineRecongnizeCall)
  end
end

local function VoiceManagerCall(msg)
  VoiceData.AutoPlayAudioList:RemoveAt(1)
  YvVoiceListener.CallBackAction(ListenerTypeEnum.OnVoicePlayListener)
end

function VoiceManager.UpdateAutoPlayAudio()
  if VoiceData.AutoPlayAudioList:Count() > 0 and not VoiceData.isAutoPlayingAudio then
    local isSuccessPlayerAudio = this.PlayAudio(VoiceData.AutoPlayAudioList:GetItemByIndex(1), VoiceManagerCall)
    if not isSuccessPlayerAudio then
      VoiceData.AutoPlayAudioList:Clear()
      VoiceData.isAutoPlayingAudio = false
    end
  end
end

function VoiceManager.Login(mType, response)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  VoiceData.isRuningRecord = false
  VoiceData.mLoginType = mType
  VoiceData.isPlayingAudio1 = false
  VoiceData.isPlayingAudio2 = false
  VoiceData.isRecordAudio = false
  VoiceData.CallbackUrl = ""
  if mType == VoiceLoginType.common then
    this.VoiceSDKInstance():Login(ViewData.meData.name, tostring(LoginData.userId), VoiceData.serverRoom, response)
  end
end

function VoiceManager.Logout(response)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.VoiceSDKInstance():Logout(response)
end

local mSpeakTargetState = false
local mSpeakResponse

local function OnSwitchVoiceSpeakCall(msg)
  this.VoiceSDKInstance():ChatMic(mSpeakTargetState, "", mSpeakResponse)
  mSpeakTargetState = false
  mSpeakResponse = nil
end

function VoiceManager.SwitchVoiceSpeakState(response, constraint, constraintOpen)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  local targetState = constraint and constraintOpen or not VoiceData.isOpenVoiceSpeak
  if (not VoiceUtility.JudgeVoiceLimit(VoiceLimitType.RealTime) or not VoiceUtility.JudgeSpeakLimit()) and targetState then
    return
  end
  if targetState and not VoiceData.HasVoicePermission then
    FloatingWordUtility.QuickMsg("H\195\163y m\225\187\159 quy\225\187\129n h\225\186\161n voice")
    this.RequestVoicePermission()
    return
  end
  if not this.VoiceSDKInstance():IsLogin(IndexerEnum.get) then
    mSpeakTargetState = targetState
    mSpeakResponse = response
    this.Login(VoiceData.mLoginType, OnSwitchVoiceSpeakCall)
  else
    this.VoiceSDKInstance():ChatMic(targetState, "", response)
  end
end

local mListerTargetState = false
local mListerResponse

local function OnSwitchVoiceListerCall(msg)
  this.VoiceSDKInstance():SetPausePlayRealAudio(mListerTargetState, mListerResponse)
end

function VoiceManager.SwitchVoiceListerState(response, constraint, constraintClose)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  if not VoiceUtility.JudgeVoiceLimit(VoiceLimitType.RealTime) then
    return
  end
  local targetState = constraint and constraintClose or VoiceData.isOpenVoiceListener
  if not this.VoiceSDKInstance().IsLogin then
    mListerTargetState = targetState
    this.Login(VoiceData.mLoginType, OnSwitchVoiceListerCall)
  else
    this.VoiceSDKInstance():SetPausePlayRealAudio(targetState, response)
  end
end

function VoiceManager.Resume()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.VoiceSDKInstance():Resume()
  VoiceData.HasVoicePermission = MuInterface:CheckVoicePermission(false)
end

function VoiceManager.Pause()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.VoiceSDKInstance():Pause()
end

function VoiceManager.StartRecord(savePath, extend, _channel, sendToName, luYingResponse, UploadResponse, args)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  if VoiceData.isBanAllVoice then
    FloatingWordUtility.QuickMsg("C\225\186\163nh \196\145\225\186\183c bi\225\187\135t, kh\195\180ng \196\145\198\176\225\187\163c ph\195\169p ph\195\161t gi\225\187\141ng n\195\179i")
    return false
  end
  if VoiceData.isRuningRecord then
    FloatingWordUtility.QuickMsg("G\225\187\173i gi\225\187\141ng n\195\179i qu\195\161 th\198\176\225\187\157ng xuy\195\170n, vui l\195\178ng th\225\187\173 l\225\186\161i sau!")
    return false
  end
  if VoiceData.isOpenVoiceSpeak then
    FloatingWordUtility.QuickMsg("Kh\195\180ng th\225\187\131 g\225\187\173i tin nh\225\186\175n tho\225\186\161i khi \196\145ang b\225\186\173t gi\225\187\141ng n\195\179i th\225\187\157i gian th\225\187\177c!")
    return false
  end
  AudioManager.SetEnable(false)
  this.VoiceSDKInstance():StartRecord(savePath, extend, _channel, sendToName, luYingResponse, UploadResponse, args)
  return true
end

function VoiceManager.StopRecord()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.VoiceSDKInstance():StopRecord()
end

function VoiceManager.OpenAudio()
  VoiceData.isPlayingAudio1 = false
  AudioManager.SetEnable(not VoiceData.isPlayingAudio1)
end

function VoiceManager.PlayAudio(url, response)
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  if VoiceData.isBanAllVoice then
    FloatingWordUtility.QuickMsg("C\225\186\163nh \196\145\225\186\183c bi\225\187\135t, kh\195\180ng \196\145\198\176\225\187\163c ph\195\169p ph\195\161t gi\225\187\141ng n\195\179i")
  end
  url = string.format("https:%s", url)
  if VoiceData.isPlayingAudio1 == true then
    VoiceData.CallbackUrl = url
    VoiceData.isPlayingAudio2 = true
    this.StopAudio()
    return
  end
  VoiceManager.PlayAudioCall(url)
end

function VoiceManager.PlayAudioCall(url)
  VoiceData.isPlayingAudio1 = true
  AudioManager.SetEnable(not VoiceData.isPlayingAudio1)
  this.VoiceSDKInstance():PlayAudio(url, VoiceManager.OpenAudio)
  VoiceData.CallbackUrl = ""
end

function VoiceManager.StopAudio()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  return this.VoiceSDKInstance():StopAudio()
end

function VoiceManager.LogoutGame()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.Logout()
  this.VoiceSDKInstance():LogoutGame()
end

function VoiceManager.LogoutAccount()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  UnInit()
  this.VoiceSDKInstance():LogoutAccount()
end

function VoiceManager.ResetVoice()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  if VoiceData.isPlayingAudio1 or VoiceData.isPlayingAudio2 then
    VoiceData.isResetVoice = true
    this.VoiceSDKInstance():StopAudio()
  else
    VoiceManager.InitVoiceDrive()
  end
  AudioManager.SetEnable(true)
end

function VoiceManager.InitVoiceDrive()
  if not VoiceUtility.isAllowYvVoice() then
    return
  end
  this.VoiceSDKInstance():Logout(nil)
  this.VoiceSDKInstance():LogoutAccount()
  this.VoiceSDKInstance():LogoutGame()
end

function VoiceManager.GetCurPlayAudioFileId()
  return this.VoiceSDKInstance():GetCurPlayAudioFileId()
end

this.Init()
