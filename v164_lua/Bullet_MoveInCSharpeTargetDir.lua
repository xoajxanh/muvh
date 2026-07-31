Bullet_MoveInCSharpeTargetDir = {}
local this = Bullet_MoveInCSharpeTargetDir

function Bullet_MoveInCSharpeTargetDir.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.MoveInCSharpeTargetDir then
    return
  end
  if Bullet_Struct.bullet ~= nil then
    if Bullet_Struct.lifeTime > 0 then
    else
    end
  else
    print("isNUll---------------------")
  end
end

function Bullet_MoveInCSharpeTargetDir.InitEffect(pbullet, skillEffect)
  if pbullet.type ~= BulletType.MoveInCSharpeTargetDir then
    return
  end
  this.MoveWenDiNi(pbullet, skillEffect)
  this.MoveShengLingGong(pbullet, skillEffect)
end

function Bullet_MoveInCSharpeTargetDir.MoveWenDiNi(pbullet, skillEffect)
  if skillEffect == nil or IsNil(skillEffect) then
    return
  end
  local WenDiNiLine = skillEffect:GetComponentInChildren(typeof(CS.Framework.WenDiNiLine))
  if WenDiNiLine then
    this.perDegree = 0
    if pbullet.group and pbullet.skillData_struct.skillRangeConfig and pbullet.skillData_struct.skillRangeConfig.paths[pbullet.group + 1] then
      this.perDegree = 360 / #pbullet.skillData_struct.skillRangeConfig.paths * pbullet.group + pbullet.offsetEulerAngles.y
    end
    WenDiNiLine:InitEffect(this.perDegree, pbullet.targetPos, pbullet.through, function()
      this.CheckHitEffect(pbullet, pbullet.bullet.transform:GetChild(0).position)
      BulletMgr.DestroySingleBullet(pbullet)
    end)
  end
end

function Bullet_MoveInCSharpeTargetDir.MoveShengLingGong(pbullet, skillEffect)
  local ShengLingCurveManager = skillEffect:GetComponentInChildren(typeof(CS.Framework.ShengLingCurveManager))
  local targetPos
  if ShengLingCurveManager and pbullet.group then
    if pbullet.skillData_struct.skillRangeConfig == nil or pbullet.skillData_struct.skillRangeConfig.paths[pbullet.group + 1] == nil then
      return
    end
    if pbullet.attacker then
      this.perRad = Mathf.Deg2Rad * (360 / #pbullet.skillData_struct.skillRangeConfig.paths * pbullet.group + pbullet.offsetEulerAngles.y)
      targetPos = pbullet.attacker.pos + Vector3(Mathf.Sin(this.perRad) * 20, 0, Mathf.Cos(this.perRad) * 20)
    end
  elseif pbullet.attacker and pbullet.target then
    if pbullet.through then
      local delta = Vector3.Normalize(pbullet.target.pos - pbullet.attacker.pos)
      targetPos = pbullet.attacker.pos + Vector3(delta.x * 20, 0, delta.z * 20)
    else
      targetPos = pbullet.target.pos
    end
  end
  if targetPos and ShengLingCurveManager ~= nil then
    ShengLingCurveManager:PlayEffectPos(targetPos, function()
      this.CheckHitEffect(pbullet, targetPos)
      BulletMgr.DestroySingleBullet(pbullet)
    end)
  end
end

function Bullet_MoveInCSharpeTargetDir.CheckHitEffect(Bullet_Struct, targetPos)
  if Bullet_Struct.hits and targetPos then
    for j = 1, #Bullet_Struct.hits do
      HitEffectMgr.AddEffectByPos(Bullet_Struct.hits[j], targetPos)
    end
  end
end
