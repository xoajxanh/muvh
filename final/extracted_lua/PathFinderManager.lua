require("GamePlay/Path/PathFinding")
require("GamePlay/Path/NpcMove")
require("GamePlay/Path/NpcJumpMapMove")
require("GamePlay/Path/PosMove")
require("GamePlay/Path/FlyMove")
require("GamePlay/Path/SwitchLineMove")
require("GamePlay/Path/JumpMapToPos")
Purpose = {
  None = enum(0),
  ClickNpc = enum(),
  ForTask = enum()
}
PathMoveType = {
  NpcMove = enum(0),
  NpcJumpMapMove = enum(),
  PosMove = enum(),
  JumpMapMove = enum(),
  SwitchLineMove = enum(),
  MapClick = enum()
}
PathFinderManager = {}
local this = PathFinderManager

function PathFinderManager.Init()
  this.eventContainer = EventContainer(EventManager)
  this.messageContainer = EventContainer(NetManager)
  this.RegistEvent()
  this.RegistMessages()
  this.NpcMove = NpcMove
  this.NpcJumpMapMove = NpcJumpMapMove
  this.PosMove = PosMove
  this.FlyMove = FlyMove
  this.SwitchLineMove = SwitchLineMove
  this.JumpMapToPos = JumpMapToPos
  this.pathFinding = PathFinding
  this.pathFinding.InitTransData()
  this.ResetData()
  this.transferTbl = ConfigManager.FindConfigs("cfg_Map_transfer", "born", 1)
end

function PathFinderManager.RegistEvent()
  this.eventContainer:Regist(Event.GamePlay_Leave, this.ResetData)
end

function PathFinderManager.RegistMessages()
  this.messageContainer:Regist(UserMessage.ResLogout, this.ResetData)
end

function PathFinderManager.TranscriptPathTo(targetScene)
  local isFindPath = true
  if TranScriptData.InTranscript then
    if TranScriptData.InTranscriptType == TranScriptType.SecretBoss then
      return true
    end
    local titleStrCon = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("autoFindError_1")
    FloatingWordUtility.QuickMsg(titleStrCon)
    isFindPath = false
  end
  if RoleManager.me.isDead then
    isFindPath = false
  end
  return isFindPath
end

function PathFinderManager.TranscriptFly()
  local isFindPath = true
  if TranScriptData.UnableToSendInCopy() then
    local titleStrCon = ConfigManager.GetConfig("cfg_Ui_word", "instance_1")
    if titleStrCon then
      FloatingWordUtility.QuickMsg(titleStrCon.content)
    end
    isFindPath = false
  end
  if RoleManager.me.isDead then
    local titleStrCon = ConfigManager.GetConfig("cfg_Ui_word", "instance_2")
    if titleStrCon then
      FloatingWordUtility.QuickMsg(titleStrCon.content)
    end
    isFindPath = false
  end
  return isFindPath
end

function PathFinderManager.MoveToNpc(param, transferId, purpose, OnArrive, range, isStopTask, isForcePath)
  this.pathfindingRecord = {}
  this.pathfindingRecord.type = PathMoveType.NpcMove
  this.pathfindingRecord.param = param
  this.pathfindingRecord.transferId = transferId
  this.pathfindingRecord.purpose = purpose == nil and Purpose.None or purpose
  this.pathfindingRecord.OnArrive = OnArrive
  this.pathfindingRecord.range = range
  this.pathfindingRecord.isStopTask = isStopTask
  this.NpcMove.MoveToNpc(param, transferId, purpose, OnArrive, range, isStopTask, isForcePath)
end

function PathFinderManager.JumpMapMoveToNpc(param, transferId, purpose, OnArrive, range, isStopTask)
  this.pathfindingRecord = {}
  this.pathfindingRecord.type = PathMoveType.NpcJumpMapMove
  this.pathfindingRecord.param = param
  this.pathfindingRecord.transferId = transferId
  this.pathfindingRecord.purpose = purpose == nil and Purpose.None or purpose
  this.pathfindingRecord.OnArrive = OnArrive
  this.pathfindingRecord.range = range
  this.pathfindingRecord.isStopTask = isStopTask
  this.NpcJumpMapMove.MoveToNpc(param, transferId, purpose, OnArrive, range, isStopTask)
