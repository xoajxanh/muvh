Bullet_MoveInPath = {}
local this = Bullet_MoveInPath
local positionArrayPool = {}

local function AllocPositonArray()
  return table.remove(positionArrayPool) or {}
end

local function RecyclePositionArray(positionArray)
  if positionArray then
    array.clear(positionArray)
    table.insert(positionArrayPool, positionArray)
  end
end

function Bullet_MoveInPath.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.MoveInPath then
    return
  end
  if Bullet_Struct.bullet ~= nil and Bullet_Struct.position ~= nil then
    if Bullet_Struct.lifeTime > 0 then
      local bulletTransform = Bullet_Struct.bullet.transform
      local x, y, z = bulletTransform:GetPosition()
      local posTemp = Vector3.GetTemp(x, y, z)
      local distanceDelta = Bullet_Struct.speed * Time.deltaTime
      while true do
        if distanceDelta < Vector3.Distance(posTemp, Bullet_Struct.position[Bullet_Struct.nextPosIndex]) or Bullet_Struct.nextPosIndex >= #Bullet_Struct.position then
          Vector3.MoveTowardsNonAlloc(posTemp, Bullet_Struct.position[Bullet_Struct.nextPosIndex], distanceDelta, posTemp)
          break
        else
          distanceDelta = distanceDelta - Vector3.Distance(posTemp, Bullet_Struct.position[Bullet_Struct.nextPosIndex])
          posTemp:CopyFrom(Bullet_Struct.position[Bullet_Struct.nextPosIndex])
          Bullet_Struct.nextPosIndex = Bullet_Struct.nextPosIndex + 1
        end
      end
      bulletTransform:SetPosition(posTemp.x, posTemp.y, posTemp.z)
      if Bullet_Struct.nextPosIndex <= #Bullet_Struct.position then
        local angleY = Vector3.AngleBetween(posTemp, Bullet_Struct.position[Bullet_Struct.nextPosIndex])
        if angleY ~= nil then
          bulletTransform:SetEulerAngles(0, angleY + 180, 0)
        end
      end
    else
      BulletMgr.DestroySingleBullet(Bullet_Struct)
    end
  else
    BulletMgr.DestroySingleBullet(Bullet_Struct)
  end
end

function Bullet_MoveInPath.InitBullet(skillData_struct, pbullet)
  if pbullet.type ~= BulletType.MoveInPath or skillData_struct.position == nil or #skillData_struct.position == 0 then
    return
  end
  local tbl_heilongbo = ConfigManager.GetConfig("cfg_HeiLongBo", pbullet.group, "position")
  pbullet.curCell = Vector2Int(0, 0)
  if pbullet.attacker and tbl_heilongbo then
    pbullet.position = AllocPositonArray()
    for i = 1, #tbl_heilongbo.paths do
      local pos = Vector3.AllocFrom(pbullet.attacker.worldPos):Add(pbullet.offset)
      pos.x = pos.x + tbl_heilongbo.paths[i].x * Scene.tileSize
      pos.y = pos.y + 1
      pos.z = pos.z + tbl_heilongbo.paths[i].y * Scene.tileSize
      table.insert(pbullet.position, pos)
    end
    pbullet.speed = tbl_heilongbo.length / pbullet.lifeTime
    pbullet.nextPosIndex = 2
    pbullet.initPos:CopyFrom(pbullet.position[1])
    local angleYT = Vector3.AngleBetween(pbullet.position[1], pbullet.position[2])
    if angleYT ~= nil then
      pbullet.initRotation:Set(0, angleYT + 180, 0)
    end
  end
end

function Bullet_MoveInPath.RecycleBullet(bullet)
  if bullet.type ~= BulletType.MoveInPath then
    return
  end
  Vector3.RecycleArray(bullet.position)
  RecyclePositionArray(bullet.position)
  bullet.position = nil
end
