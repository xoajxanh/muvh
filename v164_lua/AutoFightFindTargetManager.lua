AutoFightFindTargetManager = {}
local this = AutoFightFindTargetManager

function AutoFightFindTargetManager.IsInKillSkillRange(monsterCell, pos, skillRange)
  local distance = Mathf.Max(Mathf.Abs(monsterCell.x - pos.x), Mathf.Abs(monsterCell.y - pos.y))
  return skillRange >= distance
end

function AutoFightFindTargetManager.GetMostMonsterAroundMe(skillRange, roleTypes, tblSkill)
  local monster = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, skillRange, RoleTargetManager.GetCanAttackRole)
  local aroundCellTable = {}
  local cfg_skillRange = ConfigManager.GetConfig("cfg_skillRange", tblSkill.path, "groupId")
  local meCell = RoleManager.me.cellPos
  for k, v in ipairs(cfg_skillRange.paths) do
    local points = v.points
    for i = 1, #points do
      local attackPoint = meCell + points[i]
      local posStr = string.format("%d_%d", attackPoint.x, attackPoint.y)
      if not aroundCellTable[posStr] then
        aroundCellTable[posStr] = {}
        aroundCellTable[posStr].interactIndex = {}
        table.insert(aroundCellTable[posStr].interactIndex, k)
      else
        table.insert(aroundCellTable[posStr].interactIndex, k)
      end
    end
  end
  local lineTable = {}
  local monsterLines = {}
  for i, v in pairs(monster) do
    local posStr = string.format("%d_%d", v.cellPos.x, v.cellPos.y)
    if aroundCellTable[posStr] then
      for k = 1, #aroundCellTable[posStr].interactIndex do
        local index = aroundCellTable[posStr].interactIndex[k]
        if not lineTable[index] then
          lineTable[index] = 0
        end
        lineTable[index] = lineTable[index] + 1
        if not monsterLines[index] then
          monsterLines[index] = v
        else
          local lineMonster = monsterLines[index]
          local distanceA = Mathf.Max(Mathf.Abs(lineMonster.cellPos.x - meCell.x), Mathf.Abs(lineMonster.cellPos.y - meCell.y))
          local distanceB = Mathf.Max(Mathf.Abs(v.cellPos.x - meCell.x), Mathf.Abs(v.cellPos.y - meCell.y))
          if distanceA > distanceB then
            monsterLines[index] = v
          end
        end
      end
    end
  end
  local pathsLength = #cfg_skillRange.paths
  local maxIndex = 0
  local maxCount = 0
  local resMonster
  for i = 1, pathsLength do
    local preIndex = i - 1
    preIndex = 0 < preIndex and preIndex or pathsLength
    local nextIndex = i + 1
    nextIndex = pathsLength >= nextIndex and nextIndex or 1
    local preCount = lineTable[preIndex]
    local curCount = lineTable[i]
    local nextCount = lineTable[nextIndex]
    local sumCount = preCount + curCount + nextCount
    if maxCount < sumCount then
      maxCount = sumCount
      maxIndex = i
      resMonster = monsterLines[i]
    end
  end
  if 1 < maxCount then
    return resMonster
  end
end

