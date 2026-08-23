ItemCombineData = {}
local this = ItemCombineData

function ItemCombineData:Init()
  if self.combineOnlyOnceDic ~= nil then
    self.combineOnlyOnceDic = {}
  end
  self.ClickHonoerId = nil
end

local function CheckSelfPutOnItem(param)
  if not ViewData.meData then
    return 0
  end
  local roleData = ViewData.meData
  local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(param))
  local count = 0
  for i, v in pairs(roleData.equipsData.Data) do
    if v.itemId == tonumber(param) or v.itemId == itemTab.bindEqualItem then
      count = count + 1
    end
  end
  for i, v in pairs(roleData.mountData.Mounts) do
    if v.itemId == tonumber(param) or v.itemId == itemTab.bindEqualItem then
      count = count + 1
    end
  end
  if 0 < count then
    count = 1
  end
  return count
end

local function CheckItemCombine(cfgItem, atherState)
  local isShow
  local costParams = string.stringToNumberArray(cfgItem.monenyCost, "#")
  costParams[1] = costParams[1] and costParams[1] or 0
  costParams[2] = costParams[2] and costParams[2] or 1000010
  costParams[3] = costParams[3] and costParams[3] or 0
  local costFinal, combineCount = nil, 1
  if costParams[1] == 0 then
    costFinal = costParams[3]
  else
    costFinal = costParams[3] * cfgItem.basicSuccessRate / 10000
  end
  costFinal = costFinal * combineCount
  local ownGold = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(tonumber(costParams[2]))
  isShow = costFinal <= ownGold
  if isShow then
    if cfgItem.costMainBuckets ~= nil then
      local strTab = cfgItem.costMainBuckets
      local costTab, conditionTab, condition, equipCount
      local tempTab = {}
      conditionTab = strTab[1][1]
      if type(conditionTab[2]) == "table" then
        equipCount = table.count(conditionTab[2])
      elseif type(conditionTab[2]) ~= "table" and type(conditionTab[2]) == "string" then
        equipCount = 1
      end
      for j = 1, #strTab[1] do
        condition = ConditionManager.GenerateSingleCondition(strTab[1][j])
        if not condition:Check() then
          isShow = false
          break
        end
      end
    end
    if isShow and atherState and atherState == "UIItemCombineFormula_6416" and table.count(cfgItem.costMainBuckets) == 1 and table.count(cfgItem.costMainBuckets[1]) == 1 and table.count(cfgItem.costMainBuckets[1][1]) then
      local configId = cfgItem.costMainBuckets[1][1][2]
      local count = BagInfoData.GetItemTotalCountByItemId(tonumber(configId))
      isShow = count >= cfgItem.costMainBuckets[1][1][3] and true or false
    end
    if isShow then
      local strTab, itemTab, itemId, itemCount, bagCount
      strTab = string.split(cfgItem.costSecondaryBuckets, "&")
      for k = 1, #strTab do
        itemTab = string.split(strTab[k], "#")
        itemId = tonumber(itemTab[1])
        itemCount = tonumber(itemTab[2])
        bagCount = BagInfoData:GetItemTotalCountByItemIdFromIndexDic(itemId)
        bagCount = bagCount + CheckSelfPutOnItem(itemId)
        if itemCount > bagCount then
          isShow = false
          break
        end
      end
    end
  end
  return isShow
end

function ItemCombineData:GetCombineList(npcId)
  self.combineItems = {}
  local subTable = {}
  local combineTbl = ConfigManager.GetConfigTable("cfg_Item_combine")
  local tblItem, pageIndex
  local redPointState = {}
  local subRedPointState = {}
  for i = 1, #combineTbl do
    tblItem = combineTbl[i]
    if ConditionManager.Check4D(tblItem.openCondition) and string.contains(tblItem.npcId, npcId) then
      pageIndex = tblItem.combineMenu
      if pageIndex == 9 then
        local ss
      end
      if self.combineItems[pageIndex] == nil then
        self.combineItems[pageIndex] = {}
        redPointState[pageIndex] = {}
      end
      local subPage = tblItem.subCombineMenu
      if subPage and 0 < subPage then
        if not subTable[pageIndex] then
          subTable[pageIndex] = {}
          subRedPointState[pageIndex] = {}
        end
        if not subTable[pageIndex][subPage] then
          subTable[pageIndex][subPage] = {}
          subTable[pageIndex][subPage].titleStr = string.format("%s_%s", pageIndex, subPage)
          subRedPointState[pageIndex][subPage] = {}
        end
        local redPoint = CheckItemCombine(tblItem, tblItem.combineFormula)
        if redPoint then
          redPointState[pageIndex].redPoint = true
          subRedPointState[pageIndex][subPage].redPoint = true
        end
        table.insert(subRedPointState[pageIndex][subPage], redPoint)
        table.insert(subTable[pageIndex][subPage], tblItem)
      else
        local redPoint = CheckItemCombine(tblItem, tblItem.combineFormula)
        if redPoint then
          redPointState[pageIndex].redPoint = true
        end
        redPointState[pageIndex][tblItem.id] = redPoint
        table.insert(self.combineItems[pageIndex], tblItem)
      end
    end
  end
  for k, v in pairs(subTable) do
    local item = self.combineItems[k]
    for sub, tab in pairs(v) do
      if item[tonumber(sub)] then
        table.insert(item, sub, tab)
      else
        item[tonumber(sub)] = tab
      end
    end
  end
  for k, v in pairs(subRedPointState) do
    local item = redPointState[k]
    for sub, tab in pairs(v) do
      if item[tonumber(sub)] then
        table.insert(item, sub, tab)
      else
        item[tonumber(sub)] = tab
      end
    end
  end
  return self.combineItems, redPointState
