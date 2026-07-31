Pet = class(Role)
local mAroundRadius = 0.5
local mAngularSpeed = 100
local changeFollowDis = 1.4
local defaultScale = 0.35
local distance
local Inittimer = 0
local index = 1
local configDistance = 1
local PetFellowDistance = {
  [ERolePetType.deer] = {Max = 1.5, Min = 0.5},
  [ERolePetType.angle] = {Max = 3, Min = 0.5},
  [ERolePetType.imp] = {Max = 0, Min = 0},
  [ERolePetType.intensifyImp] = {Max = 1, Min = 0.5},
  [ERolePetType.intensifyAngle] = {Max = 1, Min = 0.5},
  [ERolePetType.xiongMao] = {Max = 1.5, Min = 1}
}
local PetFellowHight = {
  [ERolePetType.deer] = {x = 0, y = 0},
  [ERolePetType.angle] = {x = 0, y = 2},
  [ERolePetType.intensifyImp] = {x = 0, y = 2},
  [ERolePetType.intensifyAngle] = {x = 0, y = 2},
  [ERolePetType.imp] = {x = 0.5, y = 1.5},
  [ERolePetType.xiongMao] = {x = 0, y = 0}
}
local Helper01StandPoints = {
  {
    Vector3(1.5, -2, 0),
    Vector3(2, 0, 1),
    Vector3(1.5, 0, 1.52),
    Vector3(0.58, -1, 1.87),
    Vector3(-0.36, -0.5, 1.87),
    Vector3(-1.23, -2, 1.43),
    Vector3(-1.39, 0, 0.46),
    Vector3(-1.26, 0.5, -0.19),
    Vector3(-0.37, 0, -0.88),
    Vector3(0.63, -0.5, -0.88),
    Vector3(1.77, 1, -0.15),
    Vector3(1.71, -1.5, 0.61),
    Vector3(0.88, -1.5, 1.15),
    Vector3(-0.02, -1, 1.31),
    Vector3(-0.98, -0.5, 0.91),
    Vector3(-1.78, -2, -0.04),
    Vector3(-1.14, 0, -1.26),
    Vector3(0.17, 0, -1.82),
    Vector3(1.17, -2, -1.82),
    Vector3(1.99, 1, -1.06)
  },
  {
    Vector3(2, -2, 0),
    Vector3(1.8, 0, 0.92),
    Vector3(1.16, 0, 1.44),
    Vector3(0.14, -1, 1.44),
    Vector3(-1.01, -0.5, 1.15),
    Vector3(-0.64, -2, 0.07),
    Vector3(-1.68, 0, -0.57),
    Vector3(-0.56, 0.5, -1.42),
    Vector3(0.44, 0, -1.42),
    Vector3(0.78, -0.5, -0.39),
    Vector3(2.01, 1, -0.39),
    Vector3(1.01, -1.5, -0.39),
    Vector3(1.91, -1.5, 0.46),
    Vector3(1.48, -1, 1.38),
    Vector3(0.69, -0.5, 0.84),
    Vector3(0.04, -2, 1.58),
    Vector3(-0.8, 0, 1.58),
    Vector3(-0.1, 0, 0.53),
    Vector3(-1.32, -2, 0.26),
    Vector3(-1, 1, -1)
  },
  {
    Vector3(-1, -2, -1),
    Vector3(0, 0, -1),
    Vector3(1, 0, -1),
    Vector3(2, -1, -1),
    Vector3(1.69, -0.5, 0.52),
    Vector3(1.12, -2, 0.65),
    Vector3(0.38, 0, 0.5),
    Vector3(-0.4, 0.5, 0.83),
    Vector3(-1.08, 0, 1.67),
    Vector3(-1.74, -0.5, 1.07),
    Vector3(-0.42, 1, -0.6),
    Vector3(1.13, -1.5, -0.73),
    Vector3(1.72, -1.5, 1.69),
    Vector3(0.14, -1, 1.69),
    Vector3(-1.04, -0.5, 0.46),
    Vector3(-0.63, -2, -1.19),
    Vector3(1.07, 0, -1.53),
    Vector3(1.9, 0, -0.61),
    Vector3(1.5, -2, 0),
    Vector3(2, 1, 0)
  },
  {
    Vector3(1.5, -2, 0),
    Vector3(2, 0, 0.96),
    Vector3(1.36, 0, 1.55),
    Vector3(0.5, -1, 1.66),
    Vector3(-0.24, -0.5, 1.02),
    Vector3(1.28, -2, 0.39),
    Vector3(1.34, 0, 0.39),
    Vector3(-1.36, 0.5, 0.39),
    Vector3(-0.59, 0, -0.82),
    Vector3(0.28, -0.5, -1.35),
    Vector3(1.54, 1, -0.82),
    Vector3(1.93, -1.5, 0.56),
    Vector3(-0.13, -1.5, 1.68),
    Vector3(-0.79, -1, 1.07),
    Vector3(-0.73, -0.5, -0.22),
    Vector3(0.12, -2, -0.76),
    Vector3(1.22, 0, -0.76),
    Vector3(1.16, 0, 1.48),
    Vector3(-0.81, -2, 1.48),
    Vector3(-0.14, 1, 0.73)
  },
  {
    Vector3(2, -2, 1),
    Vector3(1.21, 0, 1),
    Vector3(0.44, 0, 0.64),
    Vector3(1.2, -1, -0.19),
    Vector3(0.82, -0.5, -0.66),
    Vector3(1.82, -2, -0.66),
    Vector3(0.61, 0, -1.84),
    Vector3(-0.95, 0.5, -1.84),
    Vector3(-1.29, 0, -1.11),
    Vector3(-0.49, -0.5, -0.6),
    Vector3(0.51, 1, -0.6),
    Vector3(1.54, -1.5, -1.92),
    Vector3(-0.43, -1.5, -1.27),
    Vector3(-1.14, -1, -0.69),
    Vector3(-1.58, -0.5, 0.45),
    Vector3(-0.51, -2, 1.1),
    Vector3(0.49, 0, 1.1),
    Vector3(1.28, 0, 0.41),
    Vector3(1.67, -2, -1.28),
    Vector3(0.01, 1, -1.28)
  }
}
setgetters(Pet, {
  unionId = function(self)
    return self.player.unionId
  end,
  RoleType = function(self)
    return ERoleType.Pet
  end
})

