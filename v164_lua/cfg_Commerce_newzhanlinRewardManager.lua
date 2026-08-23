local cfg_Commerce_newzhanlinRewardManager = {}

function cfg_Commerce_newzhanlinRewardManager:GetName()
  return "cfg_Commerce_newzhanlinRewardManager"
end

function cfg_Commerce_newzhanlinRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_newzhanlinReward")
  end
  return self.dic
end

setmetatable(cfg_Commerce_newzhanlinRewardManager, TableManagerBase)

function cfg_Commerce_newzhanlinRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_newzhanlinRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_newzhanlinRewardManager
