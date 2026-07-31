local cfg_Login_Welcome_NewManager = {}

function cfg_Login_Welcome_NewManager:GetName()
  return "cfg_Login_Welcome_NewManager"
end

function cfg_Login_Welcome_NewManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Login_Welcome_New")
  end
  return self.dic
end

setmetatable(cfg_Login_Welcome_NewManager, TableManagerBase)

function cfg_Login_Welcome_NewManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Login_Welcome_NewManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Login_Welcome_NewManager:GetTblByIdAndCondition(id)
  if type(id) ~= "number" then
    return
  end
  local tbl = self:TryGetValue(id)
  if type(tbl) ~= "table" then
    return nil
  end
  if type(tbl.condition) ~= "table" or ConditionManager.Check4D(tbl.condition) then
    return tbl
  end
end

return cfg_Login_Welcome_NewManager
