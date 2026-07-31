Conditional_Target = class(BaseConditional)
Conditional_Target.name = "targetCondition"

function Conditional_Target:Calc(tblSkill, tblAction)
  if tblAction.needTarget and tblAction.needTarget == 0 then
    if SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
      return true
    else
      return RoleUtility.IsCanAttackPlayer(RoleManager.me.TargetAvatar)
    end
  else
    return true
  end
  return false
end

function Conditional_Target:CalcTips(tblSkill, tblAction)
  if tblAction.needTarget and tblAction.needTarget == 0 then
    if SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
      return true
    end
    return RoleUtility.IsCanAttackPlayerTips()
  else
    return true
  end
  FloatingTipUtility.QuickMsg("K\225\187\185 n\196\131ng n\195\160y c\225\186\167n c\195\179 m\225\187\165c ti\195\170u \196\145\225\187\131 s\225\187\173 d\225\187\165ng")
  return false
end
