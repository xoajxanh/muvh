SceneUtility = {}

function SceneUtility.TileDistance(startTile, endTile)
  return math.max(math.abs(endTile.x - startTile.x), math.abs(endTile.y - startTile.y))
end

function SceneUtility.AddSceneEffect(effectId, vector2, createCallBack, positionY)
  if type(effectId) ~= "number" or vector2 == nil then
    return
  end
  return gameMgr:GetSceneManager():GetSceneDataManager():GetSceneEffectDataManager():AddEffect(effectId, vector2, createCallBack, positionY)
end

function SceneUtility.RemoveSceneEffect(Id)
  if type(Id) ~= "number" then
    return
  end
  gameMgr:GetSceneManager():GetSceneDataManager():GetSceneEffectDataManager():RemoveEffectById(Id)
end
