QiJiHelperData = {}
local this = QiJiHelperData
this.LearnSkillKey = "FirstSkill"
this.QiJiHelper_PrefsKey = "QiJiHelper"
this.isAutoFight = false
this.SettingData = {
  KillMonsterScope = 4,
  StrikeBack = true,
  ReturnHome = {IsReturn = true, ReturnTime = 10},
  AddBuffToTeammate = false,
  AutoRecover = true,
  AutoTreat = true,
  selfSelSkills = {},
  selfSelSummonSkill = 0,
  buffSkill = {},
  recoverHp = 0.7,
  recoverMp = 0.2,
  selectPickupType = AutoPickupEnum.SelectPart,
  cantPickupTypes = {}
}
this.nextReturnHomeTime = 0
this.meCellPos = Vector2(0, 0)
this.selfSelSkillTab = {}
this.buffSkillTab = {}
this.pickupTab = {}
this.treatSkill = 0
this.groupSkillPos = nil
this.groupSkillMonsterId = nil
this.groupSkillId = nil
this.selectRoleId = nil
this.targetCell = nil
this.autoPickupDelay = nil
this.limitSelectMonsterLevel = nil
this.pressSkillId = nil
this.openReturnHome = false
this.teammateBuffSkillId = 0
this.teammateRoleId = 0
this.summonMonsterId = 0
this.isReconnect = false
this.openStartTime = nil
this.NeedHasBuffSkill = {}
this.SilenceBuff = {}

function QiJiHelperData.Reset()
  this.SettingData = {
    KillMonsterScope = 4,
    StrikeBack = true,
    ReturnHome = {IsReturn = true, ReturnTime = 10},
    AddBuffToTeammate = false,
    AutoRecover = true,
    AutoTreat = true,
    selfSelSkills = {},
    selfSelSummonSkill = 0,
    buffSkill = {},
    recoverHp = 0.7,
    recoverMp = 0.2,
    selectPickupType = AutoPickupEnum.SelectPart,
    cantPickupTypes = {}
  }
  this.nextReturnHomeTime = 0
  this.meCellPos = Vector2(0, 0)
  this.selfSelSkillTab = {}
  this.buffSkillTab = {}
  this.pickupTab = {}
  this.treatSkill = 0
  this.groupSkillPos = nil
  this.groupSkillId = nil
  this.selectRoleId = nil
  this.isReconnect = false
end

function QiJiHelperData.SetDefaultAutoFight()
  this.SettingData = {
    KillMonsterScope = 4,
    StrikeBack = true,
    ReturnHome = {IsReturn = true, ReturnTime = 10},
    AddBuffToTeammate = false,
    AutoRecover = true,
    AutoTreat = true,
    selfSelSkills = {},
    selfSelSummonSkill = 0,
    buffSkill = {},
    recoverHp = 0.7,
    recoverMp = 0.2,
    selectPickupType = this.SettingData.selectPickupType,
    cantPickupTypes = this.SettingData.cantPickupTypes
  }
end

function QiJiHelperData.SetDefaultAutoPickup()
  this.SettingData.selectPickupType = AutoPickupEnum.SelectPart
  this.SettingData.cantPickupTypes = {}
  this.SetPickUpType()
end

function QiJiHelperData.Init()
  this.limitSelectMonsterLevel = tonumber(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390013))
  QiJiHelperData.SetNeedHasBuffSkill()
end

function QiJiHelperData.InitAutoFight()
  this.Reset()
  this.LoadSettings()
  this.meCellPos = ViewData.meData.serverCoord:Clone()
end

function QiJiHelperData.SetFirstLearnSkill(skillId)
  local roleid = tostring(ViewData.meData.id)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local isFirstLearn = PlayerPrefs.GetInt(roleid .. this.LearnSkillKey .. skillData.groupId, ESkillFirstLearnType.None)
  if isFirstLearn == ESkillFirstLearnType.None then
    PlayerPrefs.SetInt(roleid .. this.LearnSkillKey .. skillData.groupId, ESkillFirstLearnType.First)
  elseif isFirstLearn == ESkillFirstLearnType.First then
    PlayerPrefs.SetInt(roleid .. this.LearnSkillKey .. skillData.groupId, ESkillFirstLearnType.Second)
  end
end

