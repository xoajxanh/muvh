SkillAttributeCalculator = {}
local this = SkillAttributeCalculator

function SkillAttributeCalculator.CalcSkillAttributes(skills)
  local fightValue = 0
  local attr = {}
  for k, v in pairs(skills) do
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    fightValue = fightValue + cfg_skill.fight
  end
  attr.fight = fightValue
  local attrSumMap = AttributeConfig.GetTableAttributes(attr)
  return attrSumMap
end
