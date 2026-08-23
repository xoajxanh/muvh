local RegenerateManager = {}
RegenerateManager.RegenerateEquipCellData = nil
RegenerateManager.isLockAttribute = false
RegenerateManager.lockAttributeConfigId = ""
RegenerateManager.lockAttributeIndex = 0

function RegenerateManager:SetRegenerateEquip(equipData)
  if equipData == nil or equipData.tblItem == nil or UIManager.IsVisible(UIID.Equip_RegenerateUI) == false or ItemUtility.IsEquipType(equipData.tblItem.type) == false then
    return
  end
  if self.itemCellData == nil then
    self.itemCellData = ItemCellData()
  end
  self.itemCellData:RefreshData(equipData)
  self.RegenerateEquipCellData = self.itemCellData
  EventManager.Dispatch(Event.Equip_RegenerateChange, self.RegenerateEquipCellData)
end

function RegenerateManager:SetRegenerateEquipByServerDataList(itemInfoList)
  if itemInfoList == nil or self.RegenerateEquipCellData == nil or self.RegenerateEquipCellData.itemData == nil then
    return
  end
  if itemInfoList.id == self.RegenerateEquipCellData.itemData.id then
    self:SetRegenerateEquip(self.RegenerateEquipCellData.itemData)
  end
end

function RegenerateManager:SetRegenerateNewExcellenceList(data)
  self.RegenerateEquipCellData.itemData:SetRegenerateClearAttributeList(data)
  EventManager.Dispatch(Event.Equip_RegenerateNewAttributeChange)
end

function RegenerateManager:SetRegenerateNewExcellenceEvoList(data)
  if data then
    if UIManager.IsVisible(UIID.EffectTipUI) then
      EventManager.Dispatch(Event.TipEffect, {index = 16, time = 1})
    else
      UIManager.Show(UIID.EffectTipUI, {effectIndex = 16, effectTime = 1})
      AudioManager.PlayMusicClipById(3004)
    end
  elseif UIManager.IsVisible(UIID.EffectTipUI) then
    EventManager.Dispatch(Event.TipEffect, {index = 17, time = 1})
  else
    UIManager.Show(UIID.EffectTipUI, {effectIndex = 17, effectTime = 1})
    AudioManager.PlayMusicClipById(3005)
  end
end

function RegenerateManager:EquipPositionCanRegenerate()
  if self.RegenerateEquipCellData == nil then
    return
  end
  local equipData = RoleManager.me.data.equipsData.Data
  if equipData[self.RegenerateEquipCellData.itemData.bagGridIndex] == nil then
    return
  end
  local curEquipData = equipData[self.RegenerateEquipCellData.itemData.bagGridIndex]
  for i, v in pairs(ERoleEquipCanRegenerate) do
    if v == curEquipData.bagGridIndex and table.count(curEquipData:GetEquipExcellenceDesList()) > 0 and curEquipData.intensify >= ClientTable.cfg_Item_equip_regenerateSettingManager:GetSelectCondition(curEquipData.subType) then
      return true
    end
  end
  return false
end

function RegenerateManager:JudgeEquipCanRegenerate(equipData)
  if equipData and table.count(equipData:GetEquipExcellenceDesList()) > 0 then
    return true
  end
  return false
end

function RegenerateManager:GetFirstRegenerateEquip()
  local equipData = RoleManager.me.data.equipsData.Data
  if equipData == nil then
    return nil
  end
  for equipPosition, equipDataItem in pairs(equipData) do
    for i, gridIndex in pairs(ERoleEquipCanRegenerate) do
      if equipDataItem.bagGridIndex == gridIndex and table.count(equipDataItem:GetEquipExcellenceDesList()) > 0 and equipDataItem.intensify >= ClientTable.cfg_Item_equip_regenerateSettingManager:GetSelectCondition(equipDataItem.subType) then
        return equipDataItem, equipPosition
      end
    end
  end
  return nil
