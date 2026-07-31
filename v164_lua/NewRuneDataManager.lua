require("GameConst/NewRuneEnum")
local NewRuneDataManager = {}
NewRuneDataManager.holeIndexList = {
  1,
  2,
  3,
  4,
  5,
  6,
  7
}
NewRuneDataManager.runeSubtypeAndItemIdList = {
  [2801] = 190100001,
  [2802] = 190200001,
  [2803] = 190300001
}
NewRuneDataManager.runeSpriteNamePrefix = "img_runesType_"

function NewRuneDataManager:RefreshAllRuneServerData(serverData)
  if self.allServerRuneData == nil then
    self.allServerRuneData = {}
  end
  for i, runeData in pairs(serverData) do
    self.allServerRuneData[runeData.index] = runeData
  end
end

function NewRuneDataManager:RefreshOneRuneServerData(serverData)
  if self.allServerRuneData == nil then
    self.allServerRuneData = {}
  end
  self.allServerRuneData[serverData.index] = serverData
  EventManager.Dispatch(Event.RefreshNewRuneHoleData, serverData.index)
end

function NewRuneDataManager:SetCurChooseHoleIndex(holeIndex)
  self.curChooseHoleIndex = holeIndex
end

function NewRuneDataManager:GetHoleIndexList()
  return self.holeIndexList or {}
end

function NewRuneDataManager:GetCurChooseHoleIndex()
  return self.curChooseHoleIndex
end

function NewRuneDataManager:GetAllServerRuneData()
  return self.allServerRuneData or {}
end

function NewRuneDataManager:GetServerRuneDataByHoleIndex(holeIndex)
  return holeIndex and self.allServerRuneData and self.allServerRuneData[holeIndex]
end

function NewRuneDataManager:GetHoleCostList(holeIndex, holeLevel)
  local curTbl = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurHoleCfg(holeIndex, holeLevel)
  local costList = curTbl and TableParse:SpliteStringToItemCountList(curTbl.cost) or {}
  return costList
end

function NewRuneDataManager:GetHoleAttributeList(holeIndex, holeLevel)
  local curTbl = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurHoleCfg(holeIndex, holeLevel)
  local nextTbl = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurHoleCfg(holeIndex, holeLevel + 1)
  local attributeList = TableParse:GetAttributeList(curTbl, nextTbl, NewRuneHoleAttributeEnum)
  return attributeList
end

function NewRuneDataManager:GetHoleAllAttributeList()
  local attributeNameAndValue = {}
  local allServerRuneData = self:GetAllServerRuneData()
  for i, serverData in pairs(allServerRuneData) do
    local curTbl = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurHoleCfg(serverData.index, serverData.level)
    TableParse:GenerateAttributeNameAndValueList(curTbl, NewRuneHoleAttributeEnum, attributeNameAndValue)
  end
  local attributeNameAndValueDesList = TableParse:GetAttributeNameAndValueDesList(attributeNameAndValue)
  return attributeNameAndValueDesList
end

function NewRuneDataManager:GetRuneAllAttributeList()
  local attributeNameAndValue = {}
  local allServerRuneData = self:GetAllServerRuneData()
  for i, serverData in pairs(allServerRuneData) do
    local holeIndexRune = serverData.runeItem
    if holeIndexRune then
      local itemData = ItemUtility.GenerateItemDataByServerData(holeIndexRune)
      TableParse:GenerateAttributeNameAndValueList(itemData.tblEquip, NewRuneAttributeEnum, attributeNameAndValue)
    end
  end
  local attributeNameAndValueDesList = TableParse:GetAttributeNameAndValueDesList(attributeNameAndValue)
  return attributeNameAndValueDesList
end

function NewRuneDataManager:GetCombinationAllAttributeList()
  local attributeNameAndValue = {}
  local curAllMeetCombination, activeCombinationSuitRunesSetTbl = ClientTable.cfg_Item_equip_NewRunesSuitManager:GetCurAllMeetCombination()
  for runesSet, data in pairs(activeCombinationSuitRunesSetTbl) do
    TableParse:GenerateAttributeNameAndValueList(data.suitCfg, NewRuneCombinationAttributeEnum, attributeNameAndValue)
  end
  local activedRuneSuitCfg = self:GetActivedRuneSuitCfg()
  if table.count(activedRuneSuitCfg) > 0 then
    TableParse:GenerateAttributeNameAndValueList(activedRuneSuitCfg, NewRuneCombinationAttributeEnum, attributeNameAndValue)
  end
  local attributeNameAndValueDesList = TableParse:GetAttributeNameAndValueDesList(attributeNameAndValue)
  return attributeNameAndValueDesList
