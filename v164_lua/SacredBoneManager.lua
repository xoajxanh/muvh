local SacredBoneManager = {}
SacredBoneManager.SacredBoneEquipSelectIndex = 1
SacredBoneManager.SacredBoneType = nil
SacredBoneManager.SacredBoneSelectIndex = nil
SacredBoneManager.SacredBoneEquipData = nil
SacredBoneManager.SacredBoneBagItemData = nil
SacredBoneManager.SacredBoneEquipInfoType = false
SacredBoneManager.tonglingId = 10061

function SacredBoneManager:Init()
  self:SacredBoneBagReset()
  self:SacredBoneReset()
end

function SacredBoneManager:SacredBoneBagReset()
  if self.SacredBoneBagItemData ~= nil then
    for k, _ in pairs(self.SacredBoneBagItemData) do
      self.SacredBoneBagItemData[k] = nil
    end
  end
  self.SacredBoneBagItemData = {}
end

function SacredBoneManager:SacredBoneReset()
  self.SacredBoneEquipData = {}
  for hole = 1, 7 do
    if self.SacredBoneEquipData[hole] == nil then
      local sacredBoneEquipData = LuaClass.SacredBoneEquipData:New()
      sacredBoneEquipData:InitData(hole)
      self.SacredBoneEquipData[hole] = sacredBoneEquipData
    end
  end
end

function SacredBoneManager:OnResBagInfo(msg)
  if msg == nil then
    return
  end
  for i, item in pairs(msg.items) do
    local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(item.itemId)
    if itemCfg and itemCfg.bagType and itemCfg.bagType == 1 then
      local itemBagData = self:GetBagDataByOnlyId(item.id)
      if itemBagData == nil then
        local sacredBoneBagData = LuaClass.SacredBoneBagData:New()
        sacredBoneBagData:RefreshData(item)
        table.insert(self.SacredBoneBagItemData, sacredBoneBagData)
      end
    end
  end
  self:RefreshCurFilterConditionAllItemId(true)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.sacred_Bone_Synthesis
  })
end

function SacredBoneManager:OnResBagChange(msg)
  if msg == nil then
    return
  end
  self:RemoveBagItemData(msg.removeItem)
  self:UpdateBagItemData(msg.items)
  EventManager.Dispatch(Event.SacredBoneBagChange)
  EventManager.Dispatch(Event.CallRefreshRedPoint, {
    id = ERedPointId.sacred_Bone_Synthesis
  })
end

function SacredBoneManager:RemoveBagItemData(removeItems)
  if removeItems == nil or table.count(removeItems) == 0 then
    return
  end
  for _, id in pairs(removeItems) do
    local index = self:GetBagDataIndexById(id)
    if index and self.SacredBoneBagItemData and self.SacredBoneBagItemData[index] then
      SacredBoneManager:QuickMsg(0, self.SacredBoneBagItemData[index], self.SacredBoneBagItemData[index].ItemCount)
      table.remove(self.SacredBoneBagItemData, index)
    end
  end
end

function SacredBoneManager:OnShowChangeInfo(msg)
  if table.count(msg.items) == 0 then
    return
  end
  if msg.logType == BagChangeTypeEnum.Mail or msg.logType == BagChangeTypeEnum.OptionalBox then
    local showTbl = {}
    for index, itemServerInfo in ipairs(msg.items) do
      local serverData = table.clone(itemServerInfo)
      local bagData = self:GetBagDataByOnlyId(itemServerInfo.id)
      if table.count(bagData) > 0 then
        serverData.count = serverData.count - bagData.ItemCount
      end
      local itemData = ItemUtility.GenerateItemDataByServerData(serverData)
      table.insert(showTbl, itemData)
    end
    if table.count(showTbl) > 0 then
      UIManager.Show(UIID.Tip_RewardTipUI, {rewards = showTbl})
      FloatingWordUtility.QuickMsg("Nh\225\186\173n th\195\160nh c\195\180ng")
    end
  end
end

