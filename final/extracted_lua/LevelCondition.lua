LevelCondition = class(ConditionBase)
setgetters(LevelCondition, {
  data = function(self)
    return ViewData.meData
  end
})
LevelCondition.comparatorMap = {
  [0] = function(self)
    return self.data.level > self.targetLevel
  end,
  [1] = function(self)
    return self.data.level >= self.targetLevel
  end,
  [2] = function(self)
    return self.data.level == self.targetLevel
  end,
  [3] = function(self)
    return self.data.level <= self.targetLevel
  end,
  [4] = function(self)
    return self.data.level < self.targetLevel
  end,
  [5] = function(self)
    return self.data.level ~= self.targetLevel
  end,
  [10] = function(self)
    local equipData = self.data.equipsData:GetEquipByIndex(ERoleEquipPosition.vipIndex)
    if equipData then
      return equipData.tblItem.quality >= self.targetLevel
    end
    return false
  end,
  [11] = function(self)
    local equipData = self.data.equipsData:GetEquipByIndex(ERoleEquipPosition.vipIndex)
    if equipData then
      local vipTab = ClientTable.cfg_Vip_vipManager:TryGetValue(equipData.itemId, "id")
      return vipTab ~= nil and vipTab.badgeLevel >= self.targetLevel
    end
    return false
  end
}

function LevelCondition:InitParam(param)
  self.targetLevel = tonumber(param)
end
