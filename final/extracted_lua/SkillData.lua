SkillData = {}
local this = SkillData
SkillData.skillDic = {}
SkillData.MainMode = EMainModeType.Skill
SkillData.needInputSkillInfo = false
SkillData.skillInfoTbl = {}

function SkillData.IsNilOrEmptyAction(skill_struct)
  if skill_struct.skillConfig ~= nil and skill_struct.skillConfig.actions then
    return false
  end
  return true
end

function SkillData.SetSkillStructActionConfig(skill_struct)
  skill_struct.ActionEffectData = nil
  skill_struct.ActionBulletData = nil
  skill_struct.ActionRoleAnimationData = nil
  if skill_struct.skillConfig ~= nil and skill_struct.skillConfig.actions then
    skill_struct.ActionEffectData = skill_struct.skillConfig.actions.ActionEffectData
    skill_struct.ActionBulletData = skill_struct.skillConfig.actions.ActionBulletData
    skill_struct.ActionHeiLongBoTrailBulletData = skill_struct.skillConfig.actions.ActionHeiLongBoTrailBulletData
    skill_struct.ActionWeaponData = skill_struct.skillConfig.actions.ActionWeaponData
    skill_struct.ActionRoleAnimationData = skill_struct.skillConfig.actions.ActionRoleAnimationData
    skill_struct.ActionHitData = skill_struct.skillConfig.actions.ActionHitData
    if skill_struct.attacker and skill_struct.attacker.data and skill_struct.attacker.data.equipsData then
      local weaponConfig = skill_struct.attacker.data.equipsData:GetEquipByIndex(ERoleEquipPosition.right_weapon)
      if weaponConfig and weaponConfig.tblEquip then
        skill_struct.weaponId = weaponConfig.tblEquip.id
        skill_struct.weaponConfig = ConfigManager.GetConfig("cfg_weaponSkillLogic", weaponConfig.tblEquip.weaponSkill, "weaponId")
        if skill_struct.weaponConfig == nil then
          weaponConfig = skill_struct.attacker.data.equipsData:GetEquipByIndex(ERoleEquipPosition.left_weapon)
          if weaponConfig and weaponConfig.tblEquip then
            skill_struct.weaponId = weaponConfig.tblEquip.id
            skill_struct.weaponConfig = ConfigManager.GetConfig("cfg_weaponSkillLogic", weaponConfig.tblEquip.weaponSkill, "weaponId")
          end
        end
      else
        weaponConfig = skill_struct.attacker.data.equipsData:GetEquipByIndex(ERoleEquipPosition.left_weapon)
        if weaponConfig and weaponConfig.tblEquip then
          skill_struct.weaponId = weaponConfig.tblEquip.id
          skill_struct.weaponConfig = ConfigManager.GetConfig("cfg_weaponSkillLogic", weaponConfig.tblEquip.weaponSkill, "weaponId")
        end
      end
    end
  end
end

function SkillData.GetOffsetByOffset(attackerId, offset)
  local attacker = RoleManager.GetRoleById(attackerId)
  if attacker ~= nil and attacker.dir ~= nil then
    local directionz = Direction8Utility:GetOffsetZByAngle(Mathf.Round(attacker.dir))
    local directionx = Direction8Utility:GetOffsetXByAngle(Mathf.Round(attacker.dir))
    return Vector3(directionz.x, 0, directionz.z) * offset.z + Vector3(directionx.x, 0, directionx.z) * offset.x + Vector3(0, offset.y, 0)
  end
  return Vector3(0, 0, 0)
end

function SkillData.SaveSkillInfos(skillInfos)
  this.Reset()
end

function SkillData.Reset()
  for _, v in pairs(this.SkillList) do
    v = nil
  end
  this.SkillList = {}
end

SkillData.SkillList = {}

function SkillData.CreateCareerSkillInfos()
  local skillList1 = ConfigManager.FindConfigs("cfg_Skill_skill", "showType", 1)
  local skillList2 = ConfigManager.FindConfigs("cfg_Skill_skill", "showType", 2)
  this.SkillList[1] = this.GetCareerSkillInfo(skillList1)
  this.InsertLearnShowSkill(skillList2, this.SkillList[1])
