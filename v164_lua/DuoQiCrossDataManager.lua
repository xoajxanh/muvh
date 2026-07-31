local DuoQiCrossDataManager = {}
setmetatable(DuoQiCrossDataManager, LuaClass.PlayActivity)
local this = DuoQiCrossDataManager
this.cfgOfPersonalPoints = {}
this.cfgOfPersonalPointsOfDuoQiZhengBa = {}
this.cfgOfActivityRankReward = {}
this.cfgOfActivityRankRewardOfDuoQiZhengBa = {}
this.rankMaterialInfos = nil
this.rankMaterialInfosOfSettle = nil
this.cfgOfFlags = nil
this.cfgOfFlagsOfMiniMap = {}
this.cfgOfStronghold = {}
this.serverData = nil
this.playerInfo = nil
this.strongholdInfo = {}
this.strongholdNeedInfo = {}
this.unionInfo = {}
this.myplayerInfo = {}
this.myGetedRewardCount = 0
this.myShowRewardLevel = 1
this.myReachedRewardLevel = 0
this.isInUnionMap = false
this.colloctingBoxData = nil
this.strongholdAroundData = {}
this.isCollecting = nil
this.isRobBtnOpen = nil
this.isEnteredUnionMap = false
this.bubbleStrs = {}
this.isProgressResReturn = false
this.isMoveResReturn = false
this.unionNameFormat = nil
this.unionNameColor = {}
this.noUnionStr = nil
this.unionNameColorOfMap = {}
this.boxMapInfo = {}
this.unionEndTimer_New = nil
this.unionProcessDispatchTimer = nil
this.unionMoveDispatchTimer = nil
this.isAllRewardGeted = false
this.canNotOperateStr = ""
this.unionLackStr = ""
this.levelLackStr = ""
this.unionActiNotOpenStr = ""
this.canNotChangeMode = ""
this.needRoleLevel = 1
this.needRoleLevelOfZhengBa = 1
this.collectDis = 0
this.checkMoveTime = 500
this.announceTimer = nil
this.announceQueue = {}
this.announceTime = 4000
this.killNumOfIdCfg = {}
this.killArtFont = ""
this.reliveCD = 12000
this.reliveTip = ""
this.noEnemyOfFlagTip = ""
this.boxNameScale = 100
this.reliveTimer = nil
this.canReliveTime = nil
this.lastMapId = 0
this.personalScoreStr = "%d"
this.oneRankStr = "%s"
this.twoRankStr = "%s~%s"
this.effHight = 290
this.isBoxMapRefresh = false
this.isShowBtnDuoQiEnter = false
this.isShowBtnDuoQiZhengBaEnter = false
this.isGreenOpenTimeStr = false
local RewardType = {
  personalCore = 1,
  unionReward = 2,
  presidentReward = 3
}
local ZhangBaRewardType = {
  personalCore = 1,
  unionReward = 2,
  presidentReward = 3
}
local EffType = {
  GreenEff = "Eff_zhanqifanwei_01",
  RedEff = "Eff_zhanqifanwei_02",
  Orange = "Eff_zhanqifanwei_03"
}

function DuoQiCrossDataManager:Init()
  this:InitData()
end

function DuoQiCrossDataManager:InitData()
  if next(this.cfgOfActivityRankReward) == nil then
    local allCfg = ClientTable.cfg_Activity_rankRewardManager:GetDic()
    local tempCfg = {}
    local tempCfg2 = {}
    if next(allCfg) ~= nil then
      for i, v in pairs(allCfg) do
        if v.activityId == PlayActivityIdType.DuoQiCross then
          if v.condition == nil then
            return
          end
          local isOpen = ConditionManager.Check4D(v.condition)
          if isOpen then
            table.insert(tempCfg, v)
          end
        elseif v.activityId == PlayActivityIdType.DuoQiZhengBa then
          if v.condition == nil then
            return
          end
          local isOpen = ConditionManager.Check4D(v.condition)
          if isOpen then
            table.insert(tempCfg2, v)
          end
        end
      end
    end
    this.cfgOfActivityRankReward = tempCfg
    this.cfgOfActivityRankRewardOfDuoQiZhengBa = tempCfg2
  end
  if next(this.cfgOfPersonalPoints) == nil then
    local allCfg = ClientTable.cfg_Activity_rank_duoqiManager:GetDic()
    local tempCfg = {}
    local tempCfg2 = {}
    if next(allCfg) then
      for i, v in pairs(allCfg) do
        if v.activityId == PlayActivityIdType.DuoQiCross then
          if v.condition == nil then
            return
          end
          local isOpen = ConditionManager.Check4D(v.condition)
          if isOpen then
            table.insert(tempCfg, v)
          end
        elseif v.activityId == PlayActivityIdType.DuoQiZhengBa then
          if v.condition == nil then
            return
          end
          local isOpen = ConditionManager.Check4D(v.condition)
          if isOpen then
            table.insert(tempCfg2, v)
          end
        end
      end
    end
    table.sort(tempCfg, function(a, b)
      return a.id < b.id
    end)
    table.sort(tempCfg2, function(a, b)
      return a.id < b.id
    end)
    this.cfgOfPersonalPoints = tempCfg
    this.cfgOfPersonalPointsOfDuoQiZhengBa = tempCfg2
  end
  if this.rankMaterialInfos == nil then
    local cfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500201)
    if cfg == nil or cfg.effect == nil then
      return
    end
    this.rankMaterialInfos = cfg.effect
  end
  if this.rankMaterialInfosOfSettle == nil then
    local cfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500202)
    if cfg == nil or cfg.effect == nil then
      return
    end
    this.rankMaterialInfosOfSettle = cfg.effect
  end
  if this.cfgOfFlags == nil then
    local cfg = ClientTable.cfg_Npc_npcManager:GetDic()
    local tempCfg = {}
    for i, v in pairs(cfg) do
      if v.specialNPC == 3 then
        table.insert(tempCfg, v)
      end
    end
    table.sort(tempCfg, function(a, b)
      return a.npcId < b.npcId
    end)
    this.cfgOfFlags = tempCfg
  end
  if next(this.cfgOfFlagsOfMiniMap) == nil then
    local cfg = ConfigManager.FindConfigs("cfg_Map_minimap", "mid", 10206)
    local tempCfg = {}
    for i, v in pairs(cfg) do
      if v.type == 8 then
        table.insert(tempCfg, v)
      end
    end
    table.sort(tempCfg, function(a, b)
      return a.id < b.id
    end)
    this.cfgOfFlagsOfMiniMap = tempCfg
  end
  if next(this.cfgOfStronghold) == nil then
    this.cfgOfStronghold = ClientTable.cfg_Duoqi_point_rangeManager:GetDic()
  end
  this:InitCfgStrs()
  EventManager.Regist(Event.EnterUnionMap, this.OnEnterUnionMap)
  EventManager.Regist(Event.ProcessCollectionAndRob, this.OnProcessCollectionAndRob)
  EventManager.Regist(Event.Role_OnRoleEnterView, this.OnUnionNpcEnterView)
  EventManager.Regist(Event.UnionCampChange, this.OnUnionCampChange)
  EventManager.Regist(Event.UnionNpcExitView, this.OnUnionNpcExitView)
  EventManager.Regist(Event.UnionMoveResReturn, this.OnUnionMoveResReturn)
  EventManager.Regist(Event.UnionFinalScore, this.SetLastServerData)
  EventManager.Regist(Event.UnionKillAnnounce, this.OnUnionKillAnnounce)
  EventManager.Regist(Event.Relive, this.OnRelive)
  EventManager.Regist(Event.Role_OnRoleCreated, this.OnRoleCreated)
  EventManager.Regist(Event.Scene_SceneDataChange, this.OnSceneDataChange)
  EventManager.Regist(Event.Role_MyLvChanged, this.OnRoleMyLvChanged)
  EventManager.Regist(Event.UnionActiIsOpenCheck, this.OnUnionActiIsOpenCheck)
end

function DuoQiCrossDataManager.OnRoleMyLvChanged()
  this:RefreshPerAndUnionRewards()
  EventManager.Dispatch(Event.UnionMyLvChangeRefreshUI)
