local DuoQiZhengBaDataManager = {}
setmetatable(DuoQiZhengBaDataManager, LuaClass.PlayActivity)
local this = DuoQiZhengBaDataManager
this.BeNominatedGroupList = {}
this.teamRankList = {}
this.notPassServerIds = {}
this.atLastServerCount = 3

function DuoQiZhengBaDataManager:Init()
  this:InitData()
end

function DuoQiZhengBaDataManager:InitData()
  local globalCfg = ClientTable.cfg_Activity_globalManager:TryGetValue(500401)
  if globalCfg == nil or globalCfg.effect == nil then
    return
  end
  this.atLastServerCount = tonumber(globalCfg.effect)
end

function DuoQiZhengBaDataManager:SetNominatedGroupList(data)
  local tempTbl = table.DeepCopy(data)
  table.sort(tempTbl, function(a, b)
    return a.serverId < b.serverId
  end)
  local nowServerId = 0
  local nowGroupIndex = 0
  local newTempTbl = {}
  for index, RuWeiInfo in ipairs(tempTbl) do
    if nowServerId ~= RuWeiInfo.serverId then
      nowServerId = RuWeiInfo.serverId
      nowGroupIndex = nowGroupIndex + 1
      newTempTbl[nowGroupIndex] = {}
    end
    table.insert(newTempTbl[nowGroupIndex], RuWeiInfo)
  end
  this.BeNominatedGroupList = newTempTbl
  EventManager.Dispatch(Event.RefreshDuoQiZhangBaUI)
end

function DuoQiZhengBaDataManager:ClearNominatedGroupList()
  this.BeNominatedGroupList = {}
end

function DuoQiZhengBaDataManager:GetNominatedGroupList()
  return this.BeNominatedGroupList
end

function DuoQiZhengBaDataManager:SetTeamRanks(rankData)
  this.teamRankList = table.DeepCopy(rankData)
  table.sort(this.teamRankList, function(a, b)
    return a.rank < b.rank
  end)
  EventManager.Dispatch(Event.RefreshDuoQiZhangBaUI)
end

function DuoQiZhengBaDataManager:ClearTeamRanks()
  this.teamRankList = {}
end

function DuoQiZhengBaDataManager:GetTeamRanks()
  return this.teamRankList
end

function DuoQiZhengBaDataManager:GetMyUnionRankOfZhengBa()
  local unionRankList = this:GetTeamRanks()
  for i, v in pairs(unionRankList) do
    if v.unionId == RoleManager.me.unionId then
      return v
    end
  end
end

function DuoQiZhengBaDataManager:GetMyRuWeiInfoOfZhengBa()
  local nominatedGroupList = this:GetNominatedGroupList()
  for i, v in pairs(nominatedGroupList) do
    if v ~= nil and table.count(v) > 0 then
      for _, nominatedInfo in pairs(v) do
        if nominatedInfo.unionId == ViewData.meData.unionId then
          return nominatedInfo
        end
      end
    end
  end
end

function DuoQiZhengBaDataManager:SetNotPassServerIds(serverIds)
  if serverIds == nil or table.count(serverIds) <= 0 then
    this.notPassServerIds = {}
  else
    this.notPassServerIds = table.DeepCopy(serverIds)
  end
end

function DuoQiZhengBaDataManager:GetNotPassServerIds()
  return this.notPassServerIds
end

function DuoQiZhengBaDataManager:GetAtLastServerCount()
  return this.atLastServerCount
end

return DuoQiZhengBaDataManager
