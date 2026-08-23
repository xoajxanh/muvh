local PlayerDisplayController = {}
local this = PlayerDisplayController
local visiblePayers = {}
local invisiblePlayers = {}
local curVisiblePlayerCount = 0
local maxVisiblePlayerCount = math.maxinteger
local lastRefreshCellPos = Vector2Int(-20, -20)
local REFRESH_DISTANCE = 20

local function distanceSortFunc(a, b)
  local cellPos = RoleManager.me.cellPos
  return Vector2Int.DistancePow(a.cellPos, cellPos) < Vector2Int.DistancePow(b.cellPos, cellPos)
end

local function getDistanceSortedPlayers(roles)
  local res = {}
  for _, v in pairs(roles) do
    if v then
      table.insert(res, v)
    end
  end
  table.sort(res, distanceSortFunc)
  return res
end

local function getDistanceSortedSeveralPlayers(roles, count)
  local sortedPlayers = getDistanceSortedPlayers(roles)
  local res = {}
  local minCount = math.min(count, #sortedPlayers)
  for i = 1, minCount do
    res[#res + 1] = sortedPlayers[i]
  end
  return res
end

function PlayerDisplayController.InitData(maxShowPlayerCount)
  maxVisiblePlayerCount = maxShowPlayerCount
  visiblePayers = {}
  invisiblePlayers = {}
end

function PlayerDisplayController.Init()
  this.RegistEvents()
end

function PlayerDisplayController.LeaveGame()
  this.eventContainer:UnRegistAll()
  visiblePayers = nil
  invisiblePlayers = nil
end

function PlayerDisplayController.RegistEvents()
  this.eventContainer = EventContainer(EventManager)
  this.eventContainer:Regist(Event.Scene_OnEnterScene, this.OnChangeMap)
  this.eventContainer:Regist(Event.Role_OnMePosChanged, this.OnMePosChanged)
  this.eventContainer:Regist(Event.Role_OnRoleCreated, this.OnRoleCreated)
  this.eventContainer:Regist(Event.Role_RoleDestroyed, this.OnRoleDestroyed)
end

function PlayerDisplayController.OnChangeMap(_)
  this.RefreshVisiblePlayers()
end

function PlayerDisplayController.OnMePosChanged(_)
  if RoleManager.me then
    local dis = Vector2Int.DistancePow(RoleManager.me.cellPos, lastRefreshCellPos)
    if dis >= REFRESH_DISTANCE * REFRESH_DISTANCE then
      this.RefreshVisiblePlayers()
    end
  end
end

function PlayerDisplayController.RefreshVisiblePlayers()
  this.SetVisiblePlayersCount(maxVisiblePlayerCount)
  if RoleManager.me ~= nil then
    lastRefreshCellPos = RoleManager.me.cellPos
  end
end

function PlayerDisplayController.OnRoleCreated(_, role)
  if role.RoleType ~= GameSettingsData.visibleRoleLimitType then
    return
  end
  if this.ShouldShowRole(role) then
    if GameSettingsController.ShouldShowModel(role) then
      this.AddVisiblePlayer(role)
    end
  else
    this.AddInvisiblePlayer(role)
  end
end

function PlayerDisplayController.OnRoleDestroyed(_, role)
  if role.RoleType ~= GameSettingsData.visibleRoleLimitType then
    return
  end
  local roleEverVisibled = visiblePayers[role.id] ~= nil
  if visiblePayers[role.id] ~= nil then
    curVisiblePlayerCount = curVisiblePlayerCount - 1
  end
  visiblePayers[role.id] = nil
  invisiblePlayers[role.id] = nil
end

function PlayerDisplayController.ShouldShowRole(role)
  return role.RoleType == GameSettingsData.visibleRoleLimitType and maxVisiblePlayerCount >= curVisiblePlayerCount
end

function PlayerDisplayController.SetVisiblePlayersCount(count)
  if count < curVisiblePlayerCount and 0 < count or count == 0 then
    local sortedPlayers = getDistanceSortedPlayers(visiblePayers)
    maxVisiblePlayerCount = count
    for i = count + 1, #sortedPlayers do
      if sortedPlayers[i] ~= nil then
        this.AddInvisiblePlayer(sortedPlayers[i])
      end
    end
  elseif count > curVisiblePlayerCount then
    local players = getDistanceSortedSeveralPlayers(invisiblePlayers, count - curVisiblePlayerCount)
    maxVisiblePlayerCount = count
    for i = 1, #players do
      local display = GameSettingsController.ShouldShowModel(players[i])
      if display then
        this.AddVisiblePlayer(players[i])
      end
    end
  end
  maxVisiblePlayerCount = count
end

function PlayerDisplayController.AddVisiblePlayer(player)
  if curVisiblePlayerCount > maxVisiblePlayerCount then
    return
  end
  player:SetModelDisplay(true)
  visiblePayers[player.id] = player
  invisiblePlayers[player.id] = nil
  curVisiblePlayerCount = curVisiblePlayerCount + 1
end

function PlayerDisplayController.AddInvisiblePlayer(player)
  player:SetModelDisplay(false)
  if visiblePayers[player.id] ~= nil then
    curVisiblePlayerCount = curVisiblePlayerCount - 1
  end
  visiblePayers[player.id] = nil
  invisiblePlayers[player.id] = player
end

this.Init()
return PlayerDisplayController