end

function RegenerateManager:GetSortOrNotSortRegenerateClearAttribute()
  if self:GetRegenerateLockState() then
    local clearItemAttribute = {}
    local lockAttributeIndex = self:GetLockAttributeIndex()
    local clearAttributeList = self.RegenerateEquipCellData.itemData:GetRegenerateClearAttributeTemplateDesList()
    for i = 1, self.RegenerateEquipCellData.itemData:GetClearAttributeList() do
      if clearAttributeList[i].configId == self:GetLockConfigId() then
        clearItemAttribute = clearAttributeList[i]
        table.remove(clearAttributeList, i)
        clearItemAttribute.lockItem = true
        if lockAttributeIndex > table.count(clearAttributeList) then
          table.insert(clearAttributeList, clearItemAttribute)
          break
        end
        table.insert(clearAttributeList, lockAttributeIndex, clearItemAttribute)
        break
      end
    end
    return clearAttributeList
  else
    return self.RegenerateEquipCellData.itemData:GetRegenerateClearAttributeTemplateDesList()
  end
end

function RegenerateManager:ClearAttributeData()
  self.isLockAttribute = false
  self.lockAttributeConfigId = ""
  self.lockAttributeIndex = 0
  EventManager.Dispatch(Event.Equip_RegenerateNewAttributeChange)
end

function RegenerateManager:SetRegenerateLockStateChange(state)
  self.isLockAttribute = state
  EventManager.Dispatch(Event.Equip_RegenerateLockStateChange)
end

function RegenerateManager:GetRegenerateLockState()
  return self.isLockAttribute
end

function RegenerateManager:SetLockConfigId(id)
  self.lockAttributeConfigId = tostring(id)
end

function RegenerateManager:GetLockConfigId()
  return self.lockAttributeConfigId
end

function RegenerateManager:GetRegenerateCost()
  if self.RegenerateEquipCellData ~= nil then
    return ClientTable.cfg_Item_equip_regenerateSettingManager:GetRegenerateCostList(self.RegenerateEquipCellData.itemData.subType, self.isLockAttribute)
  end
end

function RegenerateManager:GetRegenerateEvolutionCost()
  if self.RegenerateEquipCellData ~= nil then
    return ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateCostList(self.RegenerateEquipCellData.itemData)
  end
end

function RegenerateManager:CheckOpenCondition()
  if self.RegenerateEquipCellData ~= nil then
    return self.RegenerateEquipCellData.itemData:GetNewAttributeList() > 0 and self.RegenerateEquipCellData.itemData.intensify >= ClientTable.cfg_Item_equip_regenerateSettingManager:GetSelectCondition(self.RegenerateEquipCellData.itemData.subType)
  end
  return false
end

function RegenerateManager:SetLockAttributeIndex(lockAttributeIndex)
  self.lockAttributeIndex = lockAttributeIndex
end

function RegenerateManager:GetLockAttributeIndex()
  return self.lockAttributeIndex
end

function RegenerateManager:GetRegenerateyeqian()
  local RegEvolutable = self:GetReg(RoleManager.me.data.equipsData.Data)
  for i, v in pairs(RegEvolutable) do
    local level = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(v.subType)
    if v:GetNewAttributeList() == 0 and v.intensify >= ClientTable.cfg_Item_equip_regenerateSettingManager:GetSelectCondition(v.subType) then
      local countreg = BagInfoData.GetItemTotalCountByItemId(ClientTable.cfg_Item_equip_regenerateSettingManager:GetRegenerateCostList(v.subType, false)[1].itemId)
      if 0 < countreg then
        EventManager.Dispatch(Event.CallRefreshRedPoint, {
          id = ERedPointId.Regene_1
        })
        return true
      end
    elseif v:GetNewAttributeList() > 0 and level > v.serverInfo.regenerateLevel then
      local countevo = BagInfoData.GetItemTotalCountByItemId(ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegeneratecostList(v.subType))
      if v.serverInfo.regenerateLevel ~= level then
        local costList = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateCostList(v)
        local count = 9999
        if costList ~= nil and 0 < #costList then
          count = costList[1].count
        end
        if countevo >= count then
          EventManager.Dispatch(Event.CallRefreshRedPoint, {
            id = ERedPointId.Regene_2
          })
          return true
        end
      end
    end
  end
  return false
