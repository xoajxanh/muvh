require("GamePlay/Voice/ClientVoiceState")
TXVoiceInterfaceClient = {}
local this = TXVoiceInterfaceClient
this.ScriptName = "TXVoiceInterfaceClient"
this.str_appId = "1400689422"
this.key = "EH4aqpXy93jAKErD"
this.mstr_userId = ""
this.chatLength = 60000
this.curPlayFileId = nil

function TXVoiceInterfaceClient:ChatLength(_indexer, _value)
  if _indexer == IndexerEnum.get then
    return this.chatLength
  else
    this.chatLength = _value
  end
end

function TXVoiceInterfaceClient:str_userId(_indexer, _value)
  if _indexer == IndexerEnum.get then
    if PlatformData.PlatformCheck(PlatformNameEnum.UNITY_STANDALONE_WIN) then
      return this.mstr_userId
    else
      if string.isNullOrEmpty(this.mstr_userId) then
        this.mstr_userId = tostring(Random.Range(100010, 100080))
      end
      return this.mstr_userId
    end
  else
    this.mstr_userId = _value
  end
end

this.RecordVoiceFolder = Application.persistentDataPath .. "/"
this.DownVoiceFolder = Application.persistentDataPath .. "/"

function TXVoiceInterfaceClient:IsLogin(_indexer, _value)
  if _indexer == IndexerEnum.get then
    local state = ITMGContext.GetInstance():IsRoomEntered()
    return state
  end
end

this.isInit = false
this.authBuffer = nil
this.LXAuthBuffer = nil
this.isInitListener = false
this.voiceData = nil

function TXVoiceInterfaceClient:ClientVoiceStateInstance()
  if this.voiceData == nil then
    this.voiceData = ClientVoiceState
  end
  return this.voiceData
end

this.OnEnterRoomCompleteEventDelegate = nil
this.OnExitRoomCompleteEventDelegate = nil
this.OnRoomDisconnectEventDelegate = nil
this.OnStreamingSpeechCompleteDelegate = nil
this.OnSpeechToTextCompleteDelegate = nil
this.OnDownloadFileCompleteDelegate = nil
this.OnPlayFileCompleteDelegate = nil
this.OnUploadFileCompleteDelegate = nil

function TXVoiceInterfaceClient:InitVoiceSDK()
  this.voiceData = self:ClientVoiceStateInstance()
  ITMGContext.GetInstance():SetLogLevel(0, 0)
  if string.isNullOrEmpty(this.str_appId) or string.isNullOrEmpty(this:str_userId(IndexerEnum.get)) then
    return
  end
  this.isInit = true
  local ret = ITMGContext.GetInstance():Init(this.str_appId, this:str_userId(IndexerEnum.get))
  if ret ~= QAVError.OK then
    return
  end
  if not this.isInitListener then
    this.isInitListener = true
    this:InitVoiceDelegate()
    ITMGContext.GetInstance():OnEnterRoomCompleteEvent("+", this.OnEnterRoomCompleteEventDelegate)
    ITMGContext.GetInstance():OnExitRoomCompleteEvent("+", this.OnExitRoomCompleteEventDelegate)
    ITMGContext.GetInstance():OnRoomDisconnectEvent("+", this.OnRoomDisconnectEventDelegate)
    ITMGContext.GetInstance():GetPttCtrl():OnStreamingSpeechComplete("+", this.OnStreamingSpeechCompleteDelegate)
    ITMGContext.GetInstance():GetPttCtrl():OnSpeechToTextComplete("+", this.OnSpeechToTextCompleteDelegate)
    ITMGContext.GetInstance():GetPttCtrl():OnDownloadFileComplete("+", this.OnDownloadFileCompleteDelegate)
    ITMGContext.GetInstance():GetPttCtrl():OnPlayFileComplete("+", this.OnPlayFileCompleteDelegate)
    ITMGContext.GetInstance():GetPttCtrl():OnUploadFileComplete("+", this.OnUploadFileCompleteDelegate)
    this.LXAuthBuffer = this:GetAuthBuffer(this.str_appId, this:str_userId(IndexerEnum.get), nil)
    ret = ITMGContext.GetInstance():GetPttCtrl():ApplyPTTAuthbuffer(this.LXAuthBuffer)
    ITMGContext.GetInstance():GetPttCtrl():SetMaxMessageLength(this.chatLength)
  end
