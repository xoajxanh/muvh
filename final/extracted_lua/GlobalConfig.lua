GlobalConfig = {}
local this = GlobalConfig

function GlobalConfig.GetGlobalConfig(globalId)
  local temp = ClientTable.cfg_Global_globalManager:TryGetValue(globalId)
  if temp then
    return temp.effect
  end
  return ""
end

function GlobalConfig.GetGlobalConfig_Number(globalId)
  return tonumber(this.GetGlobalConfig(globalId)) or 0
end

function GlobalConfig.GetGlobalConfig_NumberArray(globalId, sep)
  return string.stringToNumberArray(this.GetGlobalConfig(globalId), sep)
end

function GlobalConfig.Init()
  GlobalConfig.ApplySkillEffect_Ticktime_Min = this.GetGlobalConfig_Number(2110006)
  GlobalConfig.Me_HurtSound_CD = this.GetGlobalConfig_Number(8000005)
  GlobalConfig.Shop_Type = this.GetGlobalConfig(2360002)
  GlobalConfig.shop_subType = this.GetGlobalConfig(2360003)
  GlobalConfig.recycleCondition = this.GetGlobalConfig(2140003)
  GlobalConfig.sellJump = this.GetGlobalConfig(2140004)
  GlobalConfig.sellVipOpen = this.GetGlobalConfig(2140009)
  GlobalConfig.storageCondition = this.GetGlobalConfig(2140005)
  GlobalConfig.storageJump = this.GetGlobalConfig(2140006)
  GlobalConfig.storageVipOpen = this.GetGlobalConfig(2140010)
  GlobalConfig.shopCondition = this.GetGlobalConfig(2140007)
  GlobalConfig.shopJump = this.GetGlobalConfig(2140008)
  GlobalConfig.shopVipOpen = this.GetGlobalConfig(2140011)
  GlobalConfig.composeCondition = this.GetGlobalConfig(2140012)
  GlobalConfig.composeJump = this.GetGlobalConfig(2140013)
  GlobalConfig.composeOpen = this.GetGlobalConfig(2140014)
  GlobalConfig.autoBuyDrugOpen = this.GetGlobalConfig(2140015)
  GlobalConfig.autoBuyDrugOpenParam = this.GetGlobalConfig(2140016)
  GlobalConfig.bagInitCount = this.GetGlobalConfig(2070001)
  GlobalConfig.bagMaxCount = this.GetGlobalConfig(2070002)
  GlobalConfig.storageInitCount = this.GetGlobalConfig(2080001)
  GlobalConfig.storageMaxCount = this.GetGlobalConfig(2080002)
  GlobalConfig.pandoraInitCount = this.GetGlobalConfig(64001001)
  GlobalConfig.autoRecycleOpen = this.GetGlobalConfig(2140017)
  GlobalConfig.autoRecycleOpenParam = this.GetGlobalConfig(2140018)
  GlobalConfig.autoPickupOpen = this.GetGlobalConfig(2140019)
  GlobalConfig.autoPickupOpenParam = this.GetGlobalConfig(2140020)
  GlobalConfig.monthcardmaturitTime = this.GetGlobalConfig_Number(2140021)
  GlobalConfig.monthcardmaturitOpenParam = this.GetGlobalConfig(2140022)
  GlobalConfig.efficientmaturitTime = this.GetGlobalConfig_Number(2210107)
  GlobalConfig.HLBRatio = this.GetGlobalConfig_Number(2110011)
  GlobalConfig.VIPMapNpc = this.GetGlobalConfig(200000004)
  GlobalConfig.NoticeBtn = this.GetGlobalConfig(5400001)
  GlobalConfig.PromptBuyDrugsAllCount = this.GetGlobalConfig(2230002)
  GlobalConfig.RedemJump = this.GetGlobalConfig(1301009)
  GlobalConfig.Redemlevel = this.GetGlobalConfig(3600001)
  GlobalConfig.AutoRackopenServerDay = this.GetGlobalConfig_Number(2310020)
  GlobalConfig.HolySkeletonBossHelpCfg = this.GetGlobalConfig_NumberArray(9002001, "#")
  GlobalConfig.RuneBossHelpCfg = this.GetGlobalConfig_NumberArray(9002002, "#")
end

this.Init()
