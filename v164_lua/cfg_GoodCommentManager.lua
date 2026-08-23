local cfg_GoodCommentManager = {}

function cfg_GoodCommentManager:GetName()
  return "cfg_GoodCommentManager"
end

function cfg_GoodCommentManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_GoodComment")
  end
  return self.dic
end

setmetatable(cfg_GoodCommentManager, TableManagerBase)

function cfg_GoodCommentManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_GoodCommentManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_GoodCommentManager
