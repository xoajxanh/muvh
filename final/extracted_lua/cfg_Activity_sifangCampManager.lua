local cfg_Activity_sifangCampManager = {}

function cfg_Activity_sifangCampManager:GetName()
  return "cfg_Activity_sifangCampManager"
end

function cfg_Activity_sifangCampManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_sifangCamp")
  end
  return self.dic
end

setmetatable(cfg_Activity_sifangCampManager, TableManagerBase)

function cfg_Activity_sifangCampManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Activity_sifangCampManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Activity_sifangCampManager
