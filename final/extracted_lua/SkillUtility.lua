SkillUtility = {}
local this = SkillUtility

function SkillUtility.GetRolePos(role, node)
  return role:GetModelNode(node)
end

function SkillUtility.GetPointByAttacker(attacker, point)
  if attacker ~= nil and attacker.dir ~= nil then
    local directionz = Direction8Utility:GetOffsetZByAngleAccurate(Mathf.Round(attacker.dir))
    local directionx = Direction8Utility:GetOffsetXByAngleAccurate(Mathf.Round(attacker.dir))
    return Vector3(directionz.x, 0, directionz.z) * point.z + Vector3(directionx.x, 0, directionx.z) * point.x + Vector3(0, point.y, 0)
  end
  return Vector3(0, 0, 0)
end

function SkillUtility.GetSkillDuration(tblSkill, attackSpeed, defaultSpeed)
  if attackSpeed == nil then
    return defaultSpeed
  end
  if attackSpeed <= 0 then
    attackSpeed = 0.01
  end
  return (tblSkill.publicCD - tblSkill.stiffTime) * 0.001 / attackSpeed
end

function SkillUtility.GetRealSkillCd(tblSkill, attackSpeed)
  local resultCD = SkillUtility.GetCdTime(tblSkill) / attackSpeed
  return resultCD
end

function SkillUtility.GetInSpeedTime(duration, attackSpeed)
  if attackSpeed == nil then
    return duration
  end
  if attackSpeed <= 0 then
    attackSpeed = 0.01
  end
  local reversedAttackSpeed = 1 / attackSpeed
  return duration * reversedAttackSpeed
end

function SkillUtility.GetActionDefaultEndTime(actionCfg)
  local endTime = 0
  for _, actList in pairs(actionCfg.actions) do
    for _, act in pairs(actList) do
      local actEndtime = act.startTime + act.duration
      if endTime < actEndtime then
        endTime = actEndtime
      end
    end
  end
  return endTime
end

function SkillUtility.ShouldApplySkillEffectDirectly(skillActionCfg)
  local attackSpeed = ViewData.meData:GetAttribute(EAttributeType.attackSpeedCalculateValue)
  if skillActionCfg.actions.ActionApplySkillEffectData ~= nil then
    local startTime = skillActionCfg.actions.ActionApplySkillEffectData[1].startTime / attackSpeed
    return startTime < GlobalConfig.ApplySkillEffect_Ticktime_Min * 0.001
  end
  return true
end

function SkillUtility.ConstructSkillFromClientData(skillId, casterId, casterCoord, targetId, targetCoord, chooseRangeIndex, attackSpeed)
  local skill_struct = {}
  skill_struct.skillId = skillId
  skill_struct.attackerId = casterId
  skill_struct.targetId = targetId
  skill_struct.x = targetCoord.x
  skill_struct.y = targetCoord.y
  skill_struct.attackerX = casterCoord.x
  skill_struct.attackerY = casterCoord.y
  skill_struct.chooseRangeIndex = chooseRangeIndex
  skill_struct.attackSpeed = attackSpeed
  skill_struct.state = SkillState.None
  skill_struct.tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  skill_struct.groupId = skill_struct.tblSkill.groupId
  local actionId = ClientTable.cfg_Skill_skillManager:GetActionIdBySkillId(skill_struct.tblSkill.id)
  skill_struct.skillConfig = ConfigManager.GetConfig("cfg_actionLogic", actionId, "groupId")
  if skill_struct.tblSkill.effectArea == 1 then
    skill_struct.skillRangeConfig = ConfigManager.GetConfig("cfg_skillRange", skill_struct.tblSkill.path, "groupId")
  end
  if skill_struct.attackerId ~= nil and skill_struct.attackerId ~= 0 then
    skill_struct.attacker = RoleManager.GetRoleById(skill_struct.attackerId)
  end
  if skill_struct.targetId then
    skill_struct.target = RoleManager.GetRoleById(skill_struct.targetId)
    if skill_struct.target then
      skill_struct.targetPos = skill_struct.target.pos:Clone()
    end
  end
  if skill_struct.targetPos == nil then
    skill_struct.targetPos = Scene.GetPosByCell(Vector2Int(skill_struct.x, skill_struct.y))
  end
  skill_struct.preserved = 0
  SkillData.SetSkillStructActionConfig(skill_struct)
  return skill_struct
end

