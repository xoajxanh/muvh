require("GameConst/BagEnum")
require("Utility/ParseUtility")
require("GameModel/ItemCell/ItemCellData")
require("GameModel/ItemCell/SizeItemCellData")
BagInfoData = {}
local this = BagInfoData
BagInfoData.TotalPage = 4
BagInfoData.CurPage = 1
BagInfoData.PerPageCellCount = 24
BagInfoData.bagCellCount = 0
BagInfoData.curBagCellCount = 0
BagInfoData.bagCellInfo = {}
BagInfoData.useList = {}
BagInfoData.freeList = {}
BagInfoData.cellSize = 44
BagInfoData.bagFull = false
BagInfoData.colCount = 8
BagInfoData.EquipItemIds = {}
BagInfoData.RedMedicineItemIds = {}
BagInfoData.BlueMedicineItemIds = {}
BagInfoData.RedItemIdsIndex = {}
BagInfoData.BlueItemIdsIndex = {}
BagInfoData.curSelectItem = nil
BagInfoData.curSelectWing = nil
BagInfoData.PandoraBagFull = false
BagInfoData.TotalItems = {}
BagInfoData.TotalItemsIndexDic = {}
BagInfoData.CoinInfos = {}
BagInfoData.storageInfos = {}
BagInfoData.pandoraBagInfos = {}
BagInfoData.curStorageCount = 0
BagInfoData.storageCount = 0
BagInfoData.pandoraInitCount = 0
BagInfoData.RecycleItemTbl = {}
BagInfoData.ResultTbl = {}
BagInfoData.RecycleConfigTbl = {}
BagInfoData.RecycleCancel = {}
BagInfoData.sellConfigData = {}
BagInfoData.SpecialItem = {}
BagInfoData.FirstPropData = {}
BagInfoData.DecomposeItemTbl = {}
BagInfoData.consumeItemTbl = {}
BagInfoData.acquireItemTbl = {}

function BagInfoData.Init()
  local coinsCfgTbl = ConfigManager.FindConfigs("cfg_item_item", "type", 1)
  for _, coinTbl in pairs(coinsCfgTbl) do
    this.CoinInfos[coinTbl.id] = 0
  end
  local specialTbl = ClientTable.cfg_Activity_globalManager:TryGetValue(100406, "id")
  this.SpecialItem = ParseUtility.ParseId(specialTbl.effect)
  local equipMount = ConfigManager.FindConfigs("cfg_Item_equip", "subType", 22)
  for i, v in pairs(equipMount) do
    this.FirstPropData[v.id] = tonumber(v.equipPosition)
  end
  this.sellConfigData = ConfigManager.GetConfigTable("cfg_Item_sellConfig")
  this.curBagCellCount = tonumber(GlobalConfig.bagInitCount)
  this.bagCellCount = tonumber(GlobalConfig.bagMaxCount)
  local tab = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2140023), "#")
  for i = 1, table.count(tab) do
    table.insert(this.RedMedicineItemIds, tonumber(tab[i]))
    BagInfoData.RedItemIdsIndex[tonumber(tab[i])] = i
  end
  tab = string.split(ClientTable.cfg_Global_globalManager:GetGlobalItemEffect(2140024), "#")
  for i = 1, table.count(tab) do
    table.insert(this.BlueMedicineItemIds, tonumber(tab[i]))
    BagInfoData.BlueItemIdsIndex[tonumber(tab[i])] = i
  end
end

function BagInfoData.InitFreeSpace()
  this.freeList = {}
  this.useList = {}
  local row = this.curBagCellCount / 8
  local temp = ItemCellData()
  temp.x, temp.y = 0, 0
  temp.width = this.cellSize * 8
  temp.height = this.cellSize * row
  table.insert(this.freeList, temp)
  BagInfoData.GetBagGridCalcManager():SetBagGridDic(row, this.colCount)
end

function BagInfoData.HandleMedicineMaxIndex()
  if this.TotalItems == nil then
    return
  end
  this.redMaxIndex = 1
  this.blueMaxIndex = 1
  for _, itemData in pairs(this.TotalItems) do
    if itemData.tblItem.type == EItemType.Consumables then
      if table.contains(this.RedMedicineItemIds, itemData.itemId) then
        if this.redMaxIndex < this.RedItemIdsIndex[itemData.itemId] then
          this.redMaxIndex = this.RedItemIdsIndex[itemData.itemId]
        end
      elseif table.contains(this.BlueMedicineItemIds, itemData.itemId) and this.blueMaxIndex < this.BlueItemIdsIndex[itemData.itemId] then
        this.blueMaxIndex = this.BlueItemIdsIndex[itemData.itemId]
      end
    end
  end
end

function BagInfoData.JudgeMedicineItemIdRecycle(itemId)
  if table.contains(this.RedMedicineItemIds, itemId) then
    return BagInfoData.RedItemIdsIndex[itemId] < this.redMaxIndex
  elseif table.contains(this.BlueMedicineItemIds, itemId) then
    return BagInfoData.BlueItemIdsIndex[itemId] < this.blueMaxIndex
  end
  return false
end

function BagInfoData.CheckBagSpace()
  local w, h = this.colCount * this.cellSize, 3 * this.cellSize
  local emptySpace = BagInfoData.GetBagGridCalcManager():FindFreeCell(w, h)
  local hadItem = emptySpace == nil
  local useNodeCount = 0
  local haveSpace = true
  if hadItem and this.useList then
    for _, v in pairs(this.useList) do
      local x = v.width / this.cellSize
      local y = v.height / this.cellSize
      useNodeCount = useNodeCount + x * y
      if this.curBagCellCount - useNodeCount < 24 then
        haveSpace = false
      end
    end
  end
  BagInfoData.bagFull = not haveSpace
end

function BagInfoData.CheckPandoraBagSpace()
  local PandoraBagPlaid = BagInfoData.pandoraInitCount
  local Pandora = this.pandoraBagInfos
  local needPlaid = 0
  for i, v in pairs(Pandora) do
    needPlaid = needPlaid + v.tblItem.xTranslate * v.tblItem.yTranslate
  end
  BagInfoData.PandoraBagFull = not (PandoraBagPlaid > needPlaid)
end

function BagInfoData.CheckBagFiveSpace()
  local w, h = this.colCount * this.cellSize, 5 * this.cellSize
  local emptySpace = BagInfoData.GetBagGridCalcManager():FindFreeCell(w, h)
  BagInfoData.bagFiveFull = emptySpace == nil
end

function BagInfoData.InsertItemData(itemData)
  local index = itemData.bagGridIndex + 1
  local x, y = SpaceCalcUtility.CalcXy(index, 8)
  local itemCell = ItemCellData()
  itemCell.x, itemCell.y = x * this.cellSize, y * -this.cellSize
  itemCell.width, itemCell.height = this.cellSize * itemData.tblItem.xTranslate, this.cellSize * itemData.tblItem.yTranslate
  SpaceCalcUtility.InsertUseNode(itemCell, this.freeList, this.useList)
end

function BagInfoData.RefreshFreeListAndUsedList()
  this.freeList, this.useList = BagInfoData.GetBagGridCalcManager():GetFreeAndUseList()
end

function BagInfoData.InsertItemDataList(itemDataList)
  if type(itemDataList) ~= "table" or next(itemDataList) == nil then
    return
  end
  local itemCellData, cellDataList
  for k, v in pairs(itemDataList) do
    itemCellData = itemCellData()
    itemCellData:SetCellPosition(v.bagGridIndex + 1)
    itemCellData:SetCellSize(v.tblItem)
    table.insert(cellDataList, itemCellData)
  end
  SpaceCalcUtility.InsertUseNodeList(cellDataList)
