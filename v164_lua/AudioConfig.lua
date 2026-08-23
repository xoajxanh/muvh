AudioConfig = {}
local this = AudioConfig
local AUDIO_TYPE_TO_DIR = {
  [AudioType.BGM] = "BGM",
  [AudioType.EnvSound] = "Sound",
  [AudioType.DropSound] = "dropSound",
  [AudioType.MonsterSound] = "Monster",
  [AudioType.SkillSound] = "Skill",
  [AudioType.PlayerSound] = "Player",
  [AudioType.UI] = "UI"
}

function AudioConfig.GetAudioPath(audioType, name)
  return string.format("%s/%s", AUDIO_TYPE_TO_DIR[audioType], name)
end