function AutoFightFindTargetManager.GetMostMonster(skillRange, autoDoubleSkillType, monsters)
  local posX = {
    0,
    1,
    1,
    1,
    0,
    -1,
    -1,
    -1
  }
  local posY = {
    -1,
    -1,
    0,
    1,
    1,
    1,
    0,
    -1
  }
  local monsterDict = {}
  for k, v in pairs(monsters) do
    if 0 < v.hp then
      if not monsterDict[v.cellPos.x] then
        monsterDict[v.cellPos.x] = {}
      end
      monsterDict[v.cellPos.x][v.cellPos.y] = {
        monster = v,
        count = 1,
        contain = {}
      }
    end
  end
  local skillJudge = autoDoubleSkillType == 3
  local distanceToMe = skillJudge and math.mininteger or math.maxinteger
  local intersectionCount = 1
  local resMonster
  for k, v in pairs(monsters) do
    local dictPos = {}
    local stackPos = Stack:New()
    local monsterCell = Vector2Int(v.cellPos.x, v.cellPos.y)
    dictPos[monsterCell.x] = {}
    dictPos[monsterCell.x][monsterCell.y] = true
    stackPos:Push(monsterCell)
    while 0 < stackPos:Count() do
      local tempPos = stackPos:Pop()
      for i = 1, #posX do
        local pos = Vector2Int(tempPos.x + posX[i], tempPos.y + posY[i])
        if not dictPos[pos.x] then
          dictPos[pos.x] = {}
        end
        if not dictPos[pos.x][pos.y] and this.IsInKillSkillRange(monsterCell, pos, skillRange) then
          stackPos:Push(pos)
          if monsterDict[pos.x] and monsterDict[pos.x][pos.y] then
            monsterDict[monsterCell.x][monsterCell.y].contain[monsterDict[pos.x][pos.y].monster.id] = true
            monsterDict[pos.x][pos.y].contain[monsterDict[monsterCell.x][monsterCell.y].monster.id] = true
            monsterDict[pos.x][pos.y].count = monsterDict[pos.x][pos.y].count + 1
            local mostMonsterCell = monsterDict[pos.x][pos.y]
            if intersectionCount < mostMonsterCell.count then
              intersectionCount = mostMonsterCell.count
              resMonster = mostMonsterCell.monster
              distanceToMe = Mathf.Max(Mathf.Abs(pos.x - RoleManager.me.cellPos.x), Mathf.Abs(pos.y - RoleManager.me.cellPos.y))
            elseif mostMonsterCell.count == intersectionCount then
              local distance = Mathf.Max(Mathf.Abs(pos.x - RoleManager.me.cellPos.x), Mathf.Abs(pos.y - RoleManager.me.cellPos.y))
              local res = true
              if skillJudge then
                res = distanceToMe < distance
              else
                res = distanceToMe > distance
              end
              if res then
                distanceToMe = distance
                resMonster = mostMonsterCell.monster
              end
            end
          end
        end
        dictPos[pos.x][pos.y] = true
      end
    end
  end
  if QiJiHelperData.groupSkillMonsterId then
    local monsterId = QiJiHelperData.groupSkillMonsterId
    local monster = RoleManager.GetRoleById(monsterId)
    if monster and monsterDict[monster.cellPos.x] and monsterDict[monster.cellPos.x][monster.cellPos.y] then
      local monsterCell = monsterDict[monster.cellPos.x][monster.cellPos.y]
      local count = monsterCell.count
      local distance = Mathf.Max(Mathf.Abs(monster.x - RoleManager.me.cellPos.x), Mathf.Abs(monster.y - RoleManager.me.cellPos.y))
      if intersectionCount <= count and distanceToMe >= distance then
        intersectionCount = count
        resMonster = monster
      end
    end
  end
  return 1 < intersectionCount and resMonster or false
end

function AutoFightFindTargetManager.GetMostMonsterInMonsterList(skillRange, roleTypes, autoDoubleSkillType)
  local monsterRange = QiJiHelperData.isAutoFight and QiJiHelperData.SettingData.KillMonsterScope or 8
  local monsters = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, monsterRange, RoleTargetManager.GetCanAttackRole)
  return this.GetMostMonster(skillRange, autoDoubleSkillType, monsters)
end

function AutoFightFindTargetManager.GetMostMonsterInMonsterListHook(skillRange, roleTypes, autoDoubleSkillType, onHookPos)
  local monsterRange = OnHookData.hookRange
  local monsters = RoleManager.GetRolesByTypeAndRangeAliveHook(roleTypes, onHookPos, monsterRange, RoleTargetManager.GetCanAttackRoleOnHookTime)
  return this.GetMostMonster(skillRange, autoDoubleSkillType, monsters)
end