end

function BagInfoData.RecycleFreeNode(itemData)
  local index = itemData.bagGridIndex + 1
  local x, y = SpaceCalcUtility.CalcXy(index, 8)
  local itemCell = ItemCellData()
  itemCell.x, itemCell.y = x * this.cellSize, y * -this.cellSize
  itemCell.width, itemCell.height = this.cellSize * itemData.tblItem.xTranslate, this.cellSize * itemData.tblItem.yTranslate
  SpaceCalcUtility.RecycleFreeNode(itemCell, this.freeList, this.useList)
end

function BagInfoData.BagReSet()
  for k, _ in pairs(this.TotalItems) do
    this.TotalItems[k] = nil
  end
  this.TotalItems = {}
  for k, itemIndexList in pairs(this.TotalItemsIndexDic) do
    for i = #itemIndexList, 1, -1 do
      table.remove(itemIndexList)
    end
    this.TotalItemsIndexDic[k] = nil
  end
  this.TotalItemsIndexDic = {}
  this.Init()
end

function BagInfoData.PandoraReSet()
  for k, _ in pairs(this.pandoraBagInfos) do
    this.pandoraBagInfos[k] = nil
  end
  this.pandoraBagInfos = {}
  this.pandoraInitCount = tonumber(GlobalConfig.pandoraInitCount)
end

function BagInfoData.StorageReSet()
  for k, _ in pairs(this.storageInfos) do
    this.storageInfos[k] = nil
  end
  this.storageInfos = {}
  this.curStorageCount = tonumber(GlobalConfig.storageInitCount)
  this.storageCount = tonumber(GlobalConfig.storageMaxCount)
end

function BagInfoData.UpdateTotalItems(changeItems)
  local showTbl = {}
  local reduceTbl = {}
  local getTbl = {}
  local TrueTbl = {}
  local TruereduceTbl = {}
  for _, changeItem in pairs(changeItems) do
    local itemCfg = ClientTable.cfg_Item_itemManager:TryGetValue(changeItem.itemId)
    if itemCfg and itemCfg.bagType and itemCfg.bagType == 1 then
      local itemCount = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr():GetBagItemCount(changeItem)
      local itemInfo = table.clone(changeItem)
      local itemId = itemInfo.itemId
      itemInfo.count = itemCount
      if showTbl[itemId] then
        showTbl[itemId].count = showTbl[itemId].count + itemInfo.count
      else
        showTbl[itemId] = itemInfo
      end
    elseif itemCfg and itemCfg.bagType and itemCfg.bagType == 3 then
      local itemCount = CrystalNucleusBagManager:GetBagItemCount(changeItem)
      local itemInfo = table.clone(changeItem)
      local itemId = itemInfo.itemId
      itemInfo.count = itemCount
      if showTbl[itemId] then
        showTbl[itemId].count = showTbl[itemId].count + itemInfo.count
      else
        showTbl[itemId] = itemInfo
      end
    else
      local item = this.TotalItems[changeItem.bagGridIndex + 1]
      local changeCount = 0
      if item == nil then
        this.SaveAndConfigInfo(this.TotalItems, changeItem, true)
        changeCount = changeItem.count
        item = this.TotalItems[changeItem.bagGridIndex + 1]
        table.insert(getTbl, item)
        TrueTbl[changeItem.bagGridIndex] = item
      else
        changeCount = changeItem.count - item.count
        item.count = changeItem.count
        local Trueitem = table.clone(item)
        if 0 < changeCount then
          TrueTbl[changeItem.bagGridIndex] = Trueitem
          TrueTbl[changeItem.bagGridIndex].count = changeCount
        else
          TruereduceTbl[changeItem.bagGridIndex] = Trueitem
          TruereduceTbl[changeItem.bagGridIndex].count = Mathf.Abs(changeCount)
        end
      end
      local itemInfo = table.clone(changeItem)
      local itemId = itemInfo.itemId
      itemInfo.count = Mathf.Abs(changeCount)
      if 0 < changeCount then
        if showTbl[itemId] then
          showTbl[itemId].count = showTbl[itemId].count + itemInfo.count
        else
          showTbl[itemId] = itemInfo
        end
      elseif reduceTbl[itemId] then
        reduceTbl[itemId].count = reduceTbl[itemId].count + itemInfo.count
      else
        reduceTbl[itemId] = itemInfo
      end
    end
  end
  return showTbl, reduceTbl, getTbl, TrueTbl, TruereduceTbl
end

function BagInfoData.MoveItem(items, itemInfo, isAddIndex)
  local originalItem, newItem
  for i, _ in pairs(items) do
    if items[i].id == itemInfo.id then
      originalItem = items[i]
      items[i] = nil
      if isAddIndex then
        this:RemoveTotalItemsIndexDic(originalItem.itemId, i)
      end
      newItem = this.SaveAndConfigInfo(items, itemInfo, isAddIndex)
      break
    end
  end
  this.GetBagGridCalcManager():RemoveItem(originalItem)
  this.GetBagGridCalcManager():InsertItem(newItem)
  BagInfoData.RefreshFreeListAndUsedList()
end

function BagInfoData.UpdateCoins(coins)
  local showTbl = {}
  local removeTbl = {}
  for _, coin in pairs(coins) do
    local key = coin.itemId
    local changeCount = 0
    if tonumber(key) ~= ECoinsType.goldUnion then
      if this.CoinInfos[key] == nil then
        changeCount = coin.count
      else
        changeCount = coin.count - this.CoinInfos[key]
      end
      this.CoinInfos[key] = coin.count
    else
      changeCount = coin.count
      this.CoinInfos[key] = this.CoinInfos[key] and this.CoinInfos[key] + coin.count or coin.count
    end
    if 0 < changeCount then
      showTbl[key] = ItemUtility.GenerateItemData(key)
      showTbl[key].count = changeCount
    else
      removeTbl[key] = ItemUtility.GenerateItemData(key)
      removeTbl[key].count = changeCount
    end
  end
  return showTbl, removeTbl
end

function BagInfoData.RemoveItems(removeItems)
  local tempList = {}
  for _, rmId in pairs(removeItems) do
    for index, itemInfo in pairs(this.TotalItems) do
      if itemInfo.id == rmId then
        table.insert(tempList, itemInfo)
        this:RemoveTotalItemsIndexDic(itemInfo.itemId, index)
        this.TotalItems[index] = nil
        break
      end
    end
  end
  return tempList
end

function BagInfoData.SaveAndConfigInfo(itemTbl, itemInfo, isAddIndex)
  local item = ItemUtility.GenerateItemDataByServerData(itemInfo)
  itemTbl[item.bagGridIndex + 1] = item
  if isAddIndex then
    this:AddTotalItemsIndexDic(itemInfo.itemId, item.bagGridIndex + 1)
  end
  return item
end

function BagInfoData.RemoveStorageItem(removeItems)
  local tempList = {}
  for _, rmId in pairs(removeItems) do
    for index, item in pairs(this.storageInfos) do
      if item.id == rmId then
        table.insert(tempList, item)
        this.storageInfos[index] = nil
        break
      end
    end
  end
  return tempList
end

function BagInfoData.RemovePandoraItem(removeItems)
  local tempList = {}
  for _, rmId in pairs(removeItems) do
    for index, item in pairs(this.pandoraBagInfos) do
      if item.id == rmId then
        table.insert(tempList, item)
        this.pandoraBagInfos[index] = nil
        break
      end
    end
  end
  return tempList
end

