Conditional_RoleState = class(BaseConditional)
Conditional_RoleState.name = "Conditional_RoleState"

function Conditional_RoleState:GetMpConsume(tblSkill)
  local costMp = tblSkill.costMP
  local costMpPercent = Mathf.Floor(tblSkill.costMPPercentage / 10000 * RoleManager.me.maxMp)
  return costMpPercent + costMp
end

function Conditional_RoleState:Calc(tblSkill, tblAction)
  if RoleManager.me.isDead then
    return false
  end
  if not RoleManager.me:CanUseSkill() and not SkillUtility.IsComboSkill(tblSkill.id) then
    return false
  end
  if tblSkill.buildBuff ~= 0 then
    local buff = BuffData.GetBuff(RoleManager.me.id, tblSkill.buildBuff)
    if tblAction.previousSkill == 0 and buff ~= nil or tblAction.previousSkill ~= 0 and buff == nil then
      return false
    end
  end
  if self:GetMpConsume(tblSkill) > RoleManager.me.mp then
    return false
  end
  return true
end

function Conditional_RoleState:CalcTips(tblSkill, tblAction)
  if RoleManager.me.isDead then
    FloatingTipUtility.QuickMsg("Nh\195\162n v\225\186\173t \196\145\195\163 t\225\187\173 vong, kh\195\180ng th\225\187\131 d\195\185ng k\225\187\185 n\196\131ng")
    return false
  end
  if tblSkill.buildBuff ~= 0 then
    local buff = BuffData.GetBuff(RoleManager.me.id, tblSkill.buildBuff)
    if tblAction.previousSkill == 0 and buff ~= nil or tblAction.previousSkill ~= 0 and buff == nil then
      FloatingTipUtility.QuickMsg("K\225\187\185 n\196\131ng n\195\160y c\225\186\167n k\225\187\185 n\196\131ng ti\225\187\129n \196\145\225\187\129 m\225\187\155i c\195\179 th\225\187\131 s\225\187\173 d\225\187\165ng")
      return false
    end
  end
  if self:GetMpConsume(tblSkill) > RoleManager.me.mp then
    FloatingTipUtility.QuickMsg("Kh\195\180ng \196\145\225\187\167 MP")
    return false
  else
  end
  return true
end
