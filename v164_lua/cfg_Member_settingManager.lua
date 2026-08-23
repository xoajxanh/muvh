local cfg_Member_settingManager = {}

function cfg_Member_settingManager:GetName()
  return "cfg_Member_settingManager"
end

function cfg_Member_settingManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Member_setting")
  end
  return self.dic
end

setmetatable(cfg_Member_settingManager, TableManagerBase)

function cfg_Member_settingManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Member_settingManager
