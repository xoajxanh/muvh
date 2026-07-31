local MasterSysData = {}
local this = MasterSysData
this.MasterType = 0
this.MasterLevel = 0
this.MasterExp = 0
this.MasterPoint = {}
this.MasterSkillConfig = {}
this.MasterExchangeTimes = 0
this.MasterExchangeAllTimes = 0
this.IsFree = false
this.MasterResetTimes = 0
this.MasterSkillClients = {}
this.MasterCurSkillClient = {}
this.MasterTypeTab = {}
this.LevelTable = nil
this.ExchangeTable = {}
this.ResetTable = {}
this.ChangePayTable = {}
this.MastertabTemp = {}
this.MasterSkilltabTemp = {}
this.SkilltabTemp = {}
this.SkillItemtabTemp = {}

function MasterSysData:Init()
  self:InitSkillTable()
  self:InitCurSkillInfo()
  self:InitExchangeInfo()
  self:InitResetInfo()
  self:InitChangePayInfo()
end

function MasterSysData:InitSkillTable()
  self.MasterSkillClients = {}
  for i, v in pairs(ClientTable.cfg_MasterSkill_detailManager:GetDic()) do
    if v.talentType == 1 then
      if self.MasterSkillClients[v.type] == nil then
        self.MasterSkillClients[v.type] = {
          [v.id] = v
        }
      else
        self.MasterSkillClients[v.type][v.id] = v
      end
    end
  end
end

function MasterSysData:InitCurSkillInfo()
  self.MasterCurSkillClient = {}
  for i, v in pairs(self.MasterCurSkillClient) do
    for k, va in pairs(v) do
      if va.masterSkillLevel == 0 then
        if self.MasterCurSkillClient[va.type] == nil then
          self.MasterCurSkillClient[va.type] = {
            [va.masterSkillGroup] = va
          }
        else
          self.MasterCurSkillClient[va.type][va.masterSkillGroup] = va
        end
      end
    end
  end
end

function MasterSysData:InitExchangeInfo()
  if self.ExchangeTable ~= nil and #self.ExchangeTable > 0 then
    return
  end
  self.ExchangeTable = {}
  local globe = ClientTable.cfg_Global_globalManager:TryGetValue(30000001)
  if globe then
    local str = string.split(globe.effect, "&")
    local tab = {}
    for i = 1, #str do
      local str2 = string.split(str[i], "#")
      if str2 ~= nil then
        tab = {}
        if 0 < #str2 then
          tab.id = tonumber(str2[1])
        end
        if 1 < #str2 then
          tab.needItem = tonumber(str2[2])
        end
        if 2 < #str2 then
          tab.needItemNum = tonumber(str2[3])
        end
        if 3 < #str2 then
          tab.getItem = tonumber(str2[4])
        end
        if 4 < #str2 then
          tab.getItemNum = tonumber(str2[5])
        end
        table.insert(self.ExchangeTable, tab)
      end
    end
  end
end

function MasterSysData:InitResetInfo()
  if self.ResetTable ~= nil and #self.ResetTable > 0 then
    return
  end
  self.ResetTable = {}
  local globe = ClientTable.cfg_Global_globalManager:TryGetValue(30000002)
  if globe then
    local str = string.split(globe.effect, "&")
    local tab = {}
    for i = 1, #str do
      local str2 = string.split(str[i], "#")
      if str2 ~= nil then
        tab = {}
        if 0 < #str2 then
          tab.needItem = tonumber(str2[1])
        end
        if 1 < #str2 then
          tab.num = tonumber(str2[2])
        end
        table.insert(self.ResetTable, tab)
      end
    end
  end
end

function MasterSysData:InitChangePayInfo()
  if self.ChangePayTable ~= nil and #self.ChangePayTable > 0 then
    return
  end
  self.ChangePayTable = {}
  local globe = ClientTable.cfg_Global_globalManager:TryGetValue(30000003)
  if globe then
    local str = string.split(globe.effect, "&")
    local tab = {}
    for i = 1, #str do
      local str2 = string.split(str[i], "#")
      if str2 ~= nil then
        tab = {}
        if 0 < #str2 then
          tab.needItem = tonumber(str2[1])
        end
        if 1 < #str2 then
          tab.num = tonumber(str2[2])
        end
        table.insert(self.ChangePayTable, tab)
      end
    end
  end
end

function MasterSysData:GetShowSkillTab(type)
  return self.MasterCurSkillClient[type]
end

function MasterSysData:GetShowPointInfo(type)
  if type == nil then
    type = self.MasterType
  end
  return self.MasterPoint[type]
end

function MasterSysData:GetShowSkillTabCount(type)
  return table.count(self.MasterCurSkillClient[type])
end

function MasterSysData:DealTogInfo()
  self.MasterTypeTab = {}
  for i, v in pairs(self.MasterCurSkillClient) do
    if math.modf(i) == QuickFind.LuaMainPlayerViewAttrData().career then
      for k, v2 in pairs(v) do
        self.MasterTypeTab[i] = v2
        break
      end
    end
  end
  return self.MasterTypeTab
end

function MasterSysData:GetLevelPro()
  self.LevelTable = ClientTable.cfg_MasterSkill_detailManager:TryGetValue(self.MasterLevel)
  return self.MasterExp / self.LevelTable.exp, self.MasterExp .. "/" .. self.LevelTable.exp
end

