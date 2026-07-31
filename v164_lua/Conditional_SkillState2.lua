Conditional_SkillState2 = class(BaseConditional)
Conditional_SkillState2.name = "Conditional_SkillState2"

function Conditional_SkillState2:CalcTips(tblSkill, tblAction)
  if not ViewData.meData:HasSkill(tblSkill.id) then
    return false
  end
  local cdData = RoleManager.me.cd[tblSkill.groupId]
  local cdEndTime = cdData and cdData.endTime or 0
  local cdTime = SkillUtility.GetCdTime(tblSkill)
  local isCdOver = cdEndTime <= Time.GetServerTime() or cdTime >= tblSkill.publicCD
  return isCdOver, self.name
end