function BagInfoData.UpdateStorageItems(changeItems)
  for _, changeItem in pairs(changeItems) do
    local item = this.storageInfos[changeItem.bagGridIndex + 1]
    local changeCount = 0
    if item == nil then
      this.SaveAndConfigInfo(this.storageInfos, changeItem)
      changeCount = changeItem.count
      item = changeItem
    else
      changeCount = item.count - changeItem.count
      item.count = changeItem.count
    end
    if changeCount == 0 then
      return
    end
  end
end

function BagInfoData.UpdatePandoraItems(changeItems)
  for _, changeItem in pairs(changeItems) do
    local item = this.pandoraBagInfos[changeItem.bagGridIndex + 1]
    local changeCount = 0
    if item == nil then
      this.SaveAndConfigInfo(this.pandoraBagInfos, changeItem)
      changeCount = changeItem.count
      item = changeItem
    else
      changeCount = item.count - changeItem.count
      item.count = changeItem.count
    end
    if changeCount == 0 then
      return
    end
  end
end

function BagInfoData.GetItemTblByConfigId(configId, totalBag)
  totalBag = totalBag or this.TotalItems
  local tbl = {}
  for _, item in pairs(totalBag) do
    if item.itemId == configId then
      table.insert(tbl, item)
    end
  end
  return tbl
end

function BagInfoData.GetItemById(id, totalBag)
  totalBag = totalBag or this.TotalItems
  for _, item in pairs(totalBag) do
    if item.id == id then
      return item
    end
  end
end

function BagInfoData.GetFirstItemTblByConfigId(configId, totalBag)
  totalBag = totalBag or this.TotalItems
  for _, item in pairs(totalBag) do
    if item.itemId == configId then
      return item
    end
  end
end

function BagInfoData.GetItemCountById(Id)
  local count = 0
  for _, item in pairs(this.TotalItems) do
    if item.id == Id then
      count = count + item.count
    end
  end
  return count
end

function BagInfoData.GetItemCountByItemConfigId(configId)
  local count = 0
  for id, v in pairs(this.CoinInfos) do
    if id == configId then
      count = v
      return count
    end
  end
  for _, item in pairs(this.TotalItems) do
    if item.itemId == configId then
      count = count + item.count
    end
  end
  return count
end

function BagInfoData.GetItemTotalCountByItemId(configId)
  local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(configId)
  local count = this.GetItemCountByItemConfigId(configId)
  if itemTab ~= nil and itemTab.bindEqualItem ~= 0 then
    count = count + this.GetItemCountByItemConfigId(itemTab.bindEqualItem)
  end
  return count
end

function BagInfoData.GetItemTotalCountByItemIdAndContainBind(configId)
  local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(configId)
  local count = this.GetItemCountByItemConfigId(configId)
  local countOther = 0
  local totalCount = count
  if itemTab ~= nil and itemTab.bindEqualItem ~= 0 then
    totalCount = totalCount + this.GetItemCountByItemConfigId(itemTab.bindEqualItem)
    countOther = this.GetItemCountByItemConfigId(itemTab.bindEqualItem)
  end
  return totalCount, count, countOther
end

function BagInfoData.GetTotalRuneData()
  local totalRuneData = {}
  for i, v in pairs(this.TotalItems) do
    if v.tblItem and (v.tblItem.subType == 1001 or v.tblItem.subType == 2001 or v.tblItem.subType == 3001) then
      table.insert(totalRuneData, v)
    end
  end
  return totalRuneData
end

function BagInfoData.GetRuneTotalCountByItemId(runeItemID)
  local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(runeItemID)
  local count = this.GetRuneCountByItemConfigId(runeItemID)
  if itemTab ~= nil and itemTab.bindEqualItem ~= 0 then
    count = count + this.GetRuneCountByItemConfigId(itemTab.bindEqualItem)
  end
  return count
end

function BagInfoData.GetRuneCountByItemConfigId(runeItemID)
  local count = 0
  for _, item in pairs(this.TotalItems) do
    if item.itemId == runeItemID and item.serverInfo.runesLevel == 0 then
      count = count + item.count
    end
  end
  return count
end

function BagInfoData.GetRuneByItemId(itemId)
  for _, v in pairs(this.TotalItems) do
    if v and v.itemId == itemId and v.serverInfo.runesLevel == 0 then
      return v
    end
  end
end

function BagInfoData.GetMeetPutOnItemCountByItemId(configId)
  local count = 0
  for id, v in pairs(this.CoinInfos) do
    if id == configId then
      local itemTab = ConfigManager.GetConfig("cfg_item_item", configId)
      if itemTab and (itemTab.bind == nil or itemTab.bind == 0) then
        count = v
        return count
      end
    end
  end
  for _, item in pairs(this.TotalItems) do
    if item.itemId == configId then
      local itemTab = ConfigManager.GetConfig("cfg_item_item", configId)
      local equipTab = ConfigManager.GetConfig("cfg_Item_equip", configId)
      local isMeetPutOn = AuctionController.CheckMeetPutOnCondition(equipTab, item.bind, item.intensify, item.additional, false) or true
      if itemTab and itemTab.minAuctionPrice ~= "" and isMeetPutOn then
        count = count + item.count
      end
    end
  end
  local HolyRingBag = gameMgr:GetAvatarManager():GetMainPlayer():GetHolyRingDataMgr():GetHolyRingBagData()
  if HolyRingBag and 0 < table.count(HolyRingBag) then
    for i, v in pairs(HolyRingBag) do
      if v.ItemId == configId then
        count = count + v.ItemInfo.count
      end
    end
  end
  local ReliquaryBag = gameMgr:GetAvatarManager():GetMainPlayer():GetSacredBoneDataMgr().SacredBoneBagItemData
  if ReliquaryBag and 0 < table.count(ReliquaryBag) then
    for i, v in pairs(ReliquaryBag) do
      if v.ItemId == configId then
        count = count + v.ItemInfo.count
      end
    end
  end
  return count
end

function BagInfoData.SelectRecycle(recycleTbl, isAdd)
  local isChanged = true
  if isAdd then
    if this.RecycleItemTbl[recycleTbl.bagIndex] and this.RecycleItemTbl[recycleTbl.bagIndex].id == recycleTbl.id and this.RecycleItemTbl[recycleTbl.bagIndex].count == recycleTbl.count then
      isChanged = false
    end
    if isChanged then
      this.RecycleItemTbl[recycleTbl.bagIndex] = recycleTbl
    end
  else
    if this.RecycleItemTbl[recycleTbl.bagIndex] == nil then
      isChanged = false
    end
    if isChanged then
      this.RecycleItemTbl[recycleTbl.bagIndex] = nil
    end
  end
  return isChanged
end

function BagInfoData.RefreshRecycle()
  for _, recycleInfo in pairs(this.RecycleItemTbl) do
    local bagIndex = recycleInfo.bagIndex + 1
    if not this.TotalItems[bagIndex] or this.TotalItems[bagIndex].id ~= recycleInfo.id then
      this.RecycleItemTbl[recycleInfo.bagIndex] = nil
    end
  end
end

function BagInfoData.RefreshDecomposeItemData(item, isAdd)
  for i = 1, item.data.itemData.count do
    this.RefreshDecompose(item.data.itemData, isAdd)
    this.RefreshConsume(item.data.itemData, isAdd)
    this.RefreshAcquire(item.data.itemData, isAdd)
  end
end

function BagInfoData.RefreshDecompose(itemInfo, isAdd)
  if isAdd then
    table.insert(this.DecomposeItemTbl, itemInfo)
  else
    for k, v in pairs(this.DecomposeItemTbl) do
      if v == itemInfo then
        table.remove(this.DecomposeItemTbl, k)
      end
    end
  end
end

