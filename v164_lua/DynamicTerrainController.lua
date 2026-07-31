DynamicTerrainController = {}
local this = DynamicTerrainController
local blockWidth = 48
local blockHeight = 48
local viewWidth = 32
local viewHight = 32
local isFirstEnterMap = true

function DynamicTerrainController.Init()
  this.CSDynamicTerrain = CS.DynamicTerrain.DynamicTerrain.Instance
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
end

function DynamicTerrainController.OnEnterGame()
  this.RegistMessages()
  this.RegistEvent()
end

function DynamicTerrainController.OnLeaveGame()
  this.UnRegistMessages()
  this.UnRegistEvent()
  this.Destroy()
end

function DynamicTerrainController.ResetReconnect()
  this.UnRegistMessages()
  this.UnRegistEvent()
end

function DynamicTerrainController.RegistMessages()
end

function DynamicTerrainController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function DynamicTerrainController.RegistEvent()
  this.eventContainer:Regist(Event.Scene_OnEnterScene, this.OnChangeMap, nil, 1)
  this.eventContainer:Regist(Event.Role_OnMePosChanged, this.OnRoleMove)
  this.eventContainer:Regist(Event.GamePlay_Back2Choose, this.OnBack2ChooseRole)
end

function DynamicTerrainController.UnRegistEvent()
  this.eventContainer:UnRegistAll()
end

function DynamicTerrainController.DoChangeMap(terrainData, mapId)
  this.CSDynamicTerrain:Show(terrainData ~= nil and not IsNil(terrainData.mat))
  if terrainData ~= nil then
    if not IsNil(terrainData.mat) then
      this.CSDynamicTerrain:RefreshTerrain(terrainData)
    end
    CS.UnityEngine.Shader.SetGlobalTexture("Terrain_HeightMap", terrainData.heightMapData.heightMap)
    CS.UnityEngine.Shader.SetGlobalTexture("_Terrain_AmbientTex", terrainData.lightMap)
    CS.UnityEngine.Shader.SetGlobalFloat("Terrain_HeightOffset", terrainData.heightMapData.heightOffset)
    CS.UnityEngine.Shader.SetGlobalFloat("_GlobalAmbientIntensity", 1)
    SceneTouchEffect.InitTerrain()
    SceneTerrainEffect.InitAdditionalMaterial(this.CSDynamicTerrain, mapId)
    this.CSDynamicTerrain.TerrainGo.transform.localScale = Vector3(1, terrainData.heightMapData.heightScale, 1)
  else
    CS.UnityEngine.Shader.SetGlobalTexture("Terrain_HeightMap", nil)
    CS.UnityEngine.Shader.SetGlobalTexture("_Terrain_AmbientTex", nil)
    CS.UnityEngine.Shader.SetGlobalFloat("Terrain_HeightOffset", 0)
  end
end

function DynamicTerrainController.LoadMapRes(mapId)
  local mapTbl = ConfigManager.GetConfig("cfg_Map_map", mapId, "id")
  if mapTbl then
    mapId = tonumber(mapTbl.map)
  end
  local terrainPath = string.format("SceneRes/%s/TerrainData.asset", mapId)
  local req = CS.Framework.ResourceManager.LoadAssetAsync(terrainPath, typeof(CS.DynamicTerrain.TerrainData))
  Coroutine.Yield(req)
  local terrainData = req.res
  this.DoChangeMap(terrainData, mapId)
end

function DynamicTerrainController.OnChangeMap(_, mapId)
  if isFirstEnterMap then
    this.CSDynamicTerrain:Init(RoleManager.me.transform, blockWidth, blockHeight, viewWidth, viewHight)
    isFirstEnterMap = false
  end
  if this.col ~= nil then
    Coroutine.Stop(this.col)
    this.col = nil
  end
  this.col = Coroutine.Start(this.LoadMapRes, mapId)
end

function DynamicTerrainController.SetLoginLightMap(resMapID)
  local terrainData = this.LoadTerrainData_ResID(resMapID)
  if terrainData then
    CS.UnityEngine.Shader.SetGlobalTexture("Terrain_HeightMap", terrainData.heightMapData.heightMap)
    CS.UnityEngine.Shader.SetGlobalTexture("_Terrain_AmbientTex", terrainData.lightMap)
    CS.UnityEngine.Shader.SetGlobalFloat("Terrain_HeightOffset", terrainData.heightMapData.heightOffset)
    CS.UnityEngine.Shader.SetGlobalFloat("_GlobalAmbientIntensity", 1)
  end
end

function DynamicTerrainController.LoadTerrainData_ResID(resMapID)
  local terrainPath = string.format("SceneRes/%s/TerrainData.asset", resMapID)
  local req = CS.Framework.ResourceManager.LoadAsset(terrainPath, typeof(CS.DynamicTerrain.TerrainData))
  return req.res
end

function DynamicTerrainController.OnRoleMove(_)
  this.CSDynamicTerrain:Update()
end

function DynamicTerrainController.OnBack2ChooseRole(_)
  this.Destroy()
end

function DynamicTerrainController.Destroy()
  this.CSDynamicTerrain:Destroy()
  isFirstEnterMap = true
  if this.col ~= nil then
    Coroutine.Stop(this.col)
    this.col = nil
  end
end
