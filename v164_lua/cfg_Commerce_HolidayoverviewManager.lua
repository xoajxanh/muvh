local cfg_Commerce_HolidayoverviewManager = {}

function cfg_Commerce_HolidayoverviewManager:GetName()
  return "cfg_Commerce_HolidayoverviewManager"
end

function cfg_Commerce_HolidayoverviewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_Holidayoverview")
  end
  return self.dic
end

setmetatable(cfg_Commerce_HolidayoverviewManager, TableManagerBase)

function cfg_Commerce_HolidayoverviewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_HolidayoverviewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_HolidayoverviewManager