end

function DuoQiCrossDataManager:RefreshPerAndUnionRewards()
  local allCfg = ClientTable.cfg_Activity_rankRewardManager:GetDic()
  local tempCfg = {}
  local tempCfg2 = {}
  if next(allCfg) ~= nil then
    for i, v in pairs(allCfg) do
      if v.activityId == PlayActivityIdType.DuoQiCross then
        if v.condition == nil then
          return
        end
        local isOpen = ConditionManager.Check4D(v.condition)
        if isOpen then
          table.insert(tempCfg, v)
        end
      elseif v.activityId == PlayActivityIdType.DuoQiZhengBa then
        if v.condition == nil then
          return
        end
        local isOpen = ConditionManager.Check4D(v.condition)
        if isOpen then
          table.insert(tempCfg2, v)
        end
      end
    end
  end
  table.sort(tempCfg, function(a, b)
    return a.id < b.id
  end)
  table.sort(tempCfg2, function(a, b)
    return a.id < b.id
  end)
  this.cfgOfActivityRankReward = tempCfg
  this.cfgOfActivityRankRewardOfDuoQiZhengBa = tempCfg2
  local allCfgOfPerson = ClientTable.cfg_Activity_rank_duoqiManager:GetDic()
  local tempCfgOfPerson = {}
  local tempCfgOfPerson2 = {}
  if next(allCfgOfPerson) then
    for i, v in pairs(allCfgOfPerson) do
      if v.activityId == PlayActivityIdType.DuoQiCross then
        if v.condition == nil then
          return
        end
        local isOpen = ConditionManager.Check4D(v.condition)
        if isOpen then
          table.insert(tempCfgOfPerson, v)
        end
      elseif v.activityId == PlayActivityIdType.DuoQiZhengBa then
        if v.condition == nil then
          return
        end
        local isOpen = ConditionManager.Check4D(v.condition)
        if isOpen then
          table.insert(tempCfgOfPerson2, v)
        end
      end
    end
  end
  table.sort(tempCfgOfPerson, function(a, b)
    return a.id < b.id
  end)
  table.sort(tempCfgOfPerson2, function(a, b)
    return a.id < b.id
  end)
  this.cfgOfPersonalPoints = tempCfgOfPerson
  this.cfgOfPersonalPointsOfDuoQiZhengBa = tempCfgOfPerson2
end

function DuoQiCrossDataManager:GetcfgOfPersonalPoints()
  return this.cfgOfPersonalPoints
end

function DuoQiCrossDataManager:GetcfgOfPersonalPointsOfZhengBa()
  return this.cfgOfPersonalPointsOfDuoQiZhengBa
end

function DuoQiCrossDataManager:GetcfgOfActivityRankReward()
  return this.cfgOfActivityRankReward
end

function DuoQiCrossDataManager:GetcfgOfActivityRankRewardOfZhengBa()
  return this.cfgOfActivityRankRewardOfDuoQiZhengBa
end

function DuoQiCrossDataManager:GetRewardsOfEntrance()
  local tempGolbalCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500234)
  if tempGolbalCfg == nil or tempGolbalCfg.effect == nil then
    return
  end
  local cfgs = string.split(tempGolbalCfg.effect, "$")
  for i, v in ipairs(cfgs) do
    if v ~= nil then
      local subStrs = string.split(v, "_")
      if #subStrs ~= 2 then
        return
      end
      if ConditionManager.Check4D(subStrs[1]) == true then
        return subStrs[2]
      end
    end
  end
end

function DuoQiCrossDataManager:GetRankListByRewardType(rewardType)
  if rewardType == RewardType.personalCore then
    local allCfgCore = this:GetcfgOfPersonalPoints()
    return this:GetPersonalCoreByTbl(allCfgCore)
  elseif rewardType == RewardType.unionReward then
    local allCfg = this:GetcfgOfActivityRankReward()
    return this:GetUnionRewardByTbl(allCfg)
  elseif rewardType == RewardType.presidentReward then
    local allCfg = this:GetcfgOfActivityRankReward()
    return this:GetPresidentRewardByTbl(allCfg)
  end
end

function DuoQiCrossDataManager:GetZhangbaRankListByRewardType(rewardType)
  if rewardType == ZhangBaRewardType.personalCore then
    local allCfgCore = this:GetcfgOfPersonalPointsOfZhengBa()
    return this:GetPersonalCoreByTbl(allCfgCore)
  elseif rewardType == ZhangBaRewardType.unionReward then
    local allCfg = this:GetcfgOfActivityRankRewardOfZhengBa()
    return this:GetUnionRewardByTbl(allCfg)
  elseif rewardType == ZhangBaRewardType.presidentReward then
    local allCfg = this:GetcfgOfActivityRankRewardOfZhengBa()
    return this:GetPresidentRewardByTbl(allCfg)
  end
end

function DuoQiCrossDataManager:GetPersonalCoreByTbl(allCfgCore)
  if allCfgCore == nil then
    return
  end
  local tempCfg = {}
  for i, v in pairs(allCfgCore) do
    table.insert(tempCfg, {
      title = string.format(this.personalScoreStr, v.rankLimit),
      showReward = v.showReward,
      id = v.id,
      columns = 1
    })
  end
  table.sort(tempCfg, function(a, b)
    return a.id < b.id
  end)
  return tempCfg
end

function DuoQiCrossDataManager:GetUnionRewardByTbl(allCfg)
  local tempCfg = {}
  for i, v in pairs(allCfg) do
    local title
    if v.activityType == 1 then
      local rankLimit = string.split(v.rank, "#")
      if #rankLimit ~= 2 then
        return
      end
      if rankLimit[1] == rankLimit[2] then
        title = string.format(this.oneRankStr, rankLimit[1])
      else
        title = string.format(this.twoRankStr, rankLimit[1], rankLimit[2])
      end
      table.insert(tempCfg, {
        title = title,
        showReward = v.showReward,
        id = v.id,
        columns = 2
      })
    end
  end
  table.sort(tempCfg, function(a, b)
    return a.id < b.id
  end)
  return tempCfg
end

function DuoQiCrossDataManager:GetPresidentRewardByTbl(allCfg)
  local tempCfg = {}
  for i, v in pairs(allCfg) do
    local title
    if v.activityType == 2 then
      local rankLimit = string.split(v.rank, "#")
      if #rankLimit ~= 2 then
        return
      end
      if rankLimit[1] == rankLimit[2] then
        title = string.format(this.oneRankStr, rankLimit[1])
      else
        title = string.format(this.twoRankStr, rankLimit[1], rankLimit[2])
      end
      table.insert(tempCfg, {
        title = title,
        showReward = v.showReward,
        id = v.id,
        columns = 3
      })
    end
  end
  table.sort(tempCfg, function(a, b)
    return a.id < b.id
  end)
  return tempCfg
end

function DuoQiCrossDataManager:GetShowGearId()
  if this:IsInDuoQiByMapId() == true then
    if this.cfgOfPersonalPoints[this.myShowRewardLevel] == nil then
      return
    end
    return this.cfgOfPersonalPoints[this.myShowRewardLevel].id
  elseif this:IsInDuoQiZhengBaByMapId() == true then
    if this.cfgOfPersonalPointsOfDuoQiZhengBa[this.myShowRewardLevel] == nil then
      return
    end
    return this.cfgOfPersonalPointsOfDuoQiZhengBa[this.myShowRewardLevel].id
  else
    if this.cfgOfPersonalPoints[this.myShowRewardLevel] == nil then
      return
    end
    return this.cfgOfPersonalPoints[this.myShowRewardLevel].id
  end
end

function DuoQiCrossDataManager:GetRankLimitScore()
  if this.cfgOfPersonalPoints[this.myShowRewardLevel] == nil then
    return
  end
  return this.cfgOfPersonalPoints[this.myShowRewardLevel].rankLimit
end

function DuoQiCrossDataManager:GetRankLimitScoreOfZhengBa()
  if this.cfgOfPersonalPointsOfDuoQiZhengBa[this.myShowRewardLevel] == nil then
    return
  end
  return this.cfgOfPersonalPointsOfDuoQiZhengBa[this.myShowRewardLevel].rankLimit
