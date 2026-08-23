RoleBuffData = class()

function RoleBuffData:ctor()
  self.roleState = RoleBuffState.None
end

function RoleBuffData:AddState(state)
  self.roleState = self.roleState | state
end

function RoleBuffData:RemoveState(state)
  self.roleState = self.roleState & ~state
end

function RoleBuffData:CheckState(state)
  return self.roleState & state ~= 0
end

function RoleBuffData:Reset()
  self.roleState = RoleBuffState.None
end
