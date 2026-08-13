local cfg_Item_equip_randomManager = {}

function cfg_Item_equip_randomManager:GetName()
  return "cfg_Item_equip_randomManager"
end

function cfg_Item_equip_randomManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_random")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_randomManager, TableManagerBase)

function cfg_Item_equip_randomManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_randomManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_randomManager:GetSelectCondition(id, subType)
  if subType == nil and id == nil then
    return
  end
  local randomStr
  for i, v in pairs(self:GetDic()) do
    if v.id == id and v.transferId == subType then
      randomStr = v
    end
  end
  if randomStr then
    return randomStr
  end
  return
end

return cfg_Item_equip_randomManager
