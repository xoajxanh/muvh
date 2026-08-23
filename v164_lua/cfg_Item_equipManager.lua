local cfg_Item_equipManager = {}

function cfg_Item_equipManager:GetName()
  return "cfg_Item_equipManager"
end

function cfg_Item_equipManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip")
  end
  return self.dic
end

setmetatable(cfg_Item_equipManager, TableManagerBase)

function cfg_Item_equipManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equipManager:GetItemEquipCellTbl(id)
  if type(id) ~= "number" then
    return
  end
  local equipItemTbl = self:TryGetValue(id)
  if equipItemTbl == nil then
    return
  end
  return ClientTable.cfg_EquipCell_cellManager:TryGetValue(tonumber(equipItemTbl.equipPosition))
end

function cfg_Item_equipManager:GetBasicAttributeViewInfoTbl(costomData)
  if costomData == nil then
    return nil
  end
  local curTbl = self:TryGetValue(costomData.itemId)
  local nextTbl = self:TryGetValue(costomData.targetItemId)
  local attrebuteTbl = {}
  local curValue = ""
  local nextValue = ""
  local curMaxValue = ""
  local nextMaxValue = ""
  curValue = curTbl ~= nil and curTbl.minimumPhysBaseDmg or 0
  curMaxValue = curTbl ~= nil and curTbl.maximumPhysBaseDmg or 0
  nextValue = nextTbl ~= nil and nextTbl.minimumPhysBaseDmg or 0
  nextMaxValue = nextTbl ~= nil and nextTbl.maximumPhysBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "T\225\186\165n c\195\180ng"
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.minimumWizBaseDmg or 0
  curMaxValue = curTbl ~= nil and curTbl.maximumWizBaseDmg or 0
  nextValue = nextTbl ~= nil and nextTbl.minimumWizBaseDmg or 0
  nextMaxValue = nextTbl ~= nil and nextTbl.maximumWizBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "C\195\180ng ph\195\169p"
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.minimumCurseBaseDmg or 0
  curMaxValue = curTbl ~= nil and curTbl.maximumCurseBaseDmg or 0
  nextValue = nextTbl ~= nil and nextTbl.minimumCurseBaseDmg or 0
  nextMaxValue = nextTbl ~= nil and nextTbl.maximumCurseBaseDmg or 0
  if curValue ~= 0 or curMaxValue ~= 0 or nextValue ~= 0 or nextMaxValue ~= 0 then
    local temp = {}
    temp.name = "T\225\186\165n C\195\180ng Nguy\225\187\129n R\225\187\167a "
    temp.curValue = tostring(curValue) .. "-" .. tostring(curMaxValue) or ""
    temp.nextValue = tostring(nextValue) .. "-" .. tostring(nextMaxValue) or ""
    temp.isUp = curMaxValue < nextMaxValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  curValue = curTbl ~= nil and curTbl.defenseBase or 0
  nextValue = nextTbl ~= nil and nextTbl.defenseBase or 0
  if curValue ~= 0 or nextValue ~= 0 then
    local temp = {}
    temp.name = "Ph\195\178ng Th\225\187\167"
    temp.curValue = tostring(curValue) or ""
    temp.nextValue = tostring(nextValue) or ""
    temp.isUp = curValue < nextValue
    temp.nextIsNil = nextTbl == nil
    table.insert(attrebuteTbl, temp)
  end
  return attrebuteTbl
end

function cfg_Item_equipManager:GetExcellentAttributeViewInfoTbl(costomData)
  if costomData == nil then
    return nil
  end
  local attrebuteTbl = {}
  local curTbl = self:TryGetValue(costomData.itemId)
  local nextTbl = self:TryGetValue(costomData.targetItemId)
  local excellenceTbl = {}
  local nextExcellenceTbl = {}
  if curTbl then
    excellenceTbl = TableParse:SplitStringToIntList(curTbl.createFixedExcellent, "#")
  end
  if nextTbl then
    nextExcellenceTbl = TableParse:SplitStringToIntList(nextTbl.createFixedExcellent, "#")
  end
  local id, attributeInfo, sameType
  if nextExcellenceTbl ~= nil and table.count(nextExcellenceTbl) > 0 then
    for i, v in pairs(nextExcellenceTbl) do
      id = 0
      for i2, v2 in pairs(excellenceTbl) do
        sameType = ClientTable.cfg_Item_equip_excellenceManager:GetExcellenceTypeById(v) == ClientTable.cfg_Item_equip_excellenceManager:GetExcellenceTypeById(v2)
        if sameType then
          id = v2
          break
        end
      end
      attributeInfo = ClientTable.cfg_Item_equip_excellenceManager:GetExcellentAttributeViewInfo(id, v)
      if attributeInfo then
        table.insert(attrebuteTbl, attributeInfo)
      end
    end
  else
    for i, v in pairs(excellenceTbl) do
      attributeInfo = ClientTable.cfg_Item_equip_excellenceManager:GetExcellentAttributeViewInfo(v, 0)
      if attributeInfo then
        table.insert(attrebuteTbl, attributeInfo)
      end
    end
  end
  return attrebuteTbl
end

function cfg_Item_equipManager:EquipCanXiLian(id)
  if type(id) ~= "number" then
    return false
  end
  local equipTbl = self:TryGetValue(id)
  if equipTbl == nil or string.isNullOrEmpty(equipTbl.equipPosition) then
    return false
  end
  local equipIndexList = string.split(equipTbl.equipPosition, "#")
  local equipIndex = tonumber(equipIndexList[1])
  local cellTbl = ClientTable.cfg_EquipCell_cellManager:TryGetValue(equipIndex)
  return cellTbl ~= nil and cellTbl.excellLimit == 1
end

return cfg_Item_equipManager
