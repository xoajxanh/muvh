local RunesFusionDataMgr = {}
local this = RunesFusionDataMgr

function RunesFusionDataMgr:Init()
  self:InitParam()
  self:InitInfo()
end

function RunesFusionDataMgr:InitParam()
  self.RuneFusionEffName = {
    [1] = "Eff_jingyanqiu_hong",
    [2] = "Eff_jingyanqiu_02zlan",
    [3] = "Eff_jingyanqiu_lv"
  }
end

function RunesFusionDataMgr:InitInfo()
  self:InitPageNameTbl()
  self:InitDescriptionTbl()
  self:InitPromptWordTbl()
  self:InitRuneFusionDataTbl()
end

function RunesFusionDataMgr:InitPageNameTbl()
  local firstPageNameTbl = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Runes_fusion_type")
  local secondPageNameTbl = ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Runes_fusion_equipPosition")
  self.firstPageNameTbl = firstPageNameTbl ~= "" and TableParse:SplitStringToRuneFusionPageNameList(firstPageNameTbl) or nil
  self.secondPageNameTbl = secondPageNameTbl ~= "" and TableParse:SplitStringToRuneFusionPageNameList(secondPageNameTbl) or nil
end

function RunesFusionDataMgr:InitDescriptionTbl()
  self.lvCfg = ConfigManager.FindConfigs("cfg_Ui_description", "uiName", "Equip_RunesFusionUI")
end

function RunesFusionDataMgr:InitPromptWordTbl()
  self.promptWord = ClientTable.cfg_Ui_promptwordManager:TryGetValue(17)
end

function RunesFusionDataMgr:InitRuneFusionDataTbl()
  self.runeFusionDataTbl = ClientTable.cfg_Runes_FusionManager:NewRuneFusionData()
end

function RunesFusionDataMgr:GetMeetConditionRunesData()
  return gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetWearRuneTypeData() or {}
end

function RunesFusionDataMgr:GetFirstPageNameByType(type)
  if type == nil then
    return ""
  end
  if self.firstPageNameTbl and self.firstPageNameTbl[type] then
    return self.firstPageNameTbl[type]
  end
  return ""
end

function RunesFusionDataMgr:GetSecondPageNameByEquipPosition(equipPosition)
  if equipPosition == nil then
    return ""
  end
  if self.secondPageNameTbl and self.secondPageNameTbl[equipPosition] then
    return self.secondPageNameTbl[equipPosition]
  end
  return ""
end

function RunesFusionDataMgr:GetDescriptionTbl()
  return self.lvCfg or {}
end

function RunesFusionDataMgr:GetPromptWordTbl()
  return self.promptWord or {}
end

function RunesFusionDataMgr:GetRuneFusionMaxLevel(type, runesStage)
  if type == nil or runesStage == nil then
    return 40
  end
  if self.runeFusionDataTbl and self.runeFusionDataTbl[type] and self.runeFusionDataTbl[type][runesStage] and self.runeFusionDataTbl[type][runesStage] then
    return self.runeFusionDataTbl[type][runesStage].runesLevelMax
  end
  return 40
end

function RunesFusionDataMgr:GetRuneFusionTblId(type, runesStage, runesLevel)
  if type == nil or runesStage == nil or runesLevel == nil then
    return nil
  end
  if self.runeFusionDataTbl and self.runeFusionDataTbl[type] and self.runeFusionDataTbl[type][runesStage] and self.runeFusionDataTbl[type][runesStage][runesLevel] then
    return self.runeFusionDataTbl[type][runesStage][runesLevel].id
  end
  return nil
end

function RunesFusionDataMgr:GetRuneFusionNeedExp(type, runesStage, runesLevel)
  if type == nil or runesStage == nil or runesLevel == nil then
    return 10000
  end
  if self.runeFusionDataTbl and self.runeFusionDataTbl[type] and self.runeFusionDataTbl[type][runesStage] and self.runeFusionDataTbl[type][runesStage][runesLevel] then
    local needExp = self.runeFusionDataTbl[type][runesStage][runesLevel].needExp
    local needExpTbl = string.split(needExp, "#")
    return tonumber(needExpTbl[1]), tonumber(needExpTbl[2])
  end
  return 0, 10000
end

function RunesFusionDataMgr:GetRuneFusionTblName(type, runesStage, runesLevel)
  if type == nil or runesStage == nil or runesLevel == nil then
    return ""
  end
  if self.runeFusionDataTbl and self.runeFusionDataTbl[type] and self.runeFusionDataTbl[type][runesStage] and self.runeFusionDataTbl[type][runesStage][runesLevel] then
    return self.runeFusionDataTbl[type][runesStage][runesLevel].runesName
  end
  return ""
end

