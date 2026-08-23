RoleFastSwimState = class(RoleMoveState)

function RoleFastSwimState:HandleMove()
  self.context:SetSwimPrefix("Swim")
end

function RoleFastSwimState:ChangeMove()
  self.context:SetSwimPrefix()
end