function SacredBoneManager:UpdateBagItemData(changeItems)
  if changeItems == nil or table.count(changeItems) == 0 then
    return
  end
  for i, changeItem in pairs(changeItems) do
    local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(changeItem.itemId)
    if itemCfg and itemCfg.bagType and itemCfg.bagType == 1 then
      local itemBagData = self:GetBagDataByOnlyId(changeItem.id)
      if itemBagData == nil then
        local sacredBoneBagData = LuaClass.SacredBoneBagData:New()
        sacredBoneBagData:RefreshData(changeItem)
        table.insert(self.SacredBoneBagItemData, sacredBoneBagData)
        SacredBoneManager:QuickMsg(1, sacredBoneBagData, changeItem.count)
      else
        local changeCount = Mathf.Abs(itemBagData.ItemCount - changeItem.count)
        SacredBoneManager:QuickMsg(itemBagData.ItemCount > changeItem.count and 0 or 1, itemBagData, changeCount)
        itemBagData:UpdateCount(changeItem.count)
      end
    end
  end
end

function SacredBoneManager:RefreshSacredBoneEquipInfo(msg)
  self:SacredBoneReset()
  self:OnResSacredBoneEquipInfo(msg)
end

function SacredBoneManager:OnResSacredBoneEquipInfo(msg)
  if msg == nil or msg.holyBoneInfo == nil then
    return
  end
  for i, v in ipairs(msg.holyBoneInfo) do
    local type = v.type
    local grade = v.grade
    local castHole = ClientTable.cfg_Bone_castManager:BoneCastAttribute(type, grade)
    for index, holeIndex in pairs(v.holyBoneGap) do
      if self.SacredBoneEquipData[v.type].SacredBoneData[index] and holeIndex.id ~= 0 and index <= castHole then
        local itemData = self.SacredBoneEquipData[v.type].SacredBoneData[index]
        itemData:RefreshLockState(false)
        if itemData and holeIndex.id ~= 0 and itemData.SacredBoneLockType == false then
          itemData:RefreshSacredBoneItemData(holeIndex.items)
        end
        if itemData.SacredBoneEquip then
          itemData:RefreshSetState(true)
        end
      end
    end
  end
end

function SacredBoneManager:OnResSacredBoneItemChange(msg)
  if msg == nil then
    return
  end
  self:RemoveSacredBoneItemData(msg)
  self:UpdateSacredBoneItemData(msg)
  EventManager.Dispatch(Event.SacredBoneEquipChange)
  EventManager.Dispatch(Event.HolySkeletonEquipSetChange)
end

function SacredBoneManager:RemoveSacredBoneItemData(takeOff)
  if takeOff and table.count(takeOff) > 0 and takeOff.type then
    for i, v in ipairs(takeOff.holyBoneGap) do
      if self.SacredBoneEquipData[takeOff.type].SacredBoneData[v.id] then
        self.SacredBoneEquipData[takeOff.type].SacredBoneData[v.id]:RemoveSacredBoneItemData()
      end
    end
  end
end

function SacredBoneManager:UpdateSacredBoneItemData(putOn)
  if putOn and table.count(putOn) > 0 and putOn.type then
    for i, v in ipairs(putOn.holyBoneGap) do
      if self.SacredBoneEquipData[putOn.type].SacredBoneData[v.id] then
        local itemData = self.SacredBoneEquipData[putOn.type].SacredBoneData[v.id]
        itemData:RefreshLockState(false)
        itemData:RefreshSacredBoneItemData(v.items)
        if itemData.SacredBoneEquip then
          itemData:RefreshSetState(true)
        end
      end
    end
  end
end

function SacredBoneManager:GetBagDataIndexById(id)
  if self.SacredBoneBagItemData ~= nil and table.count(self.SacredBoneBagItemData) > 0 then
    for index, v in pairs(self.SacredBoneBagItemData) do
      if v.ItemInfo.id == id then
        return index
      end
    end
  end
  return nil
end

function SacredBoneManager:GetBagDataByOnlyId(id)
  if self.SacredBoneBagItemData ~= nil and table.count(self.SacredBoneBagItemData) > 0 then
    for index, v in pairs(self.SacredBoneBagItemData) do
      if v.ItemInfo.id == id then
        return self.SacredBoneBagItemData[index]
      end
    end
  end
  return nil
end

