local cfg_Item_buyManager = {}

function cfg_Item_buyManager:GetName()
  return "cfg_Item_buyManager"
end

function cfg_Item_buyManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_buy")
  end
  return self.dic
end

setmetatable(cfg_Item_buyManager, TableManagerBase)

function cfg_Item_buyManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_buyManager:GetSpellSwordGift()
  if self.mSpellSwordGiftArray == nil then
    self.mSpellSwordGiftArray = {}
    for i, v in pairs(self.dic) do
      if v.type == 80 and v.subtype then
        if self.mSpellSwordGiftArray[v.subtype] == nil then
          self.mSpellSwordGiftArray[v.subtype] = {}
        end
        table.insert(self.mSpellSwordGiftArray[v.subtype], v)
      end
    end
    for i, v in pairs(self.mSpellSwordGiftArray) do
      table.sort(v, function(a, b)
        return a.commodityRanking < b.commodityRanking
      end)
    end
  end
  return self.mSpellSwordGiftArray
end

function cfg_Item_buyManager:GetSpellSwordGiftBySubType(subType)
  local giftArray = self:GetSpellSwordGift()
  local showGiftList = {}
  for i, v in ipairs(giftArray[subType]) do
    if v.showCondition and ConditionManager.Check4D(v.showCondition) then
      table.insert(showGiftList, v)
    end
  end
  return showGiftList
end

function cfg_Item_buyManager:GetAnniversaryActivityStoreShowGift()
  self.anniversaryActivityStoreAllShowGiftArray = {}
  for i, v in pairs(self.dic) do
    if v.type == 25 and v.showCondition and ConditionManager.Check4D(v.showCondition) then
      table.insert(self.anniversaryActivityStoreAllShowGiftArray, v)
    end
  end
  local SoldOutGiftArray = {}
  local ShowGiftArray = {}
  for i, v in pairs(self.anniversaryActivityStoreAllShowGiftArray) do
    local buyLimitCount = RefreshData.GetLimitCount(v.countKey)
    v.buyLimitCount = buyLimitCount
    if buyLimitCount ~= 0 then
      table.insert(ShowGiftArray, v)
    else
      table.insert(SoldOutGiftArray, v)
    end
  end
  table.sort(ShowGiftArray, function(a, b)
    return a.commodityRanking < b.commodityRanking
  end)
  if next(SoldOutGiftArray) ~= nil then
    table.sort(SoldOutGiftArray, function(a, b)
      return a.commodityRanking < b.commodityRanking
    end)
    table.combine(ShowGiftArray, SoldOutGiftArray)
  end
  return ShowGiftArray
end

return cfg_Item_buyManager
