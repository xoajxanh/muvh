local cfg_MasterSkill_levelManager = {}

function cfg_MasterSkill_levelManager:GetName()
  return "cfg_MasterSkill_levelManager"
end

function cfg_MasterSkill_levelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_MasterSkill_level")
  end
  return self.dic
end

setmetatable(cfg_MasterSkill_levelManager, TableManagerBase)

function cfg_MasterSkill_levelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_MasterSkill_levelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_MasterSkill_levelManager:GetMaxLevel()
  if self.maxLevel == nil then
    self:InitAllConfig()
  end
  return self.maxLevel
end

function cfg_MasterSkill_levelManager:InitalizeParam()
  self.maxLevel = 0
end

function cfg_MasterSkill_levelManager:InitAllConfig()
  self:InitalizeParam()
  for i, v in pairs(self:GetDic()) do
    if self.maxLevel == nil or i > self.maxLevel then
      self.maxLevel = i
    end
  end
end

return cfg_MasterSkill_levelManager