function SacredBoneManager:GetBagEquipDataByOnlyId(id, index)
  if not self.SacredBoneBagItemData then
    return
  end
  local data = self.SacredBoneBagItemData
  local SacredBoneType = false
  if index == 1 then
    SacredBoneType = true
  end
  local EquipDataItemData = {}
  for i, v in ipairs(data) do
    if v.SacredBoneType then
      local idType = false
      local type = string.split(v.SacredBoneType, "#")
      for x, y in ipairs(type) do
        if tonumber(y) == id then
          idType = true
        end
      end
      if idType and SacredBoneType and (v.SoulType == 1 or v.SoulType == 2) then
        table.insert(EquipDataItemData, v)
      elseif idType and not SacredBoneType and (v.SoulType == 0 or v.SoulType == 3) then
        table.insert(EquipDataItemData, v)
      end
    end
  end
  table.sort(EquipDataItemData, function(a, b)
    return a.Quality > b.Quality
  end)
  return EquipDataItemData
end

function SacredBoneManager:GetEquipDataIndex()
  if self.SacredBoneEquipInfoType then
    self.SacredBoneEquipInfoType = false
    return self.SacredBoneEquipSelectIndex
  end
  for i = 1, table.count(HolySkeletonPlace) do
    for x, y in ipairs(self.SacredBoneEquipData[i].SacredBoneData) do
      if not y.SacredBoneLockType and y.SacredBoneSetType == false and table.count(self:GetBagEquipDataByOnlyId(i, y.SacredBoneIndex)) > 0 then
        self.SacredBoneEquipSelectIndex = i
        return self.SacredBoneEquipSelectIndex
      end
    end
  end
  self.SacredBoneEquipSelectIndex = 1
  return self.SacredBoneEquipSelectIndex
end

function SacredBoneManager:SetSacredBoneEquipRedPoint(place)
  for i, v in ipairs(self.SacredBoneEquipData[place].SacredBoneData) do
    if v.SacredBoneLockType == false and v.SacredBoneSetType == false then
      if table.count(self:GetBagEquipDataByOnlyId(place, v.SacredBoneIndex)) > 0 then
        return true
      end
    elseif v.SacredBoneLockType == false and v.SacredBoneSetType == true and table.count(self:GetBagEquipDataByOnlyId(place, v.SacredBoneIndex)) > 0 then
      for j, k in ipairs(self:GetBagEquipDataByOnlyId(place, v.SacredBoneIndex)) do
        if k.Quality > v.SacredBoneEquip.Quality then
          return true
        end
      end
    end
  end
  return false
end

function SacredBoneManager:SetSacredBoneRedPoint(index)
  if self.SacredBoneEquipData[self.SacredBoneEquipSelectIndex].SacredBoneData then
    local itemData = self.SacredBoneEquipData[self.SacredBoneEquipSelectIndex].SacredBoneData[index]
    if itemData.SacredBoneLockType == false and itemData.SacredBoneSetType == false and table.count(self:GetBagEquipDataByOnlyId(self.SacredBoneEquipSelectIndex, index)) > 0 then
      return true
    elseif itemData.SacredBoneLockType == false and itemData.SacredBoneSetType == true then
      for j, k in ipairs(self:GetBagEquipDataByOnlyId(self.SacredBoneEquipSelectIndex, index)) do
        if k.Quality > itemData.SacredBoneEquip.Quality then
          return true
        end
      end
    end
  end
  return false
end

function SacredBoneManager:SetSacredBoneTogRedPoint()
  for i, v in ipairs(self.SacredBoneEquipData) do
    if self:SetSacredBoneEquipRedPoint(i) then
      return true
    end
  end
  return false
end

function SacredBoneManager:SetSacredBone()
  return self.SacredBoneEquipData
end

local BoneEquipIndexMap = {
  [2] = 1,
  [8] = 2,
  [4] = 3,
  [5] = 4,
  [6] = 5,
  [9] = 6,
  [10] = 7
}

