VoiceData = {}
local this = VoiceData
VoiceData.VoiceRoomID = ""
VoiceData.isLogin = false
VoiceData.isOpenVoiceSpeak = false
VoiceData.isOpenVoiceListener = true
VoiceData.isCancelLuying = false
VoiceData.isLoginRes = false
VoiceData.isOpenLocalTranser = true
VoiceData.mLoginType = VoiceLoginType.union
VoiceData.unionVoiceOpenLevel = 0
VoiceData.unionVoiceOpenTime = 3
VoiceData.openServerBanYvVoice = 3
VoiceData.openServerBanVipLevelYvVoice = 2
VoiceData.notesLister = false
VoiceData.notesSpeak = false
VoiceData.isBanAllVoice = false
VoiceData.isBanRealTimeVoice = false
VoiceData.VoiceVersion = 0
VoiceData.isAutoPlayingAudio = false
VoiceData.AutoPlayAudioList = List:New()
VoiceData.isRuningRecord = false
VoiceData.ChatMessageList = List:New()
VoiceData.isVoiceOnlineRecognizeReqing = false
VoiceData.HasVoicePermission = false
VoiceData.serverRoom = ""
VoiceData.isPlayingAudio1 = false
VoiceData.isPlayingAudio2 = false
VoiceData.isRecordAudio = false
VoiceData.isResetVoice = false
VoiceData.CallbackUrl = ""

function VoiceData.Init()
  this.serverRoom = "1001"
end

this.Init()
