GradData = {}
local this = GradData

function GradData.Init()
  this.GradKillBossList = {}
  this.activityTime = {}
  this.openBossActivity = false
  this.floorMonster = {}
  this.timeList = {}
  this.maxFloor = nil
  this.boss = {
    GradBossEnum.OneBoss,
    GradBossEnum.TwoBoss,
    GradBossEnum.ThreeBoss,
    GradBossEnum.FourBoss,
    GradBossEnum.FiveBoss,
    GradBossEnum.SixBoss,
    GradBossEnum.SevenBoss,
    GradBossEnum.EightBoss,
    GradBossEnum.NineBoss
  }
  this.bossTal = {}
  this.AddBossInfo()
  this.reward = {
    GradBossRewardEnum.OneReward,
    GradBossRewardEnum.TwoReward,
    GradBossRewardEnum.ThreeReward,
    GradBossRewardEnum.FourReward,
    GradBossRewardEnum.FiveReward,
    GradBossRewardEnum.SixReward,
    GradBossRewardEnum.SevenReward,
    GradBossRewardEnum.EightReward,
    GradBossRewardEnum.NineReward
  }
  this.rewardTal = {}
  this.AddRewardInfo()
  this.gradType = 1302
  this.mapInfo = {}
  this.transInfo = {}
  this.InitTransInfo()
  this.SingleGradInfo()
  this.InitArea()
  this.GetGradBossTime()
  this.SortWeekTime()
end

function GradData.AddBossInfo(param)
  for p, t in pairs(this.boss) do
    print(t)
    local monsterList = ClientTable.cfg_Activity_globalManager:TryGetValue(t, "id").effect
    local monsterSingle = string.split(monsterList, "_")
    local dayList = string.split(monsterSingle[1], "#")
    local monsterList = string.split(monsterSingle[2], "#")
    local monsterTbl = {}
    for k, v in pairs(monsterList) do
      local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(v), "id")
      if monster ~= nil then
        monster.isKill = false
        table.insert(monsterTbl, monster)
      end
    end
    for k, v in pairs(dayList) do
      this.bossTal[tonumber(v)] = monsterTbl
    end
  end
end

function GradData.AddRewardInfo(param)
  for p, x in pairs(this.reward) do
    local rewardList = ClientTable.cfg_Activity_globalManager:TryGetValue(x, "id").effect
    local rewardSingle = string.split(rewardList, "_")
    local dayList = string.split(rewardSingle[1], "#")
    local rewardList = string.split(rewardSingle[2], "#")
    local rewardTbl = {}
    for k, v in pairs(rewardList) do
      local rewardBox = ClientTable.cfg_Box_boxManager:GetDic()
      for l, t in pairs(rewardBox) do
        if t.boxId == tonumber(v) then
          local rewardItemId = t.itemId
          local num = tonumber(t.count)
          rewardTbl[rewardItemId] = num
        end
      end
    end
    for k, v in pairs(dayList) do
      this.rewardTal[tonumber(v)] = rewardTbl
    end
  end
end

function GradData.GradBossInfo(id, data)
  if data ~= nil then
    this.GradKillBossList.mapInfo = data.basic
    this.GradKillBossList.activityState = data.killBossActivity.state
    this.GradKillBossList.runPhase = data.killBossActivity.run_step
    this.GradKillBossList.bossInfo = data.killBossActivity.boss
    this.GradKillBossList.hitRoleList = data.killBossActivity.hurtRoleIds
    this.GradKillBossList.auction = data.killBossActivity.tradeReward
  end
  this.openBossActivity = true
  this.RefushBossInfo()
  EventManager.Dispatch(Event.WarAlliance_BossUIUpdate)
end

function GradData.GradKillBossInfo(data)
  if data ~= nil then
    this.GradKillBossList.activityState = data.info.state
    this.GradKillBossList.runPhase = data.info.run_step
    this.GradKillBossList.bossInfo = data.info.boss
    this.GradKillBossList.hitRoleList = data.info.hurtRoleIds
    this.GradKillBossList.auction = data.info.tradeReward
  end
  this.RefushBossInfo()
  EventManager.Dispatch(Event.WarAlliance_BossUIUpdate)
end

