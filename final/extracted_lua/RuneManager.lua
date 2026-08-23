require("GameConst/RuneEnum")
local RuneManager = {}

function RuneManager:Init()
  self.ServerRuneManager = {}
end

function RuneManager:BindPlayer(player)
  self.player = player
end

function RuneManager:GetAllRuneManager()
  if self.ServerRuneManager then
    return self.ServerRuneManager
  end
end

function RuneManager:GetItemRuneInfoDataByEquipIndex(equipIndex)
  if self.ServerRuneManager and self.ServerRuneManager[equipIndex] then
    table.sort(self.ServerRuneManager[equipIndex], function(a, b)
      if a.point and b.point then
        return a.point < b.point
      end
    end)
    return self.ServerRuneManager[equipIndex]
  end
end

function RuneManager:GetItemRuneManagerLimit(equipIndex, level, runeTypes)
  if self.ServerRuneManager and self.ServerRuneManager[equipIndex] then
    local runeInfos = self.ServerRuneManager[equipIndex]
    local enoughTbl = {}
    for i, v in pairs(runeInfos) do
      if v.cfgTab.runesStage == level and table.contains(runeTypes, tostring(v.cfgTab.type)) then
        table.insert(enoughTbl, v)
      end
    end
    return enoughTbl
  end
  return {}
end

function RuneManager:GetWearRuneTypeData()
  local typeRuneData = {}
  local allRuneData = self:GetAllRuneManager()
  local runesStage, globalStage
  for equipIndex, itemEquipData in pairs(allRuneData) do
    for i, itemHoleData in pairs(itemEquipData) do
      runesStage = itemHoleData.cfgTab.runesStage
      globalStage = ParseUtility.GetTblByAnalysisParam(GlobalConfig.GetGlobalConfig(2800002))
      if runesStage and globalStage and runesStage >= globalStage[itemHoleData.cfgTab.type] then
        typeRuneData[itemHoleData.cfgTab.type] = typeRuneData[itemHoleData.cfgTab.type] or {}
        typeRuneData[itemHoleData.cfgTab.type][equipIndex] = itemEquipData
      end
    end
  end
  return typeRuneData
end

function RuneManager:GetCanSetRuneByEquipInBag(equipIndex)
  local canSetRuneData = {}
  local bagTotalRuneData = BagInfoData.GetTotalRuneData()
  for i, itemBagRuneData in ipairs(bagTotalRuneData) do
    local isCan = ClientTable.cfg_Runes_inlayManager:JudgeCanSetByEquipIndex(itemBagRuneData.tblItem.id, equipIndex)
    if isCan then
      itemBagRuneData.runesStage = ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemBagRuneData.itemId).runesStage
      table.insert(canSetRuneData, itemBagRuneData)
    end
  end
  table.sort(canSetRuneData, function(a, b)
    if a.runesStage and b.runesStage then
      return a.runesStage > b.runesStage
    end
  end)
  return canSetRuneData
end

function RuneManager:GetRuneAttributeByItemId(itemId, level)
  local inlayTab = ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemId)
  local fuseTab = ClientTable.cfg_Runes_FusionManager:GetRuneFusionTbl(inlayTab.type, inlayTab.runesStage, level)
  local tempTab = inlayTab.runesStage <= 4 and inlayTab or fuseTab
  if tempTab then
    local attributeList = {}
    for k, v in pairs(RuneAttributeEnum) do
      local itemAtt = {}
      local curValue = TableParse:GetAttributeValueDes(tempTab, v.attributeConfigName)
      if not string.isNullOrEmpty(curValue) then
        itemAtt.attributeValue = curValue
        itemAtt.attributeName = v.attributeName
        itemAtt.attributeDes = string.format("%s %s", v.attributeName, curValue)
        itemAtt.type = inlayTab.type
        itemAtt.level = level
        itemAtt.itemId = itemId
        table.insert(attributeList, itemAtt)
      end
    end
    return attributeList
  end
end