function BagInfoData.RefreshConsume(itemInfo, isAdd)
  local moneyCost
  if ItemUtility.IsRuneType(itemInfo.tblItem.type) then
    if itemInfo.serverInfo and itemInfo.serverInfo.runesLevel then
      local id = tonumber(itemInfo.itemId .. itemInfo.serverInfo.runesLevel)
      moneyCost = ClientTable.cfg_Item_decompose_runesManager:TryGetValue(id)
    end
  else
    moneyCost = ClientTable.cfg_Item_decomposeManager:TryGetValue(itemInfo.itemId)
  end
  if moneyCost == nil or moneyCost.moneyCost == nil then
    return
  end
  local moneyCostStr = string.split(moneyCost.moneyCost, "#")
  if isAdd then
    if table.count(this.consumeItemTbl) > 0 then
      for k, v in pairs(this.consumeItemTbl) do
        if k == moneyCostStr[1] then
          this.consumeItemTbl[k] = tonumber(v) + tonumber(moneyCostStr[2])
        end
      end
      if this.consumeItemTbl[moneyCostStr[1]] == 0 or this.consumeItemTbl[moneyCostStr[1]] == nil then
        this.consumeItemTbl[moneyCostStr[1]] = moneyCostStr[2]
      end
    else
      this.consumeItemTbl[moneyCostStr[1]] = moneyCostStr[2]
    end
  elseif table.count(this.consumeItemTbl) > 0 then
    for k, v in pairs(this.consumeItemTbl) do
      if k == moneyCostStr[1] then
        this.consumeItemTbl[k] = tonumber(v) - tonumber(moneyCostStr[2])
      end
    end
  end
end

function BagInfoData.RefreshAcquire(itemInfo, isAdd)
  local moneyCost
  if ItemUtility.IsRuneType(itemInfo.tblItem.type) then
    if itemInfo.serverInfo and itemInfo.serverInfo.runesLevel then
      local id = tonumber(itemInfo.itemId .. itemInfo.serverInfo.runesLevel)
      moneyCost = ClientTable.cfg_Item_decompose_runesManager:TryGetValue(id)
    end
  else
    moneyCost = ClientTable.cfg_Item_decomposeManager:TryGetValue(itemInfo.itemId)
  end
  if moneyCost == nil or moneyCost.clientReward == nil or moneyCost.clientRewardNum == nil then
    return
  end
  local clientReward = string.split(moneyCost.clientReward, "#")
  local clientRewardNum = string.split(moneyCost.clientRewardNum, "#")
  if isAdd then
    if table.count(this.acquireItemTbl) > 0 then
      for i = table.count(clientReward), 1, -1 do
        for j = 1, table.count(this.acquireItemTbl) do
          if clientReward[i] == this.acquireItemTbl[j].clientReward then
            local clIntervalNum = string.split(clientRewardNum[i], "_")
            local acIntervalNum = string.split(this.acquireItemTbl[j].clientRewardNum, "~")
            local temp1, temp2 = 0, 0
            if clIntervalNum[1] then
              temp1 = temp1 + tonumber(clIntervalNum[1])
            end
            if acIntervalNum[1] then
              temp1 = temp1 + tonumber(acIntervalNum[1])
            end
            if clIntervalNum[2] then
              temp2 = temp2 + tonumber(clIntervalNum[2])
            end
            if acIntervalNum[2] then
              temp2 = temp2 + tonumber(acIntervalNum[2])
            end
            local clientRewardNumStr
            if 0 < temp2 then
              clientRewardNumStr = string.format("%d~%d", temp1, temp2)
            else
              clientRewardNumStr = string.format("%d", temp1)
            end
            this.acquireItemTbl[j].clientRewardNum = clientRewardNumStr
            table.remove(clientReward, i)
            table.remove(clientRewardNum, i)
            break
          end
        end
      end
      for i = 1, table.count(clientReward) do
        local clientRewardTbl = {}
        clientRewardTbl.clientReward = clientReward[i]
        clientRewardTbl.clientRewardNum = string.replace(clientRewardNum[i], "_", "~")
        table.insert(this.acquireItemTbl, clientRewardTbl)
      end
    else
      for i = 1, table.count(clientReward) do
        local clientRewardTbl = {}
        clientRewardTbl.clientReward = clientReward[i]
        clientRewardTbl.clientRewardNum = string.replace(clientRewardNum[i], "_", "~")
        table.insert(this.acquireItemTbl, clientRewardTbl)
      end
    end
  else
    for i = 1, table.count(clientReward) do
      for j = 1, table.count(this.acquireItemTbl) do
        if clientReward[i] == this.acquireItemTbl[j].clientReward then
          local clIntervalNum = string.split(clientRewardNum[i], "_")
          local acIntervalNum = string.split(this.acquireItemTbl[j].clientRewardNum, "~")
          if tonumber(acIntervalNum[2]) and tonumber(clIntervalNum[2]) then
            if 0 >= tonumber(acIntervalNum[2]) - tonumber(clIntervalNum[2]) then
              table.remove(this.acquireItemTbl, j)
              break
            end
            do
              local temp1, temp2 = 0, 0
              if acIntervalNum[1] then
                temp1 = temp1 + tonumber(acIntervalNum[1])
              end
              if clIntervalNum[1] then
                temp1 = temp1 - tonumber(clIntervalNum[1])
              end
              if acIntervalNum[2] then
                temp2 = temp2 + tonumber(acIntervalNum[2])
              end
              if clIntervalNum[2] then
                temp2 = temp2 - tonumber(clIntervalNum[2])
              end
              local clientRewardNumStr
              if 0 < temp2 then
                clientRewardNumStr = string.format("%d~%d", temp1, temp2)
              else
                clientRewardNumStr = string.format("%d", temp1)
              end
              this.acquireItemTbl[j].clientRewardNum = clientRewardNumStr
            end
            break
          else
            if 0 >= tonumber(acIntervalNum[1]) - tonumber(clIntervalNum[1]) then
              table.remove(this.acquireItemTbl, j)
              break
            end
            do
              local temp1 = 0
              if acIntervalNum[1] then
                temp1 = temp1 + tonumber(acIntervalNum[1])
              end
              if clIntervalNum[1] then
                temp1 = temp1 - tonumber(clIntervalNum[1])
              end
              this.acquireItemTbl[j].clientRewardNum = string.format("%d", temp1)
            end
            break
          end
        end
      end
    end
  end
end

function BagInfoData.SelectItems(filter)
  local result = {}
  local bPass = true
  for _, v in pairs(this.TotalItems) do
    bPass = true
    for j = 1, #filter do
      if not filter[j]:Check(v) then
        bPass = false
        break
      end
    end
    if bPass then
      table.insert(result, v)
    end
  end
  return result
end

function BagInfoData.SelectItemsAndID(filter)
  local result = {}
  local bPass = true
  for _, v in pairs(this.TotalItems) do
    bPass = true
    for j = 1, #filter do
      if filter[1] and filter[1].param ~= v.itemId or not filter[j]:Check(v) then
        bPass = false
        break
      end
    end
    if bPass then
      table.insert(result, v)
    end
  end
  return result
end

function BagInfoData.SelectItemsInID(itemIDTbl)
  local result = {}
  local bPass = true
  for _, v in pairs(this.TotalItems) do
    bPass = false
    for __, vv in pairs(itemIDTbl) do
      if v.itemId == vv then
        bPass = true
        break
      end
    end
    if bPass then
      table.insert(result, v)
    end
  end
  return result
end

function BagInfoData.GetItemByConfigID(configId)
  for _, v in pairs(this.TotalItems) do
    if v and v.itemId == configId then
      return v
    end
  end
