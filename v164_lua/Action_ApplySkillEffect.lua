Action_ApplySkillEffect = class(Action_Base)

function Action_ApplySkillEffect:Init(caster, actionData, speed, skillMsg, hitdata)
  self.base.Init(self, caster, actionData, speed)
  self.skillId = skillMsg.skillId
  self.attackerId = skillMsg.attackerId
  self.hurtList = skillMsg.hurtList
  self.hitdata = hitdata and hitdata[1] or nil
  self.skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(self.skillId)
end

function Action_ApplySkillEffect:OnStartProcess()
  self:PerfermHurt()
  if self.skillConfig.type == 1 then
    PlayerSoundManager.PlayHurtSound(self)
  end
end

function Action_ApplySkillEffect:PerfermHurt()
  local attacker = RoleManager.GetRoleById(self.attackerId)
  for i = 1, #self.hurtList do
    local hurt = self.hurtList[i]
    local target = RoleManager.GetRoleById(hurt.targetId)
    if target and target.HurtMaterialEffect and hurt.showHurt > 0 then
      target:HurtMaterialEffect(self.attackerId)
    end
    if (hurt.targetId == ViewData.meData.id or self.attackerId == ViewData.meData.id or target and target.data.master == ViewData.meData.id or attacker and attacker.data.master == ViewData.meData.id or Activity_LangHunYaoSaiData.RoleIsLangHunYongBing(hurt.targetId)) and (hurt.isDodge or hurt.showHurt ~= 0) then
      local aa = -hurt.showHurt
      local tbl = ClientTable.cfg_Skill_skillManager:TryGetValue(self.skillId)
      if tbl.groupId == 12120200 then
        aa = math.floor(aa * GlobalConfig.HLBRatio)
      end
      if tbl.skillType == ESkillType.Combo then
        HpController.ChangeHPFromComboSkill(hurt.targetId, hurt.hp, hurt, aa)
      else
        HpController.ChangeHPFromResSkill(hurt.targetId, hurt.hp, hurt, aa)
      end
    end
    if target and self.attackerId == ViewData.meData.id then
      local hitRotateOpen = false
      if self.hitdata and self.hitdata.hitRotateData then
        hitRotateOpen = self.hitdata.hitRotateData.rotateOpen
      end
      if hitRotateOpen then
        local canbeRotate = false
        if target.RoleType == ERoleType.Player then
          canbeRotate = true
        elseif target.monsterTb then
          canbeRotate = true
          if GameInitData.heiLongBoSpinMonsterExcludeTypes ~= nil then
            for _, v in pairs(GameInitData.heiLongBoSpinMonsterExcludeTypes) do
              if v == target.monsterTb.type then
                canbeRotate = false
              end
            end
          end
        end
        if canbeRotate and target.id ~= RoleManager.me.id and 0 < target.hp then
          target:StartRotateLerpSpeed(target.dir + 540)
        end
      end
    end
  end
end