function RuneManager:GetRunesSuit(equipPosition)
  local suitConfigDic = ClientTable.cfg_Item_equip_runesSuitManager:GetDic()
  if suitConfigDic == nil then
    return {}
  end
  local matchiConfigs = {}
  for i, v in pairs(suitConfigDic) do
    local runeSuit = {
      suitCfg = v,
      needRune = {},
      equipPositions = {}
    }
    runeSuit.equipPositions = string.split(v.equipPositionSet, "#")
    local runeTypes = string.split(v.runesSet, "#")
    if table.contains(runeSuit.equipPositions, tostring(equipPosition)) then
      local runesInfos = self:GetItemRuneManagerLimit(tonumber(equipPosition), v.level, runeTypes)
      if table.count(runesInfos) > 0 then
        local nums = string.split(v.actNum, "#")
        for i1 = 1, #runeTypes do
          runeSuit.needRune[tonumber(runeTypes[i1])] = tonumber(nums[i1]) or 0
        end
        table.insert(matchiConfigs, runeSuit)
      end
    end
  end
  return matchiConfigs
end

function RuneManager:GetRunesSuitDes(equipPosition)
  local descriptions = {}
  local runesInfos = self:GetRunesSuit(equipPosition)
  for i = 1, #runesInfos do
    table.insert(descriptions, string.GetColorText(runesInfos[i].suitCfg.suitName, ItemQuality2ColorDic[EItemColorEnum.orange]))
    local runesCounts = self:GetRunesCountLimt(runesInfos[i].equipPositions, runesInfos[i].suitCfg.level)
    local active = true
    for i1, v1 in pairs(runesInfos[i].needRune) do
      local runeName = ClientTable.cfg_Runes_inlayManager:TryGetRuneName(i1, runesInfos[i].suitCfg.level)
      local str = string.format(runeName .. "[%d/%d]", math.min(runesCounts[i1] or 0, v1), v1)
      if v1 <= (runesCounts[i1] or 0) then
        table.insert(descriptions, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.gold]))
      else
        table.insert(descriptions, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.gray]))
        active = false
      end
    end
    table.insert(descriptions, string.GetColorText("Thu\225\187\153c t\195\173nh B\225\187\153", ItemQuality2ColorDic[EItemColorEnum.orange]))
    for i, v in ipairs(self:GetSuitAttributeDes(runesInfos[i].suitCfg)) do
      if active then
        table.insert(descriptions, string.GetColorText(v, ItemQuality2ColorDic[EItemColorEnum.gold]))
      else
        table.insert(descriptions, string.GetColorText(v, ItemQuality2ColorDic[EItemColorEnum.gray]))
      end
    end
    local skillTbl = self:GetSuitSkillDes(runesInfos[i].suitCfg)
    if not table.isNullOrEmpty(skillTbl) then
      table.insert(descriptions, string.GetColorText("K\225\187\185 n\196\131ng B\225\187\153 Trang B\225\187\139", ItemQuality2ColorDic[EItemColorEnum.orange]))
      for i, v in ipairs(skillTbl) do
        if active then
          table.insert(descriptions, string.GetColorText(v, ItemQuality2ColorDic[EItemColorEnum.gold]))
        else
          table.insert(descriptions, string.GetColorText(v, ItemQuality2ColorDic[EItemColorEnum.gray]))
        end
      end
    end
  end
  return descriptions
end

function RuneManager:GetSuitSkillDes(suitCfg)
  local suitConfig = suitCfg
  if suitConfig == nil then
    return {}
  end
  local skillTab = {}
  if string.isNullOrEmpty(suitConfig.showSkillID) then
    for i = suitConfig.id, 1, -1 do
      local tempConfig = ClientTable.cfg_Item_equip_runesSuitManager:TryGetValue(i)
      if tempConfig and tempConfig.group == suitConfig.group and tempConfig.level < suitConfig.level and not string.isNullOrEmpty(tempConfig.skillID) then
        suitConfig = tempConfig
        break
      end
    end
  end
  local strSplit = string.split(suitConfig.showSkillID, "&")
  for i, v in ipairs(strSplit) do
    local skillSplit = string.split(v, "#")
    if #skillSplit == 2 then
      local career
      if self.player then
        if self.player.GetMe then
          career = self.player:GetMe().data.career
        else
          career = self.player:GetInfo():GetData().career
        end
      else
        career = RoleManager.me.data.career
      end
      if career and RoleUtility.GetBasicCareer(career) == tonumber(skillSplit[1]) or RoleUtility.GetCurrentCareerCategory() == tonumber(skillSplit[1]) then
        local skilltbl = ClientTable.cfg_Skill_skillManager:TryGetValue(tonumber(skillSplit[2]))
        if skilltbl then
          table.insert(skillTab, string.format(ClientTable.cfg_Ui_wordManager:GetUi_wordCount("Runes_tip_skillName"), skilltbl.name, skilltbl.level))
          break
        end
      end
    else
      logPurple("Sai \196\145\225\187\139nh d\225\186\161ng cfg_Item_equip_runesSuit[skillId]")
    end
  end
  return skillTab