function SacredBoneManager:GetSacredBoneInfo(equipIndex)
  equipIndex = BoneEquipIndexMap[equipIndex]
  local SacredBonetbl = {}
  if equipIndex == nil then
    return SacredBonetbl
  end
  local entryValue, entryType
  local sacredBones = self.SacredBoneEquipData[equipIndex]
  if sacredBones.SacredBoneData then
    for i, v in ipairs(sacredBones.SacredBoneData) do
      if v.SacredBoneEquip and type(v.SacredBoneEquip) == "table" and v.SacredBoneEquip.ItemInfo then
        local attrCfg = ClientTable.cfg_Bone_attributeManager:TryGetValue(tostring(v.SacredBoneEquip.ItemInfo.itemId), "relationItem")
        if attrCfg and attrCfg.entryType > 900 then
          entryType = attrCfg.entryType % 900
          entryValue = attrCfg.valueTwo
          table.insert(SacredBonetbl, {
            addition = 0,
            itemInfo = v.SacredBoneEquip.ItemInfo
          })
        else
          local attr = ClientTable.cfg_Bone_attributeManager:TryGetValue(v.SacredBoneEquip.ItemInfo.boneSoulInfo[1].configId)
          if attr == nil then
            logError("cfg_Bone_attribute:" .. v.SacredBoneEquip.ItemInfo.boneSoulInfo[1].configId .. "id kh\195\180ng t\225\187\147n t\225\186\161i ")
            break
          end
          if entryType then
            if entryType == 99 or entryType == attr.entryType then
              table.insert(SacredBonetbl, {
                addition = entryValue,
                itemInfo = v.SacredBoneEquip.ItemInfo
              })
            else
              table.insert(SacredBonetbl, {
                addition = 0,
                itemInfo = v.SacredBoneEquip.ItemInfo
              })
            end
          else
            table.insert(SacredBonetbl, {
              addition = 0,
              itemInfo = v.SacredBoneEquip.ItemInfo
            })
          end
        end
      end
    end
  end
  return SacredBonetbl
end

function SacredBoneManager:SacredBoneDataInfo(data)
  local SacredBoneDatatbl = {}
  if data == nil then
    return SacredBoneDatatbl
  end
  local entryValue, entryType
  local sacredBones = data
  if sacredBones then
    for i, v in ipairs(sacredBones) do
      if v.SacredBoneEquip and type(v.SacredBoneEquip) == "table" and v.SacredBoneEquip.ItemInfo then
        local attrCfg = ClientTable.cfg_Bone_attributeManager:TryGetValue(tostring(v.SacredBoneEquip.ItemInfo.itemId), "relationItem")
        if attrCfg and attrCfg.entryType > 900 then
          entryType = attrCfg.entryType % 900
          entryValue = attrCfg.valueTwo
          table.insert(SacredBoneDatatbl, {
            addition = 0,
            itemInfo = v.SacredBoneEquip.ItemInfo
          })
        else
          local attr = ClientTable.cfg_Bone_attributeManager:TryGetValue(v.SacredBoneEquip.ItemInfo.boneSoulInfo[1].configId)
          if attr == nil then
            logError("cfg_Bone_attribute:" .. v.SacredBoneEquip.ItemInfo.boneSoulInfo[1].configId .. "id kh\195\180ng t\225\187\147n t\225\186\161i ")
            break
          end
          if entryType then
            if entryType == 99 or entryType == attr.entryType then
              table.insert(SacredBoneDatatbl, {
                addition = entryValue,
                itemInfo = v.SacredBoneEquip.ItemInfo
              })
            else
              table.insert(SacredBoneDatatbl, {
                addition = 0,
                itemInfo = v.SacredBoneEquip.ItemInfo
              })
            end
          else
            table.insert(SacredBoneDatatbl, {
              addition = 0,
              itemInfo = v.SacredBoneEquip.ItemInfo
            })
          end
        end
      else
        table.insert(SacredBoneDatatbl, {addition = 0, itemInfo = nil})
      end
    end
  end
  return SacredBoneDatatbl
end

