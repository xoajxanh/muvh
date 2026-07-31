require("GamePlay/Grave/GraveEffect")
require("GamePlay/Grave/Head/GraveHead3DMesh")
GraveManager = {}
local this = GraveManager

function GraveManager.Init()
  this.InitGraveRoot()
  this.displayGrave = true
  this.graveList = {}
end

function GraveManager.InitGraveRoot()
  this.root = CS.UnityEngine.GameObject("GraveManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
end

function GraveManager.OnEnterGame()
  this.RegistEvents()
  this.RegistMessages()
end

function GraveManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Grave_OnGraveEnterView, this.OnGraveEnterView)
  this.eventContainer:Regist(Event.Grave_OnGraveUpdate, this.OnGraveUpdate)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnGraveLeaveView)
end

function GraveManager.RegistMessages()
  this.messageContainer = EventContainer(NetManager)
  this.messageContainer:Regist(MapMessage.ResChangePos, this.OnResChangePos)
end

function GraveManager.OnResChangePos(id, msg)
  if msg.reason == ERoleChangePosReason.Transport or msg.reason == ERoleChangePosReason.RandomTransport then
    this.DestroyAllGrave()
  end
end

function GraveManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyAllGrave()
end

function GraveManager.CreatGrave(graveData)
  if this.graveList[graveData.id] ~= nil then
    this.OnGraveUpdate(graveData)
    return
  end
  local cellPos = Vector2Int(graveData.x, graveData.y)
  local gravePos = Scene.GetPosByCell(cellPos)
  local graveEffectData = {
    effectId = graveData.id,
    modelType = EEffectModelType.Scene,
    model = "Monster177",
    rotateY = 160,
    x = gravePos.x,
    y = gravePos.y,
    z = gravePos.z,
    reliveTime = graveData.reliveTime
  }
  local graveEffect = GraveEffect(graveEffectData)
  this.graveList[graveData.id] = graveEffect
  return this.graveList[graveData.id]
end

function GraveManager.DestroyGraveById(graveId)
  local grave = this.graveList[graveId]
  if grave then
    this.graveList[graveId] = nil
    grave:Destroy()
    return true
  else
    return false
  end
end

function GraveManager.DestroyAllGrave()
  for k, v in pairs(this.graveList) do
    v:Destroy()
  end
  this.graveList = {}
end

function GraveManager.OnGraveEnterView(_, graveData)
  if graveData == nil then
    return
  end
  this.CreatGrave(graveData)
end

function GraveManager.OnGraveUpdate(_, graveData)
  if graveData == nil then
    return
  end
  local cellPos = Vector2Int(graveData.x, graveData.y)
  local gravePos = Scene.GetPosByCell(cellPos)
  this.graveList[graveData.id]:SetPosition(gravePos.x, gravePos.y, gravePos.z)
end

function GraveManager.OnGraveLeaveView(_, graveData)
  if graveData == nil then
    return
  end
  this.DestroyGraveById(graveData.id)
end

GraveManager.Init()
