Action_SkillOver = class(Action_Base)

function Action_SkillOver:Init(caster, actionData, speed, skillId)
  self.base.Init(self, caster, actionData, speed)
  self.skillId = skillId
  if self.caster then
    self.caster:SetUsingSkill(self.skillId)
  end
end

function Action_SkillOver:OnStartProcess()
  if self.caster then
    self.caster:SetUsingSkill(nil)
  end
end

function Action_SkillOver:OnBreak()
  if self.caster then
    self.caster:SetUsingSkill(nil)
  end
end
