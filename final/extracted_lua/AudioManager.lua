require("GameConst/AudioTypeEnum")
require("LuaCore/Audio/AudioConfig")
AudioManager = {}
local this = AudioManager
local csAudioManager = CS.Framework.AudioManager.instance
AudioGroup = {Music = 1, Sound = 2}

function AudioManager.Init()
  for k, v in pairs(AudioGroup) do
    csAudioManager:CreateGroup(v, k)
  end
end

function AudioManager.Play(groupID, name, loop, volume, target)
  if string.isNullOrEmpty(name) then
    return nil
  end
  local path = "Audio/" .. name
  return csAudioManager:Play(groupID, path, loop, volume, target)
end

function AudioManager.PlayBGM(name, volume)
  if this.bgm then
    this.bgm:Stop()
    this.bgm = nil
  end
  if name then
    name = "BGM/" .. name
    if 1 < volume then
      volume = volume * 0.01
    end
    this.bgm = this.Play(AudioGroup.Music, name, true, volume or 0.1, nil)
  end
end

function AudioManager.PlayEffect(name, volume, loop, target)
  name = "Sound/" .. name
  return this.Play(AudioGroup.Sound, name, loop, volume or 0.2, target)
end

function AudioManager.PlayMusicClipById(id)
  local audios = ClientTable.cfg_Audio_audioManager:TryGetValue(id, "id")
  if not audios then
    return
  end
  local name = AudioConfig.GetAudioPath(audios.type, audios.resourceName)
  return this.Play(AudioGroup.Sound, name, false, audios.volume * 0.01, nil)
end

function AudioManager.Stop(audio)
  if audio then
    audio:Stop()
  end
end

function AudioManager.StopGroup(groupID)
  csAudioManager:StopAll(groupID)
end

function AudioManager.StopAll()
  for k, v in pairs(AudioGroup) do
    this.StopGroup(v)
  end
end

function AudioManager.SetVolume(groupID, volume)
  csAudioManager:SetVolume(groupID, volume)
end

function AudioManager.GetVolume(groupID)
  return csAudioManager:GetVolume(groupID)
end

function AudioManager.SetEnable(enabled)
  CS.UnityEngine.AudioListener.volume = not enabled and 0 or 1
end

function AudioManager.AttachAudioListener(target, pos)
  csAudioManager:AttachAudioListener(target, pos or Vector3.zero)
end

AudioManager.Init()
