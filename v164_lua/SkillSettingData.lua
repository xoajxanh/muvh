local PlayerPrefs = CS.UnityEngine.PlayerPrefs
SkillSettingData = {}
local this = SkillSettingData
SkillSettingData.skill_pan_all = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
SkillSettingData.skill_pan_turn = {
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0
}
SkillSettingData.skill_use_items = {
  0,
  0,
  0,
  0,
  0
}
SkillSettingData.hpPriorityId = {}
SkillSettingData.mpPriorityId = {}
SkillSettingData.manualItem = {
  0,
  0,
  0,
  0,
  0
}
SkillSettingData.maxSkillSetNum = 8
SkillSettingData.curmode = EPanModeType.Turn
SkillSettingData.SKILL_OP_MODE = "SkillOpMode"
SkillSettingData.SKILL_PAN_ALL = "SkillPanAll"
SkillSettingData.SKILL_PAN_TURN = "SkillPanTurn"
SkillSettingData.SKILL_USE_ITEM = "SkillUseItem"
SkillSettingData.MANUAL_ITEM = "ManualItem"

function SkillSettingData.Init()
  local roleid = tostring(ViewData.meData.id)
  SkillSettingData.curmode = PlayerPrefs.GetInt(roleid .. SkillSettingData.SKILL_OP_MODE, EPanModeType.Turn)
  local isHasKey = false
  for i = 1, #SkillSettingData.skill_pan_all do
    if PlayerPrefs.HasKey(roleid .. SkillSettingData.SKILL_PAN_ALL .. i) and not isHasKey then
      isHasKey = PlayerPrefs.HasKey(roleid .. SkillSettingData.SKILL_PAN_ALL .. i)
    end
    local skillId = PlayerPrefs.GetInt(roleid .. SkillSettingData.SKILL_PAN_ALL .. i, 0)
    if skillId ~= 0 then
      local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
      if not cfg_skill then
        SkillSettingData.SetPanAllSkill(i, 0)
      elseif ViewData.meData.skills[cfg_skill.groupId] then
        local maxSkillId = ViewData.meData.skills[cfg_skill.groupId].sid
        SkillSettingData.SetPanAllSkill(i, maxSkillId)
      else
        SkillSettingData.SetPanAllSkill(i, 0)
      end
    else
      SkillSettingData.SetPanAllSkill(i, 0)
    end
  end
  for i = 1, #SkillSettingData.skill_pan_turn do
    if PlayerPrefs.HasKey(roleid .. SkillSettingData.SKILL_PAN_TURN .. i) then
      isHasKey = PlayerPrefs.HasKey(roleid .. SkillSettingData.SKILL_PAN_TURN .. i)
    end
    local skillId = PlayerPrefs.GetInt(roleid .. SkillSettingData.SKILL_PAN_TURN .. i, 0)
    if skillId ~= 0 then
      local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
      if not cfg_skill then
        SkillSettingData.skill_pan_turn[i] = 0
        SkillSettingData.SetPanTurnSkill(i, 0)
      elseif ViewData.meData.skills[cfg_skill.groupId] then
        local maxSkillId = ViewData.meData.skills[cfg_skill.groupId].sid
        SkillSettingData.SetPanTurnSkill(i, maxSkillId)
      else
        SkillSettingData.SetPanAllSkill(i, 0)
      end
    else
      SkillSettingData.SetPanTurnSkill(i, 0)
    end
  end
  for i = 1, #SkillSettingData.skill_use_items do
    SkillSettingData.skill_use_items[i] = PlayerPrefs.GetInt(roleid .. SkillSettingData.SKILL_USE_ITEM .. i, 0)
    if SkillSettingData.skill_use_items[i] ~= 0 then
      local cfg_item = ClientTable.cfg_Item_itemManager:TryGetValue(SkillSettingData.skill_use_items[i])
      if cfg_item == nil then
        SkillSettingData.skill_use_items[i] = 0
      end
    end
  end
  for i = 1, #SkillSettingData.manualItem do
    SkillSettingData.manualItem[i] = PlayerPrefs.GetInt(roleid .. SkillSettingData.MANUAL_ITEM .. i, 0)
    if SkillSettingData.manualItem[i] ~= 0 then
      local cfg_item = ClientTable.cfg_Item_itemManager:TryGetValue(SkillSettingData.manualItem[i])
      if cfg_item == nil then
        SkillSettingData.manualItem[i] = 0
      end
    end
  end
  this.InitRecoverPriority()
  this.InitAutoSetItemInfo()
  this.InitMeSkillPut(isHasKey)
end

function SkillSettingData.ResetManualItem()
  for i = 1, #SkillSettingData.manualItem do
    local manualItemId = SkillSettingData.manualItem[i]
    if manualItemId ~= 0 then
      local manualIndex = this.GetItemIndex(manualItemId)
      if manualIndex == -1 then
        SkillSettingData.manualItem[i] = 0
      end
    end
  end