end

function BagInfoData.IsCanShowInBag(uiid, itemInfo, childType)
  if not itemInfo then
    return false
  end
  local tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(itemInfo.itemId)
  local flag = true
  if uiid == UIID.Equip_Decompose then
    local ItemDecompose = ClientTable.cfg_Item_decomposeManager:TryGetValue(itemInfo.itemId, "id")
    if ItemDecompose == nil then
      flag = false
    end
  elseif uiid == UIID.Equip_RunesDecomposeUI then
    if ItemUtility.IsRuneType(tblItem.type) == false then
      flag = false
    end
  elseif uiid == UIID.Skill_SetSkillUI then
    if tblItem.type ~= EItemType.Consumables then
      flag = false
    end
  elseif uiid == UIID.BagSellInfoUI then
    if string.isNullOrEmpty(tblItem.sell) then
      flag = false
    end
  elseif uiid == UIID.Equip_ZhuijiaUI or uiid == UIID.Equip_IntensifyUI then
    local isShow = tblItem.type == EItemType.Equipe and (tblItem.subType <= EItemSubtype.Wing or tblItem.subType == EItemSubtype.BowBag or tblItem.subType == EItemSubtype.CrossBowBag or tblItem.subType == EItemSubtype.Earrings or tblItem.subType >= EItemSubtype.Suit_Earring and tblItem.subType <= EItemSubtype.Suit_RingRight or tblItem.subType >= EItemSubtype.HongZhuang_OneHandedSword and tblItem.subType <= EItemSubtype.HongZhuang_Shield)
    if not isShow then
      flag = false
    elseif uiid == UIID.Equip_IntensifyUI then
      flag = RoleEquipUtility.CheckCanIntensify(itemInfo.itemId)
    elseif uiid == UIID.Equip_ZhuijiaUI then
      flag = RoleEquipUtility.CheckCanZhuiJia(itemInfo.itemId)
    end
  elseif uiid == UIID.Equip_Transfer then
    local isShow = tblItem.type == EItemType.Equipe and tblItem.subType ~= EItemSubtype.Guards and tblItem.subType ~= EItemSubtype.Mount and tblItem.subType ~= EItemSubtype.vipType and tblItem.subType ~= EItemSubtype.pickCard
    if not isShow or not this.IsShowEquip(itemInfo) then
      flag = false
    end
  elseif uiid == UIID.Equip_OverlapUI then
    local isShow = tblItem.type == EItemType.Equipe and tblItem.subType ~= EItemSubtype.Guards and tblItem.subType ~= EItemSubtype.Mount and itemInfo.isSuit == true
    if not isShow then
      flag = false
    end
  elseif uiid == UIID.Equip_StoneUI then
    local isShow = tblItem.type == EItemType.FireGem or tblItem.type == EItemType.WaterGem or tblItem.type == EItemType.IceGem or tblItem.type == EItemType.WindGem
    if not isShow then
      flag = false
    end
  elseif uiid == UIID.Equip_XiLianUI then
    if tblItem == nil or ItemUtility.IsEquipType(tblItem.type) == false or gameMgr:GetAvatarManager():GetMainPlayer():GetXiLianDataMgr():IsXiLianEquip(itemInfo.id) then
      return false
    end
    return ClientTable.cfg_Item_equipManager:EquipCanXiLian(itemInfo.itemId) == true and ClientTable.cfg_Item_reExcellManager:GetXiLianCostList(itemInfo.itemId) ~= nil and #RoleEquipUtility.GetEquipExcellenceDesByServerInfo(itemInfo.excellentInfo) > 0
  elseif uiid == UIID.Equip_HolySpiritLeftUI and (tblItem == nil or ItemUtility.IsEquipType(tblItem.type) == false or not ItemUtility.IsHolySpiritEquipType(tblItem.subType)) then
    return false
  end
  return flag
end

function BagInfoData.EquipIntensifySort(tabData)
  local normalTable = table.metatableCopy(nil, tabData)
  table.sort(normalTable, function(b, a)
    local isSort = false
    if a == nil or b == nil then
      return false
    end
    if b.tblItem.type == 2 and b.tblItem.subType ~= 21 and b.tblItem.subType ~= 22 and (a.tblItem.type ~= 2 or a.tblItem.subType == 21 or a.tblItem.subType == 22) then
      isSort = true
    end
    return isSort
  end)
  return normalTable
end

function BagInfoData.EquipSuitSort(tabData)
  local suitTable = table.metatableCopy(nil, tabData)
  table.sort(suitTable, function(b, a)
    local isSort = false
    if a == nil or b == nil then
      return false
    end
    if b.tblItem.type == EItemType.Equipe and b.tblItem.subType ~= EItemSubtype.Guards and b.tblItem.subType ~= EItemSubtype.Mount and b.isSuit and (a.tblItem.type ~= EItemType.Equipe or a.tblItem.subType == EItemSubtype.Guards or a.tblItem.subType == EItemSubtype.Mount or a.isSuit == false) then
      isSort = true
    end
    return isSort
  end)
  return suitTable
end

function BagInfoData.EquipDecomposeSort(tabData)
  if not tabData then
    return nil
  end
  local DecomposeTable = {}
  for _, v in pairs(tabData) do
    if this.IsCanShowInBag(UIID.Equip_Decompose, v) then
      table.insert(DecomposeTable, v)
    end
  end
  return DecomposeTable
end

function BagInfoData.EquipConsumablesSort(tabData)
  if not tabData then
    return nil
  end
  local consumeTable = {}
  for _, itemData in pairs(tabData) do
    if this.IsCanShowInBag(UIID.Skill_SetSkillUI, itemData) then
      table.insert(consumeTable, itemData)
    end
  end
  return consumeTable
end

function BagInfoData.RecycleItems(tabData)
  if not tabData then
    return {}
  end
  local recycleItemTbl = {}
  for _, itemData in pairs(tabData) do
    if this.IsCanShowInBag(UIID.BagSellInfoUI, itemData) then
      table.insert(recycleItemTbl, itemData)
    end
  end
  return recycleItemTbl
end

function BagInfoData.TransfromShow(tabData)
  if not tabData then
    return nil
  end
  local tranShowTbl = {}
  local specialIndex = 1
  for _, id in ipairs(this.SpecialItem) do
    if this.CoinInfos[id] ~= nil then
      local itemData = ItemUtility.GenerateItemDataByServerData({
        itemId = id,
        id = -specialIndex,
        count = this.CoinInfos[id],
        bagGridIndex = -specialIndex
      })
      table.insert(tranShowTbl, itemData)
      specialIndex = specialIndex + 1
    end
  end
  for _, itemData in pairs(tabData) do
    table.insert(tranShowTbl, itemData)
  end
  return tranShowTbl
end

function BagInfoData.CopyBag()
  local copyTotalBag = {}
  for _, item in pairs(this.TotalItems) do
    local copyItem = table.metatableCopy(nil, item)
    copyTotalBag[copyItem.bagGridIndex + 1] = copyItem
  end
  return copyTotalBag
end

function BagInfoData.GetTotalBag()
  return this.TotalItems
end

function BagInfoData.UpdateEquipAttri(changeItem)
  local item = this.TotalItems[changeItem.bagGridIndex + 1]
  item:RefreshData(changeItem)
  EventManager.Dispatch(Event.Bag_ResBagChange, {
    showItems = {changeItem}
  })
  return item
end

