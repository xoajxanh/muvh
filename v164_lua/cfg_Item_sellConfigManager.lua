local cfg_Item_sellConfigManager = {}

function cfg_Item_sellConfigManager:GetName()
  return "cfg_Item_sellConfigManager"
end

function cfg_Item_sellConfigManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_sellConfig")
  end
  return self.dic
end

function cfg_Item_sellConfigManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_sellConfigManager:GetValueList(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

setmetatable(cfg_Item_sellConfigManager, TableManagerBase)
return cfg_Item_sellConfigManager
