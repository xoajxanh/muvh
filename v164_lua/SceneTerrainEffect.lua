SceneTerrainEffect = {}
local this = SceneTerrainEffect

function SceneTerrainEffect.InitAdditionalMaterial(dynamicTerrain, mapId)
  local terrainGo = dynamicTerrain.TerrainGo
  if terrainGo == nil then
    return
  end
  local material = terrainGo:GetComponent(typeof(CS.UnityEngine.MeshRenderer))
  if material then
    CS.Framework.MaterialChange.ResetMaterialCount(material, 1)
    if mapId == 1008 then
      CS.Framework.MaterialChange.AttachNewMaterial(material, this.LoadTerrainData(mapId))
    end
  end
end

function SceneTerrainEffect.LoadTerrainData(mapid)
  local mapTbl = ClientTable.cfg_Map_mapManager:TryGetValue(mapid, "id")
  mapid = tonumber(mapTbl.map)
  local materialPath = string.format("Material/%s/WaterFlick.mat", mapid)
  local req = CS.Framework.ResourceManager.LoadAsset(materialPath, typeof(CS.UnityEngine.Material))
  return req.res
end