function Pet:ctor(data, Player)
  self.CirclePointsTab = nil
  self.player = Player
  Role.ctor(self, data)
end

function Pet:InitAttribute(data)
  self.data = data
  self.data.modelType = EModelType.Pet
  self.data.model = data.tblItem.model
  self.PetStatus = ERolePetStatus.Follow
  self.petType = self.data.tblEquip.guardType
  print("lyc", self.petType)
  self.data.serverCoord = self.player.cellPos:Clone()
  self.data.x = self.player.cellPos.x
  self.data.y = self.player.cellPos.y
  self.CenterPointm = self.player:GetPosition()
  self.tempMoveSpeed = self.player.tempMoveSpeed
  self.petPoseTbl = ClientTable.cfg_Item_pet_poseManager:TryGetValue(self.data.tblEquip.id)
end

function Pet:InitQuality()
  self.graphicType = GameGraphicModelType.Pet
  self.graphicQuality = GameGraphicData.GetQualityLevel(isMe, self.graphicType)
  GameGraphicData.AddCount(self.graphicType, self.graphicQuality)
end

function Pet:GetName()
  return "Pet"
end

function Pet:GetModelScale()
  return defaultScale
end

function Pet:GetParent()
  local this = Pet
  if not this.petAnchor then
    this.petAnchor = CS.UnityEngine.GameObject("PetRoot").transform
    this.petAnchor:SetParent(RoleManager.root)
  end
  return this.petAnchor
end

