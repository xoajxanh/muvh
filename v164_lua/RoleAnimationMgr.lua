RoleAnimationMgr = {}
local this = RoleAnimationMgr
RoleAnimationMgr.RoleAnimationAction = {}

function RoleAnimationMgr.Init()
end

function RoleAnimationMgr.Update()
  for k, v in pairs(this.RoleAnimationAction) do
  end
end

function RoleAnimationMgr.PlayActionAnimation(action)
  local strs = string.split(action.tblAction.animation, "#")
  local animationName = ""
  if action.animationType == ESkillAnimationPlayType.Random then
    if strs == nil or #strs == 0 then
      animationName = ""
    else
      animationName = Mathf.RandomTableValue(strs)
    end
  end
  if action.animationType == ESkillAnimationPlayType.Combo then
    if strs == nil or #strs == 0 then
      animationName = ""
    else
      if SkillData.commonAttackCombo > #strs then
        animationName = strs[SkillData.commonAttackCombo]
      end
      SkillData.commonAttackCombo = SkillData.commonAttackCombo + 1
    end
  end
  if action.role ~= nil then
    local duration = action.tblAction.duration / action.attackSpeed
    if duration <= 0 then
      duration = 0.1
    end
    local animSpeed = 1 / duration
    action.role:PlayAnimation(animationName, animSpeed)
  end
end

function RoleAnimationMgr.PlayAction(role, tblAction, tblSkill, tblWeapon, attackSpeed)
  if tblAction == nil or tblSkill == nil then
    return
  end
  local roleAction = {}
  roleAction.role = role
  roleAction.tblAction = tblAction
  roleAction.tblSkill = tblSkill
  roleAction.tblWeapon = tblWeapon
  roleAction.attackSpeed = attackSpeed
  roleAction.animationType = tblAction.animationType
  this.PlayActionAnimation(roleAction)
end

function RoleAnimationMgr.SetRoleMount()
end

function RoleAnimationMgr.Destroy(rid)
end