function QiJiHelperData.IsFirstLearnSkill(skillId)
  local roleid = tostring(ViewData.meData.id)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local isFirstLearn = PlayerPrefs.GetInt(roleid .. this.LearnSkillKey .. skillData.groupId, ESkillFirstLearnType.None)
  if isFirstLearn == ESkillFirstLearnType.First then
    return true
  else
    return false
  end
end

function QiJiHelperData.AddSelfSelectSkill(id)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
  if skillData.autoSkillType == AutoSkillEnum.SummonSkill then
    if this.SettingData.selfSelSummonSkill ~= 0 then
      local summonSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(this.SettingData.selfSelSummonSkill)
      if summonSkill.groupId == skillData.groupId then
        this.SettingData.selfSelSummonSkill = id
      elseif summonSkill.level ~= skillData.level then
        this.SettingData.selfSelSummonSkill = summonSkill.level > skillData.level and summonSkill.id or id
      elseif summonSkill.autoSkillPriority ~= skillData.autoSkillPriority then
        this.SettingData.selfSelSummonSkill = summonSkill.autoSkillPriority < skillData.autoSkillPriority and summonSkill.id or id
      elseif this.IsFirstLearnSkill(id) then
        this.SettingData.selfSelSummonSkill = id
      end
    else
      this.SettingData.selfSelSummonSkill = id
    end
  end
  if skillData.autoSkillType == AutoSkillEnum.TreatSkill then
    if this.treatSkill ~= 0 then
      local treatSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(this.treatSkill)
      if treatSkill.groupId == skillData.groupId then
        this.treatSkill = id
      elseif treatSkill.autoSkillPriority < skillData.autoSkillPriority then
        this.treatSkill = id
      end
    else
      this.treatSkill = id
    end
  end
  if skillData.autoSkillType == AutoSkillEnum.BuffSkill and not this.SettingData.buffSkill[tostring(skillData.groupId)] then
    this.SettingData.buffSkill[tostring(skillData.groupId)] = {
      groupId = skillData.groupId,
      isOpen = true
    }
  end
  if this.IsSelfSelectSkill(id) and not this.SettingData.selfSelSkills[tostring(skillData.groupId)] then
    this.SettingData.selfSelSkills[tostring(skillData.groupId)] = {
      groupId = skillData.groupId,
      isOpen = true
    }
  end
end

function QiJiHelperData.AddAutoSkill(id, isNeedSort)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
  if not skillData then
    return
  end
  if this.IsSelfSelectSkill(id) then
    local selfSelSkill = this.GetSelfSelSkill(tostring(skillData.groupId))
    if selfSelSkill and selfSelSkill.isOpen then
      this.UpdateSkillTab(this.selfSelSkillTab, id, isNeedSort)
    end
  end
  if skillData.autoSkillType == AutoSkillEnum.BuffSkill then
    local selfBuffSkill = this.GetBuffSkill(tostring(skillData.groupId))
    if selfBuffSkill and selfBuffSkill.isOpen then
      this.UpdateSkillTab(this.buffSkillTab, id, isNeedSort)
    end
  end
end

function QiJiHelperData.SortSelfSelTab(selfSelSkills, skillId)
  table.sort(selfSelSkills, function(a, b)
    if a.autoSkillPriority ~= b.autoSkillPriority then
      return a.autoSkillPriority < b.autoSkillPriority
    else
      if not skillId then
        return false
      end
      local resA = this.IsFirstLearnSkill(a.id)
      local resB = this.IsFirstLearnSkill(b.id)
      if resA and resB then
        return skillId == a.id
      end
      return resA
    end
  end)
end

function QiJiHelperData.UpdateSkillTab(skills, id, isNeedSort)
  local skill = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
  for i, v in ipairs(skills) do
    local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    if skill.groupId == skillData.groupId then
      skills[i] = skill
      return
    end
  end
  table.insert(skills, skill)
  if isNeedSort then
    this.SortSelfSelTab(skills, id)
  end
end

function QiJiHelperData.SetNeedHasBuffSkill()
  local buffInfo = ClientTable.cfg_Global_globalManager:TryGetValue(16010102).effect
  local buffs = string.split(buffInfo, "&")
  for i, v in pairs(buffs) do
    local skillForm = string.split(v, "#")
    this.NeedHasBuffSkill[tonumber(skillForm[1])] = tonumber(skillForm[2])
  end
  local Silence = ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2430019)
  local info = string.split(Silence, "#")
  for i, v in pairs(info) do
    this.SilenceBuff[tonumber(v)] = tonumber(v)
  end
