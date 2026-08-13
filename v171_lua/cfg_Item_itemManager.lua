local cfg_Item_itemManager = {}

function cfg_Item_itemManager:GetName()
  return "cfg_Item_itemManager"
end

function cfg_Item_itemManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_item")
  end
  return self.dic
end

setmetatable(cfg_Item_itemManager, TableManagerBase)

function cfg_Item_itemManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_itemManager:GetRecommendCareerList(id)
  if id == nil then
    return
  end
  local itemTbl = self:TryGetValue(id)
  if itemTbl == nil or string.isNullOrEmpty(itemTbl.newSellType) then
    return
  end
  local careerList, configCareerList = {}, string.split(itemTbl.newSellType, "&")
  for k, v in pairs(configCareerList) do
    local careerParams = string.split(v, "#")
    if 1 < #careerParams then
      table.insert(careerList, tonumber(careerParams[2]))
    end
  end
  return careerList
end

function cfg_Item_itemManager:GetItemName(id)
  local itemTbl = self:TryGetValue(id)
  return itemTbl and itemTbl.name or ""
end

return cfg_Item_itemManager
