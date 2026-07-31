Bullet_AroundSelfShoot = {}
local this = Bullet_AroundSelfShoot
local circle = 360

function Bullet_AroundSelfShoot.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.AroundSelfShoot then
    return
  end
  if Bullet_Struct.bullet ~= nil then
    if Bullet_Struct.lifeTime > 0 then
      local curPos = Bullet_Struct.bullet.transform.position
      curPos = Vector3(curPos.x, curPos.y, curPos.z)
      local forward = Bullet_Struct.bullet.transform.forward
      this.pos = Vector3.MoveTowards(curPos, curPos + forward, Bullet_Struct.speed * Time.deltaTime)
      Bullet_Struct.bullet.transform.position = this.pos
      this.CheckRoleCollider(Bullet_Struct, this.pos)
    else
      BulletMgr.Destroy(Bullet_Struct.bid)
    end
  end
end

function Bullet_AroundSelfShoot.InitBullet(skillData_struct, pbullet)
  if pbullet.type ~= BulletType.AroundSelfShoot then
    return
  end
  local bulletCount = #skillData_struct.ActionBulletData
  local intervalY = circle / bulletCount
  local angleY = (skillData_struct.index - 1) * intervalY
  pbullet.initRotation = Vector3(0, angleY, 0)
  if skillData_struct.attacker then
    pbullet.initPos = skillData_struct.attacker.pos
  else
    pbullet.state = EffectState.HaveDestory
  end
end

local roles, tempCell

function Bullet_AroundSelfShoot.CheckRoleCollider(Bullet_Struct, pos)
  if Bullet_Struct.type == BulletType.AroundSelfShoot then
    tempCell = Scene.GetCellByPos(pos)
    if Bullet_Struct.curCell == nil or Bullet_Struct.curCell.x ~= Mathf.Floor(tempCell.x) or Bullet_Struct.curCell.y ~= Mathf.Floor(tempCell.y) then
      Bullet_Struct.curCell = tempCell
      roles = RoleManager.GetRoleInCell(tempCell)
      if not (0 < #roles) or Bullet_Struct.type == BulletType.AroundSelfShoot then
      end
    end
  end
end
