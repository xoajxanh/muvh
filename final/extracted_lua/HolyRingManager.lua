require("GameConst/HolyRingEnum")
local HolyRingManager = {}
HolyRingManager.HolyRingBagData = nil
HolyRingManager.HolyRingHoleData = nil
HolyRingManager.HolyRingAttributeMap = nil
HolyRingManager.HolyRingLevel = 0
HolyRingManager.HolyRingExp = 0
HolyRingManager.HolyRingIndex = 1
HolyRingManager.ItemInfoId = nil
HolyRingManager.OtherWearHolyRingTab = nil

function HolyRingManager:Init()
  self:HolyRingBagReset()
  self:HolyRingHoleReset()
  self:HolyRingTabReset()
end

function HolyRingManager:HolyRingBagReset()
  if self.HolyRingBagData ~= nil then
    for k, _ in pairs(self.HolyRingBagData) do
      self.HolyRingBagData[k] = nil
    end
  end
  self.HolyRingBagData = {}
end

function HolyRingManager:HolyRingHoleReset()
  self.HolyRingHoleData = {}
  for hole = 1, ClientTable.cfg_Ring_levelManager:GetHolyRingHoleCount() do
    if self.HolyRingHoleData[hole] == nil then
      local holyRingHoleData = LuaClass.HolyRingHoleData:New()
      holyRingHoleData:InitData(hole)
      self.HolyRingHoleData[hole] = holyRingHoleData
    end
  end
end

function HolyRingManager:HolyRingTabReset()
  self.HolyRingAttributeMap = {}
  self.OtherWearHolyRingTab = {}
end

function HolyRingManager:OnResBagInfo(msg)
  if msg == nil then
    return
  end
  for i, item in pairs(msg.items) do
    local itemBagData = self:GetBagDataByOnlyId(item.id)
    if itemBagData == nil then
      local holyRingBagItemData = LuaClass.HolyRingBagItemData:New()
      holyRingBagItemData:RefreshData(item)
      table.insert(self.HolyRingBagData, holyRingBagItemData)
    end
  end
end

function HolyRingManager:OnResBagChange(msg)
  if msg == nil then
    return
  end
  self:RemoveBagItemData(msg.removeItem)
  self:OnShowChangeInfo(msg)
  self:UpdateBagItemData(msg.items)
  EventManager.Dispatch(Event.HolyRingBagChange)
end

function HolyRingManager:OnResHoleInfo(msg)
  if msg == nil then
    return
  end
  self.HolyRingLevel = msg.level
  self.HolyRingExp = msg.exp
  for index, holeIndex in pairs(msg.openHole) do
    if self.HolyRingHoleData[holeIndex] and holeIndex ~= 0 then
      self.HolyRingHoleData[holeIndex]:RefreshUnlockState(true)
    end
  end
  for holeIndex, holeData in pairs(msg.holyRingInfo) do
    if self.HolyRingHoleData[holeIndex] and holeData ~= 0 then
      self.HolyRingHoleData[holeIndex]:RefreshHolyRingHoleItemData(holeData)
    end
  end
  for attributeName, totalAttributeValue in pairs(msg.countAttribute) do
    self.HolyRingAttributeMap[attributeName] = totalAttributeValue
  end
  for holeIndex, probability in pairs(msg.insertAllProbability) do
    self.HolyRingHoleData[holeIndex]:RefreshHolyRingAddition(probability)
    self.HolyRingAttributeMap[holeIndex] = probability
  end
  EventManager.Dispatch(Event.HolyRingWearChange, {
    lid = RoleManager.me.id
  })
end

function HolyRingManager:RefreshOtherHoleData(data)
  for holeIndex, holeData in pairs(self.HolyRingHoleData) do
    if holeData ~= nil then
      holeData:RemoveHolyRingHoleItemData()
    end
  end
  if table.isNullOrEmpty(data) then
    return
  end
  for holeIndex, holeData in pairs(data) do
    if self.HolyRingHoleData[holeData.point] and holeData ~= 0 then
      self.HolyRingHoleData[holeData.point]:RefreshHolyRingHoleItemData(holeData.itemId)
    end
  end
end

function HolyRingManager:OnResHoleChange(msg)
  if msg == nil then
    return
  end
  self:RemoveHoleItemData(msg.takeOff)
  self:UpdateHoleItemData(msg.putOn)
  EventManager.Dispatch(Event.HolyRingWearChange, {
    lid = RoleManager.me.id
  })
  EventManager.Dispatch(Event.RefreshHolyRingPlayerModel)
end