end

function RuneManager:GetSuitAttributeDes(suitConfig)
  if suitConfig == nil then
    return {}
  end
  local attribuTbl = {}
  for k, v in pairs(RunSuitAttributeEnum) do
    if 0 < suitConfig[k] then
      local str = string.format(v, math.floor(suitConfig[k] / 100), "%")
      table.insert(attribuTbl, str)
    end
  end
  return attribuTbl
end

function RuneManager:GetRunesCountLimt(equipPositions, level)
  local countTbl = {}
  for i1, v1 in pairs(equipPositions) do
    local runesInfo = self:GetItemRuneInfoDataByEquipIndex(tonumber(v1))
    if not table.isNullOrEmpty(runesInfo) and self.player and self.player:GetEquipManager():GetEquipData().Data[tonumber(v1)] then
      for _, v2 in pairs(runesInfo) do
        if level <= v2.cfgTab.runesStage then
          if countTbl[v2.cfgTab.type] == nil then
            countTbl[v2.cfgTab.type] = 0
          end
          countTbl[v2.cfgTab.type] = countTbl[v2.cfgTab.type] + 1
        end
      end
    end
  end
  return countTbl
end

function RuneManager:GetRunesCount(equipPositions)
  local countTbl = {}
  for i1, v1 in pairs(equipPositions) do
    local runesInfo = self:GetItemRuneInfoDataByEquipIndex(tonumber(v1))
    if not table.isNullOrEmpty(runesInfo) and self.player and self.player:GetEquipManager():GetEquipData().Data[tonumber(v1)] then
      for _, v2 in pairs(runesInfo) do
        if v2.cfgTab then
          if countTbl[v2.cfgTab.runesStage] == nil then
            countTbl[v2.cfgTab.runesStage] = {}
          end
          if countTbl[v2.cfgTab.runesStage][v2.cfgTab.type] == nil then
            countTbl[v2.cfgTab.runesStage][v2.cfgTab.type] = 0
          end
          countTbl[v2.cfgTab.runesStage][v2.cfgTab.type] = countTbl[v2.cfgTab.runesStage][v2.cfgTab.type] + 1
        end
      end
    end
  end
  return countTbl
end

function RuneManager:ServerUpdateRuneData(data, forceClear)
  if forceClear == true then
    self.ServerRuneManager = {}
  end
  if data and table.count(data) > 0 then
    for i, itemEquipRuneData in pairs(data) do
      if self.ServerRuneManager[itemEquipRuneData.index] == nil then
        self.ServerRuneManager[itemEquipRuneData.index] = {}
      end
      if itemEquipRuneData.reRuneInfo then
        for i, itemHoleData in pairs(itemEquipRuneData.reRuneInfo) do
          local cfgTab = ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemHoleData.itemId)
          if cfgTab then
            itemHoleData.cfgTab = cfgTab
          end
          itemHoleData.equipIndex = itemEquipRuneData.index
          self.ServerRuneManager[itemEquipRuneData.index][itemHoleData.point] = itemHoleData
        end
      end
    end
  else
    self.ServerRuneManager = {}
  end
end

function RuneManager:ServerDeleteRuneData(data)
  if data and self.ServerRuneManager[data.index] and self.ServerRuneManager[data.index][data.point] then
    self.ServerRuneManager[data.index][data.point] = nil
  end
end

return RuneManager
