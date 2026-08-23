Bullet_LineMoveTargetPos = {}
local this = Bullet_LineMoveTargetPos

function Bullet_LineMoveTargetPos.InitBullet(skillData_struct, pbullet)
  if pbullet.type == BulletType.TargetPos then
    local target = skillData_struct.target
    if not skillData_struct.isUI then
      target = RoleManager.GetRoleById(pbullet.tid)
    end
    local hasTargetPos
    if target then
      local targetNode = target:GetModelNode(pbullet.targetBone)
      if targetNode then
        if pbullet.targetPos then
          pbullet.targetPos:CopyFrom(pbullet.targetOffset + targetNode.position)
        else
          pbullet.targetPos = Vector3.NewFrom(pbullet.targetOffset + targetNode.position)
        end
        hasTargetPos = true
      end
    end
    if not hasTargetPos then
      pbullet.targetPos.y = pbullet.initPos.y
    end
    if pbullet.initPos and pbullet.targetPos then
      pbullet.initRotation = Vector3(pbullet.offsetEulerAngles.x, pbullet.offsetEulerAngles.y + (pbullet.targetPos == pbullet.initPos and 0 or Vector3.AngleBetween(pbullet.targetPos, pbullet.initPos)), pbullet.offsetEulerAngles.z)
    end
  end
end

function Bullet_LineMoveTargetPos.Update(pbullet)
  if pbullet.type == BulletType.TargetPos and pbullet.traceTargetBone then
    this.UpdateTargetPos(pbullet)
  end
end

function Bullet_LineMoveTargetPos.UpdateTargetPos(pbullet)
  local target = RoleManager.GetRoleById(pbullet.tid)
  if target then
    local targetNode = target:GetModelNode(pbullet.targetBone)
    if targetNode then
      if pbullet.targetPos then
        pbullet.targetPos:Set(targetNode:GetPosition())
        pbullet.targetPos:Add(pbullet.targetOffset)
      else
        pbullet.targetPos = Vector3.Alloc(targetNode:GetPosition()):Add(pbullet.targetOffset)
      end
    end
  end
end

function Bullet_LineMoveTargetPos.ReachTarget(Bullet_Struct)
  if Bullet_Struct.type == BulletType.TargetPos then
    this.DisAppearBulletEffect(Bullet_Struct)
    if Bullet_Struct.target and Bullet_Struct.hits and Bullet_Struct.targetBodyPos and Bullet_Struct.targetBodyPos.x == Bullet_Struct.target.pos.x and Bullet_Struct.targetBodyPos.z == Bullet_Struct.target.pos.z and (Bullet_Struct.target.RoleType == ERoleType.Monster or Bullet_Struct.target.RoleType == ERoleType.Player) then
      for j = 1, #Bullet_Struct.hits do
        HitEffectMgr.AddEffect(Bullet_Struct.hits[j], Bullet_Struct.target)
      end
    end
  end
end

function Bullet_LineMoveTargetPos.DisAppearBulletEffect(Bullet_Struct)
  if Bullet_Struct.arrowEffect then
    this.ArrowDisappear(Bullet_Struct)
    Bullet_Struct.stopMove = true
  else
    BulletMgr.DestroySingleBullet(Bullet_Struct)
  end
end

function Bullet_LineMoveTargetPos.ArrowDisappear(Bullet_Struct)
  if Bullet_Struct.arrowEffect then
    Bullet_Struct.arrowEffect:DisableEffect()
  end
end