function SkillUtility.ConstructSkillFromServerData(data)
  local skill_struct = {}
  skill_struct.skillId = data.skillId
  skill_struct.attackerId = data.attackerId
  skill_struct.targetId = data.targetId
  skill_struct.x = data.x
  skill_struct.y = data.y
  skill_struct.attackerX = data.attackerX
  skill_struct.attackerY = data.attackerY
  skill_struct.hurtList = data.hurtList
  skill_struct.mp = data.mp
  skill_struct.skillExp = data.skillExp
  skill_struct.useBufferId = data.useBufferId
  skill_struct.mapId = data.mapId
  skill_struct.position = data.position
  skill_struct.chooseRangeIndex = data.chooesPos
  skill_struct.preserved = data.preserved
  skill_struct.attackSpeed = data.attackSpeed and data.attackSpeed * 1.0E-4 or 1
  skill_struct.state = SkillState.None
  skill_struct.notChangeDir = data.notChange
  if skill_struct.attackerId ~= nil and skill_struct.attackerId ~= 0 then
    skill_struct.attacker = RoleManager.GetRoleById(skill_struct.attackerId)
  end
  if skill_struct.targetId ~= nil and skill_struct.targetId ~= 0 then
    skill_struct.target = RoleManager.GetRoleById(skill_struct.targetId)
    if skill_struct.target then
      skill_struct.targetPos = Scene.GetPosByCell(skill_struct.target.serverCoord)
    end
  end
  if skill_struct.targetPos == nil then
    skill_struct.targetPos = Scene.GetPosByCell(Vector2Int(skill_struct.x, skill_struct.y))
  end
  skill_struct.tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(data.skillId)
  skill_struct.groupId = skill_struct.tblSkill.groupId
  local actionId = ClientTable.cfg_Skill_skillManager:GetSkillActionIdByRunLevel(skill_struct.tblSkill.actionId, data.pecialEffects)
  skill_struct.skillConfig = ConfigManager.GetConfig("cfg_actionLogic", actionId, "groupId")
  if skill_struct.tblSkill.effectArea == 1 then
    skill_struct.skillRangeConfig = ConfigManager.GetConfig("cfg_skillRange", skill_struct.tblSkill.path, "groupId")
  end
  if skill_struct.skillRangeConfig == nil then
    skill_struct.position = nil
  end
  SkillData.SetSkillStructActionConfig(skill_struct)
  return skill_struct
end

function SkillUtility.GetXIFChiSurplusCount()
  local skillId = RoleManager.me.skills[11110100].sid
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local chargingTimes = SkillUtility.GetChargingTimes(tblSkill)
  local chargeEndTime = RoleManager.me.cd[tblSkill.groupId] and RoleManager.me.cd[tblSkill.groupId].endTime
  if chargeEndTime then
    local resCdTime = SkillUtility.GetRealSkillCd(tblSkill, ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue])
    local chargingStartTime = Time.GetServerTime() - (chargingTimes - 1) * resCdTime
    if chargeEndTime > chargingStartTime then
      local intervalTime = chargeEndTime - chargingStartTime - Time.deltaTime * 1000
      local counts = Mathf.Ceil(intervalTime / resCdTime)
      return 0 <= chargingTimes - counts and chargingTimes - counts or 0
    end
    return chargingTimes
  end
  return chargingTimes
end

function SkillUtility.UpdateTips(skillConfig, color)
  local itemTip = ClientTable.cfg_Item_tipsManager:TryGetValue(skillConfig.description).content
  if string.find(itemTip, ESkillDescType.MaxDamage) then
    local maxDamage = skillConfig.maxDamage
    itemTip = string.replace(itemTip, ESkillDescType.MaxDamage, string.format("<color=%s>%s</color>", color, maxDamage))
  end
  if string.find(itemTip, ESkillDescType.SkillBaseDmg) then
    local skillBaseDmg = skillConfig.skillBaseDmg / 100
    itemTip = string.replace(itemTip, ESkillDescType.SkillBaseDmg, string.format("<color=%s>%s</color>", color, skillBaseDmg))
  end
  if string.find(itemTip, ESkillDescType.CD) then
    local cd = SkillUtility.GetRealSkillCd(skillConfig, ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue])
    cd = string.format("%.2f", cd / 1000)
    itemTip = string.replace(itemTip, ESkillDescType.CD, string.format("<color=%s>%s</color>", color, cd))
  end
  return itemTip
end

function SkillUtility.CanJumpHitToTargetRoleCell(tblSkill, caster, targetRole)
  if caster == nil or targetRole == nil then
    return false
  end
  if targetRole then
    if targetRole.dynamicBlock then
      return false
    end
    if targetRole.RoleType == ERoleType.Monster then
      if targetRole.data.roleBuffData:CheckState(RoleBuffState.PUSHED_IMMUNITY) then
        return false
      end
      local monsterTbl = ClientTable.cfg_Monster_monsterManager:TryGetValue(targetRole.configId, "id")
      if monsterTbl.pushedImmunity == 1 then
        return false
      else
        if tblSkill.pos == nil or tblSkill.pos == "" then
          return false
        end
        local jumpParam = string.splitToNumbers(tblSkill.pos)
        if jumpParam[1] == 1 then
          local targetCell = 2 * targetRole.serverCoord - caster.serverCoord
          return not Scene.IsBlock(targetCell)
        end
      end
    end
  end
  return true
