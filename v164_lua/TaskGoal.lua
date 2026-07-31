TaskGoal = class()

function TaskGoal:ctor(goalId)
  self.goalTbl = {}
  self.monster = {}
  self.goalTbl = ClientTable.cfg_Task_goalManager:TryGetValue(goalId, "goalId")
  if self.goalTbl ~= nil then
    if self.goalTbl.type == TaskGoalType.KillMonster or self.goalTbl.type == TaskGoalType.AffiliationKill or self.goalTbl.type == TaskGoalType.TeamAffiliationKill then
      local monsterList = string.splitToNumbers(self.goalTbl.goalParam)
      for k, v in pairs(monsterList) do
        local monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(v, "id")
        local monsterInfo = {}
        monsterInfo.monsterTbl = monsterTbl
        table.insert(self.monster, monsterInfo)
      end
    end
  else
    logError("Kh\195\180ng t\195\172m th\225\186\165y d\225\187\175 li\225\187\135u cfg_Task_goal", goalId)
    return
  end
  local targetList = string.splitToNumbers(self.goalTbl.target)
  self.targetType = targetList[1]
  self.npcId = nil
  self.targetMap = nil
  if self.targetType == TaskTargetType.NpcTarget then
    self.npcId = targetList[2]
  end
  if self.targetType == TaskTargetType.SingleMap then
    self.targetMap = targetList[2]
  end
  local seekType = string.splitToNumbers(self.goalTbl.seekType)
  self.seekType = seekType[1]
  self.finishCount = 0
  self:InitPosIndex()
  self.postionList = string.split(self.goalTbl.position, "#")
  if 1 < table.count(self.postionList) or self.seekType == TaskTargetMonsterType.MapLock then
    self.posType = TaskTragetPosType.MultiPos
  else
    self.posType = TaskTragetPosType.SinglePos
  end
  self.finishGoalParam = {}
end

function TaskGoal:InitPosIndex()
  self.posIndex = 1
end

function TaskGoal:SetPurposeful()
  if self.seekType == TaskTargetMonsterType.MonsterTpye then
    self.posIndex = self.posIndex + 1
  end
end

function TaskGoal:SetRandomPosIndex(sceneId)
  local sceneList = string.split(self.goalTbl.target, "#")
  for k, v in pairs(sceneList) do
    if tonumber(v) == sceneId then
      self.posIndex = k - 1
    end
  end
end

function TaskGoal:GetTarget()
  return self.targetType
end

function TaskGoal:GetMulPosition()
  return self.posType
end

function TaskGoal:GetFlagMul()
  return self.posType == TaskTragetPosType.MultiPos
end

function TaskGoal:GetTransferId()
  return self.goalTbl.transferId
end

function TaskGoal:GetNpc()
  return self.npcId
end

function TaskGoal:GetGoldType()
  return self.goalTbl.type
end

function TaskGoal:GetMonster()
  return self.monster
end

function TaskGoal:GetTargetMap()
  return self.targetMap
end

function TaskGoal:GetGoalSeekType()
  return self.seekType
end

function TaskGoal:SetCurFinishCount(count)
  self.finishCount = count
end

function TaskGoal:SetCurGoalParam(param)
  if param == nil then
    return
  end
  self.finishGoalParam = param
end

function TaskGoal:GetCurGoalParam()
  return self.finishGoalParam
end

function TaskGoal:GetCurFinishCount()
  return tonumber(self.finishCount)
end

function TaskGoal:GetCount()
  return self.goalTbl.goalCount
end

function TaskGoal:GetShowGoalParam()
  return self.goalTbl.showColor
end

function TaskGoal:GetAllGoalParam()
  local goalParamList = string.splitToNumbers(self.goalTbl.goalParam)
  return goalParamList
end

function TaskGoal:GetTargetParam()
  local monsterList = string.splitToNumbers(self.goalTbl.goalParam)
  return monsterList[1]
end

function TaskGoal:GetTargetResout()
  local goalParamList = string.splitToNumbers(self.goalTbl.goalParam)
  local finishList = {}
  local isFind = false
  for k, v in pairs(goalParamList) do
    if self.finishGoalParam ~= nil then
      isFind = false
      for l, t in pairs(self.finishGoalParam) do
        if v ~= nil and t ~= nil and v == tonumber(t) then
          isFind = true
        end
      end
      finishList[k] = isFind
    end
  end
  return finishList
