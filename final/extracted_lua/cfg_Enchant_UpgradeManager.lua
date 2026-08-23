local cfg_Enchant_UpgradeManager = {}

function cfg_Enchant_UpgradeManager:GetName()
  return "cfg_Enchant_UpgradeManager"
end

function cfg_Enchant_UpgradeManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Enchant_Upgrade")
  end
  return self.dic
end

setmetatable(cfg_Enchant_UpgradeManager, TableManagerBase)

function cfg_Enchant_UpgradeManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Enchant_UpgradeManager:TryGetValueByEquipIndex(_equipIndex)
  if _equipIndex == nil then
    return nil
  end
  if self.cacheEquipIndexTab == nil then
    self.cacheEquipIndexTab = {}
    for k, v in pairs(self:GetDic()) do
      if self.cacheEquipIndexTab[tonumber(v.equipPosition)] == nil then
        self.cacheEquipIndexTab[tonumber(v.equipPosition)] = {}
      end
      table.insert(self.cacheEquipIndexTab[tonumber(v.equipPosition)], v)
    end
  end
  return self.cacheEquipIndexTab[_equipIndex]
end

function cfg_Enchant_UpgradeManager:TryGetPointIdByEquipIndexPointGrade(_equipIndex, _pointGrade)
  local equipIndexTab = self:TryGetValueByEquipIndex(_equipIndex)
  if equipIndexTab == nil then
    return nil
  end
  for i, v in ipairs(equipIndexTab) do
    if v.pointGrade == _pointGrade then
      return v.pointId
    end
  end
  return nil
end

function cfg_Enchant_UpgradeManager:TryGetConfigByEquipIndexPointGradePointId(_equipIndex, _pointId, _pointGrade)
  if _equipIndex == nil or _pointId == nil or _pointGrade == nil then
    return nil
  end
  local equipIndexTab = self:TryGetValueByEquipIndex(_equipIndex)
  if equipIndexTab == nil then
    return nil
  end
  for i, v in ipairs(equipIndexTab) do
    if v.pointId == _pointId and v.pointGrade == _pointGrade then
      return v
    end
  end
  return nil
end

function cfg_Enchant_UpgradeManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

return cfg_Enchant_UpgradeManager