end

function QiJiHelperData.CheckUseSkillHasBuffCondition(skillInfo)
  if table.count(this.NeedHasBuffSkill) == 0 or skillInfo == nil or string.isNullOrEmpty(skillInfo.skillForm) then
    return true
  end
  if skillInfo.skillForm and not string.isNullOrEmpty(skillInfo.skillForm) and skillInfo.skillForm ~= "0" then
    local skillForm = tonumber(skillInfo.skillForm)
    return BuffData.IsHasBuffStateByGroupId(RoleManager.me.id, this.NeedHasBuffSkill[skillForm])
  end
  return true
end

function QiJiHelperData.CheckSilence()
  local silence = false
  for i, v in pairs(this.SilenceBuff) do
    if BuffData.IsHasBuffStateByGroupId(RoleManager.me.id, v) then
      silence = true
      break
    end
  end
  return silence
end

function QiJiHelperData.IsNotAutoUseSkill(skill)
  if QiJiHelperData.CheckSilence() then
    return false
  end
  if skill == nil or skill.autoType == nil or skill.autoType == "" then
    if RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SummonMagician then
      local buffSkill = this.CheckUseSkillHasBuffCondition(skill)
      if not buffSkill then
        return false
      end
    end
    return true
  end
  local autoTypeList = string.split(skill.autoType, "#")
  for i, v in pairs(autoTypeList) do
    if RoleUtility.GetCurrentCareerCategory(skill, v) == tonumber(v) then
      if RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SummonMagician then
        local buffSkill = this.CheckUseSkillHasBuffCondition(skill)
        if buffSkill then
          return true
        end
      end
      return false
    end
  end
  return true
end

function QiJiHelperData.GetCareerNameDes()
  local nowcareerId = RoleUtility.GetCurrentCareerCategory()
  if QiJiHelperData.CareerNameDesGlobleDic == nil then
    QiJiHelperData.CareerNameDesGlobleDic = {}
    local temp = ClientTable.cfg_Global_globalManager:TryGetValue(2430016)
    if temp ~= nil and temp.effect ~= nil then
      local strS = string.split(temp.effect, "&")
      if strS ~= nil then
        for i, v in pairs(strS) do
          local CareerNameDesItem = string.split(v, "_")
          if CareerNameDesItem ~= nil and #CareerNameDesItem == 2 then
            local career = tonumber(CareerNameDesItem[1])
            QiJiHelperData.CareerNameDesGlobleDic[career] = CareerNameDesItem[2]
          end
        end
      end
    end
  end
  local des = QiJiHelperData.CareerNameDesGlobleDic[nowcareerId]
  if des == nil then
    return ""
  else
    return des
  end
end

function QiJiHelperData.RemoveAutoSkill(id)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
  if not skillData then
    return
  end
  if this.IsSelfSelectSkill(id) then
    this.RemoveSkill(this.selfSelSkillTab, id)
  end
  if skillData.autoSkillType == AutoSkillEnum.BuffSkill then
    this.RemoveSkill(this.buffSkillTab, id)
  end
end

function QiJiHelperData.RemoveSelfSelectSkill(id)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(id)
  if not skillData then
    return
  end
  if skillData.autoSkillType == AutoSkillEnum.SummonSkill and this.SettingData.selfSelSummonSkill ~= 0 then
    local summonSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(this.SettingData.selfSelSummonSkill)
    if summonSkill.id == skillData.id then
      this.SettingData.selfSelSummonSkill = 0
      this.SetMeSelfSelSummonSkill()
    end
  end
  if skillData.autoSkillType == AutoSkillEnum.TreatSkill and this.treatSkill then
    local treatSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(this.treatSkill)
    if treatSkill ~= nil and treatSkill.id == skillData.id then
      this.treatSkill = 0
    end
  end
  if skillData.autoSkillType == AutoSkillEnum.BuffSkill and this.SettingData.buffSkill[tostring(skillData.groupId)] then
    this.SettingData.buffSkill[tostring(skillData.groupId)] = nil
  end
  if this.IsSelfSelectSkill(id) and this.SettingData.selfSelSkills[tostring(skillData.groupId)] then
    this.SettingData.selfSelSkills[tostring(skillData.groupId)] = nil
  end
