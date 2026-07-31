local cfg_Npc_npcManager = {}

function cfg_Npc_npcManager:GetName()
  return "cfg_Npc_npcManager"
end

function cfg_Npc_npcManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Npc_npc")
  end
  return self.dic
end

setmetatable(cfg_Npc_npcManager, TableManagerBase)

function cfg_Npc_npcManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Npc_npcManager
