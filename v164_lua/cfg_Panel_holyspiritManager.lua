local cfg_Panel_holyspiritManager = {}

function cfg_Panel_holyspiritManager:GetName()
  return "cfg_Panel_holyspiritManager"
end

function cfg_Panel_holyspiritManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Panel_holyspirit")
  end
  return self.dic
end

setmetatable(cfg_Panel_holyspiritManager, TableManagerBase)

function cfg_Panel_holyspiritManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Panel_holyspiritManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Panel_holyspiritManager
