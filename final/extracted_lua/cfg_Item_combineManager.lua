local cfg_Item_combineManager = {}

function cfg_Item_combineManager:GetName()
  return "cfg_Item_combineManager"
end

function cfg_Item_combineManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_combine")
  end
  return self.dic
end

setmetatable(cfg_Item_combineManager, TableManagerBase)

function cfg_Item_combineManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_combineManager:GetNeedShowCombineTipList()
  if self.CombineTipList ~= nil then
    return self.CombineTipList
  end
  self.CombineTipList = {}
  for i, v in pairs(self:GetDic()) do
    if v.CombineTip and v.CombineTip > 0 then
      table.insert(self.CombineTipList, v)
    end
  end
  return self.CombineTipList
end

function cfg_Item_combineManager:GetCombineCostItemIdDic()
  if self.CombineCostItemIdDic ~= nil then
    return self.CombineCostItemIdDic
  end
  self.CombineCostItemIdDic = {}
  for i, v in pairs(self:GetDic()) do
    if v.CombineTip and v.CombineTip > 0 and v.showType ~= 1 then
      if not string.isNullOrEmpty(v.monenyCost) then
        local costParams = string.stringToNumberArray(v.monenyCost, "#")
        costParams[1] = costParams[1] and costParams[1] or 0
        costParams[2] = costParams[2] and costParams[2] or 1000010
        costParams[3] = costParams[3] and costParams[3] or 0
        local costFinal, combineCount = nil, 1
        if costParams[1] == 0 then
          costFinal = costParams[3]
        else
          costFinal = costParams[3] * v.basicSuccessRate / 10000
        end
        costFinal = costFinal * combineCount
        if 0 < costFinal then
          local costItemId = costParams[2]
          if self.CombineCostItemIdDic[costItemId] == nil then
            self.CombineCostItemIdDic[costItemId] = {}
          end
          table.insert(self.CombineCostItemIdDic[costItemId], v.id)
        end
      end
      if v.costMainBuckets ~= nil then
        local strTab = v.costMainBuckets
        local conditionTab = strTab[1][1]
        local equipIdList = conditionTab[2]
        for i, equipId in ipairs(equipIdList) do
          if self.CombineCostItemIdDic[equipId] == nil then
            self.CombineCostItemIdDic[equipId] = {}
          end
          table.insert(self.CombineCostItemIdDic[equipId], v.id)
        end
      end
      local strTab, itemTab, itemId
      if not string.isNullOrEmpty(v.costSecondaryBuckets) then
        strTab = string.split(v.costSecondaryBuckets, "&")
        for k = 1, #strTab do
          itemTab = string.split(strTab[k], "#")
          itemId = tonumber(itemTab[1])
          if self.CombineCostItemIdDic[itemId] == nil then
            self.CombineCostItemIdDic[itemId] = {}
          end
          table.insert(self.CombineCostItemIdDic[itemId], v.id)
        end
      end
    end
  end
  return self.CombineCostItemIdDic
end

function cfg_Item_combineManager:GetNeedShowCombineTipListByItemId(itemId)
  if type(itemId) ~= "number" then
    return nil
  end
  return self:GetCombineCostItemIdDic()[itemId]
end

return cfg_Item_combineManager
