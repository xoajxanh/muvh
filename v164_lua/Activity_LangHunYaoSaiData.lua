Activity_LangHunYaoSaiData = {}
local this = Activity_LangHunYaoSaiData
Activity_LangHunYaoSaiData.EmployInfo = {}
Activity_LangHunYaoSaiData.State = ActivityStatusEnum.END
Activity_LangHunYaoSaiData.runState = LangHunYaoSaiRunStateEnum.Ready
Activity_LangHunYaoSaiData.initTime = 0
Activity_LangHunYaoSaiData.Count = -1
Activity_LangHunYaoSaiData.inActivity = false
Activity_LangHunYaoSaiData.TalentBtnOnClick = false
Activity_LangHunYaoSaiData.prepareTime = 0
Activity_LangHunYaoSaiData.status = {}
Activity_LangHunYaoSaiData.monsterRefreshEnd = false
Activity_LangHunYaoSaiData.monsterRefreshStep = -1
Activity_LangHunYaoSaiData.nextMonsterRefreshTime = -1
Activity_LangHunYaoSaiData.yongBing = 0
Activity_LangHunYaoSaiData.yongBingIds = {}
Activity_LangHunYaoSaiData.nextMonsterAttackTime = 0
Activity_LangHunYaoSaiData.rewardExp = 0
Activity_LangHunYaoSaiData.SelfWarAlliance = 0
Activity_LangHunYaoSaiData.Ranks = {}
Activity_LangHunYaoSaiData.RankInfor = {score = 0, rank = 0}
Activity_LangHunYaoSaiData.TalentInfors = {}
Activity_LangHunYaoSaiData.monsterNum = -1
Activity_LangHunYaoSaiData.buffNum = -1
Activity_LangHunYaoSaiData.BuffPool = {}
Activity_LangHunYaoSaiData.UsedBuffTbl = {}
Activity_LangHunYaoSaiData.CurBuffId = -1
Activity_LangHunYaoSaiData.CurBuffPool = {}
Activity_LangHunYaoSaiData.StartTimeSec = 0
Activity_LangHunYaoSaiData.nextMonsterRefreshTimeSec = 0
Activity_LangHunYaoSaiData.yongBingConfigTbl = {}
Activity_LangHunYaoSaiData.CalledYongBingPosTbl = {}
Activity_LangHunYaoSaiData.curYongBingInfo = {}
Activity_LangHunYaoSaiData.throughState = ActivityStatusEnum.INIT
local buffCount = 2
Activity_LangHunYaoSaiData.SummonPos = {
  {x = 120, y = 38},
  {x = 126, y = 35},
  {x = 125, y = 27},
  {x = 117, y = 27},
  {x = 115, y = 35}
}

function Activity_LangHunYaoSaiData.Init()
  local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(100604)
  local employs = string.split(tbl.effect, "&")
  for _, v in pairs(employs) do
    local employ = string.split(v, "#")
    table.insert(this.EmployInfo, {
      employId = tonumber(employ[1]),
      cost = tonumber(employ[2])
    })
  end
  tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(100655)
  local buffStrs = string.split(tbl.effect, "&")
  for _, buffId in pairs(buffStrs) do
    table.insert(this.BuffPool, tonumber(buffId))
  end
  tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(100603)
  local positionStrs = string.split(tbl.effect, "&")
  for _, str in pairs(positionStrs) do
    local position = string.split(str, "#")
    table.insert(this.yongBingConfigTbl, {
      x = tonumber(position[1]),
      y = tonumber(position[2])
    })
  end
end

function Activity_LangHunYaoSaiData.RandomBuff()
  local preBuffIndex = -1
  if buffCount <= #this.BuffPool then
    this.CurBuffPool = this.BuffPool
  else
    for i = 1, buffCount do
      local random = Mathf.Random(1, #this.BuffPool)
      while random == preBuffIndex do
        logPurple(random)
        random = Mathf.Random(1, #this.BuffPool)
      end
      preBuffIndex = random
      table.insert(this.CurBuffPool, preBuffIndex)
    end
  end
end

function Activity_LangHunYaoSaiData.AddUsedBuff()
  table.insert(this.UsedBuffTbl, this.CurBuffId)
end

function Activity_LangHunYaoSaiData.SetYongBingPositionTbl(monsterTbl)
  Activity_LangHunYaoSaiData.CalledYongBingPosTbl = {}
  for _, monster in pairs(monsterTbl) do
    table.insert(Activity_LangHunYaoSaiData.CalledYongBingPosTbl, Vector2.New(monster.x, monster.y))
  end
end

function Activity_LangHunYaoSaiData.AddYongBingPosition()
  if table.count(this.curYongBingInfo) > 0 then
    table.insert(Activity_LangHunYaoSaiData.CalledYongBingPosTbl, Vector2.New(this.curYongBingInfo.x, this.curYongBingInfo.y))
  end
  this.curYongBingInfo = {}
end

function Activity_LangHunYaoSaiData.RoleIsLangHunYongBing(roleId)
  if this.State ~= ActivityStatusEnum.RUNNING then
    return false
  end
  if this.yongBing < 1 then
    return false
  end
  for i = 1, #this.yongBingIds do
    if this.yongBingIds[i] == roleId then
      return true
    end
  end
  return false
end

function Activity_LangHunYaoSaiData.Reset()
  Activity_LangHunYaoSaiData.State = ActivityStatusEnum.END
  Activity_LangHunYaoSaiData.runState = LangHunYaoSaiRunStateEnum.Ready
  Activity_LangHunYaoSaiData.throughState = ActivityStatusEnum.INIT
  Activity_LangHunYaoSaiData.monsterNum = -1
  Activity_LangHunYaoSaiData.buffNum = -1
  Activity_LangHunYaoSaiData.CurBuffId = -1
  Activity_LangHunYaoSaiData.nextMonsterRefreshTimeSec = 0
  Activity_LangHunYaoSaiData.UsedBuffTbl = {}
  Activity_LangHunYaoSaiData.BuffPool = {}
  Activity_LangHunYaoSaiData.CurBuffPool = {}
  Activity_LangHunYaoSaiData.yongBingConfigTbl = {}
  Activity_LangHunYaoSaiData.CalledYongBingPosTbl = {}
  Activity_LangHunYaoSaiData.curYongBingInfo = {}
end

this.Init()
