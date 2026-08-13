SkillCondition = class(ConditionBase)
setgetters(SkillCondition, {})
SkillCondition.comparatorMap = {
  [1] = function(self)
    local skillId = tonumber(self.id)
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    if cfg_skill == nil then
      return false
    end
    local playerSkill = RoleManager.me.skills[cfg_skill.groupId]
    if cfg_skill.exp and cfg_skill.exp > 0 and cfg_skill.exp == playerSkill.exp then
      return true
    end
    return false
  end,
  [2] = function(self)
    local skillId = tonumber(self.id)
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    if cfg_skill == nil then
      return false
    end
    local playerSkill = RoleManager.me.skills[cfg_skill.groupId]
    return playerSkill and true or false
  end,
  [3] = function(self)
    local skillId = tonumber(self.id)
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    if cfg_skill == nil then
      return false
    end
    local playerSkill = RoleManager.me.skills[cfg_skill.groupId]
    return playerSkill and playerSkill.level == cfg_skill.level
  end
}

function SkillCondition:InitParam(param)
  self.id = tonumber(param)
end