function SacredBoneManager:GetSuitDes(equipIndex)
  local suitCount = {}
  equipIndex = BoneEquipIndexMap[equipIndex]
  if equipIndex == nil then
    return
  end
  for i, sacredBoneEquipv in pairs(self.SacredBoneEquipData) do
    if sacredBoneEquipv.SacredBoneData and sacredBoneEquipv.SacredBoneData[1] and sacredBoneEquipv.SacredBoneData[1].SacredBoneEquip then
      local itemCfg = ClientTable.cfg_Item_equipManager:TryGetValue(sacredBoneEquipv.SacredBoneData[1].SacredBoneEquip.ItemId)
      if itemCfg then
        local suitSplit = string.split(itemCfg.suitId, "#")
        local suitId = tonumber(suitSplit[1])
        local suitLevel = tonumber(suitSplit[2])
        if suitCount[suitId] == nil then
          suitCount[suitId] = {}
        end
        if suitCount[suitId][suitLevel] == nil then
          suitCount[suitId][suitLevel] = 0
        end
        suitCount[suitId][suitLevel] = suitCount[suitId][suitLevel] + 1
      end
    end
  end
  for i, v in pairs(suitCount) do
    local count = 0
    for i = 7, 1, -1 do
      if v[i] then
        count = count + v[i]
        v[i] = count
      end
    end
  end
  
  local function VaruateCount(level)
    if suitCount[self.tonglingId] then
      if suitCount[self.tonglingId][level] then
        return suitCount[self.tonglingId][level]
      end
      for i = level, 7 do
        if suitCount[self.tonglingId][i] then
          return suitCount[self.tonglingId][i]
        end
      end
    end
    return 0
  end
  
  local curEquipSacredBone = self.SacredBoneEquipData[equipIndex]
  if curEquipSacredBone and curEquipSacredBone.SacredBoneData[1] and curEquipSacredBone.SacredBoneData[1].SacredBoneEquip then
    local itemCfg = ClientTable.cfg_Item_equipManager:TryGetValue(curEquipSacredBone.SacredBoneData[1].SacredBoneEquip.ItemId)
    if itemCfg then
      local suitSplit = string.split(itemCfg.suitId, "#")
      local suitId = tonumber(suitSplit[1])
      local suitLevel = tonumber(suitSplit[2])
      if itemCfg.subType == EItemSubtype.GeneralSacredBone then
        for ei, ev in pairs(suitCount) do
          if ei ~= self.tonglingId then
            for i = suitLevel, 1, -1 do
              if ev[i] and 7 <= ev[i] + VaruateCount(i) then
                local suitCfg = ClientTable.cfg_Item_equip_suitManager:TryGetValueFromIdAndLevel(ei, i)
                return suitCfg, ev[i] + VaruateCount(i)
              end
            end
          end
        end
        local suitCfg = ClientTable.cfg_Item_equip_suitManager:TryGetValueFromIdAndLevel(suitId, suitLevel)
        return suitCfg, suitCount[suitId][suitLevel]
      else
        for i = suitLevel, 1, -1 do
          if suitCount[suitId][i] and 7 <= suitCount[suitId][i] + VaruateCount(i) then
            local suitCfg = ClientTable.cfg_Item_equip_suitManager:TryGetValueFromIdAndLevel(suitId, i)
            return suitCfg, suitCount[suitId][i] + VaruateCount(i)
          end
        end
        local suitCfg = ClientTable.cfg_Item_equip_suitManager:TryGetValueFromIdAndLevel(suitId, suitLevel)
        return suitCfg, suitCount[suitId][suitLevel] + VaruateCount(suitLevel)
      end
    end
  end
end

function SacredBoneManager:GetSuitPartDes(suitCfg)
  if suitCfg == nil then
    return {}
  end
  local suitDesTab = {}
  for i = 1, 7 do
    local euipData = self.SacredBoneEquipData[i]
    local des = HolySkeletonPlaceName[i]
    if euipData and euipData.SacredBoneData[1] and euipData.SacredBoneData[1].SacredBoneEquip then
      local itemCfg = ClientTable.cfg_Item_equipManager:TryGetValue(euipData.SacredBoneData[1].SacredBoneEquip.ItemId)
      if itemCfg then
        local suitSplit = string.split(itemCfg.suitId, "#")
        local suitId = tonumber(suitSplit[1])
        local suitLevel = tonumber(suitSplit[2])
        if (suitId == suitCfg.suitId or itemCfg.subType == EItemSubtype.GeneralSacredBone) and suitLevel >= suitCfg.level then
          des = string.GetColorText(des .. "   " .. itemCfg.name, ItemQuality2ColorDic[EItemColorEnum.yellow])
        else
          des = string.GetColorText(des .. "   " .. itemCfg.name, ItemQuality2ColorDic[EItemColorEnum.gray])
        end
      else
        des = string.GetColorText(des .. "Ch\198\176a kh\225\186\163m", ItemQuality2ColorDic[EItemColorEnum.gray])
      end
    else
      des = string.GetColorText(des .. "Ch\198\176a kh\225\186\163m", ItemQuality2ColorDic[EItemColorEnum.gray])
    end
    table.insert(suitDesTab, des)
  end
  return suitDesTab
