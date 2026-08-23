RoleSwimIdleState = class(RoleMoveState)

function RoleSwimIdleState:HandleMove()
  self.context:SetSwimPrefix("Swim")
end

function RoleSwimIdleState:ChangeMove()
  self.context:SetSwimPrefix()
end
