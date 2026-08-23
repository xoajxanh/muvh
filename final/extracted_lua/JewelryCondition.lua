JewelryCondition = class(ConditionBase)
setgetters(JewelryCondition, {
  jewelryTotalLevel = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():GetTotalLevel()
  end,
  necklaceTotalLevel = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():GetJewelryTotalLvByType(EItemSubtype.Necklace)
  end,
  earringsTotalLevel = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():GetJewelryTotalLvByType(EItemSubtype.Earrings)
  end,
  ringTotalLevel = function(self)
    return gameMgr:GetAvatarManager():GetMainPlayer():GetEquipManager():GetJewelryData():GetJewelryTotalLvByType(EItemSubtype.Ring)
  end
})
JewelryCondition.comparatorMap = {
  [1] = function(self)
    return self.jewelryTotalLevel >= self.param
  end,
  [5] = function(self)
    return self.jewelryTotalLevel < self.param
  end,
  [2] = function(self)
    return self.necklaceTotalLevel >= self.param
  end,
  [3] = function(self)
    return self.earringsTotalLevel >= self.param
  end,
  [4] = function(self)
    return self.ringTotalLevel >= self.param
  end
}

function JewelryCondition:InitParam(param)
  self.param = tonumber(param)
end
