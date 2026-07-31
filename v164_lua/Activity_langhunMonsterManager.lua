local Activity_langhunMonsterManager = {}

function Activity_langhunMonsterManager:GetName()
  return "Activity_langhunMonsterManager"
end

function Activity_langhunMonsterManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/Activity_langhunMonster")
  end
  return self.dic
end

setmetatable(Activity_langhunMonsterManager, TableManagerBase)

function Activity_langhunMonsterManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function Activity_langhunMonsterManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return Activity_langhunMonsterManager
