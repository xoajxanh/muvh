local cfg_Skill_SkillPreviewManager = {}

function cfg_Skill_SkillPreviewManager:GetName()
  return "cfg_Skill_SkillPreviewManager"
end

function cfg_Skill_SkillPreviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Skill_SkillPreview")
  end
  return self.dic
end

setmetatable(cfg_Skill_SkillPreviewManager, TableManagerBase)

function cfg_Skill_SkillPreviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Skill_SkillPreviewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Skill_SkillPreviewManager:AllGroupIndexByCareerAndGroup()
  if self.mAllGroupIndexByCareerAndGroup == nil then
    self:InitializeData()
  end
  return self.mAllGroupIndexByCareerAndGroup
end

function cfg_Skill_SkillPreviewManager:AllGroupInfoDicByGroup()
  if self.mAllGroupInfoDicByGroup == nil then
    self:InitializeData()
  end
  return self.mAllGroupInfoDicByGroup
end

function cfg_Skill_SkillPreviewManager:AllSkillPreviewInfoDicById()
  if self.mAllSkillPreviewInfoDicById == nil then
    self.mAllSkillPreviewInfoDicById = {}
  end
  return self.mAllSkillPreviewInfoDicById
end

function cfg_Skill_SkillPreviewManager:AllSkillPosDicById()
  if self.mAllSkillPosDicById == nil then
    self.mAllSkillPosDicById = {}
  end
  return self.mAllSkillPosDicById
end

function cfg_Skill_SkillPreviewManager:InitializeData()
  self.mAllGroupIndexByCareerAndGroup = {}
  self.mAllGroupInfoDicByGroup = {}
  for i, v in pairs(self:GetDic()) do
    self:InitializeGroupIdList(v)
    self:InitializeGroupData(v)
  end
  self:SortData()
end

function cfg_Skill_SkillPreviewManager:InitializeGroupIdList(tbl)
  if self:AllGroupIndexByCareerAndGroup()[tbl.career] == nil then
    self:AllGroupIndexByCareerAndGroup()[tbl.career] = {}
  end
  if self:AllGroupIndexByCareerAndGroup()[tbl.career][tbl.type] == nil then
    self:AllGroupIndexByCareerAndGroup()[tbl.career][tbl.type] = {}
  end
  local groupId = self:GetGroup(tbl)
  for i2, v2 in pairs(self:AllGroupIndexByCareerAndGroup()[tbl.career][tbl.type]) do
    if v2.id == groupId then
      return
    end
  end
  table.insert(self:AllGroupIndexByCareerAndGroup()[tbl.career][tbl.type], {
    id = groupId,
    sort = tbl.sortid
  })
end

function cfg_Skill_SkillPreviewManager:InitializeGroupData(tbl)
  local groupData = self:AllGroupInfoDicByGroup()[self:GetGroup(tbl)]
  if groupData == nil then
    groupData = self:NewSkillPreviewGroupInfo(tbl)
    self:AllGroupInfoDicByGroup()[self:GetGroup(tbl)] = groupData
  end
  table.insert(groupData.idList, {
    id = tbl.id,
    sort = tbl.sortid
  })
end

function cfg_Skill_SkillPreviewManager:SortData()
  local function sortRule(l, r)
    return l and r and l.sort < r.sort
  end
  
  for i, v in pairs(self:AllGroupIndexByCareerAndGroup()) do
    for i2, v2 in pairs(v) do
      table.sort(v2, sortRule)
    end
  end
  for i, v in pairs(self:AllGroupInfoDicByGroup()) do
    table.sort(v.idList, sortRule)
  end
end

function cfg_Skill_SkillPreviewManager:GetGroupIdListByType(type)
  local mainPlayerCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
  local groupIdDic = self:AllGroupIndexByCareerAndGroup()[mainPlayerCareer]
  local zeroCareerDic = self:AllGroupIndexByCareerAndGroup()[0]
  if groupIdDic == nil and zeroCareerDic == nil then
    return
  end
  local groupIdList = {}
  if groupIdDic and groupIdDic[type] then
    groupIdList = table.copy(groupIdList, groupIdDic[type])
  end
  if zeroCareerDic and zeroCareerDic[type] then
    groupIdList = table.combine(groupIdList, zeroCareerDic[type])
  end
  return groupIdList
