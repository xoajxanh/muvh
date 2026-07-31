FlyMove = {}
local this = FlyMove

function FlyMove.Init()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
  this.ResetData()
end

function FlyMove.RegistEvent()
  this.eventContainer:Regist(Event.Role_AutoFightChange, this.AutoFightChange)
  this.eventContainer:Regist(Event.Role_OnLoginedMap, this.TransTargetDo, nil, 3)
  this.eventContainer:Regist(Event.Role_ChangePos, this.TransTargetDo)
end

function FlyMove.RegistMessages()
end

function FlyMove.ResetData()
  this.transferId = nil
  this.line = nil
  this.param = nil
  this.purpose = nil
  this.OnArrive = nil
  this.useFly = false
end

function FlyMove.AutoFightChange()
  if QiJiHelperData.isAutoFight then
    this.CloseFlyShoeUI()
  end
end

function FlyMove.PathOnOpenFly(transferId, param, purpose, OnArrive)
  this.OpenFlyPanel(transferId, param, purpose, OnArrive)
end

function FlyMove.OpenFlyPanel(transferId, line, param, purpose, OnArrive)
  if QiJiHelperData.isAutoFight == false then
    if string.isNullOrEmpty(transferId) then
      transferId = 0
    end
    purpose = purpose == nil and Purpose.None or purpose
    if not UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
      UIManager.Show(UIID.FlyShoe_FlyShoeUI, {
        transferId = tonumber(transferId),
        line = line,
        param = param,
        purpose = purpose,
        onArrive = OnArrive
      })
    else
      EventManager.Dispatch(Event.FlyShoeRefresh, {
        transferId = tonumber(transferId),
        line = line,
        param = param,
        purpose = purpose,
        onArrive = OnArrive
      })
    end
  end
end

function FlyMove.CloseFlyShoeUI()
  if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
    UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
  end
end

function FlyMove.FlyJudge(purpose)
  if purpose ~= Purpose.ForTask then
    EventManager.Dispatch(Event.Task_PathStop)
  end
  this.CloseFlyShoeUI()
end

function FlyMove.FlyTransferScene(transferId, line, param, purpose, onArrive)
  local isFindPath = PathFinderManager.TranscriptFly()
  if isFindPath == false then
    return
  end
  this.FlyJudge(purpose)
  PathFinderManager.pathFinding.Reset()
  this.transferId = transferId
  this.line = line
  this.param = param
  this.purpose = purpose == nil and Purpose.None or purpose
  this.OnArrive = onArrive
  this.useFly = true
  local mapData = {mapId = transferId, line = line}
  EventManager.Dispatch(Event.Map_ChangeMap, mapData)
end

function FlyMove.TransTargetDo()
  if this.useFly == false then
    return
  end
  if this.purpose == Purpose.None then
    this.OnArriveToNone()
  end
  if this.purpose == Purpose.ClickNpc then
    this.OnArriveToNpc()
  end
  if this.purpose == Purpose.ForTask then
    this.OnArriveToTask()
  end
end

function FlyMove.OnArriveToNone()
  if this.OnArrive then
    this.OnArrive()
  end
  this.ResetData()
end

function FlyMove.OnArriveToTask()
  if this.OnArrive then
    this.OnArrive(this.param)
  end
  this.ResetData()
end

function FlyMove.OnArriveToNpc()
  PathFinderManager.OpenNpcPanelParam(this.param)
  if this.OnArrive then
    this.OnArrive(this.npcId)
  end
  this.ResetData()
end

FlyMove.Init()
