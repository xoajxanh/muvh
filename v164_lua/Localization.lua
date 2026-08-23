Localization = {}
local this = Localization
local SystemLanguage = CS.UnityEngine.SystemLanguage
local PlayerPrefs = CS.UnityEngine.PlayerPrefs
local LANGUAGE_KEY = "Language"
local language, languageDir
local DEFAULT_LANGUAGE = SystemLanguage.ChineseSimplified
LanguageConfig = {
  {
    SystemLanguage.ChineseSimplified,
    "Ti\225\186\191ng Anh"
  }
}

function Localization.InitLanguage()
  if PlayerPrefs.HasKey(LANGUAGE_KEY) then
    language = SystemLanguage.__CastFrom(PlayerPrefs.GetInt(LANGUAGE_KEY))
  else
    language = CS.UnityEngine.Application.systemLanguage
  end
  local hasConfig = false
  for k, v in ipairs(LanguageConfig) do
    if v[1] == language then
      hasConfig = true
      break
    end
  end
  if not hasConfig then
    language = DEFAULT_LANGUAGE
  end
  this.RefreshLanguage()
end

function Localization.SetLanguage(value)
  if language == value then
    return
  end
  language = value
  PlayerPrefs.SetInt(LANGUAGE_KEY, language)
  PlayerPrefs.Save()
  this.RefreshLanguage()
  if EventManager then
    EventManager.Dispatch(Event.Localization_LanguageChanged)
  end
end

function Localization.GetLanguage()
  return language
end

function Localization.RefreshLanguage()
  languageDir = "Localization/" .. language:ToString() .. "/"
  if MAIN then
    this.LoadTables()
  end
end

local loadMetaTable = {
  __index = function(t, k)
    return t.__name .. "_" .. k
  end
}

function Localization.LoadTables()
  this.LoadTable("ResourcePathTable")
  this.LoadTable("StringTable", loadMetaTable)
end

function Localization.LoadTable(name, mt)
  _G[name] = nil
  local path = languageDir .. name
  package.loaded[path] = nil
  local success, result = pcall(require, path)
  if not success then
    error(result)
  end
  local t = _G[name]
  if not t then
    t = {}
    _G[name] = t
  end
  t.__name = name
  if mt then
    setmetatable(t, mt)
  end
end

function Localization.GetResourcePath(path)
  return ResourcePathTable[path] or path
end

function Localization.LoadLauncherStringTable()
  this.LoadTable("LauncherStringTable")
end

function Localization.UnloadLauncherStringTable()
  LauncherStringTable = nil
end

function Localization.GetContent(tblName, id)
  local tbl = ConfigManager.GetConfig(tblName, id)
  if tbl == nil then
    return "B\225\186\163ng c\225\186\165u h\195\172nh tr\225\187\145ng" .. tostring(tblName) .. "  id:" .. tostring(id)
  end
  return tbl.content
end

function Localization.GetUIWord(key)
  local tbl = ClientTable.cfg_Ui_wordManager:TryGetValue(key)
  if tbl == nil then
    logError(string.format("failed to get key:[%s] in table cfg_Ui_word", key))
    return key
  end
  return tbl.content
end

Localization.InitLanguage()
