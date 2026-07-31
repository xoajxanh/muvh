Action_HitEffect = class(Action_Base)

function Action_HitEffect:Init(casterId, hitData, speed, targetId, targetCell)
  self.casterId = casterId
  self.caster = RoleManager.GetRoleById(self.casterId)
  self.base.Init(self, self.caster, hitData, speed)
  self.hitData = hitData
  if self.hitData.hitEffect == nil or self.hitData.hitEffect == "" then
    self.actionStatus = ESkillActionStatus.Finish
    return
  end
  self.target = RoleManager.GetRoleById(targetId)
  if self.target then
    self.targetPos = self.target.worldPos + self.hitData.offset
  else
    self.targetPos = Scene.GetPosByCell(targetCell) + self.hitData.offset
  end
  self.effectModelName = "hitEffect_" .. targetId
  self:LoadEffect(self.OnLoaded)
end

function Action_HitEffect:OnStartProcess()
  self:PlayEffect()
end

function Action_HitEffect:OnLoaded()
  if self.actionStatus > ESkillActionStatus.Started and self.actionStatus < ESkillActionStatus.Interrupted then
    self:PlayEffect()
  end
end

function Action_HitEffect:PlayEffect()
  if IsNil(self.skillEffectGo) then
    return
  end
  self.skillEffectGo.transform.position = self.targetPos
  self.skillEffectGo:SetActive(true)
end

function Action_HitEffect:LoadEffect(onLoaded)
  self.skillEffectGo = PoolManagerTest.Spawn(ResourceTypeEnum.Effect_Skill, self.hitData.hitEffect)
  if IsNil(self.skillEffectGo) then
    local callBack = bind(self, onLoaded)
    self.skillModelLoader = CS.Framework.GameModel(self.effectModelName, nil, callBack)
    self.skillModelLoader:LoadAsync(self.hitData.hitEffect)
    self.skillEffectGo = self.skillModelLoader.gameObject
  else
    self.skillEffectGo.name = self.effectModelName
    onLoaded(self)
  end
  self.skillEffectGo:SetActive(false)
end

function Action_HitEffect:OnDestroy()
  if self.skillModelLoader then
    self.skillModelLoader:StopLoad()
  end
  if not IsNil(self.skillEffectGo) then
    PoolManagerTest.Recycle(ResourceTypeEnum.Effect_Skill, self.hitData.hitEffect, self.skillEffectGo)
    EffectDisplayController.RemoveSkillEffect(self.casterId)
    self.skillEffectModel = nil
  end
end
