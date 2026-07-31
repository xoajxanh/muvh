local MasterSkillDataMgr = {}

function MasterSkillDataMgr:CurTypeTbl()
  if self.mTypeTbl == nil then
    self.mTypeTbl = {}
  end
  return self.mTypeTbl
end

function MasterSkillDataMgr:CurSkillGroupIdListByCBType()
  if self.mSkillGroupIdListByCBType == nil then
    self.mSkillGroupIdListByCBType = {}
  end
  return self.mSkillGroupIdListByCBType
end

function MasterSkillDataMgr:CurMasterSkillIDBySkillGroupIdDic()
  if self.mMasterSkillIDBySkillGroupIdDic == nil then
    self.mMasterSkillIDBySkillGroupIdDic = {}
  end
  return self.mMasterSkillIDBySkillGroupIdDic
end

function MasterSkillDataMgr:CurMasterSkillDataBySkillIdDic()
  if self.mMasterSkillDataBySkillIdDic == nil then
    self.mMasterSkillDataBySkillIdDic = {}
  end
  return self.mMasterSkillDataBySkillIdDic
end

function MasterSkillDataMgr:GetSurplusPointTbl()
  if self.mSurplusPointTbl == nil then
    self.mSurplusPointTbl = {}
  end
  return self.mSurplusPointTbl
end

function MasterSkillDataMgr:CurUsedPointDic()
  if self.mUsedPoint == nil then
    self.mUsedPoint = {}
  end
  return self.mUsedPoint
end

function MasterSkillDataMgr:SkillUPcodeDic()
  if self.mSkillUPgradeCodeDic == nil then
    self.mSkillUPgradeCodeDic = {}
  end
  return self.mSkillUPgradeCodeDic
end

function MasterSkillDataMgr:Init()
  self:InitParam()
  self:InitInfo()
  self:BindEventMsg()
end

function MasterSkillDataMgr:InitParam()
  self.eventContainer = EventContainer(EventManager)
end

function MasterSkillDataMgr:BindEventMsg()
  self.eventContainer:Regist(Event.Fuc_Refresh, self.FucAllRefreshCallBack, self)
end

function MasterSkillDataMgr:InitInfo()
  self:InitPSTypeData()
  self:InitSkillData()
  self:InitMasterLevelData()
  self:InitExChangeData()
end

function MasterSkillDataMgr:InitPSTypeData()
  self.baseCareer = RoleUtility.GetBasicCareer(RoleManager.me.career)
  local curPSTypeTbl, curUSTypeTbl = ClientTable.cfg_MasterSkill_detailManager:GetCurCareerSkillTbl()
  if curPSTypeTbl ~= nil then
    for k, v in pairs(curPSTypeTbl) do
      table.insert(self:CurTypeTbl(), {
        type = MasterSkillTalentTypeEnum.PS,
        subType = v.code,
        str = v.name
      })
    end
  end
  if curUSTypeTbl ~= nil then
    for k, v in pairs(curUSTypeTbl) do
      table.insert(self:CurTypeTbl(), {
        type = MasterSkillTalentTypeEnum.US,
        subType = v.code,
        str = v.name
      })
    end
  end
end

function MasterSkillDataMgr:InitSkillData()
  for i, v in pairs(self:CurTypeTbl()) do
    if v ~= nil and v.subType ~= nil then
      self:CurSkillGroupIdListByCBType()[v.subType] = ClientTable.cfg_MasterSkill_detailManager:GetSkillIdsBySkillGroup(v.subType)
    end
  end
end

function MasterSkillDataMgr:InitMasterLevelData()
  self:RefreshMasterLevelData(0, 0)
end

function MasterSkillDataMgr:InitExChangeData()
  self:RefreshExChangeInfo(0, 0)
end

function MasterSkillDataMgr:FucAllRefreshCallBack()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.MasterSkill
  })
end