end

function SacredBoneManager:GetSacredBoneEquipIndex(equipIndex)
  self.SacredBoneEquipSelectIndex = equipIndex
end

function SacredBoneManager:GetSacredBoneEquipDataIndex(equipDataIndex)
  self.SacredBoneSelectIndex = equipDataIndex
end

function SacredBoneManager:GetSacredBoneEquipDataByBoneEquipIndexMap()
  local sacredBoneEquipDataDic = {}
  for newIndex, oldIndex in pairs(BoneEquipIndexMap) do
    if self.SacredBoneEquipData[oldIndex] then
      sacredBoneEquipDataDic[newIndex] = self.SacredBoneEquipData[oldIndex]
    end
  end
  return sacredBoneEquipDataDic
end

function SacredBoneManager:SetSacredBoneEquipIndex()
  return self.SacredBoneEquipSelectIndex
end

function SacredBoneManager:SetSacredBoneEquipDataIndex()
  return self.SacredBoneSelectIndex
end

function SacredBoneManager:SetHolySkeletonCombineOtherViewTemp(temp)
  self.holySkeletonCombineOtherViewTemp = temp
end

function SacredBoneManager:SetHolySkeletonCombineSoulBagTemp(temp)
  self.holySkeletonCombineSoulBagTemp = temp
end

function SacredBoneManager:SetCombineSoulBagSoulTypeDropDownMaxValue(maxValue)
  self.combineSoulBagSoulTypeDropDownMaxValue = maxValue
end

function SacredBoneManager:SetCombineSoulBagModQulityDropDownMaxValue(maxValue)
  self.combineSoulBagModQulityDropDownMaxValue = maxValue
end

function SacredBoneManager:GetHolySkeletonCombineOtherViewTemp()
  return self.holySkeletonCombineOtherViewTemp
end

function SacredBoneManager:GetHolySkeletonCombineSoulBagTemp()
  return self.holySkeletonCombineSoulBagTemp
end

function SacredBoneManager:GetCurFilterConditionAllItemId()
  return self.curFilterConditionCanCombineItemIds or {}
end

function SacredBoneManager:GetCombineSoulBagSoulTypeDropDownMaxValue()
  return self.combineSoulBagSoulTypeDropDownMaxValue or 2
end

function SacredBoneManager:GetCombineSoulBagModQulityDropDownMaxValue()
  return self.combineSoulBagModQulityDropDownMaxValue or 5
end

function SacredBoneManager:GetMeetCombineHolySkeletonBagData(chooseSoulType, chooseSoulQuality)
  local meetCombineHolySkeletonBagData = {}
  local allHolySkeletonBagData = self.SacredBoneBagItemData
  for i, holySkeletonBagData in pairs(allHolySkeletonBagData) do
    if holySkeletonBagData.SoulType == chooseSoulType and holySkeletonBagData.ModQuality == chooseSoulQuality then
      table.insert(meetCombineHolySkeletonBagData, holySkeletonBagData)
    end
  end
  table.sort(meetCombineHolySkeletonBagData, function(a, b)
    if a and b then
      if a.SoulType == b.SoulType then
        return a.ModQuality < b.ModQuality
      else
        return a.SoulType < b.SoulType
      end
    else
      return false
    end
  end)
  self:RefreshCurFilterConditionAllItemId(false, meetCombineHolySkeletonBagData)
  return meetCombineHolySkeletonBagData
end

