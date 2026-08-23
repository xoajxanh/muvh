local cfg_Activity_rank_duoqiManager = {}

function cfg_Activity_rank_duoqiManager:GetName()
  return "cfg_Activity_rank_duoqiManager"
end

function cfg_Activity_rank_duoqiManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Activity_rank_duoqi")
  end
  return self.dic
end

setmetatable(cfg_Activity_rank_duoqiManager, TableManagerBase)

function cfg_Activity_rank_duoqiManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Activity_rank_duoqiManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Activity_rank_duoqiManager
