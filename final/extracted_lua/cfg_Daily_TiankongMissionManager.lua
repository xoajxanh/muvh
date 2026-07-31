local cfg_Daily_TiankongMissionManager = {}

function cfg_Daily_TiankongMissionManager:GetName()
  return "cfg_Daily_TiankongMissionManager"
end

function cfg_Daily_TiankongMissionManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Daily_TiankongMission")
  end
  return self.dic
end

setmetatable(cfg_Daily_TiankongMissionManager, TableManagerBase)

function cfg_Daily_TiankongMissionManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Daily_TiankongMissionManager
