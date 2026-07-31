local cfg_Item_mountManager = {}

function cfg_Item_mountManager:GetName()
  return "cfg_Item_mountManager"
end

function cfg_Item_mountManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_mount")
  end
  return self.dic
end

setmetatable(cfg_Item_mountManager, TableManagerBase)

function cfg_Item_mountManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_mountManager
