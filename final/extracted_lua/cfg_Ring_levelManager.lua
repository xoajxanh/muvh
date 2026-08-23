local cfg_Ring_levelManager = {}

function cfg_Ring_levelManager:GetName()
  return "cfg_Ring_levelManager"
end

function cfg_Ring_levelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ring_level")
  end
  return self.dic
end

setmetatable(cfg_Ring_levelManager, TableManagerBase)

function cfg_Ring_levelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Ring_levelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Ring_levelManager:GetTotalExpByLevel(level)
  local cfgTab = self:TryGetValue(level)
  if cfgTab and cfgTab.ringExp ~= 0 then
    return cfgTab.ringExp[2]
  else
    return 0
  end
end

function cfg_Ring_levelManager:GetUnlockProbability(level, holeIndex)
  local cfgTab = self:TryGetValue(level)
  if holeIndex == 1 then
    return tonumber(cfgTab.unlockOne) / 100
  elseif holeIndex == 2 then
    return tonumber(cfgTab.unlockTwo) / 100
  elseif holeIndex == 3 then
    return tonumber(cfgTab.unlockThree) / 100
  elseif holeIndex == 4 then
    return tonumber(cfgTab.unlockFour) / 100
  elseif holeIndex == 5 then
    return tonumber(cfgTab.unlockFive) / 100
  elseif holeIndex == 6 then
    return tonumber(cfgTab.unlockSix) / 100
  elseif holeIndex == 7 then
    return tonumber(cfgTab.unlockSeven) / 100
  elseif holeIndex == 8 then
    return tonumber(cfgTab.unlockEight) / 100
  elseif holeIndex == 9 then
    return tonumber(cfgTab.unlockNine) / 100
  end
  return 0
end

function cfg_Ring_levelManager:GetHolyRingHoleCount()
  return 9
end

function cfg_Ring_levelManager:GetExperienceIdByLevel(level)
  local cfgTab = self:TryGetValue(level)
  if cfgTab and cfgTab.ringExp ~= 0 then
    return cfgTab.ringExp[1]
  else
    return nil
  end
end

return cfg_Ring_levelManager
