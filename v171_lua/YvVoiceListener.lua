YvVoiceListener = {}
local this = YvVoiceListener
this.delegateList = {}
this.ScriptName = "YvVoiceListener"

function YvVoiceListener.ResetListener()
  this.delegateList = {}
  for key, value in pairs(ListenerTypeEnum) do
    this.delegateList[value] = {}
  end
end

function YvVoiceListener.CallBackAction(_listenerTypeEnum, _args)
  local actionTabs = this.delegateList[_listenerTypeEnum]
  if actionTabs == nil or table.count(actionTabs) == 0 then
    return
  end
  for key, value in pairs(actionTabs) do
    if value ~= nil then
      value(_args)
    end
  end
end

function YvVoiceListener.BindLoginListener(_a)
  table.insert(this.delegateList[ListenerTypeEnum.OnLoginListener], _a)
end

function YvVoiceListener.RemoveLoginListener(_a)
  this.RemoveVoiceListener(ListenerTypeEnum.OnLoginListener, _a)
end

function YvVoiceListener.BindChatMicListener(_a)
  table.insert(this.delegateList[ListenerTypeEnum.OnChatMicListener], _a)
end

function YvVoiceListener.RemoveChatMicListener(_a)
  this.RemoveVoiceListener(ListenerTypeEnum.OnChatMicListener, _a)
end

function YvVoiceListener.BindPausePlayRealAudioListener(_a)
  table.insert(this.delegateList[ListenerTypeEnum.OnPausePlayRealAudioListener], _a)
end

function YvVoiceListener.RemovePausePlayRealAudioListener(_a)
  this.RemoveVoiceListener(ListenerTypeEnum.OnPausePlayRealAudioListener, _a)
end

function YvVoiceListener.BindVoiceOnlineRecognizeReqing(_a)
  table.insert(this.delegateList[ListenerTypeEnum.OnVoiceOnlineRecognizeReqing], _a)
end

function YvVoiceListener.RemoveVoiceOnlineRecognizeReqing(_a)
  this.RemoveVoiceListener(ListenerTypeEnum.OnVoiceOnlineRecognizeReqing, _a)
end

function YvVoiceListener.BindSendMsgToServer(_a)
  table.insert(this.delegateList[ListenerTypeEnum.OnSendMsgToServer], _a)
end

function YvVoiceListener.RemoveSendMsgToServer(_a)
  this.RemoveVoiceListener(ListenerTypeEnum.OnSendMsgToServer, _a)
end

function YvVoiceListener.BindVoicePlayListener(_a)
  table.insert(this.delegateList[ListenerTypeEnum.OnVoicePlayListener], _a)
end

function YvVoiceListener.RemoveVoicePlayListener(_a)
  this.RemoveVoiceListener(ListenerTypeEnum.OnVoicePlayListener, _a)
end

function YvVoiceListener.RemoveVoiceListener(_listenerTypeEnum, _a)
  local actionTabs = this.delegateList[_listenerTypeEnum]
  for key, value in pairs(actionTabs) do
    if _a == value then
      table.remove(this.delegateList[_listenerTypeEnum], key)
    end
  end
end
