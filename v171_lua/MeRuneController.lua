MeRunneController = {}
MeRunneController.CurSelectItemCellRuneEquip = nil
MeRunneController.CurSelectEquipIndex = nil
MeRunneController.CurSelectRuneHoleType = nil
MeRunneController.ShowEquipType = nil
MeRunneController.CurSelectRuneData = nil
MeRunneController.CheckSuitIsActiveCache = {}

function MeRunneController.Init()
  MeRunneController:RegistEvent()
  MeRunneController:ClearRuneData()
end

function MeRunneController:RegistEvent()
  EventManager.Regist(Event.Equip_ResEquipChange, self.CheckAllSuitActiveStates, self)
end

function MeRunneController:ClearRuneData()
  self.CurSelectItemCellRuneEquip = nil
  self.CurSelectEquipIndex = nil
  self.CurSelectRuneHoleType = nil
  self.ShowEquipType = nil
  self.CurSelectRuneData = nil
end

function MeRunneController:GetSelectRuneEquip()
  return self.CurSelectItemCellRuneEquip
end

function MeRunneController:GetSelectEquipIndex()
  if self.CurSelectEquipIndex == nil then
    self.CurSelectEquipIndex = 3504
  end
  return self.CurSelectEquipIndex
end

function MeRunneController:GetSelectRuneHoleType()
  if self.CurSelectRuneHoleType == nil then
    self.CurSelectRuneHoleType = EquipRuneTypeEnum.Left
  end
  return self.CurSelectRuneHoleType
end

function MeRunneController:GetSelectRuneData()
  return self.CurSelectRuneData
end

function MeRunneController:GetShowEquipType()
  if self.ShowEquipType == nil then
    self.ShowEquipType = EquipCellType.NORMAL
  end
  return self.ShowEquipType
end

function MeRunneController:GetFirstSuitSkillId()
  local Tab = ClientTable.cfg_Item_equip_runesSuitManager:GetDic()
  for id, itemCfg in pairs(Tab) do
    if self:GetSuitActiveState(id, true) then
      local skillId = self:GetSuitSkillId(itemCfg)
      if skillId ~= nil then
        return skillId
      end
    end
  end
end

function MeRunneController:GetSuitSkillId(suitCfg)
  local suitConfig = suitCfg
  if suitConfig == nil then
    return {}
  end
  if string.isNullOrEmpty(suitConfig.showSkillID) then
    for i = suitConfig.id, 1, -1 do
      local tempConfig = ClientTable.cfg_Item_equip_runesSuitManager:TryGetValue(i)
      if tempConfig and tempConfig.group == suitConfig.group and tempConfig.level < suitConfig.level and not string.isNullOrEmpty(tempConfig.skillID) then
        suitConfig = tempConfig
        break
      end
    end
  end
  local strSplit = string.split(suitConfig.skillID, "&")
  for i, v in ipairs(strSplit) do
    local skillSplit = string.split(v, "#")
    if #skillSplit == 2 and (RoleUtility.GetBasicCareer(RoleManager.me.career) == tonumber(skillSplit[1]) or RoleUtility.GetCurrentCareerCategory() == tonumber(skillSplit[1])) then
      return tonumber(skillSplit[2])
    end
  end
end

function MeRunneController:SetSelectRuneEquip(equipData, equipIndex)
  if equipIndex == nil then
    return
  end
  if self.itemCellData == nil then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(equipData)
  self.CurSelectItemCellRuneEquip = self.itemCellData
  self.CurSelectEquipIndex = equipIndex
  EventManager.Dispatch(Event.SelectedRuneEquip)
end

function MeRunneController:SetSelectRuneType(type)
  if type then
    self.CurSelectRuneHoleType = type
  end
end

function MeRunneController:SetShowEquipType(type)
  if type then
    self.ShowEquipType = type
  end
end

function MeRunneController:ServerUpdateRuneData(data)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():ServerUpdateRuneData(data)
  self:CheckAllSuitActiveStates()
  self:SetSelectRuneData(nil)
end

function MeRunneController:ServerDeleteRuneData(data)
  gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():ServerDeleteRuneData(data)
  self:CheckAllSuitActiveStates()
  self:SetSelectRuneData(nil)
end

function MeRunneController:SetSelectRuneData(data)
  self.CurSelectRuneData = data
  EventManager.Dispatch(Event.SelectedRune)
end

function MeRunneController:CheckRuneRedPoint()
  local equipData = RoleManager.me.data.equipsData.Data
  local temp = false
  local isCan
  for equipIndex, equipData in pairs(equipData) do
    isCan = self:CheckEquipIndexCanSetRune(equipIndex)
    temp = temp or isCan
  end
  return temp
end

function MeRunneController:CheckEquipIndexCanSetRune(equipType)
  local temp = false
  local isCan
  for i, v in pairs(EquipRuneTypeEnum) do
    if v ~= 2 and v ~= 3 then
      isCan = self:CheckEquipHoleCanSetRune(equipType, v)
      temp = temp or isCan
    end
  end
  return temp
end

