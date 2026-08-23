VoiceLoginType = {
  common = enum(1),
  union = enum(),
  team = enum()
}
VoiceLimitType = {
  IM = enum(1),
  RealTime = enum()
}
EditorModeDisposeType = {
  login = enum(1),
  logout = enum()
}
PlatformNameEnum = {
  UNITY_STANDALONE_WIN = "Windows",
  UNITY_STANDALONE_OSX = "OSX",
  UNITY_STANDALONE_LINUX = "Linux",
  UNITY_WII = "Wii",
  UNITY_IOS = "iOS",
  UNITY_ANDROID = "Android",
  UNITY_PS4 = "PS4",
  UNITY_XBOXONE = "XboxOne",
  UNITY_WEBGL = "WebGL"
}
ITMGRoomTypeEnum = {}
ListenerTypeEnum = {
  OnLoginListener = enum(1),
  OnChatMicListener = enum(),
  OnPausePlayRealAudioListener = enum(),
  OnVoiceOnlineRecognizeReqing = enum(),
  OnSendMsgToServer = enum(),
  OnVoicePlayListener = enum()
}