function GradData.GetGradBossTime()
  local openActivityCond = ClientTable.cfg_Activity_overviewManager:TryGetValue(1001, "activityId").condition
  local openCondition = openActivityCond
  local openTime
  local weekChineDay = {
    "Th\225\187\169 2",
    "Th\225\187\169 3",
    "Th\225\187\169 4",
    "Th\225\187\169 5",
    "Th\225\187\169 6",
    "Th\225\187\169 7",
    "Ch\225\187\167 Nh\225\186\173t"
  }
  for i, v in pairs(openCondition) do
    local curTime = v
    local timeSingle = {}
    for j, t in ipairs(curTime) do
      local str = t
      if str[1] == 910 then
        openTime = weekChineDay[tonumber(str[2])]
        timeSingle.week = tonumber(str[2])
      end
      if str[1] == 908 then
        local _str = string.split(str[2], "-")
        local startStr = _str[1]
        local endStr = _str[2]
        local timeStr = string.split(startStr, ":")
        local endTimeStr = string.split(endStr, ":")
        local startTime1 = tonumber(timeStr[1]) < 10 and tonumber(timeStr[1]) .. "0:" or tonumber(timeStr[1]) .. ":"
        local startTime2 = tonumber(timeStr[2]) < 10 and tonumber(timeStr[2]) .. "0-" or tonumber(timeStr[2]) .. "-"
        local endTime1 = tonumber(endTimeStr[1]) < 10 and tonumber(endTimeStr[1]) .. "0:" or tonumber(endTimeStr[1]) .. ":"
        local endTime2 = tonumber(endTimeStr[2]) < 10 and tonumber(endTimeStr[2]) .. "0" or tonumber(endTimeStr[2]) .. ""
        openTime = startTime1 .. startTime2 .. endTime1 .. endTime2
        timeSingle.startHour = tonumber(timeStr[1])
        timeSingle.startMin = tonumber(timeStr[2])
        timeSingle.EndHour = tonumber(endTimeStr[1])
        timeSingle.EndMin = tonumber(endTimeStr[2])
        timeSingle.time = openTime
      end
    end
    if timeSingle.startHour ~= nil then
      if timeSingle.week == nil then
        timeSingle.week = 1
      end
      table.insert(this.timeList, timeSingle)
    end
  end
end

function GradData.SortWeekTime()
  this.activityTime = nil
  table.sort(this.timeList, function(a, b)
    return a.startHour < b.startHour
  end)
  local curTime = Time.GetServerSecondTime()
  local timeTbl = os.date("*t", curTime)
  local curDate = os.time({
    year = timeTbl.year,
    month = timeTbl.month,
    day = timeTbl.day,
    hour = timeTbl.hour,
    min = timeTbl.min
  })
  local nextTime
  for i = 1, #this.timeList do
    if tonumber(timeTbl.hour) <= 20 and tonumber(timeTbl.hour) > 12 then
      if tonumber(this.timeList[i].EndHour) == 20 then
        this.activityTime = this.timeList[i].time
        return
      end
    elseif tonumber(this.timeList[i].EndHour) == 12 then
      this.activityTime = this.timeList[i].time
      return
    end
  end
  if this.activityTime == nil then
    this.activityTime = this.timeList[1].time
  end
end

function GradData.GetGradTime()
  if this.activityTime ~= nil then
    local time = string.split(this.activityTime, "-")
    local startTime = time[1]
    local endTime = time[2]
    return startTime, endTime
  else
    return nil
  end
end

function GradData.GetReward()
  local generalIndex
  for k, v in pairs(this.rewardTal) do
    if k <= LoginData.GetOpenServerDay() then
      generalIndex = v
      return v
    end
  end
end

function GradData.GetBoss(index)
  if this.floorMonster[index] then
    return this.floorMonster[index]
  else
    return nil
  end
end

function GradData.RefushBossInfo()
  if this.GradKillBossList.bossInfo ~= nil and table.count(this.GradKillBossList.bossInfo) > 0 then
    for k, v in pairs(this.GradKillBossList.bossInfo) do
      local monster = ClientTable.cfg_Monster_monsterManager:TryGetValue(tonumber(v.cid), "id")
      monster.isKill = 0 >= v.hp
      this.floorMonster[k] = monster
    end
  else
    local generalIndex
    for k, v in pairs(this.bossTal) do
      if k <= LoginData.GetOpenServerDay() then
        generalIndex = v
        this.floorMonster = v
        break
      end
    end
  end
end