end

function SkillSettingData.GetManualItemIndex(itemId)
  for i = 1, #SkillSettingData.manualItem do
    if SkillSettingData.manualItem[i] == itemId then
      return i
    end
  end
  return -1
end

function SkillSettingData.SetManualItem(index, itemId)
  if index < 1 or index > #SkillSettingData.manualItem then
    return
  end
  SkillSettingData.manualItem[index] = itemId
  local roleid = tostring(ViewData.meData.id)
  PlayerPrefs.SetInt(roleid .. SkillSettingData.MANUAL_ITEM .. index, itemId)
end

function SkillSettingData.InitMeSkillPut(isHasKey)
  if isHasKey then
    return
  end
  for i, v in pairs(ViewData.meData.skills) do
    local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(v.sid)
    if cfg_skill.put > 0 then
      local skillPanIndex = this.GetPutSkillIndex(v.sid, this.skill_pan_all)
      if skillPanIndex ~= -1 then
        this.SetPanAllSkill(skillPanIndex, v.sid)
        this.SetPanTurnSkill(skillPanIndex, v.sid)
      end
    end
  end
end

function SkillSettingData.InitRecoverPriority()
  local hpPriority = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390004), "&")
  local mpPriority = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390005), "&")
  this.hpPriorityId = {}
  for i, v in ipairs(hpPriority) do
    this.hpPriorityId[tonumber(v)] = i
  end
  this.mpPriorityId = {}
  for i, v in ipairs(mpPriority) do
    this.mpPriorityId[tonumber(v)] = i
  end
end

function SkillSettingData.InitAutoSetItemInfo()
  local autoSetItemInfos = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2390006), "&")
  this.autoSetItemId = {}
  for i, v in ipairs(autoSetItemInfos) do
    this.autoSetItemId[tonumber(v)] = true
  end
end

function SkillSettingData.SetPanMode(modeindex)
  if modeindex == 0 or modeindex == 1 then
    if SkillSettingData.curmode == modeindex then
      return
    end
    SkillSettingData.curmode = modeindex
    local roleid = tostring(ViewData.meData.id)
    PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_OP_MODE, modeindex)
  end
end

function SkillSettingData.SetPanAllSkill(index, skillid)
  if index < 1 or index > #SkillSettingData.skill_pan_all or SkillSettingData.skill_pan_all[index] == skillid then
    return
  end
  local skillPanInfo = ClientTable.cfg_Skill_skillManager:TryGetValue(skillid)
  if skillPanInfo and skillPanInfo.skillPan == 1 then
    return
  end
  SkillSettingData.skill_pan_all[index] = skillid
  local roleid = tostring(ViewData.meData.id)
  PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_PAN_ALL .. index, skillid)
end

function SkillSettingData.SetPanTurnSkill(index, skillid)
  if index < 1 or index > #SkillSettingData.skill_pan_turn or SkillSettingData.skill_pan_turn[index] == skillid then
    return
  end
  local skillPanInfo = ClientTable.cfg_Skill_skillManager:TryGetValue(skillid)
  if skillPanInfo and skillPanInfo.skillPan == 1 then
    return
  end
  SkillSettingData.skill_pan_turn[index] = skillid
  local roleid = tostring(ViewData.meData.id)
  PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_PAN_TURN .. index, skillid)
end

function SkillSettingData.GetSkillIdIndex(skillId, skillTable)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  for i, v in pairs(skillTable) do
    if v ~= 0 then
      local skillTab = ClientTable.cfg_Skill_skillManager:TryGetValue(v)
      if skillTab.groupId == cfg_skill.groupId then
        return i
      end
    end
  end
  return -1
end

function SkillSettingData.GetCanPutSkillIdIndex(skillId, skillTable)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if cfg_skill.put == 0 then
    return -1
  end
  for i, v in pairs(skillTable) do
    if v ~= 0 then
      local skillTab = ClientTable.cfg_Skill_skillManager:TryGetValue(v)
      if skillTab.groupId == cfg_skill.groupId then
        return i
      end
    else
      return i
    end
  end
  return this.GetPutSkillIndex(skillId, skillTable)
end

function SkillSettingData.GetPutSkillIndex(skillId, skillTable)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local put = cfg_skill.put
  local index = put % 10
  local priority = Mathf.Floor(put / 10) > 0 and Mathf.Floor(put / 10) or put
  local oldSkillId = skillTable[index]
  if oldSkillId ~= 0 then
    local cfg_oldSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(oldSkillId)
    local oldPut = cfg_oldSkill.put
    local oldPriority = Mathf.Floor(oldPut / 10) > 0 and Mathf.Floor(oldPut / 10) or oldPut
    if priority > oldPriority then
      return index
    else
      return -1
    end
  else
    return index
  end
