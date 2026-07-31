local cfg_Duoqi_point_rangeManager = {}

function cfg_Duoqi_point_rangeManager:GetName()
  return "cfg_Duoqi_point_rangeManager"
end

function cfg_Duoqi_point_rangeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Duoqi_point_range")
  end
  return self.dic
end

setmetatable(cfg_Duoqi_point_rangeManager, TableManagerBase)

function cfg_Duoqi_point_rangeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Duoqi_point_rangeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Duoqi_point_rangeManager