function BagInfoData.ItemOverlyJudge(itemConfig, count, putIn, totalBag)
  totalBag = totalBag or this.TotalItems
  for _, item in pairs(totalBag) do
    if item.itemId == itemConfig.id then
      local spaceCount = itemConfig.overlying - item.count
      local reduceCount = count
      if putIn then
        if count > spaceCount then
          reduceCount = spaceCount
        end
        item.count = item.count + reduceCount
      end
      if count <= spaceCount then
        return true
      end
    end
  end
  return false
end

function BagInfoData.BagSpaceJudge2(configId, count, putIn, totalBag, freeList)
  for id, v in pairs(this.CoinInfos) do
    if id == configId then
      return true
    end
  end
  totalBag = totalBag or this.TotalItems
  freeList = freeList or this.freeList
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(configId)
  if itemConfig.type ~= EItemType.Equipe then
    local canPutIn = this.ItemOverlyJudge(itemConfig, count, putIn, totalBag)
    if canPutIn then
      return true
    end
  end
  local w, h = itemConfig.xTranslate * this.cellSize, itemConfig.yTranslate * this.cellSize
  if freeList then
    for i = 1, #freeList do
      if w <= freeList[i].width and h <= freeList[i].height then
        return true
      end
    end
  end
  return false
end

function BagInfoData.SafeBagSpaceJudge_ItemIdList(itemDataList)
  local totalBag = BagInfoData.CopyBag()
  local bagGridCalcManager = this.GetBagGridCalcManager():GetCopyBagCalcManager()
  local state = true
  for k, v in pairs(itemDataList) do
    if state == false then
      break
    end
    state = this.BagSpaceJudge(v.itemId, v.count, true, totalBag, bagGridCalcManager)
  end
  return state
end

function BagInfoData.SafeBagSpaceJudge(configId, count, putIn)
  local totalBag = BagInfoData.CopyBag()
  local bagGridCalcManager = this.GetBagGridCalcManager():GetCopyBagCalcManager()
  return this.BagSpaceJudge(configId, count, putIn, totalBag, bagGridCalcManager)
end

function BagInfoData.BagSpaceJudge(configId, count, putIn, totalBag, bagGridCalcManager)
  for id, v in pairs(this.CoinInfos) do
    if id == configId then
      return true
    end
  end
  totalBag = totalBag or this.TotalItems
  local itemConfig = ClientTable.cfg_Item_itemManager:TryGetValue(configId)
  if itemConfig.type ~= EItemType.Equipe then
    local canPutIn = this.ItemOverlyJudge(itemConfig, count, putIn, totalBag)
    if canPutIn then
      return true
    end
  end
  local w, h = itemConfig.xTranslate * this.cellSize, itemConfig.yTranslate * this.cellSize
  local emptySpace
  if putIn then
    local itemData = ItemUtility.GenerateItemData(configId)
    emptySpace = bagGridCalcManager:TryInsertItem(w, h)
    if emptySpace and emptySpace.height >= this.cellSize then
      local y = Mathf.Floor(Mathf.Abs(emptySpace.y) / this.cellSize)
      local x = Mathf.Floor(emptySpace.x / this.cellSize)
      itemData.bagGridIndex = y * this.colCount + x
      totalBag[itemData.bagGridIndex + 1] = itemData
      local spaceCount = itemConfig.overlying
      local reduceCount = count
      if count > spaceCount then
        reduceCount = spaceCount
      end
      itemData.count = reduceCount
      if count > spaceCount then
        return this.BagSpaceJudge(configId, count - spaceCount, putIn, totalBag, bagGridCalcManager)
      end
    end
  else
    emptySpace = bagGridCalcManager:FindFreeCell(w, h)
  end
  local flag = false
  if emptySpace ~= nil then
    flag = emptySpace.height >= this.cellSize
  end
  return flag
end

function BagInfoData.FirstGetEquip(items, firstGains)
  for i, v in pairs(firstGains) do
    if v then
      local firstequip = BagInfoData.FirstPropData[i]
      if firstequip then
        local item = items[i]
        local Itemsinfo = this.GetTotalBag()
        local Items = Itemsinfo[item.bagGridIndex + 1] or nil
        local canUse = RoleEquipUtility.CheckUseItem(Items, CheckUseItemWay.NotTip)
        if canUse then
          NetManager.Send(EquipMessage.ReqPutOnTheEquip, {
            position = firstequip,
            equipId = item.id
          })
          if MountData.DefaultMount == 0 then
            NetManager.Send(EquipMessage.ReqEquipDefaultHorse, {
              equipId = item.id
            })
            NetManager.Send(EquipMessage.ReqChangeHorseState, {position = firstequip, ride = true})
          end
          return true
        end
      end
    end
  end
  return false
end

function BagInfoData.IsSuit(itemData)
  if not itemData then
    return false
  end
  if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or itemData.isSuit == false or table.count(itemData.excellence) > 3 then
    return false
  end
  return true
end

function BagInfoData.IsDecompose(itemData)
  if not itemData then
    return false
  end
  if ItemUtility.IsRuneType(itemData.tblItem.type) then
    local ItemDecompose
    if itemData.serverInfo and itemData.serverInfo.runesLevel then
      local id = tonumber(itemData.itemId .. itemData.serverInfo.runesLevel)
      ItemDecompose = ClientTable.cfg_Item_decompose_runesManager:TryGetValue(id, "id")
    end
    if ItemDecompose == nil then
      return false
    end
  else
    local ItemDecompose = ClientTable.cfg_Item_decomposeManager:TryGetValue(itemData.tblItem.id, "id")
    if ItemDecompose == nil then
      return false
    end
  end
  return true
end

function BagInfoData.IsIntensify(itemData)
  if not itemData then
    return false
  end
  if ForgeData.EquipTransferMain == nil and ForgeData.EquipTransferSecond == nil then
    if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or itemData.intensify <= 0 then
      return false
    end
  elseif ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond == nil then
    if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or ForgeData.EquipTransferMain.intensify <= itemData.intensify and ForgeData.EquipTransferMain ~= itemData then
      return false
    end
  elseif ForgeData.EquipTransferMain == nil and ForgeData.EquipTransferSecond ~= nil then
    if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or ForgeData.EquipTransferSecond.intensify >= itemData.intensify then
      return false
    end
  elseif ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond ~= nil and itemData ~= ForgeData.EquipTransferMain and itemData ~= ForgeData.EquipTransferSecond then
    return false
  end
  return true
end

