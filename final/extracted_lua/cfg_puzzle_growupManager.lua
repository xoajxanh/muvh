local cfg_puzzle_growupManager = {}

function cfg_puzzle_growupManager:GetName()
  return "cfg_puzzle_growupManager"
end

function cfg_puzzle_growupManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_puzzle_growup")
  end
  return self.dic
end

setmetatable(cfg_puzzle_growupManager, TableManagerBase)

function cfg_puzzle_growupManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_puzzle_growupManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_puzzle_growupManager:GetItemDataLevelIDCost(level, id)
  for i, v in pairs(self:GetDic()) do
    if v.itemId == id and level == v.level then
      return v.cost
    end
  end
end

function cfg_puzzle_growupManager:GetItemDataLevelIDReturnRatio(level, id)
  for i, v in pairs(self:GetDic()) do
    if v.itemId == id and level == v.level then
      return v.returnRatio
    end
  end
end

function cfg_puzzle_growupManager:GetItemDataLevelIDMaterial(level, id)
  local materialCount = 0
  local materialName = ""
  for i, v in pairs(self:GetDic()) do
    if v.itemId == id and level >= v.level and v.level ~= 0 then
      local data = string.split(v.cost, "#")
      materialName = data[1]
      materialCount = materialCount + tonumber(data[2])
    end
  end
  return materialName, materialCount
end

return cfg_puzzle_growupManager
