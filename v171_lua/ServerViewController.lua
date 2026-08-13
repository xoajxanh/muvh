require("GameModel/ViewData")
require("GameModel/RoleEquipData")
require("GameConst/ServerEnum")
require("GameController/ServerViewFixer")
ServerViewController = {}
local this = ServerViewController

function ServerViewController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.RegistMessages()
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvents()
  ServerViewFixer.Init()
end

function ServerViewController.RegistMessages()
  this.messageContainer:Regist(MapMessage.ResBuildView, this.RefreshView)
  this.messageContainer:Regist(MapMessage.ResUpdateView, this.RefreshView)
  this.messageContainer:Regist(MapMessage.ResExitView, this.OnExitView)
  this.messageContainer:Regist(MapMessage.ResPlayerEnterView, this.OnResPlayerEnterView)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundPlayer, this.OnResUpdateRole)
  this.messageContainer:Regist(MapMessage.ResMonsterEnterView, this.OnResMonsterEnterView)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundMonster, this.OnResUpdateRole)
  this.messageContainer:Regist(MapMessage.ResNpcEnterView, this.OnResNpcEnterView)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundNpc, this.OnResUpdateRole)
  this.messageContainer:Regist(MapMessage.ResItemEnterView, this.OnResItemEnterView)
  this.messageContainer:Regist(MapMessage.ResBlockBuildingEnterView, this.OnResBlockBuildingEnterView)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundBlockBuilding, this.OnResUpdateBlockBuilding)
  this.messageContainer:Regist(MapMessage.ResTrapEnterView, this.OnResTrapEnterView)
  this.messageContainer:Regist(MapMessage.ResMove, this.OnResMove)
  this.messageContainer:Regist(MapMessage.ResChangePos, this.OnResChangePos)
  this.messageContainer:Regist(MapMessage.ResChangeDir, this.OnResChangeDir)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundTransmit, this.OnResUpdateTransView)
  this.messageContainer:Regist(MapMessage.ResTransmitEnterView, this.OnResTransEnterView)
  this.messageContainer:Regist(MapMessage.ResGraveEnterView, this.OnResGraveEnterView)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundGrave, this.OnResUpdateRoundGrave)
  this.messageContainer:Regist(MapMessage.ResBossSmallIcon, this.OnResResAllBossSmallIcon)
  this.messageContainer:Regist(MapMessage.ResSingleBossSmallIcon, this.OnResSingleBossSmallIcon)
  this.messageContainer:Regist(MapMessage.ResAuctionEnterView, this.OnResAuctionEnterView)
  this.messageContainer:Regist(MapMessage.ResUpdateRoundAuction, this.OnResUpdateRoundAuction)
end

function ServerViewController.RegistEvents()
  this.eventContainer:Regist(Event.Role_OnChangeMap, this.OnChangeMap)
end

function ServerViewController.OnChangeMap(_)
  RoleManager.DestroyOtherRoles()
  ServerViewController:ClearPlayers()
  ViewData.RemoveAllOtherGameObjects()
end

function ServerViewController.RefreshView(id, viewMsg)
  if not viewMsg then
    return
  end
  local tmpCnt = array.length(viewMsg.exitIds)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.GameObjectExitView(viewMsg.exitIds[i])
    end
  end
  this:AddPlayers(viewMsg.addPlayers)
  tmpCnt = array.length(viewMsg.addMonsters)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.MonsterEnterView(viewMsg.addMonsters[i])
    end
  end
  tmpCnt = array.length(viewMsg.addNpcs)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.NPCEnterView(viewMsg.addNpcs[i])
    end
  end
  tmpCnt = array.length(viewMsg.addItems)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.ItemEnterView(viewMsg.addItems[i], true)
    end
  end
  tmpCnt = array.length(viewMsg.addBlockBuildings)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.BlockBuildingsEnterView(viewMsg.addBlockBuildings[i])
    end
  end
  tmpCnt = array.length(viewMsg.addTraps)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.TrapEnterView(viewMsg.addTraps[i])
    end
  end
  tmpCnt = array.length(viewMsg.addTransmits)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.TransEnterView(viewMsg.addTransmits[i])
    end
  end
  tmpCnt = array.length(viewMsg.addGraves)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.GraveEnterView(viewMsg.addGraves[i])
    end
  end
  tmpCnt = array.length(viewMsg.addAuction)
  if 0 < tmpCnt then
    for i = 1, tmpCnt do
      this.AuctionEnterView(viewMsg.addAuction[i])
    end
  end
end

function ServerViewController.OnExitView(id, msg)
  this.GameObjectExitView(msg.exitId)
end

function ServerViewController.OnResPlayerEnterView(id, msg)
  this.PlayerEnterView(msg)
end

function ServerViewController.OnResMonsterEnterView(id, msg)
  this.MonsterEnterView(msg)
end

function ServerViewController.OnResNpcEnterView(id, msg)
  this.NPCEnterView(msg)
