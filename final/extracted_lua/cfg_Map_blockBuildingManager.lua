local cfg_Map_blockBuildingManager = {}

function cfg_Map_blockBuildingManager:GetName()
  return "cfg_Map_blockBuildingManager"
end

function cfg_Map_blockBuildingManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_blockBuilding")
  end
  return self.dic
end

setmetatable(cfg_Map_blockBuildingManager, TableManagerBase)

function cfg_Map_blockBuildingManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Map_blockBuildingManager
