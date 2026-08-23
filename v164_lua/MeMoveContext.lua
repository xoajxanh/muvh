require("GamePlay/Role/RoleMoveState/MeStandState")
require("GamePlay/Role/RoleMoveState/MeSwimIdleState")
MeMoveContext = class(RoleMoveContext)

function MeMoveContext:InitStandState()
  local standState = MeStandState(ERoleMoveType.Stand, self)
  self.moveType[ERoleMoveType.Stand] = standState
end

function MeMoveContext:InitSwimIdleState()
  local standState = MeSwimIdleState(ERoleMoveType.SwimIdle, self)
  self.moveType[ERoleMoveType.SwimIdle] = standState
end

function MeMoveContext:InitRegistEvents()
  self.base.InitRegistEvents(self)
  self.eventContainer:Regist(Event.Role_StopAutoFight, self.StopAutoFight, self)
  self.eventContainer:Regist(Event.Role_RefreshAutoFight, self.RefreshAutoFight, self)
  self.eventContainer:Regist(Event.Me_Dead, self.StopAutoFight, self)
  self.eventContainer:Regist(Event.Map_ChangeMap, self.RefreshAutoFight, self)
  self.eventContainer:Regist(Event.Scene_SceneLoaded, self.RefreshAutoFight, self, 3)
end

function MeMoveContext:RefreshAutoFight()
  if not self.currentState then
    return
  end
  if self.currentState:GetMovingType() == ERoleMoveType.Stand or self.currentState:GetMovingType() == ERoleMoveType.SwimIdle then
    self.currentState:RefreshAutoFightCountDown()
  end
end

function MeMoveContext:StopAutoFight()
  if not self.currentState then
    return
  end
  if self.currentState:GetMovingType() == ERoleMoveType.Stand or self.currentState:GetMovingType() == ERoleMoveType.SwimIdle then
    self.currentState:StopAutoFightCountDown()
  end
end

function MeMoveContext:SetMoveState(moveType)
  self.currentState = self.moveType[moveType]
end

function MeMoveContext:Destroy()
  if self.eventContainer then
    self.eventContainer:UnRegistAll()
  end
  if self.currentState then
    self.currentState:Destroy()
    self.currentState = nil
  end
end
