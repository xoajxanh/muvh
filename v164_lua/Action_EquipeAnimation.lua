Action_EquipeAnimation = class(Action_Base)
local Animator = CS.UnityEngine.Animator

function Action_EquipeAnimation:Init(caster, actData, speed)
  self.base.Init(self, caster, actData, speed)
  self.equipeIndex = actData.equipePosition
  self.animNameHash = Animator.StringToHash(actData.animation)
  self.playTimes = actData.playTimes
  if self.playTimes <= 0 then
    self.playTimes = 1
  end
  if self.caster then
    local equipeGo = self.caster.AvatarEquip:GetEquipeGoByIndedx(self.equipeIndex)
    if equipeGo then
      self.animator = equipeGo:GetComponent(typeof(Animator))
      if self.animator then
        local singleAnimTime = self.duration / self.playTimes
        self.animatorSpeed = 1 / singleAnimTime
      end
    end
  end
end

function Action_EquipeAnimation:OnStartProcess()
  if self.animator then
    self.animator:SetBool(self.animNameHash, true)
    self.animator.speed = self.animatorSpeed
  end
end

function Action_EquipeAnimation:OnFinish()
  if self.animator then
    self.animator:SetBool(self.animNameHash, false)
    self.animator.speed = 1
  end
end

function Action_EquipeAnimation:OnInterrupted()
  if self.animator then
    self.animator:SetBool(self.animNameHash, false)
    self.animator.speed = 1
  end
end

function Action_EquipeAnimation:OnBreak()
  if self.animator then
    self.animator:SetBool(self.animNameHash, false)
    self.animator.speed = 1
  end
end
