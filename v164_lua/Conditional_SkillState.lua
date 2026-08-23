Conditional_SkillState = class(BaseConditional)
Conditional_SkillState.name = "Conditional_SkillState"

function Conditional_SkillState:Calc(tblSkill, tblAction)
  if tblSkill.skillType == ESkillType.Child then
    return true
  end
  local cdData = RoleManager.me.cd[tblSkill.groupId]
  local cdEndTime = cdData and cdData.endTime or 0
  local publicCdData = RoleManager.me.cd[1]
  local publicCdEndTime = publicCdData and publicCdData.endTime or 0
  local isCdOver = cdEndTime <= Time.GetServerTime() and publicCdEndTime <= Time.GetServerTime()
  return isCdOver, self.name
end

function Conditional_SkillState:CalcTips(tblSkill, tblAction)
  if tblSkill.skillType == ESkillType.Child then
    return true
  end
  local cdData = RoleManager.me.cd[tblSkill.groupId]
  local cdEndTime = cdData and cdData.endTime or 0
  local publicCdData = RoleManager.me.cd[1]
  local publicCdEndTime = publicCdData and publicCdData.endTime or 0
  local isCdOver = cdEndTime <= Time.GetServerTime() and publicCdEndTime <= Time.GetServerTime()
  return isCdOver, self.name
end
