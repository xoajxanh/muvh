require("GameModel/VoiceData")
ClientVoiceState = {}
local this = ClientVoiceState
this.ScriptName = "ClientVoiceState"
this.table = nil

function ClientVoiceState:AutoPlayingAudio(_indexer, _value)
  if _indexer == IndexerEnum.get then
    return VoiceData.isAutoPlayingAudio
  elseif VoiceData.isAutoPlayingAudio ~= _value then
    VoiceData.isAutoPlayingAudio = _value
  end
end

function ClientVoiceState:CancelLuying(_indexer, _value)
  if _indexer == IndexerEnum.get then
    return VoiceData.isCancelLuying
  elseif VoiceData.isCancelLuying ~= _value then
    VoiceData.isCancelLuying = _value
  end
end

function ClientVoiceState:RuningRecord(_indexer, _value)
  if _indexer == IndexerEnum.get then
    return VoiceData.isRuningRecord
  elseif VoiceData.isRuningRecord ~= _value then
    VoiceData.isRuningRecord = _value
  end
end
