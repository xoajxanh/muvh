require("GameConst/RankEnum")
RankListData = {}
local this = RankListData
this.RankListAll = {
  [RANKTYPE.level] = {},
  [RANKTYPE.fight] = {},
  [RANKTYPE.tower] = {},
  [RANKTYPE.crossLevel] = {},
  [RANKTYPE.crossFight] = {},
  [RANKTYPE.attack] = {},
  [RANKTYPE.Crosskalunte] = {},
  [RANKTYPE.CrossThree] = {},
  [RANKTYPE.killMonsterScore] = {}
}

function RankListData.InitRankData(rankType, data)
  if data then
    this.RankListAll[rankType][data.career] = data.ranks
  end
  EventManager.Dispatch(Event.Rank_UpdateTableView)
end

function RankListData.ResetData()
  this.RankListAll = {
    [RANKTYPE.level] = {},
    [RANKTYPE.fight] = {},
    [RANKTYPE.tower] = {},
    [RANKTYPE.crossLevel] = {},
    [RANKTYPE.crossFight] = {},
    [RANKTYPE.attack] = {},
    [RANKTYPE.Crosskalunte] = {},
    [RANKTYPE.CrossThree] = {},
    [RANKTYPE.killMonsterScore] = {}
  }
end

function RankListData.GetPlayerId(selectRankType, selectCareer, index)
  return this.RankListAll[selectRankType][selectCareer][index].lid
end

function RankListData.UpdateViewRoleData(selectTable)
  local playerData = this.GetPlayerData(selectTable)
  if playerData == false then
    EventManager.Dispatch(Event.Rank_UpdateViewModel)
    return
  end
  local viewRoleData = {}
  local equipData = RoleEquipData(playerData.equips)
  viewRoleData.equipsData = equipData
  viewRoleData.career = playerData.career
  viewRoleData.modelType = EModelType.Charactor
  viewRoleData.model = 1003
  viewRoleData.id = playerData.lid
  viewRoleData.roleName = playerData.name
  viewRoleData.serverCoord = Vector2Int()
  viewRoleData.roleType = ERoleType.Player
  viewRoleData.holyRingInfo = playerData.holyRingInfo
  viewRoleData.buffs = playerData.buffIds
  if playerData.lid == ViewData.meData.id then
    viewRoleData.equipsData = ViewData.meData.equipsData
  else
    ForgeData.appearData[playerData.lid] = playerData.appear or "{}"
  end
  EventManager.Dispatch(Event.Rank_UpdateViewModel, viewRoleData)
end

function RankListData.GetPlayerEquipsData(equips)
  return RoleEquipData(equips)
end

function RankListData.GetPlayerData(selectTable)
  local rank = this.RankListAll[selectTable.rankType] or false
  rank = rank and rank[selectTable.selectCareer] or false
  rank = rank and rank[selectTable.index] or false
  return rank
end
