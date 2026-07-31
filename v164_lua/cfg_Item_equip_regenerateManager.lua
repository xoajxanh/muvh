local cfg_Item_equip_regenerateManager = {}

function cfg_Item_equip_regenerateManager:GetName()
  return "cfg_Item_equip_regenerateManager"
end

function cfg_Item_equip_regenerateManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_regenerate")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_regenerateManager, TableManagerBase)

function cfg_Item_equip_regenerateManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_regenerateManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_regenerateManager:GetKeyWord(id, key)
  local wordTbl = self:TryGetValue(id)
  if wordTbl == nil then
    logError(id .. "Item_equip_regenerate tr\225\187\145ng")
    return
  end
  local wordTypeStr = wordTbl[key]
  if wordTypeStr then
    return wordTypeStr
  end
end

function cfg_Item_equip_regenerateManager:GetExcellentLevel(id)
  local wordTbl = self:GetDic()
  if wordTbl == nil then
    logError(id .. "Item_equip_regenerate tr\225\187\145ng")
    return
  end
  local wordTypeStr = wordTbl[id].excellentLevel
  if wordTypeStr then
    return wordTypeStr
  end
end

return cfg_Item_equip_regenerateManager
