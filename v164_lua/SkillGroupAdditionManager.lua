local SkillGroupAdditionManager = {}
SkillGroupAdditionManager.serverData = nil
SkillGroupAdditionManager.skillGroupAdditionDic = nil

function SkillGroupAdditionManager:RefreshData(serverData)
  if self:AnalysisParam(serverData) == false then
    return
  end
  self:RefreshSkillGroupAdditionDic()
end

function SkillGroupAdditionManager:AnalysisParam(serverData)
  self.serverData = serverData
  self.skillGroupAdditionDic = {}
  return serverData ~= nil and serverData.skillSpecialEffect ~= nil and #serverData.skillSpecialEffect > 0
end

function SkillGroupAdditionManager:RefreshSkillGroupAdditionDic()
  for k, v in pairs(self.serverData.skillSpecialEffect) do
    local skillGroupAdditionInfoList = self.skillGroupAdditionDic[v.skillGroupId]
    if skillGroupAdditionInfoList == nil then
      self.skillGroupAdditionDic[v.skillGroupId] = {}
      skillGroupAdditionInfoList = self.skillGroupAdditionDic[v.skillGroupId]
    end
    for k1, serverAdditionData in pairs(v.specialEffect) do
      skillGroupAdditionInfoList[serverAdditionData.type] = serverAdditionData.value
    end
  end
end

function SkillGroupAdditionManager:GetSkillAfterAdditionValue(skillId, additionType)
  local skillTbl = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if skillTbl == nil then
    return 0
  end
  local buffDecrease = self:CheckBuffAttackRange()
  if buffDecrease ~= 0 then
    return buffDecrease
  end
  return self:GetSkillBaseValue(skillTbl, additionType) + self:GetSkillAdditionValue(skillTbl.groupId, additionType)
end

function SkillGroupAdditionManager:CheckBuffAttackRange()
  if not self.BuffRange then
    self.BuffRange = {}
    local buffList = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2800025)
    local buff = string.split(buffList, "#")
    for i, v in pairs(buff) do
      local buffInfo = ClientTable.cfg_Buff_buffManager:BaseGetTabListByType(tonumber(v), "buffGroup")
      for m, n in pairs(buffInfo) do
        if n.subType == 146 and not string.isNullOrEmpty(n.buffParam) then
          self.BuffRange[n.id] = tonumber(n.buffParam)
        end
      end
    end
  end
  local decrease = {}
  if table.count(self.BuffRange) > 0 then
    for i, v in pairs(self.BuffRange) do
      local hasBuff = BuffData.IsHasBuff(RoleManager.me.id, i)
      if hasBuff then
        table.insert(decrease, v)
      end
    end
    table.sort(decrease)
  end
  return decrease[1] and decrease[1] or 0
end

function SkillGroupAdditionManager:GetSkillBaseValue(skillTbl, additionType)
  if skillTbl == nil or additionType == nil then
    return 0
  end
  if additionType == ESkillGroupAdditionType.RANGE then
    return skillTbl.releaseDistance
  end
end

function SkillGroupAdditionManager:GetSkillAdditionValueFormId(skillId, additionType)
  local skillTbl = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if skillTbl == nil then
    return 0
  end
  return self:GetSkillAdditionValue(skillTbl.groupId, additionType)
end

function SkillGroupAdditionManager:GetSkillAdditionValue(groupId, additionType)
  if self.skillGroupAdditionDic == nil or type(groupId) ~= "number" or type(additionType) ~= "number" then
    return 0
  end
  local value = self.skillGroupAdditionDic[groupId] and self.skillGroupAdditionDic[groupId][additionType]
  return value or 0
end

return SkillGroupAdditionManager