end

function SkillSettingData.SetHighAutoPrioritySkill(skillId, skillType, panSkillType)
  local panSkill = panSkillType == "panSkillAll" and SkillSettingData.skill_pan_all or SkillSettingData.skill_pan_turn
  local setSkillFunc = panSkillType == "panSkillAll" and SkillSettingData.SetPanAllSkill or SkillSettingData.SetPanTurnSkill
  local learnSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if learnSkillConfig.autoSkillType == skillType then
    local isHasSkill = false
    for i = 1, #panSkill do
      if panSkill[i] ~= 0 then
        local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(panSkill[i])
        if skillConfig.groupId == learnSkillConfig.groupId then
          setSkillFunc(i, skillId)
          isHasSkill = true
        end
      end
    end
    if not isHasSkill then
      for i = 1, #panSkill do
        if panSkill[i] ~= 0 then
          local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(panSkill[i])
          if skillConfig.autoSkillType == skillType and skillConfig.autoSkillPriority > learnSkillConfig.autoSkillPriority then
            setSkillFunc(i, skillId)
            return true
          end
        end
      end
    else
      return true
    end
    return false
  end
  return false
end

function SkillSettingData.SetHighSummonAutoPrioritySkill(skillId, skillType, panSkillType)
  local panSkill = panSkillType == "panSkillAll" and SkillSettingData.skill_pan_all or SkillSettingData.skill_pan_turn
  local setSkillFunc = panSkillType == "panSkillAll" and SkillSettingData.SetPanAllSkill or SkillSettingData.SetPanTurnSkill
  local learnSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if learnSkillConfig.autoSkillType == skillType then
    local isHasSkill = false
    for i = 1, #panSkill do
      if panSkill[i] ~= 0 then
        local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(panSkill[i])
        if skillConfig.groupId == learnSkillConfig.groupId then
          setSkillFunc(i, skillId)
          isHasSkill = true
        end
      end
    end
    if not isHasSkill then
      for i = 1, #panSkill do
        if panSkill[i] ~= 0 then
          local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(panSkill[i])
          if skillConfig.autoSkillType == skillType then
            if skillConfig.autoSkillPriority > learnSkillConfig.autoSkillPriority then
              setSkillFunc(i, skillId)
            end
            return true
          end
        end
      end
    else
      return true
    end
    return false
  end
  return false
end

function SkillSettingData.MagicHeiLongBoSpecialHandle(skillId, panSkillType)
  local learnSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  if learnSkillConfig.groupId ~= 12120100 then
    return false
  end
  local panSkill = panSkillType == "panSkillAll" and SkillSettingData.skill_pan_all or SkillSettingData.skill_pan_turn
  local setSkillFunc = panSkillType == "panSkillAll" and SkillSettingData.SetPanAllSkill or SkillSettingData.SetPanTurnSkill
  local isHasSkill = false
  for i = 1, #panSkill do
    if panSkill[i] ~= 0 then
      local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(panSkill[i])
      if skillConfig.groupId == learnSkillConfig.groupId then
        setSkillFunc(i, skillId)
        isHasSkill = true
      end
    end
  end
  if not isHasSkill then
    for i = 1, #panSkill do
      if panSkill[i] ~= 0 then
        local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(panSkill[i])
        if skillConfig.groupId == 12100100 then
          setSkillFunc(i, skillId)
          return true
        end
      end
    end
  else
    return true
  end
  return false
end

function SkillSettingData.SetPanSkillMagicType(skillId)
  local res = this.MagicHeiLongBoSpecialHandle(skillId, "panSkillAll")
  res = res or this.SetHighAutoPrioritySkill(skillId, AutoSkillEnum.SelfSelIndSkill, "panSkillAll")
  if not res then
    this.SetPanAllSkillWithNewData(skillId)
  end
  res = this.MagicHeiLongBoSpecialHandle(skillId, "panSkillTurn")
  if not res then
    this.SetHighAutoPrioritySkill(skillId, AutoSkillEnum.SelfSelIndSkill, "panSkillTurn")
  end
  if not res then
    this.SetPanTurnSkillWithNewData(skillId)
  end
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.SetPanSkillSwordType(skillId)
  this.SetPanAllSkillWithNewData(skillId)
  this.SetPanTurnSkillWithNewData(skillId)
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.SetPanSkillSummonType(skillId)
  this.SetPanAllSkillWithNewData(skillId)
  this.SetPanTurnSkillWithNewData(skillId)
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.SetPanSkillSpellSwordType(skillId)
  this.SetPanAllSkillWithNewData(skillId)
  this.SetPanTurnSkillWithNewData(skillId)
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.SetPanSkillArcherType(skillId)
  local res
  res = this.SetHighSummonAutoPrioritySkill(skillId, AutoSkillEnum.SummonSkill, "panSkillAll")
  if not res then
    this.SetPanAllSkillWithNewData(skillId)
  end
  res = this.SetHighSummonAutoPrioritySkill(skillId, AutoSkillEnum.SummonSkill, "panSkillTurn")
  if not res then
    this.SetPanTurnSkillWithNewData(skillId)
  end
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.SetPanAllSkillWithNewData(skillId)
  local learnSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local isHasSkill = false
  for i = 1, #this.skill_pan_all do
    if this.skill_pan_all[i] ~= 0 then
      local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(this.skill_pan_all[i])
      if skillConfig.groupId == learnSkillConfig.groupId then
        this.SetPanAllSkill(i, skillId)
        isHasSkill = true
      end
    end
  end
  if not isHasSkill then
    local index = this.GetCanPutSkillIdIndex(skillId, SkillSettingData.skill_pan_all)
    if index ~= -1 then
      this.SetPanAllSkill(index, skillId)
    end
  end
