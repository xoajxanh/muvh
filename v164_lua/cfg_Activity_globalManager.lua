local cfg_Activity_globalManager = {}

function cfg_Activity_globalManager:GetName()
  return "cfg_Activity_globalManager"
end

function cfg_Activity_globalManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_global")
  end
  return self.dic
end

setmetatable(cfg_Activity_globalManager, TableManagerBase)

function cfg_Activity_globalManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Activity_globalManager:GetEffect(id, key)
  local dic = self:TryGetValue(id, key)
  return dic and dic.effect or ""
end

function cfg_Activity_globalManager:GetSafeAreaDirIcon()
  if self.mSafeAreaDirIcon == nil then
    self.mSafeAreaDirIcon = self:TryGetValue(400227).effect
  end
  return self.mSafeAreaDirIcon
end

function cfg_Activity_globalManager:GetSafeAreaDirName()
  if self.mSafeAreaDirName == nil then
    self.mSafeAreaDirName = self:TryGetValue(400228).effect
  end
  return self.mSafeAreaDirName
end

function cfg_Activity_globalManager:GetSafeAreaDirDisFormat()
  if self.mSafeAreaDirDisFormat == nil then
    self.mSafeAreaDirDisFormat = self:TryGetValue(400229).effect
  end
  return self.mSafeAreaDirDisFormat
end

function cfg_Activity_globalManager:GetCoalitionIconName(coalitionId)
  if self.mCoalitionIconNameDic == nil then
    self.mCoalitionIconNameDic = {}
    local globalTbl = self:TryGetValue(400301)
    if globalTbl ~= nil then
      self.mCoalitionIconNameDic = string.split(globalTbl.effect, "#")
    end
  end
  return self.mCoalitionIconNameDic[coalitionId]
end

function cfg_Activity_globalManager:GetCoalitionName(coalitionId)
  if self.mCoalitionNameDic == nil then
    self.mCoalitionNameDic = {}
    local globalTbl = self:TryGetValue(400300)
    if globalTbl ~= nil then
      self.mCoalitionNameDic = string.split(globalTbl.effect, "#")
    end
  end
  return self.mCoalitionNameDic[coalitionId]
end

function cfg_Activity_globalManager:GetKSBattleNoticeShowTime()
  if self.mKSBattleNoticeShowTime == nil then
    self.mKSBattleNoticeShowTime = self:GetEffect(400523)
    self.mKSBattleNoticeShowTime = tonumber(self.mKSBattleNoticeShowTime) / 1000
  end
  return self.mKSBattleNoticeShowTime
end

function cfg_Activity_globalManager:GetKSBattleMaxKillShowTime()
  if self.mKSBattleMaxKillShowTime == nil then
    self.mKSBattleMaxKillShowTime = self:GetEffect(400524)
    self.mKSBattleMaxKillShowTime = tonumber(self.mKSBattleMaxKillShowTime) / 1000
  end
  return self.mKSBattleMaxKillShowTime
end

function cfg_Activity_globalManager:GetScoreShowTime()
  if self.mScoreShowTime == nil then
    self.mScoreShowTime = self:GetEffect(400533)
    self.mScoreShowTime = tonumber(self.mScoreShowTime) / 1000
  end
  return self.mScoreShowTime
end

function cfg_Activity_globalManager:GetScoreShowTime()
  if self.mScoreShowTime == nil then
    self.mScoreShowTime = self:GetEffect(400533)
    self.mScoreShowTime = tonumber(self.mScoreShowTime) / 1000
  end
  return self.mScoreShowTime
end

function cfg_Activity_globalManager:GetDeathScore(index)
  if self.mDeathScoreList == nil then
    self.mDeathScoreList = {}
    self.mDeathScoreList = TableParse:SplitStringToIntListList(self:GetEffect(400532), "&", "#")
  end
  local deathScore = self.mDeathScoreList[index == 0 and 1 or index]
  return deathScore and deathScore[2] or 0
end

function cfg_Activity_globalManager:GetKunShouCampColorByCampId(campId)
  if self.mCampColorDic == nil then
    self.mCampColorDic = {}
    local effect = self:GetEffect(400526)
    if not string.isNullOrEmpty(effect) then
      local effectStrArr = string.split(effect, "&")
      for i, effectStr in ipairs(effectStrArr) do
        local campInfoStr = string.split(effectStr, "#")
        self.mCampColorDic[tonumber(campInfoStr[1])] = campInfoStr[2]
      end
    end
  end
  if type(campId) ~= "number" then
    return nil
  end
  return self.mCampColorDic[campId]
end

function cfg_Activity_globalManager:GetSayCommandTime()
  return tonumber(self:GetEffect(500009))
end

function cfg_Activity_globalManager:GetOverThreeVSThreeSurrenderPanelTotalTime()
  if self.mOverThreeVSThreeSurrenderPanelTotalTime == nil then
    self.mOverThreeVSThreeSurrenderPanelTotalTime = 1 / (tonumber(self:GetEffect(500011)) * 0.001)
  end
  return self.mOverThreeVSThreeSurrenderPanelTotalTime
end

return cfg_Activity_globalManager
