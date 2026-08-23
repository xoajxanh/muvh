local cfg_Character_levelManager = {}

function cfg_Character_levelManager:GetName()
  return "cfg_Character_levelManager"
end

function cfg_Character_levelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Character_level")
  end
  return self.dic
end

setmetatable(cfg_Character_levelManager, TableManagerBase)

function cfg_Character_levelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Character_levelManager:GetExpDes(level, expNum)
  if type(level) ~= "number" then
    return
  end
  local levelTbl = self:TryGetValue(level)
  if levelTbl == nil then
    return
  end
  local curExpNum = expNum
  if curExpNum == nil then
    local strTbl = string.split(levelTbl.exp, "#")
    if 1 < #strTbl then
      curExpNum = strTbl[2]
      return curExpNum
    end
  end
  if curExpNum == nil then
    curExpNum = string.format("ID b\225\186\163ng c\225\186\165p \196\145\225\187\153: %s ch\198\176a c\225\186\165u h\195\172nh exp", level)
  end
  return levelTbl.tips .. ":" .. tostring(curExpNum)
end

function cfg_Character_levelManager:GetLevelDes(level)
  if type(level) ~= "number" then
    return
  end
  local levelTbl = self:TryGetValue(level)
  if levelTbl == nil then
    return string.format("Lv.%d", level)
  end
  return levelTbl.name
end

function cfg_Character_levelManager:GetReincarnationLevel(level)
  if type(level) ~= "number" then
    return nil
  end
  local levelTbl = self:TryGetValue(level)
  if levelTbl == nil then
    return nil
  end
  return levelTbl.reincarnationLevel
end

function cfg_Character_levelManager:GetMaxLevelsByReincarnation()
  if self.maxLevels == nil then
    self.maxLevels = {}
    for i, v in pairs(self.dic) do
      if self.maxLevels[v.reincarnationLevel] == nil or self.maxLevels[v.reincarnationLevel] < v.level then
        self.maxLevels[v.reincarnationLevel] = v.level
      end
    end
  end
  return self.maxLevels
end

function cfg_Character_levelManager:GetMinLevelByReincarnation(reincarnationLevel)
  local maxLevels = self:GetMaxLevelsByReincarnation()
  if maxLevels[reincarnationLevel - 1] then
    return maxLevels[reincarnationLevel - 1] + 1
  else
    return 0
  end
end

function cfg_Character_levelManager:GetMaxLevelByReincarnation(reincarnationLevel)
  local maxLevels = self:GetMaxLevelsByReincarnation()
  if maxLevels[reincarnationLevel] then
    return maxLevels[reincarnationLevel]
  else
    return 9999
  end
end

return cfg_Character_levelManager