function SacredBoneManager:RefreshCurFilterConditionAllItemId(isInit, meetCombineHolySkeletonBagData)
  if isInit == true then
    meetCombineHolySkeletonBagData = self.SacredBoneBagItemData
  end
  local curAllMeetConditionBagDataBySoulTypeAndModQuality = {}
  for i, bagData in pairs(meetCombineHolySkeletonBagData) do
    if self:CheckIsCanResumeCombine(bagData.SoulType, bagData.ModQuality) == true then
      if curAllMeetConditionBagDataBySoulTypeAndModQuality[bagData.SoulType] == nil then
        curAllMeetConditionBagDataBySoulTypeAndModQuality[bagData.SoulType] = {}
      end
      if curAllMeetConditionBagDataBySoulTypeAndModQuality[bagData.SoulType][bagData.ModQuality] == nil then
        curAllMeetConditionBagDataBySoulTypeAndModQuality[bagData.SoulType][bagData.ModQuality] = {}
      end
      table.insert(curAllMeetConditionBagDataBySoulTypeAndModQuality[bagData.SoulType][bagData.ModQuality], bagData)
    end
  end
  self.curFilterConditionCanCombineItemIds = {}
  for soulType, soulTypeData in pairs(curAllMeetConditionBagDataBySoulTypeAndModQuality) do
    for modQuality, modQualityData in pairs(soulTypeData) do
      if soulType ~= 3 then
        local count = 0
        for i, bagData in pairs(modQualityData) do
          count = count + bagData.ItemCount
        end
        if count >= self:GetMeetCombineCount(soulType, modQuality) then
          for i, bagData in pairs(modQualityData) do
            table.insert(self.curFilterConditionCanCombineItemIds, bagData.ItemId)
          end
        end
      else
        local bagDataBySubType = {}
        for i, bagData in pairs(modQualityData) do
          if bagDataBySubType[bagData.SubType] == nil then
            bagDataBySubType[bagData.SubType] = {}
          end
          table.insert(bagDataBySubType[bagData.SubType], bagData)
          if bagDataBySubType[bagData.SubType].count == nil then
            bagDataBySubType[bagData.SubType].count = 0
          end
          bagDataBySubType[bagData.SubType].count = bagDataBySubType[bagData.SubType].count + bagData.ItemCount
        end
        for subType, subTypeData in pairs(bagDataBySubType) do
          if subTypeData.count >= self:GetMeetCombineCount(soulType, modQuality) and subTypeData[1] then
            table.insert(self.curFilterConditionCanCombineItemIds, subTypeData[1].ItemId)
          end
        end
      end
    end
  end
end

function SacredBoneManager:CheckCurFilterConditionSoulCountIsMeetCombine(chooseSoulType, chooseSoulQuality)
  local allFilteredTypeAndQualityBagData = {}
  local allHolySkeletonBagData = self.SacredBoneBagItemData
  for i, holySkeletonBagData in pairs(allHolySkeletonBagData) do
    if allFilteredTypeAndQualityBagData[holySkeletonBagData.SoulType] == nil then
      allFilteredTypeAndQualityBagData[holySkeletonBagData.SoulType] = {}
    end
    if allFilteredTypeAndQualityBagData[holySkeletonBagData.SoulType][holySkeletonBagData.ModQuality] == nil then
      allFilteredTypeAndQualityBagData[holySkeletonBagData.SoulType][holySkeletonBagData.ModQuality] = {}
    end
    table.insert(allFilteredTypeAndQualityBagData[holySkeletonBagData.SoulType][holySkeletonBagData.ModQuality], holySkeletonBagData)
  end
  if allFilteredTypeAndQualityBagData[chooseSoulType] and allFilteredTypeAndQualityBagData[chooseSoulType][chooseSoulQuality] then
    if not self:CheckIsCanResumeCombine(chooseSoulType, chooseSoulQuality) then
      return false
    end
    if chooseSoulType ~= 3 then
      local count = 0
      for i, v in pairs(allFilteredTypeAndQualityBagData[chooseSoulType][chooseSoulQuality]) do
        count = count + v.ItemCount
      end
      if count >= self:GetMeetCombineCount(chooseSoulType, chooseSoulQuality) then
        return true
      end
    else
      local countTblBySubType = {}
      for i, bagData in pairs(allFilteredTypeAndQualityBagData[chooseSoulType][chooseSoulQuality]) do
        if countTblBySubType[bagData.SubType] == nil then
          countTblBySubType[bagData.SubType] = 0
        end
        countTblBySubType[bagData.SubType] = countTblBySubType[bagData.SubType] + bagData.ItemCount
      end
      for subType, count in pairs(countTblBySubType) do
        if count >= self:GetMeetCombineCount(chooseSoulType, chooseSoulQuality) then
          return true
        end
      end
    end
  end
  return false
