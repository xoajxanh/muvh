local cfg_Commerce_pandoraManager = {}

function cfg_Commerce_pandoraManager:GetName()
  return "cfg_Commerce_pandoraManager"
end

function cfg_Commerce_pandoraManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_pandora")
  end
  return self.dic
end

setmetatable(cfg_Commerce_pandoraManager, TableManagerBase)

function cfg_Commerce_pandoraManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_pandoraManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_pandoraManager
