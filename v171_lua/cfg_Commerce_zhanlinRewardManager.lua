local cfg_Commerce_zhanlinRewardManager = {}

function cfg_Commerce_zhanlinRewardManager:GetName()
  return "cfg_Commerce_zhanlinRewardManager"
end

function cfg_Commerce_zhanlinRewardManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_zhanlinReward")
  end
  return self.dic
end

setmetatable(cfg_Commerce_zhanlinRewardManager, TableManagerBase)

function cfg_Commerce_zhanlinRewardManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_zhanlinRewardManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Commerce_zhanlinRewardManager:GetNextExpByLevel(curLevel)
  local nextLevel = 0
  if curLevel then
    nextLevel = curLevel + 1
  end
  local tbl = self:BaseTryGetValue(nextLevel, "level")
  if tbl then
    return tbl.count
  end
  return nil
end

return cfg_Commerce_zhanlinRewardManager
