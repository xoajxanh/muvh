local cfg_Commerce_goldenboxManager = {}

function cfg_Commerce_goldenboxManager:GetName()
  return "cfg_Commerce_goldenboxManager"
end

function cfg_Commerce_goldenboxManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_goldenbox")
  end
  return self.dic
end

setmetatable(cfg_Commerce_goldenboxManager, TableManagerBase)

function cfg_Commerce_goldenboxManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_goldenboxManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Commerce_goldenboxManager:GetTabListByIdAndCondition(useItemId)
  if type(useItemId) ~= "number" then
    return
  end
  local tblList = {}
  for i, tbl in pairs(self:GetDic()) do
    if tbl.useItemId == useItemId and (type(tbl.condition) ~= "table" or ConditionManager.Check4D(tbl.condition)) then
      table.insert(tblList, tbl)
    end
  end
  return tblList
end

return cfg_Commerce_goldenboxManager
