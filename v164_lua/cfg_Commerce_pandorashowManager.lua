local cfg_Commerce_pandorashowManager = {}

function cfg_Commerce_pandorashowManager:GetName()
  return "cfg_Commerce_pandorashowManager"
end

function cfg_Commerce_pandorashowManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_pandorashow")
  end
  return self.dic
end

setmetatable(cfg_Commerce_pandorashowManager, TableManagerBase)

function cfg_Commerce_pandorashowManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_pandorashowManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_pandorashowManager