end

function RegenerateManager:GetRegenerate()
  local itembol = false
  if self.RegenerateEquipCellData ~= nil then
    for k, y in pairs(ERoleEquipCanRegenerate) do
      if self.RegenerateEquipCellData.itemData.bagGridIndex == y then
        itembol = true
      end
    end
    local equipdata = self.RegenerateEquipCellData.itemData
    if itembol and equipdata:GetNewAttributeList() == 0 and equipdata.intensify >= ClientTable.cfg_Item_equip_regenerateSettingManager:GetSelectCondition(equipdata.subType) and equipdata ~= nil then
      local countreg = BagInfoData.GetItemTotalCountByItemId(ClientTable.cfg_Item_equip_regenerateSettingManager:GetRegenerateCostList(equipdata.subType, false)[1].itemId)
      if 0 < countreg then
        return true
      end
    end
  end
  return false
end

function RegenerateManager:GetRegenerateEvolu()
  if self.RegenerateEquipCellData ~= nil then
    local equipdata = self.RegenerateEquipCellData.itemData
    local level = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(equipdata.subType)
    if equipdata:GetNewAttributeList() > 0 and equipdata ~= nil and equipdata.serverInfo.regenerateLevel ~= level then
      local costList = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateCostList(equipdata)
      local countevo = BagInfoData.GetItemTotalCountByItemId(ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegeneratecostList(equipdata.subType))
      if 0 < #costList and costList ~= nil then
        local count = 9999
        count = costList[1].count
        if countevo >= count then
          return true
        end
      end
    end
  end
  return false
end

function RegenerateManager:GetRegenerateEquip(Equip_itemdata)
  if Equip_itemdata ~= nil then
    local level = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateLevelList(Equip_itemdata.subType)
    if Equip_itemdata:GetNewAttributeList() == 0 and Equip_itemdata.intensify >= ClientTable.cfg_Item_equip_regenerateSettingManager:GetSelectCondition(Equip_itemdata.subType) then
      local countreg = BagInfoData.GetItemTotalCountByItemId(ClientTable.cfg_Item_equip_regenerateSettingManager:GetRegenerateCostList(Equip_itemdata.subType, false)[1].itemId)
      if 0 < countreg then
        EventManager.Dispatch(Event.CallRefreshRedPoint, {
          id = ERedPointId.Regene_1
        })
        return true
      end
    end
    if Equip_itemdata:GetNewAttributeList() > 0 and level > Equip_itemdata.serverInfo.regenerateLevel then
      local countevo = BagInfoData.GetItemTotalCountByItemId(ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegeneratecostList(Equip_itemdata.subType))
      local costList = ClientTable.cfg_Item_equip_regenerateEvolutionManager:GetRegenerateCostList(Equip_itemdata)
      local count = 9999
      if costList ~= nil and 0 < #costList then
        count = costList[1].count
      end
      if countevo >= count then
        EventManager.Dispatch(Event.CallRefreshRedPoint, {
          id = ERedPointId.Regene_2
        })
        return true
      end
    end
  end
  return false
end

function RegenerateManager:GetReg(equipData)
  local RegEvolutable = {}
  local EquipData
  if equipData ~= nil then
    EquipData = equipData
    for i, v in pairs(EquipData) do
      for k, y in pairs(ERoleEquipCanRegenerate) do
        if i == y then
          table.insert(RegEvolutable, v)
        end
      end
    end
  end
  return RegEvolutable
end

return RegenerateManager
