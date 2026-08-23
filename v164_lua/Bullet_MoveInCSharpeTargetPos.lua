Bullet_MoveInCSharpeTargetPos = {}
local this = Bullet_MoveInCSharpeTargetPos

function Bullet_MoveInCSharpeTargetPos.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.MoveInCSharpeTargetPos then
    return
  end
  if Bullet_Struct.bullet ~= nil then
    if Bullet_Struct.lifeTime > 0 then
    else
      BulletMgr.DestroySingleBullet(Bullet_Struct)
    end
  else
    print("isNUll---------------------")
  end
end

function Bullet_MoveInCSharpeTargetPos.InitEffect(pbullet, skillEffect)
  if pbullet.type ~= BulletType.MoveInCSharpeTargetPos then
    return
  end
  this.WenDiNi(pbullet, skillEffect)
  this.ShengLingGong(pbullet, skillEffect)
end

function Bullet_MoveInCSharpeTargetPos.WenDiNi(pbullet, skillEffect)
  local WenDiNiLine = skillEffect:GetComponentInChildren(typeof(CS.Framework.WenDiNiLine))
  if WenDiNiLine ~= nil and pbullet.attacker then
    WenDiNiLine:InitEffect(pbullet.attacker.dir, pbullet.targetPos, function()
      this.CheckHitEffect(pbullet, pbullet.bullet.transform:GetChild(0).position)
      BulletMgr.DestroySingleBullet(pbullet)
    end)
  end
end

function Bullet_MoveInCSharpeTargetPos.ShengLingGong(pbullet, skillEffect)
  local shenglingCurve = skillEffect:GetComponentInChildren(typeof(CS.Framework.ShengLingCurveManager))
  if shenglingCurve ~= nil and pbullet.target then
    shenglingCurve:PlayEffectPos(pbullet.target.pos, function()
      this.CheckHitEffect(pbullet, pbullet.targetPos)
      BulletMgr.DestroySingleBullet(pbullet)
    end)
  end
end

function Bullet_MoveInCSharpeTargetPos.CheckHitEffect(Bullet_Struct, targetPos)
  if Bullet_Struct.hits and targetPos then
    for j = 1, #Bullet_Struct.hits do
      HitEffectMgr.AddEffectByPos(Bullet_Struct.hits[j], targetPos)
    end
  end
end