local function ConditionJudge(itemInfo, condition, config)
  local flag = false
  if itemInfo.tblItem.autoSell == 1 then
    return flag
  end
  if itemInfo.tblItem.type == condition.type then
    if condition.type == EItemType.Equipe then
      local upState = RoleEquipUtility.CanUpFight(itemInfo)
      if (upState == EquipUpState.CanWearUpFight or upState == EquipUpState.CantWearUpFight) and RoleManager.me.level < tonumber(GlobalConfig.GetGlobalConfig(2140025)) then
        return false
      end
      if condition.career then
        local careerCanUseItem = RoleEquipUtility.CheckCareerEquip(itemInfo.tblItem.id, condition.career)
        if careerCanUseItem == false then
          return true
        end
      end
      if itemInfo.tblEquip.cellType == EquipCellType.HONGZHUANG and (upState == EquipUpState.CantWear or upState == EquipUpState.cantUpFight or upState == EquipUpState.None) and config ~= nil then
        local temptog = string.split(config, "#")
        if 0 < #temptog then
          for i = 1, 10 do
            if tonumber(temptog[i]) == 10 then
              return true
            end
          end
        end
      end
      if condition.equipClassType and itemInfo.tblEquip ~= nil and string.isNullOrEmpty(itemInfo.tblEquip.equipPosition) == false then
        local equipIndexList = string.split(itemInfo.tblEquip.equipPosition, "#")
        local bodyEquipList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetEquipDataListByItemId(itemInfo.tblEquip.id)
        if type(bodyEquipList) == "table" and 0 < #bodyEquipList and #bodyEquipList == #equipIndexList then
          for k, v in pairs(bodyEquipList) do
            if v:IsSameType(itemInfo.tblItem.id) and (condition.equipClassType == RecycleEquipClassType.Less and itemInfo.tblEquip.equipClass < v:GetEquipTbl().equipClass or condition.equipClassType == RecycleEquipClassType.Equal and itemInfo.tblEquip.equipClass == v:GetEquipTbl().equipClass or condition.equipClassType == RecycleEquipClassType.Greater and itemInfo.tblEquip.equipClass > v:GetEquipTbl().equipClass or condition.equipClassType == RecycleEquipClassType.LessEqual and itemInfo.tblEquip.equipClass <= v:GetEquipTbl().equipClass or condition.equipClassType == RecycleEquipClassType.GreaterEqual and itemInfo.tblEquip.equipClass >= v:GetEquipTbl().equipClass) then
              return true
            end
          end
        end
      end
      if itemInfo.tblEquip ~= nil and 0 < table.count(itemInfo.excellence) and string.isNullOrEmpty(itemInfo.tblEquip.equipPosition) == false and ClientTable.cfg_Global_globalManager:ExcellentEquipRecycleLimit() then
        local equipIndexList = string.split(itemInfo.tblEquip.equipPosition, "#")
        local bodyEquipList = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetEquipDataListByItemId(itemInfo.tblEquip.id)
        if type(bodyEquipList) == "table" and 0 < #bodyEquipList and #bodyEquipList == #equipIndexList then
          for k, v in pairs(bodyEquipList) do
            if v:IsSameType(itemInfo.tblItem.id) and v:IsBetterEquipClass(itemInfo.tblEquip.equipClass) then
              return false
            end
          end
        end
      end
      if 0 < table.count(itemInfo.excellence) and RoleManager.me.level < tonumber(GlobalConfig.GetGlobalConfig(2140025)) then
        local careers = string.split(itemInfo.tblItem.career, "#")
        local isCanWear = false
        for _, v in pairs(careers) do
          if RoleUtility.JudgeWardCompatibilty(ViewData.meData.career, tonumber(v)) == 2 then
            isCanWear = true
            break
          end
        end
        if isCanWear then
          return false
        end
      end
      if itemInfo.isSuit then
        if condition.suitType == nil then
          return false
        end
        local suitType = gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetSuitManager():GetSuitTypeByItemId(itemInfo.tblItem.id)
        return suitType == condition.suitType
      end
      if condition.excellenceCount and itemInfo.excellence and table.count(itemInfo.excellence) == condition.excellenceCount then
        if not condition.intensify then
          if not itemInfo.intensify or itemInfo.intensify == 0 then
            return true
          end
        else
          return true
        end
      end
      if condition.subType and condition.subType == EItemSubtype.Guards and itemInfo.tblItem.subType == condition.subType then
        return true
      end
      if condition.excellence == 0 and (not itemInfo.excellence or table.count(itemInfo.excellence) == 0) then
        if not condition.intensify then
          if (not itemInfo.intensify or itemInfo.intensify == 0) and itemInfo.tblItem.subType ~= EItemSubtype.Guards then
            return true
          end
        elseif itemInfo.tblItem.subType ~= EItemSubtype.Guards then
          return true
        end
      end
      if condition.intensify and (itemInfo.intensify and itemInfo.intensify > condition.intensify or itemInfo.additional and itemInfo.additional > condition.additional) then
        return true
      end
      return false
    elseif condition.type == EItemType.Consumables then
      if condition.subType == EItemSubtype.Consumable then
        if table.contains(this.RedMedicineItemIds, itemInfo.itemId) or table.contains(this.BlueMedicineItemIds, itemInfo.itemId) then
          return this.JudgeMedicineItemIdRecycle(itemInfo.itemId)
        end
      elseif condition.subType == EItemSubtype.skillBook then
        return itemInfo.tblItem.subType == EItemSubtype.skillBook
      end
    end
  end
  return flag
end

function BagInfoData.IsAutoSelectRecycle(itemData)
  local flag = false
  if not string.isNullOrEmpty(itemData.tblItem.sell) and not table.isNullOrEmpty(BagSellController.GetCurrRecycleTogConfig()) then
    return BagSellController:CheckItemIsRecycle(itemData)
  end
  return flag
end

function BagInfoData.IsSelectRecycle(itemData)
  local flag = false
  if not string.isNullOrEmpty(itemData.tblItem.sell) and this.RecycleItemTbl and this.RecycleItemTbl[itemData.bagGridIndex] then
    flag = true
  end
  return flag
end

function BagInfoData.IsZhuiJia(itemData)
  if not itemData then
    return false
  end
  if ForgeData.EquipTransferMain == nil and ForgeData.EquipTransferSecond == nil then
    if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or itemData.additional <= 0 then
      return false
    end
  elseif ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond == nil then
    if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or ForgeData.EquipTransferMain.additional <= itemData.additional and ForgeData.EquipTransferMain ~= itemData then
      return false
    end
  elseif ForgeData.EquipTransferMain == nil and ForgeData.EquipTransferSecond ~= nil then
    if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount or ForgeData.EquipTransferSecond.additional >= itemData.additional then
      return false
    end
  elseif ForgeData.EquipTransferMain ~= nil and ForgeData.EquipTransferSecond ~= nil and itemData ~= ForgeData.EquipTransferMain and itemData ~= ForgeData.EquipTransferSecond then
    return false
  end
  return true
end

function BagInfoData.IsShowEquip(itemInfo)
  if not itemInfo then
    return false
  end
  local tblItem = ClientTable.cfg_Item_itemManager:TryGetValue(itemInfo.itemId)
  if tblItem.subType == EItemSubtype.vipType or tblItem.subType == EItemSubtype.Guards or tblItem.subType == EItemSubtype.Earrings or tblItem.subType == EItemSubtype.Ring or tblItem.subType == EItemSubtype.Necklace then
    return false
  end
  local transferType = TransferFilterType.None
  if ForgeData.EquipTransferMain ~= nil then
    transferType = ForgeData.EquipTransferSecond == nil and TransferFilterType.ChooseMainEquip or TransferFilterType.ChooseMainEquipAndSecondEquip
  end
  return BagInfoData.EquipTransferFilter(itemInfo, transferType, ForgeData.EquipTransferMain, ForgeData.isChooseAdd, ForgeData.isChooseIntensify, ForgeData.isRegene)
end

function BagInfoData.EquipTransferFilter(equipData, transferType, equipTransferMain, chooseAdd, chooseIntensify, chooseRegene)
  if transferType == TransferFilterType.None then
    return chooseAdd == true and equipData.additional > 0 or chooseIntensify == true and 0 < equipData.intensify or chooseRegene == true and 0 < table.count(equipData.RegenerateAttributeList)
  elseif transferType == TransferFilterType.ChooseMainEquip then
    if equipData.subType == EItemSubtype.Wing and ForgeData.EquipTransferMain.tblEquip.subType ~= EItemSubtype.Wing then
      return false
    elseif ForgeData.EquipTransferMain.tblEquip.subType == EItemSubtype.Wing and equipData.subType ~= EItemSubtype.Wing then
      return false
    end
    local isSameItem = ItemUtility:IsSameTypeEquip(equipTransferMain.tblEquip, equipData.tblEquip)
    local isChooseItem = chooseAdd == true and chooseIntensify == true and chooseRegene == true and equipData.additional == 0 and equipData.intensify == 0 and table.count(equipData.RegenerateAttributeList) == 0 or chooseAdd == true and chooseIntensify == false and chooseRegene == false and equipData.additional == 0 or chooseAdd == false and chooseIntensify == true and chooseRegene == false and equipData.intensify == 0 or chooseAdd == false and chooseIntensify == false and chooseRegene == true and table.count(equipData.RegenerateAttributeList) == 0 or chooseAdd == true and chooseIntensify == true and chooseRegene == false and equipData.additional == 0 and equipData.intensify == 0 or chooseAdd == false and chooseIntensify == true and chooseRegene == true and equipData.intensify == 0 and table.count(equipData.RegenerateAttributeList) == 0 or chooseAdd == true and chooseIntensify == false and chooseRegene == true and equipData.additional == 0 and table.count(equipData.RegenerateAttributeList) == 0
    return isSameItem and isChooseItem
  elseif transferType == TransferFilterType.ChooseMainEquipAndSecondEquip then
    return false
  end
  return false
