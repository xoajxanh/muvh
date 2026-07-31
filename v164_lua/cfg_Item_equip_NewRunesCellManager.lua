local cfg_Item_equip_NewRunesCellManager = {}

function cfg_Item_equip_NewRunesCellManager:GetName()
  return "cfg_Item_equip_NewRunesCellManager"
end

function cfg_Item_equip_NewRunesCellManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_NewRunesCell")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_NewRunesCellManager, TableManagerBase)

function cfg_Item_equip_NewRunesCellManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_NewRunesCellManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Item_equip_NewRunesCellManager:GetCurHoleCfg(index, level)
  local dic = self:GetDic()
  for i, v in pairs(dic) do
    if tonumber(v.equipPositionSet) == index and v.level == level then
      return v
    end
  end
  return nil
end

function cfg_Item_equip_NewRunesCellManager:GetCurCanInlayMaxRunesLevel(index, level)
  local dic = self:GetDic()
  for i, v in pairs(dic) do
    if tonumber(v.equipPositionSet) == index and v.level == level then
      return v.runesLevel
    end
  end
  return 0
end

function cfg_Item_equip_NewRunesCellManager:GetNextCanInlayRuneLevelNeedHoleLevel(index, runesLevel)
  if not table.isNullOrEmpty(self.allInlayRuneLevelNeedHoleLevelTbl) then
    return self.allInlayRuneLevelNeedHoleLevelTbl[index] and (self.allInlayRuneLevelNeedHoleLevelTbl[index][runesLevel] or 9999) or 9999
  end
  self.allInlayRuneLevelNeedHoleLevelTbl = {}
  local dic = self:GetDic()
  for i, v in ipairs(dic) do
    if self.allInlayRuneLevelNeedHoleLevelTbl[tonumber(v.equipPositionSet)] == nil then
      self.allInlayRuneLevelNeedHoleLevelTbl[tonumber(v.equipPositionSet)] = {}
    end
    if self.allInlayRuneLevelNeedHoleLevelTbl[tonumber(v.equipPositionSet)][v.runesLevel] == nil then
      self.allInlayRuneLevelNeedHoleLevelTbl[tonumber(v.equipPositionSet)][v.runesLevel] = v.level
    end
  end
  return self.allInlayRuneLevelNeedHoleLevelTbl[index] and (self.allInlayRuneLevelNeedHoleLevelTbl[index][runesLevel] or 9999) or 9999
end

function cfg_Item_equip_NewRunesCellManager:GetHoleMaxLevel(index)
  if not table.isNullOrEmpty(self.allHoleMaxLevelTbl) and self.allHoleMaxLevelTbl[index] then
    return self.allHoleMaxLevelTbl[index]
  end
  self.allHoleMaxLevelTbl = {}
  local dic = self:GetDic()
  for i, v in ipairs(dic) do
    if self.allHoleMaxLevelTbl[tonumber(v.equipPositionSet)] == nil or self.allHoleMaxLevelTbl[tonumber(v.equipPositionSet)] < v.level then
      self.allHoleMaxLevelTbl[tonumber(v.equipPositionSet)] = v.level
    end
  end
  return self.allHoleMaxLevelTbl[index]
end

return cfg_Item_equip_NewRunesCellManager
