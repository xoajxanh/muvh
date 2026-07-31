local cfg_Preference_preferenceManager = {}

function cfg_Preference_preferenceManager:GetName()
  return "cfg_Preference_preferenceManager"
end

function cfg_Preference_preferenceManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Preference_preference")
  end
  return self.dic
end

setmetatable(cfg_Preference_preferenceManager, TableManagerBase)

function cfg_Preference_preferenceManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Preference_preferenceManager