function RunesFusionDataMgr:GetRuneFusionEffNameByType(type)
  if type == nil then
    return ""
  end
  if self.RuneFusionEffName and self.RuneFusionEffName[type] then
    return self.RuneFusionEffName[type]
  end
  return ""
end

function RunesFusionDataMgr:CheckCurExpIsCanUpgrade(type, runesStage, runesLevel)
  if type == nil or runesStage == nil or runesLevel == nil then
    return false
  end
  local expItemId, needExp = self:GetRuneFusionNeedExp(type, runesStage, runesLevel)
  return needExp <= BagInfoData.GetItemTotalCountByItemId(expItemId)
end

function RunesFusionDataMgr:CheckIsMaxLevelAndNextIdIsZero(type, runesStage, runesLevel)
  if type == nil or runesStage == nil or runesLevel == nil then
    return false
  end
  local isMaxLevelAndNextIdIsZero = false
  local maxLevel = self:GetRuneFusionMaxLevel(type, runesStage)
  if runesLevel >= maxLevel then
    local nextId = self.runeFusionDataTbl[type][runesStage][runesLevel].nextId
    if nextId == nil or nextId == 0 then
      isMaxLevelAndNextIdIsZero = true
    end
  end
  return isMaxLevelAndNextIdIsZero
end

function RunesFusionDataMgr:GetAttributeList(type, runesStage, runesLevel)
  if type == nil or runesStage == nil or runesLevel == nil then
    return {}
  end
  local curRuneFusionId = self.runeFusionDataTbl[type][runesStage][runesLevel].id
  local nextRuneFusionId = self.runeFusionDataTbl[type][runesStage][runesLevel].nextId
  local curRuneFusionTbl = ClientTable.cfg_Runes_FusionManager:GetRuneFusionTblById(curRuneFusionId)
  local nextRuneFusionTbl = ClientTable.cfg_Runes_FusionManager:GetRuneFusionTblById(nextRuneFusionId)
  local attributeList = {}
  local attributeInfo
  for k, v in pairs(RuneAttributeEnum) do
    local curValue = TableParse:GetAttributeValueDes(curRuneFusionTbl, v.attributeConfigName)
    if curValue ~= nil and string.isNullOrEmpty(curValue) == false then
      attributeInfo = {}
      attributeInfo.name = v.attributeName
      attributeInfo.curValue = curValue
      attributeInfo.nextIsNil = nextRuneFusionTbl == nil
      attributeInfo.isUp = not attributeInfo.nextIsNil
      if not attributeInfo.nextIsNil then
        attributeInfo.nextValue = TableParse:GetAttributeValueDes(nextRuneFusionTbl, v.attributeConfigName)
      end
      table.insert(attributeList, attributeInfo)
    end
  end
  return attributeList
end

function RunesFusionDataMgr:RefreshRedPointData()
  local redPointStateTbl = {}
  local isShowMainMenuRuneFusionRedPoint = false
  local data = self:GetMeetConditionRunesData()
  for type, typeInfo in pairs(data) do
    redPointStateTbl[type] = {state = false}
    for equipPosition, equipPositionInfo in pairs(typeInfo) do
      redPointStateTbl[type][equipPosition] = {state = false}
      for hole, holeInfo in pairs(equipPositionInfo) do
        redPointStateTbl[type][equipPosition][hole] = {state = false}
        local isShowRedPoint = self:CheckIsShowHoleRuneRedPoint(type, holeInfo.cfgTab.runesStage, holeInfo.level)
        if isShowRedPoint == true then
          redPointStateTbl[type][equipPosition][hole].state = true
          redPointStateTbl[type][equipPosition].state = true
          redPointStateTbl[type].state = true
          isShowMainMenuRuneFusionRedPoint = true
        end
      end
    end
  end
  return redPointStateTbl, isShowMainMenuRuneFusionRedPoint
end

function RunesFusionDataMgr:CheckIsShowHoleRuneRedPoint(type, runesStage, runesLevel)
  local isCanUpgrade = self:CheckCurExpIsCanUpgrade(type, runesStage, runesLevel)
  local isMaxLevelAndNextIdIsZero = self:CheckIsMaxLevelAndNextIdIsZero(type, runesStage, runesLevel)
  return isCanUpgrade and not isMaxLevelAndNextIdIsZero
end

function RunesFusionDataMgr:CheckIsShowMainMenuRuneFusionRedPoint()
  local redPointStateTbl, isShowMainMenuRuneFusionRedPoint = self:RefreshRedPointData()
  return isShowMainMenuRuneFusionRedPoint
end

function RunesFusionDataMgr:RefreshRedPointCallBack()
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.Runes_Fusion
  })
end

function RunesFusionDataMgr:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return RunesFusionDataMgr
