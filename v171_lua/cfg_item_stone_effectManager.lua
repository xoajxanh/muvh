local cfg_item_stone_effectManager = {}

function cfg_item_stone_effectManager:GetName()
  return "cfg_item_stone_effectManager"
end

function cfg_item_stone_effectManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_item_stone_effect")
  end
  return self.dic
end

setmetatable(cfg_item_stone_effectManager, TableManagerBase)

function cfg_item_stone_effectManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_item_stone_effectManager
