local cfg_Item_equip_runesSuitManager = {}
cfg_Item_equip_runesSuitManager.suitTab = {}

function cfg_Item_equip_runesSuitManager:GetName()
  return "cfg_Item_equip_runesSuitManager"
end

function cfg_Item_equip_runesSuitManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_runesSuit")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_runesSuitManager, TableManagerBase)

function cfg_Item_equip_runesSuitManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_runesSuitManager:GetRuneSuitCfg(equipIndex)
  if self.suitTab[equipIndex] == nil then
    self.suitTab[equipIndex] = {}
    for id, itemCfg in ipairs(self:GetDic()) do
      for index, itemEquipIndex in pairs(string.split(itemCfg.equipPositionSet, "#")) do
        if tonumber(itemEquipIndex) == equipIndex then
          table.insert(self.suitTab[equipIndex], itemCfg)
        end
      end
    end
  end
  return self.suitTab[equipIndex]
end

function cfg_Item_equip_runesSuitManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Item_equip_runesSuitManager