function HolyRingManager:OnResUpgradeHolyRing(msg)
  if msg == nil then
    return
  end
  self.HolyRingExp = msg.ringExp
  self.HolyRingLevel = msg.ringLevel
  if msg.isSuccess and self.HolyRingHoleData[msg.point] then
    self.HolyRingHoleData[msg.point]:RefreshUnlockState(true)
  end
  for attributeName, totalAttributeValue in pairs(msg.countAttribute) do
    self.HolyRingAttributeMap[attributeName] = totalAttributeValue
  end
  for holeIndex, probability in pairs(msg.insertAllProbability) do
    self.HolyRingAttributeMap[holeIndex] = probability
    self.HolyRingHoleData[holeIndex]:RefreshHolyRingAddition(probability)
  end
  EventManager.Dispatch(Event.HolyRingPowerChange, {
    attribute = msg.attribute,
    probability = msg.insertProbability,
    isSuccess = msg.isSuccess,
    holyIndex = msg.point
  })
end

function HolyRingManager:OnResHolyRingExpChange(msg)
  if msg == nil then
    return
  end
  self.HolyRingExp = msg.exp
end

function HolyRingManager:RemoveBagItemData(removeItems)
  if removeItems == nil or table.count(removeItems) == 0 then
    return
  end
  for _, id in pairs(removeItems) do
    local index = self:GetBagDataIndexById(id)
    if index and self.HolyRingBagData and self.HolyRingBagData[index] then
      table.remove(self.HolyRingBagData, index)
    end
  end
end

function HolyRingManager:UpdateBagItemData(changeItems)
  if changeItems == nil or table.count(changeItems) == 0 then
    return
  end
  for i, changeItem in pairs(changeItems) do
    local itemBagData = self:GetBagDataByOnlyId(changeItem.id)
    if itemBagData == nil then
      local holyRingBagItemData = LuaClass.HolyRingBagItemData:New()
      holyRingBagItemData:RefreshData(changeItem)
      table.insert(self.HolyRingBagData, holyRingBagItemData)
    else
      itemBagData:UpdateCount(changeItem.count)
    end
  end
end

function HolyRingManager:RemoveHoleItemData(takeOff)
  if takeOff and table.count(takeOff) > 0 and takeOff.point and self.HolyRingHoleData[takeOff.point] then
    self.HolyRingHoleData[takeOff.point]:RemoveHolyRingHoleItemData()
  end
end

function HolyRingManager:UpdateHoleItemData(putOn)
  if putOn and table.count(putOn) > 0 and putOn.itemId and putOn.point and self.HolyRingHoleData[putOn.point] then
    self.HolyRingHoleData[putOn.point]:RefreshHolyRingHoleItemData(putOn.itemId)
  end
end

function HolyRingManager:RefreshHoleData(msg, lid)
  if msg == nil or table.count(msg) == 0 or lid == nil then
    return
  end
  table.sort(msg, function(a, b)
    if a.point and b.point then
      return a.point < b.point
    end
  end)
  self.OtherWearHolyRingTab = table.clone(msg)
  EventManager.Dispatch(Event.HolyRingWearChange, {lid = lid})
end

function HolyRingManager:OnShowChangeInfo(msg)
  if table.count(msg.items) == 0 then
    return
  end
  if msg.logType == BagChangeTypeEnum.Mail or msg.logType == BagChangeTypeEnum.OptionalBox then
    local showTbl = {}
    for index, itemServerInfo in ipairs(msg.items) do
      local serverData = table.clone(itemServerInfo)
      local bagData = self:GetBagDataByOnlyId(itemServerInfo.id)
      if table.count(bagData) > 0 then
        serverData.count = serverData.count - bagData:GetCount()
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

function HolyRingManager:GetBagDataByOnlyId(id)
  if self.HolyRingBagData ~= nil and table.count(self.HolyRingBagData) > 0 then
    for index, v in pairs(self.HolyRingBagData) do
      if v.ItemInfo.id == id then
        return self.HolyRingBagData[index]
      end
    end
  end
  return nil
end

function HolyRingManager:GetBagDataIndexById(id)
  if self.HolyRingBagData ~= nil and table.count(self.HolyRingBagData) > 0 then
    for index, v in pairs(self.HolyRingBagData) do
      if v.ItemInfo.id == id then
        return index
      end
    end
  end
  return nil
end

function HolyRingManager:GetHolyRingHoleDataSkillBuff(id)
  local holyRingItem = ClientTable.cfg_Item_equipManager:TryGetValue(id)
  if not holyRingItem then
    return
  end
  local carryingSkills = holyRingItem.carryingSkills
  local holyRingItemSkill = ClientTable.cfg_Skill_skillManager:TryGetValue(carryingSkills)
  if not holyRingItemSkill then
    return
  end
  local carryingBuff = holyRingItemSkill.buff
  local holyRingItemSkillBuff = ClientTable.cfg_Buff_buffManager:TryGetValue(tonumber(carryingBuff))
  if not holyRingItemSkillBuff then
    return
  end
  local skillBuff = holyRingItemSkillBuff.buffParam
  local tableBuff = string.split(skillBuff, "#")
  local skillBuffTable = {
    typeId = holyRingItemSkillBuff.buffGroup,
    min = tableBuff[1],
    max = tableBuff[2],
    buffMy = tableBuff[3],
    buffOther = tableBuff[4]
  }
  if skillBuffTable.buffMy == nil or skillBuffTable.buffMy == "0" then
    local tableBuff = self:Buffer(skillBuffTable.buffOther)
    skillBuffTable.buffOther = tableBuff
  elseif skillBuffTable.buffOther == nil or skillBuffTable.buffOther == "0" then
    local tableBuff = self:Buffer(skillBuffTable.buffMy)
    skillBuffTable.buffMy = tableBuff
  else
    local tableBuff = self:Buffer(skillBuffTable.buffMy)
    skillBuffTable.buffMy = tableBuff
    local tableBuff = self:Buffer(skillBuffTable.buffOther)
    skillBuffTable.buffOther = tableBuff
  end
  return skillBuffTable or {}
