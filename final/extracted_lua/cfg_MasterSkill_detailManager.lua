local cfg_MasterSkill_detailManager = {}

function cfg_MasterSkill_detailManager:GetName()
  return "cfg_MasterSkill_detailManager"
end

function cfg_MasterSkill_detailManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_MasterSkill_detail")
  end
  return self.dic
end

setmetatable(cfg_MasterSkill_detailManager, TableManagerBase)

function cfg_MasterSkill_detailManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_MasterSkill_detailManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_MasterSkill_detailManager:PSTypeDic()
  if self.mPSTypeDic == nil then
    self:InitAllConfig()
  end
  return self.mPSTypeDic
end

function cfg_MasterSkill_detailManager:USTypeDic()
  if self.mUSTypeDic == nil then
    self:InitAllConfig()
  end
  return self.mUSTypeDic
end

function cfg_MasterSkill_detailManager:SkillGroupInfoDic()
  if self.mSkillGroupInfoDic == nil then
    self:InitAllConfig()
  end
  return self.mSkillGroupInfoDic
end

function cfg_MasterSkill_detailManager:FirstSkillIdDic()
  if self.mFirstSkillIdDic == nil then
    self:InitAllConfig()
  end
  return self.mFirstSkillIdDic
end

function cfg_MasterSkill_detailManager:InitalizeParam()
  self.mPSTypeDic = {}
  self.mUSTypeDic = {}
  self.mSkillGroupInfoDic = {}
  self.mFirstSkillIdDic = {}
end

function cfg_MasterSkill_detailManager:InitAllConfig()
  self:InitalizeParam()
  for i, v in pairs(self:GetDic()) do
    self:ForeachCallBack(v)
  end
  self:ForeachEndCallBack()
end

function cfg_MasterSkill_detailManager:ForeachCallBack(tbl)
  if tbl == nil then
    return
  end
  self:TrySetPSAndUSInfoGsGs(tbl)
  self:SetSkillGroupInfo(tbl)
  self:SetSkillFirstId(tbl)
end

function cfg_MasterSkill_detailManager:TrySetPSAndUSInfoGsGs(tbl)
  local careers = TableParse:SplitStringToIntList(tbl.career, "#")
  for i, v in pairs(careers) do
    if tbl.talentType == MasterSkillTalentTypeEnum.PS then
      self:SetPSInfo(v, {
        code = tbl.type,
        name = tbl.typeNameRes
      })
    elseif tbl.talentType == MasterSkillTalentTypeEnum.US then
      self:SetUSInfo(v, {
        code = tbl.type,
        name = tbl.typeNameRes
      })
    end
  end
end

function cfg_MasterSkill_detailManager:SetPSInfo(career, info)
  if self.mPSTypeDic[career] ~= nil then
    for i, v in pairs(self.mPSTypeDic[career]) do
      if v.code == info.code then
        return
      end
    end
  else
    self.mPSTypeDic[career] = {}
  end
  table.insert(self.mPSTypeDic[career], info)
end

function cfg_MasterSkill_detailManager:SetUSInfo(career, info)
  if self.mUSTypeDic[career] ~= nil then
    for i, v in pairs(self.mUSTypeDic[career]) do
      if v.code == info.code then
        return
      end
    end
  else
    self.mUSTypeDic[career] = {}
  end
  table.insert(self.mUSTypeDic[career], info)
end

function cfg_MasterSkill_detailManager:SetSkillGroupInfo(tbl)
  if self.mSkillGroupInfoDic[tbl.type] ~= nil then
    for i, v in pairs(self.mSkillGroupInfoDic[tbl.type]) do
      if v.skillGroup == tbl.masterSkillGroup then
        return
      end
    end
  else
    self.mSkillGroupInfoDic[tbl.type] = {}
  end
  table.insert(self.mSkillGroupInfoDic[tbl.type], {
    skillGroup = tbl.masterSkillGroup,
    order = tbl.order
  })
end

function cfg_MasterSkill_detailManager:SetSkillFirstId(tbl)
  if tbl.masterSkillLevel ~= 0 then
    return
  end
  self.mFirstSkillIdDic[tbl.masterSkillGroup] = tbl.id
