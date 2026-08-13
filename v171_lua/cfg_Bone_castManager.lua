local cfg_Bone_castManager = {}

function cfg_Bone_castManager:GetName()
  return "cfg_Bone_castManager"
end

function cfg_Bone_castManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Bone_cast")
  end
  return self.dic
end

setmetatable(cfg_Bone_castManager, TableManagerBase)

function cfg_Bone_castManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Bone_castManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Bone_castManager:BoneCastAttribute(position, grade)
  local hole = 0
  if not position and not grade then
    return
  end
  for i, v in pairs(self:GetDic()) do
    if v.position == position and v.grade == grade then
      hole = v.hole
      return hole
    end
  end
  return hole
end

function cfg_Bone_castManager:GetConfigByTypeAndId(position, grade)
  if string.isNullOrEmpty(position) or string.isNullOrEmpty(grade) then
    return
  end
  if self.configDataTab == nil then
    self.configDataTab = {}
  end
  if self.configDataTab[position] == nil then
    for index, itemCfg in pairs(self:GetDic()) do
      if self.configDataTab[itemCfg.position] == nil then
        self.configDataTab[itemCfg.position] = {}
      end
      self.configDataTab[itemCfg.position][itemCfg.grade] = itemCfg
    end
  end
  return self.configDataTab[position][grade]
end

function cfg_Bone_castManager:GetUnlockGradeByTypeAndHole(holeIndex)
  if self.UnlockTab == nil then
    self.UnlockTab = {}
  end
  if self.UnlockTab[holeIndex] == nil then
    local effect = GlobalConfig.GetGlobalConfig(2800018)
    local splitTab = string.split(effect, "&")
    for i, v in pairs(splitTab) do
      local item = string.split(v, "#")
      self.UnlockTab[tonumber(item[2])] = tonumber(item[1])
    end
  end
  return self.UnlockTab[holeIndex]
end

return cfg_Bone_castManager
