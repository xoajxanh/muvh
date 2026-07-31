local cfg_Commerce_ConnectionGiftManager = {}

function cfg_Commerce_ConnectionGiftManager:GetName()
  return "cfg_Commerce_ConnectionGiftManager"
end

function cfg_Commerce_ConnectionGiftManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_ConnectionGift")
  end
  return self.dic
end

setmetatable(cfg_Commerce_ConnectionGiftManager, TableManagerBase)

function cfg_Commerce_ConnectionGiftManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_ConnectionGiftManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Commerce_ConnectionGiftManager
