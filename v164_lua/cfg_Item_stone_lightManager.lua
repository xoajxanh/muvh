local cfg_Item_stone_lightManager = {}

function cfg_Item_stone_lightManager:GetName()
  return "cfg_Item_stone_lightManager"
end

function cfg_Item_stone_lightManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_stone_light")
  end
  return self.dic
end

setmetatable(cfg_Item_stone_lightManager, TableManagerBase)

function cfg_Item_stone_lightManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_stone_lightManager
