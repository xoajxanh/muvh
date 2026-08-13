SceneWeatherEffect = {}
local weatherTbl = {}
local randomTime = 30
local currentWeather = {}
local cacheEffectIndex
local cacheTable = {}
local showEffect = {}

local function RandomTableValue()
  math.randomseed(os.time())
  local randomValue = Mathf.Random(1, #currentWeather)
  cacheEffectIndex = randomValue
end

local function LoadWeatherEffect(ranWeather)
  for i = 1, #showEffect do
    showEffect[i].Effect:SetActive(false)
  end
  showEffect = {}
  if string.isNullOrEmpty(ranWeather) then
    return
  end
  if table.contains(cacheTable, cacheEffectIndex) then
    for i = 1, #weatherTbl do
      if weatherTbl[i].index == cacheEffectIndex then
        weatherTbl[i].Effect:SetActive(true)
        table.insert(showEffect, weatherTbl[i])
      end
    end
  else
    local effects = string.split(ranWeather, "#")
    for i = 1, #effects do
      local effectModel = CS.Framework.GameModel(effects[i], RoleManager.me.WeatherAnchor, nil)
      effectModel:LoadAsync(string.format("Effect/Scene/%s.prefab", effects[i]))
      if effectModel then
        local EffectObj = effectModel.gameObject
        if EffectObj then
          local data = {}
          EffectObj.transform:SetParent(RoleManager.me.WeatherAnchor)
          EffectObj.transform.localPosition = Vector3(0, 0, 0)
          EffectObj:SetActive(true)
          data.index = cacheEffectIndex
          data.Effect = EffectObj
          table.insert(weatherTbl, data)
          table.insert(showEffect, data)
        end
      end
    end
    table.insert(cacheTable, cacheEffectIndex)
  end
end

local limitWeather = ""
local limitStartTime = 0
local limitEndTime = 0
local limitWeatherState = false
local weatherStr = ""

local function EffectLoad()
  local ranWeather
  if currentWeather == nil or #currentWeather == 0 then
    ranWeather = ""
  elseif #currentWeather == 1 then
    cacheEffectIndex = 1
    ranWeather = currentWeather[1]
  else
    RandomTableValue()
    ranWeather = currentWeather[cacheEffectIndex]
  end
  LoadWeatherEffect(ranWeather)
end

function SceneWeatherEffect.InitEffect(mapId)
  if not GameSettingsData.showWeatherEffect then
    return
  end
  if RoleManager.me.WeatherAnchor == nil then
    return
  end
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(mapId, "id")
  if mapTbl == nil then
    return
  end
  local weatherMap = mapTbl.weather
  weatherStr = mapTbl.weather
  limitWeatherState = false
  limitWeather = ""
  if not string.isNullOrEmpty(mapTbl.weather_limit) then
    limitWeather = mapTbl.weather_limit
    if not string.isNullOrEmpty(mapTbl.duration) then
      local timeStr = string.split(mapTbl.duration, "#")
      limitStartTime = TimeUtility.GetServerTimeByDate(timeStr[1])
      limitEndTime = TimeUtility.GetServerTimeByDate(timeStr[2])
      timeStr = Time.GetServerSecondTime()
      if timeStr > limitStartTime and timeStr < limitEndTime then
        weatherMap = mapTbl.weather_limit
        limitWeatherState = true
      end
    end
  end
  if string.isNullOrEmpty(weatherMap) then
    return
  end
  currentWeather = string.split(weatherMap, "&")
  EffectLoad()
end

local function LimitWeatherCheck()
  if not GameSettingsData.showWeatherEffect then
    return
  end
  if not string.isNullOrEmpty(limitWeather) then
    local timeStr = Time.GetServerSecondTime()
    local change = false
    if not limitWeatherState then
      if timeStr > limitStartTime and timeStr < limitEndTime then
        limitWeatherState = true
        currentWeather = string.split(limitWeather, "&")
        change = true
      end
    elseif timeStr > limitEndTime then
      limitWeatherState = false
      currentWeather = string.split(weatherStr, "&")
      change = true
    end
    if not change then
      return
    end
    EffectLoad()
  end
end

local timer = 0

function SceneWeatherEffect.Update()
  if RoleManager.me and RoleManager.me.WeatherAnchor then
    LimitWeatherCheck()
  end
  if cacheEffectIndex == nil or #currentWeather <= 1 then
    return
  end
  if not GameSettingsData.showWeatherEffect then
    return
  end
  if timer < randomTime then
    timer = timer + Time.deltaTime
  else
    local lastCacheIndex = cacheEffectIndex
    RandomTableValue()
    if lastCacheIndex ~= cacheEffectIndex then
      LoadWeatherEffect(currentWeather[cacheEffectIndex])
    end
    timer = 0
  end
end

function SceneWeatherEffect.DestroyEffect()
  while 0 < #weatherTbl do
    CS.UnityEngine.GameObject.Destroy(weatherTbl[1].Effect)
    table.remove(weatherTbl, 1)
  end
  currentWeather = {}
  cacheEffectIndex = nil
  cacheTable = {}
  showEffect = {}
  timer = 0
end

function SceneWeatherEffect.CloseAllWeatherEffect(state, args)
  if not args then
    return
  end
  for i = 1, #weatherTbl do
    if tonumber(args) > 0 then
      weatherTbl[i].Effect:SetActive(true)
    else
      weatherTbl[i].Effect:SetActive(false)
    end
  end
end
