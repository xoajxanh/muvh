local cfg_Item_equip_NewRunesSuitManager = {}

function cfg_Item_equip_NewRunesSuitManager:GetName()
  return "cfg_Item_equip_NewRunesSuitManager"
end

function cfg_Item_equip_NewRunesSuitManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_NewRunesSuit")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_NewRunesSuitManager, TableManagerBase)

function cfg_Item_equip_NewRunesSuitManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_NewRunesSuitManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_NewRunesSuitManager:GetCurAllMeetCombination(imitateReplaceHoleIndex, imitateReplaceRuneItem)
  local allServerRuneData = QuickFind.GetNewRuneDataManager():GetAllServerRuneData()
  if table.count(allServerRuneData) < 3 then
    return {}, {}
  end
  local meetRunesCellCombinationTbl, activeCombinationSuitRunesSetTbl = {}, {}
  local cfg_Item_equip_NewRunesCombo = ClientTable.cfg_Item_equip_NewRunesComboManager:GetDic()
  local cfg_Item_equip_NewRunesSuit = self:GetDic()
  for i, comboCfg in pairs(cfg_Item_equip_NewRunesCombo) do
    local allEquipedSubTypeNumTbl = {}
    local minRuneLevel
    local runesCellArr = string.split(comboCfg.runesCell, "#")
    for i, holeIndex in pairs(runesCellArr) do
      if allServerRuneData[tonumber(holeIndex)] == nil or allServerRuneData[tonumber(holeIndex)].runeItem == nil then
        goto lbl_159
      end
      local runeItem = imitateReplaceHoleIndex and imitateReplaceHoleIndex == holeIndex and imitateReplaceRuneItem or allServerRuneData[tonumber(holeIndex)].runeItem
      local itemData = ItemUtility.GenerateItemDataByServerData(runeItem)
      local subType = itemData.tblItem and itemData.tblItem.subType or 0
      if allEquipedSubTypeNumTbl[subType] == nil then
        allEquipedSubTypeNumTbl[subType] = 1
      else
        allEquipedSubTypeNumTbl[subType] = allEquipedSubTypeNumTbl[subType] + 1
      end
      local curRuneLevel = itemData.tblEquip and itemData.tblEquip.equipClass
      if minRuneLevel == nil then
        minRuneLevel = curRuneLevel
      elseif curRuneLevel < minRuneLevel then
        minRuneLevel = curRuneLevel
      end
    end
    for k, suitCfg in pairs(cfg_Item_equip_NewRunesSuit) do
      local isInsert = true
      local allSetSubTypeNumTbl = {}
      local runesSetArr = string.split(suitCfg.runesSet, "#")
      for i, runeSubType in pairs(runesSetArr) do
        if allSetSubTypeNumTbl[tonumber(runeSubType)] == nil then
          allSetSubTypeNumTbl[tonumber(runeSubType)] = 1
        else
          allSetSubTypeNumTbl[tonumber(runeSubType)] = allSetSubTypeNumTbl[tonumber(runeSubType)] + 1
        end
      end
      for subType, num in pairs(allSetSubTypeNumTbl) do
        if allEquipedSubTypeNumTbl[subType] == nil or allEquipedSubTypeNumTbl[subType] ~= num then
          isInsert = false
          break
        end
      end
      if minRuneLevel == nil or suitCfg.runesSuitLevel ~= minRuneLevel then
        isInsert = false
      end
      if isInsert then
        meetRunesCellCombinationTbl[comboCfg.runesCell] = suitCfg
      end
    end
    ::lbl_159::
  end
  for runesCell, suitCfg in pairs(meetRunesCellCombinationTbl) do
    if activeCombinationSuitRunesSetTbl[suitCfg.runesSet] == nil then
      activeCombinationSuitRunesSetTbl[suitCfg.runesSet] = {suitCfg = suitCfg, runesCell = runesCell}
    elseif activeCombinationSuitRunesSetTbl[suitCfg.runesSet].suitCfg.runesSuitLevel < suitCfg.runesSuitLevel then
      activeCombinationSuitRunesSetTbl[suitCfg.runesSet] = {suitCfg = suitCfg, runesCell = runesCell}
    end
  end
  return meetRunesCellCombinationTbl, activeCombinationSuitRunesSetTbl
end

return cfg_Item_equip_NewRunesSuitManager