end

function BagInfoData.IsOnClick(itemData)
  if not itemData then
    return false
  end
  if itemData.tblItem.type ~= EItemType.Equipe or itemData.tblItem.subType == EItemSubtype.Guards or itemData.tblItem.subType == EItemSubtype.Mount then
    return false
  end
  return true
end

function BagInfoData.IsConsumables(itemData)
  if not itemData then
    return false
  end
  local item = ClientTable.cfg_Item_itemManager:TryGetValue(itemData.itemId)
  if item == nil or item.type ~= EItemType.Consumables then
    return false
  end
  return true
end

function BagInfoData.GetItemByCondition()
  this.HandleMedicineMaxIndex()
  for _, resultItem in pairs(this.ResultTbl) do
    if this.RecycleItemTbl[resultItem.bagGridIndex] then
      this.RecycleItemTbl[resultItem.bagGridIndex] = nil
    end
  end
  local autoResultTbl = {}
  for _, itemInfo in pairs(this.TotalItems) do
    if not string.isNullOrEmpty(itemInfo.tblItem.sell) and BagSellController:CheckItemIsRecycle(itemInfo) then
      table.insert(autoResultTbl, itemInfo)
    end
  end
  for _, resultItem in pairs(autoResultTbl) do
    if not this.RecycleItemTbl[resultItem.bagGridIndex] then
      this.RecycleItemTbl[resultItem.bagGridIndex] = {
        id = resultItem.id,
        count = resultItem.count,
        sell = resultItem.tblItem.sell,
        sell = resultItem.tblItem.sell,
        bind = resultItem.bind,
        bagIndex = resultItem.bagGridIndex
      }
    end
  end
  this.ResultTbl = autoResultTbl
end

function BagInfoData.GetAutoRecycleItemTbl()
  local flag = false
  local recycleTbl = {
    recycleItems = {}
  }
  this.HandleMedicineMaxIndex()
  if BagInfoData.bagFiveFull and PlayerControlForceData.autoRecycleState and this.TotalItems ~= nil then
    for _, itemData in pairs(this.TotalItems) do
      if this.IsAutoSelectRecycle(itemData) then
        flag = true
        recycleTbl.recycleItems[itemData.id] = itemData.count
      end
    end
  end
  return flag, recycleTbl
end

function BagInfoData.GetRecycleConfig(togTbl)
  this.RecycleCancel = {}
  local changeTbl = {}
  local configStr = table.concat(togTbl, "#")
  for _, index in ipairs(togTbl) do
    local conditionTbl = BagSellController:GetRecycleConditionParam(index)
    if conditionTbl then
      table.insert(changeTbl, conditionTbl)
    end
  end
  return changeTbl, configStr
end

function BagInfoData.ArrowheadMinutes(itemData)
  if itemData.img_grrow and itemData.img_grrow.gameObject.activeSelf then
    if itemData.img_grrow.graphic.sprite.name == "ty_bag_green(Clone)" or itemData.img_grrow.graphic.sprite.name == "ty_bag_green" then
      return 1
    elseif itemData.img_grrow.graphic.sprite.name == "ty_bag_yellow(Clone)" or itemData.img_grrow.graphic.sprite.name == "ty_bag_yellow" then
      return 2
    end
  end
end

function BagInfoData.ArrowheadItems(tabData)
  if not tabData then
    return {}
  end
  local ArrowheadItemTbl = {
    GreenArrow = {},
    YellowArrow = {}
  }
  for _, itemData in pairs(tabData) do
    local State = this.ArrowheadMinutes(itemData)
    if State == 1 then
      table.insert(ArrowheadItemTbl.GreenArrow, itemData)
    elseif State == 2 then
      table.insert(ArrowheadItemTbl.YellowArrow, itemData)
    end
  end
  return ArrowheadItemTbl
end

function BagInfoData.RemoveArrowhead(tabData)
end

function BagInfoData.GetShowSellConfigDataList()
  if type(BagInfoData.sellConfigData) ~= "table" or next(BagInfoData.sellConfigData) == nil then
    return
  end
  local sellConfigList = {}
  for k, v in pairs(BagInfoData.sellConfigData) do
    if BagSellController:RecycleConfigShow(v.id) then
      table.insert(sellConfigList, v)
    end
  end
  return sellConfigList
end

function BagInfoData.GetBagGridCalcManager()
  if this.mBagGridCalcManager == nil then
    this.mBagGridCalcManager = LuaClass.BagGridCalcManager:New()
  end
  return this.mBagGridCalcManager
end

function BagInfoData:GetTotalItemsIndexDic()
  if self.TotalItemsIndexDic == nil then
    self.TotalItemsIndexDic = {}
  end
  return self.TotalItemsIndexDic
end

function BagInfoData:AddTotalItemsIndexDic(itemId, index)
  if self.TotalItemsIndexDic == nil then
    self.TotalItemsIndexDic = {}
  end
  if self.TotalItemsIndexDic[itemId] == nil then
    self.TotalItemsIndexDic[itemId] = {}
  end
  if not table.contains(self.TotalItemsIndexDic[itemId], index) then
    table.insert(self.TotalItemsIndexDic[itemId], index)
  end
end

function BagInfoData:RemoveTotalItemsIndexDic(itemId, index)
  if self.TotalItemsIndexDic == nil or self.TotalItemsIndexDic[itemId] == nil then
    return
  end
  local keyPosition = table.getKey(self.TotalItemsIndexDic[itemId], index)
  if keyPosition then
    table.remove(self.TotalItemsIndexDic[itemId], keyPosition)
  end
  if table.count(self.TotalItemsIndexDic[itemId]) <= 0 then
    self.TotalItemsIndexDic[itemId] = nil
  end
end

function BagInfoData:GetItemCountByItemConfigIdFromIndexDic(configId)
  local count
  count = this.CoinInfos[configId]
  if count then
    return count
  end
  count = 0
  local itemBagIndexList = self.TotalItemsIndexDic[configId]
  if type(itemBagIndexList) ~= "table" then
    return count
  end
  for i, itemBagIndex in ipairs(itemBagIndexList) do
    count = count + self.TotalItems[itemBagIndex].count
  end
  return count
end

function BagInfoData:GetItemTotalCountByItemIdFromIndexDic(configId)
  local itemTab = ClientTable.cfg_Item_itemManager:TryGetValue(configId)
  local count = self:GetItemCountByItemConfigIdFromIndexDic(configId)
  if itemTab ~= nil and itemTab.bindEqualItem ~= 0 then
    count = count + self:GetItemCountByItemConfigIdFromIndexDic(itemTab.bindEqualItem)
  end
  return count
end

BagInfoData.Init()