end

function TXVoiceInterfaceClient:InitVoiceDelegate()
  if this.OnEnterRoomCompleteEventDelegate == nil then
    function this.OnEnterRoomCompleteEventDelegate(_err, _errInfo)
      QAVEnterRoomComplete(self:OnEnterRoomComplete(_err, _errInfo))
    end
  end
  if this.OnExitRoomCompleteEventDelegate == nil then
    function this.OnExitRoomCompleteEventDelegate()
      QAVExitRoomComplete(self:OnExitRoomCompleteEvent())
    end
  end
  if this.OnRoomDisconnectEventDelegate == nil then
    function this.OnRoomDisconnectEventDelegate(_result, _error_info)
      QAVRoomDisconnect(self:OnRoomDisconnectEvent(_result, _error_info))
    end
  end
  if this.OnStreamingSpeechCompleteDelegate == nil then
    function this.OnStreamingSpeechCompleteDelegate(_code, _fileid, _filePath, _result)
      QAVStreamingRecognitionCallback(self:OnStreamingSpeechComplete(_code, _fileid, _filePath, _result))
    end
  end
  if this.OnSpeechToTextCompleteDelegate == nil then
    function this.OnSpeechToTextCompleteDelegate(_code, _fileid, _result)
      QAVSpeechToTextCallback(self:OnSpeechToTextComplete(_code, _fileid, _result))
    end
  end
  if this.OnDownloadFileCompleteDelegate == nil then
    function this.OnDownloadFileCompleteDelegate(_code, _filepath, _fileid)
      QAVDownloadFileCompleteCallback(self:OnDownloadFileComplete(_code, _filepath, _fileid))
    end
  end
  if this.OnPlayFileCompleteDelegate == nil then
    function this.OnPlayFileCompleteDelegate(_code, _filepath)
      QAVPlayFileCompleteCallback(self:OnPlayFileComplete(_code, _filepath))
    end
  end
  if this.OnUploadFileCompleteDelegate == nil then
    function this.OnUploadFileCompleteDelegate(_code, _filepath, _fileid)
      QAVUploadFileCompleteCallback(self:OnUploadFileComplete(_code, _filepath, _fileid))
    end
  end
end

function TXVoiceInterfaceClient:GetAuthBuffer(_appId, _userId, _roomId)
  return QAVAuthBuffer.GenAuthBuffer(tonumber(_appId), _roomId, _userId, this.key)
end

this.loginResponse = nil

function TXVoiceInterfaceClient:Login(_name, _uid, _roomID, _response)
  if not this.isInit then
    if PlatformData.PlatformCheck(PlatformNameEnum.UNITY_STANDALONE_WIN) then
      this.mstr_userId = _uid
    end
    local userid = 0
    if not string.isNullOrEmpty(this:str_userId(IndexerEnum.get)) and tonumber(this:str_userId(IndexerEnum.get)) then
      userid = tonumber(this:str_userId(IndexerEnum.get))
      this:InitVoiceSDK()
    else
      return
    end
  end
  if this:IsLogin(IndexerEnum.get) then
    this:Logout(function(obj)
      this:Login(_name, _uid, _roomID, _response)
      return
    end)
  end
  this.authBuffer = this:GetAuthBuffer(this.str_appId, this:str_userId(IndexerEnum.get), _roomID)
  this.loginResponse = _response
  if ITMGRoomTypeEnum then
    local ret = ITMGContext.GetInstance():EnterRoom(_roomID, ITMGRoomTypeEnum.ITMG_ROOM_TYPE_FLUENCY, this.authBuffer)
  end
