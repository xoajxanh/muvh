local cfg_PVP_3v3_runeManager = {}

function cfg_PVP_3v3_runeManager:GetName()
  return "cfg_PVP_3v3_runeManager"
end

function cfg_PVP_3v3_runeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_PVP_3v3_rune")
  end
  return self.dic
end

setmetatable(cfg_PVP_3v3_runeManager, TableManagerBase)

function cfg_PVP_3v3_runeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_PVP_3v3_runeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_PVP_3v3_runeManager
