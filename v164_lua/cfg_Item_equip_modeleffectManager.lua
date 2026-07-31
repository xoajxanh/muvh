local cfg_Item_equip_modeleffectManager = {}

function cfg_Item_equip_modeleffectManager:GetName()
  return "cfg_Item_equip_modeleffectManager"
end

function cfg_Item_equip_modeleffectManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_modeleffect")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_modeleffectManager, TableManagerBase)

function cfg_Item_equip_modeleffectManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

return cfg_Item_equip_modeleffectManager