end

function TXVoiceInterfaceClient:OnEnterRoomComplete(_err, _errInfo)
  if _err ~= 0 or _err ~= nil then
    return
  end
  YvVoiceListener.CallBackAction(ListenerTypeEnum.OnLoginListener, this:IsLogin(IndexerEnum.get))
  if this.loginResponse ~= nil then
    this.loginResponse("")
    this.loginResponse = nil
  end
end

this.logoutResponse = nil

function TXVoiceInterfaceClient:Logout(_response)
  this.logoutResponse = _response
  ITMGContext.GetInstance():ExitRoom()
  ITMGContext.GetInstance():GetAudioCtrl():EnableMic(false)
end

function TXVoiceInterfaceClient:LogoutGame()
  ITMGContext.GetInstance():Uninit()
  this.isInit = false
end

function TXVoiceInterfaceClient:OnExitRoomCompleteEvent()
  ITMGContext.GetInstance():GetAudioCtrl():EnableMic(false)
  YvVoiceListener.CallBackAction(ListenerTypeEnum.OnLoginListener, this:IsLogin(IndexerEnum.get))
  if this.logoutResponse ~= nil then
    this.logoutResponse("")
  end
  this.logoutResponse = nil
end

function TXVoiceInterfaceClient:OnRoomDisconnectEvent(_result, error_info)
  YvVoiceListener.CallBackAction(ListenerTypeEnum.OnLoginListener, this:IsLogin(IndexerEnum.get))
end

function TXVoiceInterfaceClient:ChatMic(_onOff, _expand, _response)
  local state = ITMGContext.GetInstance():GetAudioCtrl():EnableMic(_onOff)
  YvVoiceListener.CallBackAction(ListenerTypeEnum.OnChatMicListener, _onOff)
  if _response ~= nil then
    _response("")
  end
end

function TXVoiceInterfaceClient:SetPausePlayRealAudio(_isPause, _response)
  ITMGContext.GetInstance():GetAudioCtrl():EnableSpeaker(not _isPause)
  YvVoiceListener.CallBackAction(ListenerTypeEnum.OnPausePlayRealAudioListener, not _isPause)
  if _response ~= nil then
    _response("")
  end
end

this.extend = nil
this._channel = 0
this.sendToName = 0
this.luYingResponse = nil
this.UploadResponse = nil
this.args = nil

function TXVoiceInterfaceClient:StartRecord(_savePath, _extend, _channel, _sendToName, _luYingResponse, _UploadResponse, _args)
  local retState = 0
  if ITMGContext.GetInstance():GetAudioCtrl():GetMicState() == 0 then
    retState = ITMGContext.GetInstance():GetAudioCtrl():EnableMic(true)
  end
  this.extend = _extend
  this._channel = _channel
  this.sendToName = _sendToName
  this.luYingResponse = _luYingResponse
  this.UploadResponse = _UploadResponse
  this.args = _args
  local recordPath = this.RecordVoiceFolder .. string.format("%s.silk", "txvoice")
  VoiceData.isRecordAudio = true
  local ret = ITMGContext.GetInstance():GetPttCtrl():StartRecordingWithStreamingRecognition(recordPath, "cmn-Hans-CN")
end

function TXVoiceInterfaceClient:StopRecord()
  local reuslt = ITMGContext.GetInstance():GetPttCtrl():StopRecording()
end