end

function NewRuneDataManager:GetActivedRuneSuitCfg()
  local activedRuneSuitCfg = {}
  local runeSuitId, minRuneLevel
  local inlayRuneCount = 0
  for i, v in pairs(self:GetAllServerRuneData()) do
    if v.runeItem then
      inlayRuneCount = inlayRuneCount + 1
      if runeSuitId == nil then
        local itemData = ItemUtility.GenerateItemDataByServerData(v.runeItem)
        runeSuitId = itemData.tblEquip and string.isNullOrEmpty(itemData.tblEquip.suitId) == false and tonumber(string.split(itemData.tblEquip.suitId, "#")[1])
      end
      if v.runeItem.runesLevel and (minRuneLevel == nil or minRuneLevel > v.runeItem.runesLevel) then
        minRuneLevel = v.runeItem.runesLevel
      end
    end
  end
  local isActive = inlayRuneCount >= #self.holeIndexList
  if isActive and runeSuitId and minRuneLevel then
    local suit = MeEquipController.GetSuitCfg(runeSuitId, minRuneLevel)
    if 0 < table.count(suit) then
      activedRuneSuitCfg = suit[1]
    end
  end
  return activedRuneSuitCfg
end

function NewRuneDataManager:GetBagAllRunes()
  local bagInfo = BagInfoData.TotalItems
  local meetRuneData = {}
  for i, v in pairs(bagInfo) do
    local itemData = ItemUtility.GenerateItemDataByServerData(v)
    local tblItem, tblEquip = itemData.tblItem, itemData.tblEquip
    if tblItem and tblItem.type == 28 and tblEquip then
      table.insert(meetRuneData, itemData)
    end
  end
  table.sort(meetRuneData, function(a, b)
    if a and b then
      if a.tblEquip.subType == b.tblEquip.subType then
        return a.tblEquip.equipClass > b.tblEquip.equipClass
      else
        return a.tblEquip.subType < b.tblEquip.subType
      end
    else
      return false
    end
  end)
  return meetRuneData
end

function NewRuneDataManager:GetCurHoleCanInlayAllRunes(holeIndex, holeLevel)
  local curCanInlayMaxRunesLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurCanInlayMaxRunesLevel(holeIndex, holeLevel)
  local bagInfo = BagInfoData.TotalItems
  local meetRuneData = {}
  for i, v in pairs(bagInfo) do
    local itemData = ItemUtility.GenerateItemDataByServerData(v)
    local tblItem, tblEquip = itemData.tblItem, itemData.tblEquip
    if tblItem and tblItem.type == 28 and tblEquip and curCanInlayMaxRunesLevel >= tblEquip.equipClass then
      table.insert(meetRuneData, itemData)
    end
  end
  table.sort(meetRuneData, function(a, b)
    if a and b then
      if a.tblEquip.subType == b.tblEquip.subType then
        return a.tblEquip.equipClass > b.tblEquip.equipClass
      else
        return a.tblEquip.subType < b.tblEquip.subType
      end
    else
      return false
    end
  end)
  return meetRuneData
end

function NewRuneDataManager:CheckImitateReplaceCombinationNumIsGreater(imitateReplaceHoleIndex, imitateReplaceRuneItem)
  local curAllMeetCombination, activeCombinationSuitRunesSetTbl = ClientTable.cfg_Item_equip_NewRunesSuitManager:GetCurAllMeetCombination()
  local curActiveCombinationNum = table.count(activeCombinationSuitRunesSetTbl)
  local imitateAllMeetCombination, imitateActiveCombinationSuitRunesSetTbl = ClientTable.cfg_Item_equip_NewRunesSuitManager:GetCurAllMeetCombination(imitateReplaceHoleIndex, imitateReplaceRuneItem)
  local imitateReplaceCombinationNum = table.count(imitateActiveCombinationSuitRunesSetTbl)
  return curActiveCombinationNum < imitateReplaceCombinationNum