function AutoFightFindTargetManager.GetMostMonsterIntersection(skillRange, roleTypes)
  local posX = {
    0,
    1,
    1,
    1,
    0,
    -1,
    -1,
    -1
  }
  local posY = {
    -1,
    -1,
    0,
    1,
    1,
    1,
    0,
    -1
  }
  local monsterIntersection = {}
  local distanceToMe = math.maxinteger
  local intersectionCount = 1
  local resCell = Vector2Int(0, 0)
  local monsterRange = QiJiHelperData.isAutoFight and QiJiHelperData.SettingData.KillMonsterScope or 8
  local monsters = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, monsterRange, RoleTargetManager.GetCanAttackRole)
  for k, v in pairs(monsters) do
    local dictPos = {}
    local stackPos = Stack:New()
    local monsterCell = Vector2Int(v.cellPos.x, v.cellPos.y)
    dictPos[monsterCell.x] = {}
    dictPos[monsterCell.x][monsterCell.y] = true
    stackPos:Push(monsterCell)
    while 0 < stackPos:Count() do
      local tempPos = stackPos:Pop()
      for i = 1, #posX do
        local pos = Vector2Int(tempPos.x + posX[i], tempPos.y + posY[i])
        if not dictPos[pos.x] then
          dictPos[pos.x] = {}
        end
        if not dictPos[pos.x][pos.y] and not Scene.tileData:IsBlock(pos.x, pos.y) and this.IsInKillSkillRange(monsterCell, pos, skillRange) then
          if not monsterIntersection[pos.x] then
            monsterIntersection[pos.x] = {}
            monsterIntersection[pos.x][pos.y] = 1
          elseif not monsterIntersection[pos.x][pos.y] then
            monsterIntersection[pos.x][pos.y] = 1
          else
            monsterIntersection[pos.x][pos.y] = monsterIntersection[pos.x][pos.y] + 1
          end
          stackPos:Push(pos)
          if intersectionCount < monsterIntersection[pos.x][pos.y] then
            intersectionCount = monsterIntersection[pos.x][pos.y]
            resCell = pos
            distanceToMe = Mathf.Max(Mathf.Abs(pos.x - RoleManager.me.cellPos.x), Mathf.Abs(pos.y - RoleManager.me.cellPos.y))
          elseif intersectionCount == monsterIntersection[pos.x][pos.y] then
            local distance = Mathf.Max(Mathf.Abs(pos.x - RoleManager.me.cellPos.x), Mathf.Abs(pos.y - RoleManager.me.cellPos.y))
            if distanceToMe > distance then
              distanceToMe = distance
              resCell = pos
            end
          end
        end
        dictPos[pos.x][pos.y] = true
      end
    end
  end
  if QiJiHelperData.groupSkillPos then
    local targetCell = QiJiHelperData.groupSkillPos
    if monsterIntersection[targetCell.x] and monsterIntersection[targetCell.x][targetCell.y] then
      local count = monsterIntersection[targetCell.x][targetCell.y]
      local distance = Mathf.Max(Mathf.Abs(targetCell.x - RoleManager.me.cellPos.x), Mathf.Abs(targetCell.y - RoleManager.me.cellPos.y))
      if intersectionCount <= count and distanceToMe >= distance then
        intersectionCount = count
        resCell = Vector2Int(targetCell.x, targetCell.y)
      end
    end
  end
  local meCell = Vector2Int(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y)
  if monsterIntersection[meCell.x] and monsterIntersection[meCell.x][meCell.y] and intersectionCount <= monsterIntersection[meCell.x][meCell.y] then
    intersectionCount = monsterIntersection[meCell.x][meCell.y]
    resCell = meCell
  end
  return 1 < intersectionCount and resCell or false
end

