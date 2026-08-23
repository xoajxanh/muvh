local cfg_item_stone_combinationManager = {}

function cfg_item_stone_combinationManager:GetName()
  return "cfg_item_stone_combinationManager"
end

function cfg_item_stone_combinationManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_item_stone_combination")
  end
  return self.dic
end

setmetatable(cfg_item_stone_combinationManager, TableManagerBase)

function cfg_item_stone_combinationManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

cfg_item_stone_combinationManager.stoneCombineTypeDic = nil

function cfg_item_stone_combinationManager:TryInitStoneCombineTypeDic()
  if self.stoneCombineTypeDic ~= nil then
    return
  end
  self.stoneCombineTypeDic = {}
  local data = self:GetDic()
  for k, v in pairs(data) do
    if self.stoneCombineTypeDic[v.type] == nil then
      self.stoneCombineTypeDic[v.type] = {}
    end
    table.insert(self.stoneCombineTypeDic[v.type], {
      level = v.level,
      stoneCombineTbl = v
    })
  end
end

function cfg_item_stone_combinationManager:GetStoneCombineInfoByLevel(gemType, level)
  if type(level) ~= "number" then
    return
  end
  self:TryInitStoneCombineTypeDic()
  local gemCombineTblList = self.stoneCombineTypeDic[gemType]
  if gemCombineTblList == nil or next(gemCombineTblList) == nil then
    return
  end
  local combineEffectInfo = {}
  combineEffectInfo.stoneCombineTbl = gemCombineTblList[1].stoneCombineTbl
  combineEffectInfo.IsActive = false
  for k, v in ipairs(gemCombineTblList) do
    if level < v.level then
      break
    end
    combineEffectInfo.stoneCombineTbl = v.stoneCombineTbl
    combineEffectInfo.IsActive = true
  end
  return combineEffectInfo
end

return cfg_item_stone_combinationManager