end

function cfg_Skill_SkillPreviewManager:GetGroupInfoByGroupId(groupId)
  return self:AllGroupInfoDicByGroup()[groupId]
end

function cfg_Skill_SkillPreviewManager:GetSKillPreviewInfoBySkillId(skillId)
  if self:AllSkillPreviewInfoDicById()[skillId] then
    return self:AllSkillPreviewInfoDicById()[skillId]
  end
  local tbl = self:TryGetValue(skillId)
  local skillData = self:NewSkillPreviewInfo(tbl)
  self:AllSkillPreviewInfoDicById()[tbl.id] = skillData
  return skillData
end

function cfg_Skill_SkillPreviewManager:GetSkillInfoByPageLevel(pageLevel, id)
  if pageLevel == 1 then
    return self:GetGroupInfoByGroupId(id)
  elseif pageLevel == 2 then
    return self:GetSKillPreviewInfoBySkillId(id)
  end
end

function cfg_Skill_SkillPreviewManager:GetDefaultSkillDataByMenuData(data)
  if data.preViewid ~= nil then
    return self:GetSKillPreviewInfoBySkillId(data.preViewid)
  end
  local groupIdList = self:GetGroupIdListByType(data.uiType)
  local groupInfo
  for i, v in pairs(groupIdList) do
    if v.id == data.group then
      groupInfo = self:GetGroupInfoByGroupId(v.id)
      break
    end
  end
  if groupInfo and groupInfo.idList then
    for i2, v2 in pairs(groupInfo.idList) do
      return ClientTable.cfg_Skill_SkillPreviewManager:GetSKillPreviewInfoBySkillId(v2.id)
    end
  end
end

function cfg_Skill_SkillPreviewManager:GetFirstSkillData(type)
  local groupIdList = self:GetGroupIdListByType(type)
  local groupInfo
  for i, v in pairs(groupIdList) do
    groupInfo = self:GetGroupInfoByGroupId(v.id)
    if groupInfo and groupInfo.idList then
      for i2, v2 in pairs(groupInfo.idList) do
        return ClientTable.cfg_Skill_SkillPreviewManager:GetSKillPreviewInfoBySkillId(v2.id)
      end
    end
  end
  return nil
end

function cfg_Skill_SkillPreviewManager:GetSkillPosConfigTblBySkillId(skillId)
  if self:AllSkillPosDicById()[skillId] == nil then
    local temp
    local tbl = self:TryGetValue(skillId)
    if tbl then
      temp = TableParse:SplitStringToIntList(tbl.skillPosition, "#")
    else
      temp = {}
    end
    self:AllSkillPosDicById()[skillId] = temp
  end
  return self:AllSkillPosDicById()[skillId]
end

function cfg_Skill_SkillPreviewManager:NewSkillPreviewGroupInfo(tbl)
  local temp = {}
  if tbl then
    temp.group = self:GetGroup(tbl)
    temp.pageLevel = 1
    temp.str = tbl.subOne
    temp.uiType = tbl.type
    temp.idList = {}
  end
  return temp
end

function cfg_Skill_SkillPreviewManager:NewSkillPreviewInfo(tbl)
  local temp = {}
  if tbl then
    temp.preViewid = tbl.id
    temp.pageLevel = 2
    temp.uiType = tbl.type
    temp.group = self:GetGroup(tbl)
    temp.str = tbl.subTwo
    temp.skillId = tbl.skillId
    temp.buffId = tbl.skillId
    temp.actionId = tbl.actionLogicId
  end
  return temp
end

function cfg_Skill_SkillPreviewManager:GetGroup(tbl)
  if tbl then
    return tbl.type * 1000 + tbl.career * 100 + tbl.group
  end
  return nil
end

return cfg_Skill_SkillPreviewManager
