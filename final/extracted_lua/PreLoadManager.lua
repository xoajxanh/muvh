require("GameModel/PreloadResourceData")
PreLoadManager = {}
local this = PreLoadManager
local resourceManager = CS.Framework.ResourceManager

function PreLoadManager.Init()
  this.InitEvents()
end

function PreLoadManager.InitEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.OnRoleLoginedMap, nil, 2)
  this.eventContainer:Regist(Event.Scene_HideLoading, this.OnHideLoading)
end

local function SetLoadCount(count)
  resourceManager.MaxLoadOrInstanceCount = count
end

function PreLoadManager.OnLODChanged()
  SetLoadCount(GameSettingsData.LOD)
end

function PreLoadManager.OnHideLoading()
  UIManager.Hide(UIID.LoadingUI)
end

function PreLoadManager.OnRoleLoginedMap()
  SceneData.mapLoaded = true
end

function PreLoadManager.Count()
  PreloadResourceData.preCount = PreloadResourceData.preCount + 1
end

function PreLoadManager.CollectPreLoadOnBackground(mapId)
  if mapId == nil or mapId == 0 then
    return false, 0
  end
  return PreloadResourceData.CollectPreloadRes(mapId)
end

function PreLoadManager.NeedPreLoadOnLoading(mapId)
  if #PreloadResourceData.UIPreloadingTbl > 0 then
    return true
  end
  return false
end

function PreLoadManager.LargeLoadOpen()
  SetLoadCount(GameSettingsData.maxInstantiateCount)
end

function PreLoadManager.SetPreloadState(state)
  this.LargeLoadOpen(state)
end

function PreLoadManager.LoadingLoad()
  PreloadResourceData.ResetCount()
  PreloadResourceData.totalCount = PreloadResourceData.totalCount + table.count(PreloadResourceData.UIPreloadingTbl)
  this.LargeLoadOpen(true)
  UIManager.PreLoadUI(PreloadResourceData.UIPreloadingTbl)
end

local catlikeTimer

function PreLoadManager.CatlikeLoadUI()
  if catlikeTimer then
    return
  end
  catlikeTimer = Timer.StartLoopForever(PreloadResourceData.CatlikeTime, this.LoadUI)
end

function PreLoadManager.StopCatlikeLoad()
  if catlikeTimer then
    Timer.Stop(catlikeTimer)
    catlikeTimer = nil
  end
end

function PreLoadManager.LoadUI()
  local name = table.remove(PreloadResourceData.UIPreloadingTbl)
  if not string.isNullOrEmpty(name) then
    UIManager.OnPreLoadUI(name)
  end
end

local function LoadRes()
  local tmpTbl, modelType, modelName, path
  for t, _ in pairs(PreloadResourceData.ResTbl) do
    modelType = t
    if table.count(PreloadResourceData.ResTbl[t]) > 0 then
      tmpTbl = PreloadResourceData.ResTbl[t]
      break
    end
  end
  modelName = table.remove(tmpTbl)
  if modelType and not string.isNullOrEmpty(modelName) then
    path = ResourceConfig.GetModelPath(modelType, modelName)
    if modelType == ResourceTypeEnum.Model_Monster or modelType == ResourceTypeEnum.Model_NPC then
      PreloadResourceData.Preload(modelType, path)
    elseif modelType == ResourceTypeEnum.Effect_Skill then
      PreloadResourceData.PreloadSkill(modelType, path)
    end
  end
end

function PreLoadManager.CatlikeLoadRes()
  if catlikeTimer then
    return
  end
  local need, Count = this.CollectPreLoadOnBackground(SceneData.mapId)
  if need then
    catlikeTimer = Timer.StartLoop(PreloadResourceData.CatlikeTime, Count, LoadRes)
  end
end

function PreLoadManager.CatlikeLoadGuide()
  EventManager.Dispatch(Event.Load_Guide)
end

this.Init()
