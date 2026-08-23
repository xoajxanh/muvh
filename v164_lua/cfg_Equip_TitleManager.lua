local cfg_Equip_TitleManager = {}

function cfg_Equip_TitleManager:GetName()
  return "cfg_Equip_TitleManager"
end

function cfg_Equip_TitleManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Equip_Title")
  end
  return self.dic
end

setmetatable(cfg_Equip_TitleManager, TableManagerBase)

function cfg_Equip_TitleManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Equip_TitleManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Equip_TitleManager
