local LuaKunShouBattleDataMgr = {}
setmetatable(LuaKunShouBattleDataMgr, LuaClass.PlayActivity)
LuaKunShouBattleDataMgr.des = nil
LuaKunShouBattleDataMgr.roleCampDic = nil

function LuaKunShouBattleDataMgr:AllRankList()
  if self.mRankList == nil then
    self.mRankList = {}
  end
  return self.mRankList
end

function LuaKunShouBattleDataMgr:RewardIndexInfoList()
  if self.mRewardIndexInfoList == nil then
    self.mRewardIndexInfoList = {}
  end
  return self.mRewardIndexInfoList
end

function LuaKunShouBattleDataMgr:AllRewardDic()
  if self.mAllRewardDic == nil then
    self.mAllRewardDic = {}
  end
  return self.mAllRewardDic
end

LuaKunShouBattleDataMgr.RankData = {}

function LuaKunShouBattleDataMgr:Init()
  self:InitParam()
end

function LuaKunShouBattleDataMgr:Refresh(activityTbl)
  self:RunBaseFunction("Refresh", activityTbl)
  self:InitRewardData()
end

function LuaKunShouBattleDataMgr:InitParam()
  self.mKillNoticeItem = {}
end

function LuaKunShouBattleDataMgr:InitRewardData()
  local rewardTblList = ClientTable.cfg_Activity_rankRewardManager:GetTabListByType(self:GetActivityId(), "activityId")
  local rewardList, rankLimit, rankText
  for i, v in pairs(rewardTblList) do
    rewardList = TableParse:SpliteStringToItemCountList(v.showReward)
    if rewardList and table.count(rewardList) > 0 then
      self:AllRewardDic()[v.id] = rewardList
      rankLimit = TableParse:SplitStringToIntList(v.rank, "#")
      rankText = nil
      if rankLimit and table.count(rankLimit) > 1 then
        if rankLimit[1] ~= rankLimit[2] and tonumber(rankLimit[1]) < tonumber(rankLimit[2]) then
          rankText = "H\225\186\161ng" .. tonumber(rankLimit[1]) .. "~" .. tonumber(rankLimit[2]) .. "0"
        elseif rankLimit[1] == rankLimit[2] then
          rankText = "H\225\186\161ng" .. rankLimit[1] .. "0"
        end
        table.insert(self:RewardIndexInfoList(), {
          id = v.id,
          minRank = rankLimit[1],
          maxRank = rankLimit[2],
          rankText = rankText
        })
      end
    end
  end
  table.sort(self:RewardIndexInfoList(), function(a, b)
    return a and b and a.minRank < b.minRank
  end)
end

function LuaKunShouBattleDataMgr:BindEventMsg()
end

function LuaKunShouBattleDataMgr:RefreshRankData(data)
  if data == nil then
    return
  end
  self:ResetRankData()
  self.mRankList = data.rankList
  self.mMyRankInfo = data.myRank
  self:RankSettlement(data.close)
  EventManager.Dispatch(Event.RefreshTrappedRank)
end

function LuaKunShouBattleDataMgr:RefreshKillData(data)
  EventManager.Dispatch(Event.RefreshNoticeMaxKillCount, data.maxKill)
end

function LuaKunShouBattleDataMgr:RefreshTrappedInstanceData()
  if RoleManager.me.data.mountData:GetidMountData(MountData.DefaultMount) then
    NetManager.Send(EquipMessage.ReqChangeHorseState, {
      position = RoleManager.me.data.mountData:GetidMountData(MountData.DefaultMount).bagGridIndex,
      ride = false
    })
  end
end

function LuaKunShouBattleDataMgr:ProcessKillNotice(noticeData)
  if noticeData == nil or not TranScriptData.IsInRefineKSBattle() then
    return
  end
  EventManager.Dispatch(Event.ShowkillNotice, self:GetNoticeItem(noticeData))
end

function LuaKunShouBattleDataMgr:ThreeVsThreeProcessKillNotice(noticeData)
  if noticeData == nil or not ThreeVsThreeUtility.MainPlayerInThreeVSThreeActivity() then
    return
  end
  EventManager.Dispatch(Event.ShowkillNotice, self:GetNoticeItem(noticeData))
end

function LuaKunShouBattleDataMgr:RankSettlement(isEnd)
  if isEnd then
    UIManager.Show(UIID.Activity_NightFightRankUI)
  end
end

function LuaKunShouBattleDataMgr:SetRankData(data)
  self.RankData = {}
  if data then
    for i, v in ipairs(data.ranks) do
      if v.name == ViewData.meData.name and v.lid == ViewData.meData.id then
        v.equips = ViewData.meData.equipsData.Data
        v.appear = ForgeData.appearData[RoleManager.me.id]
      end
    end
    self.RankData = data.ranks
  end
  EventManager.Dispatch(Event.RankKunShouPlayModel)
end

function LuaKunShouBattleDataMgr:IndividualKillNum()
  return self.mIndividualKillNum or 0
end

function LuaKunShouBattleDataMgr:GetRankList()
  return self:AllRankList()
end

function LuaKunShouBattleDataMgr:GetMeRankData()
  return self.mMyRankInfo
end

function LuaKunShouBattleDataMgr:GetRankData()
  if not self.RankData then
    return
  end
  return self.RankData
end

function LuaKunShouBattleDataMgr:GetSortedAllRankReward()
  if self.mSortedRewardList == nil then
    self.mSortedRewardList = {}
    for i, v in pairs(self:RewardIndexInfoList()) do
      if v and v.id then
        table.insert(self.mSortedRewardList, {
          reward = self:AllRewardDic()[v.id],
          rankText = v.rankText
        })
      end
    end
  end
  return self.mSortedRewardList