end

function ServerViewController.OnResItemEnterView(id, msg)
  this.ItemEnterView(msg, true)
end

function ServerViewController.OnResBlockBuildingEnterView(id, msg)
  this.BlockBuildingsEnterView(msg)
end

function ServerViewController.OnResTrapEnterView(id, msg)
  this.TrapEnterView(msg)
end

function ServerViewController.OnResUpdateTransView(id, msg)
  this.UpdateTransView(msg)
end

function ServerViewController.OnResTransEnterView(id, msg)
  this.TransEnterView(msg)
end

function ServerViewController.OnResGraveEnterView(id, msg)
  this.GraveEnterView(msg)
end

function ServerViewController.OnResAuctionEnterView(id, msg)
  this.AuctionEnterView(msg)
end

function ServerViewController:OnResUpdateRoundAuction(id, msg)
  this.UpdateRoundAuction(msg)
end

function ServerViewController.OnResUpdateRoundGrave(id, msg)
  this.UpdateGraveView(msg)
end

function ServerViewController.OnResUpdateRole(id, msg)
  if msg.info then
    RoleEquipUtility.UpdatePlayerAppearData(msg.info.roleId, msg.info.appear)
  end
  this.UpdateRole(msg)
end

function ServerViewController.OnResUpdateBlockBuilding(id, msg)
  this.UpdateBlockBuilding(msg)
end

function ServerViewController.OnResResAllBossSmallIcon(id, msg)
  ForgeData.BossAndEliteStateData = msg
  EventManager.Dispatch(Event.Map_MonsterAllState, msg)
  SceneData.SetMapAllMonState(msg)
end

function ServerViewController.OnResSingleBossSmallIcon(id, msg)
  table.insert(ForgeData.BossAndEliteSingleData, msg)
  EventManager.Dispatch(Event.Map_MonsterStateChange, msg)
  SceneData.SetMapSingleMonState(msg)
end

function ServerViewController.PlayerEnterView(playerMsg)
  if RoleManager.me == nil then
    return
  end
  if playerMsg ~= nil and playerMsg.info.roleId == RoleManager.me.id then
    return
  end
  if playerMsg.info then
    RoleEquipUtility.UpdatePlayerAppearData(playerMsg.info.roleId, playerMsg.info.appear)
  end
  ViewData.AddPlayer(playerMsg)
end

function ServerViewController.MonsterEnterView(monsterMsg)
  ViewData.AddMonster(monsterMsg)
end

function ServerViewController.NPCEnterView(npcMsg)
  ViewData.AddNPC(npcMsg)
end

function ServerViewController.ItemEnterView(itemMsg, isMonsterDeath)
  ViewData.AddItem(itemMsg, isMonsterDeath)
end

function ServerViewController.BlockBuildingsEnterView(blockBuildingMsg)
  ViewData.AddBlockBuilding(blockBuildingMsg)
end

function ServerViewController.TrapEnterView(trapMsg)
  ViewData.AddTrap(trapMsg)
end

function ServerViewController.UpdateTransView(transMsg)
  ViewData.UpdateTrans(transMsg)
end

function ServerViewController.TransEnterView(transMsg)
  ViewData.AddTrans(transMsg)
end

function ServerViewController.GraveEnterView(transMsg)
  ViewData.AddGrave(transMsg)
end

function ServerViewController.UpdateGraveView(transMsg)
  ViewData.UpdateGrave(transMsg)
end

function ServerViewController.UpdateRole(roleMsg)
  ViewData.UpdateRole(roleMsg)
end

function ServerViewController.UpdateBlockBuilding(blockBuildingMsg)
  ViewData.UpdateBlockBuilding(blockBuildingMsg)
end

function ServerViewController.GameObjectExitView(gameObjectId)
  if gameObjectId == RoleManager.me.id then
    return
  end
  local removedGameObject = ViewData.RemoveGameObject(gameObjectId)
  ServerViewController:RemovePlayers(gameObjectId)
  EventManager.Dispatch(Event.UnionNpcExitView, gameObjectId)
  if removedGameObject == nil then
    return
  end
end

function ServerViewController.AuctionEnterView(msg)
  ViewData.AddPlayerShop(msg)
end

function ServerViewController.UpdateRoundAuction(msg)
end

local PosChangedDataTable = {
  roleId = 0,
  moveType = ERoleMoveType.Run,
  changePosReason = ERoleChangePosReason.Move,
  moveSpeed = 0,
  reasonParam = nil
}

function ServerViewController.OnResMove(id, msg)
  if ViewData.meData.id == msg.lid then
    EventManager.Dispatch(Event.CanNotCollectBox)
    EventManager.Dispatch(Event.UnionMoveResReturn)
    return
  end
  local ret = ViewData.ChangeRoleServerPos(msg.lid, msg.x, msg.y)
  if not ret then
    ServerViewFixer.AddMovingMissingRole(msg.lid, msg.x, msg.y)
    return
  end
  local moveType = this.ParseMoveAction(msg.action)
  PosChangedDataTable.roleId = msg.lid
  PosChangedDataTable.moveType = moveType
  PosChangedDataTable.changePosReason = ERoleChangePosReason.Move
  PosChangedDataTable.moveSpeed = msg.moveSpeed
  EventManager.Dispatch(Event.Role_OnRoleServerPosChanged, PosChangedDataTable)