end

function QiJiHelperData.SetSettings(settingsData)
  for k, v in pairs(settingsData) do
    this.SettingData[k] = v
  end
end

function QiJiHelperData.IsContainBuffSkill(skillGroupId)
  if this.SettingData.buffSkill[tostring(skillGroupId)] then
    return true
  end
  return false
end

function QiJiHelperData.GetBuffSkill(skillGroupId)
  return this.SettingData.buffSkill[tostring(skillGroupId)]
end

function QiJiHelperData.CloseBuffSkill(skillId)
  local skillGroupId = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId).groupId
  this.SettingData.buffSkill[tostring(skillGroupId)].isOpen = false
  this.RemoveSkill(this.buffSkillTab, skillId)
end

function QiJiHelperData.OpenBuffSkill(skillId)
  local skillGroupId = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId).groupId
  this.SettingData.buffSkill[tostring(skillGroupId)].isOpen = true
  this.AddSkill(this.buffSkillTab, skillId)
end

function QiJiHelperData.IsContainSelfSelSkill(skillGroupId)
  if this.SettingData.selfSelSkills[tostring(skillGroupId)] then
    return true
  end
  return false
end

function QiJiHelperData.GetSelfSelSkill(skillGroupId)
  return this.SettingData.selfSelSkills[tostring(skillGroupId)]
end

function QiJiHelperData.CloseSelfSelSkill(skillId)
  local skillGroupId = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId).groupId
  this.SettingData.selfSelSkills[tostring(skillGroupId)].isOpen = false
  this.RemoveSkill(this.selfSelSkillTab, skillId)
end

function QiJiHelperData.OpenSelfSelSkill(skillId)
  local skillGroupId = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId).groupId
  this.SettingData.selfSelSkills[tostring(skillGroupId)].isOpen = true
  this.AddSkill(this.selfSelSkillTab, skillId)
end

function QiJiHelperData.RemoveSkill(skillTab, skillId)
  for i, v in ipairs(skillTab) do
    if v.id == skillId then
      table.remove(skillTab, i)
    end
  end
end

function QiJiHelperData.AddSkill(skillTab, skillId)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  for i, v in ipairs(skillTab) do
    if v.id == skillId then
      return
    end
  end
  table.insert(skillTab, skillData)
  this.SortSelfSelTab(skillTab, skillId)
end

function QiJiHelperData.IsHasSkill(skillId)
  local resSkillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if not resSkillData then
    return false
  end
  for i, v in pairs(ViewData.meData.skills) do
    local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if skillData.groupId == resSkillData.groupId and skillId == v.sid then
      return true
    end
  end
  return false
end

function QiJiHelperData.SetMeSelfSelSummonSkill()
  local summonSkillPriority = 100000
  local summonSkill = this.SettingData.selfSelSummonSkill
  local isHasSkill = QiJiHelperData.IsHasSkill(summonSkill)
  summonSkill = isHasSkill and summonSkill or 0
  local resSelfSkill
  if summonSkill == 0 then
    for i, v in pairs(ViewData.meData.skills) do
      local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
      if skillData.autoSkillType == AutoSkillEnum.SummonSkill then
        if not resSelfSkill then
          resSelfSkill = skillData
          summonSkillPriority = skillData.autoSkillPriority
        elseif resSelfSkill.level < skillData.level then
          resSelfSkill = skillData
          summonSkillPriority = skillData.autoSkillPriority
        elseif summonSkillPriority < skillData.autoSkillPriority then
          resSelfSkill = skillData
          summonSkillPriority = skillData.autoSkillPriority
        end
      end
    end
    if resSelfSkill then
      summonSkill = resSelfSkill.id
      this.SettingData.selfSelSummonSkill = summonSkill
    end
  end
end

function QiJiHelperData.SetDefaultMeTreatSkill()
  local treatSkillPriority = 100000
  local treatSkill
  for i, v in pairs(ViewData.meData.skills) do
    local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if skillData.autoSkillType == AutoSkillEnum.TreatSkill and treatSkillPriority < skillData.autoSkillPriority then
      treatSkillPriority = skillData.autoSkillPriority
      treatSkill = v.sid
    end
  end
  if treatSkill then
    this.treatSkill = treatSkill
  end
