AudioUtility = {}

function AudioUtility.GetMonsterAudioSound(behaviorName, model)
  local audioConfig = ClientTable.cfg_Audio_monsterManager:TryGetValue(model, "id")
  if not audioConfig then
    return
  end
  local sound = string.split(audioConfig[behaviorName], "#")
  local soundCount = 0 < #sound and #sound or 1
  local audioIndex = Mathf.Random(1, soundCount)
  local soundId = sound[audioIndex]
  return tonumber(soundId)
end

function AudioUtility.GetMonsterNormalAttack(model)
  local audioMonster = ClientTable.cfg_Audio_monsterManager:TryGetValue(model, "id")
  if not audioMonster then
    return
  end
  local attackType = audioMonster.attackType
  if attackType == 0 then
    return
  end
  local attackSoundTypes = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(8000004)
  attackSoundTypes = string.split(attackSoundTypes, "&")
  local attackNormalSounds = string.split(attackSoundTypes[attackType], "#")
  local normalAttackIndex = Mathf.Random(1, #attackNormalSounds)
  local attackNormalId = tonumber(attackNormalSounds[normalAttackIndex])
  return attackNormalId
end
