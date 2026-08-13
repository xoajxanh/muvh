local cfg_Ring_rgbManager = {}

function cfg_Ring_rgbManager:GetName()
  return "cfg_Ring_rgbManager"
end

function cfg_Ring_rgbManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Ring_rgb")
  end
  return self.dic
end

setmetatable(cfg_Ring_rgbManager, TableManagerBase)

function cfg_Ring_rgbManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Ring_rgbManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Ring_rgbManager