end

function QiJiHelperData.SetMeSelfSelBuffSkill()
  for i, v in pairs(ViewData.meData.skills) do
    local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if skillData.autoSkillType == AutoSkillEnum.BuffSkill then
      if not this.IsContainBuffSkill(tostring(skillData.groupId)) then
        this.SettingData.buffSkill[tostring(skillData.groupId)] = {
          groupId = skillData.groupId,
          isOpen = true
        }
        this.AddAutoSkill(v.sid)
      else
        local buffSkill = this.GetBuffSkill(tostring(skillData.groupId))
        if buffSkill.isOpen then
          this.AddAutoSkill(v.sid)
        end
      end
    end
  end
  this.SortSelfSelTab(this.buffSkillTab)
end

function QiJiHelperData.SetCantPickupType(isCancel, dropItemType, rarity)
  if dropItemType == EItemType.Equipe then
    local rarityTab = string.split(rarity, "#")
    for i, v in ipairs(rarityTab) do
      local index = string.format("%d#%s", dropItemType, v)
      if isCancel then
        this.SettingData.cantPickupTypes[index] = nil
        this.pickupTab[index] = nil
      else
        this.SettingData.cantPickupTypes[index] = true
        this.pickupTab[index] = true
      end
    end
  elseif isCancel then
    this.SettingData.cantPickupTypes[tostring(dropItemType)] = nil
    this.pickupTab[tostring(dropItemType)] = nil
  else
    this.SettingData.cantPickupTypes[tostring(dropItemType)] = true
    this.pickupTab[tostring(dropItemType)] = true
  end
end

function QiJiHelperData.SetAutoFightData(isAutoFight)
  if isAutoFight and RoleManager.me.isDead then
    return
  end
  this.isAutoFight = isAutoFight
  if isAutoFight then
    this.meCellPos = Vector2Int(RoleManager.me.serverCoord.x, RoleManager.me.serverCoord.y)
    this.nextReturnHomeTime = Time.GetServerSecondTime() + this.SettingData.ReturnHome.ReturnTime
    this.groupSkillPos = nil
    this.groupSkillMonsterId = nil
    this.groupSkillId = nil
    this.selectRoleId = nil
    this.targetCell = nil
    this.autoPickupDelay = nil
    this.openReturnHome = false
    this.pressSkillId = nil
    this.openStartTime = Time.GetServerSecondTime()
  else
    this.openStartTime = nil
  end
  EventManager.Dispatch(Event.Role_AutoFightChange)
end

function QiJiHelperData.Save()
  local settings = {}
  for k, v in pairs(this.SettingData) do
    settings[k] = v
  end
  local settingsStr = json.encode(settings)
  local prefsKey = this.GetRolePrefsKey()
  PlayerPrefs.SetString(prefsKey, settingsStr)
end

function QiJiHelperData.GetRolePrefsKey()
  return this.QiJiHelper_PrefsKey .. ViewData.meData.id
end

function QiJiHelperData.LoadSettings()
  local prefsKey = this.GetRolePrefsKey()
  local settingsStr = PlayerPrefs.GetString(prefsKey)
  local settings
  if string.isNullOrEmpty(settingsStr) or settingsStr == "[]" then
    settings = QiJiHelperData.SettingData
  else
    settings = json.decode(settingsStr)
    this.SetSettings(settings)
  end
  if RoleUtility.GetBasicCareer(ViewData.meData.career) == ERoleCareer.Archer then
    this.SetMeSelfSelSummonSkill()
    this.SetDefaultMeTreatSkill()
  end
  this.SetSelfSelectSkills()
  this.SetMeSelfSelBuffSkill()
  this.SetPickUpType()
end

function QiJiHelperData.SetPickUpType()
  this.pickupTab = {}
  for k, v in pairs(this.SettingData.cantPickupTypes) do
    this.pickupTab[k] = v
  end
end

function QiJiHelperData.SetCantFakePickUpType(pickupType, isPickup)
  this.pickupTab[tostring(pickupType)] = isPickup
end