function MasterSkillDataMgr:RefreshMasterDataCallBack(data)
  self:RefreshMasterTalentData(data.masterTalent)
  self:RefreshMasterLevelData(data.level, data.masterExp)
  if data.grandMasterPointInfo then
    self:RefreshAllPointData(data.grandMasterPointInfo)
  end
  if data.grandMasterSkillInfo then
    for i, v in pairs(data.grandMasterSkillInfo) do
      self:RefreshMasterSkillData(v)
    end
  end
  self:RefreshExChangeInfo(data.surplusExchangeNum, data.allExchangeNum)
  self:RefreshOther(data.changeTalentFree, data.resetNum)
  self:RefreshSkillUpgradeCode()
end

function MasterSkillDataMgr:RefreshEnableDataCallBack(data)
  self:RefreshMasterTalentData(data.masterTalent)
  self:RefreshOther(data.changeTalentFree)
  if data.grandMasterSkillInfo then
    for i, v in pairs(data.grandMasterSkillInfo) do
      self:RefreshMasterSkillData(v)
    end
  end
  self:ResetUpcodeData()
  self:RefreshSkillUpgradeCode()
end

function MasterSkillDataMgr:RefreshSkillUpCallBack(data)
  if data.grandMasterPointInfo then
    self:RefreshPointData(data.grandMasterPointInfo, true)
  end
  if self:RefreshMasterSkillUnitData(data.grandMasterSkill) then
    EventManager.Dispatch(Event.NewMasterSkillDataChanged, {
      talent = data.masterTalent,
      groupIds = {
        data.grandMasterSkill.skillGroupId
      }
    })
  end
  self:RefreshSkillUpgradeCode()
  if data.grandMasterSkill then
    EventManager.Dispatch(Event.NewMasterSkillUpgradeDataChanged, data.grandMasterSkill.skillId)
  end
end

function MasterSkillDataMgr:RefreshExchangeDataCallBack(data)
  self:RefreshMasterLevelData(data.level, data.masterExp)
  self:RefreshExChangeInfo(data.surplusExchangeNum)
  if data.grandMasterPointInfo then
    self:RefreshAllPointData(data.grandMasterPointInfo)
  end
  self:RefreshSkillUpgradeCode()
end

function MasterSkillDataMgr:RefreshExchangeTimeDataCallBack(data)
  self:RefreshExChangeInfo(data.surplusExchangeNum, data.allExchangeNum)
end

function MasterSkillDataMgr:RefreshResetPointDataCallBack(data)
  self:ResetData(true)
  self:RefreshMasterTalentData(data.masterTalent)
  if data.grandMasterPointInfo then
    self:RefreshAllPointData(data.grandMasterPointInfo)
  end
  self:RefreshOther(self:GetFreeState(), data.resetNum)
  EventManager.Dispatch(Event.NewMasterSkillAllDataChanged)
  self:ResetUsedPointDic()
  self:RefreshSkillUpgradeCode()
end

function MasterSkillDataMgr:RefreshMasterLevelData(level, value)
  self:ResetData()
  if self.mExpInfo == nil then
    self.mExpInfo = {}
  end
  self.mExpInfo.value = value
  if self.mLevel ~= level then
    self.mLevel = level
    local tbl = ClientTable.cfg_MasterSkill_levelManager:TryGetValue(level)
    self.mExpInfo.maxValue = tbl and tbl.exp or 0
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.MasterSkill
    })
  end
  EventManager.Dispatch(Event.NewMasterSkillLevelChanged)
end

function MasterSkillDataMgr:RefreshAllPointData(dataTbl)
  local isChange = false
  for i, v in pairs(dataTbl) do
    if self:RefreshPointData(v) and not isChange then
      isChange = true
    end
  end
  if isChange then
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.MasterSkill
    })
    EventManager.Dispatch(Event.NewMasterPointChanged)
  end
end

function MasterSkillDataMgr:RefreshPointData(data, sendEvent)
  local lastNum = self:GetSurplusPointTbl()[data.masterTalent]
  local isChange = lastNum ~= data.surplusPoint
  if isChange then
    self:GetSurplusPointTbl()[data.masterTalent] = data.surplusPoint
  end
  if sendEvent and isChange then
    EventManager.Dispatch(Event.NewMasterPointChanged)
  end
  return isChange
end

function MasterSkillDataMgr:RefreshMasterTalentData(type)
  if self.mEnableSubType == type then
    return
  end
  self.mEnableSubType = type
  EventManager.Dispatch(Event.NewSwitchMasterCarrerChanged)
