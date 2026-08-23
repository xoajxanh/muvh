Bullet_MoveInBezier = {}
local this = Bullet_MoveInBezier
local angleY

function Bullet_MoveInBezier.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.MoveInBezier then
    return
  end
  if Bullet_Struct.bullet ~= nil and Bullet_Struct.position ~= nil then
    if Bullet_Struct.lifeTime > 0 then
      if Bullet_Struct.timer < 1 and Bullet_Struct.bezier then
        Bullet_Struct.bullet.transform.position = PointMgr.GetBezierPoint(Bullet_Struct.bezier, Bullet_Struct.timer)
        if Bullet_Struct.timer then
          Bullet_Struct.timer = Bullet_Struct.timer + Bullet_Struct.bezierSpeed
          if Bullet_Struct.timer > 1 then
            Bullet_Struct.timer = 1
          end
        end
      end
      if Bullet_Struct.timer == 1 and Bullet_Struct.bullet ~= nil and Bullet_Struct.target ~= nil then
        this.pos = Vector3.MoveTowards(Bullet_Struct.bullet.transform.position, Bullet_Struct.targetPos, Bullet_Struct.speed * Time.deltaTime)
        Bullet_Struct.bullet.transform.position = this.pos
        if this.pos == Bullet_Struct.targetPos then
          BulletMgr.DestroySingleBullet(Bullet_Struct)
        end
      end
    else
      BulletMgr.DestroySingleBullet(Bullet_Struct)
    end
  else
    print("isNUll---------------------")
  end
end

function Bullet_MoveInBezier.InitBullet(skillData_struct, pbullet)
  if pbullet.type ~= BulletType.MoveInBezier then
    return
  end
  local cfg_MoveInLine = ConfigManager.GetConfig("cfg_CurveDrawLine", 0, "pathId")
  if pbullet.attacker and cfg_MoveInLine then
    pbullet.position = {}
    local randomValue = Mathf.Random(1, #cfg_MoveInLine.paths)
    local selectPath = cfg_MoveInLine.paths[randomValue]
    if selectPath then
      local paths = {}
      for i = 1, #selectPath.path do
        table.insert(paths, SkillUtility.GetPointByAttacker(pbullet.attacker, selectPath.path[i]))
      end
      for i = 1, #paths do
        table.insert(pbullet.position, pbullet.attacker.pos + pbullet.offset + Vector3(paths[i].x * Scene.tileSize, paths[i].y, paths[i].z * Scene.tileSize))
      end
      pbullet.initPos = pbullet.position[1]
      pbullet.bezier = PointMgr.InitBezier(pbullet.position)
      pbullet.timer = 0
      pbullet.bezierSpeed = 0.02 * (3 / pbullet.lifeTime)
    end
  end
end
