local RedEquipLevelDataManager = {}
RedEquipLevelDataManager.mRedEquipIndexRule = {
  [ERoleEquipPosition.right_weapon + 3500] = true,
  [ERoleEquipPosition.left_weapon + 3500] = true,
  [ERoleEquipPosition.armor + 3500] = true,
  [ERoleEquipPosition.pant + 3500] = true,
  [ERoleEquipPosition.helm + 3500] = true,
  [ERoleEquipPosition.glove + 3500] = true,
  [ERoleEquipPosition.boot + 3500] = true,
  [ERoleEquipPosition.nechushou + 3500] = true,
  [ERoleEquipPosition.new_left_ring] = true,
  [ERoleEquipPosition.new_right_ring] = true,
  [ERoleEquipPosition.new_left_Earring] = true,
  [ERoleEquipPosition.new_right_Earring] = true
}

function RedEquipLevelDataManager:AllEquipIndexDic()
  if self.mAllEquipIndexDic == nil then
    self.mAllEquipIndexDic = {}
  end
  return self.mAllEquipIndexDic
end

function RedEquipLevelDataManager:AllRedEquipDic()
  if self.mAllRedEquip == nil then
    self.mAllRedEquip = {}
  end
  return self.mAllRedEquip
end

function RedEquipLevelDataManager:AllRedEquipUpgradeCodeDic()
  if self.mAllRedEquipUpgradeCodeDic == nil then
    self.mAllRedEquipUpgradeCodeDic = {}
  end
  return self.mAllRedEquipUpgradeCodeDic
end

function RedEquipLevelDataManager:Init()
  self:InitParam()
  self:BindEventMsg()
end

function RedEquipLevelDataManager:InitParam()
  self.eventContainer = EventContainer(EventManager)
end

function RedEquipLevelDataManager:BindEventMsg()
  self.eventContainer:Regist(Event.Bag_ResBagChange, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Bag_ResBagInfo, self.BagChangedCallBack, self)
  self.eventContainer:Regist(Event.Role_MyLvChanged, self.LvChangedCallBack, self)
  self.eventContainer:Regist(Event.RedEquipIndexInitalize, self.RedEquipIndexInitalizeCallBack, self)
end

function RedEquipLevelDataManager:BagChangedCallBack()
  local isNeedCall = false
  for i, v in pairs(self:AllRedEquipUpgradeCodeDic()) do
    if v == ERedEquipUpgradeCode.NotMeetConsumable and self:RefreshUpgrassState(i) then
      isNeedCall = true
    end
  end
  if isNeedCall then
  end
end

function RedEquipLevelDataManager:LvChangedCallBack()
  local isNeedCall = false
  for i, v in pairs(self:AllRedEquipUpgradeCodeDic()) do
    if v == ERedEquipUpgradeCode.NotMeetCondition and self:RefreshUpgrassState(i) then
      isNeedCall = true
    end
  end
  if isNeedCall then
  end
end

function RedEquipLevelDataManager:RedEquipIndexInitalizeCallBack(msgId, _index)
  RedEquipLevelDataManager.mEquipUISelectIndex = _index
end

function RedEquipLevelDataManager:RefreshAllRedEquipData(data)
  if data == nil or data.redEquipUpRank == nil then
    return
  end
  local equipIndexInfo
  for i, v in pairs(data.redEquipUpRank) do
    equipIndexInfo = self:AllEquipIndexDic()[v.position]
    if equipIndexInfo == nil then
      self:AllEquipIndexDic()[v.position] = self:NewRedEquipIndexData(v)
    else
      equipIndexInfo.redId = v.equipItemId == 0 and v.position or v.equipItemId
      equipIndexInfo.lid = v.equipItemId
    end
  end
  self:RefreshAllUpgrassState()
end

function RedEquipLevelDataManager:RefreshUpRankCallBack(data)
  if data == nil or data.position == nil then
    return
  end
  local equipIndexInfo = self:AllEquipIndexDic()[data.position]
  if equipIndexInfo ~= nil then
    equipIndexInfo.redId = data.equipItemId == 0 and data.position or data.equipItemId
    equipIndexInfo.lid = data.equipId
  end
  self:RefreshUpgrassState(data.position)
  EventManager.Dispatch(Event.RedEquipUpgradeInfoChanged, {
    index = data.position
  })