end

function TaskGoal:GetPosition()
  if self.postionList == nil or self.postionList == "" then
    return
  end
  if self.seekType == TaskTargetMonsterType.MonsterId or self.seekType == TaskTargetMonsterType.Random then
    return self:GetRandomPos()
  end
  if self.seekType == TaskTargetMonsterType.MonsterTpye then
    local transferIdList = {}
    if self.goalTbl.transferId ~= nil and self.goalTbl.transferId ~= "" then
      transferIdList = string.split(self.goalTbl.transferId, "#")
    end
    if self.posIndex > table.count(self.postionList) then
      self.posIndex = 1
    end
    local sceneId
    local sceneList = string.split(self.goalTbl.target, "#")
    if tonumber(sceneList[1]) == TaskTargetType.MultiMap then
      sceneId = sceneList[self.posIndex + 1]
    else
      sceneId = sceneList[2]
    end
    return self:GetFlagMul(), tonumber(sceneId), self.postionList[self.posIndex], tonumber(transferIdList[self.posIndex]), self.seekType, self.goalTbl.positionRange
  end
  if self.seekType == TaskTargetMonsterType.MapLock then
    if MapMonster.FindMonsterData() ~= nil then
      local monsterData = MapMonster.FindMonsterData()
      return self:GetFlagMul(), SceneData.groupId, Vector2(monsterData.x, monsterData.y), nil, self.seekType, self.goalTbl.positionRange
    else
      return self:GetFlagMul(), SceneData.groupId, nil, nil, self.seekType, self.goalTbl.positionRange
    end
  end
  if self.seekType == TaskTargetMonsterType.CheckDistance then
    local sceneList = string.split(self.goalTbl.target, "#")
    if table.count(sceneList) < 2 or tonumber(sceneList[1]) ~= TaskTargetType.SingleMap then
      return
    end
    local sceneId = tonumber(sceneList[2])
    if SceneData.groupId ~= sceneId then
      return self:GetRandomPos()
    else
      return self:GetRecentPos()
    end
  end
end

function TaskGoal:GetRandomPos()
  local transferIdList = {}
  if self.goalTbl.transferId ~= nil and self.goalTbl.transferId ~= "" then
    transferIdList = string.split(self.goalTbl.transferId, "#")
  end
  local position = string.split(self.goalTbl.position, "#")
  if table.count(position) == 0 then
    return
  end
  if self.posIndex ~= nil and table.count(position) > 1 and self.posIndex <= table.count(position) then
    table.remove(position, self.posIndex)
  end
  local randomIndex = Mathf.Random(1, table.count(position))
  local sceneId
  local sceneList = string.split(self.goalTbl.target, "#")
  if tonumber(sceneList[1]) == TaskTargetType.MultiMap then
    if self.posIndex ~= nil and table.count(sceneList) > 2 and self.posIndex + 1 <= table.count(sceneList) then
      table.remove(sceneList, self.posIndex + 1)
    end
    sceneId = sceneList[randomIndex + 1]
  else
    sceneId = sceneList[2]
  end
  self:SetRandomPosIndex(tonumber(sceneId))
  return self:GetFlagMul(), tonumber(sceneId), position[randomIndex], tonumber(transferIdList[randomIndex]), self.seekType, self.goalTbl.positionRange
end

function TaskGoal:GetRecentPos()
  local position = string.split(self.goalTbl.position, "#")
  if table.count(position) == 0 then
    return
  end
  local mainPos = {
    x = RoleManager.me.cellPos.x,
    y = RoleManager.me.cellPos.y
  }
  local distance, curDistance, index = 0, 0, 1
  local positionNum = table.count(position)
  local posItem = {}
  for i = 1, positionNum do
    posItem = string.split(position[i], "_")
    if table.count(posItem) > 1 then
      distance = PathFinding.GetDistance(mainPos, {
        x = tonumber(posItem[1]),
        y = tonumber(posItem[2])
      })
    end
    if curDistance > distance or curDistance == 0 then
      curDistance = distance
      index = i
    end
  end
  return self:GetFlagMul(), SceneData.groupId, position[index], nil, self.seekType, self.goalTbl.positionRange
end
