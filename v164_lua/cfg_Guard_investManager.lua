local cfg_Guard_investManager = {}

function cfg_Guard_investManager:GetName()
  return "cfg_Guard_investManager"
end

function cfg_Guard_investManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Guard_invest")
  end
  return self.dic
end

setmetatable(cfg_Guard_investManager, TableManagerBase)

function cfg_Guard_investManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Guard_investManager:GetTabByType(_type)
  local tabs = {}
  for index, value in pairs(self:GetDic()) do
    if value.type == _type then
      table.insert(tabs, value)
    end
  end
  table.sort(tabs, function(a, b)
    if a.id and b.id then
      return a.id < b.id
    else
      return false
    end
  end)
  return tabs
end

function cfg_Guard_investManager:GetAllTabType()
  local tabs = {}
  for index, value in pairs(self:GetDic()) do
    if value.condition == nil or value.condition == "" then
      table.insert(tabs, value)
    end
  end
  table.sort(tabs, function(a, b)
    if a.id and b.id then
      return a.id < b.id
    else
      return false
    end
  end)
  return tabs
end

return cfg_Guard_investManager