end

function RedEquipLevelDataManager:RefreshAllUpgrassState()
  local isNeedCall = false
  for i, v in pairs(self:AllEquipIndexDic()) do
    if self:RefreshUpgrassState(i) then
      isNeedCall = true
    end
  end
  if isNeedCall then
  end
end

function RedEquipLevelDataManager:RefreshUpgrassState(_index)
  local isNeedCall, curStateCode, lastStateCode
  lastStateCode = self:AllRedEquipUpgradeCodeDic()[_index]
  curStateCode = self:GetUpgradeStateCode(_index)
  if curStateCode ~= lastStateCode then
    isNeedCall = true
    self:AllRedEquipUpgradeCodeDic()[_index] = curStateCode
  end
  return isNeedCall
end

function RedEquipLevelDataManager:GetRedEquipIndexData(_index)
  return self:AllEquipIndexDic()[_index]
end

function RedEquipLevelDataManager:GetRedIdByIndex(_index)
  if _index == nil then
    return 0
  end
  return self:AllEquipIndexDic()[_index] == nil and 0 or self:AllEquipIndexDic()[_index].redId
end

function RedEquipLevelDataManager:GetRedEquipLevelDataByIndex(_index)
  local redId = self:GetRedIdByIndex(_index)
  return self:GetRedEquipLevelDataByRedId(redId)
end

function RedEquipLevelDataManager:GetRedEquipLevelDataByRedId(_redId)
  if _redId == nil then
    return nil
  end
  if self:AllRedEquipDic()[_redId] == nil then
    self:AllRedEquipDic()[_redId] = self:InitializeRedEquipLevelDataByRedId(_redId)
  end
  return self:AllRedEquipDic()[_redId]
end

function RedEquipLevelDataManager:GetEquipAttributeInfo(_redId)
  local redData = self:GetRedEquipLevelDataByRedId(_redId)
  if redData == nil then
    return nil
  end
  local result = {}
  result.basic = self:GetBasicEquipAttribute(redData)
  result.excellence = self:GetExcellentEquipAtenttribute(redData)
  return result
end

function RedEquipLevelDataManager:GetUpgradeStateByIndex(_index)
  return self:AllRedEquipUpgradeCodeDic()[_index] and self:AllRedEquipUpgradeCodeDic()[_index] > 0
end

function RedEquipLevelDataManager:GetUpgradeStateCodeByIndex(_index)
  if _index == nil then
    return ERedEquipUpgradeCode.None
  end
  return self:AllRedEquipUpgradeCodeDic()[_index] or ERedEquipUpgradeCode.None
end

function RedEquipLevelDataManager:GetFirstIndex()
  local index, firstIndex, redIndexData, redData
  for i, v in pairs(RedEquipLevelDataManager.mRedEquipIndexRule) do
    if firstIndex == nil then
      firstIndex = i
    end
    if self:GetUpgradeStateCodeByIndex(i) ~= nil and self:GetUpgradeStateCodeByIndex(i) > 0 then
      return i
    end
    redIndexData = self:GetRedEquipIndexData(i)
    if index == nil and redIndexData and 0 < redIndexData.redId then
      redData = self:GetRedEquipLevelDataByRedId(redIndexData.redId)
      if redData and not redData.isMax then
        index = i
      end
    end
  end
  return index or firstIndex
end

function RedEquipLevelDataManager:GetRedEquipSytemOpenState()
  return FucShowOrHideController.FuncSystemIsOpen(FunctionSystemEnumId.RedEquip)
end

function RedEquipLevelDataManager:CheckRedEquipIndex(_index)
  return RedEquipLevelDataManager.mRedEquipIndexRule[_index] ~= nil and RedEquipLevelDataManager.mRedEquipIndexRule[_index]
end

function RedEquipLevelDataManager:CheckRedEquipIndexByBasicIndex(_index)
  return RedEquipLevelDataManager.mRedEquipIndexRule[_index + 3500] ~= nil and RedEquipLevelDataManager.mRedEquipIndexRule[_index + 3500]
end

function RedEquipLevelDataManager:GetSelectIndex()
  return RedEquipLevelDataManager.mEquipUISelectIndex
end