function QiJiHelperData.SetSelfSelectSkills()
  for i, v in pairs(ViewData.meData.skills) do
    local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if this.IsSelfSelectSkill(v.sid) then
      if not this.IsContainSelfSelSkill(tostring(skillData.groupId)) then
        this.SettingData.selfSelSkills[tostring(skillData.groupId)] = {
          groupId = skillData.groupId,
          isOpen = true
        }
        this.AddAutoSkill(v.sid)
      else
        local selfSelSkill = this.GetSelfSelSkill(tostring(skillData.groupId))
        if selfSelSkill.isOpen then
          this.AddAutoSkill(v.sid)
        end
      end
    end
  end
  this.SortSelfSelTab(this.selfSelSkillTab)
end

function QiJiHelperData.IsSelfSelectSkill(skillId)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if skillData.autoSkillType == AutoSkillEnum.SelfSelIndSkill or skillData.autoSkillType == AutoSkillEnum.SelfSelGroupSkill then
    return true
  end
  if skillData.autoSkillType == AutoSkillEnum.IndSkill or skillData.autoSkillType == AutoSkillEnum.GroupSkill then
    return true
  end
  if skillData.autoSkillType == AutoSkillEnum.CommonSkill then
    return true
  end
  return false
end

function QiJiHelperData.IsGroupSkill(skillId)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if skillData.autoSkillType == AutoSkillEnum.SelfSelGroupSkill or skillData.autoSkillType == AutoSkillEnum.GroupSkill then
    return true
  end
  if skillData.autoSkillType == AutoSkillEnum.CommonSkill then
    return true
  end
  return false
end

function QiJiHelperData.IsIndSkill(skillId)
  local skillData = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if skillData.autoSkillType == AutoSkillEnum.IndSkill or skillData.autoSkillType == AutoSkillEnum.SelfSelIndSkill then
    return true
  end
  if skillData.autoSkillType == AutoSkillEnum.CommonSkill then
    return true
  end
  return false
end

function QiJiHelperData.IsCanSetBuffSkillToTeammate(role)
  for k, v in ipairs(this.buffSkillTab) do
    local tblSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.id)
    local tblAction = ConfigManager.GetConfig("cfg_actionLogic", tblSkill.actionId, "groupId")
    if tblSkill.buff ~= "" and SkillUtility.IsDontNeedTargetSkill(v.id) and ConditionalMgr:CanReleaseSkillNoSkillRange(tblSkill, tblAction) and not RoleTargetManager.IsTargetNotHasBuff(role, tblSkill.buff) then
      this.teammateBuffSkillId = v.id
      return true
    end
  end
  return false
end

function QiJiHelperData.SetBuffTeammateRole(roleId)
  this.teammateRoleId = roleId
end

function QiJiHelperData.SetReconnectState(state)
  if this.isReconnect and not RoleManager.me:IsCurSafeZone() then
    RoleManager.me:SetAutoTaskFight(AutoFightStrKey.AutoFight)
  end
  this.isReconnect = state
end

function QiJiHelperData.EquipRemoveAutoSkill(skillId)
  this.RemoveAutoSkill(skillId)
  this.RemoveSelfSelectSkill(skillId)
  this.Save()
end

function QiJiHelperData.SetPressSkill(skillId)
  this.pressSkillId = skillId
end

function QiJiHelperData.SetSummonMonsterId(monsterId)
  this.summonMonsterId = monsterId
end

function QiJiHelperData.SetAutoReturnHome(isAutoReturnHome)
  this.openReturnHome = isAutoReturnHome
end

function QiJiHelperData.SetSelectRoleId(selectRoleId)
  if this.selectRoleId and not selectRoleId then
    this.nextReturnHomeTime = Time.GetServerSecondTime()
  end
  this.selectRoleId = selectRoleId
  EventManager.Dispatch(Event.AutoFightPvpModeChange)
end

function QiJiHelperData.LearnSkill(skillId)
  this.SetFirstLearnSkill(skillId)
  this.AddSelfSelectSkill(skillId)
  this.AddAutoSkill(skillId, true)
  this.Save()
end

function QiJiHelperData.ForgetSkill(skillId)
  this.RemoveAutoSkill(skillId)
  this.RemoveSelfSelectSkill(skillId)
  this.Save()
end

function QiJiHelperData.SetOpenStartTime(openTime)
  this.openStartTime = openTime
end

function QiJiHelperData.ResetOpenStartTime()
  this.openStartTime = Time.GetServerSecondTime()
end

this.Init()