end

function NewRuneDataManager:GetTipRunesMasterData()
  local tipRunesMasterData = {}
  local allServerRuneData = self:GetAllServerRuneData()
  local curAllMeetCombination, activeCombinationSuitRunesSetTbl = ClientTable.cfg_Item_equip_NewRunesSuitManager:GetCurAllMeetCombination()
  local cfg_SuitLevel1 = ClientTable.cfg_Item_equip_NewRunesSuitManager:GetTabListByType(1, "runesSuitLevel")
  for i, cfgSuit in ipairs(cfg_SuitLevel1) do
    local isAvtive = activeCombinationSuitRunesSetTbl[cfgSuit.runesSet] ~= nil
    local cfgSuit = isAvtive and activeCombinationSuitRunesSetTbl[cfgSuit.runesSet].suitCfg or cfgSuit
    local runeCombination = {}
    if isAvtive then
      local runesCellArr = string.split(activeCombinationSuitRunesSetTbl[cfgSuit.runesSet].runesCell, "#")
      for k, holeIndex in ipairs(runesCellArr) do
        local runeItem = allServerRuneData[tonumber(holeIndex)].runeItem
        local itemData = ItemUtility.GenerateItemDataByServerData(runeItem)
        local subType = itemData.tblItem and itemData.tblItem.subType
        local runeSpriteName = self.runeSpriteNamePrefix .. subType
        table.insert(runeCombination, runeSpriteName)
      end
    else
      local cfgSuitRunesSetArr = string.split(cfgSuit.runesSet, "#")
      for k, subType in ipairs(cfgSuitRunesSetArr) do
        local runeSpriteName = self.runeSpriteNamePrefix .. subType
        table.insert(runeCombination, runeSpriteName)
      end
    end
    local skillId = self:GetTipRunesMasterCombinationSkillId(cfgSuit.showSkillID)
    local skillCfg = ClientTable.cfg_Skill_skillManager:TryGetValue(skillId)
    table.insert(tipRunesMasterData, {
      id = cfgSuit.id,
      runeCombination = runeCombination,
      skillName = skillCfg and skillCfg.name or "",
      skillLevel = skillCfg and skillCfg.level or "",
      skillIcon = skillCfg and skillCfg.icon or "",
      skillDes = skillCfg and SkillUtility.ParseSkillDesc(skillCfg.description) or "",
      isAvtive = isAvtive,
      activeId = isAvtive and 1 or 0
    })
  end
  table.sort(tipRunesMasterData, function(a, b)
    if a and b then
      if a.activeId == b.activeId then
        return a.id < b.id
      else
        return a.activeId > b.activeId
      end
    end
    return false
  end)
  return tipRunesMasterData
end

function NewRuneDataManager:GetTipRunesMasterCombinationSkillId(showSkillID)
  local strSplit = string.split(showSkillID, "&")
  for i, v in ipairs(strSplit) do
    local skillSplit = string.split(v, "#")
    if #skillSplit == 2 then
      local career = RoleManager.me.data.career
      if RoleUtility.GetBasicCareer(career) == tonumber(skillSplit[1]) or RoleUtility.GetCurrentCareerCategory() == tonumber(skillSplit[1]) then
        return tonumber(skillSplit[2])
      end
    else
      logPurple("Sai \196\145\225\187\139nh d\225\186\161ng cfg_Item_equip_NewRunesSuit[skillId]")
      break
    end
  end
  return 0
end

function NewRuneDataManager:CheckRuneCanSetOrHigh(chooseHoleRuneData, bagRuneData)
  if chooseHoleRuneData == nil then
    return false
  end
  local curCanInlayMaxRunesLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurCanInlayMaxRunesLevel(chooseHoleRuneData.index, chooseHoleRuneData.level)
  if bagRuneData.tblEquip and curCanInlayMaxRunesLevel >= bagRuneData.tblEquip.equipClass then
    if chooseHoleRuneData.runeItem then
      local chooseHoleRuneItemData = ItemUtility.GenerateItemDataByServerData(chooseHoleRuneData.runeItem)
      if chooseHoleRuneItemData.tblEquip == nil then
        return false
      elseif bagRuneData.tblEquip.equipClass > chooseHoleRuneItemData.tblEquip.equipClass then
        return true
      elseif bagRuneData.tblEquip.equipClass == chooseHoleRuneItemData.tblEquip.equipClass then
        return self:CheckImitateReplaceCombinationNumIsGreater(chooseHoleRuneItemData.index, bagRuneData)
      end
    else
      return true
    end
  end
  return false