end

function DuoQiCrossDataManager:GetPersonalCfgOfOwn()
  local personalScoreCfg
  if this:IsInDuoQiByMapId() == true then
    personalScoreCfg = this:GetCfgOfRankRewardByActivityType(RewardType.personalCore)
  elseif this:IsInDuoQiZhengBaByMapId() == true then
    personalScoreCfg = this:GetCfgOfRankRewardByActivityTypeOfZhengBa(ZhangBaRewardType.personalCore)
  else
    personalScoreCfg = this:GetCfgOfRankRewardByActivityType(RewardType.personalCore)
  end
  local showDang = this:GetShowGearId()
  local rewardInfos = {}
  for i, v in ipairs(personalScoreCfg) do
    if v.id == showDang then
      local strings = string.split(v.showReward, "&")
      for m, n in ipairs(strings) do
        local rewardStrs = string.split(n, "#")
        if #rewardStrs ~= 2 then
          return
        end
        table.insert(rewardInfos, {
          itemId = tonumber(rewardStrs[1]),
          count = tonumber(rewardStrs[2])
        })
      end
      return rewardInfos
    end
  end
end

function DuoQiCrossDataManager:GetUnionShowRewardCfgByRank(rank, isUseZhengBaCfg)
  local unionRewardCfg
  if this:IsInDuoQiByMapId() == true then
    unionRewardCfg = this:GetCfgOfRankRewardByActivityType(RewardType.unionReward)
  elseif this:IsInDuoQiZhengBaByMapId() == true then
    unionRewardCfg = this:GetCfgOfRankRewardByActivityTypeOfZhengBa(ZhangBaRewardType.unionReward)
  else
    unionRewardCfg = this:GetCfgOfRankRewardByActivityType(RewardType.unionReward)
  end
  if isUseZhengBaCfg == true then
    unionRewardCfg = this:GetCfgOfRankRewardByActivityTypeOfZhengBa(ZhangBaRewardType.unionReward)
  end
  local rewardInfos = {}
  if unionRewardCfg == nil then
    return
  end
  for i, v in ipairs(unionRewardCfg) do
    local rankStr = v.rank
    local rankStrs = string.split(rankStr, "#")
    if #rankStrs ~= 2 then
      return
    end
    if rank >= tonumber(rankStrs[1]) and rank <= tonumber(rankStrs[2]) then
      local strings = string.split(v.showReward, "&")
      for m, n in ipairs(strings) do
        local rewardStrs = string.split(n, "#")
        if #rewardStrs ~= 2 then
          return
        end
        table.insert(rewardInfos, {
          itemId = tonumber(rewardStrs[1]),
          count = tonumber(rewardStrs[2])
        })
      end
      return rewardInfos
    end
  end
end

function DuoQiCrossDataManager:GetCfgOfRankRewardByActivityType(activityType)
  if activityType == RewardType.personalCore then
    return this:GetcfgOfPersonalPoints()
  elseif activityType == RewardType.unionReward then
    if next(this.cfgOfActivityRankReward) ~= nil then
      local tempCfg = {}
      for i, v in ipairs(this.cfgOfActivityRankReward) do
        if v.activityType == 1 then
          table.insert(tempCfg, v)
        end
      end
      table.sort(tempCfg, function(a, b)
        return a.id < b.id
      end)
      return tempCfg
    end
  elseif activityType == RewardType.presidentReward and next(this.cfgOfActivityRankReward) ~= nil then
    local tempCfg = {}
    for i, v in ipairs(this.cfgOfActivityRankReward) do
      if v.activityType == 2 then
        table.insert(tempCfg, v)
      end
    end
    table.sort(tempCfg, function(a, b)
      return a.id < b.id
    end)
    return tempCfg
  end
end

function DuoQiCrossDataManager:GetCfgOfRankRewardByActivityTypeOfZhengBa(activityType)
  if activityType == ZhangBaRewardType.personalCore then
    return this:GetcfgOfPersonalPointsOfZhengBa()
  elseif activityType == ZhangBaRewardType.unionReward then
    if next(this.cfgOfActivityRankRewardOfDuoQiZhengBa) ~= nil then
      local tempCfg = {}
      for i, v in ipairs(this.cfgOfActivityRankRewardOfDuoQiZhengBa) do
        if v.activityType == 1 then
          table.insert(tempCfg, v)
        end
      end
      table.sort(tempCfg, function(a, b)
        return a.id < b.id
      end)
      return tempCfg
    end
  elseif activityType == ZhangBaRewardType.presidentReward and next(this.cfgOfActivityRankRewardOfDuoQiZhengBa) ~= nil then
    local tempCfg = {}
    for i, v in ipairs(this.cfgOfActivityRankRewardOfDuoQiZhengBa) do
      if v.activityType == 2 then
        table.insert(tempCfg, v)
      end
    end
    table.sort(tempCfg, function(a, b)
      return a.id < b.id
    end)
    return tempCfg
  end
end

function DuoQiCrossDataManager:GetImgMaterialByRank(strCfg, rank)
  if strCfg ~= nil then
    local strings = string.split(strCfg, "&")
    if strings[rank] == nil then
      return
    end
    local strs = string.split(strings[rank], "#")
    if #strs ~= 2 then
      return
    end
    local iconCfg = strs[1]
    local bgCfg = strs[2]
    local iconNameCfg = string.split(iconCfg, "$")
    local bgNameCfg = string.split(bgCfg, "$")
    if iconNameCfg[1] == nil or iconNameCfg[2] == nil or bgNameCfg[1] == nil or bgNameCfg[2] == nil then
      return
    end
    return {
      iconName = iconNameCfg[1],
      iconAtlas = iconNameCfg[2],
      bgName = bgNameCfg[1],
      bgAtlas = bgNameCfg[2]
    }
  end
end

function DuoQiCrossDataManager:GetRankMaterialByRank(rank)
  return this:GetImgMaterialByRank(this.rankMaterialInfos, rank)
end

function DuoQiCrossDataManager:GetRankMaterialOfSettleByRank(rank)
  return this:GetImgMaterialByRank(this.rankMaterialInfosOfSettle, rank)
end

function DuoQiCrossDataManager:GetUnionRankList()
  table.sort(this.unionInfo, function(a, b)
    return a.rank < b.rank
  end)
  return this.unionInfo
end

function DuoQiCrossDataManager:GetMyUnionRank()
  local unionRankList = this:GetUnionRankList()
  for i, v in pairs(unionRankList) do
    if v.unionId == RoleManager.me.unionId then
      return v
    end
  end
end

function DuoQiCrossDataManager:GetOwnUnionId()
  return RoleManager.me.unionId
end

function DuoQiCrossDataManager:GetOwnUnionRank()
  local unionId = this:GetOwnUnionId()
  local data = this:GetUnionRankList()
  for i, v in pairs(data) do
    if v.unionId == unionId then
      return v
    end
  end
end

function DuoQiCrossDataManager:SetServerData(msg)
  if msg == nil or msg.panel == nil or msg.basic == nil then
    return
  end
  this.serverData = msg
  this.playerInfo = this.serverData.panel.playerInfo
  this.strongholdInfo = this.serverData.panel.strongholdInfo
  this.unionInfo = this.serverData.panel.unionInfo
  this:SetMyPlayerInfo()
  if this:IsInDuoQiByMapId() == true then
    this:SetMyRewardLevelAndGetedCount()
    this:SetMyReachedRewardLevel()
  elseif this:IsInDuoQiZhengBaByMapId() == true then
    this:SetMyRewardLevelAndGetedCountOfZhengBa()
    this:SetMyReachedRewardLevelOfZhengBa()
  else
    this:SetMyRewardLevelAndGetedCount()
    this:SetMyReachedRewardLevel()
  end
  EventManager.Dispatch(Event.ResUnionInfo)
end

