local cfg_Monster_dimensionBornManager = {}

function cfg_Monster_dimensionBornManager:GetName()
  return "cfg_Monster_dimensionBornManager"
end

function cfg_Monster_dimensionBornManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Monster_dimensionBorn")
  end
  return self.dic
end

setmetatable(cfg_Monster_dimensionBornManager, TableManagerBase)

function cfg_Monster_dimensionBornManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Monster_dimensionBornManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Monster_dimensionBornManager