function MasterSysData:GetExchangeTab()
  return self.ExchangeTable
end

function MasterSysData:GetResetTab()
  if self.MasterResetTimes > 0 then
    return self.ResetTable[2]
  end
  return self.ResetTable[1]
end

function MasterSysData:GetChangeTab(type)
  return self.ChangePayTable[type]
end

function MasterSysData:GetSkillInfo(id)
  self.MasterSkilltabTemp = {}
  self.SkilltabTemp = {}
  self.SkillItemtabTemp = {}
  self.MastertabTemp = ClientTable.cfg_MasterSkill_detailManager:TryGetValue(id)
  if self.MastertabTemp then
    self.MasterSkilltabTemp.masterID = id
    self.MasterSkilltabTemp.curLevel = self.MastertabTemp.masterSkillLevel
    self.MasterSkilltabTemp.maxLevel = self.MastertabTemp.maxLevel
    self.MasterSkilltabTemp.needPoint = self.MastertabTemp.exPoint
    self.MasterSkilltabTemp.skillIcon = self.MastertabTemp.icon
    self.SkilltabTemp = ClientTable.cfg_Skill_skillManager:TryGetValue(self.MastertabTemp.skill)
    self.MasterSkilltabTemp.curName = self.SkilltabTemp.name
    self.SkillItemtabTemp = ClientTable.cfg_Item_tipsManager:TryGetValue(self.SkilltabTemp.description)
    if self.SkillItemtabTemp then
      self.MasterSkilltabTemp.curDes = self.SkillItemtabTemp.content
    end
    self.SkillItemtabTemp = ClientTable.cfg_Item_tipsManager:TryGetValue(self.SkilltabTemp.nextDescription)
    if self.SkillItemtabTemp then
      self.MasterSkilltabTemp.nextDes = self.SkillItemtabTemp.content
    end
  end
  return self.MasterSkilltabTemp
end

function MasterSysData:UpdateSingleSkillInfo(type, newID)
  local newSkill = ClientTable.cfg_MasterSkill_detailManager:TryGetValue(newID)
  if newSkill then
    local curTypeTab = self:GetShowSkillTab(type)
    if curTypeTab then
      self.MasterCurSkillClient[type][newSkill.masterSkillGroup] = newSkill
    end
  end
end

function MasterSysData:UpdateSingleSkillPoint(type, data)
  self.MasterPoint[type] = data
end

function MasterSysData:SetPointInfo(info)
  self.MasterPoint = {}
  for i = 1, #info do
    self.MasterPoint[QuickFind.LuaMainPlayerViewAttrData().career * 100 + i] = info[i]
  end
end

function MasterSysData:SetSkillInfo(info)
  self.MasterSkillConfig = {}
  for i = 1, #info do
    self.MasterSkillConfig[info[i].masterTalent] = info[i]
  end
  self:RefreshAllCurSkill()
end

function MasterSysData:RefreshAllCurSkill()
  for i, v in pairs(self.MasterSkillConfig) do
    for j = 1, #v.grandMasterSkill do
      self:UpdateSingleSkillInfo(i, v.grandMasterSkill[j])
    end
  end
end

function MasterSysData:RefreshAllData(data)
  self.MasterType = data.masterTalent
  self.MasterLevel = data.level
  self.MasterExp = data.masterExp
  self.MasterExchangeTimes = data.surplusExchangeNum
  self.MasterPoint = self:SetPointInfo(data.grandMasterPointInfo)
  self.MasterSkillConfig = self:SetSkillInfo(data.grandMasterSkillInfo)
  self.IsFree = data.changeTalentFree
  EventManager.Dispatch(Event.RefreshMasterData)
end

function MasterSysData:RefreshExchangeData(data)
  self.MasterLevel = data.level
  self.MasterExp = data.masterExp
  self.MasterExchangeTimes = data.surplusExchangeNum
  self.MasterPoint = self:SetPointInfo(data.grandMasterPointInfo)
  EventManager.Dispatch(Event.RefreshExMasterData)
end

function MasterSysData:RefreshEnableData(data)
  self.MasterType = data.masterTalent
  self.MasterSkillConfig = self:SetSkillInfo(data.grandMasterSkillInfo)
  self.IsFree = data.changeTalentFree
  EventManager.Dispatch(Event.RefreshMasterData)
end

function MasterSysData:RefreshUpGrandData(data)
  self:UpdateSingleSkillInfo(self.MasterType, data.skillId)
  self:UpdateSingleSkillPoint(self.MasterType, data.grandMasterPointInfo)
  EventManager.Dispatch(Event.RefreshSkillMasterData)
end

function MasterSysData:RefreshResetGrandData(data)
  self.MasterType = data.masterTalent
  self.MasterSkillConfig = self:SetSkillInfo(data.grandMasterSkillInfo)
  self.MasterPoint = self:SetPointInfo(data.grandMasterPointInfo)
  EventManager.Dispatch(Event.RefreshMasterData)
end

function MasterSysData:RefreshFreeData(data)
  self.IsFree = data.changeTalentFree
  EventManager.Dispatch(Event.RefreshMasterData)
end

function MasterSysData:RefreshExpTimesData(data)
  self.MasterExchangeAllTimes = data.allExchangeNum
  self.MasterExchangeTimes = data.surplusExchangeNum
  EventManager.Dispatch(Event.RefreshMasterData)
end

return MasterSysData