end

function PathFinderManager.MoveToPos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  this.pathfindingRecord = {}
  this.pathfindingRecord.type = PathMoveType.PosMove
  this.pathfindingRecord.groupId = groupId
  this.pathfindingRecord.pos = pos
  this.pathfindingRecord.transferId = transferId
  this.pathfindingRecord.line = line
  this.pathfindingRecord.param = param
  this.pathfindingRecord.purpose = purpose == nil and Purpose.None or purpose
  this.pathfindingRecord.OnArrive = OnArrive
  this.pathfindingRecord.range = range
  this.pathfindingRecord.isStopTask = isStopTask
  this.PosMove.MoveToPos(groupId, pos, transferId, param, purpose, OnArrive, range, isStopTask)
end

function PathFinderManager.JumpMapToMovePosByTransferId(transferId, line, param, purpose, OnArrive, range, isStopTask)
  if type(transferId) ~= "number" then
    return
  end
  local transferTbl = ClientTable.cfg_Map_transferManager:TryGetValue(transferId)
  if transferTbl == nil or string.isNullOrEmpty(transferTbl.position) or ConditionManager.Check4D(transferTbl.condition) == false then
    return
  end
  local positionList = string.split(transferTbl.position, "#")
  local randomIndex = 1
  if 1 < #positionList then
    randomIndex = Mathf.Random(1, #positionList)
  end
  local curPositionDes = positionList[randomIndex]
  if string.isNullOrEmpty(curPositionDes) then
    return
  end
  local positionSplit = string.split(curPositionDes, "_")
  if #positionSplit < 2 then
    return
  end
  local curPosition = Vector2(tonumber(positionSplit[1]), tonumber(positionSplit[2]))
  PathFinderManager.JumpMapToMoveToPos(transferTbl.groupId, curPosition, transferId, line, param, purpose, OnArrive, range, isStopTask)
end

function PathFinderManager.JumpMapToMoveToPos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  this.pathfindingRecord = {}
  this.pathfindingRecord.type = PathMoveType.JumpMapMove
  this.pathfindingRecord.groupId = groupId
  this.pathfindingRecord.pos = pos
  this.pathfindingRecord.transferId = transferId
  this.pathfindingRecord.line = line
  this.pathfindingRecord.param = param
  this.pathfindingRecord.purpose = purpose == nil and Purpose.None or purpose
  this.pathfindingRecord.OnArrive = OnArrive
  this.pathfindingRecord.range = range
  this.pathfindingRecord.isStopTask = isStopTask
  this.JumpMapToPos.MapMoveToPos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
end

function PathFinderManager.TransferMapPos(mapId, pos, line)
  networkRequest.ReqTransmit(mapId, line, pos.x, pos.y)
end

function PathFinderManager.MoveToLinePos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
  this.pathfindingRecord = {}
  this.pathfindingRecord.type = PathMoveType.SwitchLineMove
  this.pathfindingRecord.groupId = groupId
  this.pathfindingRecord.pos = pos
  this.pathfindingRecord.transferId = transferId
  this.pathfindingRecord.line = line
  this.pathfindingRecord.param = param
  this.pathfindingRecord.purpose = purpose == nil and Purpose.None or purpose
  this.pathfindingRecord.OnArrive = OnArrive
  this.pathfindingRecord.range = range
  this.pathfindingRecord.isStopTask = isStopTask
  this.SwitchLineMove.MoveToLinePos(groupId, pos, transferId, line, param, purpose, OnArrive, range, isStopTask)
end

function PathFinderManager.MoveToPosHangUpAutoFight(groupId, pos)
  this.PosMove.MoveToPosHangUpAutoFight(groupId, pos)
end

function PathFinderManager.ChatMoveToLinePos(mapId, pos)
  this.SwitchLineMove.ChatMoveToLinePos(mapId, pos)
end

function PathFinderManager.Update()
  this.NpcMove.Update()
  this.NpcJumpMapMove.Update()
  this.PosMove.Update()
  this.SwitchLineMove.Update()
  this.JumpMapToPos.Update()
  this.EnterPickUp()
end

function PathFinderManager.ResetData()
  this.NpcMove.ResetData()
  this.NpcJumpMapMove.ResetData()
  this.PosMove.ResetData()
  this.FlyMove.ResetData()
  this.SwitchLineMove.ResetData()
  this.JumpMapToPos.ResetData()
  this.pathFinding.Reset()
  this.PickUp = false
  this.pathfindingRecord = {}
end

function PathFinderManager.PathOnOpenFly(transferId, line, param, purpose, onArrive)
  this.FlyMove.OpenFlyPanel(transferId, line, param, purpose, onArrive)
end

function PathFinderManager.FlyTransferScene(transferId, line, param, purpose, onArrive)
  if type(transferId) ~= "number" then
    return
  end
  local transferTbl = ClientTable.cfg_Map_transferManager:TryGetValue(transferId)
  if type(transferTbl) ~= "table" then
    return
  end
  if type(param) ~= "table" then
    param = {}
  end
  if param.npcId == nil then
    param.npcId = transferTbl.npcId
  end
  if purpose == nil then
    purpose = transferTbl.purpose
  end
  this.FlyMove.FlyTransferScene(transferId, line, param, purpose, onArrive)
end

function PathFinderManager.CloseFlyShoeUI()
  this.pathFinding.CloseFlyShoeUI()
end

function PathFinderManager.GetTransIdByGroupId(groupId)
  for i = 1, table.count(this.transferTbl) do
    if this.transferTbl[i].groupId == groupId then
      return this.transferTbl[i].id
    end
  end
end

function PathFinderManager.SwitchLine(type, line)
  this.SwitchLineMove.SwitchLine(type, line)
end

function PathFinderManager.IsReachPoint(posData)
  return this.pathFinding.IsReachPoint(posData)
end

function PathFinderManager.Compare(a, b)
  return this.pathFinding.Compare(a, b)
end

function PathFinderManager.GetCalcPosData(posData)
  local posTable = {}
  local posArray
  if string.contains(tostring(posData), "_") then
    posArray = string.split(posData, "_")
  else
    posArray = string.split(posData, "#")
  end
  posTable = {
    x = tonumber(posArray[1]),
    y = tonumber(posArray[2])
  }
  return posTable
end

function PathFinderManager.GetCalcPosDataWithSymbol(posData, symbol)
  local posTable = {}
  local posArray
  if symbol then
    posArray = string.split(posData, symbol)
  else
    posArray = string.split(posData, "#")
  end
  posTable = {
    x = tonumber(posArray[1]),
    y = tonumber(posArray[2])
  }
  return posTable
end

local function WaitFindPath()
  if ForgeData.UseRandomStoneState == EUseStoneRecordEnum.Fight then
    if not Scene.IsSafeZone(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y) then
      RoleManager.me:SetAutoFight(AutoFightStrKey.AutoFight)
    end
  elseif ForgeData.UseRandomStoneState == EUseStoneRecordEnum.Path and this.pathfindingRecord ~= nil then
    if this.pathfindingRecord.type == PathMoveType.NpcMove then
      this.MoveToNpc(this.pathfindingRecord.param, this.pathfindingRecord.transferId, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.NpcJumpMapMove then
      this.JumpMapMoveToNpc(this.pathfindingRecord.param, this.pathfindingRecord.transferId, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.PosMove then
      this.MoveToPos(this.pathfindingRecord.groupId, this.pathfindingRecord.pos, this.pathfindingRecord.transferId, this.pathfindingRecord.line, this.pathfindingRecord.param, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.JumpMapMove then
      this.JumpMapToMoveToPos(this.pathfindingRecord.groupId, this.pathfindingRecord.pos, this.pathfindingRecord.transferId, this.pathfindingRecord.line, this.pathfindingRecord.param, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.SwitchLineMove then
      this.MoveToLinePos(this.pathfindingRecord.groupId, this.pathfindingRecord.pos, this.pathfindingRecord.transferId, this.pathfindingRecord.line, this.pathfindingRecord.param, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.MapClick then
      local path = RoleManager.me:MoveTo(this.pathfindingRecord.pos, nil, function()
        if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
          UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
        end
      end)
    end
    EventManager.Dispatch(Event.Map_PathChange, RoleManager.me.movePath)
  end
  ForgeData.UseRandomStoneState = EUseStoneRecordEnum.None
end

function PathFinderManager.PathRecord()
  Timer.Start(0.2, WaitFindPath)
end

function PathFinderManager.PickUpDropItems()
  if this.pathfindingRecord and this.pathfindingRecord.purpose and this.pathfindingRecord.purpose ~= Purpose.ForTask then
    this.PickUp = true
  end
end

function PathFinderManager.EnterPickUp()
  if this.PickUp and this.pathfindingRecord and this.pathfindingRecord.purpose and this.pathfindingRecord.purpose ~= Purpose.ForTask then
    if not TaskManager.NeedPickUp() then
      if this.PickUp and RoleManager.me and RoleManager.me:CanMove() and not MapMonsterLockManager.startCircle then
        if QiJiHelperData.isAutoFight then
          this.PickUp = false
          RoleManager.me:SetAutoTaskFight(AutoFightStrKey.None)
        end
        this.pathFinding.Reset()
        this.CotuinePath()
      end
    elseif QiJiHelperData.isAutoFight == false then
      if DropItemManager.IsHasPowerToAutoPickUp() then
        RoleManager.me:StopMove()
        this.PickUp = true
      else
        RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
        this.PickUp = true
      end
    end
  end
end

function PathFinderManager.CotuinePath()
  if this.pathfindingRecord and this.pathfindingRecord.purpose and this.pathfindingRecord.purpose ~= Purpose.ForTask then
    if this.pathfindingRecord.type == PathMoveType.NpcMove then
      this.MoveToNpc(this.pathfindingRecord.param, this.pathfindingRecord.transferId, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.NpcJumpMapMove then
      this.JumpMapMoveToNpc(this.pathfindingRecord.param, this.pathfindingRecord.transferId, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.PosMove then
      this.MoveToPos(this.pathfindingRecord.groupId, this.pathfindingRecord.pos, this.pathfindingRecord.transferId, this.pathfindingRecord.line, this.pathfindingRecord.param, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.JumpMapMove then
      this.JumpMapToMoveToPos(this.pathfindingRecord.groupId, this.pathfindingRecord.pos, this.pathfindingRecord.transferId, this.pathfindingRecord.line, this.pathfindingRecord.param, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.SwitchLineMove then
      this.MoveToLinePos(this.pathfindingRecord.groupId, this.pathfindingRecord.pos, this.pathfindingRecord.transferId, this.pathfindingRecord.line, this.pathfindingRecord.param, this.pathfindingRecord.purpose, this.pathfindingRecord.OnArrive, this.pathfindingRecord.range, this.pathfindingRecord.isStopTask)
    elseif this.pathfindingRecord.type == PathMoveType.MapClick then
      local path = RoleManager.me:MoveTo(this.pathfindingRecord.pos, nil, function()
        if UIManager.IsVisible(UIID.FlyShoe_FlyShoeUI) then
          UIManager.Hide(UIID.FlyShoe_FlyShoeUI)
        end
      end)
    end
  end
end

function PathFinderManager.OpenNpcPanelParam(param)
  local npcTbl = ConfigManager.GetConfig("cfg_Npc_npc", param.npcId, "npcId")
  local metaTbl = getmetatable(npcTbl)
  if metaTbl then
    metaTbl = table.copy(nil, metaTbl.__index)
    npcTbl = table.copy(metaTbl, npcTbl)
    npcTbl.param = param
  end
  local npc = RoleManager.GetNpcByConfigId(param.npcId)
  if npc and npc:NpcOutLine() then
    npc:NpcOutLine()
  end
  EventManager.Dispatch(Event.OpenNpcPanel, npcTbl)
end

PathFinderManager.Init()
