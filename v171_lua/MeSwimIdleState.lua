MeSwimIdleState = class(MeStandState)

function MeSwimIdleState:HandleMove()
  self.context:SetSwimPrefix("Swim")
  PickupManager.StartCountDown()
  self:StartAutoFightCountDown()
end

function MeSwimIdleState:ChangeMove()
  self.context:SetSwimPrefix()
  PickupManager.StopCountDown()
  self:StopAllTimer()
end
