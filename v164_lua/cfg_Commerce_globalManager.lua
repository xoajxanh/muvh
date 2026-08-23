local cfg_Commerce_globalManager = {}

function cfg_Commerce_globalManager:GetName()
  return "cfg_Commerce_globalManager"
end

function cfg_Commerce_globalManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_global")
  end
  return self.dic
end

setmetatable(cfg_Commerce_globalManager, TableManagerBase)

function cfg_Commerce_globalManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_globalManager:GetLuckyTurntableBg()
  if self.luckyTurntableBgTbl == nil then
    local tbl = self:TryGetValue(307002)
    if tbl and tbl.effect then
      self.luckyTurntableBgTbl = string.split(tbl.effect, "#")
    end
  end
  return self.luckyTurntableBgTbl
end

function cfg_Commerce_globalManager:GetLuckyTurntableBgByType(type)
  local bgTbl = self:GetLuckyTurntableBg()
  return bgTbl[type]
end

function cfg_Commerce_globalManager:GetLuckyTurntableSingleRewardCount()
  if self.luckyTurntableSingleRewardCount == nil then
    local tbl = self:TryGetValue(307003)
    if tbl and tbl.effect then
      local singleReward = string.split(tbl.effect, "#")
      self.luckyTurntableSingleRewardCount = singleReward[2]
    end
  end
  return self.luckyTurntableSingleRewardCount
end

function cfg_Commerce_globalManager:GetWarOrderPassUpCost()
  if self.warOrderPassUpCost == nil then
    local tbl = self:TryGetValue(310001)
    if tbl and tbl.effect then
      local costStr = string.split(tbl.effect, "#")
      self.warOrderPassUpCost = {
        itemId = tonumber(costStr[1]),
        count = tonumber(costStr[2])
      }
    end
  end
  return self.warOrderPassUpCost
end

function cfg_Commerce_globalManager:GetWarOrderPassSwitchText()
  if self.warOrderPassSwitchText == nil then
    local tbl = self:TryGetValue(310002)
    if tbl and tbl.effect then
      self.warOrderPassSwitchText = string.split(tbl.effect, "#")
    end
  end
  return self.warOrderPassSwitchText
end

function cfg_Commerce_globalManager:GetEveryDayLimitFirecrackerCountByBoss()
  if self.everyDayLimitFirecrackerCountByBoss == nil then
    local tbl = self:TryGetValue(313004)
    if tbl and tbl.effect then
      self.everyDayLimitFirecrackerCountByBoss = tonumber(tbl.effect)
    end
  end
  return self.everyDayLimitFirecrackerCountByBoss or 10
end

function cfg_Commerce_globalManager:GetEveryDayLimitFirecrackerCountByRecharge()
  if self.everyDayLimitFirecrackerCountByRecharge == nil then
    local tbl = self:TryGetValue(313005)
    if tbl and tbl.effect then
      self.everyDayLimitFirecrackerCountByRecharge = tonumber(tbl.effect)
    end
  end
  return self.everyDayLimitFirecrackerCountByRecharge or 20
end

function cfg_Commerce_globalManager:GetExchangeRateForFirecracker()
  if self.exchangeRate == nil then
    local tbl = self:TryGetValue(313003)
    if tbl and tbl.effect then
      self.exchangeRate = string.split(tbl.effect, "#")
    end
  end
  return tonumber(self.exchangeRate[1] or 15), tonumber(self.exchangeRate[2] or 10)
end

function cfg_Commerce_globalManager:GetInvestmentSpriteNameByRechargeId(rechargeId)
  if self.investmentSpriteNameDic == nil then
    self.investmentSpriteNameDic = {}
    local tbl = self:TryGetValue(316001)
    local str
    if tbl and tbl.effect then
      str = string.split(tbl.effect, "&")
      for i, v in ipairs(str) do
        local key = v[1] and tonumber(v[1]) or nil
        local value = v[2] or nil
        if key and value then
          self.investmentSpriteNameDic[key] = value
        end
      end
    end
  end
  return self.investmentSpriteNameDic[rechargeId]
end

function cfg_Commerce_globalManager:GetFirstChargeDes(giftid)
  if self.FirstChargeDesDic == nil then
    local tableData = self:TryGetValue(323001)
    if tableData == nil then
      return nil
    end
    self.FirstChargeDesDic = {}
    local global = tableData.effect
    local globalString = string.split(global, "&")
    for i, v in pairs(globalString) do
      local strS = string.split(v, "#")
      if #strS == 2 then
        self.FirstChargeDesDic[tonumber(strS[1])] = strS[2]
      end
    end
  end
  return self.FirstChargeDesDic[giftid]
end

function cfg_Commerce_globalManager:GetGoldDiamondGiftid()
  if self.mGoldDiamondGiftid == nil then
    self.mGoldDiamondGiftid = {}
    local tableData = self:TryGetValue(324001)
    if tableData == nil then
      return nil
    end
    local globalString = string.split(tableData.effect, "#")
    for i, v in pairs(globalString) do
      table.insert(self.mGoldDiamondGiftid, tonumber(v))
    end
  end
  return self.mGoldDiamondGiftid
end

return cfg_Commerce_globalManager