end

function cfg_MasterSkill_detailManager:ForeachEndCallBack()
  function self.psSortRule(a, b)
    return a and b and a.code < b.code
  end
  
  for i, v in pairs(self.mPSTypeDic) do
    table.sort(v, self.psSortRule)
  end
  
  function self.groupIdSortRule(a, b)
    return a and b and a.order < b.order
  end
  
  for i, v in pairs(self.mSkillGroupInfoDic) do
    table.sort(v, self.groupIdSortRule)
  end
end

function cfg_MasterSkill_detailManager:GetCurCareerSkillTbl()
  if RoleManager.me == nil then
    return nil
  end
  local career = RoleUtility.GetBasicCareer(RoleManager.me.career)
  return self:PSTypeDic()[career], self:USTypeDic()[career]
end

function cfg_MasterSkill_detailManager:GetSkillIdsBySkillGroup(type)
  if type == nil then
    return nil
  end
  return self:SkillGroupInfoDic()[type]
end

function cfg_MasterSkill_detailManager:GetSkillFirstIdBySkillGroup(groupId)
  if groupId == nil then
    return nil
  end
  return self:FirstSkillIdDic()[groupId]
end

function cfg_MasterSkill_detailManager:GetCurItemTipsIDByLid(lid)
  if lid == nil then
    return 20220901
  end
  local cfg = self:TryGetValue(lid)
  local itemTipsID = cfg and cfg.skillDesc or ""
  return tonumber(string.isNullOrEmpty(itemTipsID) == false and itemTipsID or "20220901")
end

function cfg_MasterSkill_detailManager:LineDic()
  if self.mLineDic == nil then
    self.mLineDic = {}
  end
  return self.mLineDic
end

function cfg_MasterSkill_detailManager:GetLineTblByLid(lid)
  local curTbl = self:TryGetValue(lid)
  if curTbl == nil then
    return nil
  end
  return self:GetLineTblBySkillGroup(curTbl.masterSkillGroup)
end

function cfg_MasterSkill_detailManager:GetLineTblBySkillGroup(group)
  if group == nil then
    return nil
  end
  if self:LineDic()[group] == nil then
    local targetId = self:GetSkillFirstIdBySkillGroup(group)
    if targetId then
      self:LineDic()[group] = self:ParesLineDataById(targetId)
    end
  end
  return self:LineDic()[group]
end

function cfg_MasterSkill_detailManager:ParesLineDataById(id)
  local masterSkillTbl = self:TryGetValue(id)
  if masterSkillTbl == nil or masterSkillTbl.connection == nil or masterSkillTbl.connection == "" then
    return nil
  end
  local sepTbl = {}
  local newTbl = {}
  local lineTbl = {}
  local num = 0
  local pattern = string.format("([^%s]+)", "|")
  string.gsub(masterSkillTbl.connection, pattern, function(c)
    table.insert(sepTbl, c)
  end)
  pattern = string.format("([^%s]+)", "&")
  for i, v in pairs(sepTbl) do
    string.gsub(v, pattern, function(c)
      table.insert(newTbl, c)
    end)
  end
  pattern = string.format("([^%s]+)", "#")
  local count = table.count(newTbl)
  for i = 1, count do
    if newTbl[i] and newTbl[i + 1] and i & 1 == 1 then
      local startTbl = {}
      local endTbl = {}
      string.gsub(newTbl[i], pattern, function(c)
        num = tonumber(c)
        table.insert(startTbl, num or 0)
      end)
      string.gsub(newTbl[i + 1], pattern, function(c)
        num = tonumber(c)
        table.insert(endTbl, num or 0)
      end)
      if 1 < table.count(startTbl) and 1 < table.count(endTbl) then
        table.insert(lineTbl, {
          startPoint = Vector3(startTbl[1], startTbl[2], startTbl[3] or 0),
          endPoint = Vector3(endTbl[1], endTbl[2], endTbl[3] or 0),
          skillGroup = masterSkillTbl.masterSkillGroup
        })
      end
    end
  end
  return lineTbl
end

return cfg_MasterSkill_detailManager