end

function SkillUtility.GetSkillRangesConfig(skillId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if tblSkill then
    return ConfigManager.GetConfig("cfg_skillRange", tblSkill.path, "groupId")
  end
end

function SkillUtility.GetSkillRangeDir(rangeCfg, rangdeIndex)
  if rangeCfg and rangeCfg.paths and #rangeCfg.paths > 1 then
    local deltaDir = 360 / #rangeCfg.paths
    return deltaDir * rangdeIndex
  end
end

function SkillUtility.IsDontNeedTargetSkill(skillId)
  if skillId == nil then
    return false
  end
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if not tblSkill then
    logError(string.format("B\225\186\163ng k\225\187\185 n\196\131ng c\225\187\167a k\225\187\185 n\196\131ng id=%s tr\225\187\145ng", skillId))
    return false
  end
  if tblSkill.castTargetType == ESkillCastType.Mine or tblSkill.castTargetType == ESkillCastType.Me or tblSkill.castTargetType == ESkillCastType.MePos then
    return true
  else
    return false
  end
end

function SkillUtility.GetFarestFlashPoint(tblSkill, casterId)
  local caster = RoleManager.GetRoleById(casterId)
  if not caster or not tblSkill then
    return
  end
  local jumpParam = string.splitToNumbers(tblSkill.pos)
  if jumpParam[1] == 6 then
    local dir8 = Direction8Utility.GetRoleDirInDirection8(caster.dir)
    dir8 = Direction8Utility.GetDirectionOffset(dir8)
    local startCell = ViewData.meData.serverCoord:Clone()
    local endx, endy
    for i = 6, 1, -1 do
      endx = startCell.x + dir8.x * i
      endy = startCell.y + dir8.y * i
      if not Scene.IsTileType(endx, endy, SceneTileType.Ignore) then
        startCell:Set(endx, endy)
        break
      end
    end
    return startCell
  end
end

local operatePriority = {
  ["("] = 0,
  ["+"] = 2,
  ["-"] = 2,
  ["*"] = 3,
  ["/"] = 3,
  ["/"] = 3,
  [")"] = 7
}

function SkillUtility.FloatingPointCalc(operateWord, num1, num2)
  local res = 0
  if num1 == nil then
    num1 = 0
  end
  if operateWord == "+" then
    res = num1 + num2
  elseif operateWord == "-" then
    res = num1 - num2
  elseif operateWord == "*" then
    res = num1 * num2
  elseif operateWord == "/" then
    res = num1 / num2
  end
  return res
end

function SkillUtility.DirectCalc(opStack, numStack, isBracket)
  local opt = opStack:Pop()
  local num2 = numStack:Pop()
  local num1 = numStack:Pop()
  local res = this.FloatingPointCalc(opt, num1, num2)
  numStack:Push(res)
  if isBracket then
    if opStack:Peek() == "(" then
      opStack:Pop()
    else
      this.DirectCalc(opStack, numStack, isBracket)
    end
  elseif not opStack:IsEmpty() then
    this.DirectCalc(opStack, numStack, isBracket)
  end
end

function SkillUtility.GetPriority(opt1, opt2)
  local priority = operatePriority[opt2] - operatePriority[opt1]
  return priority
end

function SkillUtility.CompareAndCalc(opStack, numStack, operateWord)
  local operate = opStack:Peek()
  local priority = this.GetPriority(operate, operateWord)
  if priority == -1 or priority == 0 then
    local curOperate = opStack:Pop()
    local num2 = numStack:Pop()
    local num1 = numStack:Pop()
    local res = this.FloatingPointCalc(curOperate, num1, num2)
    numStack:Push(res)
    if opStack:IsEmpty() then
      opStack:Push(operateWord)
    else
      this.CompareAndCalc(opStack, numStack, operateWord)
    end
  else
    opStack:Push(operateWord)
  end
end

function SkillUtility.ExecuteExpression(expression)
  local opStack = Stack:New()
  local numStack = Stack:New()
  local fullWord = ""
  for i = 1, #expression do
    local word = string.sub(expression, i, i)
    local num = tonumber(word)
    if num or word == "." then
      fullWord = fullWord .. word
    else
      if 0 < #fullWord then
        numStack:Push(fullWord)
        fullWord = ""
      end
      if opStack:IsEmpty() then
        opStack:Push(word)
      elseif word == "(" then
        opStack:Push(word)
      elseif word == ")" then
        this.DirectCalc(opStack, numStack, true)
      else
        this.CompareAndCalc(opStack, numStack, word)
      end
    end
  end
  if 0 < #fullWord then
    numStack:Push(fullWord)
  end
  this.DirectCalc(opStack, numStack, false)
  return tonumber(numStack:Pop())
end

this.AttrStrMap = {
  Energy = function()
    return ViewData.meData.attributeMap[EAttributeType.energy]
  end,
  attackSpeedIncrease = function()
    return ViewData.meData.attributeMap[EAttributeType.attackSpeedCalculateValue]
  end,
  maximumPhysBaseDmg = function()
    return ViewData.meData.attributeMap[EAttributeType.maximumPhysBaseDmg]
  end,
  strength = function()
    return ViewData.meData.attributeMap[EAttributeType.strength]
  end
}

function SkillUtility.ParseSkillDesc(descriptionId)
  if descriptionId == nil then
    return ""
  end
  local attr
  local attrMapValue = QuickFind.LuaMainPlayerData():TryGetAttrValue(EAttributeType.attackSpeedIncrease)
  local attrInit = attrMapValue and (attrMapValue - 10000) / 10000 or 0
  local cfg_Item_tips = ClientTable.cfg_Item_tipsManager:TryGetValue(descriptionId)
  local itemTip = cfg_Item_tips and cfg_Item_tips.content or ""
  local formula = cfg_Item_tips and cfg_Item_tips.formula or ""
  if formula == "" then
    return itemTip
  end
  local formulas = string.split(formula, "#")
  for i = 1, #formulas do
    local formulaStrs = string.split(formulas[i], "$")
    local curFormula = formulaStrs[1]
    local mathF = formulaStrs[2]
    local attrStr = Regex.Matches(curFormula, "[a-zA-Z]+")
    for j = 0, attrStr.Count - 1 do
      if attrStr[j].Value == "attackSpeedIncrease" then
        attr = 1 + attrInit
      else
        attr = this.AttrStrMap[attrStr[j].Value]()
      end
      curFormula = string.replace(curFormula, attrStr[j].Value, attr)
    end
    local res = this.ExecuteExpression(curFormula)
    if mathF == "i" then
      res = Mathf.Floor(res)
    else
      res = Mathf.Round(res * 100)
      res = res / 100
    end
    itemTip = string.replace(itemTip, string.format("[%d]", i), res)
  end
  return itemTip
end

function SkillUtility.IsComboSkill(skillId)
  local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if tblSkill and tblSkill.skillType == ESkillType.Combo then
    return true
  end
  return false
end

function SkillUtility.GetMeComboSkill()
  for i, v in pairs(RoleManager.me.skills) do
    if SkillUtility.IsComboSkill(v.sid) then
      return v.sid
    end
  end
end

function SkillUtility.GetChargingTimes(skillConfig)
  if skillConfig == nil or type(skillConfig) ~= "table" then
    return
  end
  local chargingTimes = skillConfig.chargingTimes
  if skillConfig.connectskill ~= nil and not string.isNullOrEmpty(skillConfig.connectskill) then
    local strengthenSkillGroupIdStr = string.split(skillConfig.connectskill, "#")
    for i, skillGroupId in pairs(strengthenSkillGroupIdStr) do
      if ViewData.meData.skills[tonumber(skillGroupId)] then
        local strengthenSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(ViewData.meData.skills[tonumber(skillGroupId)].sid)
        if strengthenSkillConfig ~= nil and not string.isNullOrEmpty(strengthenSkillConfig.skillGlobal) then
          local strengthenCount = tonumber(string.split(strengthenSkillConfig.skillGlobal, "#")[2])
          chargingTimes = chargingTimes + strengthenCount
        end
      elseif chargingTimes == 1 then
        chargingTimes = 0
      end
    end
  elseif chargingTimes == 1 then
    chargingTimes = 0
  end
  return chargingTimes
end

function SkillUtility.GetCdTime(skillConfig)
  if skillConfig == nil or type(skillConfig) ~= "table" then
    return
  end
  local cdTime = skillConfig.cdTime
  if not string.isNullOrEmpty(skillConfig.skillcdTime) then
    local skillCdTime = tonumber(skillConfig.skillcdTime)
    if ViewData.meData.skills[skillCdTime] then
      local passiveSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(ViewData.meData.skills[skillCdTime].sid)
      if passiveSkillConfig ~= nil and type(passiveSkillConfig) == "table" then
        cdTime = passiveSkillConfig.cdTime
      end
    end
  end
  return cdTime
end

function SkillUtility.GetMainPlayerAttackBtnName()
  local career = RoleUtility.GetBasicCareer(RoleManager.me.career)
  local prefixName = "btn_AttackChange_"
  return prefixName .. tostring(career)
end