function TXVoiceInterfaceClient:OnStreamingSpeechComplete(_code, _fileid, _filePath, _result)
  if this.voiceData:CancelLuying(IndexerEnum.get) then
    this.voiceData:RuningRecord(IndexerEnum.set, false)
    this.voiceData:CancelLuying(IndexerEnum.set, false)
    return
  end
  if _code == 0 or _code == 32777 then
    local fileDuration = ITMGContext.GetInstance():GetPttCtrl():GetVoiceFileDuration(_filePath)
    if string.isNullOrEmpty(_result) then
      _result = "..."
    end
    _result = string.format("%s#%s#%s#%s", tostring(_code), _fileid, _result, tostring(fileDuration))
    YvVoiceListener.CallBackAction(ListenerTypeEnum.OnSendMsgToServer, _result)
    if this.luYingResponse ~= nil then
      this.luYingResponse(_result)
    end
    ITMGContext.GetInstance():GetPttCtrl():UploadRecordedFile(_filePath)
  else
    _result = string.format("%s", tostring(_code))
    YvVoiceListener.CallBackAction(ListenerTypeEnum.OnSendMsgToServer, _result)
  end
end

this.defaultTranslate = "..."

function TXVoiceInterfaceClient:OnUploadFileComplete(_code, _filepath, _fileid)
  if _code == 0 then
    local fileDuration = ITMGContext.GetInstance():GetPttCtrl():GetVoiceFileDuration(_filepath)
    this.extend = this.extend .. "#" .. this.defaultTranslate
    if this.UploadResponse ~= nil and this.args then
      this.UploadResponse(this.args)
    end
  else
    print("[FF0000FF]\232\175\173\233\159\179\228\184\138\228\188\160\229\164\177\232\180\165")
  end
end

this.PlayAudioResponse = nil

function TXVoiceInterfaceClient:PlayAudio(_url, _response)
  if this.voiceData:AutoPlayingAudio(IndexerEnum.get) then
    return false
  end
  this.PlayAudioResponse = _response
  this.voiceData:AutoPlayingAudio(IndexerEnum.set, true)
  local lastXG = string.lastIndexOf(_url, "/")
  local lastDian = string.lastIndexOf(_url, ".")
  local filename
  if lastXG < lastDian then
    filename = string.sub(_url, lastXG + 1, lastDian)
  else
    filename = string.sub(_url, lastXG + 1)
  end
  local folder = this.DownVoiceFolder .. "voice/"
  if not Directory.Exists(folder) then
    Directory.CreateDirectory(folder)
  end
  local filePath = folder .. string.format("%s.silk", filename)
  if File.Exists(filePath) then
    this:OnDownloadFileComplete(0, filePath, _url)
    return
  end
  local ret = ITMGContext.GetInstance():GetPttCtrl():DownloadRecordedFile(_url, filePath)
  return true
end

function TXVoiceInterfaceClient:OnDownloadFileComplete(_code, _filepath, fileid)
  this.curPlayFileId = fileid
  if not string.isNullOrEmpty(_filepath) then
    local playResult = ITMGContext.GetInstance():GetPttCtrl():PlayRecordedFile(_filepath)
  else
    this.voiceData:AutoPlayingAudio(IndexerEnum.set, false)
    if this.PlayAudioResponse ~= nil then
      this.PlayAudioResponse("")
    end
    this.PlayAudioResponse = nil
  end
  EventManager.Dispatch(Event.Chat_VoicePlay, fileid)
end

function TXVoiceInterfaceClient:OnPlayFileComplete(_code, _filepath)
  this.curPlayFileId = nil
  this.voiceData:AutoPlayingAudio(IndexerEnum.set, false)
  if this.PlayAudioResponse ~= nil then
    this.PlayAudioResponse("")
  end
  this.PlayAudioResponse = nil
  if VoiceData.isPlayingAudio2 then
    VoiceData.isPlayingAudio2 = false
    if not string.isNullOrEmpty(VoiceData.CallbackUrl) then
      VoiceManager.PlayAudioCall(VoiceData.CallbackUrl)
    end
  end
  if VoiceData.isRecordAudio then
    VoiceData.isRecordAudio = false
    AudioManager.SetEnable(false)
  end
  if VoiceData.isResetVoice then
    VoiceData.isResetVoice = false
    VoiceManager.InitVoiceDrive()
  end
  EventManager.Dispatch(Event.Chat_VoiceStop)
end

function TXVoiceInterfaceClient:GetCurPlayAudioFileId()
  return this.curPlayFileId
