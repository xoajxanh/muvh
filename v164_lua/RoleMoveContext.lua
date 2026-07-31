require("GamePlay/Role/RoleMoveState/RoleMoveState")
require("GamePlay/Role/RoleMoveState/RoleRunState")
require("GamePlay/Role/RoleMoveState/RoleWalkState")
require("GamePlay/Role/RoleMoveState/RoleStandState")
require("GamePlay/Role/RoleMoveState/RoleSwimIdleState")
require("GamePlay/Role/RoleMoveState/RoleSwimState")
require("GamePlay/Role/RoleMoveState/RoleFastSwimState")
RoleMoveContext = class()

function RoleMoveContext:ctor(avatar)
  self.currentState = nil
  self.moveType = {}
  self.avatar = avatar
  self:InitState()
  self:InitRegistEvents()
end

function RoleMoveContext:InitState()
  self:InitRunState()
  self:InitWalkState()
  self:InitStandState()
  self:InitSwimIdleState()
  self:InitSwimState()
  self:InitFastSwimState()
end

function RoleMoveContext:InitRegistEvents()
  self.eventContainer = EventContainer(EventManager)
end

function RoleMoveContext:InitRunState()
  local runState = RoleRunState(ERoleMoveType.Run, self)
  self.moveType[ERoleMoveType.Run] = runState
end

function RoleMoveContext:InitWalkState()
  local walkState = RoleWalkState(ERoleMoveType.Walk, self)
  self.moveType[ERoleMoveType.Walk] = walkState
end

function RoleMoveContext:InitStandState()
  local standState = RoleStandState(ERoleMoveType.Stand, self)
  self.moveType[ERoleMoveType.Stand] = standState
end

function RoleMoveContext:InitSwimIdleState()
  local swimIdle = RoleSwimIdleState(ERoleMoveType.SwimIdle, self)
  self.moveType[ERoleMoveType.SwimIdle] = swimIdle
end

function RoleMoveContext:SetSwimPrefix(name)
  if self.avatar.model and self.avatar.model.animator then
    self.avatar.model.animator:SetSwimPrefix(name)
  end
end

function RoleMoveContext:InitSwimState()
  local swimState = RoleSwimState(ERoleMoveType.Swim, self)
  self.moveType[ERoleMoveType.Swim] = swimState
end

function RoleMoveContext:InitFastSwimState()
  local fastSwimState = RoleFastSwimState(ERoleMoveType.FastSwim, self)
  self.moveType[ERoleMoveType.FastSwim] = fastSwimState
end

function RoleMoveContext:SetMoveState(moveType)
  self.currentState = self.moveType[moveType]
end

function RoleMoveContext:Handle()
  self.currentState:HandleMove()
end

function RoleMoveContext:GetCurrentState()
  return self.currentState:GetMovingType()
end

function RoleMoveContext:ExitCurrentState()
  if not self.currentState then
    return
  end
  self.currentState:ChangeMove()
end

function RoleMoveContext:Destroy()
  if self.eventContainer then
    self.eventContainer:UnRegistAll()
  end
  if self.currentState then
    self.currentState:Destroy()
    self.currentState = nil
  end
end
