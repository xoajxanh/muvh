Conditional_SkillRange = class(BaseConditional)
Conditional_SkillRange.name = "Conditional_SkillRange"

function Conditional_SkillRange:Calc(tblSkill, tblAction)
  if tblAction.needTarget and tblAction.needTarget == 0 then
    if SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
      return true
    end
    if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
      local targetCell = RoleManager.me.TargetAvatar.serverCoord
      local meCell = RoleManager.me.serverCoord
      local range = Mathf.Max(Mathf.Abs(targetCell.x - meCell.x), Mathf.Abs(targetCell.y - meCell.y))
      local serverInRange = range <= gameMgr:GetAvatarManager():GetMainPlayer():GetSkillManager():GetSKillGroupAdditionManager():GetSkillAfterAdditionValue(tblSkill.id, ESkillGroupAdditionType.RANGE)
      return serverInRange
    else
      return false
    end
  end
  return true
end

function Conditional_SkillRange:CalcTips(tblSkill, tblAction)
  if tblAction.needTarget and tblAction.needTarget == 0 then
    if (not RoleManager.me.TargetAvatar or RoleManager.me.TargetAvatar.isDead) and SkillUtility.IsDontNeedTargetSkill(tblSkill.id) then
      return true
    end
    if RoleManager.me.TargetAvatar and not RoleManager.me.TargetAvatar.isDead then
      local targetCell = RoleManager.me.TargetAvatar.serverCoord
      local meCell = RoleManager.me.serverCoord
      local range = Mathf.Max(Mathf.Abs(targetCell.x - meCell.x), Mathf.Abs(targetCell.y - meCell.y))
      local serverInRange = range <= tblSkill.releaseDistance
      return serverInRange
    else
      FloatingTipUtility.QuickMsg("K\225\187\185 n\196\131ng n\195\160y c\225\186\167n c\195\179 m\225\187\165c ti\195\170u \196\145\225\187\131 s\225\187\173 d\225\187\165ng")
      return false
    end
  end
  return true
end