function Pet:SetPosition(x, y, z)
  x = self.player:GetPosition().x
  y = self.player:GetPosition().y
  z = self.player:GetPosition().z
  y = y + PetFellowHight[self.petType].y
  x = x + PetFellowHight[self.petType].x
  Role.SetPosition(self, x, y, z)
end

function Pet:Reset()
  self.PathPoint = nil
  self.targetPosPet = nil
  self.data.x = self.player.cellPos.x
  self.data.y = self.player.cellPos.y
  self.CenterPointm = self.player:GetPosition()
  self.tempMoveSpeed = self.player.tempMoveSpeed
  self:InitPosition()
end

function Pet:Update()
  Role.Update(self)
  if not self.player or Vector3.EqualsValue(self.player:GetPosition(), 0, 0, 0) then
    return
  end
  self.playerPos = self.player:GetPosition()
  self.playerRota = self.player:GetRotation()
  local disX = self.playerPos.x - self:GetPosition().x
  local disY = self.playerPos.z - self:GetPosition().z
  distance = Mathf.Sqrt(disX * disX + disY * disY)
  self:UpdatePetStatus()
  self:UpdatePetAnimation()
  self:UpdatePetMove()
end

function Pet:UpdatePetStatus()
  if self.petPoseTbl ~= nil then
    self:UpdatePetStatusConfig()
  elseif self.petType == ERolePetType.deer or self.petType == ERolePetType.xiongMao then
    self:UpdatePetStatusHorse()
  elseif self.petType == ERolePetType.intensifyImp then
    self:UpdatePetStatusDemon()
  elseif self.petType == ERolePetType.angle then
    self:UpdatePetStatusHelper01()
  elseif self.petType == ERolePetType.imp then
  elseif self.petType == ERolePetType.intensifyAngle then
    self:UpdatePetStatusMaria()
  end
end

function Pet:UpdatePetStatusHorse()
  if distance <= PetFellowDistance[self.petType].Min and self.player.RoleMoveType == ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Stand then
    self.PetStatus = ERolePetStatus.Stand
    self.CenterPointm = Vector3(self.playerPos.x, self.playerPos.y, self.playerPos.z)
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    if self.angled then
      self.angled = self.angled
    end
  elseif self.player.RoleMoveType ~= ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Follow then
    local playerPos = self:GetPetNewYPos(self.playerPos)
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    self.PetStatus = ERolePetStatus.Follow
    self.tempMoveSpeed = self.player.tempMoveSpeed - 1
  end
end

function Pet:UpdatePetStatusConfig()
  if self.player.usingSkillId ~= nil and self.player.usingSkillId > 0 then
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    self.PetStatus = ERolePetStatus.Attack
  elseif distance - configDistance <= 0.001 and self.player.RoleMoveType == ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Stand then
    self.PetStatus = ERolePetStatus.Stand
    self.CenterPointm = Vector3(self.playerPos.x, self.playerPos.y, self.playerPos.z)
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    if self.angled then
      self.angled = self.angled
    end
  elseif 0.001 < distance - configDistance or self.player.RoleMoveType ~= ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Follow then
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    self.PetStatus = ERolePetStatus.Follow
    self.tempMoveSpeed = self.player.tempMoveSpeed - 1
  end
end

function Pet:UpdatePetStatusDemon()
  if distance <= PetFellowDistance[self.petType].Min and self.player.RoleMoveType == ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Stand then
    self.PetStatus = ERolePetStatus.Stand
    self.MoveTrack = true
  elseif distance > PetFellowDistance[self.petType].Max and self.PetStatus ~= ERolePetStatus.Follow then
    local playerPos = self:GetPetNewYPos(self.playerPos)
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    self.PathPoint = self:GetCirclePoints(self:GetPosition(), playerPos, 9)
    index = 1
    self.PetStatus = ERolePetStatus.Follow
    self.tempMoveSpeed = self.player.tempMoveSpeed - 1
  end
end

