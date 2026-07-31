local CombineFirstGiftData = {}
setmetatable(CombineFirstGiftData, LuaClass.CommerceActivity)

function CombineFirstGiftData:Init()
  self:RegistEvent(Event.CombineFirstGiftCount, self.OnCombineFirstGiftCount, self)
end

function CombineFirstGiftData:SetShopInfoData(ShopInfoData)
  self.ShopInfoData = ShopInfoData
  self.Item_buyList = self:GetItem_buyList(ShopInfoData)
  self.GiftDetailedInfoList = self:GetGiftDetailedInfoList(self.Item_buyList)
end

function CombineFirstGiftData:GetShopGiftList()
  if self.GiftDetailedInfoList == nil then
    return {}
  end
  return self.GiftDetailedInfoList
end

function CombineFirstGiftData:GetItem_buyList(ShopInfoData)
  if ShopInfoData == nil then
    return
  end
  local dataList = {}
  for i, v in pairs(ShopInfoData) do
    local data = ClientTable.cfg_Commerce_2Manager:TryGetValue(v.id)
    if data ~= nil then
      local Item_buy = string.split(data.shopId, "#")
      for c = 1, #Item_buy do
        table.insert(dataList, {
          shopId = Item_buy[c],
          type = data.type
        })
      end
    end
  end
  return dataList
end

function CombineFirstGiftData:GetGiftDetailedInfoList(Item_buyList)
  if Item_buyList == nil then
    return
  end
  local GiftDetailedInfoList = {}
  for i, data in pairs(Item_buyList) do
    if data.type == 1 then
      local itemBuyTable = ClientTable.cfg_Item_buyManager:TryGetValue(tonumber(data.shopId))
      if itemBuyTable ~= nil and ConditionManager.Check4D(itemBuyTable.showCondition) then
        local itemBuydata = {}
        local reward = string.split(itemBuyTable.reward, "#")
        local ItemuseParam = ClientTable.cfg_Item_itemManager:TryGetValue(tonumber(reward[1])).useParam
        local ItemBox = string.split(ItemuseParam, "#")
        local BoxItem = ClientTable.cfg_Box_boxManager:TryGetShowListByBoxId(tonumber(ItemBox[2]))
        local refreshCount = ClientTable.cfg_Count_countManager:TryGetValue(itemBuyTable.countKey)
        local titleDes = ClientTable.cfg_Ui_wordManager:TryGetValue(itemBuyTable.title)
        local amount = string.split(itemBuyTable.cost, "#")
        itemBuydata.itemBuyTable = itemBuyTable
        itemBuydata.BoxItem = BoxItem
        itemBuydata.title = titleDes == nil and "" or titleDes.content
        itemBuydata.countKey = itemBuyTable.countKey
        itemBuydata.amount = tonumber(amount[2])
        itemBuydata.refreshCountLimit = refreshCount == nil and 0 or refreshCount.refreshCountLimit
        itemBuydata.type = not string.isNullOrEmpty(amount[1]) and tonumber(amount[1]) == 1000021 and 3 or 1
        table.insert(GiftDetailedInfoList, itemBuydata)
      end
    elseif data.type == 2 then
      local rechargeTable = ClientTable.cfg_Recharge_rechargeManager:TryGetValue(tonumber(data.shopId))
      if rechargeTable ~= nil and ConditionManager.Check4D(rechargeTable.showCondition) then
        local itemBuydata = {}
        local BoxItem = ClientTable.cfg_Box_boxManager:TryGetTabListByType(rechargeTable.reward, "boxId")
        local refreshCount = ClientTable.cfg_Count_countManager:TryGetValue(rechargeTable.countKey)
        local titleDes = ClientTable.cfg_Ui_wordManager:TryGetValue(rechargeTable.title)
        itemBuydata.rechargeTable = rechargeTable
        itemBuydata.BoxItem = BoxItem
        itemBuydata.title = titleDes == nil and "" or titleDes.content
        itemBuydata.countKey = rechargeTable.countKey
        itemBuydata.rmb = rechargeTable.rmb
        itemBuydata.refreshCountLimit = refreshCount == nil and 0 or refreshCount.refreshCountLimit
        itemBuydata.type = 2
        table.insert(GiftDetailedInfoList, itemBuydata)
      end
    end
  end
  self:SortGiftDetailedInfoList(GiftDetailedInfoList)
  return GiftDetailedInfoList
end

function CombineFirstGiftData:GetItemBuydataRemainingTimes(itemBuydata)
  if itemBuydata == nil then
    return 0
  end
  return itemBuydata.refreshCountLimit - self:GetCount(itemBuydata.countKey)
end

function CombineFirstGiftData:GetCount(id)
  local countData = RefreshData.TotalRefreshTbl
  if countData == nil or countData[id] == nil then
    return 0
  end
  return countData[id].count
end

function CombineFirstGiftData:SortGiftDetailedInfoList(GiftDetailedInfoList)
  if GiftDetailedInfoList == nil then
    return
  end
  table.sort(GiftDetailedInfoList, function(a, b)
    local aState = self:GetItemBuydataRemainingTimes(a) == 0 and 0 or 1
    local bState = self:GetItemBuydataRemainingTimes(b) == 0 and 0 or 1
    if aState == bState then
      return a.itemBuyTable.commodityRanking < b.itemBuyTable.commodityRanking
    else
      return aState > bState
    end
  end)
end

function CombineFirstGiftData:OnCombineFirstGiftCount()
  self:SortGiftDetailedInfoList(self.GiftDetailedInfoList)
  EventManager.Dispatch(Event.CombineFirstGiftCountSortOver)
end

return CombineFirstGiftData