end

function MasterSkillDataMgr:RefreshExChangeInfo(value, maxValue)
  if self.mExChangeInfo == nil then
    self.mExChangeInfo = {}
  end
  local isChange = false
  if self.mExChangeInfo.value ~= value then
    self.mExChangeInfo.value = value
    isChange = true
  end
  if maxValue ~= nil and self.mExChangeInfo.maxValue ~= maxValue then
    self.mExChangeInfo.maxValue = maxValue
    isChange = true
  end
  if isChange then
    EventManager.Dispatch(Event.NewMasterExChangeDataChanged)
    EventManager.Dispatch(Event.CallRefreshRedPoint, {
      id = ERedPointId.MasterSkill
    })
  end
end

function MasterSkillDataMgr:RefreshMasterSkillData(data)
  local changeGroupId = {}
  if data.grandMasterSkill then
    for i, v in pairs(data.grandMasterSkill) do
      if self:RefreshMasterSkillUnitData(v) then
        table.insert(changeGroupId, v.skillGroupId)
      end
    end
  end
  if table.count(changeGroupId) > 0 then
    EventManager.Dispatch(Event.NewMasterSkillDataChanged, {
      talent = data.talentType,
      groupIds = changeGroupId
    })
  end
end

function MasterSkillDataMgr:RefreshMasterSkillUnitData(data)
  if data.skillGroupId == nil then
    return
  end
  local skillId = self:CurMasterSkillIDBySkillGroupIdDic()[data.skillGroupId]
  self:CurMasterSkillIDBySkillGroupIdDic()[data.skillGroupId] = data.skillId
  self:RefreshPoint(skillId, data.skillId)
  return skillId ~= data.skillId
end

function MasterSkillDataMgr:RefreshPoint(oldSkillId, newSkillId)
  local table_Old = oldSkillId and self:GetSkillDataByLid(oldSkillId) or {}
  local table_New = newSkillId and self:GetSkillDataByLid(newSkillId) or {}
  local oldPoint, newPoint
  oldPoint = table_Old and next(table_Old) ~= nil and table_Old.level or 0
  newPoint = table_New and next(table_New) ~= nil and table_New.level or 0
  if table_New.subType then
    if self:CurUsedPointDic()[table_New.subType] then
      self:CurUsedPointDic()[table_New.subType] = self:CurUsedPointDic()[table_New.subType] - oldPoint + newPoint
    else
      self:CurUsedPointDic()[table_New.subType] = 0 - oldPoint + newPoint
    end
  end
end

function MasterSkillDataMgr:RefreshOther(isFree, resetNum)
  self.isFree = isFree or false
  if resetNum and self.mResetNum ~= resetNum then
    self.mResetNum = resetNum
    EventManager.Dispatch(Event.NewMasterResetSuccess)
  end
end

function MasterSkillDataMgr:RefreshSkillUpgradeCode()
  local isChangePS = false
  local careerType = self:GetCurEnableSubType()
  local groupTblPS = self:GetSkillGroupTblByCareerType(careerType)
  local lastCode
  for i, v in pairs(groupTblPS) do
    lastCode = self:SkillUPcodeDic()[v.skillGroup]
    self:SkillUPcodeDic()[v.skillGroup] = self:ReturnUpcodeByGroupId(v.skillGroup)
    if lastCode == nil or lastCode ~= self:SkillUPcodeDic()[v.skillGroup] and lastCode * self:SkillUPcodeDic()[v.skillGroup] == 0 then
      isChangePS = true
    end
  end
  local isChangeUS = false
  local groupTblUS = self:GetSkillGroupTblByCareerType(self:GetUSTalentSubType())
  local lastCode
  for i, v in pairs(groupTblUS) do
    lastCode = self:SkillUPcodeDic()[v.skillGroup]
    self:SkillUPcodeDic()[v.skillGroup] = self:ReturnUpcodeByGroupId(v.skillGroup)
    if lastCode == nil or lastCode ~= self:SkillUPcodeDic()[v.skillGroup] and lastCode * self:SkillUPcodeDic()[v.skillGroup] == 0 then
      isChangeUS = true
    end
  end
  if isChangePS or isChangeUS then
    EventManager.Dispatch(Event.NewMasterSkillUpStateChanged)
  end
