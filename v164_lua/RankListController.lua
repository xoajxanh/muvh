require("GameModel/RankListData")
require("GameConst/RankEnum")
require("GameConst/RoleInteractEnum")
RankListController = {}
local this = RankListController

function RankListController.Init()
  this.messageContainer = EventContainer(NetManager)
  this.eventContainer = EventContainer(EventManager)
  this.RegistEvent()
  this.RegistMessages()
end

function RankListController.RegistMessages()
  this.messageContainer:Regist(RankMessage.ResLevelRanks, this.OnResLevelRanks)
  this.messageContainer:Regist(RankMessage.ResFightValueRanks, this.OnResFightRanks)
  this.messageContainer:Regist(RankMessage.ResWarriorTrialRanks, this.OnResTowerRanks)
  this.messageContainer:Regist(RankMessage.ResMaxAttackRanks, this.OnResMaxAttackRanks)
  this.messageContainer:Regist(RankMessage.ResColetRuinsRankRanks, this.OnResKalunteRanks)
  this.messageContainer:Regist(RankMessage.ResPVPScoreRank, this.OnResThreeRanks)
  this.messageContainer:Regist(RankMessage.ResKillMonsterScoreRanks, this.OnResKillMonsterScoreRanks)
end

function RankListController.UnRegistMessages()
  this.messageContainer:UnRegistAll()
end

function RankListController.OnResLevelRanks(id, msg)
  if msg.type == RANKTYPE.level then
    RankListData.InitRankData(RANKTYPE.level, msg)
  else
    RankListData.InitRankData(RANKTYPE.crossLevel, msg)
  end
end

function RankListController.OnResFightRanks(id, msg)
  if msg.type == RANKTYPE.fight then
    RankListData.InitRankData(RANKTYPE.fight, msg)
  else
    RankListData.InitRankData(RANKTYPE.crossFight, msg)
  end
end

function RankListController.OnResTowerRanks(id, msg)
  RankListData.InitRankData(RANKTYPE.tower, msg)
end

function RankListController.OnResMaxAttackRanks(id, msg)
  RankListData.InitRankData(RANKTYPE.attack, msg)
end

function RankListController.OnResKalunteRanks(id, msg)
  gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetCrossServerData():InitRankData(msg)
end

function RankListController.OnResThreeRanks(id, msg)
  RankListData.InitRankData(RANKTYPE.CrossThree, msg)
end

function RankListController.OnResKillMonsterScoreRanks(id, msg)
  RankListData.InitRankData(RANKTYPE.killMonsterScore, msg)
end

function RankListController.RegistEvent()
  this.eventContainer:Regist(Event.Rank_SetCurrentCareer, this.SetCurrentCareer)
  this.eventContainer:Regist(Event.Rank_QueryRanks, this.GetQueryRanks)
  this.eventContainer:Regist(Event.Rank_UpdateViewRoleData, this.UpdateViewRoleData)
end

function RankListController.GetQueryRanks(id, rankType, career)
  local msg = {rankType = rankType, career = career}
  NetManager.Send(RankMessage.ReqQueryRanks, msg)
end

function RankListController.UpdateViewRoleData(id, selectTable)
  RankListData.UpdateViewRoleData(selectTable)
end