end

function ServerViewController.OnResChangePos(id, msg)
  if msg.reason ~= ERoleChangePosReason.Scene_Interactive and msg.lid == ViewData.meData.id then
    if UIManager.IsVisible(UIID.MapNameUI) then
      Main_MapNameUI:Refresh()
    else
      UIManager.Show(UIID.MapNameUI)
    end
  end
  local ret = ViewData.ChangeRoleServerPos(msg.lid, msg.x, msg.y)
  if not ret then
    ServerViewFixer.AddMovingMissingRole(msg.lid, msg.x, msg.y)
    return
  end
  PosChangedDataTable.roleId = msg.lid
  PosChangedDataTable.moveType = ERoleMoveType.Stand
  PosChangedDataTable.changePosReason = msg.reason
  PosChangedDataTable.moveSpeed = nil
  PosChangedDataTable.reasonParam = msg.reasonParam
  EventManager.Dispatch(Event.Role_OnRoleServerPosChanged, PosChangedDataTable)
end

function ServerViewController.OnResChangeDir(id, msg)
  ViewData.ChangeRoleServerDir(msg)
  EventManager.Dispatch(Event.Role_OnRoleServerDirChanged, msg.lid)
end

function ServerViewController.ParseMoveAction(serverAction)
  local moveType = ERoleMoveType.Stand
  if serverAction == 1 then
    moveType = ERoleMoveType.Walk
  elseif serverAction == 2 then
    moveType = ERoleMoveType.Run
  end
  return moveType
end

ServerViewController.Init()
ServerViewController.playerEnterViewAsyncCount = 1
ServerViewController.waitLoadPlayers = nil
ServerViewController.LoadPlayers = nil
ServerViewController.IsLoading = false

function ServerViewController:AddPlayers(players)
  if type(players) ~= "table" or next(players) == nil then
    return
  end
  if self.LoadPlayers == nil then
    self.LoadPlayers = {}
  end
  if self.waitLoadPlayers == nil then
    self.waitLoadPlayers = {}
  end
  for k, v in pairs(players) do
    self.waitLoadPlayers[v.info.roleId] = v
  end
  if self.addPlayerCoroutine == nil then
    self.addPlayerCoroutine = Coroutine.Start(self.LoadPlayerAsync, self)
  end
end

function ServerViewController:RemovePlayers(lid)
  if self.LoadPlayers ~= nil then
    self.LoadPlayers[lid] = nil
  end
  if self.waitLoadPlayers ~= nil then
    self.waitLoadPlayers[lid] = nil
  end
end

function ServerViewController:ClearPlayers()
  if self.addPlayerCoroutine ~= nil then
    Coroutine.Stop(self.addPlayerCoroutine)
    self.addPlayerCoroutine = nil
  end
  self.waitLoadPlayers = nil
  self.LoadPlayers = nil
end

function ServerViewController:LoadPlayerAsync()
  while true do
    self.IsLoading = true
    self:WaitListToLoading()
    if self:HaveLoadData() == false then
      break
    end
    self:LoadData()
    self.IsLoading = false
    Coroutine.Wait(0)
  end
  self.IsLoading = false
  if self.addPlayerCoroutine ~= nil then
    Coroutine.Stop(self.addPlayerCoroutine)
    self.addPlayerCoroutine = nil
  end
end

function ServerViewController:WaitListToLoading()
  if type(self.waitLoadPlayers) ~= "table" or next(self.waitLoadPlayers) == nil then
    return
  end
  for k, v in pairs(self.waitLoadPlayers) do
    self.LoadPlayers[k] = v
  end
  self.waitLoadPlayers = {}
end

function ServerViewController:HaveLoadData()
  return next(self.LoadPlayers) ~= nil
end

function ServerViewController:LoadData()
  local removeList = {}
  for k, v in pairs(self.LoadPlayers) do
    if self:IsNeedAsync() == true then
      break
    end
    table.insert(removeList, k)
    self.PlayerEnterView(v)
  end
  for k, v in pairs(removeList) do
    self.LoadPlayers[v] = nil
  end
end

function ServerViewController:IsNeedAsync()
  if self.curPlayerEnterViewAsyncCount == nil then
    self.curPlayerEnterViewAsyncCount = 0
  end
  if self.curPlayerEnterViewAsyncCount >= self.playerEnterViewAsyncCount then
    self.curPlayerEnterViewAsyncCount = 0
    return true
  end
  self.curPlayerEnterViewAsyncCount = self.curPlayerEnterViewAsyncCount + 1
  return false
end
