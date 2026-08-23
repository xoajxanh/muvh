VoiceUtility = {}
local this = VoiceUtility
this.SpChar = {}
this.isOpenVoice = false

function VoiceUtility.GetVoiceVersion()
  return 2
end

function VoiceUtility.InitSpChar()
  local pbs = string.split("1#2#3#4#5#6#7#8#9#0#0#1#2#3#4#5#6#7#8#9#SNS", "#")
  for i = 1, #pbs do
    table.insert(this.SpChar, pbs[i])
  end
end

function VoiceUtility.ReplaceSpChar(msg)
  if table.count(this.SpChar) == 0 then
    return
  end
  local result = msg
  for i = 1, table.count(this.SpChar) do
    if string.contains(result, this.SpChar[i]) then
      result = string.replace(result, this.SpChar[i], "*")
    end
  end
  return result
end

function VoiceUtility.isAllowYvVoice()
  return this.isOpenVoice
end

function VoiceUtility.JudgeSpeakLimit()
  return true
end

function VoiceUtility.JudgeVoiceLimit(limitType)
  if not this.isAllowYvVoice() then
    return false
  end
  if VoiceData.isBanAllVoice then
    logPurple("[FF0000FF] C\225\186\163nh \196\145\225\186\183c bi\225\187\135t, kh\195\180ng \196\145\198\176\225\187\163c ph\195\169p ph\195\161t gi\225\187\141ng n\195\179i")
    return false
  end
  if VoiceData.isBanRealTimeVoice and limitType == VoiceLimitType.RealTime then
    logPurple("[FF0000FF] C\225\186\163nh \196\145\225\186\183c bi\225\187\135t, kh\195\180ng \196\145\198\176\225\187\163c ph\195\169p ph\195\161t gi\225\187\141ng n\195\179i th\225\187\157i gian th\225\187\177c")
    return false
  end
  return true
end
