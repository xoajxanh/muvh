Bullet_PointToPoint = {}
local this = Bullet_PointToPoint

function Bullet_PointToPoint.Update(Bullet_Struct)
  if Bullet_Struct.type ~= BulletType.SelfToTarget then
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

function Bullet_PointToPoint.InitEffect(Bullet_Struct, skillEffect)
  if Bullet_Struct.type ~= BulletType.SelfToTarget then
    return
  end
  this.InitZhangXinLeiEffect(Bullet_Struct, skillEffect)
  this.InitLineRendererBezierEffect(Bullet_Struct, skillEffect)
  this.InitLineRendererCommonEffect(Bullet_Struct, skillEffect)
end

function Bullet_PointToPoint.InitZhangXinLeiEffect(Bullet_Struct, skillEffect)
  if skillEffect == nil or IsNil(skillEffect) then
    return
  end
  Bullet_Struct.zhangxin = skillEffect:GetComponentInChildren(typeof(CS.Framework.BulletZhangXinLeiEffect))
  if Bullet_Struct.zhangxin then
    Bullet_Struct.zhangxin:ResetEffect(Bullet_Struct.initPos)
    Bullet_Struct.zhangxin:InitEffect(Bullet_Struct.attackerNode, Bullet_Struct.targetNode, Bullet_Struct.initPos, Bullet_Struct.targetPos)
  end
end

function Bullet_PointToPoint.InitLineRendererBezierEffect(Bullet_Struct, skillEffect)
  if Bullet_Struct.attacker == nil or Bullet_Struct.target == nil then
    return
  end
  local effectLineRendererBezier = skillEffect:GetComponentInChildren(typeof(CS.Framework.EffectLineRendererBezierManager))
  if effectLineRendererBezier then
    effectLineRendererBezier:InitEffect(Bullet_Struct.attackerNode, Bullet_Struct.attackerNode, Bullet_Struct.targetNode)
  end
end

function Bullet_PointToPoint.InitLineRendererCommonEffect(Bullet_Struct, skillEffect)
  if Bullet_Struct.attacker == nil or Bullet_Struct.target == nil or IsNil(skillEffect) then
    return
  end
  local effectLineRendererCommons = skillEffect:GetComponentsInChildren(typeof(CS.Framework.EffectLineRendererCommon))
  if effectLineRendererCommons then
    local attackerNode, targetNode
    if Bullet_Struct.attackerNode then
      attackerNode = Bullet_Struct.attackerNode
    end
    if Bullet_Struct.targetNode then
      targetNode = Bullet_Struct.targetNode
    end
    if attackerNode == nil then
      attackerNode = Bullet_Struct.attacker.transform
    end
    if targetNode == nil then
      targetNode = Bullet_Struct.target.transform
    end
    if attackerNode and targetNode then
      for i = 0, effectLineRendererCommons.Length - 1 do
        effectLineRendererCommons[i]:PlayEffect(attackerNode, targetNode)
      end
    end
  end
end