end

function MasterSkillDataMgr:ResetData(isServerReset)
  if self.baseCareer ~= RoleUtility.GetBasicCareer(RoleManager.me.career) then
    self:InitPSTypeData()
    self.mMasterSkillIDBySkillGroupIdDic = {}
  elseif isServerReset then
    self.mMasterSkillIDBySkillGroupIdDic = {}
  end
  self:ResetUpcodeData()
end

function MasterSkillDataMgr:ResetUsedPointDic()
  if self.mUsedPoint ~= nil then
    self.mUsedPoint = nil
  end
end

function MasterSkillDataMgr:ResetUpcodeData()
  self.mSkillUPgradeCodeDic = {}
end

function MasterSkillDataMgr:GetLevel()
  return self.mLevel or 0
end

function MasterSkillDataMgr:IsMax()
  return self:GetLevel() >= ClientTable.cfg_MasterSkill_levelManager:GetMaxLevel()
end

function MasterSkillDataMgr:GetExpInfo()
  return self.mExpInfo
end

function MasterSkillDataMgr:GetCurEnableSubType()
  return self.mEnableSubType or 0
end

function MasterSkillDataMgr:GetUSTalentSubType()
  return 0
end

function MasterSkillDataMgr:GetCurTypeTbl()
  return self:CurTypeTbl()
end

function MasterSkillDataMgr:GetExChangeInfo()
  return self.mExChangeInfo
end

function MasterSkillDataMgr:GetPointByMasterTalentType(type)
  if type == nil then
    return 0
  end
  return self:GetSurplusPointTbl()[type] or 0
end

function MasterSkillDataMgr:GetFreeState()
  return self.isFree
end

function MasterSkillDataMgr:GetResetNum()
  return self.mResetNum or 0
end

function MasterSkillDataMgr:GetSkillGroupTblByCareerType(subType)
  return self:CurSkillGroupIdListByCBType()[subType]
end

function MasterSkillDataMgr:GetSkillDataBySkillGroup(group)
  if group == nil then
    return
  end
  local lid = self:CurMasterSkillIDBySkillGroupIdDic()[group]
  if lid == nil then
    lid = ClientTable.cfg_MasterSkill_detailManager:GetSkillFirstIdBySkillGroup(group)
    if lid then
      self:CurMasterSkillIDBySkillGroupIdDic()[group] = lid
    end
  end
  return self:GetSkillDataByLid(lid)
end

function MasterSkillDataMgr:GetSkillDataByLid(id)
  if id == nil then
    return
  end
  if self:CurMasterSkillDataBySkillIdDic()[id] == nil then
    self:CurMasterSkillDataBySkillIdDic()[id] = self:NewMasterSkillData(id)
  end
  return self:CurMasterSkillDataBySkillIdDic()[id]
end

function MasterSkillDataMgr:CheckReqSwitch()
  if self:GetCurEnableSubType() == 0 then
    return true
  end
  return self:GetFreeState()
end

function MasterSkillDataMgr:GetSwitchConsum()
  return ClientTable.cfg_Global_globalManager:GetMasterSwitchConsumTbl()
end

function MasterSkillDataMgr:GetUpcodeByGroupId(groupId)
  if self:SkillUPcodeDic()[groupId] == nil then
    self:SkillUPcodeDic()[groupId] = self:ReturnUpcodeByGroupId(groupId)
  end
  return self:SkillUPcodeDic()[groupId]
end

function MasterSkillDataMgr:NewMasterSkillData(id)
  local temp = {}
  local tbl = ClientTable.cfg_MasterSkill_detailManager:TryGetValue(id)
  if tbl then
    temp.lid = tbl.id
    if string.isNullOrEmpty(tbl.nextskilllevel) then
    end
    temp.nextLId = tonumber(tbl.nextskilllevel)
    temp.skillId = tbl.skill
    temp.skillGroup = tbl.masterSkillGroup
    temp.level = tbl.masterSkillLevel
    temp.maxlevel = tbl.maxLevel
    temp.subType = tbl.type
    temp.type = tbl.talentType
    temp.skillIcon = tbl.icon
    temp.name = tbl.name
    temp.preSkills = self:NewMasterSkillLearnCondition(tbl.preSkills)
    if not string.isNullOrEmpty(tbl.xy) then
      local pointArray = TableParse:SplitStringToIntList(tbl.xy, "#")
      if table.count(pointArray) > 1 then
        temp.x = pointArray[1]
        temp.y = pointArray[2]
      end
    end
    if temp.nextLId then
      tbl = ClientTable.cfg_MasterSkill_detailManager:TryGetValue(temp.nextLId)
      if tbl then
        temp.needPoint = tbl.exPoint
      end
    end
  end
  return temp