function Pet:UpdatePetStatusHelper01()
  if distance <= PetFellowDistance[self.petType].Min and self.player.RoleMoveType == ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Stand then
    self.PetStatus = ERolePetStatus.Stand
    self.PathPoint = table.DeepCopy(Helper01StandPoints[math.random(5)])
  elseif distance > PetFellowDistance[self.petType].Max and self.PetStatus ~= ERolePetStatus.Follow then
    self.PetStatus = ERolePetStatus.Follow
  end
end

function Pet:UpdatePetStatusMaria()
  if distance <= PetFellowDistance[self.petType].Min and self.player.RoleMoveType == ERoleMoveType.Stand and self.PetStatus ~= ERolePetStatus.Stand then
    self.PetStatus = ERolePetStatus.Stand
    self.MoveTrack = true
  elseif distance > PetFellowDistance[self.petType].Max and self.PetStatus ~= ERolePetStatus.Follow then
    local playerPos = self:GetPetNewYPos(self.playerPos)
    self.angled = Vector3.AngleBetween(self:GetPosition(), self.playerPos)
    self.PathPoint = self:GetCirclePoints(self:GetPosition(), playerPos, 9)
    index = 1
    self.PetStatus = ERolePetStatus.Follow
    self.tempMoveSpeed = self.player.tempMoveSpeed - 1
  end
end

function Pet:RefreshAnimation()
  self:PlayAnimation("stand")
end

function Pet:UpdatePetAnimation()
  if self.cacheAnimationStatus == nil or self.cacheAnimationStatus ~= self.PetStatus then
    self.cacheAnimationStatus = self.PetStatus
    self:PlayAnimation(self:GetAnimationName(self.cacheAnimationStatus))
  end
end

function Pet:GetAnimationName(status)
  if self.petPoseTbl == nil then
    return "run"
  end
  if status == ERolePetStatus.Stand then
    return "stand"
  elseif status == ERolePetStatus.Follow then
    return "run"
  elseif status == ERolePetStatus.Attack then
    return "attack"
  end
end

local normalPlayerPos = Vector3.zero
local offsetSpeed = 0

function Pet:UpdatePetMove()
  if self.PathPoint and table.count(self.PathPoint) > 0 then
    if self.petType ~= ERolePetType.angle then
      self:UpdateFixedPathMove(self.PathPoint, normalPlayerPos, self.player.tempMoveSpeed)
    else
      self:UpdateFixedPathMove(self.PathPoint, nil, self.player.tempMoveSpeed)
    end
    return
  end
  if self.petPoseTbl ~= nil then
    self:UpdatePetCustom()
  elseif self.petType == ERolePetType.deer or self.petType == ERolePetType.xiongMao then
    self:UpdatePetHorse()
  elseif self.petType == ERolePetType.intensifyImp then
    self:UpdatePetDemon()
  elseif self.petType == ERolePetType.angle then
    self:UpdatePetHelper01()
  elseif self.petType == ERolePetType.imp then
    self:UpdatePetHelper02()
  elseif self.petType == ERolePetType.intensifyAngle then
    self:UpdatePetMaria()
  end
end

local addRatio = 0.67
local reduceRatio = 0.5

function Pet:UpdatePetHorse()
  if self.PetStatus == ERolePetStatus.Stand then
    self:CircularMotion(self.CenterPointm, mAroundRadius, mAngularSpeed)
  elseif self.PetStatus == ERolePetStatus.Follow then
    offsetSpeed = math.abs(self.player.tempMoveSpeed - self.tempMoveSpeed)
    if 2 <= distance and self.tempMoveSpeed < self.player.tempMoveSpeed then
      self.tempMoveSpeed = self.tempMoveSpeed + addRatio * offsetSpeed
    elseif distance < 2 and self.tempMoveSpeed > self.player.tempMoveSpeed then
      self.tempMoveSpeed = self.tempMoveSpeed - reduceRatio * offsetSpeed
    end
    self:PetFellowHorse()
  end
end

