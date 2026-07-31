local cfg_GMPanelManager = {}

function cfg_GMPanelManager:GetName()
  return "cfg_GMPanelManager"
end

function cfg_GMPanelManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_GMPanel")
  end
  return self.dic
end

setmetatable(cfg_GMPanelManager, TableManagerBase)

function cfg_GMPanelManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_GMPanelManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_GMPanelManager
