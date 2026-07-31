RevealPlayer = class(Player)

function RevealPlayer:ctor(data)
  Player.InitAttribute(self, data)
  Player.InitGameObject(self)
  self:InitPosition()
  Player.InitModel(self)
  Player.InitRotation(self)
  self:SetMoving(ERoleMoveType.Stand)
end

function RevealPlayer:InitModelDisplay()
  self.isShowModel = true
end

function RevealPlayer:InitCell()
  self.cellPos = Vector2Int(0, 0)
end

function RevealPlayer:InitPosition()
  self:InitCell()
  self.moving = false
  self.pos = Vector3(self.data.x, self.data.y, self.data.z)
end

function RevealPlayer:SetMoving(moving)
  if self.RoleMoveType == moving then
    return
  end
  self.RoleMoveType = moving
  self:RefreshAnimation()
  self:SetMoveSpeed(0)
  if self.data.WingData and self.AvatarEquip then
    self.AvatarEquip:SetWingAni(self.RoleMoveType, false)
  end
end

function RevealPlayer:RefreshAnimation(fadeLength)
  local name = self:GetCurrentAnimation()
  local basicSpeed = BasicMoveSpeedConfig[name]
  local speed = basicSpeed and self.tempMoveSpeed / basicSpeed
  self:PlayAnimation(name, speed, fadeLength)
  if self.isMe then
    Scene.PlayStepSoundByMoveName(name)
  end
end

function RevealPlayer:PetReset()
  if self.RolePet then
    self.RolePet:Reset()
  end
end

function RevealPlayer:SetPlayerDeadAnimator()
end

function RevealPlayer:IsCurSafeZone(_)
  if self.data.revealWing then
    return false
  end
  if self.data.rideMount then
    return false
  end
  return true
end

function RevealPlayer:RefreshMount()
  if self:IsCurSafeZone(self.cellPos) then
    self:SetMount(nil)
  elseif self.data.rideMount then
    if self.playerEquipType == ERoleInitEquipType.snowMan then
      self:SetMount(nil)
    else
      self:SetMount(self.data.rideMount.model)
    end
  else
    self:SetMount(nil)
  end
  if self.gameObject and self.Head then
    self.Head:RefreshData(self)
    return
  end
end

function RevealPlayer:Destroy()
  Player.DestroyEquip(self)
  Player.DestroyPet(self)
  Role.Destroy(self)
end
