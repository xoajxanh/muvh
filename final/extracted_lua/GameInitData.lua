GameInitData = {}
local this = GameInitData

function GameInitData.Init()
  if ClientTable.cfg_Global_globalManager:TryGetValue(7010002) ~= nil then
    this.personWalkSpeed = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(7010002))
  else
    this.personWalkSpeed = 0
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(7010003) ~= nil then
    this.personRunSpeed = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(7010003))
  else
    this.personRunSpeed = 0
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(7010004) ~= nil then
    this.needWalkStep = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(7010004))
  else
    this.needWalkStep = 0
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(2160001) ~= nil then
    this.wingWalkSpeed = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2160001))
  else
    this.wingWalkSpeed = 0
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(2160002) ~= nil then
    this.wingRunSpeed = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2160002))
  else
    this.wingRunSpeed = 0
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(2110001) ~= nil then
    this.comboAttackLimit = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2110001))
  else
    this.comboAttackLimit = 0
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(2110002) ~= nil then
    local data1 = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2110002), "&")
    this.atkSpeedIncreaseRate = {}
    for i = 1, #data1 do
      local data2 = string.split(data1[i], "#")
      local career = tonumber(data2[1])
      this.atkSpeedIncreaseRate[career] = tonumber(data2[2])
    end
  else
    this.atkSpeedIncreaseRate = {}
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(2390001) ~= nil then
    this.lossTargetDistance = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390001))
  else
    this.lossTargetDistance = 8
  end
  if ClientTable.cfg_Global_globalManager:TryGetValue(2390002) ~= nil then
    this.selectTargetDistance = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390002))
  else
    this.selectTargetDistance = 8
  end
  local config = ClientTable.cfg_Global_globalManager:TryGetValue(2110004)
  if config then
    this.heiLongBoSpinMonsterExcludeTypes = string.stringToNumberArray(config.effect, "&")
  end
  this.PathFindLimit = 20
end

function GameInitData.GetCDIncreaseFactor(atkSpeed, career)
  local careerCoef = this.atkSpeedIncreaseRate[career] or 667
  return 1 / (1 + atkSpeed * careerCoef * 1.0E-5)
end
