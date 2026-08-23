local cfg_Monster_dimensionsetManager = {}

function cfg_Monster_dimensionsetManager:GetName()
  return "cfg_Monster_dimensionsetManager"
end

function cfg_Monster_dimensionsetManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_dimensionset")
  end
  return self.dic
end

setmetatable(cfg_Monster_dimensionsetManager, TableManagerBase)

function cfg_Monster_dimensionsetManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Monster_dimensionsetManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Monster_dimensionsetManager
