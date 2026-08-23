local cfg_Map_headSculptureManager = {}

function cfg_Map_headSculptureManager:GetName()
  return "cfg_Map_headSculptureManager"
end

function cfg_Map_headSculptureManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Map_headSculpture")
  end
  return self.dic
end

setmetatable(cfg_Map_headSculptureManager, TableManagerBase)

function cfg_Map_headSculptureManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Map_headSculptureManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Map_headSculptureManager
