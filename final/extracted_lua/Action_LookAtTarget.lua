Action_LookAtTarget = class(Action_Base)

function Action_LookAtTarget:Init(caster, targetId, actionData, speed)
  self.base.Init(self, caster, actionData, speed)
  self.targetId = targetId
  self.keepLooking = self.actionData.keepLooking
end

function Action_LookAtTarget:OnStartProcess()
  if self.caster then
    self.caster:LookAtTarget(self.targetId)
  end
end

function Action_LookAtTarget:OnProcessing()
  if self.keepLooking and self.caster then
    self.caster:LookAtTarget(self.targetId)
  end
end