end

function ItemCombineData:CheckCombineState(itemIdList)
  if type(itemIdList) ~= "table" then
    return
  end
  local combineTbl, combineIdList, isCanShow
  for i, itemId in ipairs(itemIdList) do
    combineIdList = ClientTable.cfg_Item_combineManager:GetNeedShowCombineTipListByItemId(itemId)
    if type(combineIdList) == "table" then
      for i, combineId in ipairs(combineIdList) do
        if not ItemCombineData:CheckOnlyOnceState(combineId) and self:GetCombineStateDic()[combineId] ~= false then
          combineTbl = ClientTable.cfg_Item_combineManager:TryGetValue(combineId)
          isCanShow = false
          if combineTbl ~= nil and combineTbl.openCondition and ConditionManager.Check4D(combineTbl.openCondition) and CheckItemCombine(combineTbl) then
            isCanShow = true
          end
          self.combineStateDic[combineId] = isCanShow
        end
      end
    end
  end
  EventManager.Dispatch(Event.CanCombineTip, self:GetCanShowCombineList())
end

function ItemCombineData:GetQualityData()
  local qualityDataDic = {}
  local cfg_Global = ClientTable.cfg_Global_globalManager:TryGetValue(12)
  if cfg_Global and cfg_Global.effect then
    local effectArray = string.split(cfg_Global.effect, "&")
    for i = 1, #effectArray do
      local infoArray = string.split(effectArray[i], "#")
      if #infoArray == 3 then
        local quality = tonumber(infoArray[1])
        qualityDataDic[quality] = {
          damageBonus = infoArray[2],
          damageAbsorption = infoArray[3]
        }
      end
    end
  end
  return qualityDataDic
end

function ItemCombineData:CheckOnlyOnceState(id)
  if id == nil then
    return false
  end
  if self.combineOnlyOnceDic == nil then
    self.combineOnlyOnceDic = {}
  end
  return self.combineOnlyOnceDic[id]
end

function ItemCombineData:SetOnlyOnceState(id, state)
  if id == nil then
    return
  end
  if self.combineOnlyOnceDic == nil then
    self.combineOnlyOnceDic = {}
  end
  self.combineOnlyOnceDic[id] = state
end

function ItemCombineData:ResetCombineData()
  if self.combineOnlyOnceDic ~= nil then
    self.combineOnlyOnceDic = {}
  end
  if self.combineStateDic ~= nil then
    self.combineStateDic = {}
  end
  self.isNotFirst = false
end

function ItemCombineData:CheckTodayOnlyOnceState(id)
  if id == nil then
    return false
  end
  local playerPrefs = string.format("%s_ItemCombineTodayIsShowPromptTipUI_%s", ViewData.meData.id, id)
  local lastRecordTime = PlayerPrefs.GetInt(playerPrefs, 0)
  local isServerSameDay = TimeUtility.CheckIsServerSameDay(lastRecordTime)
  if lastRecordTime == 0 or isServerSameDay == false then
    return false
  else
    return true
  end
  return false
end

function ItemCombineData:SetTodayOnlyOnceState(id, state)
  if id == nil then
    return
  end
  local playerPrefs = string.format("%s_ItemCombineTodayIsShowPromptTipUI_%s", ViewData.meData.id, id)
  PlayerPrefs.SetInt(playerPrefs, state and Time.GetServerSecondTime() or 0)
end

function ItemCombineData:SetClickHonoerId(id)
  self.ClickHonoerId = id
end

function ItemCombineData:GetClickHonoerId()
  return self.ClickHonoerId
end

function ItemCombineData:GetCanShowCombineList()
  local combineTbl
  local canShowCombineList = {}
  for combineId, combineState in pairs(self:GetCombineStateDic()) do
    if combineState and not self:CheckOnlyOnceState(combineId) then
      combineTbl = ClientTable.cfg_Item_combineManager:TryGetValue(combineId)
      table.insert(canShowCombineList, combineTbl)
    else
      self.combineStateDic[combineId] = nil
    end
  end
  return canShowCombineList
end

function ItemCombineData:FirstCheckItemCombine()
  if self.combineStateDic == nil then
    self.combineStateDic = {}
  end
  if self.isNotFirst then
    return
  end
  self.isNotFirst = true
  local itemList = {}
  for itemId, v in pairs(ClientTable.cfg_Item_combineManager:GetCombineCostItemIdDic()) do
    table.insert(itemList, itemId)
  end
  self:CheckCombineState(itemList)
end

function ItemCombineData:GetCombineStateDic()
  if self.combineStateDic == nil then
    self.combineStateDic = {}
  end
  return self.combineStateDic
end
