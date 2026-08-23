PlayerSoundManager = {}
local this = PlayerSoundManager

function PlayerSoundManager.PlayHurtSound(hurtData)
  local meHurt = false
  for i = 1, #hurtData.hurtList do
    if hurtData.hurtList[i].targetId == ViewData.meData.id and hurtData.hurtList[i].hp > 0 then
      meHurt = true
      break
    end
  end
  if meHurt then
    this.PlayMeHurtSound(ViewData.meData.career)
  end
end

local function getRoleSoundConfig(career)
  local hurtSoundCfg = ClientTable.cfg_Audio_characterManager:TryGetValue(career, "career")
  if not hurtSoundCfg then
    logError(string.format("Kh\195\180ng t\195\172m th\225\186\165y c\225\186\165u h\195\172nh ngh\225\187\129 %d trong b\225\186\163ng Audio_character", career))
    return
  end
  return hurtSoundCfg
end

function PlayerSoundManager.PlayMeHurtSound(career)
  if not this.lastMeHurSoundTime then
    this.lastMeHurSoundTime = 0
  end
  local serverTime = Time.GetServerTime()
  if serverTime - this.lastMeHurSoundTime > GlobalConfig.Me_HurtSound_CD then
    this.lastMeHurSoundTime = serverTime
  else
    return
  end
  local hurtSoundCfg = getRoleSoundConfig(career)
  local randomSoundList = string.stringToNumberArray(hurtSoundCfg.hitAudios, "#")
  local soundId = Mathf.RandomTableValue(randomSoundList)
  AudioManager.PlayMusicClipById(soundId)
end

function PlayerSoundManager.PlayDieSound(career)
  local hurtSoundCfg = getRoleSoundConfig(career)
  AudioManager.PlayMusicClipById(hurtSoundCfg.die)
end
