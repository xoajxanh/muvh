local cfg_Runes_inlayManager = {}
cfg_Runes_inlayManager.CfgTab = {}

function cfg_Runes_inlayManager:GetName()
  return "cfg_Runes_inlayManager"
end

function cfg_Runes_inlayManager:GetDic()
  if self.dic == nil then
    self.dic = require("Config/table/clientTable/cfg_Runes_inlay")
  end
  return self.dic
end

setmetatable(cfg_Runes_inlayManager, TableManagerBase)

function cfg_Runes_inlayManager:TryGetValue(id, key)
  return self:BaseTryGetValue(id, key)
end

function cfg_Runes_inlayManager:GetTabListByType(type, typeKey)
  return self:BaseGetTabListByType(type, typeKey)
end

function cfg_Runes_inlayManager:GetItemCfgData(id)
  if id then
    if self.CfgTab[id] == nil then
      self.CfgTab[id] = self:TryGetValue(id)
    end
    return self.CfgTab[id]
  end
end

function cfg_Runes_inlayManager:GetRuneType(id)
  if id and self:GetItemCfgData(id) then
    return self:GetItemCfgData(id).type
  end
end

function cfg_Runes_inlayManager:TryGetRuneName(type, level)
  for i, v in pairs(self:GetDic()) do
    if v.type == type and v.runesStage == level then
      return v.runesName
    end
  end
  return ""
end

function cfg_Runes_inlayManager:JudgeCanSetByEquipIndex(id, equipIndex)
  local tab = self:GetItemCfgData(id)
  if tab and not string.isNullOrEmpty(tab.equipPosition) then
    local equipPosTab = string.split(tab.equipPosition, "#")
    for i, v in pairs(equipPosTab) do
      if tonumber(v) == equipIndex then
        return true
      end
    end
  end
  return false
end

return cfg_Runes_inlayManager