function Pet:UpdatePetCustom()
  if self.PetStatus == ERolePetStatus.Stand then
    if self.petPoseTbl.standPoseType == PetStandType.standLeft or self.petPoseTbl.standPoseType == PetStandType.standRight then
      self:StandSide(self.CenterPointm, self.petPoseTbl.standPoseType)
    elseif self.petPoseTbl.standPoseType == PetStandType.circularMotion then
      self:CircularMotion(self.CenterPointm, configDistance, mAngularSpeed)
    end
  elseif self.PetStatus == ERolePetStatus.Follow then
    offsetSpeed = math.abs(self.player.tempMoveSpeed - self.tempMoveSpeed)
    if 2 <= distance and self.tempMoveSpeed < self.player.tempMoveSpeed then
      self.tempMoveSpeed = self.tempMoveSpeed + addRatio * offsetSpeed
    elseif distance < 2 and self.tempMoveSpeed > self.player.tempMoveSpeed then
      self.tempMoveSpeed = self.tempMoveSpeed - reduceRatio * offsetSpeed
    end
    self:PetFellowHorse(true)
  end
end

function Pet:PetFellowHorse(useConfigPos)
  if not self.targetPosPet or self.targetPosPet == self.pos then
    local playerPos = self:GetPetNewYPos(self.playerPos)
    self.targetPosPet = self:GetFellowPlayerPoint(self:GetPosition(), playerPos, PetFellowDistance[self.petType].Min, self.targetPosPet)
    self.NewtargetPos = nil
  end
  if distance <= 1.3 and not self.NewtargetPos then
    if useConfigPos then
      local standType = PetStandType.standLeft
      if self.petPoseTbl ~= nil and self.petPoseTbl.standPoseType < PetStandType.circularMotion then
        standType = self.petPoseTbl.standPoseType
      end
      local pos = self:GetStandSidePosition(self.playerPos, standType)
      self.targetPosPet = Vector3(pos.x, self.targetPosPet.y, pos.z)
    else
      local playerPos = self:GetPetNewYPos(self.playerPos)
      local xx, yy = self:GetRotaAnglePoint(self.targetPosPet, playerPos, -45)
      self.targetPosPet = Vector3(xx, self.targetPosPet.y, yy)
    end
    self.NewtargetPos = self.targetPosPet
  end
  self:LookAt(self.targetPosPet, true)
  Vector3.MoveTowardsNonAlloc(self.pos, self.targetPosPet, self.tempMoveSpeed * Time.deltaTime, self.pos)
  local pos = Vector3.GetTemp(self.transform:GetPosition())
  Vector3.LerpWithFrom(pos, self.pos, 0.2)
  self.transform:SetPosition(pos.x, pos.y, pos.z)
end

function Pet:UpdatePetDemon()
  if self.PetStatus == ERolePetStatus.Stand then
  elseif self.PetStatus == ERolePetStatus.Follow then
    self:PetFellow()
  end
end

function Pet:UpdatePetHelper01()
  if self.PetStatus == ERolePetStatus.Stand then
    if not self.PathPoint or table.count(self.PathPoint) == 0 then
      self.PathPoint = table.DeepCopy(Helper01StandPoints[1])
    end
  elseif self.PetStatus == ERolePetStatus.Follow then
    self:PetFellow()
  end
end

function Pet:UpdatePetHelper02()
  if self.PetStatus == ERolePetStatus.Stand then
  elseif self.PetStatus == ERolePetStatus.Follow then
    offsetSpeed = math.abs(self.player.tempMoveSpeed - self.tempMoveSpeed)
    if 2 <= distance and self.tempMoveSpeed < self.player.tempMoveSpeed then
      self.tempMoveSpeed = self.tempMoveSpeed + addRatio * offsetSpeed
    elseif distance < 2 and self.tempMoveSpeed > self.player.tempMoveSpeed then
      self.tempMoveSpeed = self.tempMoveSpeed - reduceRatio * offsetSpeed
    end
    self:PetFellowHorse(true)
  end