function AutoFightFindTargetManager.GetSpecifyMonsterIntersection(skillRange, specifyMonster, autoDoubleSkillType, roleTypes)
  local posX = {
    0,
    1,
    1,
    1,
    0,
    -1,
    -1,
    -1
  }
  local posY = {
    -1,
    -1,
    0,
    1,
    1,
    1,
    0,
    -1
  }
  local monsterIntersection = {}
  local distanceToMe = math.maxinteger
  local intersectionCount = 1
  local resCell = Vector2Int(0, 0)
  local spMonsterCell = Vector2Int(specifyMonster.cellPos.x, specifyMonster.cellPos.y)
  local spStackPos = Stack:New()
  spStackPos:Push(spMonsterCell)
  local spMonsterDict = {}
  spMonsterDict[spMonsterCell.x] = {}
  spMonsterDict[spMonsterCell.x][spMonsterCell.y] = true
  while 0 < spStackPos:Count() do
    local tempPos = spStackPos:Pop()
    for i = 1, #posX do
      local pos = Vector2Int(tempPos.x + posX[i], tempPos.y + posY[i])
      if not spMonsterDict[pos.x] then
        spMonsterDict[pos.x] = {}
      end
      if not spMonsterDict[pos.x][pos.y] and not Scene.tileData:IsBlock(pos.x, pos.y) and this.IsInKillSkillRange(spMonsterCell, pos, skillRange) then
        if not monsterIntersection[pos.x] then
          monsterIntersection[pos.x] = {}
          monsterIntersection[pos.x][pos.y] = 1
        elseif not monsterIntersection[pos.x][pos.y] then
          monsterIntersection[pos.x][pos.y] = 1
        end
        spStackPos:Push(pos)
      end
      spMonsterDict[pos.x][pos.y] = true
    end
  end
  local monsterRange = QiJiHelperData.isAutoFight and QiJiHelperData.SettingData.KillMonsterScope or 8
  local monsters = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, monsterRange, RoleTargetManager.GetCanAttackRole)
  for k, v in pairs(monsters) do
    if 0 < v.hp and v.id ~= specifyMonster.id and not v.isSummon then
      local dictPos = {}
      local stackPos = Stack:New()
      local monsterCell = Vector2Int(v.cellPos.x, v.cellPos.y)
      dictPos[monsterCell.x] = {}
      dictPos[monsterCell.x][monsterCell.y] = true
      stackPos:Push(monsterCell)
      while 0 < stackPos:Count() do
        local tempPos = stackPos:Pop()
        for i = 1, #posX do
          local pos = Vector2Int(tempPos.x + posX[i], tempPos.y + posY[i])
          if not dictPos[pos.x] then
            dictPos[pos.x] = {}
          end
          if not dictPos[pos.x][pos.y] and not Scene.tileData:IsBlock(pos.x, pos.y) and this.IsInKillSkillRange(monsterCell, pos, skillRange) then
            if monsterIntersection[pos.x] and monsterIntersection[pos.x][pos.y] then
              monsterIntersection[pos.x][pos.y] = monsterIntersection[pos.x][pos.y] + 1
              if intersectionCount < monsterIntersection[pos.x][pos.y] then
                intersectionCount = monsterIntersection[pos.x][pos.y]
                resCell = pos
                local distance = Mathf.Max(Mathf.Abs(pos.x - RoleManager.me.cellPos.x), Mathf.Abs(pos.y - RoleManager.me.cellPos.y))
                distanceToMe = distance
              elseif intersectionCount == monsterIntersection[pos.x][pos.y] then
                local distance = Mathf.Max(Mathf.Abs(pos.x - RoleManager.me.cellPos.x), Mathf.Abs(pos.y - RoleManager.me.cellPos.y))
                if distanceToMe > distance then
                  distanceToMe = distance
                  resCell = pos
                end
              end
            end
            stackPos:Push(pos)
          end
          dictPos[pos.x][pos.y] = true
        end
      end
    end
  end
  if QiJiHelperData.groupSkillPos then
    local targetCell = QiJiHelperData.groupSkillPos
    if monsterIntersection[targetCell.x] and monsterIntersection[targetCell.x][targetCell.y] then
      local count = monsterIntersection[targetCell.x][targetCell.y]
      local distance = Mathf.Max(Mathf.Abs(targetCell.x - RoleManager.me.cellPos.x), Mathf.Abs(targetCell.y - RoleManager.me.cellPos.y))
      if intersectionCount <= count and distanceToMe >= distance then
        intersectionCount = monsterIntersection[targetCell.x][targetCell.y]
        resCell = Vector2Int(targetCell.x, targetCell.y)
      end
    end
  end
  local meCell = Vector2Int(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y)
  if monsterIntersection[meCell.x] and monsterIntersection[meCell.x][meCell.y] and intersectionCount <= monsterIntersection[meCell.x][meCell.y] then
    intersectionCount = monsterIntersection[meCell.x][meCell.y]
    resCell = meCell
  end
  if autoDoubleSkillType == 1 then
    return 1 < intersectionCount and resCell or false
  elseif autoDoubleSkillType == 2 then
    return 1 < intersectionCount and specifyMonster or false
  end