function DuoQiCrossDataManager.SetLastServerData(_, msg)
  if msg == nil then
    return
  end
  this.playerInfo = msg.playerInfo
  this.strongholdInfo = msg.strongholdInfo
  this.unionInfo = msg.unionInfo
  this:SetMyPlayerInfo()
  this:SetMyRewardLevelAndGetedCount()
  this:SetMyReachedRewardLevel()
  if msg.serverType ~= nil and msg.serverType == 2 then
    UIManager.Show(UIID.Activity_DuoqiRankUI, {isUseZhengBaCfg = true})
  else
    UIManager.Show(UIID.Activity_DuoqiRankUI)
  end
  EventManager.Dispatch(Event.RefreshSettlementOfUnion)
end

function DuoQiCrossDataManager.OnRelive(_, msg)
  if msg.reliveType == RoleReliveType.Here and msg.lid == ViewData.meData.id and this.reliveTimer == nil then
    this.canReliveTime = this.reliveCD / 1000
    this.reliveTimer = Timer.StartLoopForever(1, function()
      this.canReliveTime = this.canReliveTime - 1
      if this.canReliveTime < 0 then
        this.canReliveTime = nil
        Timer.Stop(this.reliveTimer)
        this.reliveTimer = nil
      end
    end)
  end
end

function DuoQiCrossDataManager.OnRoleCreated(_, npc)
  if this.isInUnionMap == true and npc ~= nil and npc.data ~= nil and npc.data.config_Npc ~= nil and npc.data.config_Npc.specialNPC ~= nil and npc.data.config_Npc.specialNPC == 2 and npc.gameObject ~= nil then
    local tempLabel = npc.gameObject.transform:Find("toplogoPlayer/Label", typeof(CS.CSLabel))
    if tempLabel ~= nil then
      tempLabel.halfWidth = 47
      tempLabel.fontSize = 18
      tempLabel.color = Color(0, 1, 0, 1)
      tempLabel.SpaceX = 2
      tempLabel.text = npc.data.name
    end
  end
end

function DuoQiCrossDataManager.OnSceneDataChange(_, goMapId)
  if goMapId == 10206 or goMapId == 10207 then
    EventManager.Dispatch(Event.EnterUnionMap, true)
  elseif goMapId ~= 10206 and goMapId ~= 10207 and (this.lastMapId == 10206 or this.lastMapId == 10207) then
    EventManager.Dispatch(Event.EnterUnionMap, false)
  end
  this.lastMapId = goMapId
end

function DuoQiCrossDataManager.OnUnionKillAnnounce(_, msg)
  if msg == nil or msg.id == nil then
    return
  end
  local isUnionKillAnnounce, chatCfg = this:IsUnionKillAnnounceById(msg.id)
  if isUnionKillAnnounce == false then
    return
  end
  table.insert(this.announceQueue, {chatCfg = chatCfg, msg = msg})
  
  local function CheckShow()
    if table.count(this.announceQueue) > 0 then
      local data = table.remove(this.announceQueue, 1)
      UIManager.Show(UIID.Activity_DuoqikillUI, data)
      EventManager.Dispatch(Event.RefreshUnionKillAnnounce)
    else
      UIManager.Hide(UIID.Activity_DuoqikillUI)
      Timer.Stop(this.announceTimer)
      this.announceTimer = nil
    end
  end
  
  if this.announceTimer == nil then
    CheckShow()
    this.announceTimer = Timer.StartLoopForever(this.announceTime / 1000, CheckShow)
  end
end

function DuoQiCrossDataManager:OnUnionActiIsOpenCheck()
  local isDuoQiActivityOpen = this:IsDuoQiActivityOpen()
  local isDuoQiZhengBaActivityOpen = this:IsDuoQiZhengBaActivityOpen()
  if isDuoQiActivityOpen ~= this.isShowBtnDuoQiEnter then
    EventManager.Dispatch(Event.ShowBtnDuoQiEnter)
  end
  if isDuoQiZhengBaActivityOpen ~= this.isShowBtnDuoQiZhengBaEnter then
    EventManager.Dispatch(Event.ShowBtnDuoQiZhengBaEnter)
  end
  if isOpen ~= this.isGreenOpenTimeStr then
    EventManager.Dispatch(Event.RefreshUnionStrColor)
  end
end

function DuoQiCrossDataManager:IsUnionKillAnnounceById(id)
  local tempCfg = ClientTable.cfg_Chat_chatManager:TryGetValue(id)
  if tempCfg == nil or tempCfg.type == nil then
    return false
  end
  local strs = string.split(tempCfg.type, "&")
  for i, v in ipairs(strs) do
    if v == "10" then
      return true, tempCfg
    end
  end
  return false
end

function DuoQiCrossDataManager:GetKillNumByChatId(id)
  if this.killNumOfIdCfg == nil then
    return
  end
  for i, v in ipairs(this.killNumOfIdCfg) do
    local strs = string.split(v, "#")
    if strs[1] == nil or strs[2] == nil or strs[3] == nil then
      return
    end
    if tonumber(strs[2]) == id or tonumber(strs[3]) == id then
      return strs[1]
    end
  end
end

function DuoQiCrossDataManager:SetMyPlayerInfo()
  if this.playerInfo ~= nil then
    for i, v in pairs(this.playerInfo) do
      if v.rid == ViewData.meData.id then
        this.myplayerInfo = v
        return
      end
    end
    this.myplayerInfo = {}
  end
end

function DuoQiCrossDataManager:SetMyRewardLevelAndGetedCount()
  if next(this.cfgOfPersonalPoints) == nil then
    return
  end
  if next(this.myplayerInfo) == nil or next(this.myplayerInfo.rewards) == nil then
    this.myShowRewardLevel = 1
    this.myGetedRewardCount = 0
    this.isAllRewardGeted = false
  else
    local rewardLevel = #this.myplayerInfo.rewards + 1
    if this.cfgOfPersonalPoints[rewardLevel] == nil then
      this.myShowRewardLevel = #this.cfgOfPersonalPoints
      this.isAllRewardGeted = true
    else
      this.myShowRewardLevel = rewardLevel
      this.isAllRewardGeted = false
    end
    this.myGetedRewardCount = #this.myplayerInfo.rewards
  end
end

function DuoQiCrossDataManager:SetMyRewardLevelAndGetedCountOfZhengBa()
  if next(this.cfgOfPersonalPointsOfDuoQiZhengBa) == nil then
    return
  end
  if next(this.myplayerInfo) == nil or next(this.myplayerInfo.rewards) == nil then
    this.myShowRewardLevel = 1
    this.myGetedRewardCount = 0
    this.isAllRewardGeted = false
  else
    local rewardLevel = #this.myplayerInfo.rewards + 1
    if this.cfgOfPersonalPointsOfDuoQiZhengBa[rewardLevel] == nil then
      this.myShowRewardLevel = #this.cfgOfPersonalPointsOfDuoQiZhengBa
      this.isAllRewardGeted = true
    else
      this.myShowRewardLevel = rewardLevel
      this.isAllRewardGeted = false
    end
    this.myGetedRewardCount = #this.myplayerInfo.rewards
  end
end

function DuoQiCrossDataManager:SetMyReachedRewardLevel()
  if this.cfgOfPersonalPoints == nil then
    return
  end
  if this.myplayerInfo == nil or this.myplayerInfo.score == nil then
    this.myReachedRewardLevel = 0
    return
  end
  for i, v in ipairs(this.cfgOfPersonalPoints) do
    if v.rankLimit > this.myplayerInfo.score then
      this.myReachedRewardLevel = i - 1
      return
    end
  end
  this.myReachedRewardLevel = #this.cfgOfPersonalPoints
end

function DuoQiCrossDataManager:SetMyReachedRewardLevelOfZhengBa()
  if this.cfgOfPersonalPointsOfDuoQiZhengBa == nil then
    return
  end
  if this.myplayerInfo == nil or this.myplayerInfo.score == nil then
    this.myReachedRewardLevel = 0
    return
  end
  for i, v in ipairs(this.cfgOfPersonalPointsOfDuoQiZhengBa) do
    if v.rankLimit > this.myplayerInfo.score then
      this.myReachedRewardLevel = i - 1
      return
    end
  end
  this.myReachedRewardLevel = #this.cfgOfPersonalPointsOfDuoQiZhengBa
