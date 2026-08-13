local Activity_indexManager = {}

function Activity_indexManager:GetName()
  return "Activity_indexManager"
end

function Activity_indexManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Activity_index")
  end
  return self.dic
end

setmetatable(Activity_indexManager, TableManagerBase)

function Activity_indexManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Activity_indexManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Activity_indexManager
