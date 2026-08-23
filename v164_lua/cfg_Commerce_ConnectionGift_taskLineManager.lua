local cfg_Commerce_ConnectionGift_taskLineManager = {}

function cfg_Commerce_ConnectionGift_taskLineManager:GetName()
  return "cfg_Commerce_ConnectionGift_taskLineManager"
end

function cfg_Commerce_ConnectionGift_taskLineManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_ConnectionGift_taskLine")
  end
  return self.dic
end

setmetatable(cfg_Commerce_ConnectionGift_taskLineManager, TableManagerBase)

function cfg_Commerce_ConnectionGift_taskLineManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_ConnectionGift_taskLineManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_ConnectionGift_taskLineManager