end

local function GetTodayTime(timeOffset)
  timeOffset = timeOffset or 0
  local curTime = Time.GetServerSecondTime()
  curTime = TimeUtility.GetDayTimeStamp(curTime)
  return curTime + timeOffset
end

function DuoQiCrossDataManager:SetUnionEndTimer_New(isEnter)
  if isEnter == true and this.unionEndTimer_New == nil then
    local activityId = PlayActivityIdType.DuoQiCross
    if this:IsDuoQiActivityOpen() == true then
      activityId = PlayActivityIdType.DuoQiCross
    elseif this:IsDuoQiZhengBaActivityOpen() == true then
      activityId = PlayActivityIdType.DuoQiZhengBa
    end
    this.unionEndTimer_New = Timer.StartLoopForever(1, function()
      local activityOverview = ClientTable.cfg_Activity_overviewManager:TryGetValue(activityId, "activityId")
      if activityOverview == nil then
        return
      end
      local openTime = ActivityListData.GetOpenTime(activityOverview.condition, activityOverview.preTime, activityOverview.activityId)
      if openTime == nil then
        return
      end
      local endTime, middleTime
      local limitTimeUnix = TimeUtility.GetCurTimeZoneSecondTime()
      for i = 1, #openTime do
        if ConditionManager.Check(openTime[i].condition) then
          endTime = openTime[i].endLimitTimeUnix + GetTodayTime()
          if openTime[i].middleLimitTimeUnix and limitTimeUnix < openTime[i].middleLimitTimeUnix + GetTodayTime() then
            middleTime = openTime[i].middleLimitTimeUnix + GetTodayTime()
          end
          break
        end
      end
      if endTime then
        local interval = middleTime and middleTime - TimeUtility.GetCurTimeZoneSecondTime() or endTime - TimeUtility.GetCurTimeZoneSecondTime()
        if interval < 0 and this.unionEndTimer_New ~= nil then
          EventManager.Dispatch(Event.UnionEndTimer, 0)
          Timer.Stop(this.unionEndTimer_New)
          this.unionEndTimer_New = nil
          return
        end
        EventManager.Dispatch(Event.UnionEndTimer, interval)
      end
    end)
  end
  if isEnter == false and this.unionEndTimer_New ~= nil then
    Timer.Stop(this.unionEndTimer_New)
    this.unionEndTimer_New = nil
  end
end

function DuoQiCrossDataManager:GetMyPlayerInfo()
  if this.myplayerInfo ~= nil then
    return this.myplayerInfo
  end
end

function DuoQiCrossDataManager:GetMyPlayerScore()
  if this.myplayerInfo ~= nil and this.myplayerInfo.score ~= nil then
    return this.myplayerInfo.score
  end
end

function DuoQiCrossDataManager.OnEnterUnionMap(_, data)
  this.isInUnionMap = data
  if data == true and this.isEnteredUnionMap == false then
    this.isEnteredUnionMap = true
  end
  if data == true and this.unionProcessDispatchTimer == nil then
    this.unionProcessDispatchTimer = Timer.StartLoopForever(0.2, function()
      if this:GetIsProcessResReturn() == true then
        EventManager.Dispatch(Event.OpenUnionProcess, true)
        this:SetIsProcessResReturn(false)
      else
        EventManager.Dispatch(Event.OpenUnionProcess, false)
      end
      if this.isBoxMapRefresh == true then
        EventManager.Dispatch(Event.RefreshBoxMap)
        this.isBoxMapRefresh = false
      end
    end)
  elseif data == false and this.unionProcessDispatchTimer ~= nil then
    Timer.Stop(this.unionProcessDispatchTimer)
    this.unionProcessDispatchTimer = nil
  end
  if data == true and this.unionMoveDispatchTimer == nil then
    this.unionMoveDispatchTimer = Timer.StartLoopForever(this.checkMoveTime / 1000, function()
      if this:GetIsMoveResReturn() == true then
        EventManager.Dispatch(Event.OpenCollectParent, false)
        this.isMoveResReturn = false
      else
        EventManager.Dispatch(Event.OpenCollectParent, true)
      end
    end)
  elseif data == false and this.unionMoveDispatchTimer ~= nil then
    Timer.Stop(this.unionMoveDispatchTimer)
    this.unionMoveDispatchTimer = nil
  end
  if data == true then
    this:RefreshPerAndUnionRewards()
    EventManager.Dispatch(Event.ChangeRightTopBtn, false)
    if UIManager.IsVisible(UIID.CrossServer_IntoUI) then
      UIManager.Hide(UIID.CrossServer_IntoUI)
    end
  end
  if data == false then
    this:RemoveUnionEffs()
    this.boxMapInfo = {}
    TranScriptData.ClearData()
    LeftTopPanelManager.SetCurrentPanelType(PanelType.TaskPanelType)
    EventManager.Dispatch(Event.Task_ChangePanelState)
  end
  this:SetUnionEndTimer_New(data)
end

function DuoQiCrossDataManager.OnProcessCollectionAndRob(_, list)
  if next(list) == nil then
    return
  end
  local miniDisOfBox = 100
  local miniKeyOfBox
  local miniDisOfFlag = 100
  local miniKeyOfFalg
  for key, v in pairs(list) do
    local distance = Vector2.DistancePow(v.cellPos, RoleManager.me.cellPos)
    if distance <= this.collectDis and v.data ~= nil and v.data.config_Npc ~= nil and v.data.config_Npc.specialNPC == 2 and miniDisOfBox > distance then
      miniDisOfBox = distance
      miniKeyOfBox = key
    end
    if v.data ~= nil and v.data.config_Npc ~= nil and v.data.config_Npc.specialNPC == 3 and v.data.config_Npc.npcId ~= nil then
      local dis = QuickFind:GetDuoQiCrossDataManager():GetBornRangeByFlagId(v.data.config_Npc.npcId)
      if dis == nil then
        return
      end
      if distance <= dis * dis and miniDisOfFlag > distance then
        miniDisOfFlag = distance
        miniKeyOfFalg = key
      end
    end
  end
  if miniKeyOfBox ~= nil then
    local temp = list[miniKeyOfBox]
    this.colloctingBoxData = {
      id = temp.id,
      x = temp.x,
      y = temp.y
    }
    EventManager.Dispatch(Event.OpenCollectionButton, true)
  else
    this.colloctingBoxData = nil
    EventManager.Dispatch(Event.OpenCollectionButton, false)
  end
  local isOpenRob = false
  if miniKeyOfFalg ~= nil then
    local temp = list[miniKeyOfFalg]
    if temp.data ~= nil and temp.data.data ~= nil and temp.data.data.unionId ~= nil and temp.data.data.unionId ~= 0 and temp.data.data.unionId ~= RoleManager.me.unionId then
      this.strongholdAroundData = {
        id = temp.id,
        x = temp.x,
        y = temp.y,
        unionId = temp.data.data.unionId
      }
      isOpenRob = true
      EventManager.Dispatch(Event.OpenFlagRobButton, true)
    end
  end
  if isOpenRob == false then
    this.strongholdAroundData = {}
    EventManager.Dispatch(Event.OpenFlagRobButton, false)
  end
end

function DuoQiCrossDataManager.OnUnionNpcEnterView(_, addNpc)
  if this:IsEnterDuoQi() ~= true or addNpc == nil or addNpc.data == nil then
    return
  end
  if this:IsFlagNpcByConfigId(addNpc.data.configId) then
    if this.strongholdNeedInfo[addNpc.data.id] == nil then
      this.strongholdNeedInfo[addNpc.data.id] = {
        configId = addNpc.data.configId,
        id = addNpc.data.id
      }
    end
    this.strongholdNeedInfo[addNpc.data.id].unionId = addNpc.data.unionId
    this.strongholdNeedInfo[addNpc.data.id].unionName = addNpc.data.unionName
    this.strongholdNeedInfo[addNpc.data.id].x = addNpc.data.x
    this.strongholdNeedInfo[addNpc.data.id].y = addNpc.data.y
    this:ShowFlagEffByUnionId(this.strongholdNeedInfo[addNpc.data.id])
  end
  local isBoxNpc, subType = this:IsBoxNpcByConfigId(addNpc.data.configId)
  if isBoxNpc == true then
    this.boxMapInfo[addNpc.data.id] = {
      subType = subType,
      x = addNpc.data.x,
      y = addNpc.data.y
    }
    this.isBoxMapRefresh = true
  end