end

function NewRuneDataManager:CheckIsShowUpgradeHoleRedPoint(holeIndex)
  local holeIndexServerData = self:GetServerRuneDataByHoleIndex(holeIndex)
  local holeIndexLevel = holeIndexServerData and holeIndexServerData.level or 0
  local cfg_Item_equip_NewRunesCell = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurHoleCfg(holeIndex, holeIndexLevel)
  if cfg_Item_equip_NewRunesCell and string.isNullOrEmpty(cfg_Item_equip_NewRunesCell.cost) == false then
    return ItemUtility:IsMeetCost(TableParse:SpliteStringToItemCountList(cfg_Item_equip_NewRunesCell.cost))
  end
  return false
end

function NewRuneDataManager:CheckIsShowUpgradeRedPoint()
  for i, holeIndex in ipairs(self:GetHoleIndexList()) do
    if self:CheckIsShowUpgradeHoleRedPoint(holeIndex) then
      return true
    end
  end
  return false
end

function NewRuneDataManager:CheckIsShowInlayHoleRedPoint(holeIndex)
  local holeIndexServerData = self:GetServerRuneDataByHoleIndex(holeIndex)
  if holeIndexServerData then
    local curCanInlayMaxRunesLevel = ClientTable.cfg_Item_equip_NewRunesCellManager:GetCurCanInlayMaxRunesLevel(holeIndexServerData.index, holeIndexServerData.level)
    local bagTotalNewRuneData = self:GetBagAllRunes()
    for i, runeData in pairs(bagTotalNewRuneData) do
      if runeData.tblEquip and curCanInlayMaxRunesLevel >= runeData.tblEquip.equipClass then
        if holeIndexServerData.runeItem then
          local chooseHoleRuneItemData = ItemUtility.GenerateItemDataByServerData(holeIndexServerData.runeItem)
          return chooseHoleRuneItemData.tblEquip and bagRuneData.tblEquip.equipClass > chooseHoleRuneItemData.tblEquip.equipClass or false
        else
          return true
        end
      end
    end
  end
  return false
end

function NewRuneDataManager:CheckIsShowInlayRedPoint()
  for i, holeIndex in ipairs(self:GetHoleIndexList()) do
    if self:CheckIsShowInlayHoleRedPoint(holeIndex) then
      return true
    end
  end
  return false
end

function NewRuneDataManager:GetTipRunesMasterDes(suitId, level)
  local allServerData = self:GetAllServerRuneData()
  local resultDes = {}
  local count = 0
  for i, v in pairs(allServerData) do
    if v.runeItem ~= nil and level <= v.runeItem.runesLevel then
      count = count + 1
    end
  end
  local suit = MeEquipController.GetSuitCfg(suitId, level)[1]
  local active = count >= #self.holeIndexList
  table.insert(resultDes, string.GetColorText(suit.suitName, ItemQuality2ColorDic[EItemColorEnum.orange]))
  local str = string.format(suit.suitName .. "[%d/%d]", count, #self.holeIndexList)
  if active then
    table.insert(resultDes, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.gold]))
  else
    table.insert(resultDes, string.GetColorText(str, ItemQuality2ColorDic[EItemColorEnum.gray]))
  end
  table.insert(resultDes, string.GetColorText("Thu\225\187\153c t\195\173nh B\225\187\153", ItemQuality2ColorDic[EItemColorEnum.orange]))
  for i, v in ipairs(self:GetSuitAttributeDes(suit)) do
    if active then
      table.insert(resultDes, string.GetColorText(v, ItemQuality2ColorDic[EItemColorEnum.gold]))
    else
      table.insert(resultDes, string.GetColorText(v, ItemQuality2ColorDic[EItemColorEnum.gray]))
    end
  end
  return resultDes
end

function NewRuneDataManager:GetSuitAttributeDes(suitConfig)
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

return NewRuneDataManager