end

function AutoFightFindTargetManager.GetSpecifyMonsterIntersectionNew(skillRange, specifyMonster, roleTypes)
  local posX = {
    0,
    1,
    1,
    1,
    0,
    -1,
    -1,
    -1
  }
  local posY = {
    -1,
    -1,
    0,
    1,
    1,
    1,
    0,
    -1
  }
  local monsterIntersection = {}
  local spMonsterCell = Vector2Int(specifyMonster.cellPos.x, specifyMonster.cellPos.y)
  local spStackPos = Stack:New()
  spStackPos:Push(spMonsterCell)
  local spMonsterDict = {}
  spMonsterDict[spMonsterCell.x] = {}
  spMonsterDict[spMonsterCell.x][spMonsterCell.y] = true
  while 0 < spStackPos:Count() do
    local tempPos = spStackPos:Pop()
    for i = 1, #posX do
      local pos = Vector2Int(tempPos.x + posX[i], tempPos.y + posY[i])
      if not spMonsterDict[pos.x] then
        spMonsterDict[pos.x] = {}
      end
      if not spMonsterDict[pos.x][pos.y] and not Scene.tileData:IsBlock(pos.x, pos.y) and this.IsInKillSkillRange(spMonsterCell, pos, skillRange) then
        if not monsterIntersection[pos.x] then
          monsterIntersection[pos.x] = {}
          monsterIntersection[pos.x][pos.y] = 1
        elseif not monsterIntersection[pos.x][pos.y] then
          monsterIntersection[pos.x][pos.y] = 1
        end
        spStackPos:Push(pos)
      end
      spMonsterDict[pos.x][pos.y] = true
    end
  end
  local monsterRange = QiJiHelperData.isAutoFight and QiJiHelperData.SettingData.KillMonsterScope or 8
  local monsters = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, monsterRange, RoleTargetManager.GetCanAttackRole)
  for k, v in pairs(monsters) do
    if 0 < v.hp and v.id ~= specifyMonster.id and not v.isSummon and monsterIntersection[v.cellPos.x] and monsterIntersection[v.cellPos.x][v.cellPos.y] then
      return true
    end
  end
end

function AutoFightFindTargetManager.IsHasMoreThanOneMonsterInSkillRangePos()
  local range = 0
  local autoDoubleSkillType = 0
  local roleTypes = {
    ERoleType.Monster
  }
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsGroupSkill(v.id) then
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) then
        range = v.autoDoubleSkillArea
        autoDoubleSkillType = v.autoDoubleSkillType
        local res = autoDoubleSkillType == 1 and this.GetMostMonsterIntersection(range, roleTypes) or this.GetMostMonsterInMonsterList(range, roleTypes, autoDoubleSkillType)
        if res then
          QiJiHelperData.groupSkillId = v.id
          return res, autoDoubleSkillType == 1 and "Pos" or "Monster"
        end
      end
    end
  end
  return false
end

