Bullet_LineMove = {}
local this = Bullet_LineMove

function Bullet_LineMove.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.TargetPos and Bullet_Struct.type ~= BulletType.TargetDir then
    return
  end
  if Bullet_Struct.bullet ~= nil then
    if Bullet_Struct.lifeTime > 0 then
      if Bullet_Struct.stopMove then
        return
      end
      Bullet_LineMoveTargetPos.Update(Bullet_Struct)
      local bulletTransform = Bullet_Struct.bullet.transform
      local pos = Vector3.Alloc(bulletTransform:GetPosition())
      Vector3.MoveTowardsNonAlloc(pos, Bullet_Struct.targetPos, Bullet_Struct.speed * Time.deltaTime, pos)
      bulletTransform:SetPosition(pos.x, pos.y, pos.z)
      if pos == Bullet_Struct.targetPos then
        Bullet_LineMoveTargetPos.ReachTarget(Bullet_Struct)
        Bullet_LineMoveTargetDir.ReachTarget(Bullet_Struct)
      end
      Bullet_LineMoveTargetDir.CheckRoleCollider(Bullet_Struct, pos)
      Vector3.Recycle(pos)
    else
      BulletMgr.DestroySingleBullet(Bullet_Struct)
    end
  else
  end
end

function Bullet_LineMove.InitBullet(skillData_struct, pbullet)
  if pbullet.type ~= BulletType.TargetDir and pbullet.type ~= BulletType.TargetPos then
    return
  end
  Bullet_LineMoveTargetDir.InitBullet(skillData_struct, pbullet)
  Bullet_LineMoveTargetPos.InitBullet(skillData_struct, pbullet)
end

function Bullet_LineMove.InitEffect(Bullet_Struct, skillEffect)
  if IsNil(skillEffect) then
    return
  end
  Bullet_Struct.arrowEffect = skillEffect:GetComponentInChildren(typeof(CS.Framework.ArrowDisableEffect))
end
