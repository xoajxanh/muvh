Action_SyncServerPos = class(Action_Base)

function Action_SyncServerPos:OnStartProcess()
  if self.caster then
    self.caster:ChangePos(ERoleMoveType.Stand, ERoleChangePosReason.Flash)
    EventManager.Dispatch(Event.Role_PlayerChangePos, self.caster.id, ERoleChangePosReason.Flash)
  end
end
