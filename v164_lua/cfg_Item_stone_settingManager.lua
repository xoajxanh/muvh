local cfg_Item_stone_settingManager = {}

function cfg_Item_stone_settingManager:GetName()
  return "cfg_Item_stone_settingManager"
end

function cfg_Item_stone_settingManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_stone_setting")
  end
  return self.dic
end

setmetatable(cfg_Item_stone_settingManager, TableManagerBase)

function cfg_Item_stone_settingManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_stone_settingManager
