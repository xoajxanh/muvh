local cfg_Map_instanceManager = {}

function cfg_Map_instanceManager:GetName()
  return "cfg_Map_instanceManager"
end

function cfg_Map_instanceManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_instance")
  end
  return self.dic
end

setmetatable(cfg_Map_instanceManager, TableManagerBase)

function cfg_Map_instanceManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_instanceManager:TryGetTypeByMapId(mapId)
  local tbl = self:TryGetValue(mapId)
  if tbl then
    return tbl.type
  end
  return nil
end

return cfg_Map_instanceManager