function RedEquipLevelDataManager:GetBasicEquipAttribute(redData)
  if redData == nil then
    return
  end
  if redData.basicAttr == nil then
    redData.basicAttr = ClientTable.cfg_Item_equipManager:GetBasicAttributeViewInfoTbl({
      itemId = redData.curItemId,
      targetItemId = redData.nextItemId
    })
    table.sort(redData.basicAttr, function(a, b)
      return a and b and a.isUp and a.isUp ~= b.isUp
    end)
  end
  return redData.basicAttr
end

function RedEquipLevelDataManager:GetExcellentEquipAtenttribute(redData)
  if redData == nil then
    return
  end
  if redData.exccellentAttr == nil then
    redData.exccellentAttr = ClientTable.cfg_Item_equipManager:GetExcellentAttributeViewInfoTbl({
      itemId = redData.curItemId,
      targetItemId = redData.nextItemId
    })
    table.sort(redData.exccellentAttr, function(a, b)
      return a and b and a.isUp and a.isUp ~= b.isUp
    end)
  end
  return redData.exccellentAttr
end

function RedEquipLevelDataManager:InitializeRedEquipLevelDataByRedId(_redId)
  return self:NewRedEquipLevelDataByRedId(_redId)
end

function RedEquipLevelDataManager:NewRedEquipLevelDataByRedId(_redId)
  local tbl = ClientTable.cfg_Equip_redcloth_levelManager:TryGetValue(_redId)
  if tbl == nil then
    return nil
  end
  local result = {}
  result.redId = tbl.id
  result.level = tbl.lv
  result.curItemId = tbl.id
  result.limitLevelStr = ""
  result.condition = tbl.condition
  result.equipIndex = tbl.equipPosition
  if tbl.lv == 0 then
    result.nextItemId = self:GetItemIdByCareer(tbl.newid)
    local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(result.nextItemId)
    result.name = itemTbl and itemTbl.name or ""
  else
    result.nextItemId = not string.isNullOrEmpty(tbl.newid) and tonumber(tbl.newid) or nil
    local itemTbl = ClientTable.cfg_Item_itemManager:TryGetValue(result.curItemId)
    result.name = itemTbl and itemTbl.name or ""
  end
  result.isMax = result.nextItemId == nil
  result.consumable = TableParse:SpliteStringToItemCountList(tbl.consumption)
  if result.condition ~= nil and 0 < table.count(result.condition) then
    local cLevelTbl = ClientTable.cfg_Character_levelManager:TryGetValue(result.condition[1][1][2])
    if cLevelTbl then
      result.limitLevelStr = cLevelTbl.name
    end
  end
  return result
end

function RedEquipLevelDataManager:NewRedEquipIndexData(data)
  if data == nil then
    return nil
  end
  local result = {}
  result.redId = data.equipItemId == 0 and data.position or data.equipItemId
  result.lid = data.equipId
  return result
end

function RedEquipLevelDataManager:GetItemIdByCareer(itemIDStr)
  if RoleManager.me == nil then
    return 0
  end
  local itemIdList = TableParse:SplitStringToIntList(itemIDStr, "#")
  if RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.SwordMan then
    return 0 < table.count(itemIdList) and itemIdList[1] or 0
  elseif RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.Magic then
    return table.count(itemIdList) > 1 and itemIdList[2] or 0
  elseif RoleUtility.GetBasicCareer(RoleManager.me.career) == ERoleCareer.Archer then
    return table.count(itemIdList) > 2 and itemIdList[3] or 0
  end
end

function RedEquipLevelDataManager:GetUpgradeStateCode(_index)
  local redData = self:GetRedEquipLevelDataByIndex(_index)
  if redData == nil then
    return ERedEquipUpgradeCode.None
  end
  if redData.condition ~= nil and not ConditionManager.Check4D(redData.condition) then
    return ERedEquipUpgradeCode.NotMeetCondition
  end
  if redData.consumable ~= nil then
    local bagCount
    for i, v in pairs(redData.consumable) do
      bagCount = BagInfoData.GetItemTotalCountByItemId(v.itemId)
      if bagCount < v.count then
        return ERedEquipUpgradeCode.NotMeetConsumable
      end
    end
  end
  return ERedEquipUpgradeCode.MeetAll
end

function RedEquipLevelDataManager:OnDestruct()
  self:RunBaseFunction("OnDestruct")
end

return RedEquipLevelDataManager
