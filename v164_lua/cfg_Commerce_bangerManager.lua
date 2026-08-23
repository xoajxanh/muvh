local cfg_Commerce_bangerManager = {}

function cfg_Commerce_bangerManager:GetName()
  return "cfg_Commerce_bangerManager"
end

function cfg_Commerce_bangerManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_banger")
  end
  return self.dic
end

setmetatable(cfg_Commerce_bangerManager, TableManagerBase)

function cfg_Commerce_bangerManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_bangerManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Commerce_bangerManager:GetTblDataById(id)
  if id == nil then
    return {}
  end
  return self:TryGetValue(id, "id") or {}
end

function cfg_Commerce_bangerManager:GetDrawableRewards()
  if self.drawableRewards == nil then
    self.drawableRewards = {}
    for i, v in pairs(self:GetDic()) do
      if v.type == RewardsTypeEnum.DrawableRewards then
        table.insert(self.drawableRewards, v)
      end
    end
  end
  return self.drawableRewards
end

function cfg_Commerce_bangerManager:GetCumulativeRewards()
  if self.cumulativeRewards == nil then
    self.cumulativeRewards = {}
    for i, v in pairs(self:GetDic()) do
      if v.type == RewardsTypeEnum.CumulativeRewards then
        table.insert(self.cumulativeRewards, v)
      end
    end
  end
  return self.cumulativeRewards
end

return cfg_Commerce_bangerManager