end

function SkillSettingData.SetPanTurnSkillWithNewData(skillId)
  local learnSkillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  local isHasSkill = false
  for i = 1, #this.skill_pan_turn do
    if this.skill_pan_turn[i] ~= 0 then
      local skillConfig = ClientTable.cfg_Skill_skillManager:TryGetValue(this.skill_pan_turn[i])
      if skillConfig.groupId == learnSkillConfig.groupId then
        this.SetPanTurnSkill(i, skillId)
        isHasSkill = true
      end
    end
  end
  if not isHasSkill then
    local index = this.GetCanPutSkillIdIndex(skillId, SkillSettingData.skill_pan_all)
    if index ~= -1 then
      this.SetPanTurnSkill(index, skillId)
    end
  end
end

function SkillSettingData.SetPanSkillWhenLearnNewSkill(skillId)
  if RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.Magic then
    this.SetPanSkillMagicType(skillId)
  elseif RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.Archer then
    this.SetPanSkillArcherType(skillId)
  elseif RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SwordMan then
    this.SetPanSkillSwordType(skillId)
  elseif RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SummonMagician then
    this.SetPanSkillSummonType(skillId)
  elseif RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SpellSword then
    this.SetPanSkillSpellSwordType(skillId)
  end
end

function SkillSettingData.RemovePanAllSkill(skillId)
  local cfg_skill = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
  for i, v in pairs(SkillSettingData.skill_pan_all) do
    if v ~= 0 then
      local skillTab = ClientTable.cfg_Skill_skillManager:TryGetValue(v)
      if skillTab.groupId == cfg_skill.groupId then
        this.SetPanAllSkill(i, 0)
      end
    end
  end
  for i, v in pairs(SkillSettingData.skill_pan_turn) do
    if v ~= 0 then
      local skillTab = ClientTable.cfg_Skill_skillManager:TryGetValue(v)
      if skillTab.groupId == cfg_skill.groupId then
        this.SetPanTurnSkill(i, 0)
      end
    end
  end
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.SetItem(index, itemid)
  if index < 1 or index > #SkillSettingData.skill_use_items or SkillSettingData.skill_use_items[index] == itemid then
    return
  end
  SkillSettingData.skill_use_items[index] = itemid
  local roleid = tostring(ViewData.meData.id)
  PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_USE_ITEM .. index, itemid)
  this.ResetManualItem()
end

function SkillSettingData.GetItemIndex(itemId)
  for i, v in ipairs(SkillSettingData.skill_use_items) do
    if v == itemId then
      return i
    end
  end
  return -1
end

function SkillSettingData.GetSpaceItemIndex(itemId)
  for i, v in ipairs(SkillSettingData.skill_use_items) do
    if v == itemId then
      return -1
    end
  end
  for i, v in ipairs(SkillSettingData.skill_use_items) do
    if v == 0 then
      return i
    end
  end
  return -1
end

function SkillSettingData.Clear()
  SkillSettingData.skill_pan_all = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  SkillSettingData.skill_pan_turn = {
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  }
  SkillSettingData.skill_use_items = {
    0,
    0,
    0,
    0,
    0
  }
  local roleid = tostring(ViewData.meData.id)
  for index = 1, #SkillSettingData.skill_pan_all do
    PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_PAN_ALL .. index, 0)
  end
  for index = 1, #SkillSettingData.skill_pan_turn do
    PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_PAN_TURN .. index, 0)
  end
  for index = 1, #SkillSettingData.skill_use_items do
    PlayerPrefs.SetInt(roleid .. SkillSettingData.SKILL_USE_ITEM .. index, 0)
  end
  EventManager.Dispatch(Event.Skill_Pan_Changed)
end

function SkillSettingData.RefreshSkillData()
  this.Clear()
end