end

function MasterSkillDataMgr:NewMasterSkillLearnCondition(preSkills)
  local temp = {}
  if not string.isNullOrEmpty(preSkills) then
    local tab = TableParse:SplitStringToIntList(preSkills, "#")
    if table.count(tab) > 0 then
      temp.groupId = tab[1] or 0
      temp.needLevel = tab[2] or 1
    end
  end
  return temp
end

function MasterSkillDataMgr:CheckEnabelSubType()
  return self:GetCurEnableSubType() ~= 0
end

function MasterSkillDataMgr:ReturnUpcodeByGroupId(groupId)
  local skillData = self:GetSkillDataBySkillGroup(groupId)
  return self:ReturnUpcodeBySkillData(skillData)
end

function MasterSkillDataMgr:ReturnUpcodeBySkillData(data)
  if data == nil or data.subType == nil or data.type == nil then
    return MasterSkillUpcode.DataIsError
  end
  if data.type == MasterSkillTalentTypeEnum.US and not QuickFind.MasterDataMgr():CheckEnabelSubType() then
    return MasterSkillUpcode.ProfessionalTalentNotOpen
  end
  if data.level == data.maxlevel then
    return MasterSkillUpcode.LevelIsFull
  end
  if data.type ~= MasterSkillTalentTypeEnum.US and not self:GetCurEnableSubTypeIsMatchSelf(data.subType) then
    return MasterSkillUpcode.TalentNotOpen
  end
  if self:GetPointByMasterTalentType(data.subType) == 0 then
    return MasterSkillUpcode.RemainPointIsZero
  end
  local usedPoint = self:CurUsedPointDic()[data.subType] and self:CurUsedPointDic()[data.subType] or 0
  if data.needPoint ~= nil and usedPoint < data.needPoint then
    return MasterSkillUpcode.NotMeetPrePoint
  end
  if 0 < table.count(data.preSkills) and not self:GetExSkillIsEnough(data.preSkills) then
    return MasterSkillUpcode.NotMeetPreSkill
  end
  return MasterSkillUpcode.CanUpgrade
end

function MasterSkillDataMgr:GetCurEnableSubTypeIsMatchSelf(subType)
  if subType then
    return self:GetCurEnableSubType() == subType
  else
    return false
  end
end

function MasterSkillDataMgr:GetCurSurplusPointIsZero(type)
  return self:GetPointByMasterTalentType(type) == 0
end

function MasterSkillDataMgr:GetExPointIsEnough(type, needPoint)
  if type and needPoint then
    local usedPoint = self:CurUsedPointDic()[type] and self:CurUsedPointDic()[type] or 0
    return needPoint <= usedPoint
  end
  return false
end

function MasterSkillDataMgr:GetExSkillIsEnough(preSkills)
  if preSkills and preSkills.groupId and preSkills.needLevel and table.containsKey(RoleManager.me.skills, preSkills.groupId) then
    local perSkillLevel = RoleManager.me.skills[preSkills.groupId].level or 0
    return perSkillLevel >= preSkills.needLevel
  end
  return false
end

function MasterSkillDataMgr:CheckShowAddExpRedPoint()
  return not self:IsMax() and self:GetExChangeInfo() ~= nil and self:GetExChangeInfo().value ~= 0
end

function MasterSkillDataMgr:CheckShowMainMenuMasterSkillRedPoint()
  return not self:GetCurSurplusPointIsZero(self:GetCurEnableSubType()) or not self:GetCurSurplusPointIsZero(self:GetUSTalentSubType())
end

function MasterSkillDataMgr:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return MasterSkillDataMgr
