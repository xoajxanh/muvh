Bullet_LineMoveTargetDir = {}
local this = Bullet_LineMoveTargetDir

function Bullet_LineMoveTargetDir.InitBullet(skillData_struct, pbullet)
  if pbullet.type == BulletType.TargetDir then
    local attackerPos = pbullet.attacker and pbullet.attacker.worldPos or Scene.GetPosByCell({
      x = skillData_struct.attackerX,
      y = skillData_struct.attackerY
    })
    pbullet.initRotation = Vector3.NewFrom(pbullet.offsetEulerAngles)
    if pbullet.group and skillData_struct.skillRangeConfig and skillData_struct.skillRangeConfig.paths[pbullet.group + 1] then
      this.perRad = Mathf.Deg2Rad * (360 / #skillData_struct.skillRangeConfig.paths * pbullet.group + pbullet.offsetEulerAngles.y)
      this.targetPos = attackerPos + Vector3(Mathf.Sin(this.perRad) * 100, 0, Mathf.Cos(this.perRad) * 100)
      pbullet.targetPos = setmetatable({
        x = this.targetPos.x,
        y = this.targetPos.y,
        z = this.targetPos.z
      }, Vector3)
      pbullet.deltaPos = pbullet.targetPos - pbullet.initPos
      pbullet.deltaPos.y = 0
      pbullet.initRotation.y = Vector3.AngleBetween(pbullet.targetPos, attackerPos)
    else
      if pbullet.attacker and pbullet.attacker.model then
        pbullet.deltaPos = pbullet.attacker.model.transform.forward
      elseif attackerPos == pbullet.initPos then
        pbullet.deltaPos = Vector3.forward
      else
        pbullet.deltaPos = Vector3.Normalize(attackerPos - pbullet.initPos)
      end
      if pbullet.through then
        pbullet.targetPos = pbullet.initPos + pbullet.deltaPos
      end
      pbullet.initRotation.y = pbullet.initRotation.y + Vector3.AngleBetween(pbullet.targetPos, attackerPos)
    end
    pbullet.targetPos.y = pbullet.initPos.y
  end
end

function Bullet_LineMoveTargetDir.ReachTarget(Bullet_Struct)
  if Bullet_Struct.type == BulletType.TargetDir then
    if Bullet_Struct.through then
      Bullet_Struct.targetPos:Add(Bullet_Struct.deltaPos)
    else
      this.DisAppearBulletEffect(Bullet_Struct)
    end
  end
end

local roles, tempCell

function Bullet_LineMoveTargetDir.CheckRoleCollider(Bullet_Struct, pos)
  if Bullet_Struct.type == BulletType.TargetDir and (not Bullet_Struct.through or Bullet_Struct.hits) then
    tempCell = Scene.GetCellByPos(pos)
    if Bullet_Struct.curCell == nil or Bullet_Struct.curCell.x ~= Mathf.Floor(tempCell.x) or Bullet_Struct.curCell.y ~= Mathf.Floor(tempCell.y) then
      Bullet_Struct.curCell = tempCell
      roles = RoleManager.GetRoleInCell(tempCell)
      if 0 < #roles then
        if Bullet_Struct.type == BulletType.TargetDir and not Bullet_Struct.through then
          this.DisAppearBulletEffect(Bullet_Struct)
          Bullet_Struct.stopMove = true
        end
        this.CheckHitEffect(Bullet_Struct)
      end
    end
  end
end

function Bullet_LineMoveTargetDir.DisAppearBulletEffect(Bullet_Struct)
  this.ArrowDisappear(Bullet_Struct)
end

function Bullet_LineMoveTargetDir.ArrowDisappear(Bullet_Struct)
  if Bullet_Struct.arrowEffect then
    Bullet_Struct.arrowEffect:DisableEffect()
  else
    BulletMgr.DestroySingleBullet(Bullet_Struct)
  end
end

function Bullet_LineMoveTargetDir.CheckHitEffect(Bullet_Struct)
  if Bullet_Struct.hits then
    for i = 1, #roles do
      if roles[i].RoleType == ERoleType.Monster or roles[i].RoleType == ERoleType.Player then
        for j = 1, #Bullet_Struct.hits do
          HitEffectMgr.AddEffect(Bullet_Struct.hits[j], roles[i])
        end
      end
    end
  end
end