function AutoFightFindTargetManager.IsHasMoreThanOneMonsterInSkillRangePosNew()
  local range = 0
  local autoDoubleSkillType = 0
  local roleTypes = {
    ERoleType.Monster
  }
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsGroupSkill(v.id) then
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoTarget(tblSkill, tblaction) then
        range = v.autoDoubleSkillArea
        autoDoubleSkillType = v.autoDoubleSkillType
        if autoDoubleSkillType == 1 then
          local targetGroup = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, range, RoleTargetManager.GetCanAttackRole)
          if 1 < #targetGroup and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return Vector2Int(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y), "Pos"
          end
        else
          local res = this.GetMostMonsterInMonsterList(range, roleTypes, autoDoubleSkillType)
          if res and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return res, "Monster"
          end
        end
      end
    end
  end
  return false
end

function AutoFightFindTargetManager.IsHasMoreThanOneMonsterInSkillRangeHook(hookPos)
  local range = 0
  local autoDoubleSkillType = 0
  local roleTypes = {
    ERoleType.Monster
  }
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsGroupSkill(v.id) then
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoTarget(tblSkill, tblaction) then
        range = v.autoDoubleSkillArea
        autoDoubleSkillType = v.autoDoubleSkillType
        if autoDoubleSkillType == 1 then
          local targetGroup = RoleManager.GetRolesByTypeAndRangeAliveHook(roleTypes, hookPos, range, RoleTargetManager.GetCanAttackRoleOnHookTime)
          if 1 < #targetGroup and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return Vector2Int(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y), "Pos"
          end
        else
          local res = this.GetMostMonsterInMonsterListHook(range, roleTypes, autoDoubleSkillType, hookPos)
          if res and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return res, "Monster"
          end
        end
      end
    end
  end
  return false
end

function AutoFightFindTargetManager.GetSpecifyMonsterIntersectionHook(skillRange, specifyMonster, roleTypes, hookPos)
  local posX = {
    0,
    1,
    1,
    1,
    0,
    -1,
    -1,
    -1
  }
  local posY = {
    -1,
    -1,
    0,
    1,
    1,
    1,
    0,
    -1
  }
  local monsterIntersection = {}
  local spMonsterCell = Vector2Int(specifyMonster.cellPos.x, specifyMonster.cellPos.y)
  local spStackPos = Stack:New()
  spStackPos:Push(spMonsterCell)
  local spMonsterDict = {}
  spMonsterDict[spMonsterCell.x] = {}
  spMonsterDict[spMonsterCell.x][spMonsterCell.y] = true
  while 0 < spStackPos:Count() do
    local tempPos = spStackPos:Pop()
    for i = 1, #posX do
      local pos = Vector2Int(tempPos.x + posX[i], tempPos.y + posY[i])
      if not spMonsterDict[pos.x] then
        spMonsterDict[pos.x] = {}
      end
      if not spMonsterDict[pos.x][pos.y] and not Scene.tileData:IsBlock(pos.x, pos.y) and this.IsInKillSkillRange(spMonsterCell, pos, skillRange) then
        if not monsterIntersection[pos.x] then
          monsterIntersection[pos.x] = {}
          monsterIntersection[pos.x][pos.y] = 1
        elseif not monsterIntersection[pos.x][pos.y] then
          monsterIntersection[pos.x][pos.y] = 1
        end
        spStackPos:Push(pos)
      end
      spMonsterDict[pos.x][pos.y] = true
    end
  end
  local monsterRange = QiJiHelperData.isAutoFight and QiJiHelperData.SettingData.KillMonsterScope or 8
  local monsters = RoleManager.GetRolesByTypeAndRangeAliveHook(roleTypes, hookPos, monsterRange, RoleTargetManager.GetCanAttackRoleOnHookTime)
  for k, v in pairs(monsters) do
    if 0 < v.hp and v.id ~= specifyMonster.id and not v.isSummon and monsterIntersection[v.cellPos.x] and monsterIntersection[v.cellPos.x][v.cellPos.y] then
      return true
    end
  end
end

