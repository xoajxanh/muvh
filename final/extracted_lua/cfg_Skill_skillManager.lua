local cfg_Skill_skillManager = {}

function cfg_Skill_skillManager:GetName()
  return "cfg_Skill_skillManager"
end

function cfg_Skill_skillManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Skill_skill")
  end
  return self.dic
end

setmetatable(cfg_Skill_skillManager, TableManagerBase)

function cfg_Skill_skillManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Skill_skillManager:RuneAndSkillGroupDic()
  if self.mRuneAndSkillGroupDic == nil then
    self.mRuneAndSkillGroupDic = {}
  end
  return self.mRuneAndSkillGroupDic
end

function cfg_Skill_skillManager:InitializeRuneInfoById(skillId)
  local tbl = self:TryGetValue(skillId)
  if self:RuneAndSkillGroupDic()[tbl.groupId] ~= nil then
    return
  end
  self:RuneAndSkillGroupDic()[tbl.groupId] = TableParse:SplitStringToIntList(tbl.runes, "#")
end

function cfg_Skill_skillManager:GetRuneIndexBySkillId(skillId)
  local tbl = self:TryGetValue(skillId)
  if self:RuneAndSkillGroupDic()[tbl.groupId] == nil then
    self:InitializeRuneInfoById(skillId)
  end
  return self:RuneAndSkillGroupDic()[tbl.groupId]
end

function cfg_Skill_skillManager:GetSkillGroupTblByRuneIndex(runeIndex)
  return self:SkillGroupAndRuneDic()[runeIndex]
end

function cfg_Skill_skillManager:GetActionIdBySkillId(skillId)
  local tbl = self:TryGetValue(skillId)
  local runeList = self:GetRuneIndexBySkillId(skillId)
  local runeLevel, runeActivatedState, runeSuitTbl
  for i, v in pairs(runeList) do
    runeActivatedState = MeRunneController:GetSuitActiveState(v)
    if runeActivatedState then
      runeSuitTbl = ClientTable.cfg_Item_equip_runesSuitManager:TryGetValue(v)
      runeLevel = runeSuitTbl and runeSuitTbl.level or 0
    end
  end
  return self:GetSkillActionIdByRunLevel(tbl.actionId, runeLevel or 0)
end

function cfg_Skill_skillManager:GetSkillActionIdByRunLevel(baseAction, runeLevel)
  if runeLevel == 0 then
    return baseAction
  end
  local actionTbl
  for i = 0, runeLevel do
    actionTbl = ConfigManager.GetConfig("cfg_actionLogic", (runeLevel - i) * 1000 + baseAction, "groupId")
    if actionTbl ~= nil then
      return actionTbl.groupId
    end
  end
  return actionTbl.baseAction
end

function cfg_Skill_skillManager:GetActionIdByRuneLevelRule(runeLevel, baseAction)
  return runeLevel * 1000 + baseAction
end

return cfg_Skill_skillManager