function MeRunneController:CheckEquipHoleCanSetRune(equipIndex, holeType)
  local equipData = RoleManager.me.data.equipsData.Data
  if equipData[equipIndex] == nil or equipData[equipIndex].isSuit == false then
    return false
  end
  local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
  local bagSetRuneBag = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetCanSetRuneByEquipInBag(equipIndex)
  if equipRuneData == nil then
    return bagSetRuneBag ~= nil and table.count(bagSetRuneBag) > 0 or false
  end
  if equipRuneData[holeType] and table.count(equipRuneData[holeType]) > 0 then
    for i, itemBagRuneData in pairs(bagSetRuneBag) do
      if equipRuneData[holeType].cfgTab.runesRating < ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemBagRuneData.tblItem.id).runesStage then
        return true
      elseif equipRuneData[holeType].cfgTab.runesRating == ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemBagRuneData.tblItem.id).runesStage and equipRuneData[holeType].level < itemBagRuneData.serverInfo.runesLevel then
        return true
      end
    end
    return false
  else
    return bagSetRuneBag ~= nil and table.count(bagSetRuneBag) > 0 or false
  end
end

function MeRunneController:CheckRuneCanSetOrHigh(itemId, level)
  local equipIndex = self:GetSelectEquipIndex()
  local isEquip = ClientTable.cfg_Runes_inlayManager:JudgeCanSetByEquipIndex(itemId, equipIndex)
  if isEquip then
    local equipRuneData = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetItemRuneInfoDataByEquipIndex(equipIndex)
    if equipRuneData == nil then
      return true
    end
    local temp = false
    local isCan
    for i, v in pairs(EquipRuneTypeEnum) do
      if v ~= 2 and v ~= 3 then
        if equipRuneData[v] == nil or table.count(equipRuneData[v]) == 0 then
          isCan = true
        elseif ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemId).runesStage > equipRuneData[v].cfgTab.runesRating then
          isCan = true
        elseif ClientTable.cfg_Runes_inlayManager:GetItemCfgData(itemId).runesStage == equipRuneData[v].cfgTab.runesRating then
          isCan = level > equipRuneData[v].level
        else
          isCan = false
        end
        temp = temp or isCan
      end
    end
    return temp
  end
  return false
end

function MeRunneController:GetSuitActiveState(suitId, notCompati)
  local suitConfig = ClientTable.cfg_Item_equip_runesSuitManager:TryGetValue(suitId)
  if suitConfig == nil then
    return false
  end
  if notCompati then
    if self.CheckSuitIsActiveCache[suitConfig.group] ~= nil then
      for i, v in pairs(self.CheckSuitIsActiveCache[suitConfig.group]) do
        if i == suitConfig.level and v then
          return true
        end
      end
    end
  elseif self.CheckSuitIsActiveCache[suitConfig.group] ~= nil then
    for i, v in pairs(self.CheckSuitIsActiveCache[suitConfig.group]) do
      if i >= suitConfig.level and v then
        return true
      end
    end
  end
  return false
end

function MeRunneController:CheckSuitIsActive(suitId)
  local suitConfig = ClientTable.cfg_Item_equip_runesSuitManager:TryGetValue(suitId)
  if suitConfig == nil then
    return false
  end
  local needRunes = {}
  local equipPositions = string.split(suitConfig.equipPositionSet, "#")
  local runeTypes = string.split(suitConfig.runesSet, "#")
  local nums = string.split(suitConfig.actNum, "#")
  for i1 = 1, #runeTypes do
    needRunes[tonumber(runeTypes[i1])] = tonumber(nums[i1]) or 0
  end
  local runes = gameMgr:GetAvatarManager():GetMainPlayer():GetRuneDataMgr():GetRunesCount(equipPositions)
  if table.isNullOrEmpty(runes) then
    self:ChangeSuitIsActiveCache(suitConfig, false)
    return false
  end
  for i1, v1 in pairs(needRunes) do
    if runes[suitConfig.level] == nil or runes[suitConfig.level][i1] == nil or runes[suitConfig.level][i1] == 0 then
      self:ChangeSuitIsActiveCache(suitConfig, false)
      return false
    end
    local count = 0
    for i2, v2 in pairs(runes) do
      if i2 >= suitConfig.level and v2[i1] ~= nil then
        count = count + v2[i1]
      end
    end
    if v1 > count then
      self:ChangeSuitIsActiveCache(suitConfig, false)
      return false
    end
  end
  self:ChangeSuitIsActiveCache(suitConfig, true)
  return true
end

function MeRunneController:ChangeSuitIsActiveCache(suitConfig, isActive)
  if self.CheckSuitIsActiveCache[suitConfig.group] == nil then
    self.CheckSuitIsActiveCache[suitConfig.group] = {}
  end
  if isActive == true then
    self.CheckSuitIsActiveCache[suitConfig.group][suitConfig.level] = true
  else
    self.CheckSuitIsActiveCache[suitConfig.group][suitConfig.level] = nil
  end
end

function MeRunneController:CheckAllSuitActiveStates()
  local suitConfigs = ClientTable.cfg_Item_equip_runesSuitManager:GetDic()
  for i, v in pairs(suitConfigs) do
    self:CheckSuitIsActive(i)
  end
end
