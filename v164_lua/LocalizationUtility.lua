LocalizationUtility = {}
local this = LocalizationUtility

function LocalizationUtility.GetContentByKey(key, cfg)
  if string.isNullOrEmpty(cfg) then
    cfg = "cfg_Ui_word"
  end
  local cfg = ConfigManager.GetConfig(cfg, key)
  return cfg and cfg.content
end

function LocalizationUtility.GetBattleCampPlayerDesc(campType)
  local localizationKey
  if campType == EBattleCamp.None then
    localizationKey = "buyincang"
  elseif campType == EBattleCamp.All then
    localizationKey = "quanbuwanjia"
  elseif campType == EBattleCamp.League then
    localizationKey = "tongmengwanjia"
  elseif campType == EBattleCamp.OpLeague then
    localizationKey = "diduiwanjia"
  elseif campType == EBattleCamp.OtherPlayer then
    localizationKey = "zhongliwanjia"
  end
  return this.GetContentByKey(localizationKey)
end

function LocalizationUtility.GetUIWord(uiWord)
  local uiWordConfig = ClientTable.cfg_Ui_wordManager:GetUi_wordCount(uiWord)
  if string.isNullOrEmpty(uiWordConfig) then
    return ""
  end
  return uiWordConfig
end
