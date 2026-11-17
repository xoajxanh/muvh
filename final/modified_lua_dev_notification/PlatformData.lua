PlatformData = {}
local this = PlatformData
PlatformData.Platform = CS.Framework.Platform.name

function PlatformData.PlatformCheck(platform)
  if platform == nil or platform == "" then
    return true
  end
  return string.contains(platform, PlatformData.Platform)
end

local config

function PlatformData.GetVersionConfig()
  if not CS.MuInterface.Instance.GetVersionConfig then
    return nil
  end
  local configJson = CS.MuInterface.Instance:GetVersionConfig()
  if string.isNullOrEmpty(configJson) then
    return nil
  end
  if not config then
    config = json.decode(configJson)
  end
  return config
end

function PlatformData.GetAuditPlatfromID()
  if not PlatformData.PlatformCheck("iOS") then
    return 0
  end
  local config = PlatformData.GetVersionConfig()
  if not config then
    return 0
  end
  if string.isNullOrEmpty(config.AuditPlatfromID) then
    return 0
  end
  return tonumber(config.AuditPlatfromID)
end

function PlatformData.GetIsShowUserAgrement()
  local config = PlatformData.GetVersionConfig()
  if not config then
    return false
  end
  if string.isNullOrEmpty(config.IsShowUserAgrement) then
    return false
  end
  return tonumber(config.IsShowUserAgrement) ~= 0
end

function PlatformData.GetCopyright()
  local config = PlatformData.GetVersionConfig()
  if not config then
    return ""
  end
  if string.isNullOrEmpty(config.CopyrightStr) then
    return ""
  end
  return config.CopyrightStr
end

function PlatformData.GetCKUrl()
  local defaultUrl = LoginData.SERVER_CHECK_LOGIN
  local config = PlatformData.GetVersionConfig()
  if not config then
    return defaultUrl
  end
  if string.isNullOrEmpty(config.ckUrl) then
    return defaultUrl
  end
  defaultUrl = CS.Encryption.ReplaceValue(config.ckUrl)
  return defaultUrl
end

function PlatformData.GetCKUrdnsl()
  local defaultUrl = "http://login-qj2yn.muvh.vn"
  local config = PlatformData.GetVersionConfig()
  if not config then
    return defaultUrl
  end
  if not string.isNullOrEmpty(config.ckUrldns) then
    defaultUrl = config.ckUrldns
    return defaultUrl
  end
  return "https://login-qj2yn.muvh.vn"
end

function PlatformData.GetClientLogdnsl()
  local defaultUrl = "http://client-log-qj2yn.muvh.vn"
  local config = PlatformData.GetVersionConfig()
  if not config then
    return defaultUrl
  end
  if not string.isNullOrEmpty(config.ClientLogUrldns) then
    defaultUrl = config.ClientLogUrldns
    return defaultUrl
  end
  return "https://client-log-qj2yn.muvh.vn"
end

function PlatformData.GetHttpLogState()
  local defaultUrl = "0"
  local config = PlatformData.GetVersionConfig()
  if not config then
    return defaultUrl
  end
  if not string.isNullOrEmpty(config.httplog) then
    defaultUrl = config.httplog
    return defaultUrl
  end
  return "0"
end

function PlatformData.GetDnsUrl()
  local defaultUrl = CS.MuInterface.Instance:GetDnsUrl()
  if not string.isNullOrEmpty(defaultUrl) then
    CS.MuInterface.Instance:GetDnsUrl()
  elseif CS.MuInterface.Instance:IsExternalNet() then
    logError("Tên miền trống, is nil")
  else
    defaultUrl = "https://gitip-qj2yn.muvh.vn"
  end
  return defaultUrl
end

function PlatformData.GetServerlistUrl()
  local defaultUrl = CS.MuInterface.Instance:GetServerUrl()
  if not string.isNullOrEmpty(defaultUrl) then
    CS.MuInterface.Instance:GetServerUrl()
  elseif CS.MuInterface.Instance:IsExternalNet() then
    logError("Danh sách máy chủ có tên miền trống, is nil")
  else
    defaultUrl = "https://list-qj2yn.muvh.vn"
  end
  return defaultUrl
end

-- =========================================================================
-- [MOD FIX]: KHOI PHUC 4 HAM BI THIEU CUA PlatformData
-- Ly do: Main_MainMenuUI:OnShow() -> InitCheckCanFouceUpdate() goi
--        PlatformData.GetCanForceUpdateULR(). Ham bi mat => loi "call a nil value"
--        => HUD chinh khong hien => game treo o man ngoai, khong vao duoc.
-- Ghi chu: GetCanForceUpdateULR / GetCanForceUpdate tra ve "" de GIU nguyen y do mod
--          (chan ep update, an nut tai ban moi). GetCanPay / GetAppid khoi phuc nguyen ban.
-- =========================================================================

function PlatformData.GetCanForceUpdateULR()
  return ""
end

function PlatformData.GetCanForceUpdate()
  return ""
end

function PlatformData.GetCanPay()
  local defaultUrl = ""
  local config = PlatformData.GetVersionConfig()
  if not config then
    return defaultUrl
  end
  if not string.isNullOrEmpty(config.iswebpay) then
    defaultUrl = config.iswebpay
    return defaultUrl
  end
  return ""
end

function PlatformData.GetAppid()
  local defaultUrl = ""
  local config = PlatformData.GetVersionConfig()
  if not config then
    return defaultUrl
  end
  if not string.isNullOrEmpty(config.Appid) then
    defaultUrl = config.Appid
    return defaultUrl
  end
  return ""
end
