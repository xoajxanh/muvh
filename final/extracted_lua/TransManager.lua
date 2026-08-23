require("GamePlay/Trans/TransEffect")
TransManager = {}
local this = TransManager

function TransManager.Init()
  this.InitTransRoot()
  this.displayTrans = false
  this.displayTrans = true
  this.transList = {}
end

function TransManager.InitTransRoot()
  this.root = CS.UnityEngine.GameObject("TransManager").transform
  CS.UnityEngine.Object.DontDestroyOnLoad(this.root)
end

function TransManager.OnEnterGame()
  this.RegistEvents()
  this.RegistMessages()
end

function TransManager.RegistMessages()
end

function TransManager.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Trans_OnTransEnterView, this.OnTransEnterView)
  this.eventContainer:Regist(Event.GameObject_OnGameObjectLeaveView, this.OnTransLeaveView)
  this.eventContainer:Regist(Event.Trans_OnTransUpdate, this.OnTransUpdate)
end

function TransManager.OnLeaveGame()
  if this.eventContainer then
    this.eventContainer:UnRegistAll()
  end
  this.DestroyAllTrans()
end

function TransManager.CreatTrans(transData)
  if this.transList[transData.id] ~= nil then
    this.OnTransUpdate(transData)
    return
  end
  local cellPos = Vector2Int(transData.x, transData.y)
  local transPos = Scene.GetPosByCell(cellPos)
  local transEffectData = ClientTable.cfg_Map_eventManager:GetTransEffectConfigData(transData.configId)
  local transEffectData = {
    effectId = transData.id,
    modelType = EEffectModelType.Scene,
    model = transEffectData and transEffectData.name or "bingfenggu_chuansongmen",
    rotate = transEffectData and transEffectData.rotation,
    scale = transEffectData and transEffectData.scale,
    x = transPos.x,
    y = transPos.y,
    z = transPos.z
  }
  local transEffect = TransEffect(transEffectData)
  this.transList[transData.id] = transEffect
  return this.transList[transData.id]
end

function TransManager.DestroyTransById(transId)
  local trans = this.transList[transId]
  if trans then
    this.transList[transId] = nil
    trans:Destroy()
    return true
  else
    return false
  end
end

function TransManager.DestroyAllTrans()
  for k, v in pairs(this.transList) do
    v:Destroy()
  end
  this.transList = {}
end

function TransManager.OnTransUpdate(_, transData)
  if transData == nil then
    return
  end
  local cellPos = Vector2Int(transData.x, transData.y)
  local transPos = Scene.GetPosByCell(cellPos)
  this.transList[transData.id]:SetPosition(transPos.x, transPos.y, transPos.z)
end

function TransManager.OnTransEnterView(_, transData)
  if transData == nil then
    return
  end
  this.CreatTrans(transData)
end

function TransManager.OnTransLeaveView(_, transData)
  if transData == nil then
    return
  end
  this.DestroyTransById(transData.id)
end

function TransManager.OnTransDisplay()
  this.displayTrans = true
  if this.transList[1] ~= nil then
    this.transList[1]:SetOnActive(true)
  end
end

TransManager.Init()