function AutoFightFindTargetManager.IsHasMoreThanOneSpMonsterInSkillRangePosHook(specifyMonster, hookPos)
  local range = 0
  local autoDoubleSkillType = 0
  local roleTypes = {
    ERoleType.Monster
  }
  if Vector2.DistancePow(specifyMonster.serverCoord, hookPos) > OnHookData.hookRange * OnHookData.hookRange then
    return
  end
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsGroupSkill(v.id) then
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) then
        range = v.autoDoubleSkillArea
        autoDoubleSkillType = v.autoDoubleSkillType
        if autoDoubleSkillType == 1 then
          local targetGroup = RoleManager.GetRolesByTypeAndRangeAliveHook(roleTypes, hookPos, range, RoleTargetManager.GetCanAttackRoleOnHookTime)
          if 1 < #targetGroup and this.IsSpMonsterInMySkillRange(targetGroup, specifyMonster) and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return Vector2Int(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y), "Pos"
          end
        else
          local res = this.GetSpecifyMonsterIntersectionHook(range, specifyMonster, roleTypes, hookPos)
          if res and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return specifyMonster, "Monster"
          end
        end
      end
    end
  end
  return false
end

function AutoFightFindTargetManager.IsHasMoreThanOneSpMonsterInSkillRangePos(specifyMonster)
  local range = 0
  local autoDoubleSkillType = 0
  local roleTypes = {
    ERoleType.Monster
  }
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsGroupSkill(v.id) then
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) then
        range = v.autoDoubleSkillArea
        autoDoubleSkillType = v.autoDoubleSkillType
        local res = autoDoubleSkillType == 1 and this.GetSpecifyMonsterIntersection(range, specifyMonster, autoDoubleSkillType, roleTypes) or this.GetMostMonsterInMonsterList(range, roleTypes, autoDoubleSkillType)
        if res then
          QiJiHelperData.groupSkillId = v.id
          return res, autoDoubleSkillType == 1 and "Pos" or "Monster"
        end
      end
    end
  end
  return false
end

function AutoFightFindTargetManager.IsSpMonsterInMySkillRange(targetGroup, spMonster)
  for i, v in pairs(targetGroup) do
    if v.id == spMonster.id then
      return true
    end
  end
  return false
end

function AutoFightFindTargetManager.IsHasMoreThanOneSpMonsterInSkillRangePosNew(specifyMonster)
  local range = 0
  local autoDoubleSkillType = 0
  local roleTypes = {
    ERoleType.Monster
  }
  for i, v in pairs(QiJiHelperData.selfSelSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if QiJiHelperData.IsGroupSkill(v.id) then
      local tblaction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
      if ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblaction) then
        range = v.autoDoubleSkillArea
        autoDoubleSkillType = v.autoDoubleSkillType
        if autoDoubleSkillType == 1 then
          local targetGroup = RoleManager.GetRolesByTypeAndRangeAlive(roleTypes, range, RoleTargetManager.GetCanAttackRole)
          if 1 < #targetGroup and this.IsSpMonsterInMySkillRange(targetGroup, specifyMonster) and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return Vector2Int(RoleManager.me.cellPos.x, RoleManager.me.cellPos.y), "Pos"
          end
        else
          local res = this.GetSpecifyMonsterIntersectionNew(range, specifyMonster, roleTypes)
          if res and QiJiHelperData.IsNotAutoUseSkill(tblSkill) then
            QiJiHelperData.groupSkillId = v.id
            return specifyMonster, "Monster"
          end
        end
      end
    end
  end
  return false
end

function AutoFightFindTargetManager.IsCanAttackTargetTypeAutoGoTargetSkill(skillId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if tblSkill.autoGoTarget ~= AutoGoTargetEnum.AutoGoTarget then
    return true
  end
  if not RoleManager.me.TargetAvatar then
    return false
  end
  local targetCell = RoleManager.me.TargetAvatar.serverCoord
  local meCell = RoleManager.me.serverCoord
  local distance = Mathf.Max(Mathf.Abs(targetCell.x - meCell.x), Mathf.Abs(targetCell.y - meCell.y))
  return distance <= tblSkill.releaseDistance
end