end

function SacredBoneManager:CheckIsShowCombineRedPoint()
  local allFilteredHolySkeletonBagData = {}
  local allHolySkeletonBagData = self.SacredBoneBagItemData
  for i, holySkeletonBagData in pairs(allHolySkeletonBagData) do
    if self:CheckIsCanResumeCombine(holySkeletonBagData.SoulType, holySkeletonBagData.ModQuality) == true then
      if allFilteredHolySkeletonBagData[holySkeletonBagData.SoulType] == nil then
        allFilteredHolySkeletonBagData[holySkeletonBagData.SoulType] = {}
      end
      if allFilteredHolySkeletonBagData[holySkeletonBagData.SoulType][holySkeletonBagData.ModQuality] == nil then
        allFilteredHolySkeletonBagData[holySkeletonBagData.SoulType][holySkeletonBagData.ModQuality] = {}
      end
      table.insert(allFilteredHolySkeletonBagData[holySkeletonBagData.SoulType][holySkeletonBagData.ModQuality], holySkeletonBagData)
    end
  end
  for soulType, soulTypeData in pairs(allFilteredHolySkeletonBagData) do
    for modQuality, modQualityData in pairs(soulTypeData) do
      if soulType ~= 3 then
        local count = 0
        for i, bagData in pairs(modQualityData) do
          count = count + bagData.ItemCount
        end
        if count >= self:GetMeetCombineCount(soulType, modQuality) then
          return true
        end
      else
        local countTblBySubType = {}
        for i, bagData in pairs(modQualityData) do
          if countTblBySubType[bagData.SubType] == nil then
            countTblBySubType[bagData.SubType] = 0
          end
          countTblBySubType[bagData.SubType] = countTblBySubType[bagData.SubType] + bagData.ItemCount
        end
        for subType, count in pairs(countTblBySubType) do
          if count >= self:GetMeetCombineCount(soulType, modQuality) then
            return true
          end
        end
      end
    end
  end
  return false
end

function SacredBoneManager:GetMeetCombineCount(soulType, modQuality)
  local meetCombineCount = 0
  if soulType == 0 then
    if modQuality == 5 then
      meetCombineCount = 2
    else
      meetCombineCount = 3
    end
  else
    meetCombineCount = 2
  end
  return meetCombineCount
end

function SacredBoneManager:CheckIsCanResumeCombine(soulType, modQuality)
  return true
end

function SacredBoneManager:CheckIsShowFixedCombineOption()
  local allHolySkeletonBagData = self.SacredBoneBagItemData
  for i, holySkeletonBagData in pairs(allHolySkeletonBagData) do
    if holySkeletonBagData.SoulType == 3 and holySkeletonBagData.ItemCount >= 1 then
      return true
    end
  end
  return false
end

function SacredBoneManager:QuickMsg(type, sacredBoneBagData, changeCount)
  local removetip = (type == 0 and string.GetColorText("Ti\195\170u hao ", "#ED2E2E") or "Nh\225\186\173n ") .. string.GetColorText(sacredBoneBagData.Name .. "\226\128\148" .. sacredBoneBagData.SacredBoneAttribute, ItemQuality2ColorDic[sacredBoneBagData.ColorShow])
  removetip = removetip .. "  *" .. changeCount
  FloatingWordUtility.QuickMsg(removetip)
end

function SacredBoneManager:GetBagItemCount(_itemInfo)
  if _itemInfo == nil then
    return
  end
  local itemBagData = self:GetBagDataByOnlyId(_itemInfo.id)
  if itemBagData == nil then
    return _itemInfo.count
  else
    local changeCount = Mathf.Abs(itemBagData.ItemCount - _itemInfo.count)
    return changeCount
  end
end

return SacredBoneManager
