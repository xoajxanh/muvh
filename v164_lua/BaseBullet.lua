BaseBullet = {}

function BaseBullet:Init(BulletObjData, bulletGo, sender, target)
end

function BaseBullet:Update(delta)
end

function BaseBullet:LateUpdate(delta)
end

function BaseBullet:GetTargetPos()
end

function BaseBullet:CleanBeAttackerList()
end

function BaseBullet:OnHitOtherCollider(other)
end

function BaseBullet:ReviseBulletCreateAngle()
end

function BaseBullet:DisposeSpecialOnBulletCreate()
end

function BaseBullet:alculateLifeTime()
end

function BaseBullet:CalculateFinalSpeedOnRunTime()
end

function BaseBullet:SetCalculateOpportunity()
end

function BaseBullet:esetHitList()
end

function BaseBullet:FilterTargetNum()
end

function BaseBullet:CalculateGetHitData()
end

function BaseBullet:SetPosAndRot()
end

function BaseBullet:SetPosAndRot_FollowSender()
end

function BaseBullet:SetPosAndRot_Fly()
end

function BaseBullet:SetPosAndRot_Fly_Parabola()
end

function BaseBullet:CreateChildBullet()
end

function BaseBullet:IsInAtkArea(p)
  return true
end

function BaseBullet:CalculateTargetMovedPos(p, canBreak, tPos)
end

function BaseBullet:CreateBullet()
end

function BaseBullet:CheckCollision(selfData)
end

function BaseBullet:FindBulletTargetByBullet(selfData, bCfg)
end

function BaseBullet:FindBulletTargetByBuff(selfData, bCfg)
end

function BaseBullet:RequestHitTargets(casterId, hitIds, targetPoss, bulletId, bUid, angle, targetPos)
end

function BaseBullet:Dispose()
end
