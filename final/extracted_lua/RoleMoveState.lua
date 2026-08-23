RoleMoveState = class()

function RoleMoveState:ctor(moveType, context)
  self.context = context
  self:SetMovingType(moveType)
end

function RoleMoveState:SetMovingType(moveType)
  self.moveType = moveType
end

function RoleMoveState:GetMovingType()
  return self.moveType
end

function RoleMoveState:HandleMove()
end

function RoleMoveState:ChangeMove()
end

function RoleMoveState:Destroy()
end
