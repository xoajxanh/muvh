local cfg_Item_decompose_runesManager = {}

function cfg_Item_decompose_runesManager:GetName()
  return "cfg_Item_decompose_runesManager"
end

function cfg_Item_decompose_runesManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_decompose_runes")
  end
  return self.dic
end

setmetatable(cfg_Item_decompose_runesManager, TableManagerBase)

function cfg_Item_decompose_runesManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_decompose_runesManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Item_decompose_runesManager
