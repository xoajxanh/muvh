local cfg_Item_class_settingManager = {}

function cfg_Item_class_settingManager:GetName()
  return "cfg_Item_class_settingManager"
end

function cfg_Item_class_settingManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_class_setting")
  end
  return self.dic
end

setmetatable(cfg_Item_class_settingManager, TableManagerBase)

function cfg_Item_class_settingManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_class_settingManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_class_settingManager:GetRingTypeNameByRingType(ringType)
  if ringType == nil then
    return ""
  end
  local dic = self:TryGetValue(tonumber(ringType), "id")
  return dic and dic.ringName or ""
end

return cfg_Item_class_settingManager