end

function Pet:UpdatePetMaria()
  if self.PetStatus == ERolePetStatus.Stand then
  elseif self.PetStatus == ERolePetStatus.Follow then
    self:PetFellow()
  end
end

function Pet:PetFellow()
  if not self.targetPosPet or self.targetPosPet == self.pos then
    local playerPos = self:GetPetNewYPos(self.playerPos)
    self.targetPosPet = self:GetFellowPlayerPoint(self:GetPosition(), playerPos, PetFellowDistance[self.petType].Min, self.targetPosPet)
  end
  if self.tempMoveSpeed < self.player.tempMoveSpeed then
    self.tempMoveSpeed = self.tempMoveSpeed + 0.8 * Time.deltaTime
  end
  self.tempMoveSpeed = self.player.tempMoveSpeed
  self:SetPetMoveToPoint(self.targetPosPet)
end

function Pet:UpdateFixedPathMove(PointList, paramPlayerPos, moveSpeend)
  if not (self.targetPosPet and self.pos) or self.targetPosPet == self.pos then
    local playerPos = paramPlayerPos or self:GetPetNewYPos(self.playerPos)
    if table.count(PointList) >= 1 then
      local topos = table.remove(PointList, 1)
      topos.x = playerPos.x + topos.x
      topos.y = playerPos.y + topos.y
      topos.z = playerPos.z + topos.z
      self.targetPosPet = topos
    end
  end
  self.tempMoveSpeed = self.player.tempMoveSpeed
  self:SetPetMoveToPoint(self.targetPosPet)
end

function Pet:CircularMotion(CenterPointm, aroundRadius, angularSpeed)
  if not CenterPointm then
    return
  end
  if not self.angled then
    self.angled = 0
  end
  self.angled = self.angled + angularSpeed * Time.deltaTime % 360
  if self.angled >= 360 then
    self.angled = self.angled - 360
  end
  self.pos = self:GetCirclePoint(CenterPointm, aroundRadius, self.angled)
  self.targetPosPet = self.pos
  self.transform.position = Vector3.LerpWithFrom(self.transform.position, self.pos, 0.2)
  local x = CenterPointm.x
  local y = CenterPointm.z
  local dx = self.transform.localPosition.x
  local dy = self.transform.localPosition.z
  local xx = (x - dx) * Mathf.Cos(90 * Mathf.PI / 180) - (y - dy) * Mathf.Sin(90 * Mathf.PI / 180) + dx
  local yy = (x - dx) * Mathf.Sin(90 * Mathf.PI / 180) + (y - dy) * Mathf.Cos(90 * Mathf.PI / 180) + dy
  self:LookAt({x = xx, z = yy}, true)
end

function Pet:StandSide(targetPosition, petStandType, curDistance)
  if curDistance == nil then
    curDistance = configDistance
  end
  if Mathf.Abs(distance - curDistance) > 0.001 or self.player:GetRotation() ~= self:GetRotation() then
    self.targetPosPet = self:GetStandSidePosition(targetPosition, petStandType, curDistance)
    self:SetRotation(self.player:GetRotation())
    self:SetPetMoveToPoint(self.targetPosPet)
  end
end

function Pet:GetStandSidePosition(targetPosition, petStandType, distance)
  if not targetPosition or petStandType == nil or petStandType > PetStandType.standRight then
    return
  end
  if distance == nil then
    distance = configDistance
  end
  local playerNormalized = Direction8Utility.GetDirectionOffsetByDir(self.player:GetRotation()):SetNormalize()
  if petStandType == PetStandType.standLeft then
    playerNormalized = Direction8Utility.ChangeDir(playerNormalized, -90)
  elseif petStandType == PetStandType.standRight then
    playerNormalized = Direction8Utility.ChangeDir(playerNormalized, 90)
  end
  local offsetVec2 = playerNormalized * distance
  return targetPosition + Vector3(offsetVec2.x, 0, offsetVec2.y)