end

function HolyRingManager:Buffer(buff)
  if buff == nil then
    return {}
  end
  local holyRingItemSkillBuff = ClientTable.cfg_Buff_buffManager:TryGetValue(tonumber(buff))
  local buff = holyRingItemSkillBuff.buffParam
  local skill = string.split(buff, "#")
  local tableBuff = {}
  for i, v in ipairs(skill) do
    table.insert(tableBuff, v)
  end
  return tableBuff or {}
end

function HolyRingManager:GetHolyRingBagData()
  return self.HolyRingBagData
end

function HolyRingManager:GetHolyRingHoleData()
  return self.HolyRingHoleData
end

function HolyRingManager:GetHolyRingLevel()
  return self.HolyRingLevel
end

function HolyRingManager:GetHolyRingExp()
  return self.HolyRingExp
end

function HolyRingManager:GetHolyRingAttributeMap()
  return self.HolyRingAttributeMap
end

function HolyRingManager:GetWearStateAndMap()
  local playWearHolyRingHoleMap = {}
  for i, v in ipairs(self.HolyRingHoleData) do
    if v:GetHolyRingHoleItemData() ~= nil then
      local data = {}
      data.point = v:GetHolyRingHoleIndex()
      data.itemId = v:GetHolyRingHoleItemData():GetItemId()
      table.insert(playWearHolyRingHoleMap, data)
    end
  end
  return table.count(playWearHolyRingHoleMap) > 0, playWearHolyRingHoleMap
end

function HolyRingManager:GetOtherWearHolyRingTab()
  return self.OtherWearHolyRingTab
end

function HolyRingManager:GetHolyRingItemTip(itemId)
  local holyRingItemTips = ClientTable.cfg_Item_equipManager:TryGetValue(itemId)
  local attributeList = {}
  if holyRingItemTips then
    for k, v in ipairs(HolyRingInfoAttributeEnum) do
      local itemTips
      if table.count(v.attributeConfigName) >= 2 then
        local nameMin = v.attributeConfigName[1]
        local nameMax = v.attributeConfigName[2]
        itemTips = v.attributeName .. ": " .. holyRingItemTips[nameMin] .. " ~ " .. holyRingItemTips[nameMax]
        table.insert(attributeList, itemTips)
      else
        local name = v.attributeConfigName[1]
        if type(holyRingItemTips[name]) == "table" then
          for i, y in ipairs(holyRingItemTips[name]) do
            if y[1] == QuickFind.LuaMainPlayerViewAttrData():GetBaseCareer() then
              itemTips = v.attributeName .. ": " .. y[2]
            end
          end
        elseif tonumber(holyRingItemTips[name]) ~= 0 then
          if name == "holyBeast" then
            itemTips = v.attributeName .. ": " .. tonumber(holyRingItemTips[name]) / 100 .. "%"
          else
            itemTips = v.attributeName .. ": " .. holyRingItemTips[name]
          end
        end
        table.insert(attributeList, itemTips)
      end
    end
    return attributeList
  end
  return attributeList
end

function HolyRingManager:GetMeetCombineHolyRingBagData()
  local meetCombineHolyRingBagData = {}
  local allHolyRingBagData = self:GetHolyRingBagData()
  for i, holyRingBagData in pairs(allHolyRingBagData) do
    if holyRingBagData.Count >= ClientTable.cfg_Global_globalManager:GetCombineHolyRingBagFilterNum() and holyRingBagData.IsMaxYear == false then
      table.insert(meetCombineHolyRingBagData, holyRingBagData)
    end
  end
  table.sort(meetCombineHolyRingBagData, function(a, b)
    if a and b then
      if a.RingType == b.RingType then
        return a.Quality > b.Quality
      else
        return a.RingType < b.RingType
      end
    else
      return false
    end
  end)
  return meetCombineHolyRingBagData
end

function HolyRingManager:RedPointRefresh()
  local bagItemData = self.HolyRingBagData
  local holeData = self.HolyRingHoleData
  local Count = 0
  for i, v in ipairs(holeData) do
    if not v.HolyRingHoleItemData and v.UnlockState then
      Count = Count + 1
    end
  end
  if 0 < table.count(bagItemData) and 0 < Count then
    return true
  else
    return false
  end
end

return HolyRingManager
