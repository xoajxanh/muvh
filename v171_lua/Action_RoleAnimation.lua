local playTime
Action_RoleAnimation = class(Action_Base)
Action_RoleAnimation.name = "Action_RoleAnimation"

function Action_RoleAnimation:Init(caster, actionData, speed, skillId)
  if not caster then
    return
  end
  self.base.Init(self, caster, actionData, speed)
  self.skillId = skillId
  local strs = string.split(self.actionData.animation, "#")
  if self.actionData.animationType == ESkillAnimationPlayType.Random then
    self.animationName = Mathf.RandomTableValue(strs)
  elseif self.actionData.animationType == ESkillAnimationPlayType.Sequence then
    local animIndex = SequenceSkillAnimationCounter.GetCounter(self.caster, skillId, #strs)
    self.animationName = strs[animIndex]
  end
  self.animatorSpeed = 1 / self.duration
end

function Action_RoleAnimation:OnStartProcess()
  if not self.caster then
    return
  end
  playTime = Time.time
  self.caster:PlayAnimation(self.animationName, self.animatorSpeed)
end

function Action_RoleAnimation:OnDestroy()
  if not self.caster or not self.caster.model then
    return
  end
  self.caster.model:SetAnimatorSpeed(1)
end