end

function DuoQiCrossDataManager.OnUnionCampChange(_, data)
  if this:IsEnterDuoQi() ~= true or next(data) == nil then
    return
  end
  if this:IsFlagNpcByConfigId(data.configId) then
    if this.strongholdNeedInfo[data.id] == nil then
      this.strongholdNeedInfo[data.id] = {
        configId = data.configId,
        id = data.id
      }
    end
    this.strongholdNeedInfo[data.id].unionId = data.unionId
    this.strongholdNeedInfo[data.id].unionName = data.unionName
    this.strongholdNeedInfo[data.id].x = data.x
    this.strongholdNeedInfo[data.id].y = data.y
    this:ShowFlagEffByUnionId(this.strongholdNeedInfo[data.id])
    this:RefreshRobBtn(data)
  end
end

function DuoQiCrossDataManager:RefreshRobBtn(data)
  local flagPos = Vector2.New(data.x, data.y)
  local distance = Vector2.DistancePow(flagPos, RoleManager.me.cellPos)
  local dis = QuickFind:GetDuoQiCrossDataManager():GetBornRangeByFlagId(data.configId)
  if dis == nil then
    return
  end
  if distance <= dis * dis and data.unionId ~= 0 and data.unionId ~= RoleManager.me.unionId then
    this.strongholdAroundData = {
      id = data.id,
      x = data.x,
      y = data.y,
      unionId = data.unionId
    }
    EventManager.Dispatch(Event.OpenFlagRobButton, true)
    return
  end
  this.strongholdAroundData = {}
  EventManager.Dispatch(Event.OpenFlagRobButton, false)
end

function DuoQiCrossDataManager:IsFlagNpcByConfigId(configId)
  if this.cfgOfFlags == nil then
    return
  end
  for i, v in ipairs(this.cfgOfFlags) do
    if v.npcId == configId then
      return true
    end
  end
  return false
end

function DuoQiCrossDataManager:IsBoxNpcByConfigId(configId)
  if configId == 10206101 then
    return true, 1
  elseif configId == 10206102 then
    return true, 2
  elseif configId == 10206103 then
    return true, 3
  end
  return false
end

function DuoQiCrossDataManager:ShowFlagEffByUnionId(info)
  local tempType, unionNameColor
  if info.unionId == RoleManager.me.unionId then
    tempType = EffType.GreenEff
    if #this.unionNameColor[1] ~= 4 then
      return
    end
    local color = this.unionNameColor[1]
    unionNameColor = Color.New(color[1] / 100, color[2] / 100, color[3] / 100, color[4] / 100)
  elseif info.unionId == 0 then
    tempType = EffType.Orange
    if #this.unionNameColor[3] ~= 4 then
      return
    end
    local color = this.unionNameColor[3]
    unionNameColor = Color.New(color[1] / 100, color[2] / 100, color[3] / 100, color[4] / 100)
  else
    tempType = EffType.RedEff
    if #this.unionNameColor[2] ~= 4 then
      return
    end
    local color = this.unionNameColor[2]
    unionNameColor = Color.New(color[1] / 100, color[2] / 100, color[3] / 100, color[4] / 100)
  end
  if info.effObj == nil or info.effObj.EffectObj == nil or IsNil(info.effObj.EffectObj) == true then
    local ver = Vector2.New(info.x, info.y)
    SceneUtility.AddSceneEffect(344, ver, function(effObj)
      info.effObj = effObj
      info.effObj.EffectObj:SetActive(true)
      this:SetEffActiveByType(info.effObj, tempType)
      this:SetFlagUnionName(info.effObj, info.unionName, unionNameColor)
    end, this.effHight / 1000)
  else
    info.effObj.EffectObj:SetActive(true)
    this:SetEffActiveByType(info.effObj, tempType)
    this:SetFlagUnionName(info.effObj, info.unionName, unionNameColor)
  end
end

function DuoQiCrossDataManager.OnUnionNpcExitView(_, exitId)
  if exitId == nil then
    return
  end
  if this.boxMapInfo[exitId] ~= nil then
    this.boxMapInfo[exitId] = nil
    this.isBoxMapRefresh = true
  end
  if this.strongholdNeedInfo[exitId] ~= nil then
    local info = this.strongholdNeedInfo[exitId]
    if info.effObj ~= nil and info.effObj.EffectObj ~= nil and IsNil(info.effObj.EffectObj) == false then
      info.effObj.EffectObj:SetActive(false)
    end
  end
end

function DuoQiCrossDataManager.OnUnionMoveResReturn()
  if this:IsEnterDuoQi() == true then
    this.isMoveResReturn = true
  end
end

function DuoQiCrossDataManager:GetBoxMapInfo()
  return this.boxMapInfo
end

function DuoQiCrossDataManager:IsEnterDuoQi()
  return this.isInUnionMap
end

function DuoQiCrossDataManager:GetCollectingBoxId()
  if this.colloctingBoxData ~= nil and this.colloctingBoxData.id ~= nil then
    return this.colloctingBoxData.id
  end
end

function DuoQiCrossDataManager:GetStrongholdAroundData()
  return this.strongholdAroundData
end

function DuoQiCrossDataManager:GetCollectTime()
  local timeCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500209)
  if timeCfg == nil or timeCfg.effect == nil then
    return
  end
  return tonumber(timeCfg.effect)
end

function DuoQiCrossDataManager:SetIsCollectState(isCollect)
  this.isCollecting = isCollect
end

function DuoQiCrossDataManager:GetIsCollectState()
  return this.isCollecting
end

function DuoQiCrossDataManager:SetIsRobBtnOpen(isRobBtnOpen)
  this.isRobBtnOpen = isRobBtnOpen
end

function DuoQiCrossDataManager:GetIsRobBtnOpen()
  return this.isRobBtnOpen
end