function GradData.GetGradInfo()
  local copyTal = ClientTable.cfg_Map_instanceManager:GetDic()
  local transferIdList = {}
  for k, v in pairs(copyTal) do
    if v.type == this.gradType then
      table.insert(transferIdList, v)
    end
  end
  table.sort(transferIdList, function(a, b)
    if a ~= nil and b ~= nil then
      return a.mapId < b.mapId
    end
  end)
  local transTable = ClientTable.cfg_Map_transferManager:GetDic()
  for k, v in pairs(transferIdList) do
    for t, tbl in pairs(transTable) do
      if tbl.groupId == v.mapId then
        this.mapInfo[v.mapId] = {
          floor = k,
          max = table.count(transferIdList),
          config = tbl
        }
      end
    end
  end
  this.maxFloor = table.count(transferIdList)
end

function GradData.GetFloorNum(mapId)
  if this.mapInfo[mapId] then
    return this.mapInfo[mapId]
  else
    return nil
  end
end

function GradData.GetTransferId(index)
  for k, v in pairs(this.mapInfo) do
    if v.floor == index then
      return v.config.id
    end
  end
end

function GradData.GetCurCount()
  return this.GradKillBossList.runPhase
end

function GradData.GetShowAuction()
  return this.GradKillBossList.auction
end

function GradData.InitTransInfo()
  local transList = ClientTable.cfg_Activity_globalManager:TryGetValue(100122, "id").effect
  local trans = string.split(transList, "#")
  for k, v in pairs(trans) do
    local transTbl = ClientTable.cfg_Map_eventManager:TryGetValue(tonumber(v), "eventId")
    this.transInfo[k] = {transId = v, tbl = transTbl}
  end
end

function GradData.GetTransPos(index)
  if this.transInfo[index] then
    local position = PathFinderManager.GetCalcPosData(this.transInfo[index].tbl.position)
    return position
  else
    return nil
  end
end

function GradData.GetNavi()
  local naveid = ClientTable.cfg_Activity_globalManager:TryGetValue(100128, "id").effect
  local naveTal = NavigationUtility.GetNavTblForId(tonumber(naveid))
  if naveTal then
    return naveTal
  end
end

function GradData.GoToNavi(naveTal)
  if naveTal.functionId ~= 0 then
    local condition = ClientTable.cfg_Function_functionManager:TryGetValue(naveTal.functionId, "id").condition
    if not ConditionManager.Check4D(condition) then
      FloatingTipUtility.QuickMsg("\196\144i\225\187\129u ki\225\187\135n kh\195\180ng \196\145\225\187\167")
      return false
    end
  end
  return true
end

function GradData.SingleGradInfo()
  local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(GradBossAreaTrans.TransInfoId).effect
  local transId = string.split(tbl, "&")
  for k, v in pairs(transId) do
    local floorTrans = string.split(v, "#")
    this.mapInfo[tonumber(floorTrans[1])] = tonumber(floorTrans[2])
  end
  this.maxFloor = table.count(this.mapInfo)
end

function GradData.GetSingleInfo(floor)
  if this.mapInfo[floor] then
    return this.mapInfo[floor]
  end
end

function GradData.InitArea()
  local tbl = ClientTable.cfg_Activity_globalManager:TryGetValue(GradBossArea.FloorArea).effect
  local area = string.split(tbl, "&")
  this.areaList = {}
  for k, v in pairs(area) do
    local floorTrans = string.split(v, "#")
    this.areaList[tonumber(floorTrans[1])] = {}
    this.areaList[tonumber(floorTrans[1])] = {
      fsPos = floorTrans[2],
      sePos = floorTrans[3]
    }
  end
end

function GradData.JudgeArea(pos)
  if pos then
    for k, v in pairs(this.areaList) do
      local pos1 = string.split(v.fsPos, "_")
      local pos2 = string.split(v.sePos, "_")
      pos1.x = tonumber(pos1[1])
      pos1.y = tonumber(pos1[2])
      pos2.x = tonumber(pos2[1])
      pos2.y = tonumber(pos2[2])
      local minX, manX, minY, manY
      if pos1.x > pos2.x then
        minX = pos2.x
        manX = pos1.x
      else
        minX = pos1.x
        manX = pos2.x
      end
      if pos1.y > pos2.y then
        minY = pos2.y
        manY = pos1.y
      else
        minY = pos1.y
        manY = pos2.y
      end
      if tonumber(minX) <= pos.x and tonumber(manX) >= pos.x and tonumber(minY) <= pos.y and tonumber(manY) >= pos.y then
        return k
      end
    end
  end
end
