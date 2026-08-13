SceneGrassEffectManager = {}
local this = SceneGrassEffectManager
local curMapId
local defaultSettings = {}
local settingsMap = {}

function SceneGrassEffectManager.SetGrassSettings(mapid, mapGrassSettings)
  settingsMap[mapid] = mapGrassSettings
  this.ApplyMapGrassSettings(curMapId)
end

function SceneGrassEffectManager.Init()
  this.eventContainer = EventContainer(EventManager)
end

function SceneGrassEffectManager.OnEnterGame()
  this.RegistEvent()
end

function SceneGrassEffectManager.OnLeaveGame()
  this.UnRegistEvent()
end

function SceneGrassEffectManager.RegistEvent()
  this.eventContainer:Regist(Event.Scene_SceneLoaded, this.OnChangeMap, nil, 1)
end

function SceneGrassEffectManager.UnRegistEvent()
  this.eventContainer:UnRegistAll()
end

function SceneGrassEffectManager.OnChangeMap(_, mapId)
  curMapId = mapId
  this.LoadDefaultMapGrassSettings()
  this.ApplyMapGrassSettings(mapId)
end

function SceneGrassEffectManager.LoadDefaultMapGrassSettings()
  if CSGrassSceneData.Instance == nil then
    return
  end
  local grassMats = CSGrassSceneData.Instance:GetUsingGrassMat()
  for i = 0, grassMats.Length - 1 do
    local mat = grassMats[i]
    if not defaultSettings[mat] then
      defaultSettings[mat] = {}
    end
    defaultSettings[mat]._AmplitudeZ = mat:GetFloat("_AmplitudeZ")
    defaultSettings[mat]._PowZ = mat:GetFloat("_PowZ")
    defaultSettings[mat]._WavelengthZ = mat:GetFloat("_WavelengthZ")
    defaultSettings[mat]._WaveSpeedZ = mat:GetFloat("_WaveSpeedZ")
    defaultSettings[mat]._AmplitudeX = mat:GetFloat("_AmplitudeX")
    defaultSettings[mat]._VertXOffset = mat:GetFloat("_VertXOffset")
  end
end

function SceneGrassEffectManager.ApplyDefaultMapGrassSettings()
  for k, v in pairs(defaultSettings) do
    for k1, v1 in pairs(v) do
      k:SetFloat(k1, v1)
    end
  end
end

function SceneGrassEffectManager.ApplyMapGrassSettings(mapId)
  if CSGrassSceneData.Instance == nil then
    return
  end
  local settings = settingsMap[mapId]
  if settings then
    local grassMats = CSGrassSceneData.Instance:GetUsingGrassMat()
    for i = 0, grassMats.Length - 1 do
      for k1, v1 in pairs(settings) do
        grassMats[i]:SetFloat(k1, v1)
      end
    end
  else
    this.ApplyDefaultMapGrassSettings()
  end
end

this.Init()