function DuoQiCrossDataManager:InitCfgStrs()
  local getBoxCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500205)
  local occupyCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500206)
  local killCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500207)
  if getBoxCfg == nil or occupyCfg == nil or killCfg == nil then
    return
  end
  if getBoxCfg.effect == nil or occupyCfg.effect == nil or killCfg.effect == nil then
    return
  end
  this.bubbleStrs[1] = getBoxCfg.effect
  this.bubbleStrs[2] = occupyCfg.effect
  this.bubbleStrs[3] = killCfg.effect
  local unionFormatCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500213)
  local unionNameColorCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500216)
  local noUnionCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500217)
  local unionNameColorOfMapCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500218)
  if unionFormatCfg == nil or unionNameColorCfg == nil or noUnionCfg == nil or unionNameColorOfMapCfg == nil then
    return
  end
  if unionFormatCfg.effect == nil or unionNameColorCfg.effect == nil or noUnionCfg.effect == nil or unionNameColorCfg.effect == nil then
    return
  end
  this.unionNameFormat = unionFormatCfg.effect
  local colorTemp = string.split(unionNameColorCfg.effect, "&")
  if next(colorTemp) == nil then
    return
  end
  for i, v in ipairs(colorTemp) do
    local colorTemp2 = string.split(v, "#")
    for m, n in ipairs(colorTemp2) do
      colorTemp2[m] = tonumber(n)
    end
    this.unionNameColor[i] = colorTemp2
  end
  this.noUnionStr = noUnionCfg.effect
  this.unionNameColorOfMap = string.split(unionNameColorOfMapCfg.effect, "&")
  local canNotStrCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips", "id")
  if canNotStrCfg == nil or string.isNullOrEmpty(canNotStrCfg.content) == true then
    return
  end
  this.canNotOperateStr = canNotStrCfg.content
  local unionLackCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips1", "id")
  if unionLackCfg == nil or string.isNullOrEmpty(unionLackCfg.content) == true then
    return
  end
  this.unionLackStr = unionLackCfg.content
  local levelLackCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips2", "id")
  if levelLackCfg == nil or string.isNullOrEmpty(levelLackCfg.content) == true then
    return
  end
  this.levelLackStr = levelLackCfg.content
  local unionActiNotOpenCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips3", "id")
  if unionActiNotOpenCfg == nil or string.isNullOrEmpty(unionActiNotOpenCfg.content) == true then
    return
  end
  this.unionActiNotOpenStr = unionActiNotOpenCfg.content
  local collectCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500210)
  if collectCfg == nil or collectCfg.effect == nil then
    return
  end
  this.collectDis = tonumber(collectCfg.effect) * tonumber(collectCfg.effect)
  local checkTimeCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500224)
  if checkTimeCfg == nil or checkTimeCfg.effect == nil then
    return
  end
  this.checkMoveTime = tonumber(checkTimeCfg.effect)
  local notChangeModeCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips4", "id")
  if notChangeModeCfg == nil or string.isNullOrEmpty(notChangeModeCfg.content) == true then
    return
  end
  this.canNotChangeMode = notChangeModeCfg.content
  local skillNumCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500227)
  if skillNumCfg == nil or string.isNullOrEmpty(skillNumCfg.effect) == true then
    return
  end
  local skillNumCfgStrs = string.split(skillNumCfg.effect, "&")
  if next(skillNumCfgStrs) == nil then
    return
  end
  this.killNumOfIdCfg = skillNumCfgStrs
  local killArtCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500228)
  if killArtCfg == nil or string.isNullOrEmpty(killArtCfg.effect) == true then
    return
  end
  this.killArtFont = killArtCfg.effect
  local checkAnnounceTimeCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500229)
  if checkAnnounceTimeCfg == nil or string.isNullOrEmpty(checkAnnounceTimeCfg.effect) == true then
    return
  end
  this.announceTime = tonumber(checkAnnounceTimeCfg.effect)
  local reliveCDCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500225)
  if reliveCDCfg == nil or string.isNullOrEmpty(reliveCDCfg.effect) == true then
    return
  end
  this.reliveCD = tonumber(reliveCDCfg.effect)
  local reliveTipCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips5", "id")
  if reliveTipCfg == nil or string.isNullOrEmpty(reliveTipCfg.content) == true then
    return
  end
  this.reliveTip = reliveTipCfg.content
  local noEnemyOfFlagTipCfg = ClientTable.cfg_Ui_wordManager:TryGetValue("Activity_Duoqi_Tips6", "id")
  if noEnemyOfFlagTipCfg == nil or string.isNullOrEmpty(noEnemyOfFlagTipCfg.content) == true then
    return
  end
  this.noEnemyOfFlagTip = noEnemyOfFlagTipCfg.content
  local boxNameScaleCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500232)
  if boxNameScaleCfg == nil or string.isNullOrEmpty(boxNameScaleCfg.effect) == true then
    return
  end
  this.boxNameScale = tonumber(boxNameScaleCfg.effect)
  local personalStrCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500235)
  if personalStrCfg == nil or string.isNullOrEmpty(personalStrCfg.effect) == true then
    return
  end
  this.personalScoreStr = personalStrCfg.effect
  local oneRankStrCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500236)
  if oneRankStrCfg == nil or string.isNullOrEmpty(oneRankStrCfg.effect) == true then
    return
  end
  this.oneRankStr = oneRankStrCfg.effect
  local twoRankStrCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500237)
  if twoRankStrCfg == nil or string.isNullOrEmpty(twoRankStrCfg.effect) == true then
    return
  end
  this.twoRankStr = twoRankStrCfg.effect
  local effHightCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500240)
  if effHightCfg == nil or string.isNullOrEmpty(effHightCfg.effect) == true then
    return
  end
  this.effHight = tonumber(effHightCfg.effect)
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiCross, "activityId")
  if temp == nil or temp.enterCondition == nil then
    return
  end
  for index, condition in pairs(temp.enterCondition) do
    if next(condition) ~= nil then
      for conditionIndex, conditionOne in pairs(condition) do
        if next(conditionOne) ~= nil and conditionOne[1] == 101 then
          this.needRoleLevel = conditionOne[2]
          break
        end
      end
    end
  end
  local tempZhengBa = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiZhengBa, "activityId")
  if tempZhengBa == nil or tempZhengBa.enterCondition == nil then
    return
  end
  for index, condition in pairs(tempZhengBa.enterCondition) do
    if next(condition) ~= nil then
      for conditionIndex, conditionOne in pairs(condition) do
        if next(conditionOne) ~= nil and conditionOne[1] == 101 then
          this.needRoleLevelOfZhengBa = conditionOne[2]
          break
        end
      end
    end
  end
end

function DuoQiCrossDataManager:GetScoreStrByType(type)
  if this.bubbleStrs ~= nil and this.bubbleStrs[type] ~= nil then
    return this.bubbleStrs[type]
  end
end

function DuoQiCrossDataManager:IsDuoQiActivityOpenAndCanEnter()
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiCross, "activityId")
  if temp == nil then
    return
  end
  if ConditionManager.Check4D(temp.enterCondition) and ConditionManager.Check4D(temp.condition) then
    return true
  end
  return false
end

function DuoQiCrossDataManager:IsDuoQiActivityOpen()
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiCross, "activityId")
  if temp == nil then
    return
  end
  if ConditionManager.Check4D(temp.condition) then
    return true
  end
  return false
end

function DuoQiCrossDataManager:IsDuoQiZhengBaActivityOpen()
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiZhengBa, "activityId")
  if temp == nil then
    return
  end
  if ConditionManager.Check4D(temp.condition) then
    return true
  end
  return false
end

function DuoQiCrossDataManager:IsDuoQiActivityOpenAndLevelOk()
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiCross, "activityId")
  if temp == nil then
    return
  end
  if ConditionManager.Check4D(temp.condition) then
    local needLevel = QuickFind:GetDuoQiCrossDataManager():GetNeedRoleLevel()
    if needLevel <= ViewData.meData.level then
      return true
    end
  end
  return false
end

function DuoQiCrossDataManager:IsZhengBaActivityOpenAndLevelOk()
  local temp = ClientTable.cfg_Activity_overviewManager:TryGetValue(PlayActivityIdType.DuoQiZhengBa, "activityId")
  if temp == nil then
    return
  end
  if ConditionManager.Check4D(temp.condition) then
    local needLevel = QuickFind:GetDuoQiCrossDataManager():GetNeedRoleLevelOfZhangBa()
    if needLevel <= ViewData.meData.level then
      return true
    end
  end
  return false
end

function DuoQiCrossDataManager:IsEnteredUnionMap()
  return this.isEnteredUnionMap
end

function DuoQiCrossDataManager:GetIsProcessResReturn()
  return this.isProgressResReturn
end

function DuoQiCrossDataManager:GetIsMoveResReturn()
  return this.isMoveResReturn
end

function DuoQiCrossDataManager:SetIsProcessResReturn(isReturn)
  this.isProgressResReturn = isReturn
end

function DuoQiCrossDataManager:SetEffActiveByType(effObj, effType)
  local tempTrans = effObj.EffectObj.transform:Find(effType)
  if tempTrans == nil or tempTrans.gameObject == nil or IsNil(tempTrans.gameObject) == true then
    return
  end
  tempTrans.gameObject:SetActive(true)
  for i, v in pairs(EffType) do
    if v ~= effType then
      local tempTr = effObj.EffectObj.transform:Find(v)
      tempTr.gameObject:SetActive(false)
    end
  end
end

function DuoQiCrossDataManager:SetFlagUnionName(effObj, unionName, unionNameColor)
  local nameLabel = effObj.EffectObj.transform:Find("alliancename/Label", typeof(CS.CSLabel))
  if IsNil(nameLabel) == false then
    if unionName == nil or string.isNullOrEmpty(unionName) then
      nameLabel.text = this.noUnionStr
    else
      nameLabel.text = string.format(this.unionNameFormat, unionName)
    end
    nameLabel.color = unionNameColor
  end
end

