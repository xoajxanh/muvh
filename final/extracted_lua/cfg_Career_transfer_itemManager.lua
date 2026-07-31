local cfg_Career_transfer_itemManager = {}

function cfg_Career_transfer_itemManager:GetName()
  return "cfg_Career_transfer_itemManager"
end

function cfg_Career_transfer_itemManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Career_transfer_item")
  end
  return self.dic
end

setmetatable(cfg_Career_transfer_itemManager, TableManagerBase)

function cfg_Career_transfer_itemManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Career_transfer_itemManager:GetItemDic()
  if self.mItemDic == nil then
    self.mItemDic = {}
    for i, v in pairs(self:GetDic()) do
      if not string.isNullOrEmpty(v.cost) then
        local costId = tonumber(string.split(v.cost, "#")[1])
        if self.mItemDic[costId] == nil then
          self.mItemDic[costId] = {}
        end
        self.mItemDic[costId][v.itemId] = v
      end
    end
  end
  return self.mItemDic
end

function cfg_Career_transfer_itemManager:GetItemInfo(costId, itemId)
  local itemDic = self:GetItemDic()
  if itemDic and itemDic[costId] then
    return itemDic[costId][itemId]
  end
  return nil
end

return cfg_Career_transfer_itemManager
