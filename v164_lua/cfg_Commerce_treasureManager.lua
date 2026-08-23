local cfg_Commerce_treasureManager = {}

function cfg_Commerce_treasureManager:GetName()
  return "cfg_Commerce_treasureManager"
end

function cfg_Commerce_treasureManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Commerce_treasure")
  end
  return self.dic
end

setmetatable(cfg_Commerce_treasureManager, TableManagerBase)

function cfg_Commerce_treasureManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Commerce_treasureManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Commerce_treasureManager:GetTurntableItemInfoList()
  if self.turntableItemInfoList == nil then
    self.turntableItemInfoList = {}
    for i, v in pairs(self:GetDic()) do
      if v.type == TurntableItemTypeEnum.Ordinary or v.type == TurntableItemTypeEnum.Rare then
        table.insert(self.turntableItemInfoList, v)
      end
    end
  end
  return self.turntableItemInfoList
end

function cfg_Commerce_treasureManager:GetItemInfoName(Id)
  local Itemname
  for i, v in pairs(self:GetDic()) do
    if v.id == Id then
      Itemname = v.name
      return Itemname
    end
  end
  return Itemname
end

function cfg_Commerce_treasureManager:GetGiftPropInfoList()
  if self.giftPropInfoList == nil then
    self.giftPropInfoList = {}
    for i, v in pairs(self:GetDic()) do
      if v.type == TurntableItemTypeEnum.GiftProp then
        table.insert(self.giftPropInfoList, v)
      end
    end
  end
  return self.giftPropInfoList
end

function cfg_Commerce_treasureManager:GetMaxLuckyValue()
  for i, v in pairs(self:GetDic()) do
    if v.type == TurntableItemTypeEnum.Rare and v.condition and ConditionManager.Check4D(v.condition) then
      return v.space
    end
  end
  return 0
end

return cfg_Commerce_treasureManager