function DuoQiCrossDataManager:RemoveUnionEffs()
  if next(this.strongholdNeedInfo) ~= nil then
    for i, v in pairs(this.strongholdNeedInfo) do
      if v.effObj ~= nil and v.effObj.EffectObj ~= nil and IsNil(v.effObj.EffectObj) == false then
        SceneUtility.RemoveSceneEffect(v.effObj.EffectData.Id)
        v.effObj = nil
      end
    end
    this.strongholdNeedInfo = {}
  end
end

function DuoQiCrossDataManager:ResetActivityData()
  this:RemoveUnionEffs()
end

function DuoQiCrossDataManager:GetCfgOfFlagsMiniMap()
  return this.cfgOfFlagsOfMiniMap
end

function DuoQiCrossDataManager:SetMiniMapFlagIconBySubType(obj, type)
  obj.transform:Find("img_flag1").gameObject:SetActive(type == 1)
  obj.transform:Find("img_flag2").gameObject:SetActive(type == 2)
  obj.transform:Find("img_flag3").gameObject:SetActive(type == 3)
  obj.transform:Find("img_flag4").gameObject:SetActive(type == 4)
end

function DuoQiCrossDataManager:SetMiniBoxIconBySubType(obj, type)
  obj.transform:Find("img_box1").gameObject:SetActive(type == 1)
  obj.transform:Find("img_box2").gameObject:SetActive(type == 2)
  obj.transform:Find("img_box3").gameObject:SetActive(type == 3)
end

function DuoQiCrossDataManager:GetStrongholdInfo()
  return this.strongholdInfo
end

function DuoQiCrossDataManager:GetUnionNameColorOfMapByFlagId(flagId)
  local cfg = this.cfgOfStronghold
  if next(cfg) == nil or next(this.unionNameColorOfMap) == nil then
    return
  end
  for i, v in pairs(cfg) do
    if tonumber(v.relateId) == flagId then
      local serverData = this:GetStrongholdInfo()
      if next(serverData) == nil then
        return this.unionNameColorOfMap[3]
      else
        for m, n in ipairs(serverData) do
          if n.id == v.id then
            if n.unionId == RoleManager.me.unionId then
              return this.unionNameColorOfMap[1]
            elseif n.unionId == 0 then
              return this.unionNameColorOfMap[3]
            else
              return this.unionNameColorOfMap[2]
            end
          end
        end
        return this.unionNameColorOfMap[3]
      end
    end
  end
end

function DuoQiCrossDataManager:GetBornRangeByFlagId(flagId)
  local cfg = this.cfgOfStronghold
  if next(cfg) == nil then
    return
  end
  for i, v in pairs(cfg) do
    if tonumber(v.relateId) == flagId then
      return v.bornRange
    end
  end
end

function DuoQiCrossDataManager:GetStrongholdMultipleByUnionId(unionId)
  local serverData = this:GetStrongholdInfo()
  if next(serverData) == nil then
    return 0
  end
  local strongholdMultiple = 0
  for i, v in ipairs(serverData) do
    if v.unionId == unionId then
      local multiple = this:GetStrongholdOneMultipleById(v.id)
      if multiple == nil then
        return
      end
      strongholdMultiple = strongholdMultiple + multiple
    end
  end
  return strongholdMultiple
end

function DuoQiCrossDataManager:GetStrongholdOneMultipleById(id)
  if this.cfgOfStronghold[id] == nil or this.cfgOfStronghold[id].multiple == nil then
    return
  end
  return this.cfgOfStronghold[id].multiple
end

function DuoQiCrossDataManager:GetUnionNameByFlagId(flagId)
  local cfg = this.cfgOfStronghold
  if next(cfg) == nil then
    return
  end
  for i, v in pairs(cfg) do
    if tonumber(v.relateId) == flagId then
      local serverData = this:GetStrongholdInfo()
      if next(serverData) == nil then
        return this.noUnionStr
      else
        for m, n in ipairs(serverData) do
          if n.id == v.id then
            if string.isNullOrEmpty(n.unionName) ~= true then
              return n.unionName
            else
              return this.noUnionStr
            end
          end
        end
        return this.noUnionStr
      end
    end
  end
end

function DuoQiCrossDataManager:GetIsAllRewardGeted()
  return this.isAllRewardGeted
end

function DuoQiCrossDataManager:GetMyReachedRewardLevel()
  return this.myReachedRewardLevel
end

function DuoQiCrossDataManager:IsGetNowLastReward()
  return this.myGetedRewardCount + 1 == this.myReachedRewardLevel
end

function DuoQiCrossDataManager:IsCanGetReward()
  return this.myGetedRewardCount < this.myReachedRewardLevel
end

function DuoQiCrossDataManager:GetItemIdAndCountOfDuoQi()
  if next(this.cfgOfPersonalPoints) == nil then
    return
  end
  for i, v in ipairs(this.cfgOfPersonalPoints) do
    if i == this.myShowRewardLevel then
      local str = v.doubleConditon
      local strs = string.split(str, "#")
      if #strs ~= 2 then
        return
      end
      return tonumber(strs[1]), tonumber(strs[2])
    end
  end
end

function DuoQiCrossDataManager:GetItemIdAndCountOfZhengBa()
  if next(this.cfgOfPersonalPointsOfDuoQiZhengBa) == nil then
    return
  end
  for i, v in ipairs(this.cfgOfPersonalPointsOfDuoQiZhengBa) do
    if i == this.myShowRewardLevel then
      local str = v.doubleConditon
      local strs = string.split(str, "#")
      if #strs ~= 2 then
        return
      end
      return tonumber(strs[1]), tonumber(strs[2])
    end
  end
end

function DuoQiCrossDataManager:GetBtnsState(needItemId, needCount)
  local count = BagInfoData.GetItemTotalCountByItemId(needItemId)
  if this.myShowRewardLevel > this.myReachedRewardLevel then
    return 1
  elseif this.myShowRewardLevel <= this.myReachedRewardLevel and needCount > count then
    return 2
  elseif this.myShowRewardLevel <= this.myReachedRewardLevel and needCount <= count then
    return 3
  end
end

function DuoQiCrossDataManager:GetCanNotOperateStr()
  return this.canNotOperateStr
end

function DuoQiCrossDataManager:GetUnionLackStr()
  return this.unionLackStr
end

function DuoQiCrossDataManager:GetLevelLackStr()
  return this.levelLackStr
end

function DuoQiCrossDataManager:GetUnionActiNotOpenStr()
  return this.unionActiNotOpenStr
end

function DuoQiCrossDataManager:GetNeedRoleLevel()
  return this.needRoleLevel
end

function DuoQiCrossDataManager:GetNeedRoleLevelOfZhangBa()
  return this.needRoleLevelOfZhengBa
end

function DuoQiCrossDataManager:GetCanNotChangeMode()
  return this.canNotChangeMode
end

function DuoQiCrossDataManager:GetKillArtFont()
  return this.killArtFont
end

function DuoQiCrossDataManager:GetReliveCD()
  return this.reliveCD
end

function DuoQiCrossDataManager:GetReliveTip()
  return this.reliveTip
end

function DuoQiCrossDataManager:GetCanReliveTime()
  return this.canReliveTime
end

function DuoQiCrossDataManager:GetNoEnemyOfFlagTip()
  return this.noEnemyOfFlagTip
end

function DuoQiCrossDataManager:GetBoxNameScale()
  return this.boxNameScale
end

function DuoQiCrossDataManager:SetIsShowBtnDuoQiEnter(isShow)
  this.isShowBtnDuoQiEnter = isShow
end

function DuoQiCrossDataManager:SetIsShowBtnDuoQiZhengBaEnter(isShow)
  this.isShowBtnDuoQiZhengBaEnter = isShow
end

function DuoQiCrossDataManager:SetIsGreenOpenTimeStr(isGreen)
  this.isGreenOpenTimeStr = isGreen
end

function DuoQiCrossDataManager:IsInDuoQiByMapId()
  return this.lastMapId == 10206
end

function DuoQiCrossDataManager:IsInDuoQiZhengBaByMapId()
  return this.lastMapId == 10207
end

return DuoQiCrossDataManager