end

function LuaKunShouBattleDataMgr:GetRewardListByRank(rank)
  for i, v in pairs(self:RewardIndexInfoList()) do
    if v and v.minRank and v.maxRank and rank >= v.minRank and rank <= v.maxRank then
      return self:AllRewardDic()[v.id] or nil
    end
  end
  return nil
end

function LuaKunShouBattleDataMgr:NewRankItem(rankItem)
  local temp = {}
  temp.roleId = rankItem.roleId
  temp.name = rankItem.name
  temp.level = rankItem.level
  temp.career = rankItem.career
  temp.rank = rankItem.rank
  temp.score = rankItem.score
  temp.killNum = rankItem.killNum
  temp.maxKill = rankItem.maxKill
  temp.helpAttackNum = rankItem.helpAttackNum
  return temp
end

function LuaKunShouBattleDataMgr:GetNoticeItem(data)
  self.mKillNoticeItem.chatId = data.id
  if self.mKillNoticeItem.killer == nil then
    self.mKillNoticeItem.killer = {}
  end
  self.mKillNoticeItem.killer.lid = data.killRid
  self.mKillNoticeItem.killer.name = data.killName
  self.mKillNoticeItem.killer.career = RoleUtility.GetBasicCareer(data.killCareer)
  self.mKillNoticeItem.killer.group = data.group
  if self.mKillNoticeItem.dead == nil then
    self.mKillNoticeItem.dead = {}
  end
  self.mKillNoticeItem.dead.name = data.dieName
  self.mKillNoticeItem.dead.career = RoleUtility.GetBasicCareer(data.dieCareer)
  self.mKillNoticeItem.dead.group = data.group == 1 and 2 or 1
  local chatTab = ClientTable.cfg_Chat_chatManager:TryGetValue(data.id)
  self.mKillNoticeItem.audioId = chatTab and chatTab.audioID or nil
  self.mKillNoticeItem.noticeLevel = chatTab and chatTab.priority or nil
  self.mKillNoticeItem.param = chatTab and chatTab.systemChat or nil
  return self.mKillNoticeItem
end

function LuaKunShouBattleDataMgr:ResetRankData()
  self.mMyRankInfo = nil
  self.mRankList = {}
end

LuaKunShouBattleDataMgr.RewardData = nil
LuaKunShouBattleDataMgr.RewardDataCareer = nil

function LuaKunShouBattleDataMgr:ShowRankRewardData()
  if not self.RewardData or self.RewardDataCareer ~= ViewData.meData.career then
    self.RewardData = {}
    self.RewardDataCareer = ViewData.meData.career
    for i = 400501, 400505 do
      local reward = ClientTable.cfg_Activity_globalManager:TryGetValue(i, "id").effect
      local itemTable = TableParse:GetCareerConditionAttribute(reward)
      if itemTable then
        table.insert(self.RewardData, itemTable)
      end
    end
    return self.RewardData
  end
  return self.RewardData
end

function LuaKunShouBattleDataMgr:GetWordTime()
  self.kunShouTime = nil
  local openActivityCond = self:GetNoticeTimeConfig()
  local timeShow = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Activity_kunshou_7")
  local isOpen = ConditionManager.Check4D(openActivityCond)
  self.kunShouTime, self.TimeBol = self:GetNoticeTextConfig(isOpen, timeShow)
  return self.kunShouTime
end

function LuaKunShouBattleDataMgr:GetWordDes()
  if self.des == nil then
    self.des = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Activity_kunshou_6")
    return self.des
  end
  return self.des
end

function LuaKunShouBattleDataMgr:GetWordLevel()
  self.kunShouLevel = nil
  local timeShowLevel = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Activity_kunshou_8")
  local activityInlevel = string.split(timeShowLevel, "#")
  local tbl = ClientTable.cfg_Character_levelManager:TryGetValue(tonumber(activityInlevel[2]))
  local activityBool = tonumber(activityInlevel[2]) <= ViewData.meData.level
  self.kunShouLevel, self.LevelBol = self:GetNoticeTextConfig(activityBool, tbl.name)
  return self.kunShouLevel
end

function LuaKunShouBattleDataMgr:GetNoticeTextConfig(bool, showtext)
  local data
  local activityBool = false
  if bool then
    data = string.GetColorText(showtext, ItemQuality2ColorDic[5])
    activityBool = true
  else
    data = string.GetColorText(showtext, ItemQuality2ColorDic[7])
  end
  return data, activityBool
end

function LuaKunShouBattleDataMgr:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

function LuaKunShouBattleDataMgr:RefreshCampTeamDataByServerData(serverData)
  if type(serverData) ~= "table" then
    return
  end
  if self.roleCampDic == nil then
    self.roleCampDic = {}
  end
  for i, campInfo in ipairs(serverData.campTeamList) do
    for j, roleId in ipairs(campInfo.lid) do
      self.roleCampDic[roleId] = campInfo.campTeam
    end
  end
  RoleManager.RefreshHeadColor()
end

function LuaKunShouBattleDataMgr:GetRoleCampByRoleId(roleId)
  if type(roleId) ~= "number" or self.roleCampDic == nil then
    return nil
  end
  return self.roleCampDic[roleId]
end

function LuaKunShouBattleDataMgr:IsSameCamp(leftId, rightId)
  if type(leftId) ~= "number" or type(rightId) ~= "number" then
    return false
  end
  local leftCamp = self:GetRoleCampByRoleId(leftId)
  local rightCamp = self:GetRoleCampByRoleId(rightId)
  if leftCamp ~= nil and rightCamp ~= nil and leftCamp == rightCamp then
    return true
  end
  return false
end

return LuaKunShouBattleDataMgr
