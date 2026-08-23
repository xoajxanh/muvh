require("GameConst/SystemForecastEnum")
SystemForecastData = {}
local this = SystemForecastData
SystemForecastData.Info1 = {}
SystemForecastData.Info2 = {}
SystemForecastData.Info3 = {}
SystemForecastData.Tab = {
  Preview = {},
  Other = {}
}
SystemForecastData.MainPreview = {}
SystemForecastData.NoticeBtnShowHideUI = {}

function SystemForecastData.Init()
  this.GetTabGroupInfo()
  this.GetInfo1()
  this.NoticeBtnShowHideUI = this.NoticeBtnShowHideUIFun(GlobalConfig.NoticeBtn)
end

function SystemForecastData.AllGetInfo()
  local AllInfo = ClientTable.cfg_Preview_strategyManager:GetDic()
  return AllInfo
end

function SystemForecastData.GetTabGroupInfo()
  local AllInfo = SystemForecastData.AllGetInfo()
  for i, v in pairs(AllInfo) do
    if not string.isNullOrEmpty(v.imgName) then
      this.Tab.Preview[v.group] = v.group
    else
      this.Tab.Other[v.group] = v.group
    end
  end
end

function SystemForecastData.NoticeBtnShowHideUIFun(str)
  local tbl = {}
  if not string.isNullOrEmpty(str) then
    local Showtbl = string.split(str, "&")
    for i, v in pairs(Showtbl) do
      tbl[v] = i
    end
  end
  return tbl
end

function SystemForecastData.GetInfo1()
  this.Info1 = {}
  for i, v in pairs(SystemForecastData.Tab.Preview) do
    local Info = ClientTable.cfg_Preview_strategyManager:TryGetValue(v, "group")
    table.insert(this.Info1, Info)
  end
  table.sort(this.Info1, function(a, b)
    return tonumber(a.split1) < tonumber(b.split1)
  end)
  return this.Info1d
end

function SystemForecastData.GetMainPreviewGear()
  local MainPreview = this.Info1
  local current
  local MianRed = false
  for k = 1, #MainPreview do
    local v = MainPreview[k]
    if v.conditionpreview and ConditionManager.Check4D(v.conditionpreview) and (not v.conditionclose or not ConditionManager.Check4D(v.conditionclose)) then
      if current == nil then
        current = v
      end
      if v.conditionopen and ConditionManager.Check4D(v.conditionopen) and (not v.conditionget or not ConditionManager.Check(v.conditionget)) then
        current = v
        MianRed = true
        break
      end
    end
  end
  return current, MianRed
end

function SystemForecastData.GetInfo2()
  SystemForecastData.Info2 = ConfigManager.FindConfigs("cfg_Preview_strategy", "group", 108)
  return SystemForecastData.Info2
end

function SystemForecastData.GetInfo3()
  SystemForecastData.Info3 = ConfigManager.FindConfigs("cfg_Preview_strategy", "group", 109)
  return SystemForecastData.Info3
end

SystemForecastData.Init()