end

function SkillData.GetCareerSkillInfo(skillData)
  local skillInfos = {}
  local skillGroupIdDict = {}
  for i, v in pairs(skillData) do
    local cfg_skill = v
    local incareer = ParseUtility:IsSameCareerType(cfg_skill.career, RoleManager.me.career)
    local skill = RoleManager.me.skills[cfg_skill.groupId]
    if incareer and not skillGroupIdDict[cfg_skill.groupId] then
      table.insert(skillInfos, cfg_skill)
      skillGroupIdDict[cfg_skill.groupId] = #skillInfos
    elseif incareer and skill and skill.sid == cfg_skill.id and skillGroupIdDict[cfg_skill.groupId] then
      skillInfos[skillGroupIdDict[cfg_skill.groupId]] = cfg_skill
    end
  end
  return skillInfos
end

function SkillData.InsertLearnShowSkill(skillData, skillList)
  for i, v in pairs(skillData) do
    local cfg_skill = v
    local incareer = ParseUtility:IsSameCareerType(cfg_skill.career, RoleManager.me.career)
    local skill = RoleManager.me.skills[cfg_skill.groupId]
    if incareer and skill and skill.sid == cfg_skill.id then
      table.insert(skillList, cfg_skill)
    end
  end
end

function SkillData.UpdateSkillData(skillInfo)
  local skillInfoData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillInfo.sid)
  if skillInfoData.showType == ESkillShowType.NotShow then
    return
  end
  if skillInfoData.showType == ESkillShowType.Show or skillInfoData.showType == ESkillShowType.LearnShow then
    this.UpdateCareerSkillData(this.SkillList[1], skillInfoData)
  end
  EventManager.Dispatch(Event.Skill_SkillInfo_Refresh, skillInfo)
  EventManager.Dispatch(Event.Skill_RefreshSkillUI, skillInfo)
end

function SkillData.UpdateCareerSkillData(careerSkillData, skillData)
  for i, v in pairs(careerSkillData) do
    local tempSkillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if skillData.groupId == tempSkillData.groupId then
      careerSkillData[i] = skillData
      if skillData.id > tempSkillData.id then
        EventManager.Dispatch(Event.Skill_UpgradeSuccess)
      end
      return
    end
  end
  table.insert(careerSkillData, skillData)
end

function SkillData.RemoveSkillData(skillInfo)
  local skillInfoData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillInfo.sid)
  if skillInfoData.showType == ESkillShowType.NotShow then
    return
  end
  if skillInfoData.showType == ESkillShowType.LearnShow then
    this.RemoveCareerSkillData(this.SkillList[1], skillInfoData)
  end
  EventManager.Dispatch(Event.Skill_RefreshSkillUI, skillInfo)
end

function SkillData.RemoveCareerSkillData(careerSkillData, skillData)
  for i, v in pairs(careerSkillData) do
    local tempSkillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if skillData.groupId == tempSkillData.groupId then
      table.remove(careerSkillData, i)
      return
    end
  end
end

function SkillData.CheckFakeSkill(groupId, level)
  local contentStr = ClientTable.cfg_Global_globalManager:TryGetValue(60000009).effect
  local itemTabs = string.split(contentStr, "&")
  local skillFakeTab = {}
  for i = 1, #itemTabs do
    local fakeItem = {}
    fakeItem.groupId = tonumber(string.split(itemTabs[i], "#")[1])
    fakeItem.level = tonumber(string.split(itemTabs[i], "#")[2])
    table.insert(skillFakeTab, fakeItem)
  end
  if RoleManager.me.skills[groupId] and skillFakeTab ~= nil then
    for i = 1, #skillFakeTab do
      local fakeItem = skillFakeTab[i]
      if fakeItem.groupId == groupId and fakeItem.level == level then
        return true
      end
    end
  end
  return false
end

function SkillData.SetAllAttackData(data)
  EventManager.Dispatch(Event.RefreshReinBeatBack, data)
end

SkillData.commonAttackCombo = 0
SkillData.AttackSequence = 1
