RoleSwimState = class(RoleMoveState)

function RoleSwimState:HandleMove()
  self.context:SetSwimPrefix("Swim")
end

function RoleSwimState:ChangeMove()
  self.context:SetSwimPrefix()
end
