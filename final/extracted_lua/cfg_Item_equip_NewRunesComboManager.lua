local cfg_Item_equip_NewRunesComboManager = {}

function cfg_Item_equip_NewRunesComboManager:GetName()
  return "cfg_Item_equip_NewRunesComboManager"
end

function cfg_Item_equip_NewRunesComboManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_NewRunesCombo")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_NewRunesComboManager, TableManagerBase)

function cfg_Item_equip_NewRunesComboManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_NewRunesComboManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_NewRunesComboManager:GetRuneCellByRunesSuitEffect(runesSuitEffect)
  if runesSuitEffect == nil then
    return
  end
  if self.runeCellList == nil then
    self.runeCellList = {}
  end
  if self.runeCellList[runesSuitEffect] == nil then
    local dic = self:GetDic()
    for i, v in pairs(dic) do
      if self.runeCellList[tonumber(v.runesSuitEffect)] == nil then
        self.runeCellList[tonumber(v.runesSuitEffect)] = v.runesCell
      end
    end
  end
  return self.runeCellList[runesSuitEffect]
end

return cfg_Item_equip_NewRunesComboManager
