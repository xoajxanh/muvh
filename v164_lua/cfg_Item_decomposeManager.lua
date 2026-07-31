local cfg_Item_decomposeManager = {}

function cfg_Item_decomposeManager:GetName()
  return "cfg_Item_decomposeManager"
end

function cfg_Item_decomposeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_decompose")
  end
  return self.dic
end

setmetatable(cfg_Item_decomposeManager, TableManagerBase)

function cfg_Item_decomposeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_decomposeManager
