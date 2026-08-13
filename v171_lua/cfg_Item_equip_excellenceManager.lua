local cfg_Item_equip_excellenceManager = {}

function cfg_Item_equip_excellenceManager:GetName()
  return "cfg_Item_equip_excellenceManager"
end

function cfg_Item_equip_excellenceManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Item_equip_excellence")
  end
  return self.dic
end

setmetatable(cfg_Item_equip_excellenceManager, TableManagerBase)

function cfg_Item_equip_excellenceManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Item_equip_excellenceManager:GetExcellenceTypeById(id)
  if self.mExcellenceTypeDic == nil then
    self:InitalizeExcellenceType()
  end
  return self.mExcellenceTypeDic[id]
end

function cfg_Item_equip_excellenceManager:InitalizeExcellenceType()
  self.mExcellenceTypeDic = {}
  for i, v in pairs(self:GetDic()) do
    self.mExcellenceTypeDic[i] = v.attributeType
  end
end

function cfg_Item_equip_excellenceManager:GetExcellentAttributeViewInfo(id, targetId)
  local excellenceTbl = self:TryGetValue(id)
  local targetExcellenceTbl = self:TryGetValue(targetId)
  local attributeViewTemp, type, ratio, curValue, targetValue, curValueShow, targetValueShow, curCount, targetCount
  curCount = excellenceTbl ~= nil and table.count(excellenceTbl) or 0
  targetCount = targetExcellenceTbl ~= nil and table.count(targetExcellenceTbl) or 0
  local forTbl = curCount > targetCount and excellenceTbl or targetExcellenceTbl
  for i, v in pairs(forTbl) do
    if v ~= nil and v ~= 0 and RoleEquipUtility.GetExcellenceTbl(i) ~= nil then
      attributeViewTemp = {}
      attributeViewTemp.name = AttributeWordUtil.GetUIWord(i, "attributeUI")
      type = RoleEquipUtility.GetExcellenceTbl(i)
      ratio = type == "tTRatio" and "%" or ""
      curValue = excellenceTbl == nil and 0 or self:GetAttributeValue(excellenceTbl[i], type)
      targetValue = targetExcellenceTbl == nil and "" or self:GetAttributeValue(targetExcellenceTbl[i], type)
      curValueShow = excellenceTbl and excellenceTbl[tostring(i) .. "_Show"] or nil
      targetValueShow = targetExcellenceTbl and targetExcellenceTbl[tostring(i) .. "_Show"] or nil
      attributeViewTemp.curValue = string.isNullOrEmpty(curValueShow) and tostring(curValue) .. ratio or curValueShow
      attributeViewTemp.nextValue = string.isNullOrEmpty(targetValueShow) and tostring(targetValue) .. ratio or targetValueShow
      attributeViewTemp.nextIsNil = string.isNullOrEmpty(attributeViewTemp.nextValue) or attributeViewTemp.nextValue == ratio
      attributeViewTemp.isUp = curValue ~= targetValue
      break
    end
  end
  return attributeViewTemp
end

function cfg_Item_equip_excellenceManager:GetAttributeValue(num, type)
  if num == nil or num == 0 then
    return 0
  end
  if type == "tTRatio" then
    return math.floor(num * 0.01)
  elseif type == "fixed" then
    num = 1 / num * 10000
    return math.floor(num + 0.5)
  end
  return num
end

return cfg_Item_equip_excellenceManager
