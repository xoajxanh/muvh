require("GamePlay/MapEffect/TornadoMapEffect")
require("GamePlay/MapEffect/FireworksEffect")
MapEffectManager = {}
local mapEffects = {}
local this = MapEffectManager
this.isCameraAttach = false
this.tornado = nil

function MapEffectManager.OnEnterGame()
  this.RegistEvents()
end

function MapEffectManager.Init()
  this.InitMapEffectRootGo()
end

function MapEffectManager.InitMapEffectRootGo()
  this.root = CS.UnityEngine.GameObject("MapEffectManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
end

function MapEffectManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.isCameraAttach = false
  this.DestroyMapEffects()
end

function MapEffectManager.UnRegistAll()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
end

function MapEffectManager.DestroyMapEffectById(id)
  local mapEffect = mapEffects[id]
  if mapEffect then
    mapEffect:Destroy()
  end
  mapEffects[id] = nil
end

function MapEffectManager.DestroyMapEffects()
  this.DestroyTornado()
  for i, v in pairs(mapEffects) do
    v:Destroy()
  end
  mapEffects = {}
end

function MapEffectManager.CreateTornado()
  local rolePos = Scene.GetPosByCell(RoleManager.me.cellPos)
  local randX = Random.Range(0, 1)
  local randY = Random.Range(0, 1)
  local randPos = MainCamera.initCamera:ViewportToWorldPoint(Vector3(randX, randY, 5))
  randPos.y = rolePos.y
  local limitLeft = Vector2Int(43, 163)
  local limitRight = Vector2Int(101, 220)
  local point = Vector2Int(randPos.x, randPos.z)
  local limitLine = limitRight - limitLeft
  local line = point - limitLeft
  local res = limitLine.x * line.y - line.x * limitLine.y
  local resCellPos = randPos
  local k = limitLine.y / limitLine.x
  local x = (point.y - limitLeft.y + k * limitLeft.x + point.x / k) / (k + 1 / k)
  local y = limitLeft.y + k * (x - limitLeft.x)
  if limitLeft.x > point.x and point.x < limitRight.x and 0 < res then
    local cellPos = Vector2Int(Mathf.Floor(x + 0.5), Mathf.Floor(y + 0.5))
    resCellPos = Vector3(cellPos.x, rolePos.y, cellPos.y)
  end
  local rotateY = Mathf.Random(20, 160)
  local tornadoData = {
    modelType = EEffectModelType.Scene,
    model = "Huanshuyuan_feng",
    rotateY = rotateY,
    x = resCellPos.x,
    y = resCellPos.y,
    z = resCellPos.z
  }
  local tornado = TornadoMapEffect(tornadoData)
  this.tornado = tornado
end

function MapEffectManager.DestroyTornado()
  if this.tornado then
    this.tornado:Destroy()
    this.tornado = nil
  end
  if this.countDownTornado then
    Timer.Stop(this.countDownTornado)
    this.countDownTornado = nil
  end
end

function MapEffectManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Role_OnMove, this.MeMove)
  this.eventContainer:Regist(Event.Map_ChangeMap, this.ChangeMap)
  this.eventContainer:Regist(Event.CameraAttach, this.CameraAttach)
  this.eventContainer:Regist(Event.Role_OnMeDestroy, this.OnRoleDestroy)
  this.eventContainer:Regist(Event.BroadcastFireWorks, this.BroadcastFireWorks)
end

function MapEffectManager.BroadcastFireWorks(_, msg)
  if msg.specialEffects == 1 then
    local pos = Scene.GetPosByCell(Vector2Int(msg.x, msg.y))
    for i = 1, 3 do
      local id = string.format("%s%s%s%d", Time.GetServerTime(), msg.x, msg.y, i)
      local fireworksData = {
        modelType = EEffectModelType.Scene,
        model = "Eff_yanhua",
        x = pos.x,
        y = pos.y + 0.1,
        z = pos.z,
        id = id,
        timerInterval = (i - 1) * 1.3
      }
      local fireworks = FireworksEffect(fireworksData)
      mapEffects[id] = fireworks
    end
  elseif msg.specialEffects == 3 then
    local pos = Scene.GetPosByCell(Vector2Int(msg.x, msg.y))
    for i = 1, 3 do
      local id = string.format("%s%s%s%d", Time.GetServerTime(), msg.x, msg.y, i)
      local fireworksData = {
        modelType = EEffectModelType.Scene,
        model = "Eff_yanhua_03",
        x = pos.x,
        y = pos.y + 0.1,
        z = pos.z,
        id = id,
        timerInterval = (i - 1) * 1.3
      }
      local fireworks = FireworksEffect(fireworksData)
      mapEffects[id] = fireworks
    end
  end
end

function MapEffectManager.MeMove()
  if this.isCameraAttach then
    this.RefreshMapEffect()
  end
end

function MapEffectManager.ChangeMap()
  if this.isCameraAttach then
    this.RefreshMapEffect()
  end
end

function MapEffectManager.CameraAttach()
  this.isCameraAttach = true
  this.RefreshMapEffect()
end

function MapEffectManager.OnRoleDestroy()
  this.isCameraAttach = false
end

function MapEffectManager.RefreshMapEffect()
  if not SceneData.mapId or not RoleManager.me then
    return
  end
  if SceneData.mapId == 1052 and not RoleManager.me:IsCurSafeZone() then
    if not this.countDownTornado then
      local timeInterval = Mathf.Random(25, 45)
      this.countDownTornado = Timer.StartLoop(timeInterval, 1, function()
        this.CreateTornado()
      end)
    end
  elseif this.countDownTornado then
    Timer.Stop(this.countDownTornado)
    this.countDownTornado = nil
  end
end

MapEffectManager.Init()