end

function TXVoiceInterfaceClient:StopAudio()
  ITMGContext.GetInstance():GetPttCtrl():StopPlayFile()
  this.voiceData:AutoPlayingAudio(IndexerEnum.set, false)
end

function TXVoiceInterfaceClient:SpeechDiscernByUrl(_chatMsg, _resp)
  local msgs = string.split(_chatMsg, "$")
  if #msgs < 6 then
    return
  end
  local url = msgs[3]
  local duration = tonumber(msgs[4])
  self:SpeechDiscernByUrl(0, 0, url, duration, "", function(str)
    local OlineTranslateText
    local text = msgs[5]
    local exts = string.split(msgs[6], "#")
    if string.isNullOrEmpty(url) or #exts < 4 then
      return
    end
    local translate = tostring(exts[4])
    OlineTranslateText = string.isNullOrEmpty(str) and "..." or str
    _chatMsg = _chatMsg .. "#" .. text .. "#" .. translate .. "#" .. OlineTranslateText
    YvVoiceListener.CallBackAction(ListenerTypeEnum.OnVoiceOnlineRecognizeReqing, _chatMsg)
    if _resp ~= nil then
      _resp("")
    end
  end)
end

this.resp = nil

function TXVoiceInterfaceClient:SpeechDiscernByUrl(_recognizeLanguage, _outputTextLanguageType, _voiceUrlFilePath, _voiceDuration, _expand, _resp)
  this.resp = _resp
  local ret = ITMGContext.GetInstance():GetPttCtrl():SpeechToText(_voiceUrlFilePath, "cmn-Hans-CN")
end

function TXVoiceInterfaceClient:OnSpeechToTextComplete(_code, _fileid, _result)
  if this.resp ~= nil then
    this.resp(_result)
  end
  this.resp = nil
end

function TXVoiceInterfaceClient:Update()
  QAVNative.QAVSDK_Poll()
end

function TXVoiceInterfaceClient:Pause()
  ITMGContext.GetInstance():Pause()
end

function TXVoiceInterfaceClient:Resume()
  ITMGContext.GetInstance():Resume()
end

function TXVoiceInterfaceClient:LogoutAccount()
  this.isInitListener = false
  if this.OnEnterRoomCompleteEventDelegate ~= nil then
    ITMGContext.GetInstance():OnEnterRoomCompleteEvent("-", this.OnEnterRoomCompleteEventDelegate)
  end
  if this.OnExitRoomCompleteEventDelegate ~= nil then
    ITMGContext.GetInstance():OnExitRoomCompleteEvent("-", this.OnExitRoomCompleteEventDelegate)
  end
  if this.OnRoomDisconnectEventDelegate ~= nil then
    ITMGContext.GetInstance():OnRoomDisconnectEvent("-", this.OnRoomDisconnectEventDelegate)
  end
  if this.OnStreamingSpeechCompleteDelegate ~= nil then
    ITMGContext.GetInstance():GetPttCtrl():OnStreamingSpeechComplete("-", this.OnStreamingSpeechCompleteDelegate)
  end
  if this.OnSpeechToTextCompleteDelegate ~= nil then
    ITMGContext.GetInstance():GetPttCtrl():OnSpeechToTextComplete("-", this.OnSpeechToTextCompleteDelegate)
  end
  if this.OnDownloadFileCompleteDelegate ~= nil then
    ITMGContext.GetInstance():GetPttCtrl():OnDownloadFileComplete("-", this.OnDownloadFileCompleteDelegate)
  end
  if this.OnPlayFileCompleteDelegate ~= nil then
    ITMGContext.GetInstance():GetPttCtrl():OnPlayFileComplete("-", this.OnPlayFileCompleteDelegate)
  end
  if this.OnUploadFileCompleteDelegate ~= nil then
    ITMGContext.GetInstance():GetPttCtrl():OnUploadFileComplete("-", this.OnUploadFileCompleteDelegate)
  end
end