end

function Pet:GetFellowPlayerPoint(pos1, pos2, Distance, resultVect3)
  if resultVect3 == nil then
    resultVect3 = Vector3.NewFrom(pos1)
  end
  return resultVect3:Sub(pos2):SetNormalize():Mul(Distance):Add(pos2)
end

function Pet:GetRoundTangentPoint(pos1, pos2, aroundRadius)
  local lenght = Vector3.Distance(pos1, pos2)
  if lenght == 0 or lenght * lenght - aroundRadius * aroundRadius == 0 then
    return
  end
  local cc = Mathf.Sqrt(lenght * lenght - aroundRadius * aroundRadius)
  local coeffic = Mathf.Round(lenght / aroundRadius)
  local newX = Mathf.Round(aroundRadius / coeffic)
  local newY = Mathf.Round(cc / coeffic)
  return Vector3(pos1.x + newX, pos1.y, pos1.z + newY)
end

local petNewYPos = Vector3.zero

function Pet:GetPetNewYPos(pos)
  petNewYPos:Set(pos.x + PetFellowHight[self.petType].x, pos.y + PetFellowHight[self.petType].y, pos.z)
  return petNewYPos
end

function Pet:SetPetMoveToPoint(targetPos)
  if targetPos == nil then
    return
  end
  self:LookAt(targetPos, true)
  Vector3.MoveTowardsNonAlloc(self.pos, self.targetPosPet, self.tempMoveSpeed * Time.deltaTime, self.pos)
  local pos = Vector3.GetTemp(self.transform:GetPosition())
  Vector3.LerpWithFrom(pos, self.pos, 0.2)
  self.transform:SetPosition(pos.x, pos.y, pos.z)
end

function Pet:GetCirclePoints(pos1, pos2, num)
  local dis = Vector3.Distance(pos1, pos2)
  if self.CirclePointsTab == nil or #self.CirclePointsTab ~= num then
    self.CirclePointsTab = {}
    for i = 0, num - 1 do
      local point = self:GetCirclePoint(pos2, dis, i * 20 + self.angled)
      table.insert(self.CirclePointsTab, point)
    end
    return self.CirclePointsTab
  end
  for i = 1, num do
    self:GetCirclePointNoGC(pos2, dis, i * 20 + self.angled, self.CirclePointsTab[i])
  end
  return self.CirclePointsTab
end

function Pet:GetCirclePointNoGC(CenterPoint, aroundRadius, angled, resultPoint)
  local posX = aroundRadius * Mathf.Sin(angled * Mathf.Deg2Rad)
  local posZ = aroundRadius * Mathf.Cos(angled * Mathf.Deg2Rad)
  resultPoint:Set(posX, 0, posZ)
  return resultPoint:Add(CenterPoint)
end

function Pet:GetCirclePoint(CenterPoint, aroundRadius, angled)
  local posX = aroundRadius * Mathf.Sin(angled * Mathf.Deg2Rad)
  local posZ = aroundRadius * Mathf.Cos(angled * Mathf.Deg2Rad)
  return Vector3(posX, 0, posZ):Add(CenterPoint)
end

function Pet:GetRotaAnglePoint(startPoint, CenterPoint, angle)
  local x = startPoint.x
  local y = startPoint.z
  local dx = CenterPoint.x
  local dy = CenterPoint.z
  local xx = (x - dx) * Mathf.Cos(angle * Mathf.PI / 180) - (y - dy) * Mathf.Sin(angle * Mathf.PI / 180) + dx
  local yy = (x - dx) * Mathf.Sin(angle * Mathf.PI / 180) + (y - dy) * Mathf.Cos(angle * Mathf.PI / 180) + dy
  return xx, yy
end

function Pet:onLoadMountModel()
  self:PlayAnimation(self:GetAnimationName(self.cacheAnimationStatus))
end

function Pet:InitHeadUI()
end

function Pet:DestroyEffect()
end
