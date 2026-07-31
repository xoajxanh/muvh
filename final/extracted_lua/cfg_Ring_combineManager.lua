local cfg_Ring_combineManager = {}

function cfg_Ring_combineManager:GetName()
  return "cfg_Ring_combineManager"
end

function cfg_Ring_combineManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ring_combine")
  end
  return self.dic
end

setmetatable(cfg_Ring_combineManager, TableManagerBase)

function cfg_Ring_combineManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Ring_combineManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Ring_combineManager:GetRewardBoxIdByItemId(itemId)
  if itemId == nil then
    return nil
  end
  local dic = self:TryGetValue(itemId, "itemId")
  return dic and dic.rewardItem or nil
end

function cfg_Ring_combineManager:GetId(itemId)
  if itemId == nil then
    return 0
  end
  local dic = self:TryGetValue(itemId, "itemId")
  return dic and dic.id or 0
end

function cfg_Ring_combineManager:GetIsMaxLevel(itemId)
  if itemId == nil then
    return false
  end
  local dic = self:TryGetValue(itemId, "itemId")
  return dic and dic.maxLevel == 1 or false
end

return cfg_Ring_combineManager
